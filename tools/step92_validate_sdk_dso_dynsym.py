#!/usr/bin/env python3
"""Independently parse ELF32 ARM DSO .dynsym tables and verify Step80 ordinals.

This deliberately avoids readelf for symbol enumeration. Symbian DSO export
ordinals are derived as st_value / 4 + 1 for defined GLOBAL DEFAULT symbols
whose st_value is word-aligned. Duplicate ordinal aliases are retained in the
report; the canonical comparison value is the last symbol in dynsym order,
matching the prior readelf-based dictionary construction.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import struct
from collections import defaultdict
from pathlib import Path

SHT_DYNSYM = 11
SHT_STRTAB = 3
STB_GLOBAL = 1
STV_DEFAULT = 0
SHN_UNDEF = 0


def cstr(table: bytes, offset: int) -> str:
    if offset < 0 or offset >= len(table):
        return ""
    end = table.find(b"\0", offset)
    if end < 0:
        end = len(table)
    return table[offset:end].decode("utf-8", errors="replace")


def parse_dso(path: Path) -> dict:
    data = path.read_bytes()
    if len(data) < 52 or data[:4] != b"\x7fELF":
        raise ValueError("not an ELF file")
    ident = data[:16]
    if ident[4] != 1:
        raise ValueError(f"expected ELFCLASS32, got {ident[4]}")
    if ident[5] != 1:
        raise ValueError(f"expected little-endian ELF, got data encoding {ident[5]}")

    e_type, e_machine, e_version = struct.unpack_from("<HHI", data, 16)
    e_shoff = struct.unpack_from("<I", data, 32)[0]
    e_flags = struct.unpack_from("<I", data, 36)[0]
    e_ehsize, e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHHH", data, 40)
    if e_machine != 40:
        raise ValueError(f"expected EM_ARM (40), got {e_machine}")
    if e_ehsize < 52 or e_shentsize != 40 or e_shnum == 0:
        raise ValueError(
            f"unsupported ELF section table: ehsize={e_ehsize} "
            f"shentsize={e_shentsize} shnum={e_shnum}"
        )
    if e_shoff + e_shentsize * e_shnum > len(data):
        raise ValueError("section header table extends beyond file")
    if e_shstrndx >= e_shnum:
        raise ValueError(f"invalid e_shstrndx {e_shstrndx}")

    sections = [
        struct.unpack_from("<IIIIIIIIII", data, e_shoff + i * e_shentsize)
        for i in range(e_shnum)
    ]
    shstr = sections[e_shstrndx]
    if shstr[1] != SHT_STRTAB:
        raise ValueError("section-name table is not SHT_STRTAB")
    shstr_data = data[shstr[4]:shstr[4] + shstr[5]]
    if len(shstr_data) != shstr[5]:
        raise ValueError("truncated section-name string table")

    dynsyms = []
    for index, sec in enumerate(sections):
        name = cstr(shstr_data, sec[0])
        if sec[1] != SHT_DYNSYM:
            continue
        link = sec[6]
        entsize = sec[9] or 16
        if link >= len(sections) or sections[link][1] != SHT_STRTAB:
            raise ValueError(f"{name or index}: invalid linked dynamic string table")
        if entsize != 16 or sec[5] % entsize:
            raise ValueError(f"{name or index}: unsupported Elf32_Sym entry size {entsize}")
        symstr_sec = sections[link]
        symstr = data[symstr_sec[4]:symstr_sec[4] + symstr_sec[5]]
        if len(symstr) != symstr_sec[5]:
            raise ValueError(f"{name or index}: truncated dynamic string table")
        symdata = data[sec[4]:sec[4] + sec[5]]
        if len(symdata) != sec[5]:
            raise ValueError(f"{name or index}: truncated dynamic symbol table")
        dynsyms.append((name or f"section-{index}", symdata, symstr, entsize))

    if not dynsyms:
        raise ValueError("no SHT_DYNSYM section found")

    ordinal_names: dict[int, list[str]] = defaultdict(list)
    unaligned = []
    ignored = {"undefined": 0, "non_global": 0, "non_default": 0, "empty_name": 0}
    symbol_rows = 0
    for section_name, symdata, symstr, entsize in dynsyms:
        for off in range(0, len(symdata), entsize):
            st_name, st_value, st_size, st_info, st_other, st_shndx = struct.unpack_from(
                "<IIIBBH", symdata, off
            )
            symbol_rows += 1
            if st_shndx == SHN_UNDEF:
                ignored["undefined"] += 1
                continue
            if (st_info >> 4) != STB_GLOBAL:
                ignored["non_global"] += 1
                continue
            if (st_other & 0x3) != STV_DEFAULT:
                ignored["non_default"] += 1
                continue
            name = cstr(symstr, st_name).split("@@", 1)[0]
            if not name:
                ignored["empty_name"] += 1
                continue
            if st_value & 3:
                unaligned.append({"section": section_name, "name": name, "value": f"0x{st_value:08X}"})
                continue
            ordinal_names[st_value // 4 + 1].append(name)

    canonical = {ordinal: names[-1] for ordinal, names in ordinal_names.items()}
    duplicates = {
        str(ordinal): names for ordinal, names in ordinal_names.items() if len(set(names)) > 1
    }
    return {
        "sha256": hashlib.sha256(data).hexdigest(),
        "file_size": len(data),
        "elf_type": e_type,
        "machine": e_machine,
        "e_flags": f"0x{e_flags:08X}",
        "eabi_version": (e_flags >> 24) & 0xFF,
        "dynsym_sections": [x[0] for x in dynsyms],
        "symbol_rows": symbol_rows,
        "export_count": len(canonical),
        "exports": canonical,
        "duplicate_ordinals": duplicates,
        "unaligned_global_defined": unaligned,
        "ignored": ignored,
    }


def read_tsv(path: Path) -> list[dict]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter="\t"))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sdk-root", type=Path, required=True)
    ap.add_argument("--rom-dir", type=Path, required=True)
    args = ap.parse_args()

    libdir = args.sdk_root / "Epoc32/release/armv5/lib"
    expected_rows = read_tsv(args.rom_dir / "ROM_SDK_EXPORT_MAP.tsv")
    count_rows = read_tsv(args.rom_dir / "ROM_SDK_EXPORT_COUNTS.tsv")
    expected: dict[str, dict[int, str]] = defaultdict(dict)
    for row in expected_rows:
        name = row["module"].lower()
        if row.get("sdk_symbol"):
            expected[name][int(row["ordinal"])] = row["sdk_symbol"]

    count_meta = {r["module"].lower(): r for r in count_rows}
    modules = []
    mismatches = []
    structural_errors = []
    for name, meta in sorted(count_meta.items()):
        if meta.get("status") == "DSO_MISSING":
            continue
        path = libdir / name.removesuffix(".dll")
        path = path.with_suffix(".dso")
        try:
            parsed = parse_dso(path)
        except Exception as exc:
            structural_errors.append({"module": name, "error": f"{type(exc).__name__}: {exc}"})
            modules.append({
                "module": name, "status": "PARSE_ERROR", "path": str(path),
                "error": f"{type(exc).__name__}: {exc}",
            })
            continue

        direct = parsed["exports"]
        prior = expected.get(name, {})
        module_mismatches = []
        for ordinal in sorted(set(direct) | set(prior)):
            a, b = prior.get(ordinal), direct.get(ordinal)
            if a != b:
                item = {
                    "module": name, "ordinal": ordinal,
                    "readelf_symbol": a or "", "direct_dynsym_symbol": b or "",
                }
                mismatches.append(item)
                module_mismatches.append(item)

        expected_count = int(meta["sdk_dso_export_count"])
        count_ok = len(direct) == expected_count
        status = "PASS" if count_ok and not module_mismatches else "MISMATCH"
        modules.append({
            "module": name,
            "sha256": parsed["sha256"],
            "file_size": parsed["file_size"],
            "e_flags": parsed["e_flags"],
            "eabi_version": parsed["eabi_version"],
            "dynsym_sections": parsed["dynsym_sections"],
            "symbol_rows": parsed["symbol_rows"],
            "direct_export_count": len(direct),
            "readelf_export_count": expected_count,
            "count_match": count_ok,
            "mapping_mismatches": len(module_mismatches),
            "duplicate_ordinals": parsed["duplicate_ordinals"],
            "unaligned_global_defined_count": len(parsed["unaligned_global_defined"]),
            "ignored": parsed["ignored"],
            "status": status,
        })

    report = {
        "method": "Independent ELF32 little-endian section/dynsym parser; no readelf symbol parsing",
        "ordinal_rule": "st_value / 4 + 1 for defined GLOBAL DEFAULT word-aligned symbols",
        "modules_checked": len(modules),
        "modules_passed": sum(1 for m in modules if m.get("status") == "PASS"),
        "modules_with_mismatches": sum(1 for m in modules if m.get("status") == "MISMATCH"),
        "parse_errors": structural_errors,
        "mapping_mismatch_count": len(mismatches),
        "modules": modules,
        "result": "PASS" if not structural_errors and not mismatches else "MISMATCH",
    }
    out_json = args.rom_dir / "STEP92_DSO_DYNSYM_VALIDATION.json"
    out_json.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")

    with (args.rom_dir / "STEP92_DSO_DYNSYM_MODULES.tsv").open("w", encoding="utf-8") as f:
        f.write("module\tsha256\te_flags\teabi_version\tdirect_export_count\treadelf_export_count\tmapping_mismatches\tduplicate_ordinals\tunaligned_count\tstatus\n")
        for m in modules:
            f.write("\t".join([
                m.get("module", ""), m.get("sha256", ""), m.get("e_flags", ""),
                str(m.get("eabi_version", "")), str(m.get("direct_export_count", "")),
                str(m.get("readelf_export_count", "")), str(m.get("mapping_mismatches", "")),
                json.dumps(m.get("duplicate_ordinals", {}), separators=(",", ":")),
                str(m.get("unaligned_global_defined_count", "")), m.get("status", ""),
            ]) + "\n")
    with (args.rom_dir / "STEP92_DSO_DYNSYM_MISMATCHES.tsv").open("w", encoding="utf-8") as f:
        f.write("module\tordinal\treadelf_symbol\tdirect_dynsym_symbol\n")
        for row in mismatches:
            f.write("\t".join(str(row[k]) for k in
                               ("module", "ordinal", "readelf_symbol", "direct_dynsym_symbol")) + "\n")

    print(json.dumps({k: report[k] for k in (
        "modules_checked", "modules_passed", "modules_with_mismatches",
        "parse_errors", "mapping_mismatch_count", "result"
    )}, indent=2))
    return 0 if not structural_errors else 2


if __name__ == "__main__":
    raise SystemExit(main())
