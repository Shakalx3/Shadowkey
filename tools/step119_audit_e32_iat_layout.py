#!/usr/bin/env python3
"""Audit E32 import/export offsets and IAT bounds under explicit interpretations."""
from __future__ import annotations
import argparse, json, struct
from collections import Counter
from pathlib import Path

DLL_UID = 0x10000079
EXE_UID = 0x1000007A
MAX_EXPORTS = 131072
MAX_DLL_REFS = 4096
MAX_IMPORTS = 1000000
HEADER_MIN = 0x7C

def u32(data, offset):
    if offset < 0 or offset + 4 > len(data):
        raise ValueError("u32 outside file at 0x%X" % offset)
    return struct.unpack_from("<I", data, offset)[0]

def parse_import_table(data, offset, dll_count):
    if dll_count == 0:
        return {"valid": offset == 0, "total_imports": 0, "names": [], "ordinals": [], "error": ""}
    if dll_count > MAX_DLL_REFS or offset < HEADER_MIN or offset > len(data) - 4:
        return {"valid": False, "total_imports": 0, "names": [], "ordinals": [], "error": "import offset/count outside bounds"}
    size = u32(data, offset)
    if size < 4 or size > len(data) - offset:
        return {"valid": False, "size": size, "total_imports": 0, "names": [], "ordinals": [], "error": "import table size outside file"}
    end, pos = offset + size, offset + 4
    names, ordinals = [], []
    for index in range(dll_count):
        if pos + 8 > end:
            return {"valid": False, "size": size, "total_imports": len(ordinals), "names": names, "ordinals": ordinals, "error": "descriptor %d exceeds import table" % index}
        name_rel, count = struct.unpack_from("<II", data, pos)
        if count > MAX_IMPORTS or len(ordinals) + count > MAX_IMPORTS:
            return {"valid": False, "size": size, "total_imports": len(ordinals), "names": names, "ordinals": ordinals, "error": "import count exceeds safety cap"}
        ord_end = pos + 8 + count * 4
        if ord_end > end:
            return {"valid": False, "size": size, "total_imports": len(ordinals), "names": names, "ordinals": ordinals, "error": "ordinal array %d exceeds import table" % index}
        name_off = offset + name_rel
        if name_off < offset or name_off >= end:
            return {"valid": False, "size": size, "total_imports": len(ordinals), "names": names, "ordinals": ordinals, "error": "DLL name offset %d outside import table" % index}
        name_end = data.find(b"\0", name_off, end)
        if name_end < 0:
            return {"valid": False, "size": size, "total_imports": len(ordinals), "names": names, "ordinals": ordinals, "error": "DLL name %d unterminated" % index}
        names.append(data[name_off:name_end].decode("ascii", "replace"))
        if count:
            ordinals.extend(struct.unpack_from("<" + "I" * count, data, pos + 8))
        pos = ord_end
    return {"valid": True, "size": size, "total_imports": len(ordinals), "names": names, "ordinals": ordinals, "error": ""}

def parse_export_table(data, offset, count, code_size):
    if count == 0:
        return {"valid": offset == 0, "valid_entries": 0, "invalid_entries": 0, "error": ""}
    if count > MAX_EXPORTS or offset < HEADER_MIN or offset > len(data) or count * 4 > len(data) - offset:
        return {"valid": False, "valid_entries": 0, "invalid_entries": 0, "error": "export table outside file"}
    good = bad = 0
    for index in range(count):
        raw = u32(data, offset + index * 4)
        if raw in (0, 0xFFFFFFFF) or (raw & ~1) < code_size:
            good += 1
        else:
            bad += 1
    return {"valid": bad == 0, "valid_entries": good, "invalid_entries": bad, "error": "" if bad == 0 else "%d export entries outside code size" % bad}

def resolve_modes(data, code_offset, field_offset, parser, *args):
    candidates = {"absolute": field_offset, "code_relative": code_offset + field_offset}
    results = {mode: {"offset": offset, **parser(data, offset, *args)} for mode, offset in candidates.items()}
    valid = [mode for mode, row in results.items() if row.get("valid")]
    preferred = valid[0] if len(valid) == 1 else ("AMBIGUOUS" if len(valid) == 2 else "NONE")
    return {"preferred": preferred, "results": results}

def inspect_image(data, path):
    row = {"path": path, "size": len(data), "status": "INVALID"}
    if len(data) < HEADER_MIN or data[0x10:0x14] != b"EPOC":
        row["reason"] = "missing EPOC signature or truncated header"
        return row
    f = {
        "uid1": u32(data,0), "uid2": u32(data,4), "uid3": u32(data,8),
        "compression": u32(data,0x1C), "flags": u32(data,0x2C),
        "code_size": u32(data,0x30), "data_size": u32(data,0x34),
        "entry_point": u32(data,0x48), "code_base": u32(data,0x4C),
        "data_base": u32(data,0x50), "dll_ref_count": u32(data,0x54),
        "export_dir_offset": u32(data,0x58), "export_count": u32(data,0x5C),
        "text_size": u32(data,0x60), "code_offset": u32(data,0x64),
        "data_offset": u32(data,0x68), "import_offset": u32(data,0x6C),
        "code_reloc_offset": u32(data,0x70), "data_reloc_offset": u32(data,0x74),
    }
    row.update(f)
    errors = []
    if f["uid1"] not in (DLL_UID, EXE_UID): errors.append("unsupported UID1")
    if bool(f["flags"] & 1) != (f["uid1"] == DLL_UID): errors.append("UID1/flags mismatch")
    code_off, code_size, text_size = f["code_offset"], f["code_size"], f["text_size"]
    code_end = code_off + code_size
    code_end_ok = code_off >= HEADER_MIN and code_size > 0 and code_end <= len(data)
    if not code_end_ok: errors.append("code range exceeds file/header")
    if text_size > code_size: errors.append("text size exceeds code size")
    if f["data_size"] and (f["data_offset"] > len(data) or f["data_size"] > len(data)-f["data_offset"]):
        errors.append("data range exceeds file")
    exports = resolve_modes(data, code_off, f["export_dir_offset"], parse_export_table, f["export_count"], code_size)
    imports = resolve_modes(data, code_off, f["import_offset"], parse_import_table, f["dll_ref_count"])
    imp = imports["results"].get(imports["preferred"], imports["results"]["absolute"])
    total = imp.get("total_imports", 0)
    iat_start, iat_end = text_size, text_size + total * 4
    iat_fits = iat_end <= code_size
    iat_file_start, iat_file_end = code_off + iat_start, code_off + iat_end
    iat_file_bounded = iat_file_start <= len(data) and iat_file_end <= len(data)
    iat_match = None
    if imports["preferred"] not in ("NONE","AMBIGUOUS") and iat_fits and iat_file_bounded:
        expected = imp.get("ordinals", [])
        actual = list(struct.unpack_from("<" + "I"*len(expected), data, iat_file_start)) if expected else []
        iat_match = actual == expected
    abs_imp, abs_exp = imports["results"]["absolute"], exports["results"]["absolute"]
    row.update({
        "code_end": code_end, "code_end_ok": code_end_ok,
        "export_mode": exports["preferred"], "import_mode": imports["preferred"],
        "export_abs_valid": abs_exp.get("valid",False),
        "export_abs_valid_entries": abs_exp.get("valid_entries",0),
        "export_abs_invalid_entries": abs_exp.get("invalid_entries",0),
        "export_rel_valid": exports["results"]["code_relative"].get("valid",False),
        "import_abs_valid": abs_imp.get("valid",False),
        "import_rel_valid": imports["results"]["code_relative"].get("valid",False),
        "import_size": imp.get("size",0), "import_names": ";".join(imp.get("names",[])),
        "total_imports": total, "iat_start_in_code": iat_start, "iat_end_in_code": iat_end,
        "iat_fits_code": iat_fits, "iat_file_bounded": iat_file_bounded,
        "iat_values_match_ordinals": iat_match,
        "import_abs_error": abs_imp.get("error",""),
        "import_rel_error": imports["results"]["code_relative"].get("error",""),
        "export_abs_error": abs_exp.get("error",""),
        "export_rel_error": exports["results"]["code_relative"].get("error",""),
    })
    if imports["preferred"] == "NONE": errors.append("no import offset interpretation parses")
    if imports["preferred"] == "AMBIGUOUS": errors.append("import offset interpretations ambiguous")
    if exports["preferred"] == "NONE": errors.append("no export offset interpretation parses")
    if exports["preferred"] == "AMBIGUOUS": errors.append("export offset interpretations ambiguous")
    if not iat_fits: errors.append("IAT byte range exceeds code size")
    if not iat_file_bounded: errors.append("IAT byte range exceeds file")
    if iat_match is False: errors.append("IAT values differ from import ordinals")
    row["reason"] = "; ".join(errors)
    row["status"] = "STRUCTURAL_CANDIDATE" if not errors else "NEEDS_LAYOUT_REVIEW"
    return row

def self_test():
    def fixture(relative):
        data = bytearray(0xEA)
        struct.pack_into("<III",data,0,DLL_UID,0x1000008D,0xE0001190)
        data[0x10:0x14] = b"EPOC"
        struct.pack_into("<I",data,0x2C,1)
        struct.pack_into("<II",data,0x30,0x30,0)
        struct.pack_into("<II",data,0x48,0,0x10000000)
        struct.pack_into("<I",data,0x50,0x10010000)
        struct.pack_into("<I",data,0x54,1)
        struct.pack_into("<II",data,0x58,(0x20 if relative else 0xC0),1)
        struct.pack_into("<I",data,0x60,0x10)
        struct.pack_into("<I",data,0x64,0xA0)
        struct.pack_into("<I",data,0x6C,(0x30 if relative else 0xD0))
        struct.pack_into("<I",data,0xB0,7)
        struct.pack_into("<I",data,0xC0,4)
        struct.pack_into("<I",data,0xD0,26)
        struct.pack_into("<II",data,0xD4,16,1)
        struct.pack_into("<I",data,0xDC,7)
        data[0xE0:0xEA] = b"euser.dll\0"
        return bytes(data)
    a = inspect_image(fixture(False),"absolute.dll")
    assert a["export_mode"] == "absolute" and a["import_mode"] == "absolute", a
    assert a["iat_fits_code"] and a["iat_values_match_ordinals"], a
    b = inspect_image(fixture(True),"relative.dll")
    assert b["export_mode"] == "code_relative" and b["import_mode"] == "code_relative", b
    assert b["iat_fits_code"] and b["iat_values_match_ordinals"], b
    print("Step119 E32 offset/IAT self-tests: PASS (2/2)")

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--tree", type=Path, required=True)
    p.add_argument("--out", type=Path, required=True)
    p.add_argument("--self-test", action="store_true")
    a = p.parse_args()
    if a.self_test: self_test()
    if not a.tree.is_dir(): raise SystemExit("missing decompressed tree: %s" % a.tree)
    rows = []
    for path in sorted(a.tree.rglob("*")):
        if path.is_symlink() or not path.is_file(): continue
        try:
            with path.open("rb") as stream:
                stream.seek(0x10)
                if stream.read(4) != b"EPOC": continue
            rows.append(inspect_image(path.read_bytes(),path.relative_to(a.tree).as_posix()))
        except (OSError,ValueError,struct.error,OverflowError) as exc:
            rows.append({"path":path.relative_to(a.tree).as_posix(),"status":"READ_ERROR","reason":str(exc)})
    status = Counter(r.get("status","UNKNOWN") for r in rows)
    imodes = Counter(r.get("import_mode","UNKNOWN") for r in rows)
    emodes = Counter(r.get("export_mode","UNKNOWN") for r in rows)
    reasons = Counter(r.get("reason","") for r in rows if r.get("reason"))
    a.out.parent.mkdir(parents=True,exist_ok=True)
    a.out.with_suffix(".json").write_text(json.dumps({
        "candidate_count":len(rows),"status_counts":dict(status),
        "import_modes":dict(imodes),"export_modes":dict(emodes),
        "reason_counts":dict(reasons),"rows":rows
    },indent=2)+"\n",encoding="utf-8")
    lines = [
        "# Step119 — E32 import/export offset and IAT layout audit","",
        "- EPOC candidates: **%d**" % len(rows),
        "- Layout statuses: %s" % dict(status),
        "- Import offset interpretations: %s" % dict(imodes),
        "- Export offset interpretations: %s" % dict(emodes),
        "","## Common findings",""
    ]
    for reason,count in reasons.most_common(12):
        lines.append("- **%d file(s):** %s" % (count,reason))
    lines += ["","## Per-module header and IAT fields","","| Path | Status | Code size | Text size | DLL refs | Imports | IAT end/code | IAT fit | Import mode | Export mode | IAT matches | Reason |","|---|---|---:|---:|---:|---:|---:|---|---|---|---|---|"]
    for r in rows:
        lines.append("| %s | **%s** | %s | %s | %s | %s | %s/%s | %s | %s | %s | %s | %s |" % (
            r.get("path",""),r.get("status",""),r.get("code_size",""),r.get("text_size",""),
            r.get("dll_ref_count",""),r.get("total_imports",""),r.get("iat_end_in_code",""),
            r.get("code_size",""),r.get("iat_fits_code",""),r.get("import_mode",""),
            r.get("export_mode",""),r.get("iat_values_match_ordinals",""),r.get("reason","")))
    lines += ["","## Interpretation limits","",
        "- Absolute offsets are the documented E32 header interpretation; code-relative offsets are diagnostic alternatives only.",
        "- A unique bounded interpretation is not a loader test and does not validate header CRC, relocations, signatures or runtime ABI.",
        "- IAT checks record both byte-range bounds and whether IAT values equal the import ordinal list.",
        "- Firmware and decompressed E32 binaries remain read-only and are not committed; this report contains metadata only.",""]
    a.out.write_text("\n".join(lines),encoding="utf-8")
    print(a.out.read_text(encoding="utf-8"))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
