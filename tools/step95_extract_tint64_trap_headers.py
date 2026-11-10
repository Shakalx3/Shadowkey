#!/usr/bin/env python3
"""Extract TInt64/TTrap declarations and TRAP macro definitions from S60 headers."""
import argparse
import json
import re
from pathlib import Path

PATTERNS = {
    "TInt64 class": re.compile(r"\b(class|struct)\s+TInt64\b"),
    "TInt64 declarations": re.compile(r"\bTInt64\b"),
    "TTrap class": re.compile(r"\b(class|struct)\s+TTrap\b"),
    "TTrap declarations": re.compile(r"\bTTrap\b"),
    "TRAP macros": re.compile(r"^\s*#\s*define\s+TRAP(?:D|_IGNORE)?\b"),
    "64-bit storage names": re.compile(r"\b(?:iLo|iHi|iLow|iHigh|TInt64Rep|TInt64Value)\b"),
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sdk-root", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--summary", type=Path, required=True)
    args = ap.parse_args()

    include = args.sdk_root / "Epoc32/include"
    if not include.is_dir():
        raise SystemExit(f"SDK include directory missing: {include}")

    files = sorted(
        p for p in include.rglob("*")
        if p.is_file() and p.suffix.lower() in {".h", ".hpp", ".inl", ".inc"}
    )
    lines_out = [
        "Step95 — target S60 3.1 FP1 TInt64 / TTrap header evidence",
        f"SDK include root: {include}",
        "Only source declarations/macros are shown; this is not proof of ABI compatibility by itself.",
        "",
    ]
    summary = {"sdk_include": str(include), "files_scanned": len(files), "patterns": {}, "hits": []}

    for label, pattern in PATTERNS.items():
        matches = []
        for path in files:
            try:
                lines = path.read_text(encoding="latin-1", errors="replace").splitlines()
            except Exception:
                continue
            for idx, line in enumerate(lines):
                if pattern.search(line):
                    matches.append((path, idx, lines))
        summary["patterns"][label] = len(matches)
        lines_out.append(f"=== {label}: {len(matches)} matches ===")
        # For class/macro/storage patterns, include all useful contexts.
        # For broad TInt64/TTrap references, keep only the first 50 contexts.
        limit = 50 if label in ("TInt64 declarations", "TTrap declarations") else 100
        for path, idx, lines in matches[:limit]:
            lo = max(0, idx - 8)
            hi = min(len(lines), idx + 18)
            rel = path.relative_to(include)
            lines_out.append(f"--- {rel}:{idx+1} ---")
            for n in range(lo, hi):
                mark = ">" if n == idx else " "
                lines_out.append(f"{mark}{n+1:5d}: {lines[n]}")
            summary["hits"].append({"pattern": label, "file": str(rel), "line": idx + 1})
        if len(matches) > limit:
            lines_out.append(f"... {len(matches)-limit} additional contexts omitted")
        lines_out.append("")

    # Focused, untruncated audit of the core headers most likely to define
    # TInt64 representation. The broad report intentionally caps contexts.
    focused = args.out.parent / "STEP95_TINT64_CORE_HEADERS.txt"
    core_names = {"e32def.h", "e32std.h", "e32std.inl", "e32cmn.h", "e32cmn.inl"}
    focused_lines = ["Step95 focused core-header audit", f"SDK include root: {include}", ""]
    for path in files:
        if path.name.lower() not in core_names:
            continue
        try:
            source_lines = path.read_text(encoding="latin-1", errors="replace").splitlines()
        except Exception as exc:
            focused_lines.append(f"ERROR {path}: {exc}")
            continue
        indexes = [i for i, line in enumerate(source_lines)
                   if re.search(r"\\bTInt64\\b|TInt64Rep|TInt64Value|iLow|iHigh", line)]
        if not indexes:
            continue
        focused_lines.append(f"=== {path.relative_to(include)} ===")
        emitted = set()
        for idx in indexes:
            lo, hi = max(0, idx - 5), min(len(source_lines), idx + 8)
            if any(n in emitted for n in range(lo, hi)):
                continue
            focused_lines.extend(f"{n+1:5d}: {source_lines[n]}" for n in range(lo, hi))
            emitted.update(range(lo, hi))
            focused_lines.append("")
    focused.write_text("\\n".join(focused_lines) + "\\n", encoding="utf-8")
    print(f"Focused core-header audit: {focused}")
    args.out.write_text("\n".join(lines_out) + "\n", encoding="utf-8")
    args.summary.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "files_scanned": summary["files_scanned"],
        "patterns": summary["patterns"],
        "report": str(args.out),
    }, indent=2))


if __name__ == "__main__":
    main()
