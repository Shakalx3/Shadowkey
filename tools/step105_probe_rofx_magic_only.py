#!/usr/bin/env python3
"""Run a reversible magic-only probe for a carved PPM ROFx extension."""
from __future__ import annotations
import argparse, hashlib, json, os, struct, subprocess, tempfile
from pathlib import Path

def u16(b,o): return struct.unpack_from("<H",b,o)[0]
def u32(b,o): return struct.unpack_from("<I",b,o)[0]
def sha(b): return hashlib.sha256(b).hexdigest()

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--source",type=Path,required=True)
    ap.add_argument("--unpacker",type=Path,required=True)
    ap.add_argument("--out-dir",type=Path,required=True)
    ap.add_argument("--library-path",default="")
    a=ap.parse_args()
    original=a.source.read_bytes()
    base=0x400
    if len(original)<base+0x30 or original[base:base+4]!=b"ROFx":
        raise SystemExit("expected ROFx magic at offset 0x400")
    h={
        "header_size":original[base+4],"reserved":original[base+5],
        "format_version":u16(original,base+6),
        "dir_tree_offset":u32(original,base+8),"dir_tree_size":u32(original,base+12),
        "file_entries_offset":u32(original,base+16),"file_entries_size":u32(original,base+20),
        "timestamp_low":u32(original,base+24),"timestamp_high":u32(original,base+28),
        "image_version_raw":u32(original,base+32),"image_size":u32(original,base+36),
        "checksum":u32(original,base+40),"max_image_size":u32(original,base+44)
    }
    adjustment=h["dir_tree_offset"]-0x30
    h["official_extension_adjustment"]=adjustment
    h["adjusted_root_directory_file_offset"]=h["dir_tree_offset"]-adjustment
    before=sha(original)
    a.out_dir.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="shadowkey-step105-rofx-") as td:
        root=Path(td)
        probe=root/"ppm-rofx-magic-only.rofs"
        probe.write_bytes(original)
        with probe.open("r+b") as f:
            f.seek(base)
            f.write(b"ROFS")
        patched=probe.read_bytes()
        changed=[i for i,(x,y) in enumerate(zip(original,patched)) if x!=y]
        if changed != [base+3]:
            raise SystemExit(f"magic-only copy changed unexpected bytes: {changed[:16]}")
        out=root/"out"
        out.mkdir()
        env=os.environ.copy()
        if a.library_path:
            env["LD_LIBRARY_PATH"]=a.library_path+((":"+env["LD_LIBRARY_PATH"]) if env.get("LD_LIBRARY_PATH") else "")
        try:
            run=subprocess.run([str(a.unpacker),"-o",str(out),str(probe)],
                               capture_output=True,text=True,env=env,timeout=180)
            exit_code=run.returncode
            output=(run.stdout or "")+(run.stderr or "")
            timed_out=False
        except subprocess.TimeoutExpired as e:
            exit_code=None
            output=(e.stdout or "")+(e.stderr or "")
            if isinstance(output,bytes): output=output.decode("utf-8","replace")
            timed_out=True
        files=[p for p in out.rglob("*") if p.is_file()]
        file_bytes=sum(p.stat().st_size for p in files)
        after=sha(a.source.read_bytes())
        result={
            "source":str(a.source),"source_size":len(original),"source_sha256_before":before,
            "source_sha256_after":after,"source_unchanged":before==after,
            "magic_offset":base,"magic_before":"ROFx","magic_after":"ROFS",
            "changed_offsets":[f"0x{x:X}" for x in changed],"header":h,
            "unpacker_exit_code":exit_code,"timed_out":timed_out,
            "extracted_file_count":len(files),"extracted_file_bytes":file_bytes,
            "parser_output_tail":output[-6000:],
            "result":"EXTRACTED" if exit_code==0 and files else "PARTIAL" if files else "NO_FILES"
        }
        (a.out_dir/"STEP105_ROFX_MAGIC_PROBE.log").write_text(output[-30000:],encoding="utf-8",errors="replace")
    (a.out_dir/"STEP105_ROFX_MAGIC_PROBE.json").write_text(json.dumps(result,indent=2)+"\n",encoding="utf-8")
    lines=[
        "# Step105 — PPM ROFx magic-only probe","",
        "The source image is read-only. A temporary copy was changed at exactly four bytes and deleted after the test.","",
        f"- Result: **{result['result']}**",
        f"- Source unchanged: **{result['source_unchanged']}**",
        f"- Source size/SHA-256: {len(original)} / {before}",
        f"- Header size/version: {h['header_size']} / 0x{h['format_version']:04X}",
        f"- Directory tree offset/size: 0x{h['dir_tree_offset']:08X} / {h['dir_tree_size']}",
        f"- File entries offset/size: 0x{h['file_entries_offset']:08X} / {h['file_entries_size']}",
        f"- Official extension adjustment: 0x{adjustment:X}; adjusted root file offset: 0x{h['adjusted_root_directory_file_offset']:X}",
        f"- Changed bytes: {changed}",
        f"- Unpacker exit: {exit_code}; files: {len(files)}; extracted bytes: {file_bytes}",
        "","## Parser output tail","",
        "    "+output[-3000:].replace("\n","\n    "),"",
        "## Interpretation","",
        "- This is a diagnostic only; original firmware is unchanged.",
        "- Success after changing only the magic indicates the current parser's offset adjustment is compatible with this ROFx extension.",
        "- Failure must be compared with Symbian's TExtensionRofsHeader reader; it does not prove source corruption.",""
    ]
    report="\n".join(lines)
    (a.out_dir/"STEP105_ROFX_MAGIC_PROBE.md").write_text(report,encoding="utf-8")
    print(report)
    print(json.dumps(result,indent=2))
    return 0

if __name__=="__main__":
    raise SystemExit(main())
