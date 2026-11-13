#!/usr/bin/env python3
"""Summarize Step117 bulk E32 decompression and Step109 flat-image validation.

Consumes text/JSON reports only; never opens or writes firmware inputs or E32
module binaries. The workflow owns the temporary decompressed tree.
"""
from __future__ import annotations

import argparse
import csv
import json
from collections import Counter, defaultdict
from pathlib import Path


def load_tsv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--step117-json", type=Path, required=True)
    parser.add_argument("--modules", type=Path, required=True)
    parser.add_argument("--exports", type=Path, required=True)
    parser.add_argument("--imports", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    step117 = json.loads(args.step117_json.read_text(encoding="utf-8"))
    decompression_rows = step117.get("results", [])
    module_rows = load_tsv(args.modules)
    export_rows = load_tsv(args.exports)
    import_rows = load_tsv(args.imports)

    decomp_counts = Counter(row.get("status", "UNKNOWN") for row in decompression_rows)
    parse_counts = Counter(row.get("status", "UNKNOWN") for row in module_rows)
    reason_groups: dict[str, list[str]] = defaultdict(list)
    for row in module_rows:
        if row.get("status") in ("REJECTED", "PARTIAL", "READ_ERROR"):
            reason = row.get("reason") or "(no reason recorded)"
            reason_groups[reason].append(row.get("path", "(unknown path)"))

    def normalize_path(value: str) -> str:
        parts = Path(value).parts
        if parts and parts[0] == "PPM_OVER_C0R":
            parts = parts[1:]
        return Path(*parts).as_posix() if parts else ""

    parsed_by_path = {normalize_path(row.get("path", "")): row for row in module_rows}
    decompressed_paths = {normalize_path(item.get("path", "")) for item in decompression_rows}
    missing = [
        row.get("path", "(unknown path)")
        for row in decompression_rows
        if row.get("status") == "DECOMPRESSED"
        and normalize_path(row.get("path", "")) not in parsed_by_path
    ]
    unparsed = [
        row.get("path", "(unknown path)")
        for row in module_rows
        if normalize_path(row.get("path", "")) not in decompressed_paths
    ]
    valid_exports = sum(int(row.get("valid_exports") or 0) for row in module_rows)
    zero_exports = sum(int(row.get("zero_exports") or 0) for row in module_rows)
    invalid_exports = sum(int(row.get("invalid_exports") or 0) for row in module_rows)
    parsed_imports = sum(int(row.get("import_count") or 0) for row in module_rows)

    lines = [
        "# Step118 — bulk Symbian-native E32 decompression and flat-image audit",
        "",
        f"- Step117 candidates selected: **{len(decompression_rows)}**",
        f"- Step117 results: `{dict(sorted(decomp_counts.items()))}`",
        f"- Step109 flat-image candidates: **{len(module_rows)}**",
        f"- Step109 parse statuses: `{dict(sorted(parse_counts.items()))}`",
        f"- Decompressed candidates missing from flat-image audit: **{len(missing)}**",
        f"- Extra EPOC candidates in flat-image tree: **{len(unparsed)}**",
        f"- Export rows emitted: **{len(export_rows)}**",
        f"- Export entries classified valid/zero/invalid: **{valid_exports}/{zero_exports}/{invalid_exports}**",
        f"- Import rows emitted: **{len(import_rows)}**",
        f"- Sum of per-module import counts: **{parsed_imports}**",
        "",
        "## Decompression results",
        "",
        "| Path | Compression UID | Result | Input bytes | Output bytes | Output SHA-256 / reason |",
        "|---|---:|---|---:|---:|---|",
    ]
    for row in decompression_rows:
        lines.append(
            f"| `{row.get('path','')}` | {row.get('compression','')} | "
            f"**{row.get('status','')}** | {row.get('input_size','')} | "
            f"{row.get('output_size','')} | {row.get('output_sha256') or row.get('reason','')} |"
        )

    lines += ["", "## Flat-image structural results", "",
              "| Path | Status | UID3 | Code size | Text size | DLL refs | Export count | Exports valid/zero/invalid | Imports | Import offset | Export offset | Reason |",
              "|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|"]
    for row in module_rows:
        lines.append(
            f"| `{row.get('path','')}` | **{row.get('status','')}** | "
            f"{row.get('uid3','')} | {row.get('code_size','')} | {row.get('text_size','')} | "
            f"{row.get('dll_ref_count','')} | {row.get('export_count','')} | "
            f"{row.get('valid_exports','')}/{row.get('zero_exports','')}/{row.get('invalid_exports','')} | "
            f"{row.get('import_count','')} | {row.get('import_offset','')} | "
            f"{row.get('export_dir_offset','')} | {row.get('reason','')} |"
        )

    lines += ["", "## Aggregated parse issues", ""]
    if reason_groups:
        for reason, paths in sorted(reason_groups.items(), key=lambda item: (-len(item[1]), item[0])):
            lines.append(f"- **{len(paths)} file(s):** {reason}")
            for path in paths[:8]:
                lines.append(f"  - `{path}`")
            if len(paths) > 8:
                lines.append(f"  - … and {len(paths) - 8} more")
    else:
        lines.append("- No PARTIAL/REJECTED/READ_ERROR rows.")

    if missing:
        lines += ["", "## Missing from flat-image audit", ""]
        lines.extend(f"- `{path}`" for path in missing)
    if unparsed:
        lines += ["", "## Additional parsed candidates", ""]
        lines.extend(f"- `{path}`" for path in unparsed)

    lines += [
        "",
        "## Interpretation limits",
        "",
        "- DECOMPRESSED records mean the pinned upstream elf2e32 parser emitted an uncompressed image and Step117's UID, code-offset and size bounds passed.",
        "- PASS/PARTIAL/REJECTED are Step109's independent export/import/IAT structural classifications on the decompressed files.",
        "- Export-entry bounds do not validate header CRC, relocation streams, signatures, ABI compatibility, Symbian loader acceptance or device execution.",
        "- These ROFS/ROFx filesystem modules are separate from the seven XIP ROM modules inventoried from C0R SOS+CORE.",
        "- All decompressed binaries remain in the ephemeral workflow workspace; this report contains metadata only.",
        "",
    ]
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text("\n".join(lines), encoding="utf-8")
    print(args.out.read_text(encoding="utf-8"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
