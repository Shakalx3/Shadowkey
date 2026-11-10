#!/usr/bin/env python3
"""Find the target SDK declarations for EikStart::RunApplication and its factory type."""
import argparse
from pathlib import Path

NEEDLES = ("TApaApplicationFactory", "RunApplication", "class RLibrary", "Lookup(TInt")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sdk-root", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()
    include = args.sdk_root / "Epoc32" / "include"
    if not include.exists():
        raise SystemExit(f"SDK include directory missing: {include}")
    hits = []
    for path in sorted(include.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in (".h", ".hpp", ".inl"):
            continue
        try:
            lines = path.read_text(encoding="latin-1").splitlines()
        except OSError:
            continue
        indexes = [i for i, line in enumerate(lines) if any(n in line for n in NEEDLES)]
        if not indexes:
            continue
        selected = set()
        for i in indexes:
            selected.update(range(max(0, i-5), min(len(lines), i+9)))
        hits.append((path, lines, sorted(selected)))
    if not hits:
        raise SystemExit("No EikStart/factory/RLibrary declarations found in SDK headers")
    out = []
    for path, lines, indexes in hits:
        out.append(f"===== {path.relative_to(include)} =====")
        last = -2
        for i in indexes:
            if i > last+1:
                out.append("...")
            out.append(f"{i+1:5d}: {lines[i]}")
            last = i
        out.append("")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text("\n".join(out), encoding="utf-8")
    print("\n".join(out))

if __name__ == "__main__":
    main()
