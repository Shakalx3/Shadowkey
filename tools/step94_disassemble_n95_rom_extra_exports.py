#!/usr/bin/env python3
"""Disassemble ROM-only exports that have no matching pinned SDK DSO symbol."""
import argparse
import csv
import json
import re
import subprocess
from pathlib import Path

FOCUS = {
    "euser.dll", "cone.dll", "efsrv.dll", "eikcore.dll",
    "fbscli.dll", "gdi.dll", "ws32.dll",
}


def read_tsv(path):
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter="\t"))


def disassemble(objdump, module_file, header_va, start_va, stop_va, mode):
    p = subprocess.run([
        str(objdump), "-D", "-b", "binary", "-m", "arm", "-M", mode,
        f"--adjust-vma=0x{header_va:X}",
        f"--start-address=0x{start_va:X}",
        f"--stop-address=0x{stop_va:X}",
        str(module_file),
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if p.returncode:
        return "ERROR: " + p.stderr.strip()
    return p.stdout.strip()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom-dir", type=Path, required=True)
    ap.add_argument("--objdump", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--tsv", type=Path, required=True)
    args = ap.parse_args()

    modules = read_tsv(args.rom_dir / "ROM_TARGET_MODULES.tsv")
    exports = read_tsv(args.rom_dir / "ROM_EXPORTS.tsv")
    sdk_map = read_tsv(args.rom_dir / "ROM_SDK_EXPORT_MAP.tsv")
    module_meta = {
        Path(r["path"].split("/")[-1]).name.lower(): r
        for r in modules
    }
    sdk_symbols = {
        (r["module"].lower(), int(r["ordinal"])): r.get("sdk_symbol", "")
        for r in sdk_map
    }
    exports_by_module = {}
    for row in exports:
        exports_by_module.setdefault(row["module"].lower(), []).append(row)

    out = [
        "Step94 — N95 ROM-only export disassembly",
        "These exports exist in the reconstructed RM-320 ROM but have no named entry in the pinned S60 3.1 FP1 SDK DSO map.",
        "Disassembly is evidence for later identification, not a symbol name or proof of API equivalence.",
        "",
    ]
    tsv_rows = []
    errors = []
    module_counts = {}
    string_patterns = [
        b"TInt64", b"TTrap", b"TUint64", b"TPtrC16",
        b"RThread", b"CBase", b"TFontSpec", b"RSubSessionBase",
    ]

    for module in sorted(FOCUS):
        meta = module_meta.get(module)
        if not meta:
            errors.append({"module": module, "error": "module metadata missing"})
            continue
        module_file = Path(meta["file"])
        if not module_file.is_file():
            errors.append({"module": module, "error": f"module file missing: {module_file}"})
            continue
        data = module_file.read_bytes()
        code_base = int(meta["code_address"], 16)
        header_va = int(meta["header_va"], 16)
        module_exports = exports_by_module.get(module, [])
        extras = [
            r for r in module_exports
            if not sdk_symbols.get((module, int(r["ordinal"])), "")
        ]
        all_addresses = sorted({
            int(r["address"], 16) & ~1 for r in module_exports
        })
        module_counts[module] = len(extras)
        out.append(f"=== {module.upper()} ({len(extras)} ROM-only exports) ===")
        out.append(f"module_file={module_file} bytes={len(data)} code_base=0x{code_base:08X} header_va=0x{header_va:08X}")

        hits = []
        for pat in string_patterns:
            for m in re.finditer(re.escape(pat), data):
                hits.append((m.start(), pat.decode("ascii")))
        if hits:
            out.append("embedded type/name strings:")
            out.extend(f"  fileoff=0x{off:X} {name}" for off, name in hits[:80])
        else:
            out.append("embedded type/name strings: none of the selected names found")

        for row in sorted(extras, key=lambda r: int(r["ordinal"])):
            ordinal = int(row["ordinal"])
            va = int(row["address"], 16)
            code_va = va & ~1
            thumb = int(row["thumb"])
            file_off = 0x78 + (code_va - code_base)
            if file_off < 0 or file_off >= len(data):
                error = f"export VA 0x{va:08X} maps outside module file at 0x{file_off:X}"
                errors.append({"module": module, "ordinal": ordinal, "error": error})
                out.append(f"  #{ordinal}: ERROR {error}")
                tsv_rows.append([module, ordinal, f"0x{va:08X}", thumb, file_off, "", "ERROR"])
                continue

            later = [a for a in all_addresses if a > code_va]
            next_va = min(later) if later else code_base + len(data)
            next_file_off = 0x78 + (next_va - code_base)
            stop_file_off = min(len(data), file_off + 64)
            if next_file_off > file_off:
                stop_file_off = min(stop_file_off, next_file_off)
            if stop_file_off <= file_off:
                stop_file_off = min(len(data), file_off + 8)
            start_va = header_va + file_off
            stop_va = header_va + stop_file_off
            mode = "force-thumb" if thumb else "arm"
            sample = data[file_off:min(file_off + 24, len(data))]
            dis = disassemble(args.objdump, module_file, header_va, start_va, stop_va, mode)
            out.append(f"  #{ordinal} VA=0x{va:08X} thumb={thumb} fileoff=0x{file_off:X} bytes={sample.hex(' ')}")
            out.append(f"  disassembly ({mode}):")
            out.extend("    " + line for line in dis.splitlines())
            tsv_rows.append([
                module, ordinal, f"0x{va:08X}", thumb, file_off,
                sample.hex(), mode, dis.replace("\n", " | "),
            ])
        out.append("")

    with args.tsv.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, delimiter="\t", lineterminator="\n")
        w.writerow(["module", "ordinal", "rom_address", "thumb", "file_offset", "sample_hex", "mode", "disassembly"])
        w.writerows(tsv_rows)
    report = {
        "focus_modules": sorted(FOCUS),
        "rom_only_export_counts": module_counts,
        "total_rom_only_exports": sum(module_counts.values()),
        "errors": errors,
        "result": "PASS" if not errors else "PARTIAL",
    }
    args.out.write_text("\n".join(out) + "\n", encoding="utf-8")
    args.rom_dir.joinpath("STEP94_ROM_ONLY_EXPORTS_SUMMARY.json").write_text(
        json.dumps(report, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(report, indent=2))
    if errors:
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
