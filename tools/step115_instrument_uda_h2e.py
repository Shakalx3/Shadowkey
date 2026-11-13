#!/usr/bin/env python3
"""Instrument the upstream FPSX H2E (SOS-USER) parser without changing its semantics.

Step114's field-order swap experiment did not validate: on the RM-320 UDA input it
produced a zero-byte userarea.img and an unknown next block. Step115 therefore
restores the upstream read order and emits bounded raw-header/payload diagnostics.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

START = "    else if (btype==BLOCK_TYPE_H2E) {"
END = "\n    else if (btype==BLOCK_TYPE_H30) {"
ANCHOR = "        string description=wis.readString(12);\n"

DIAGNOSTIC = (
    '        cout << indent << "H2E declared header window: " << wis.getSize() << endl;\n'
    '        BinaryReader rawHeader=wis;\n'
    '        string rawHeaderBytes=rawHeader.readString(wis.getSize()+1);\n'
    '        cout << indent << "H2E header raw (+trailing byte): " << toHexString(rawHeaderBytes) << endl;\n'
    '        cout << indent << "H2E payload source offset: " << is.debug() << endl;\n'
    '        cout << indent << "H2E payload bytes remaining: " << is.available() << endl;\n'
    '        BinaryReader rawPayload=is;\n'
    '        size_t rawPrefixLength = is.available() < 64 ? is.available() : 64;\n'
    '        string rawPayloadPrefix=rawPayload.readString(rawPrefixLength);\n'
    '        cout << indent << "H2E payload prefix: " << toHexString(rawPayloadPrefix) << endl;\n'
)


def instrument_source(source: str) -> str:
    if source.count(START) != 1 or source.count(END) != 1:
        raise ValueError("upstream H2E branch anchors changed; refusing to instrument")
    start = source.index(START)
    end = source.index(END, start)
    block = source[start:end]
    if "H2E header raw (+trailing byte)" in block:
        raise ValueError("H2E raw-header diagnostics are already present")
    if block.count(ANCHOR) != 1:
        raise ValueError("expected H2E description read exactly once")
    block = block.replace(ANCHOR, ANCHOR + DIAGNOSTIC, 1)
    if "uint32_t length=wis.readInt();\n        uint32_t offset=wis.readInt();" not in block:
        raise ValueError("upstream H2E length/offset read order changed")
    return source[:start] + block + source[end:]


def self_test() -> None:
    sample = (
        START + "\n"
        + ANCHOR
        + "        uint32_t length=wis.readInt();\n"
        + "        uint32_t offset=wis.readInt();\n"
        + END
    )
    result = instrument_source(sample)
    assert "BinaryReader rawHeader=wis;" in result
    assert "rawHeader.readString(wis.getSize()+1)" in result
    assert "rawPayload.readString(rawPrefixLength)" in result
    assert "uint32_t length=wis.readInt();\n        uint32_t offset=wis.readInt();" in result
    assert "uint32_t offset=wis.readInt();\n        uint32_t length=wis.readInt();" not in result
    print("Step115 H2E raw-header instrumentation self-test: PASS")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    if args.self_test:
        self_test()
    if args.source is None:
        if args.self_test:
            return 0
        parser.error("--source is required unless --self-test is used")

    original = args.source.read_text(encoding="utf-8")
    instrumented = instrument_source(original)
    before = hashlib.sha256(original.encode("utf-8")).hexdigest()
    after = hashlib.sha256(instrumented.encode("utf-8")).hexdigest()
    args.source.write_text(instrumented, encoding="utf-8")

    report = "\n".join([
        "# Step115 — UDA H2E raw-header instrumentation",
        "",
        "- Status: INSTRUMENTED",
        "- Scope: BLOCK_TYPE_H2E only",
        "- Original H2E length/offset read order: preserved",
        "- Original extraction behavior: preserved",
        "- Diagnostics: declared header window, raw header bytes including trailing byte, source payload offset, available bytes and first 64 payload bytes",
        "- Firmware data: read-only",
        f"- Source SHA-256 before: {before}",
        f"- Source SHA-256 after: {after}",
        "",
        "The raw bytes are diagnostic evidence only; no field interpretation is accepted by this step.",
        "",
    ])
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(report, encoding="utf-8")
    print(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
