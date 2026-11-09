#!/usr/bin/env python3
"""Compare N-Gage BTENG import-library ordinals with the N95 ROM BTENG exports."""
import argparse
import csv
import re
import subprocess
from pathlib import Path

def read_tsv(path):
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter="\t"))

def run(cmd, **kwargs):
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, **kwargs)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sdk-root", type=Path, required=True)
    ap.add_argument("--rom-dir", type=Path, required=True)
    ap.add_argument("--epoc-demangler", type=Path)
    ap.add_argument("--objdump", type=Path)
    args = ap.parse_args()

    lib = args.sdk_root / "6.1/Series60/Epoc32/Release/armi/urel/bteng.lib"
    out = []
    out.append("N-Gage SDK BTENG import library vs N95 ROM BTENG")
    out.append(f"SDK library: {lib}")
    if not lib.exists():
        out.append("BTENG import library is missing from the N-Gage SDK checkout")
        (args.rom_dir / "STEP85_BTENG_ORDINAL_COMPATIBILITY.txt").write_text("\n".join(out)+"\n", encoding="utf-8")
        print("\n".join(out))
        return

    members = run(["ar", "t", str(lib)])
    if members.returncode:
        raise RuntimeError(members.stderr)
    names = members.stdout.splitlines()
    ordinals = sorted({int(m.group(1)) for name in names if (m := re.fullmatch(r"ds(\d+)\.o", name, re.I))})
    out.append(f"archive bytes: {lib.stat().st_size}")
    out.append(f"archive members: {len(names)}")
    out.append(f"ordinal members: {len(ordinals)}")
    out.append(f"ordinal range: {min(ordinals) if ordinals else '-'}..{max(ordinals) if ordinals else '-'}")
    if ordinals:
        missing = sorted(set(range(1, max(ordinals)+1)) - set(ordinals))
        out.append(f"missing ordinal members in 1..max: {missing}")

    modules = read_tsv(args.rom_dir / "ROM_TARGET_MODULES.tsv")
    bteng = next((r for r in modules if r["path"].split("/")[-1].lower() == "bteng.dll"), None)
    exports = read_tsv(args.rom_dir / "ROM_EXPORTS.tsv")
    bteng_exports = {int(r["ordinal"]): r for r in exports if r["module"].lower() == "bteng.dll"}
    if not bteng:
        out.append("N95 ROM BTENG module not found")
        (args.rom_dir / "STEP85_BTENG_ORDINAL_COMPATIBILITY.txt").write_text("\n".join(out)+"\n", encoding="utf-8")
        print("\n".join(out))
        return

    out.append(f"N95 BTENG UID3: {bteng['uid3']}")
    out.append(f"N95 BTENG export count: {bteng['export_count']}")
    out.append(f"N95 BTENG code VA: {bteng['code_address']}")
    out.append(f"N95 BTENG module file: {bteng['file']}")
    out.append(f"ordinal-range-count-equal: {bool(ordinals) and max(ordinals) == int(bteng['export_count'])}")
    lib_bytes = lib.read_bytes()
    uid_bytes = int(bteng["uid3"], 16).to_bytes(4, "little")
    out.append(f"target UID3 byte sequence occurs in import library: {lib_bytes.find(uid_bytes) >= 0}")

    imports_path = args.rom_dir / "STEP46_GAMECOMMS_ARM_IMPORTS.tsv"
    imports = [r for r in read_tsv(imports_path) if r["dll"].lower() == "bteng"]
    gamecomms_csv = args.rom_dir / "GAMECOMMS_DLL_import_thunks.csv"
    import_uid3 = ""
    if gamecomms_csv.exists():
        with gamecomms_csv.open(newline="", encoding="utf-8") as f:
            for row in csv.DictReader(f):
                dep = row.get("dependency", "")
                m = re.match(r"BTENG\[([0-9a-fA-F]+)\]\.DLL$", dep, re.I)
                if m:
                    import_uid3 = m.group(1).upper()
                    break
    target_uid3 = bteng["uid3"].replace("0x", "").upper()
    uid_match = bool(import_uid3 and import_uid3 == target_uid3)
    ordinal_max = max(ordinals) if ordinals else 0
    target_export_count = int(bteng["export_count"])
    compatibility = {
        "bteng_import_uid3": import_uid3,
        "n95_rom_uid3": target_uid3,
        "uid_match": uid_match,
        "ngage_import_library_ordinal_count": len(ordinals),
        "ngage_import_library_max_ordinal": ordinal_max,
        "n95_rom_export_count": target_export_count,
        "ordinal_range_compatible": bool(ordinal_max and ordinal_max <= target_export_count),
        "same_uid_ordinal_candidate": bool(uid_match and ordinal_max and ordinal_max <= target_export_count),
        "used_bteng_import_ordinals": sorted({int(r["ordinal"]) for r in imports}),
    }
    (args.rom_dir / "STEP85_BTENG_ORDINAL_COMPATIBILITY.json").write_text(
        __import__("json").dumps(compatibility, indent=2) + "\n", encoding="utf-8"
    )
    out.append(f"GAMECOMMS BTENG import UID3: {import_uid3 or 'not found'}")
    out.append(f"BTENG import UID3 matches N95 ROM UID3: {uid_match}")
    out.append(f"Ordinal-range compatible: {compatibility['ordinal_range_compatible']}")
    demangled = {}
    if args.epoc_demangler and imports:
        symbols = [r["arm_urel_symbol"] for r in imports if r["arm_urel_symbol"] and r["arm_urel_symbol"] != "<no archive-index symbol>"]
        if symbols:
            p = run([str(args.epoc_demangler)], input="\n".join(symbols)+"\n")
            if p.returncode == 0:
                demangled = dict(zip(symbols, p.stdout.splitlines()))

    module_file = Path(bteng["file"])
    code_base = int(bteng["code_address"], 16)
    header_va = int(bteng["header_va"], 16)
    code_size = int(bteng["code_size"])
    out.append("")
    out.append("Imported BTENG functions and same-ordinal N95 candidates:")
    for r in imports:
        ordinal = int(r["ordinal"])
        exp = bteng_exports.get(ordinal)
        sig = demangled.get(r["arm_urel_symbol"], "")
        if not exp:
            out.append(f"  old #{ordinal}: {r['arm_urel_symbol']} {sig} -> no N95 export at same ordinal")
            continue
        va = int(exp["address"], 16)
        thumb = int(exp["thumb"])
        file_off = 0x78 + ((va & ~1) - code_base)
        sample = ""
        if module_file.exists() and 0 <= file_off < module_file.stat().st_size:
            with module_file.open("rb") as f:
                f.seek(file_off)
                sample = f.read(32).hex(" ")
        out.append(f"  old #{ordinal}: {r['arm_urel_symbol']} {sig}")
        out.append(f"      N95 same-ordinal candidate: {exp['address']} thumb={thumb} fileoff=0x{file_off:X} bytes={sample}")
        if args.objdump and module_file.exists() and code_base <= (va & ~1) < code_base + code_size:
            start = header_va + file_off
            stop = min(start + 64, header_va + module_file.stat().st_size)
            mode = "force-thumb" if thumb else "arm"
            dis = run([
                str(args.objdump), "-D", "-b", "binary", "-m", "arm", "-M", mode,
                f"--adjust-vma=0x{header_va:X}", f"--start-address=0x{start:X}",
                f"--stop-address=0x{stop:X}", str(module_file)
            ])
            if dis.returncode == 0:
                out.append("      disassembly:")
                out.extend("        " + line for line in dis.stdout.splitlines()[:18])
            else:
                out.append("      objdump error: " + dis.stderr.strip())

    if module_file.exists():
        data = module_file.read_bytes()
        out.append("")
        out.append("BTENG RTTI/type-name strings:")
        for name in (b"CBTMCMSettings", b"CBTEngDevMan", b"CBTConnection", b"CBTSdpQueryAlg", b"CBTSdpDbHandler", b"CBTBondingHandler", b"RBTDeviceHandler", b"RBTSecuritySettings"):
            pos = data.find(name)
            if pos >= 0:
                out.append(f"  {name.decode()}: file offset 0x{pos:X}")

    text = "\n".join(out) + "\n"
    (args.rom_dir / "STEP85_BTENG_ORDINAL_COMPATIBILITY.txt").write_text(text, encoding="utf-8")
    print(text)

if __name__ == "__main__":
    main()
