#!/usr/bin/env python3
"""Emit a compact, text-only audit of the RM-320 firmware extraction run.

This intentionally records metadata and derived tables only. It never copies
firmware images, ROM pages, or extracted system DLL binaries into the repo.
"""
from collections import Counter
import csv
import hashlib
from pathlib import Path

ROOT = Path("firmware-input")
PARSED = Path("firmware-parsed")
EXTRACTED = Path("firmware-extracted/n95-inno/app")


def read_tsv(path):
    if not path.is_file():
        return []
    with path.open(newline="", encoding="utf-8", errors="replace") as f:
        return list(csv.DictReader(f, delimiter="\t"))


def read_exit(name):
    path = ROOT / name
    if not path.is_file():
        return "not-recorded"
    return path.read_text(encoding="ascii", errors="replace").strip() or "empty"


def tree_stats(path):
    if not path.exists():
        return 0, 0, []
    files = sorted(p for p in path.rglob("*") if p.is_file())
    return len(files), sum(p.stat().st_size for p in files), files


def sha256(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def main():
    lines = [
        "# Step102 — RM-320 firmware extraction audit",
        "",
        "Text-only derived checkpoint. No firmware image, ROM page, or system DLL is committed.",
        "",
        "## Input package members",
        "",
    ]
    inputs = sorted(p for p in EXTRACTED.glob("*") if p.is_file()) if EXTRACTED.exists() else []
    relevant = [p for p in inputs if any(x in p.name.lower() for x in ("uda", "35.0.001", ".c0r", ".v05"))]
    if relevant:
        for p in relevant:
            lines.append(f"- `{p.name}`: {p.stat().st_size} bytes, SHA-256 `{sha256(p)}`")
    else:
        lines.append("- No matching extracted UDA/PPM/C0R package members found.")

    lines += ["", "## FPSX/partition unpacker results", "",
              "| Input/partition | Exit code | Output files | Output bytes | Interpretation |",
              "|---|---:|---:|---:|---|"]
    jobs = [
        ("UDA FPSX", "uda-unpack.exit", "uda-unpack.log", PARSED / "uda",
         "Container output only; inspect whether it contains a usable filesystem tree."),
        ("PPM FPSX", "ppm-unpack.exit", "ppm-unpack.log", PARSED / "ppm",
         "Sparse flash image; SOS+ROFX is carved and parsed separately."),
        ("C0R / CORE FPSX", "core-unpack.exit", "core-unpack.log", PARSED / "core",
         "Sparse flash image; SOS+CORE and SOS+ROFS are handled separately."),
        ("Carved CORE SOS+ROFS", "core-rofs-unpack.exit", "core-rofs-unpack.log", PARSED / "core-rofs",
         "Filesystem extraction result from the carved CORE ROFS partition."),
        ("Carved PPM SOS+ROFX", "ppm-rofx-unpack.exit", "ppm-rofx-unpack.log", PARSED / "ppm-rofs",
         "Filesystem extraction result from the carved PPM ROFX partition."),
    ]
    for label, exit_name, log_name, outdir, note in jobs:
        count, total, files = tree_stats(outdir)
        lines.append(f"| {label} | {read_exit(exit_name)} | {count} | {total} | {note} |")
    lines += ["", "### Output-tree samples", ""]
    for label, _, _, outdir, _ in jobs:
        count, total, files = tree_stats(outdir)
        lines.append(f"**{label}** — {count} files, {total} bytes")
        if files:
            for p in files[:12]:
                lines.append(f"- `{p.relative_to(PARSED).as_posix()}` ({p.stat().st_size} bytes)")
            if len(files) > 12:
                lines.append(f"- … and {len(files) - 12} more")
        else:
            lines.append("- No files emitted.")
        lines.append("")

    lines += ["## Carved SOS partitions", ""]
    carve = ROOT / "STEP77_CARVED_PARTITIONS.txt"
    if carve.is_file():
        lines.extend(["```text", carve.read_text(encoding="utf-8", errors="replace").rstrip(), "```"])
    else:
        lines.append("Step77 carve report is missing.")

    lines += ["", "## Reconstructed CORE ROM", ""]
    page = ROOT / "STEP79_ROM_PAGE_RECONSTRUCTION.txt"
    if page.is_file():
        lines.extend(["```text", page.read_text(encoding="utf-8", errors="replace").rstrip(), "```"])
    else:
        lines.append("Step79 reconstruction report is missing.")

    scan = ROOT / "ROFS_SIGNATURE_SCAN.tsv"
    if scan.is_file():
        rows = read_tsv(scan)
        counts = Counter(r.get("validation", "") for r in rows)
        lines += ["", "## Raw sparse-image signature scan", "",
                  "This scan is diagnostic only; the carved SOS wrapper is the relevant ROFS/ROFX input.",
                  "", f"- Rows: {len(rows)}", f"- Validation counts: `{dict(sorted(counts.items()))}`"]

    modules = read_tsv(ROOT / "ROM_TARGET_MODULES.tsv")
    exports = read_tsv(ROOT / "ROM_EXPORTS.tsv")
    selected = read_tsv(ROOT / "STEP91_TARGET_EXPORTS.tsv")
    rom_only = read_tsv(ROOT / "STEP94_ROM_ONLY_EXPORTS.tsv")
    export_counts = Counter(r.get("module", "").lower() for r in exports)
    selected_counts = Counter(r.get("module", "").lower() for r in selected)
    lines += ["", "## N95 ROM module/export inventory", "",
              f"- ROM directory entries: see Step79 report (expected to be retained in logs).",
              f"- XIP target modules: {len(modules)}",
              f"- Raw export rows: {len(exports)}",
              f"- Selected SDK-symbolized export rows: {len(selected)}",
              f"- ROM-only export rows from Step94: {len(rom_only)}",
              "", "| Module | UID3 | ROM exports | Selected symbolized exports |",
              "|---|---:|---:|---:|"]
    for name in ("euser.dll", "cone.dll", "gdi.dll", "fbscli.dll", "eikcore.dll", "ws32.dll", "efsrv.dll"):
        m = next((r for r in modules if Path(r.get("path", "").replace("\\", "/")).name.lower() == name), {})
        lines.append(
            f"| {name} | {m.get('uid3', '—')} | {export_counts.get(name, 0)} | {selected_counts.get(name, 0)} |"
        )

    for name, title in [
        ("STEP91_N95_ROM_EXPORT_SUMMARY.md", "Step91 summary"),
        ("STEP91_SELECTED_IMPORTS.tsv", "Step91 selected import remaps"),
        ("STEP91_KEY_IMPORT_CASES.tsv", "Step91 key ordinal cases"),
        ("STEP94_ROM_ONLY_EXPORTS.tsv", "Step94 ROM-only exports"),
    ]:
        p = ROOT / name
        lines.append(f"- {title}: {'present' if p.is_file() else 'missing'} (`{name}`)")

    lines += [
        "",
        "## Interpretation limits",
        "",
        "- A zero unpacker exit code and a generated sparse image prove container parsing, not necessarily a complete user-visible filesystem extraction.",
        "- The reconstructed SOS+CORE ROM and its XIP module/export tables are a separate successful extraction path.",
        "- SDK symbol names identify candidate exports; they do not prove runtime ABI equivalence.",
        "- No ROM image or protected system DLL is retained in this repository.",
        "",
    ]
    report = "\n".join(lines)
    out = ROOT / "STEP102_FIRMWARE_EXTRACTION_AUDIT.md"
    out.write_text(report, encoding="utf-8")
    print(report)


if __name__ == "__main__":
    main()
