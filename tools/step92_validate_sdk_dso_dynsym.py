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
    e_phoff = struct.unpack_from("<I", data, 28)[0]
    e_shoff = struct.unpack_from("<I", data, 32)[0]
    e_flags = struct.unpack_from("<I", data, 36)[0]
    e_ehsize, e_phentsize, e_phnum, e_shentsize, e_shnum, e_shstrndx = struct.unpack_from(
        "<HHHHHH", data, 40
    )
    if e_machine != 40:
        raise ValueError(f"expected EM_ARM (40), got {e_machine}")
    if e_ehsize < 52 or e_phentsize != 32 or e_phnum == 0:
        raise ValueError(
            f"unsupported ELF program table: ehsize={e_ehsize} "
            f"phentsize={e_phentsize} phnum={e_phnum}"
        )
    if e_phoff + e_phentsize * e_phnum > len(data):
        raise ValueError("program header table extends beyond file")

    phdrs = [
        struct.unpack_from("<IIIIIIII", data, e_phoff + i * e_phentsize)
        for i in range(e_phnum)
    ]
    loads = [p for p in phdrs if p[0] == 1 and p[4] > 0]  # PT_LOAD
    dynamics = [p for p in phdrs if p[0] == 2]           # PT_DYNAMIC
    if not loads or not dynamics:
        raise ValueError(f"missing PT_LOAD/PT_DYNAMIC segments: loads={len(loads)} dynamic={len(dynamics)}")

    load_summary = [
        {"offset": f"0x{p[1]:X}", "vaddr": f"0x{p[2]:X}", "filesz": f"0x{p[4]:X}", "memsz": f"0x{p[5]:X}", "flags": f"0x{p[6]:X}"}
        for p in loads
    ]

    def va_to_off(va: int, size: int) -> int:
        for p in loads:
            _, p_offset, p_vaddr, _p_paddr, p_filesz, _p_memsz, _p_flags, _p_align = p
            if va >= p_vaddr and va + size <= p_vaddr + p_filesz:
                off = p_offset + (va - p_vaddr)
                if off + size <= len(data):
                    return off
        raise ValueError(f"virtual range 0x{va:08X}+0x{size:X} is not file-backed by PT_LOAD; PT_LOAD={json.dumps(load_summary, separators=(chr(44), chr(58)))}")

    tags = {}
    for dyn in dynamics:
        p_offset, p_filesz = dyn[1], dyn[4]
        if p_offset + p_filesz > len(data):
            raise ValueError("PT_DYNAMIC extends beyond file")
        for off in range(p_offset, p_offset + p_filesz - 7, 8):
            tag, value = struct.unpack_from("<iI", data, off)
            if tag == 0:  # DT_NULL
                break
            tags.setdefault(tag, value)

    # Dynamic tags: HASH=4, STRTAB=5, SYMTAB=6, STRSZ=10, SYMENT=11,
    # GNU_HASH=0x6FFFFEF5.
    for tag, label in ((5, "DT_STRTAB"), (6, "DT_SYMTAB"), (10, "DT_STRSZ"), (11, "DT_SYMENT")):
        if tag not in tags:
            raise ValueError(f"missing {label} in PT_DYNAMIC")
    syment = tags[11]
    if syment != 16:
        raise ValueError(f"expected Elf32_Sym size 16, got {syment}")
    strsz = tags[10]
    strtab_off = va_to_off(tags[5], strsz)

    if 4 in tags:  # SysV DT_HASH: nbucket, nchain, buckets[], chains[].
        hash_off = va_to_off(tags[4], 8)
        nbucket, nchain = struct.unpack_from("<II", data, hash_off)
        if nchain == 0 or nchain > 100000:
            raise ValueError(f"invalid DT_HASH nchain={nchain}")
        if hash_off + 8 + 4 * (nbucket + nchain) > len(data):
            raise ValueError("DT_HASH table extends beyond file")
        symbol_count = nchain
        hash_method = "DT_HASH"
    elif 0x6FFFFEF5 in tags:  # GNU hash table, derive the last symbol index from chains.
        hash_off = va_to_off(tags[0x6FFFFEF5], 16)
        nbuckets, symoffset, bloom_size, bloom_shift = struct.unpack_from("<IIII", data, hash_off)
        if not nbuckets or not bloom_size or symoffset > 100000:
            raise ValueError("invalid DT_GNU_HASH header")
        buckets_off = hash_off + 16 + bloom_size * 4
        chains_off = buckets_off + nbuckets * 4
        if chains_off > len(data):
            raise ValueError("DT_GNU_HASH buckets extend beyond file")
        max_symbol = symoffset - 1
        for i in range(nbuckets):
            bucket = struct.unpack_from("<I", data, buckets_off + i * 4)[0]
            if bucket < symoffset:
                continue
            index = bucket
            while True:
                chain_off = chains_off + (index - symoffset) * 4
                if chain_off + 4 > len(data) or index > 100000:
                    raise ValueError("DT_GNU_HASH chain extends beyond file")
                value = struct.unpack_from("<I", data, chain_off)[0]
                max_symbol = max(max_symbol, index)
                if value & 1:
                    break
                index += 1
        symbol_count = max_symbol + 1
        hash_method = "DT_GNU_HASH"
    else:
        raise ValueError("neither DT_HASH nor DT_GNU_HASH is present")

    if symbol_count <= 0 or symbol_count > 100000:
        raise ValueError(f"invalid dynamic symbol count {symbol_count}")
    symtab_off = va_to_off(tags[6], symbol_count * syment)
    strtab = data[strtab_off:strtab_off + strsz]
    if len(strtab) != strsz:
        raise ValueError("truncated dynamic string table")
    symdata = data[symtab_off:symtab_off + symbol_count * syment]
    if len(symdata) != symbol_count * syment:
        raise ValueError("truncated dynamic symbol table")

    ordinal_names: dict[int, list[str]] = defaultdict(list)
    unaligned = []
    ignored = {"undefined": 0, "non_global": 0, "non_default": 0, "empty_name": 0}
    for off in range(0, len(symdata), syment):
        st_name, st_value, st_size, st_info, st_other, st_shndx = struct.unpack_from(
            "<IIIBBH", symdata, off
        )
        if st_shndx == SHN_UNDEF:
            ignored["undefined"] += 1
            continue
        if (st_info >> 4) != STB_GLOBAL:
            ignored["non_global"] += 1
            continue
        if (st_other & 0x3) != STV_DEFAULT:
            ignored["non_default"] += 1
            continue
        name = cstr(strtab, st_name).split("@@", 1)[0]
        if not name:
            ignored["empty_name"] += 1
            continue
        if st_value & 3:
            unaligned.append({"name": name, "value": f"0x{st_value:08X}"})
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
        "section_header_entry_size": e_shentsize,
        "section_header_count": e_shnum,
        "symbol_source": "PT_DYNAMIC",
        "hash_method": hash_method,
        "symbol_rows": symbol_count,
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
