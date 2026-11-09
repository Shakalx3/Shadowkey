#!/usr/bin/env python3
"""Reconstruct Symbian demand-paged ROM pages from SRomPageInfo."""
from pathlib import Path
import hashlib
import struct

PAGE = 0x1000
ROM = Path("firmware-parsed/carved/rom-sos-core.img")
REPORT = Path("firmware-input/STEP79_ROM_PAGE_RECONSTRUCTION.txt")
TARGETS = {
    "euser.dll", "cone.dll", "gdi.dll", "fbscli.dll", "eikcore.dll",
    "avkon.dll", "ws32.dll", "eikcoctl.dll", "appcore.dll", "efsrv.dll",
}

def u32(b, o):
    return struct.unpack_from("<I", b, o)[0]

def bytepair_decompress(src, dst_size=PAGE):
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
    def expand(token):
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

def find_rom_header(data):
    marker = struct.pack("<I", 0x80000000)
    hits = []
    for p in range(0, len(data) - 0x120, 4):
        if data[p + 0x8C:p + 0x90] != marker:
            continue
        rom_size = u32(data, p + 0x90)
        root = u32(data, p + 0x94)
        uncompressed = u32(data, p + 0xF4)
        if 0x100000 <= rom_size <= 0x20000000 and 0x80000000 <= root < 0x80000000 + rom_size and 0 < uncompressed <= 0x20000000:
            hits.append(p)
    if len(hits) != 1:
        raise ValueError(f"expected one TRomHeader, found {len(hits)}: {hits}")
    return hits[0]

def parse_rom_directory(rom_image, rom_base, root_ptr, outdir):
    def va_to_off(va):
        if va < rom_base:
            raise ValueError(f"VA below ROM base: 0x{va:08X}")
        return va - rom_base
    directory_rows = []
    target_rows = []
    export_rows = []
    errors = []
    seen = set()

    def walk(dir_va, prefix="", depth=0):
        if depth > 32:
            errors.append(f"depth limit: {prefix}")
            return
        try:
            d_off = va_to_off(dir_va)
            if d_off in seen:
                return
            seen.add(d_off)
            if d_off < 0 or d_off + 4 > len(rom_image):
                raise ValueError(f"directory outside reconstructed ROM: {dir_va:08X}")
            d_size = u32(rom_image, d_off)
            pos = d_off + 4
            end = pos + d_size
            if end > len(rom_image):
                raise ValueError(f"directory size outside ROM: {prefix} {d_size:X}")
            while pos + 10 <= end:
                file_size = u32(rom_image, pos)
                address = u32(rom_image, pos + 4)
                attr = rom_image[pos + 8]
                name_len = rom_image[pos + 9]
                stride = (10 + 2 * name_len + 3) & ~3
                if not name_len or pos + stride > end:
                    errors.append(f"bad entry at {prefix} +0x{pos:X}, name_len={name_len}")
                    break
                name = rom_image[pos + 10:pos + 10 + 2 * name_len].decode("utf-16le", errors="replace")
                full = f"{prefix}/{name}" if prefix else name
                directory_rows.append((full, "DIR" if attr & 0x10 else "FILE", attr, file_size, address, pos))
                if attr & 0x10:
                    walk(address, full, depth + 1)
                elif name.lower() in TARGETS:
                    if not (attr & 0x80):
                        target_rows.append(f"{full}\tNON-XIP\t{attr:02X}\t{file_size}\t{address:08X}")
                    else:
                        try:
                            off = va_to_off(address)
                            hdr = rom_image[off:off + 0x78]
                            if len(hdr) < 0x78:
                                raise ValueError("truncated TRomImageHeader")
                            uid1, uid2, uid3 = struct.unpack_from("<III", hdr, 0)
                            entry = u32(hdr, 0x10)
                            code_addr = u32(hdr, 0x14)
                            code_size = u32(hdr, 0x1C)
                            data_size = u32(hdr, 0x24)
                            bss_size = u32(hdr, 0x28)
                            export_count = u32(hdr, 0x3C)
                            export_addr = u32(hdr, 0x40)
                            if code_addr != address + 0x78:
                                raise ValueError(f"code VA mismatch {code_addr:08X} != {address+0x78:08X}")
                            export_off = va_to_off(export_addr) if export_count else 0
                            if export_count > 10000 or (export_count and export_off + export_count * 4 > len(rom_image)):
                                raise ValueError("export table outside ROM")
                            module_path = outdir / "rom-modules" / name
                            module_path.parent.mkdir(parents=True, exist_ok=True)
                            if off + 0x78 + code_size > len(rom_image):
                                raise ValueError("module code exceeds reconstructed ROM")
                            module_path.write_bytes(rom_image[off:off + 0x78 + code_size])
                            target_rows.append(
                                f"{full}\tXIP\t{attr:02X}\t{file_size}\t{address:08X}\t"
                                f"{uid1:08X}\t{uid2:08X}\t{uid3:08X}\t{entry:08X}\t"
                                f"{code_addr:08X}\t{code_size}\t{data_size}\t{bss_size}\t"
                                f"{export_count}\t{export_addr:08X}\t{module_path}"
                            )
                            for ordinal in range(1, export_count + 1):
                                va = u32(rom_image, export_off + (ordinal - 1) * 4)
                                export_rows.append(f"{name}\t{ordinal}\t{va:08X}\t{va & 1}")
                        except Exception as exc:
                            target_rows.append(f"{full}\tXIP-ERROR\t{attr:02X}\t{file_size}\t{address:08X}\t{exc}")
                pos += stride
        except Exception as exc:
            errors.append(f"{prefix}: {exc}")

    root_off = va_to_off(root_ptr)
    root_count = u32(rom_image, root_off)
    if root_count < 1 or root_count > 32 or root_off + 4 + root_count * 8 > len(rom_image):
        raise ValueError(f"invalid root directory list count {root_count}")
    for i in range(root_count):
        hardware = u32(rom_image, root_off + 4 + i * 8)
        root_dir = u32(rom_image, root_off + 8 + i * 8)
        walk(root_dir, f"[variant-{hardware:08X}]")
    (outdir / "ROM_DIRECTORY.tsv").write_text(
        "path\ttype\tattr\tsize\taddress\tentry_offset\n" +
        "".join(f"{p}\t{t}\t{a:02X}\t{s}\t{addr:08X}\t{off:X}\n" for p,t,a,s,addr,off in directory_rows),
        encoding="utf-8",
    )
    (outdir / "ROM_TARGET_MODULES.tsv").write_text(
        "path\tkind\tattr\tfile_size\theader_va\tuid1\tuid2\tuid3\tentry_point\tcode_address\t"
        "code_size\tdata_size\tbss_size\texport_count\texport_address\tfile\n" +
        "\n".join(target_rows) + ("\n" if target_rows else ""),
        encoding="utf-8",
    )
    (outdir / "ROM_EXPORTS.tsv").write_text(
        "module\tordinal\taddress\tthumb\n" + "\n".join(export_rows) +
        ("\n" if export_rows else ""), encoding="utf-8"
    )
    return root_count, len(directory_rows), len(target_rows), len(export_rows), errors

def main():
    if not ROM.exists():
        raise FileNotFoundError(ROM)
    raw = ROM.read_bytes()
    h_off = find_rom_header(raw)
    header = raw[h_off:h_off + 0x200]
    rom_base = u32(header, 0x8C)
    rom_size = u32(header, 0x90)
    root_ptr = u32(header, 0x94)
    uncompressed_size = u32(header, 0xF4)
    pageable_start = u32(header, 0x148)
    pageable_size = u32(header, 0x14C)
    page_index_off = u32(header, 0x150)
    page_count = (uncompressed_size + PAGE - 1) // PAGE
    first_pageable_index = pageable_start // PAGE
    pageable_page_count = page_count - first_pageable_index
    table_off = h_off + page_index_off
    if table_off + page_count * 8 > len(raw):
        raise ValueError("ROM page index table extends beyond SOS+CORE image")

    entries = []
    for i in range(page_count):
        data_start, data_size, compression, attrs = struct.unpack_from("<IHBB", raw, table_off + i * 8)
        entries.append((data_start, data_size, compression, attrs))

    # Determine whether iDataStart is relative to the TRomHeader or the
    # outer partition. Test real BytePair pages rather than guessing.
    base_candidates = [("rom-relative", h_off), ("partition-relative", 0)]
    base_scores = []
    for label, base in base_candidates:
        ok = 0
        tried = 0
        for data_start, data_size, compression, attrs in entries[first_pageable_index:]:
            if not data_size or compression != 1:
                continue
            off = base + data_start
            if off < 0 or off + data_size > len(raw):
                continue
            tried += 1
            try:
                bytepair_decompress(raw[off:off + data_size])
                ok += 1
            except Exception:
                pass
            if tried >= 64:
                break
        base_scores.append((ok, tried, label, base))
    base_scores.sort(key=lambda x: (x[0], x[1], x[2] == "rom-relative"), reverse=True)
    ok, tried, chosen_label, data_base = base_scores[0]

    outdir = Path("firmware-input")
    report = [
        f"raw_size={len(raw)} sha256={hashlib.sha256(raw).hexdigest()}",
        f"rom_header_offset=0x{h_off:X} rom_base=0x{rom_base:08X} rom_size=0x{rom_size:X}",
        f"uncompressed_size=0x{uncompressed_size:X} pageable_start=0x{pageable_start:X} pageable_size=0x{pageable_size:X}",
        f"page_index_offset=0x{page_index_off:X} page_count_total={page_count} first_pageable_index={first_pageable_index} pageable_page_count={pageable_page_count} page_index_file_offset=0x{table_off:X}",
        f"data_start_mapping={chosen_label} base=0x{data_base:X} sample_bytepair_ok={ok}/{tried}",
        f"compression_types={dict((x, sum(1 for e in entries if e[2] == x)) for x in sorted(set(e[2] for e in entries)))}",
        f"zero_size_pages={sum(1 for e in entries if e[1] == 0)}",
        f"non_pageable_flags={sum(1 for e in entries if not (e[3] & 1))}",
        f"data_size_min={min(e[1] for e in entries)} data_size_max={max(e[1] for e in entries)}",
        f"pageable_data_start_min=0x{min(e[0] for e in entries[first_pageable_index:]):X} pageable_data_start_max=0x{max(e[0] for e in entries[first_pageable_index:]):X}",
        f"base_scores={base_scores}",
    ]
    page_rows = ["index\trom_offset\tdata_start\tdata_size\tcompression\tattrs\traw_offset\tstatus"]
    output = bytearray(b"\xFF" * uncompressed_size)
    prefix = raw[h_off:h_off + pageable_start]
    if len(prefix) != pageable_start:
        raise ValueError("unpaged ROM prefix is truncated")
    output[:pageable_start] = prefix
    successes = {0: 0, 1: 0}
    failures = []
    for i, (data_start, data_size, compression, attrs) in enumerate(entries):
        if i < first_pageable_index:
            page_rows.append(f"{i}\t{i*PAGE:08X}\t{data_start:08X}\t{data_size}\t{compression}\t{attrs:02X}\t-\tunpaged-skip")
            continue
        dst_off = i * PAGE
        raw_off = data_base + data_start
        status = "ok"
        page_len = min(PAGE, uncompressed_size - dst_off)
        if data_size == 0:
            page = b"\xFF" * PAGE
            status = "empty-ff"
        elif raw_off < 0 or raw_off + data_size > len(raw):
            page = b"\xFF" * PAGE
            status = "source-out-of-range"
            failures.append((i, status, raw_off, data_size))
        else:
            src = raw[raw_off:raw_off + data_size]
            try:
                if compression == 0:
                    if len(src) < PAGE:
                        page = src + b"\x03" * (PAGE - len(src))
                    else:
                        page = src[:PAGE]
                elif compression == 1:
                    page = bytepair_decompress(src, PAGE)
                else:
                    raise ValueError(f"unsupported compression {compression}")
                successes[compression] = successes.get(compression, 0) + 1
            except Exception as exc:
                page = b"\xFF" * PAGE
                status = f"decode-error:{type(exc).__name__}:{exc}"
                failures.append((i, status, raw_off, data_size))
        output[dst_off:dst_off + page_len] = page[:page_len]
        page_rows.append(
            f"{i}\t{dst_off:08X}\t{data_start:08X}\t{data_size}\t{compression}\t{attrs:02X}\t{raw_off:08X}\t{status}"
        )
    (outdir / "ROM_PAGE_INDEX.tsv").write_text("\n".join(page_rows) + "\n", encoding="utf-8")
    reconstructed = outdir / "rom-reconstructed.bin"
    reconstructed.write_bytes(output)
    report.append(f"page_decode_successes={successes} failures={len(failures)}")
    report.append(f"reconstructed_size={len(output)} expected={uncompressed_size} sha256={hashlib.sha256(output).hexdigest()}")
    for row in failures[:40]:
        report.append(f"PAGE_ERROR index={row[0]} status={row[1]} raw_offset=0x{row[2]:X} size={row[3]}")
    try:
        root_count, dirs, targets, exports, errors = parse_rom_directory(output, rom_base, root_ptr, outdir)
        report.append(f"reconstructed_root_count={root_count} directory_entries={dirs} target_modules={targets} export_rows={exports}")
        report.extend("ROM_DIR_ERROR " + e for e in errors[:80])
    except Exception as exc:
        report.append(f"ROM_DIRECTORY_PARSE_FAILED {type(exc).__name__}: {exc}")
    text = "\n".join(report) + "\n"
    REPORT.write_text(text, encoding="utf-8")
    print(text, end="")

if __name__ == "__main__":
    main()
