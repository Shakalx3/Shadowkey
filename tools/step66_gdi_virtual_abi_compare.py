#!/usr/bin/env python3
"""Compare N-Gage and S60 3.1 GDI virtual declarations used by the game Draw path."""
from __future__ import annotations
import difflib
import hashlib
import json
import re
from pathlib import Path

OLD = Path("third_party/ngage-sdk/6.1/Series60/Epoc32/Include")
NEW = Path("/tmp/s60-devkit/Epoc32/include")
CLASSES = {"CGraphicsContext": "gdi.h", "CBitmapContext": "gdi.h", "CWindowGc": "w32std.h"}

def extract_class(text: str, name: str) -> str:
    pattern = re.compile(r"\bclass\s+" + re.escape(name) + r"\b[^;{]*\{")
    m = pattern.search(text)
    if not m: raise SystemExit(f"class {name} not found")
    depth, i, state = 0, text.find("{", m.start()), "code"
    while i < len(text):
        ch = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""
        if state == "line":
            if ch == "\n": state = "code"
        elif state == "block":
            if ch == "*" and nxt == "/": state = "code"; i += 1
        elif state == "string":
            if ch == "\\": i += 1
            elif ch == '"': state = "code"
        elif state == "char":
            if ch == "\\": i += 1
            elif ch == "'": state = "code"
        else:
            if ch == "/" and nxt == "/": state = "line"; i += 1
            elif ch == "/" and nxt == "*": state = "block"; i += 1
            elif ch == '"': state = "string"
            elif ch == "'": state = "char"
            elif ch == "{": depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0: return text[m.start():i + 1]
        i += 1
    raise SystemExit(f"unbalanced class body: {name}")

def virtual_declarations(block: str):
    block = re.sub(r"/\*.*?\*/", "", block, flags=re.S)
    block = re.sub(r"//[^\n]*", "", block)
    rows, current = [], ""
    for raw in block.splitlines():
        line = raw.strip()
        if not current and not re.search(r"\bvirtual\b", line): continue
        current = (current + " " + line).strip()
        if ";" in line:
            if re.search(r"\bvirtual\b", current): rows.append(re.sub(r"\s+", " ", current))
            current = ""
    return rows

def main():
    report = {"classes": {}, "headers": {}}
    md = [
        "# Step66 — GDI virtual ABI comparison", "",
        "Old N-Gage SDK vs target S60 3.1 FP1 headers. The game Draw path obtains a CWindowGc through CCoeControl::SystemGc and performs virtual calls at byte offsets +0x48 and +0xB8. This comparison checks whether the declared CWindowGc virtual sequence remains compatible.", ""
    ]
    for side, root in (("old", OLD), ("target", NEW)):
        for filename in ("gdi.h", "w32std.h"):
            p = root / filename
            if not p.is_file(): raise SystemExit(f"missing {side} header: {p}")
            report["headers"][f"{side}:{filename}"] = hashlib.sha256(p.read_bytes()).hexdigest()
    for name, filename in CLASSES.items():
        old_block = extract_class((OLD / filename).read_text(errors="replace"), name)
        new_block = extract_class((NEW / filename).read_text(errors="replace"), name)
        old_v, new_v = virtual_declarations(old_block), virtual_declarations(new_block)
        diff = list(difflib.unified_diff(old_v, new_v, fromfile=f"old/{name}", tofile=f"target/{name}", lineterm=""))
        legacy_slot_map = {}
        if name == "CWindowGc":
            # Symbian ARM vptr points at a two-word vtable prefix
            # (offset-to-top, RTTI pointer); code loads slots at vptr+8+4*n.
            vtable_header_bytes = 8
            expected = [
                (0x48, 16, 16, "SetPenColor", "SetPenColor"),
                (0xB8, 44, 46, "Clear", "Clear"),
                (0xC0, 46, 48, "CopyRect", "CopyRect"),
                (0xD8, 52, 54, "BitBltMasked", "BitBltMasked"),
                (0xDC, 53, 55, "MapColors", "MapColors"),
            ]
            target_at_old_slot = {
                44: "DrawText(const TDesC",
                46: "Clear()",
                52: "BitBlt(const TPoint",
                53: "BitBlt(const TPoint",
            }
            for byte_offset, old_slot, target_slot, old_method, target_method in expected:
                assert byte_offset == vtable_header_bytes + old_slot * 4
                assert old_method in old_v[old_slot], (old_slot, old_v[old_slot], old_method)
                assert target_method in new_v[target_slot], (target_slot, new_v[target_slot], target_method)
                legacy_slot_map[hex(byte_offset)] = {
                    "byte_offset_from_vptr": byte_offset,
                    "old_declaration_slot": old_slot,
                    "old_method": old_v[old_slot],
                    "target_declaration_slot": target_slot,
                    "target_method": new_v[target_slot],
                    "target_method_at_unchanged_old_slot": new_v[old_slot],
                }
            for slot, method in target_at_old_slot.items():
                assert method in new_v[slot], (slot, new_v[slot], method)
                byte_offset = vtable_header_bytes + slot * 4
                if hex(byte_offset) in legacy_slot_map:
                    legacy_slot_map[hex(byte_offset)]["target_method_at_unchanged_old_slot"] = new_v[slot]
        report["classes"][name] = {
            "header": filename, "old_virtual_count": len(old_v),
            "target_virtual_count": len(new_v), "old_virtuals": old_v,
            "target_virtuals": new_v, "diff": diff,
            "exact_sequence_match": old_v == new_v,
            "critical_vtable_slots": legacy_slot_map,
        }
        md += [
            f"## {name}", "",
            f"- Header: {filename}",
            f"- N-Gage virtual declarations: {len(old_v)}",
            f"- Target virtual declarations: {len(new_v)}",
            f"- Exact declaration sequence match: {old_v == new_v}", "",
            "### N-Gage sequence", "",
        ]
        md += [f"{i:02d}. {v}" for i, v in enumerate(old_v)]
        md += ["", "### Target sequence", ""]
        md += [f"{i:02d}. {v}" for i, v in enumerate(new_v)]
        md += ["", "### Unified diff", "", chr(96)*3 + "diff"]
        md += diff or ["(no differences)"]
        md += [chr(96)*3, ""]
    out = Path("/tmp/probe")
    out.mkdir(exist_ok=True)
    (out / "step66-gdi-virtual-abi.json").write_text(json.dumps(report, indent=2) + "\n")
    (out / "STEP66_GDI_VIRTUAL_ABI_COMPARE.md").write_text("\n".join(md) + "\n")
    print(json.dumps({k: {"old":v["old_virtual_count"],"target":v["target_virtual_count"],"match":v["exact_sequence_match"]} for k,v in report["classes"].items()}, indent=2))

if __name__ == "__main__":
    main()
