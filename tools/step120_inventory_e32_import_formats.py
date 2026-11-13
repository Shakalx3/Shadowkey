#!/usr/bin/env python3
"""Format-aware inventory of uncompressed EKA2 E32 modules."""
from __future__ import annotations
import argparse, csv, json, struct
from collections import Counter
from pathlib import Path

DLL_UID = 0x10000079
EXE_UID = 0x1000007A
IMP_MASK = 0xF0000000
IMP_PE = 0x00000000
IMP_ELF = 0x10000000
IMP_PE2 = 0x20000000
HDR_MASK = 0x0F000000
HDR_J = 0x01000000
HDR_V = 0x02000000
HEADER_MIN = 0x7C
MAX_DLL_REFS = 4096
MAX_ITEMS = 1000000
MAX_EXPORTS = 131072

def u32(data, off):
    if off < 0 or off + 4 > len(data):
        raise ValueError("u32 outside file at 0x%X" % off)
    return struct.unpack_from("<I", data, off)[0]

def fmt_name(value):
    return {IMP_PE:"PE", IMP_ELF:"ELF", IMP_PE2:"PE2"}.get(value, "UNKNOWN_0x%08X" % value)

def parse_imports(data, off, dll_count, imp_fmt, code_size):
    result = {"status":"NO_IMPORTS","blocks":[],"rows":[],"count":0,"valid_refs":0,"invalid_refs":0,"error":""}
    if dll_count == 0:
        return result
    result["status"] = "INVALID"
    if dll_count > MAX_DLL_REFS or off < HEADER_MIN or off > len(data)-4:
        result["error"] = "import table offset/count outside file bounds"
        return result
    if imp_fmt not in (IMP_PE, IMP_ELF, IMP_PE2):
        result["status"] = "UNSUPPORTED_FORMAT"
        result["error"] = "unsupported import format 0x%08X" % imp_fmt
        return result
    size = u32(data,off)
    if size < 4 or size > len(data)-off:
        result["error"] = "import table size outside file"
        return result
    end, pos = off+size, off+4
    for block_index in range(dll_count):
        if pos+8 > end:
            result["error"] = "import descriptor %d exceeds table" % block_index
            return result
        name_rel, count = struct.unpack_from("<II",data,pos)
        if count > MAX_ITEMS or result["count"]+count > MAX_ITEMS:
            result["error"] = "import count exceeds safety cap"
            return result
        list_bytes = 0 if imp_fmt == IMP_PE2 else count*4
        next_pos = pos+8+list_bytes
        if next_pos > end:
            result["error"] = "import reference list %d exceeds table" % block_index
            return result
        name_off = off+name_rel
        if name_off < off or name_off >= end:
            result["error"] = "DLL name offset %d outside table" % block_index
            return result
        name_end = data.find(b"\0",name_off,end)
        if name_end < 0:
            result["error"] = "DLL name %d is unterminated" % block_index
            return result
        dll = data[name_off:name_end].decode("ascii","replace")
        values = list(struct.unpack_from("<"+"I"*count,data,pos+8)) if count and imp_fmt != IMP_PE2 else []
        result["blocks"].append({"dll":dll,"count":count})
        result["count"] += count
        if imp_fmt == IMP_ELF:
            for index, raw in enumerate(values):
                site = raw & ~1
                valid = site < code_size
                result["valid_refs" if valid else "invalid_refs"] += 1
                result["rows"].append({"dll":dll,"index":index,"kind":"CODE_OFFSET","value":raw,"code_offset":site,"valid":valid})
        elif imp_fmt == IMP_PE:
            for index, ordinal in enumerate(values):
                result["rows"].append({"dll":dll,"index":index,"kind":"ORDINAL","value":ordinal,"code_offset":"","valid":True})
        else:
            for index in range(count):
                result["rows"].append({"dll":dll,"index":index,"kind":"PE2_COUNT_ONLY","value":"","code_offset":"","valid":True})
        pos = next_pos
    result["status"] = "VALID" if result["invalid_refs"] == 0 else "PARTIAL"
    result["size"] = size
    result["trailing_bytes"] = end-pos
    return result

def parse_exports(data, off, count, imp_fmt, code_base, entry_point, code_size, code_off):
    result = {"status":"NO_EXPORTS","rows":[],"valid":0,"absent":0,"invalid":0,"error":""}
    if count == 0:
        return result
    result["status"] = "INVALID"
    if count > MAX_EXPORTS or off < HEADER_MIN or off > len(data) or count*4 > len(data)-off:
        result["error"] = "export directory outside file"
        return result
    if imp_fmt not in (IMP_PE,IMP_ELF,IMP_PE2):
        result["status"] = "UNSUPPORTED_FORMAT"
        result["error"] = "unsupported export address format"
        return result
    absent_value = (code_base+entry_point) & 0xFFFFFFFF if imp_fmt == IMP_ELF else entry_point
    for ordinal in range(1,count+1):
        raw = u32(data,off+(ordinal-1)*4)
        if raw in (absent_value,0xFFFFFFFF):
            result["absent"] += 1
            result["rows"].append({"ordinal":ordinal,"raw":raw,"kind":"ABSENT","code_offset":"","file_offset":"","valid":True})
            continue
        if imp_fmt == IMP_ELF:
            address = raw & ~1
            valid = code_base <= address < code_base+code_size
            code_relative = address-code_base if valid else ""
        else:
            code_relative = raw & ~1
            valid = code_relative < code_size
        file_off = code_off+code_relative if valid else ""
        result["valid" if valid else "invalid"] += 1
        result["rows"].append({"ordinal":ordinal,"raw":raw,"kind":"ELF_ABSOLUTE_ADDRESS" if imp_fmt==IMP_ELF else "CODE_OFFSET","code_offset":code_relative,"file_offset":file_off,"valid":valid})
    result["status"] = "VALID" if result["invalid"] == 0 else "PARTIAL"
    return result

def inspect_image(data,path):
    row={"path":path,"size":len(data),"status":"INVALID"}
    if len(data)<HEADER_MIN or data[0x10:0x14]!=b"EPOC":
        row["reason"]="missing EPOC signature or truncated E32 header"
        return row,[],[]
    f={
      "uid1":u32(data,0),"uid2":u32(data,4),"uid3":u32(data,8),
      "flags":u32(data,0x2C),"compression":u32(data,0x1C),
      "code_size":u32(data,0x30),"data_size":u32(data,0x34),
      "entry_point":u32(data,0x48),"code_base":u32(data,0x4C),
      "data_base":u32(data,0x50),"dll_ref_count":u32(data,0x54),
      "export_dir_offset":u32(data,0x58),"export_count":u32(data,0x5C),
      "text_size":u32(data,0x60),"code_offset":u32(data,0x64),
      "data_offset":u32(data,0x68),"import_offset":u32(data,0x6C),
      "code_reloc_offset":u32(data,0x70),"data_reloc_offset":u32(data,0x74)
    }
    imp_fmt=f["flags"]&IMP_MASK
    hdr_fmt=f["flags"]&HDR_MASK
    row.update(f)
    row["import_format"]=fmt_name(imp_fmt)
    row["header_format"]={0:"ORIGINAL",HDR_J:"J",HDR_V:"V"}.get(hdr_fmt,"UNKNOWN_0x%08X"%hdr_fmt)
    errors=[]
    if f["compression"] != 0: errors.append("input is still compressed")
    if f["uid1"] not in (DLL_UID,EXE_UID): errors.append("UID1 is not DLL or EXE")
    if bool(f["flags"]&1)!=(f["uid1"]==DLL_UID): errors.append("UID1/flags DLL bit mismatch")
    code_off,code_size=f["code_offset"],f["code_size"]
    code_end=code_off+code_size
    code_ok=code_off>=HEADER_MIN and code_size>0 and code_end<=len(data)
    if not code_ok: errors.append("code range outside file")
    if f["text_size"]>code_size: errors.append("text size exceeds code size")
    if f["data_size"] and (f["data_offset"]>len(data) or f["data_size"]>len(data)-f["data_offset"]):
        errors.append("data range outside file")
    imports=parse_imports(data,f["import_offset"],f["dll_ref_count"],imp_fmt,code_size)
    exports=parse_exports(data,f["export_dir_offset"],f["export_count"],imp_fmt,f["code_base"],f["entry_point"],code_size,code_off)
    if imports["status"] in ("INVALID","UNSUPPORTED_FORMAT"): errors.append(imports["error"])
    if imports["status"]=="PARTIAL": errors.append("one or more ELF import code offsets outside code")
    if exports["status"] in ("INVALID","UNSUPPORTED_FORMAT"): errors.append(exports["error"])
    if exports["status"]=="PARTIAL": errors.append("one or more export entries outside code/address range")
    iat_status="NOT_APPLICABLE_ELF" if imp_fmt==IMP_ELF else "NO_IMPORTS" if imports["status"]=="NO_IMPORTS" else "NOT_CHECKED"
    iat_matches=None
    if imp_fmt in (IMP_PE,IMP_PE2) and imports["count"]:
        iat_start=f["text_size"]
        iat_end=iat_start+imports["count"]*4
        iat_ok=iat_end<=code_size and code_off+iat_end<=len(data)
        iat_status="BOUNDED" if iat_ok else "OUT_OF_BOUNDS"
        if not iat_ok: errors.append("PE-style IAT exceeds code segment/file")
        elif imp_fmt==IMP_PE:
            expected=[r["value"] for r in imports["rows"] if r["kind"]=="ORDINAL"]
            actual=list(struct.unpack_from("<"+"I"*len(expected),data,code_off+iat_start)) if expected else []
            iat_matches=(actual==expected)
            iat_status="MATCH" if iat_matches else "MISMATCH"
            if not iat_matches: errors.append("PE IAT values differ from ordinal list")
    row.update({
      "code_end":code_end,"code_range_ok":code_ok,
      "import_status":imports["status"],"import_count":imports["count"],
      "import_valid_refs":imports["valid_refs"],"import_invalid_refs":imports["invalid_refs"],
      "import_names":";".join(b["dll"] for b in imports["blocks"]),
      "export_status":exports["status"],"export_valid":exports["valid"],
      "export_absent":exports["absent"],"export_invalid":exports["invalid"],
      "iat_status":iat_status,"iat_matches":iat_matches
    })
    row["reason"]="; ".join(x for x in errors if x)
    row["status"]="VALID" if not errors else "PARTIAL" if imports["status"] in ("VALID","PARTIAL","NO_IMPORTS") and exports["status"] in ("VALID","PARTIAL","NO_EXPORTS") and code_ok else "REJECTED"
    export_rows=[{"path":path,**x} for x in exports["rows"]]
    import_rows=[{"path":path,**x} for x in imports["rows"]]
    return row,export_rows,import_rows

def fixture(imp_fmt):
    data=bytearray(0xEA)
    flags=0x02000021|imp_fmt
    struct.pack_into("<III",data,0,DLL_UID,0x1000008D,0xE0001190)
    data[0x10:0x14]=b"EPOC"
    struct.pack_into("<I",data,0x2C,flags)
    struct.pack_into("<II",data,0x30,0x30,0)
    struct.pack_into("<II",data,0x48,0,0x10000000)
    struct.pack_into("<I",data,0x50,0x10010000)
    struct.pack_into("<I",data,0x54,1)
    struct.pack_into("<II",data,0x58,0xC0,1)
    struct.pack_into("<I",data,0x60,0x30 if imp_fmt==IMP_ELF else 0x10)
    struct.pack_into("<I",data,0x64,0xA0)
    struct.pack_into("<I",data,0x6C,0xD0)
    if imp_fmt==IMP_ELF:
        struct.pack_into("<I",data,0xC0,0x10000004)
        struct.pack_into("<I",data,0xD0,26)
        struct.pack_into("<II",data,0xD4,16,1)
        struct.pack_into("<I",data,0xDC,8)
    elif imp_fmt==IMP_PE:
        struct.pack_into("<I",data,0xB0,7)
        struct.pack_into("<I",data,0xC0,4)
        struct.pack_into("<I",data,0xD0,26)
        struct.pack_into("<II",data,0xD4,16,1)
        struct.pack_into("<I",data,0xDC,7)
    else:
        struct.pack_into("<I",data,0xB0,7)
        struct.pack_into("<I",data,0xC0,4)
        struct.pack_into("<I",data,0xD0,22)
        struct.pack_into("<II",data,0xD4,12,1)
    data[0xE0:0xEA]=b"euser.dll\0"
    return bytes(data)

def self_test():
    for fmt in (IMP_ELF,IMP_PE,IMP_PE2):
        row,ex,im=inspect_image(fixture(fmt),"test.bin")
        assert row["status"]=="VALID",(fmt,row)
        assert len(ex)==1 and ex[0]["valid"],(fmt,ex)
        assert len(im)==1 and im[0]["valid"],(fmt,im)
        if fmt==IMP_ELF: assert row["iat_status"]=="NOT_APPLICABLE_ELF",row
        if fmt==IMP_PE: assert row["iat_status"]=="MATCH",row
        if fmt==IMP_PE2: assert row["iat_status"]=="BOUNDED",row
    print("Step120 format-aware E32 self-tests: PASS (3/3)")

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--tree",type=Path,required=True)
    p.add_argument("--out-dir",type=Path,required=True)
    p.add_argument("--self-test",action="store_true")
    a=p.parse_args()
    if a.self_test:self_test()
    if not a.tree.is_dir():raise SystemExit("missing E32 tree: %s"%a.tree)
    modules=[];exports=[];imports=[]
    for path in sorted(a.tree.rglob("*")):
        if path.is_symlink() or not path.is_file():continue
        try:
            with path.open("rb") as stream:
                stream.seek(0x10)
                if stream.read(4)!=b"EPOC":continue
            m,e,i=inspect_image(path.read_bytes(),path.relative_to(a.tree).as_posix())
            modules.append(m);exports.extend(e);imports.extend(i)
        except (OSError,ValueError,struct.error,OverflowError) as exc:
            modules.append({"path":path.relative_to(a.tree).as_posix(),"status":"READ_ERROR","reason":str(exc)})
    a.out_dir.mkdir(parents=True,exist_ok=True)
    def write_tsv(name,rows):
        if not rows:return
        keys=[]
        for r in rows:
            for k in r:
                if k not in keys:keys.append(k)
        with (a.out_dir/name).open("w",newline="",encoding="utf-8") as f:
            w=csv.DictWriter(f,fieldnames=keys,delimiter="\t",extrasaction="ignore")
            w.writeheader();w.writerows(rows)
    write_tsv("STEP120_E32_MODULES.tsv",modules)
    write_tsv("STEP120_E32_EXPORTS.tsv",exports)
    write_tsv("STEP120_E32_IMPORTS.tsv",imports)
    statuses=Counter(m.get("status","UNKNOWN") for m in modules)
    formats=Counter(m.get("import_format","UNKNOWN") for m in modules)
    errors=Counter(m.get("reason","") for m in modules if m.get("reason"))
    summary={"candidate_count":len(modules),"status_counts":dict(statuses),"import_format_counts":dict(formats),"export_rows":len(exports),"import_rows":len(imports),"reason_counts":dict(errors)}
    (a.out_dir/"STEP120_E32_SUMMARY.json").write_text(json.dumps(summary,indent=2)+"\n",encoding="utf-8")
    lines=["# Step120 — format-aware E32 module inventory","",
      "- EPOC candidates: **%d**"%len(modules),
      "- Status counts: %s"%dict(statuses),
      "- Import-format counts: %s"%dict(formats),
      "- Export rows: **%d**"%len(exports),
      "- Import rows: **%d**"%len(imports),"","## Common findings",""]
    for reason,count in errors.most_common(12):lines.append("- **%d file(s):** %s"%(count,reason))
    lines += ["","## Module summary","","| Path | Status | Import format | Flags | Code base | Code size | Text size | DLL refs | Imports | Exports valid/absent/invalid | IAT | Reason |","|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|---|"]
    for m in modules:
        lines.append("| %s | **%s** | %s | 0x%08X | 0x%08X | %s | %s | %s | %s | %s/%s/%s | %s | %s |"%(
          m.get("path",""),m.get("status",""),m.get("import_format",""),m.get("flags",0),m.get("code_base",0),
          m.get("code_size",""),m.get("text_size",""),m.get("dll_ref_count",""),m.get("import_count",""),
          m.get("export_valid",""),m.get("export_absent",""),m.get("export_invalid",""),m.get("iat_status",""),m.get("reason","")))
    lines += ["","## Format semantics used","","- ELF import format (flags mask 0xF0000000 == 0x10000000): each import-block list item is a code-section offset, not an ordinal; there is no PE-style ordinal IAT check.",
      "- PE import format (mask 0): list items are imported ordinals; the IAT is checked at code_offset + text_size.",
      "- PE2 import format (mask 0x20000000): import-block ordinal list is omitted; the IAT range is bounds-checked but cannot be compared to a stored ordinal list.",
      "- ELF export entries are absolute runtime addresses and are translated to code-relative/file offsets using code_base; PE/PE2 exports are code-relative offsets.",
      "- These rules follow the pinned upstream E32 header/parser definitions. Structural validity is not a Symbian loader test or device compatibility proof.",
      "- Only metadata is retained; extracted E32 binaries remain in the ephemeral workflow workspace.",""]
    report=a.out_dir/"STEP120_E32_FORMAT_AWARE_INVENTORY.md"
    report.write_text("\n".join(lines),encoding="utf-8")
    print(report.read_text(encoding="utf-8"))
    return 0

if __name__=="__main__":
    raise SystemExit(main())
