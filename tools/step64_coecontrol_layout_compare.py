#!/usr/bin/env python3
"""Compare N-Gage and S60 3.1 CCoeControl class declarations."""
from __future__ import annotations
import json
import re
from pathlib import Path

def extract(text: str, name: str):
    pattern = re.compile(r"\bclass\s+" + re.escape(name) + r"\s*:")
    match = pattern.search(text)
    if not match:
        return None
    brace = text.find("{", match.start())
    if brace < 0:
        return None
    depth = 0
    for i in range(brace, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[match.start():i + 2]
    return None

def main():
    old_path = Path("third_party/ngage-sdk/6.1/Series60/Epoc32/Include/coecntrl.h")
    new_path = Path("/tmp/s60-devkit/Epoc32/include/coecntrl.h")
    if not old_path.is_file():
        raise SystemExit(f"missing pinned N-Gage header: {old_path}")
    if not new_path.is_file():
        raise SystemExit(f"missing target S60 header: {new_path}")
    old_text = old_path.read_text(errors="replace")
    new_text = new_path.read_text(errors="replace")
    old_class = extract(old_text, "CCoeControl")
    new_class = extract(new_text, "CCoeControl")
    if not old_class or not new_class:
        raise SystemExit("could not extract exact CCoeControl class definition from both SDK headers")
    def base_line(block):
        return next((line.strip() for line in block.splitlines() if "class CCoeControl" in line), "")
    report = {
        "old_header": str(old_path),
        "target_header": str(new_path),
        "old_sha256": __import__("hashlib").sha256(old_path.read_bytes()).hexdigest(),
        "target_sha256": __import__("hashlib").sha256(new_path.read_bytes()).hexdigest(),
        "old_base_declaration": base_line(old_class),
        "target_base_declaration": base_line(new_class),
        "old_class": old_class,
        "target_class": new_class,
    }
    out = Path("/tmp/probe")
    out.mkdir(exist_ok=True)
    (out / "step64-coecontrol-layout.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = [
        "# Step64 — CCoeControl layout comparison", "",
        f"Old N-Gage header: {old_path}",
        f"Target S60 3.1 header: {new_path}", "",
        "## N-Gage CCoeControl declaration", "", old_class, "",
        "## Target S60 3.1 CCoeControl declaration", "", new_class, "",
        "## Initial comparison", "",
        f"- N-Gage base list: {report['old_base_declaration']}",
        f"- Target base list: {report['target_base_declaration']}",
        "",
        "The full declarations are retained above. Member offsets must be calculated from the actual target compiler ABI and must not be inferred from matching field names alone.",
        "",
    ]
    (out / "STEP64_COECONTROL_LAYOUT_COMPARE.md").write_text("\n".join(lines))
    print(json.dumps({
        "old_base": report["old_base_declaration"],
        "target_base": report["target_base_declaration"],
        "old_sha256": report["old_sha256"],
        "target_sha256": report["target_sha256"],
    }, indent=2))

if __name__ == "__main__":
    main()
