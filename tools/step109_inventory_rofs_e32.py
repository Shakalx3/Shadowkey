#!/usr/bin/env python3
"""Bounded structural inventory of E32 candidates extracted from N95 ROFS/ROFx.

This reads only the extracted local files produced by Step108. It never writes
back to firmware images and emits text metadata only.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import struct
import zlib
from collections import Counter
from pathlib import Path

DLL_UID = 0x10000079
EXE_UID = 0x1000007A
MAX_EXPORTS = 131072
MAX_DLL_REFS = 4096
MAX_IMPORTS = 1_000_000
DEFLATE_UID = 0x101F7AFC
BYTEPAIR_UID = 0x102822AA
MAX_DECOMPRESSED = 128 * 1024 * 1024

# E32 import formats from E32ImageHeader::iFlags.
IMPORT_FMT_MASK = 0xF0000000
IMPORT_FMT_PE = 0x00000000
IMPORT_FMT_ELF = 0x10000000
IMPORT_FMT_PE2 = 0x20000000
OLD_ELF_IMPORT_FLAG = 0x00000010
IMAGE_NAMED_EXPORT_DATA = 0x00000400


def bytepair_decompress(src: bytes, dst_size: int) -> bytes:
    if not src:
        raise ValueError("empty BytePair input")
    pos = 0
    num_tokens = src[pos]
    pos += 1
    marker = 0xFFFFFFFF
    lut0 = list(range(256))
    lut1 = list(range(256))
    if num_tokens:
        if pos >= len(src):
            raise ValueError("missing BytePair marker")
        marker = src[pos]
        pos += 1
        lut0[marker] = (~marker) & 0xFF
        if num_tokens < 32:
            if pos + num_tokens * 3 > len(src):
                raise ValueError("truncated BytePair token table")
            for _ in range(num_tokens):
                token, left, right = src[pos:pos + 3]
                pos += 3
                lut0[token] = left
                lut1[token] = right
        else:
            if pos + 32 > len(src):
                raise ValueError("truncated BytePair token mask")
            mask = src[pos:pos + 32]
            pos += 32
            remaining = num_tokens
            for token in range(256):
                if mask[token >> 3] & (1 << (token & 7)):
                    if pos + 2 > len(src):
                        raise ValueError("truncated BytePair token pair")
                    lut0[token] = src[pos]
                    lut1[token] = src[pos + 1]
                    pos += 2
                    remaining -= 1
            if remaining:
                raise ValueError("BytePair token count/mask mismatch")

    cache = {}
    active = set()

    def expand(token: int) -> bytes:
        if lut0[token] == token:
            return bytes((token,))
        if token in cache:
            return cache[token]
        if token in active or len(active) > 256:
            raise ValueError(f"recursive BytePair token 0x{token:02X}")
        active.add(token)
        value = expand(lut0[token]) + expand(lut1[token])
        active.remove(token)
        cache[token] = value
        return value

    out = bytearray()
    while pos < len(src) and len(out) < dst_size:
        token = src[pos]
        pos += 1
        if token == marker:
            if pos >= len(src):
                raise ValueError("truncated BytePair marker escape")
            out.append(src[pos])
            pos += 1
        else:
            out.extend(expand(token))
        if len(out) > dst_size:
            raise ValueError(f"BytePair output overflow: {len(out)} > {dst_size}")
    if len(out) != dst_size:
        raise ValueError(f"BytePair output short: {len(out)} != {dst_size}")
    if pos != len(src):
        raise ValueError(f"BytePair trailing input: {len(src) - pos} bytes")
    return bytes(out)


def inflate_e32(data: bytes) -> tuple[bytes, dict]:
    """Inflate an EKA2 V-format E32 image using its declared header size.

    Symbian's f32image.h defines iCodeOffset as both the code-section offset
    and total header size. iUncompressedSize at 0x7C is the byte count after
    that header, not a fixed 0x80-byte payload offset.
    """
    if len(data) < 0x80:
        raise ValueError("compressed E32 image is shorter than the compression header")
    compression = u32(data, 0x1C)
    flags = u32(data, 0x2C)
    header_format = (flags & 0x0F000000) >> 24
    header_size = u32(data, 0x64)
    declared = u32(data, 0x7C)
    if header_format != 2:
        raise ValueError(f"unsupported compressed E32 header format {header_format}; expected V-format 2")
    if header_size < 0x9C or header_size > len(data):
        raise ValueError(
            f"V-format iCodeOffset/header size outside file: 0x{header_size:X}"
        )
    export_desc_size = struct.unpack_from("<H", data, 0x98)[0]
    min_header_size = (0x9B + export_desc_size + 3) & ~3
    if header_size < min_header_size:
        raise ValueError(
            f"iCodeOffset 0x{header_size:X} truncates V-header export descriptor "
            f"(minimum 0x{min_header_size:X})"
        )
    if declared <= 0 or declared > MAX_DECOMPRESSED:
        raise ValueError(f"uncompressedSize outside safety limit: 0x{declared:X}")
    payload = data[header_size:]
    if compression == DEFLATE_UID:
        decoded = None
        failures = []
        for wbits in (zlib.MAX_WBITS, -zlib.MAX_WBITS):
            try:
                decoder = zlib.decompressobj(wbits)
                out = decoder.decompress(payload, MAX_DECOMPRESSED + 1)
                if len(out) > MAX_DECOMPRESSED or decoder.unconsumed_tail:
                    raise ValueError("Deflate output exceeds safety limit")
                out += decoder.flush()
                if len(out) > MAX_DECOMPRESSED:
                    raise ValueError("Deflate output exceeds safety limit")
                if not decoder.eof:
                    raise ValueError("Deflate stream did not reach EOF")
                if decoder.unused_data:
                    raise ValueError(f"Deflate stream has {len(decoder.unused_data)} trailing bytes")
                decoded = out
                break
            except (zlib.error, ValueError) as exc:
                failures.append(str(exc))
        if decoded is None:
            raise ValueError("Deflate decode failed: " + " | ".join(failures))
        algorithm = "deflate"
    elif compression == BYTEPAIR_UID:
        try:
            decoded = bytepair_decompress(payload, declared)
        except ValueError as exc:
            raise ValueError(f"BytePair decode failed: {exc}") from exc
        algorithm = "bytepair"
    else:
        raise ValueError(f"unsupported E32 compression UID 0x{compression:08X}")

    if len(decoded) != declared:
        raise ValueError(
            f"uncompressedSize mismatch: header=0x{declared:X}, decoded=0x{len(decoded):X}"
        )
    flat = bytearray(data[:header_size] + decoded)
    flat[0x1C:0x20] = b"\0\0\0\0"
    return bytes(flat), {
        "algorithm": algorithm,
        "header_format": header_format,
        "header_size": header_size,
        "declared_uncompressed_size": declared,
        "decoded_payload_size": len(decoded),
        "size_mode": "post-header-size",
    }


def u32(data: bytes, off: int) -> int:
    if off < 0 or off + 4 > len(data):
        raise ValueError(f"u32 outside file at 0x{off:X}")
    return struct.unpack_from("<I", data, off)[0]


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def parse_candidate(data: bytes, image: str, path: str) -> tuple[dict, list[dict], list[dict]]:
    row = {
        "image": image,
        "path": path,
        "size": len(data),
        "sha256": sha256(data),
        "status": "REJECTED",
        "reason": "",
        "uid1": "",
        "uid2": "",
        "uid3": "",
        "header_crc": "",
        "module_version": "",
        "tools_version": "",
        "entry_point": "",
        "data_base": "",
        "kind": "",
        "flags": "",
        "compression_type": "",
        "compression_header_hex": "",
        "compressed_payload_prefix_hex": "",
        "header_format": "",
        "header_size": 0,
        "compression_algorithm": "none",
        "uncompressed_size_field": 0,
        "decompression_size_mode": "",
        "decompressed": False,
        "flat_size": len(data),
        "code_base": "",
        "code_size": 0,
        "data_size": 0,
        "code_offset": 0,
        "data_offset": 0,
        "text_size": 0,
        "import_offset": 0,
        "import_size": 0,
        "code_reloc_offset": 0,
        "data_reloc_offset": 0,
        "export_dir_offset": 0,
        "export_count": 0,
        "valid_exports": 0,
        "zero_exports": 0,
        "invalid_exports": 0,
        "dll_ref_count": 0,
        "import_count": 0,
        "parsed_import_blocks": 0,
        "iat_matches": True,
        "import_trailing_bytes": 0,
        "import_format": "unknown",
        "named_lookup": "false",
        "export_address_mode": "relative",
    }
    exports: list[dict] = []
    imports: list[dict] = []
    if len(data) < 0x7C or data[0x10:0x14] != b"EPOC":
        row["reason"] = "missing EPOC signature or truncated 0x7C-byte header"
        return row, exports, imports

    uid1, uid2, uid3 = struct.unpack_from("<III", data, 0)
    row.update(uid1=f"0x{uid1:08X}", uid2=f"0x{uid2:08X}", uid3=f"0x{uid3:08X}")
    if uid1 not in (DLL_UID, EXE_UID):
        row["status"] = "MAGIC_ONLY"
        row["reason"] = f"EPOC marker with unsupported UID1 0x{uid1:08X}"
        return row, exports, imports
    row["kind"] = "DLL" if uid1 == DLL_UID else "EXE"

    original_compression = u32(data, 0x1C)
    row["compression_type"] = f"0x{original_compression:08X}"
    if len(data) >= 0x68:
        flags = u32(data, 0x2C)
        row["header_format"] = (flags & 0x0F000000) >> 24
        row["header_size"] = u32(data, 0x64)
        row["flags"] = f"0x{flags:08X}"
        row["code_offset"] = row["header_size"]
    if original_compression:
        # Preserve only header metadata and a short payload prefix; never emit module code.
        row["compression_header_hex"] = data[0x7C:min(len(data), 0xA0)].hex()
        row["uncompressed_size_field"] = u32(data, 0x7C) if len(data) >= 0x80 else 0
        header_size = row.get("header_size", 0)
        if 0 < header_size <= len(data):
            row["compressed_payload_prefix_hex"] = data[header_size:min(len(data), header_size + 0x40)].hex()
        try:
            data, inflation = inflate_e32(data)
        except (ValueError, zlib.error, struct.error) as exc:
            row["status"] = "COMPRESSED_UNDECODED"
            row["reason"] = str(exc)
            row["iat_matches"] = None
            row["compression_algorithm"] = {
                DEFLATE_UID: "deflate",
                BYTEPAIR_UID: "bytepair",
            }.get(original_compression, "unknown")
            return row, exports, imports
        row["compression_algorithm"] = inflation["algorithm"]
        row["header_format"] = inflation["header_format"]
        row["header_size"] = inflation["header_size"]
        row["uncompressed_size_field"] = inflation["declared_uncompressed_size"]
        row["decompression_size_mode"] = inflation["size_mode"]
        row["decompressed"] = True
        row["flat_size"] = len(data)

    try:
        fields = {
            "header_crc": u32(data, 0x14),
            "module_version": u32(data, 0x18),
            "tools_version": u32(data, 0x20),
            "flags": u32(data, 0x2C),
            "entry_point": u32(data, 0x48),
            "data_base": u32(data, 0x50),
            "code_size": u32(data, 0x30),
            "data_size": u32(data, 0x34),
            "dll_ref_count": u32(data, 0x54),
            "export_dir_offset": u32(data, 0x58),
            "export_count": u32(data, 0x5C),
            "text_size": u32(data, 0x60),
            "code_offset": u32(data, 0x64),
            "data_offset": u32(data, 0x68),
            "import_offset": u32(data, 0x6C),
            "code_reloc_offset": u32(data, 0x70),
            "data_reloc_offset": u32(data, 0x74),
            "code_base": u32(data, 0x4C),
            "compression_type": original_compression,
        }
        row.update(fields)
        for key in ("header_crc", "module_version", "tools_version", "flags", "compression_type", "code_base", "entry_point", "data_base"):
            row[key] = f"0x{row[key]:08X}"

        errors: list[str] = []
        warnings: list[str] = []
        code_off = fields["code_offset"]
        code_size = fields["code_size"]
        import_off = fields["import_offset"]
        export_off = fields["export_dir_offset"]
        export_count = fields["export_count"]
        text_size = fields["text_size"]
        dll_count = fields["dll_ref_count"]
        flags_value = fields["flags"]

        # EKA2 V-format images carry the import format in the high flag nibble.
        # Pre-V images use the historical ELF flag or the PE default.
        if row["header_format"]:
            import_format = flags_value & IMPORT_FMT_MASK
        else:
            import_format = IMPORT_FMT_ELF if flags_value & OLD_ELF_IMPORT_FLAG else IMPORT_FMT_PE
        import_format_name = {
            IMPORT_FMT_PE: "PE",
            IMPORT_FMT_ELF: "ELF",
            IMPORT_FMT_PE2: "PE2",
        }.get(import_format, f"UNKNOWN_0x{import_format:08X}")
        named_lookup = bool(flags_value & IMAGE_NAMED_EXPORT_DATA)
        row["import_format"] = import_format_name
        row["named_lookup"] = str(named_lookup).lower()
        row["export_address_mode"] = "absolute" if import_format == IMPORT_FMT_ELF else "relative"

        code_end = code_off + code_size
        data_end = 0
        if code_size == 0 or code_off < 0x7C or code_off > len(data):
            errors.append("code segment is empty or its offset is outside file")
        elif code_size > len(data) - code_off:
            errors.append("uncompressed code segment is outside file")
        if text_size > code_size:
            errors.append("text size exceeds code size")
        if fields["data_size"]:
            data_off = fields["data_offset"]
            if data_off < code_end:
                errors.append("data segment overlaps code segment")
            elif data_off > len(data) or fields["data_size"] > len(data) - data_off:
                errors.append("uncompressed data segment is outside file")
            else:
                data_end = data_off + fields["data_size"]
        if dll_count > MAX_DLL_REFS:
            errors.append(f"DLL reference count exceeds safety cap {MAX_DLL_REFS}")
        if import_format not in (IMPORT_FMT_PE, IMPORT_FMT_ELF, IMPORT_FMT_PE2):
            errors.append(f"unsupported E32 import format 0x{import_format:08X}")
        if export_count > MAX_EXPORTS:
            errors.append(f"export count exceeds safety cap {MAX_EXPORTS}")

        export_bytes = export_count * 4
        export_bounded = (
            (export_count == 0 and export_off == 0)
            or (
                export_off >= code_off
                and export_off <= code_end
                and export_bytes <= code_end - export_off
                and export_off <= len(data)
                and export_bytes <= len(data) - export_off
            )
        )
        if not export_bounded:
            errors.append("export table is outside the code segment")
        elif export_count:
            valid = zero = invalid = 0
            code_base = fields["code_base"]
            for ordinal in range(1, export_count + 1):
                raw = u32(data, export_off + (ordinal - 1) * 4)
                if raw in (0, 0xFFFFFFFF):
                    zero += 1
                    exports.append({
                        "image": image, "path": path, "uid3": row["uid3"],
                        "ordinal": ordinal, "raw_offset": f"0x{raw:08X}",
                        "runtime_address": "", "thumb": "", "code_file_offset": "",
                        "valid_code_offset": "sentinel",
                    })
                    continue
                if import_format == IMPORT_FMT_ELF:
                    absolute = raw & ~1
                    code_rel = absolute - code_base if absolute >= code_base else -1
                    runtime_address = f"0x{raw:08X}"
                else:
                    code_rel = raw & ~1
                    runtime_address = f"0x{(code_base + raw) & 0xFFFFFFFF:08X}"
                ok = 0 <= code_rel < code_size
                file_off = code_off + code_rel if code_rel >= 0 else -1
                if ok:
                    valid += 1
                else:
                    invalid += 1
                exports.append({
                    "image": image, "path": path, "uid3": row["uid3"],
                    "ordinal": ordinal, "raw_offset": f"0x{raw:08X}",
                    "runtime_address": runtime_address,
                    "thumb": raw & 1,
                    "code_file_offset": f"0x{file_off:08X}" if file_off >= 0 else "",
                    "valid_code_offset": str(ok).lower(),
                })
            row.update(valid_exports=valid, zero_exports=zero, invalid_exports=invalid)

        import_end = None
        if dll_count:
            import_floor = max(code_end, data_end)
            if import_off < import_floor or import_off > len(data) - 4:
                errors.append("import section is outside the post-code/data region")
            else:
                import_size = u32(data, import_off)
                row["import_size"] = import_size
                if import_size < 4 or import_size > len(data) - import_off:
                    errors.append("import table size is outside file")
                else:
                    import_end = import_off + import_size
                    code_reloc = fields["code_reloc_offset"]
                    data_reloc = fields["data_reloc_offset"]
                    if code_reloc and code_reloc < import_end:
                        errors.append("code relocation section overlaps import section")
                    if data_reloc and code_reloc and data_reloc < code_reloc:
                        warnings.append("data relocation section precedes code relocation section")

                    pos = import_off + 4
                    total_imports = 0
                    parsed_blocks = 0
                    iat_matches = "not-applicable-ELF-relocations" if import_format == IMPORT_FMT_ELF else True
                    for block_index in range(dll_count):
                        if pos + 8 > import_end:
                            errors.append(f"import descriptor {block_index} exceeds import table")
                            break
                        name_rel, count = struct.unpack_from("<II", data, pos)
                        if count > MAX_IMPORTS or total_imports + count > MAX_IMPORTS:
                            errors.append("import count exceeds safety cap")
                            break
                        array_bytes = 0 if import_format == IMPORT_FMT_PE2 else count * 4
                        ord_end = pos + 8 + array_bytes
                        if ord_end > import_end:
                            errors.append(f"import list {block_index} exceeds import table")
                            break
                        name_off = import_off + name_rel
                        if name_off < import_off + 4 or name_off >= import_end:
                            errors.append(f"DLL name offset {block_index} is outside import table")
                            break
                        name_end = data.find(b"\0", name_off, import_end)
                        if name_end < 0:
                            errors.append(f"DLL name {block_index} is unterminated")
                            break
                        name = data[name_off:name_end].decode("ascii", "replace")

                        if import_format == IMPORT_FMT_PE:
                            ordinals = struct.unpack_from("<" + "I" * count, data, pos + 8) if count else ()
                            iat_off = text_size + total_imports * 4
                            if iat_off > code_size or count * 4 > code_size - iat_off:
                                errors.append(f"PE IAT block {block_index} exceeds code segment")
                                break
                            iat_values = struct.unpack_from("<" + "I" * count, data, code_off + iat_off) if count else ()
                            block_match = tuple(iat_values) == tuple(ordinals)
                            if not block_match:
                                iat_matches = False
                                warnings.append(f"IAT values differ from ordinal array for {name}")
                            for index, ordinal_value in enumerate(ordinals):
                                imports.append({
                                    "image": image, "path": path, "dependency": name,
                                    "ordinal": ordinal_value,
                                    "iat_file_offset": f"0x{code_off + iat_off + index * 4:08X}",
                                    "iat_value_matches": str(block_match).lower(),
                                    "import_kind": "PE ordinal/IAT",
                                    "relocation_offset": "",
                                    "addend": "",
                                })
                            total_imports += count

                        elif import_format == IMPORT_FMT_PE2:
                            iat_off = text_size + total_imports * 4
                            if iat_off > code_size or count * 4 > code_size - iat_off:
                                errors.append(f"PE2 IAT block {block_index} exceeds code segment")
                                break
                            ordinals = struct.unpack_from("<" + "I" * count, data, code_off + iat_off) if count else ()
                            for index, ordinal_value in enumerate(ordinals):
                                imports.append({
                                    "image": image, "path": path, "dependency": name,
                                    "ordinal": ordinal_value,
                                    "iat_file_offset": f"0x{code_off + iat_off + index * 4:08X}",
                                    "iat_value_matches": "PE2-IAT",
                                    "import_kind": "PE2 IAT",
                                    "relocation_offset": "",
                                    "addend": "",
                                })
                            total_imports += count

                        else:  # KImageImpFmt_ELF: list contains code-relative relocation places.
                            relocation_offsets = list(
                                struct.unpack_from("<" + "I" * count, data, pos + 8)
                            ) if count else []
                            if named_lookup:
                                if relocation_offsets and relocation_offsets[-1] == 0:
                                    relocation_offsets = relocation_offsets[:-1]
                                else:
                                    warnings.append(
                                        f"named-lookup import block {block_index} lacks its trailing zero-ordinal slot"
                                    )
                            for index, relocation_offset in enumerate(relocation_offsets):
                                if relocation_offset > code_size - 4:
                                    errors.append(
                                        f"ELF relocation place {block_index}:{index} is outside code segment"
                                    )
                                    break
                                if relocation_offset & 3:
                                    warnings.append(
                                        f"ELF relocation place {block_index}:{index} is not word-aligned"
                                    )
                                encoded = u32(data, code_off + relocation_offset)
                                ordinal_value = encoded & 0xFFFF
                                addend_value = (encoded >> 16) & 0xFFFF
                                imports.append({
                                    "image": image, "path": path, "dependency": name,
                                    "ordinal": ordinal_value,
                                    "iat_file_offset": f"0x{code_off + relocation_offset:08X}",
                                    "iat_value_matches": "ELF-relocation-slot",
                                    "import_kind": "ELF relocation",
                                    "relocation_offset": f"0x{relocation_offset:08X}",
                                    "addend": f"0x{addend_value:04X}",
                                })
                            total_imports += len(relocation_offsets)

                        parsed_blocks += 1
                        pos = ord_end
                    row.update(
                        import_count=total_imports,
                        parsed_import_blocks=parsed_blocks,
                        iat_matches=iat_matches,
                        import_trailing_bytes=import_end - pos,
                    )
                    if parsed_blocks != dll_count:
                        errors.append("not all DLL import descriptors were parsed")
        if errors:
            row["status"] = "REJECTED"
            row["reason"] = "; ".join(errors + warnings)
        elif warnings:
            row["status"] = "PARTIAL"
            row["reason"] = "; ".join(warnings)
        else:
            row["status"] = "PASS"
            row["reason"] = "bounded E32 header, export table, import table and IAT checks passed"
    except (ValueError, struct.error, OverflowError) as exc:
        row["status"] = "REJECTED"
        row["reason"] = str(exc)
    return row, exports, imports


def synthetic_e32() -> bytes:
    data = bytearray(0xB6)
    struct.pack_into("<III", data, 0, DLL_UID, 0x1000008D, 0xE0001090)
    data[0x10:0x14] = b"EPOC"
    struct.pack_into("<I", data, 0x1C, 0)       # compression type
    struct.pack_into("<I", data, 0x2C, 0)       # flags
    struct.pack_into("<I", data, 0x30, 0x20)   # code size
    struct.pack_into("<I", data, 0x34, 0)      # data size
    struct.pack_into("<I", data, 0x4C, 0x10000000)
    struct.pack_into("<I", data, 0x54, 1)      # one DLL reference
    struct.pack_into("<I", data, 0x58, 0x98)   # export table
    struct.pack_into("<I", data, 0x5C, 1)      # one export
    struct.pack_into("<I", data, 0x60, 0x10)   # IAT starts at code+0x10
    struct.pack_into("<I", data, 0x64, 0x7C)   # code offset
    struct.pack_into("<I", data, 0x6C, 0x9C)   # import offset
    struct.pack_into("<I", data, 0x70, 0xB6)   # end of import table
    struct.pack_into("<I", data, 0x78, 350)    # priority/reserved tail
    struct.pack_into("<I", data, 0x8C, 7)     # IAT ordinal
    struct.pack_into("<I", data, 0x98, 4)     # one export at code+4
    struct.pack_into("<I", data, 0x9C, 26)    # import table size
    struct.pack_into("<II", data, 0xA0, 16, 1)
    struct.pack_into("<I", data, 0xA8, 7)
    data[0xAC:0xB5] = b"euser.dll\0"
    return bytes(data)


def write_tsv(path: Path, rows: list[dict], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, delimiter="\t", extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def self_test() -> None:
    good = synthetic_e32()

    def compressed_fixture(compression_uid: int) -> bytes:
        # Model an EKA2 V-format image with a 0xA0-byte header. The compressed
        # payload begins at iCodeOffset, not at the fixed 0x80-byte J-header.
        header_size = 0xA0
        delta = header_size - 0x7C
        flat = bytearray(good[:0x7C] + bytes(delta) + good[0x7C:])
        for offset in (0x58, 0x64, 0x6C, 0x70):
            struct.pack_into("<I", flat, offset, u32(flat, offset) + delta)
        struct.pack_into("<I", flat, 0x2C, 0x02000001)  # V header format + DLL
        struct.pack_into("<I", flat, 0x64, header_size)
        struct.pack_into("<I", flat, 0x80, u32(flat, 0x08))  # secure ID
        struct.pack_into("<I", flat, 0x84, 0x101FB657)       # vendor ID
        struct.pack_into("<II", flat, 0x88, 0, 0)            # capabilities
        struct.pack_into("<I", flat, 0x90, 0)                # exception descriptor
        struct.pack_into("<I", flat, 0x94, 0)                # spare2
        struct.pack_into("<HBB", flat, 0x98, 0, 0, 0)         # no export description
        payload = bytes(flat[header_size:])
        struct.pack_into("<I", flat, 0x1C, compression_uid)
        struct.pack_into("<I", flat, 0x7C, len(payload))
        if compression_uid == DEFLATE_UID:
            packed = zlib.compress(payload)
        else:
            packed = b"\0" + payload
        return bytes(flat[:header_size]) + packed

    for compression_uid in (DEFLATE_UID, BYTEPAIR_UID):
        packed = compressed_fixture(compression_uid)
        flat, meta = inflate_e32(packed)
        assert flat[0x1C:0x20] == b"\0\0\0\0" and len(flat) == 0xA0 + meta["decoded_payload_size"], meta
        assert meta["header_format"] == 2 and meta["header_size"] == 0xA0, meta
        row, exp, imp = parse_candidate(packed, "TEST", "sys/bin/compressed.dll")
        assert row["status"] == "PASS", row
        assert row["decompressed"] is True and len(exp) == 1 and len(imp) == 1, row

    row, exports, imports = parse_candidate(good, "TEST", "sys/bin/test.dll")
    assert row["status"] == "PASS", row
    assert row["export_count"] == 1 and row["valid_exports"] == 1, row
    assert len(exports) == 1 and len(imports) == 1, (exports, imports)

    def v_format_fixture(import_format: int, named_lookup: bool = False) -> bytes:
        header_size = 0xA0
        code_size = 0x20
        code_offset = header_size
        import_offset = code_offset + code_size
        if import_format == IMPORT_FMT_ELF:
            count = 2 if named_lookup else 1
            name_rel = 4 + 8 + count * 4
            import_size = (name_rel + len(b"euser.dll\0") + 3) & ~3
        elif import_format == IMPORT_FMT_PE2:
            count = 1
            name_rel = 4 + 8
            import_size = (name_rel + len(b"euser.dll\0") + 3) & ~3
        else:
            raise AssertionError("unsupported synthetic format")
        image = bytearray(import_offset + import_size)
        struct.pack_into("<III", image, 0, DLL_UID, 0x1000008D, 0xE0001190)
        image[0x10:0x14] = b"EPOC"
        struct.pack_into("<I", image, 0x1C, 0)
        flags = 0x02000000 | 0x00000020 | 0x00000008 | 0x00000001 | import_format
        if named_lookup:
            flags |= IMAGE_NAMED_EXPORT_DATA
        struct.pack_into("<I", image, 0x2C, flags)
        struct.pack_into("<II", image, 0x30, code_size, 0)
        struct.pack_into("<I", image, 0x4C, 0x10000000)
        struct.pack_into("<I", image, 0x54, 1)
        struct.pack_into("<II", image, 0x58, code_offset + 0x1C, 1)
        struct.pack_into("<I", image, 0x60, 0x10 if import_format == IMPORT_FMT_PE2 else code_size)
        struct.pack_into("<III", image, 0x64, code_offset, 0, import_offset)
        struct.pack_into("<I", image, import_offset, import_size)
        struct.pack_into("<II", image, import_offset + 4, name_rel, count)
        if import_format == IMPORT_FMT_ELF:
            struct.pack_into("<I", image, code_offset + 8, (3 << 16) | 7)
            struct.pack_into("<I", image, import_offset + 12, 8)
            if named_lookup:
                struct.pack_into("<I", image, import_offset + 16, 0)
            struct.pack_into("<I", image, code_offset + 0x1C, 0x10000004)
        else:
            struct.pack_into("<I", image, code_offset + 0x10, 7)
            struct.pack_into("<I", image, code_offset + 0x1C, 4)
        image[import_offset + name_rel:import_offset + name_rel + len(b"euser.dll\0")] = b"euser.dll\0"
        return bytes(image)

    elf = v_format_fixture(IMPORT_FMT_ELF, named_lookup=True)
    row, exports, imports = parse_candidate(elf, "TEST", "sys/bin/elf.dll")
    assert row["status"] == "PASS" and row["import_format"] == "ELF", row
    assert row["export_address_mode"] == "absolute" and row["valid_exports"] == 1, row
    assert row["import_count"] == 1 and len(imports) == 1, (row, imports)
    assert imports[0]["ordinal"] == 7 and imports[0]["addend"] == "0x0003", imports

    pe2 = v_format_fixture(IMPORT_FMT_PE2)
    row, _, imports = parse_candidate(pe2, "TEST", "sys/bin/pe2.dll")
    assert row["status"] == "PASS" and row["import_format"] == "PE2", row
    assert row["import_count"] == 1 and imports[0]["ordinal"] == 7, (row, imports)

    bad_iat = bytearray(good)
    struct.pack_into("<I", bad_iat, 0x8C, 9)
    row, _, _ = parse_candidate(bytes(bad_iat), "TEST", "sys/bin/bad.dll")
    assert row["status"] == "PARTIAL" and "IAT values differ" in row["reason"], row

    unknown_compression = bytearray(good)
    struct.pack_into("<I", unknown_compression, 0x1C, 1)
    row, _, imports = parse_candidate(bytes(unknown_compression), "TEST", "sys/bin/unknown-compression.dll")
    assert row["status"] == "COMPRESSED_UNDECODED" and row["iat_matches"] is None, row
    assert not imports, imports

    truncated = good[:0x90]
    row, _, _ = parse_candidate(truncated, "TEST", "sys/bin/truncated.dll")
    assert row["status"] == "REJECTED", row

    false_positive = bytearray(good)
    struct.pack_into("<I", false_positive, 0, 0x12345678)
    row, _, _ = parse_candidate(bytes(false_positive), "TEST", "sys/bin/not-e32.bin")
    assert row["status"] == "MAGIC_ONLY", row
    print("Step109 E32 inventory self-tests: PASS (7/7)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tree", action="append", default=[], metavar="LABEL=PATH")
    parser.add_argument("--out-dir", type=Path, default=Path("firmware-input"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        self_test()

    rows: list[dict] = []
    exports: list[dict] = []
    imports: list[dict] = []
    for spec in args.tree:
        if "=" not in spec:
            parser.error("--tree must be LABEL=PATH")
        label, root_text = spec.split("=", 1)
        if not label or any(c not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-" for c in label):
            parser.error(f"unsafe tree label: {label!r}")
        root = Path(root_text)
        if not root.is_dir():
            raise SystemExit(f"extracted tree does not exist: {root}")
        for file_path in sorted(root.rglob("*")):
            if file_path.is_symlink() or not file_path.is_file():
                continue
            try:
                data = file_path.read_bytes()
            except OSError as exc:
                rows.append({"image": label, "path": file_path.relative_to(root).as_posix(),
                             "size": 0, "sha256": "", "status": "READ_ERROR", "reason": str(exc)})
                continue
            if len(data) < 0x14 or data[0x10:0x14] != b"EPOC":
                continue
            rel = file_path.relative_to(root).as_posix()
            row, exp_rows, imp_rows = parse_candidate(data, label, rel)
            rows.append(row)
            exports.extend(exp_rows)
            imports.extend(imp_rows)

    if not args.tree:
        if args.self_test:
            return 0
        parser.error("provide --tree LABEL=PATH and/or --self-test")

    args.out_dir.mkdir(parents=True, exist_ok=True)
    module_fields = [
        "image", "path", "size", "sha256", "status", "reason", "uid1", "uid2", "uid3",
        "header_crc", "module_version", "tools_version", "kind", "flags", "header_format", "header_size", "compression_type",
        "compression_header_hex", "compressed_payload_prefix_hex", "compression_algorithm", "uncompressed_size_field", "decompression_size_mode",
        "decompressed", "flat_size", "code_base", "entry_point", "data_base", "code_size", "data_size",
        "code_offset", "data_offset", "text_size", "import_offset", "import_size",
        "code_reloc_offset", "data_reloc_offset", "export_dir_offset", "export_count",
        "valid_exports", "zero_exports", "invalid_exports", "dll_ref_count", "import_count",
        "parsed_import_blocks", "iat_matches", "import_trailing_bytes",
        "import_format", "named_lookup", "export_address_mode",
    ]
    export_fields = [
        "image", "path", "uid3", "ordinal", "raw_offset", "runtime_address", "thumb",
        "code_file_offset", "valid_code_offset",
    ]
    import_fields = [
        "image", "path", "dependency", "ordinal", "iat_file_offset", "iat_value_matches",
        "import_kind", "relocation_offset", "addend",
    ]
    write_tsv(args.out_dir / "STEP109_E32_MODULES.tsv", rows, module_fields)
    write_tsv(args.out_dir / "STEP109_E32_EXPORTS.tsv", exports, export_fields)
    write_tsv(args.out_dir / "STEP109_E32_IMPORTS.tsv", imports, import_fields)

    counts = Counter(row.get("status", "UNKNOWN") for row in rows)
    compression_counts = Counter(row.get("compression_type", "unknown") for row in rows)
    decompressed_count = sum(1 for row in rows if row.get("decompressed"))
    decompression_error_counts = Counter(
        row.get("reason") or "unspecified decompression failure"
        for row in rows if row.get("status") == "COMPRESSED_UNDECODED"
    )
    summary = {
        "format": "Step109 bounded ROFS/ROFx E32 inventory",
        "candidate_count": len(rows),
        "status_counts": dict(sorted(counts.items())),
        "compression_type_counts": dict(sorted(compression_counts.items())),
        "decompressed_modules": decompressed_count,
        "decompression_error_counts": dict(sorted(decompression_error_counts.items())),
        "structurally_valid_modules": sum(1 for row in rows if row.get("status") == "PASS"),
        "export_rows": len(exports),
        "import_rows": len(imports),
        "module_rows": rows,
        "limits": {
            "source_firmware_modified": False,
            "firmware_or_system_binaries_committed": False,
            "header_crc_verified": False,
            "code_relocations_fully_parsed": False,
            "runtime_loadability_proven": False,
            "rom_xip_export_inventory_is_separate": True,
        },
    }
    (args.out_dir / "STEP109_E32_AUDIT.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )

    lines = [
        "# Step109 — bounded E32 inventory from N95 ROFS/ROFx",
        "",
        f"- EPOC-signature candidates: **{len(rows)}**",
        f"- Status counts: `{dict(sorted(counts.items()))}`",
        f"- Compression UID counts: `{dict(sorted(compression_counts.items()))}`",
        f"- Compressed modules successfully inflated: **{decompressed_count}**",
        f"- Decompression error counts: {dict(sorted(decompression_error_counts.items()))}",
        f"- Structurally valid modules: **{summary['structurally_valid_modules']}**",
        f"- Decoded export rows: **{len(exports)}**",
        f"- Decoded import rows: **{len(imports)}**",
        "",
        "## Decompression diagnostics",
        "",
    ]
    for message, count in decompression_error_counts.most_common(10):
        lines.append(f"- {count} candidate(s): {message}")
    samples = [row for row in rows if row.get("status") == "COMPRESSED_UNDECODED"][:8]
    if samples:
        lines += ["", "### First failed candidates (header/payload prefixes only)", ""]
        for row in samples:
            lines.append(
                "- {} ({}, size-field=0x{:08X}): {}; header={}; payload={}".format(
                    row["path"], row["compression_algorithm"],
                    int(row.get("uncompressed_size_field") or 0), row["reason"],
                    row["compression_header_hex"], row["compressed_payload_prefix_hex"]
                )
            )
    lines += [
        "",
        "## Structurally valid candidates",
        "",
        "| Image | Path | Kind | UID3 | Exports | Imports |",
        "|---|---|---|---:|---:|---:|",
    ]
    for row in rows:
        if row.get("status") == "PASS":
            lines.append(
                f"| {row['image']} | `{row['path']}` | {row['kind']} | "
                f"{row['uid3']} | {row['export_count']} | {row['import_count']} |"
            )
    lines += [
        "",
        "## Interpretation limits",
        "",
        "- EPOC signature plus UID1 is only the candidate gate; full bounds, import descriptors, IAT values and export offsets are checked separately.",
        "- PASS means the inspected E32 tables are structurally bounded and internally consistent under this parser. It is not a signature, checksum, relocation, loader or runtime test.",
        "- PARTIAL means the bounded tables were readable but at least one layout or IAT cross-check did not match.",
        "- REJECTED means a hard structural/bounds check failed. MAGIC_ONLY means the EPOC marker was present but UID1 was not an E32 DLL/EXE UID.",
        "- Header CRC and code/data relocation streams are not validated by this step.",
        "- The seven core system DLL export tables are XIP ROM modules reconstructed separately from C0R SOS+CORE; they are not replaced by this ROFS/ROFx file inventory.",
        "- PPM ROFx external references remain excluded by Step108 and are not resolved against a guessed base image.",
        "- No firmware image or protected system DLL is modified or committed.",
        "",
        "Detailed tables: `STEP109_E32_MODULES.tsv`, `STEP109_E32_EXPORTS.tsv`, `STEP109_E32_IMPORTS.tsv`.",
        "",
    ]
    report = "\n".join(lines)
    (args.out_dir / "STEP109_E32_INVENTORY.md").write_text(report, encoding="utf-8")
    print(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
