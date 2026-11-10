#!/usr/bin/env python3
"""Independently parse ELF32 ARM S60 DSO dynsym tables and verify ordinals.

S60 3.1 FP1 SDK DSOs use a Symbian-specific file-offset model for dynamic
pointers: PT_DYNAMIC has p_vaddr == 0 and DT_SYMTAB/DT_STRTAB/DT_HASH values
match section file offsets, while the only PT_LOAD maps ER_RO code. Therefore
these pointers must not be forced through PT_LOAD VA translation.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import struct
from collections import defaultdict
from pathlib import Path

ET_DYN = 3
PT_LOAD = 1
PT_DYNAMIC = 2
STB_GLOBAL = 1
STV_DEFAULT = 0
SHN_UNDEF = 0
ELF_MAGIC = bytes((127, 69, 76, 70))
NUL = bytes((0,))


def cstr(table: bytes, offset: int) -> str:
    if offset < 0 or offset >= len(table):
        return ""
    end = table.find(NUL, offset)
    if end < 0:
        end = len(table)
    return table[offset:end].decode("utf-8", errors="replace")


def parse_sections(data: bytes, shoff: int, shentsize: int,
                   shnum: int, shstrndx: int) -> dict[str, dict]:
    if not shoff or not shnum:
        return {}
    if shentsize != 40:
        raise ValueError(f"expected ELF32 section-header size 40, got {shentsize}")
    if shoff + shentsize * shnum > len(data):
        raise ValueError("section-header table extends beyond file")
    raw = [
        struct.unpack_from("<IIIIIIIIII", data, shoff + i * shentsize)
        for i in range(shnum)
    ]
    if shstrndx >= len(raw):
        raise ValueError(f"invalid e_shstrndx={shstrndx}")
    names_hdr = raw[shstrndx]
    names_off, names_size = names_hdr[4], names_hdr[5]
    if names_off + names_size > len(data):
        raise ValueError("section-name string table extends beyond file")
    names = data[names_off:names_off + names_size]
    result = {}
    for row in raw:
        name = cstr(names, row[0])
        if name:
            result[name] = {
                "type": row[1], "flags": row[2], "addr": row[3],
                "offset": row[4], "size": row[5], "link": row[6],
                "info": row[7], "addralign": row[8], "entsize": row[9],
            }
    return result


def parse_dso(path: Path) -> dict:
    data = path.read_bytes()
    if len(data) < 52 or data[:4] != ELF_MAGIC:
        raise ValueError("not an ELF file")
    ident = data[:16]
    if ident[4] != 1:
        raise ValueError(f"expected ELFCLASS32, got {ident[4]}")
    if ident[5] != 1:
        raise ValueError(f"expected little-endian ELF, got data encoding {ident[5]}")

    e_type, e_machine, _e_version = struct.unpack_from("<HHI", data, 16)
    phoff = struct.unpack_from("<I", data, 28)[0]
    shoff = struct.unpack_from("<I", data, 32)[0]
    e_flags = struct.unpack_from("<I", data, 36)[0]
    ehsize, phentsize, phnum, shentsize, shnum, shstrndx = struct.unpack_from(
        "<HHHHHH", data, 40
    )
    if e_type != ET_DYN:
        raise ValueError(f"expected ET_DYN (3), got {e_type}")
    if e_machine != 40:
        raise ValueError(f"expected EM_ARM (40), got {e_machine}")
    if ehsize < 52 or phentsize != 32 or phnum == 0:
        raise ValueError(
            f"unsupported ELF program table: ehsize={ehsize} "
            f"phentsize={phentsize} phnum={phnum}"
        )
    if phoff + phentsize * phnum > len(data):
        raise ValueError("program header table extends beyond file")

    phdrs = [
        struct.unpack_from("<IIIIIIII", data, phoff + i * phentsize)
        for i in range(phnum)
    ]
    loads = [p for p in phdrs if p[0] == PT_LOAD and p[4] > 0]
    dynamics = [p for p in phdrs if p[0] == PT_DYNAMIC]
    if not loads or not dynamics:
        raise ValueError(
            f"missing PT_LOAD/PT_DYNAMIC segments: loads={len(loads)} dynamic={len(dynamics)}"
        )

    load_summary = [
        {"offset": f"0x{p[1]:X}", "vaddr": f"0x{p[2]:X}",
         "filesz": f"0x{p[4]:X}", "memsz": f"0x{p[5]:X}",
         "flags": f"0x{p[6]:X}"}
        for p in loads
    ]
    dynamic_summary = [
        {"offset": f"0x{p[1]:X}", "vaddr": f"0x{p[2]:X}",
         "filesz": f"0x{p[4]:X}", "memsz": f"0x{p[5]:X}"}
        for p in dynamics
    ]
    sections = parse_sections(data, shoff, shentsize, shnum, shstrndx)

    tags = {}
    for dyn in dynamics:
        p_offset, p_filesz = dyn[1], dyn[4]
        if p_offset + p_filesz > len(data):
            raise ValueError("PT_DYNAMIC extends beyond file")
        if p_filesz % 8:
            raise ValueError(f"PT_DYNAMIC size is not a multiple of Elf32_Dyn: {p_filesz}")
        for off in range(p_offset, p_offset + p_filesz, 8):
            tag, value = struct.unpack_from("<iI", data, off)
            if tag == 0:
                break
            tags.setdefault(tag, value)

    for tag, label in ((5, "DT_STRTAB"), (6, "DT_SYMTAB"),
                       (10, "DT_STRSZ"), (11, "DT_SYMENT")):
        if tag not in tags:
            raise ValueError(f"missing {label} in PT_DYNAMIC")
    syment = tags[11]
    if syment != 16:
        raise ValueError(f"expected Elf32_Sym size 16, got {syment}")
    strsz = tags[10]

    # Standard ELF VA translation is preferred. In S60 DSOs, dynamic
    # pointers are zero-based file offsets because PT_LOAD maps only ER_RO.
    def resolve_pointer(value: int, size: int, label: str) -> tuple[int, str]:
        for p in loads:
            _kind, p_offset, p_vaddr, _paddr, p_filesz, _memsz, _flags, _align = p
            if value >= p_vaddr and value + size <= p_vaddr + p_filesz:
                off = p_offset + (value - p_vaddr)
                if off + size <= len(data):
                    return off, "PT_LOAD_VA"
        zero_based_symbian_dso = (
            all(p[2] == 0 for p in loads)
            and all(p[2] == 0 for p in dynamics)
        )
        if zero_based_symbian_dso and value + size <= len(data):
            return value, "SYMBIAN_DSO_FILE_OFFSET"
        raise ValueError(
            f"{label} pointer 0x{value:08X}+0x{size:X} is neither PT_LOAD-backed "
            f"nor a valid zero-based Symbian DSO file offset; "
            f"PT_LOAD={json.dumps(load_summary, separators=(',', ':'))}; "
            f"PT_DYNAMIC={json.dumps(dynamic_summary, separators=(',', ':'))}"
        )

    strtab_off, address_model = resolve_pointer(tags[5], strsz, "DT_STRTAB")
    if 4 in tags:
        hash_off, hash_model = resolve_pointer(tags[4], 8, "DT_HASH")
        nbucket, nchain = struct.unpack_from("<II", data, hash_off)
        if nchain == 0 or nchain > 100000:
            raise ValueError(f"invalid DT_HASH nchain={nchain}")
        hash_size = 8 + 4 * (nbucket + nchain)
        hash_off, hash_model = resolve_pointer(tags[4], hash_size, "DT_HASH")
        if hash_off + hash_size > len(data):
            raise ValueError("DT_HASH table extends beyond file")
        symbol_count = nchain
        hash_method = "DT_HASH"
    elif 0x6FFFFEF5 in tags:
        hash_off, hash_model = resolve_pointer(tags[0x6FFFFEF5], 16, "DT_GNU_HASH")
        nbuckets, symoffset, bloom_size, _bloom_shift = struct.unpack_from(
            "<IIII", data, hash_off
        )
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
    symtab_off, symtab_model = resolve_pointer(
        tags[6], symbol_count * syment, "DT_SYMTAB"
    )
    strtab = data[strtab_off:strtab_off + strsz]
    if len(strtab) != strsz:
        raise ValueError("truncated dynamic string table")
    symdata = data[symtab_off:symtab_off + symbol_count * syment]
    if len(symdata) != symbol_count * syment:
        raise ValueError("truncated dynamic symbol table")

    # S60 section headers independently confirm the dynamic file offsets.
    section_checks = {}
    for tag, section_name in ((4, ".hash"), (5, ".strtab"), (6, ".dynsym")):
        section = sections.get(section_name)
        if tag in tags and section:
            ok = tags[tag] == section["offset"]
            section_checks[section_name] = {
                "dynamic_value": f"0x{tags[tag]:X}",
                "section_offset": f"0x{section['offset']:X}",
                "match": ok,
            }
            if not ok:
                raise ValueError(
                    f"DT_{section_name[1:].upper()} value 0x{tags[tag]:X} "
                    f"does not match {section_name} file offset 0x{section['offset']:X}"
                )
    dynsym_section = sections.get(".dynsym", {})
    if dynsym_section:
        if dynsym_section.get("type") != 11:
            raise ValueError(".dynsym section does not have SHT_DYNSYM type")
        if dynsym_section.get("entsize") not in (0, syment):
            raise ValueError("SHT_DYNSYM sh_entsize does not match DT_SYMENT")
        if dynsym_section.get("size") not in (0, len(symdata)):
            raise ValueError("SHT_DYNSYM sh_size does not match DT_HASH symbol count")

    ordinal_names: dict[int, list[str]] = defaultdict(list)
    unaligned = []
    ignored = {"undefined": 0, "non_global": 0, "non_default": 0, "empty_name": 0}
    for off in range(0, len(symdata), syment):
        st_name, st_value, _st_size, st_info, st_other, st_shndx = struct.unpack_from(
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
        str(ordinal): names for ordinal, names in ordinal_names.items()
        if len(set(names)) > 1
    }
    return {
        "sha256": hashlib.sha256(data).hexdigest(),
        "file_size": len(data),
        "elf_type": e_type,
        "machine": e_machine,
        "e_flags": f"0x{e_flags:08X}",
        "eabi_version": (e_flags >> 24) & 0xFF,
        "section_header_entry_size": shentsize,
        "section_header_count": shnum,
        "symbol_source": "PT_DYNAMIC",
        "address_model": address_model,
        "symtab_address_model": symtab_model,
        "hash_address_model": hash_model,
        "hash_method": hash_method,
        "symbol_rows": symbol_count,
        "export_count": len(canonical),
        "exports": canonical,
        "duplicate_ordinals": duplicates,
        "unaligned_global_defined": unaligned,
        "ignored": ignored,
        "section_checks": section_checks,
        "dynsym_section": dynsym_section,
    }


def read_tsv(path: Path) -> list[dict]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter=chr(9)))


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
            "address_model": parsed["address_model"],
            "hash_method": parsed["hash_method"],
            "symbol_rows": parsed["symbol_rows"],
            "direct_export_count": len(direct),
            "readelf_export_count": expected_count,
            "count_match": count_ok,
            "mapping_mismatches": len(module_mismatches),
            "duplicate_ordinals": parsed["duplicate_ordinals"],
            "unaligned_global_defined_count": len(parsed["unaligned_global_defined"]),
            "ignored": parsed["ignored"],
            "section_checks": parsed["section_checks"],
            "status": status,
        })

    report = {
        "method": "Independent ELF32 little-endian PT_DYNAMIC/DT_HASH parser with Symbian DSO file-offset handling",
        "ordinal_rule": "st_value / 4 + 1 for defined GLOBAL DEFAULT word-aligned symbols",
        "modules_checked": len(modules),
        "modules_passed": sum(1 for m in modules if m.get("status") == "PASS"),
        "modules_with_mismatches": sum(1 for m in modules if m.get("status") == "MISMATCH"),
        "parse_errors": structural_errors,
        "mapping_mismatch_count": len(mismatches),
        "modules": modules,
        "mismatches": mismatches,
        "result": "PASS" if not structural_errors and not mismatches else "MISMATCH",
    }
    out_json = args.rom_dir / "STEP92_DSO_DYNSYM_VALIDATION.json"
    out_json.write_text(json.dumps(report, indent=2) + chr(10), encoding="utf-8")

    with (args.rom_dir / "STEP92_DSO_DYNSYM_MODULES.tsv").open("w", encoding="utf-8") as f:
        f.write("module	sha256	e_flags	eabi_version	address_model	direct_export_count	readelf_export_count	mapping_mismatches	duplicate_ordinals	unaligned_count	status" + chr(10))
        for m in modules:
            f.write(chr(9).join([
                m.get("module", ""), m.get("sha256", ""), m.get("e_flags", ""),
                str(m.get("eabi_version", "")), m.get("address_model", ""),
                str(m.get("direct_export_count", "")), str(m.get("readelf_export_count", "")),
                str(m.get("mapping_mismatches", "")),
                json.dumps(m.get("duplicate_ordinals", {}), separators=(",", ":")),
                str(m.get("unaligned_global_defined_count", "")), m.get("status", ""),
            ]) + chr(10))
    with (args.rom_dir / "STEP92_DSO_DYNSYM_MISMATCHES.tsv").open("w", encoding="utf-8") as f:
        f.write("module	ordinal	readelf_symbol	direct_dynsym_symbol" + chr(10))
        for row in mismatches:
            f.write(chr(9).join(str(row[k]) for k in
                               ("module", "ordinal", "readelf_symbol", "direct_dynsym_symbol")) + chr(10))

    print(json.dumps({k: report[k] for k in (
        "modules_checked", "modules_passed", "modules_with_mismatches",
        "parse_errors", "mapping_mismatch_count", "result"
    )}, indent=2))
    if structural_errors:
        return 2
    if mismatches:
        return 3
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
