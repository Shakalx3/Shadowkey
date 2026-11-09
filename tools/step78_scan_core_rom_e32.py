#!/usr/bin/env python3
"""Locate TRomHeader in SOS+CORE and walk its XIP ROM directory."""
from pathlib import Path
import hashlib
import struct

rom = Path("firmware-parsed/carved/rom-sos-core.img")
out = Path("firmware-input/STEP78_CORE_ROM_E32_SCAN.txt")
report = []
targets = {
    "euser.dll", "cone.dll", "gdi.dll", "fbscli.dll", "eikcore.dll",
    "avkon.dll", "ws32.dll", "eikcoctl.dll", "appcore.dll", "efsrv.dll",
}

def u32(buf, off):
    return struct.unpack_from("<I", buf, off)[0]

def va_to_off(va, base, header_off):
    if va < base:
        raise ValueError(f"VA below ROM base: 0x{va:08X}")
    return header_off + va - base

if not rom.exists():
    report.append("SOS+CORE image missing")
else:
    data = rom.read_bytes()
    report.append(f"path={rom} size={len(data)} sha256={hashlib.sha256(data).hexdigest()}")
    report.append("first256=" + data[:256].hex())
    report.append("payload+0x400=" + data[1024:1536].hex())
    base_word = struct.pack("<I", 0x80000000)
    candidates = []
    for pos in range(0, len(data) - 0x120, 4):
        if data[pos + 0x8C:pos + 0x90] != base_word:
            continue
        rom_size = u32(data, pos + 0x90)
        root_ptr = u32(data, pos + 0x94)
        kern_data = u32(data, pos + 0x98)
        primary = u32(data, pos + 0xA0)
        secondary = u32(data, pos + 0xA4)
        uncompressed = u32(data, pos + 0xF4)
        if not (0x100000 <= rom_size <= 0x20000000):
            continue
        if not (0x80000000 <= root_ptr < 0x80000000 + rom_size):
            continue
        if not (0x80000000 <= primary < 0x80000000 + rom_size):
            continue
        if not (0x80000000 <= secondary < 0x80000000 + rom_size):
            continue
        if uncompressed == 0 or uncompressed > 0x20000000:
            continue
        candidates.append((pos, rom_size, root_ptr, kern_data, primary, secondary, uncompressed))
    report.append(f"TRomHeader_candidates={len(candidates)}")
    for h_off, rom_size, root_ptr, kern_data, primary, secondary, uncompressed in candidates:
        report.append(
            f"TRomHeader file_offset=0x{h_off:X} rom_size=0x{rom_size:X} "
            f"root_list=0x{root_ptr:08X} kern_data=0x{kern_data:08X} "
            f"primary=0x{primary:08X} secondary=0x{secondary:08X} "
            f"uncompressed=0x{uncompressed:X}"
        )
    if candidates:
        # The strongest candidate is the one whose root list and boot entries
        # all map to valid, aligned ROM addresses.
        h_off, rom_size, root_ptr, kern_data, primary, secondary, uncompressed = candidates[0]
        rom_base = 0x80000000
        directory_rows = []
        target_rows = []
        export_rows = []
        seen_dirs = set()
        errors = []

        def walk_dir(dir_va, prefix, depth=0):
            if depth > 32:
                errors.append(f"depth-limit {prefix} @0x{dir_va:08X}")
                return
            try:
                d_off = va_to_off(dir_va, rom_base, h_off)
                if d_off in seen_dirs:
                    return
                seen_dirs.add(d_off)
                if d_off < 0 or d_off + 4 > len(data):
                    raise ValueError(f"directory address outside image: 0x{dir_va:08X}")
                d_size = u32(data, d_off)
                start = d_off + 4
                end = start + d_size
                if d_size > len(data) or end > len(data):
                    raise ValueError(f"directory size outside image: {prefix} size=0x{d_size:X}")
                pos = start
                while pos + 10 <= end:
                    file_size = u32(data, pos)
                    address = u32(data, pos + 4)
                    attr = data[pos + 8]
                    name_len = data[pos + 9]
                    stride = (0xA + name_len * 2 + 3) & ~3
                    if name_len == 0 or name_len > 255 or pos + stride > end:
                        errors.append(f"bad entry {prefix} at file+0x{pos:X} len={name_len}")
                        break
                    raw_name = data[pos + 10:pos + 10 + name_len * 2]
                    name = raw_name.decode("utf-16le", errors="replace")
                    full = f"{prefix}/{name}" if prefix else name
                    pos_next = pos + stride
                    if attr & 0x10:
                        directory_rows.append((full, "DIR", attr, file_size, address, pos))
                        walk_dir(address, full, depth + 1)
                    else:
                        directory_rows.append((full, "FILE", attr, file_size, address, pos))
                        if name.lower() in targets:
                            if attr & 0x80:
                                try:
                                    image_off = va_to_off(address, rom_base, h_off)
                                    hdr = data[image_off:image_off + 0x78]
                                    if len(hdr) < 0x78:
                                        raise ValueError("truncated TRomImageHeader")
                                    uid1, uid2, uid3 = struct.unpack_from("<III", hdr, 0)
                                    entry_point = u32(hdr, 0x10)
                                    code_address = u32(hdr, 0x14)
                                    code_size = u32(hdr, 0x1C)
                                    data_size = u32(hdr, 0x24)
                                    bss_size = u32(hdr, 0x28)
                                    export_count = u32(hdr, 0x3C)
                                    export_address = u32(hdr, 0x40)
                                    if code_address != address + 0x78:
                                        raise ValueError(
                                            f"code VA mismatch 0x{code_address:08X} vs 0x{address+0x78:08X}"
                                        )
                                    export_off = va_to_off(export_address, rom_base, h_off)
                                    if export_count > 10000 or export_off + export_count * 4 > len(data):
                                        raise ValueError("export table outside ROM")
                                    module_file = Path("firmware-input/rom-modules") / name
                                    module_file.parent.mkdir(parents=True, exist_ok=True)
                                    module_file.write_bytes(data[image_off:image_off + 0x78 + code_size])
                                    target_rows.append(
                                        f"{full}\tXIP\t{attr:02X}\t{file_size}\t{address:08X}\t"
                                        f"{uid1:08X}\t{uid2:08X}\t{uid3:08X}\t{entry_point:08X}\t"
                                        f"{code_address:08X}\t{code_size}\t{data_size}\t{bss_size}\t"
                                        f"{export_count}\t{export_address:08X}\t{module_file}"
                                    )
                                    for ordinal in range(1, export_count + 1):
                                        export_va = u32(data, export_off + (ordinal - 1) * 4)
                                        export_rows.append(
                                            f"{name}\t{ordinal}\t{export_va:08X}\t{export_va & 1}"
                                        )
                                except Exception as exc:
                                    target_rows.append(f"{full}\tXIP-ERROR\t{attr:02X}\t{file_size}\t{address:08X}\t{exc}")
                            else:
                                target_rows.append(f"{full}\tNON-XIP\t{attr:02X}\t{file_size}\t{address:08X}")
                    pos = pos_next
            except Exception as exc:
                errors.append(f"{prefix}: {exc}")

        try:
            list_off = va_to_off(root_ptr, rom_base, h_off)
            root_count = u32(data, list_off)
            report.append(f"root_directory_count={root_count}")
            if root_count < 1 or root_count > 32 or list_off + 4 + root_count * 8 > len(data):
                raise ValueError("invalid TRomRootDirectoryList")
            for i in range(root_count):
                hardware = u32(data, list_off + 4 + i * 8)
                root_dir = u32(data, list_off + 8 + i * 8)
                report.append(f"root[{i}] hardware=0x{hardware:08X} dir=0x{root_dir:08X}")
                walk_dir(root_dir, "")
        except Exception as exc:
            errors.append(f"root-list: {exc}")

        Path("firmware-input/ROM_DIRECTORY.tsv").write_text(
            "path\ttype\tattr\tsize\taddress\tentry_file_offset\n" +
            "".join(f"{p}\t{t}\t{a:02X}\t{s}\t{addr:08X}\t{off:X}\n"
                    for p, t, a, s, addr, off in directory_rows),
            encoding="utf-8",
        )
        Path("firmware-input/ROM_TARGET_MODULES.tsv").write_text(
            "path\tkind\tattr\tfile_size\theader_va\tuid1\tuid2\tuid3\tentry_point\t"
            "code_address\tcode_size\tdata_size\tbss_size\texport_count\texport_address\tfile\n" +
            "\n".join(target_rows) + ("\n" if target_rows else ""),
            encoding="utf-8",
        )
        Path("firmware-input/ROM_EXPORTS.tsv").write_text(
            "module\tordinal\taddress\tthumb\n" + "\n".join(export_rows) +
            ("\n" if export_rows else ""), encoding="utf-8"
        )
        report.append(f"rom_directory_entries={len(directory_rows)}")
        report.append(f"target_modules={len(target_rows)}")
        report.append(f"export_rows={len(export_rows)}")
        report.extend("ERROR " + e for e in errors[:100])
    else:
        hits = []
        for pos in range(0, len(data) - 4, 4):
            if data[pos:pos + 4] == base_word:
                hits.append(pos)
        report.append("rom_base_word_offsets=" + ",".join(f"0x{x:X}" for x in hits[:100]))
        report.append("No structurally valid TRomHeader found; EPOC scan follows.")
        epoc_hits = []
        pos = 0
        while True:
            pos = data.find(b"EPOC", pos)
            if pos < 0:
                break
            header_off = pos - 0x10
            if header_off >= 0 and header_off + 0x40 <= len(data):
                uid1 = u32(data, header_off)
                if uid1 in (0x10000079, 0x1000007A):
                    epoc_hits.append((header_off, uid1, u32(data, header_off + 4), u32(data, header_off + 8)))
            pos += 4
        report.append(f"valid_E32_headers={len(epoc_hits)}")
        for off, uid1, uid2, uid3 in epoc_hits[:200]:
            report.append(f"E32 0x{off:08X} {uid1:08X} {uid2:08X} {uid3:08X}")

text = "\n".join(report) + "\n"
out.write_text(text, encoding="utf-8")
print(text, end="")
