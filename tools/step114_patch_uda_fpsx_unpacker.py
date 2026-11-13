#!/usr/bin/env python3
"""Historical Step114 field-order experiment; rejected by RM-320 run 43409312931.

Do not use this patch in the firmware workflow. Step115 preserves semantics and
instruments the raw header before any new field interpretation is attempted.

Original experiment: patch only the Nokia FPSX H2E (SOS-USER) field order in the CI unpacker clone.

The upstream parser's H2E branch labels the first 32-bit value as length and
the second as offset. BinaryReader::extract(destination, offset, length)
actually seeks the output to offset, then copies length bytes from the current
input cursor. RM-320 UDA evidence suggests the first value is the destination
offset and the second is the payload byte length. This patch is deliberately
limited to H2E; all other FPSX block types remain byte-for-byte unchanged.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

START = "    else if (btype==BLOCK_TYPE_H2E) {"
END = "\n    else if (btype==BLOCK_TYPE_H30) {"


def patch_source(source: str) -> str:
    if source.count(START) != 1 or source.count(END) != 1:
        raise ValueError("upstream H2E branch anchors changed; refusing to patch")
    start = source.index(START)
    end = source.index(END, start)
    block = source[start:end]

    old_order = (
        "        uint32_t length=wis.readInt();\n"
        "        uint32_t offset=wis.readInt();"
    )
    new_order = (
        "        uint32_t offset=wis.readInt();\n"
        "        uint32_t length=wis.readInt();"
    )
    if block.count(old_order) != 1:
        raise ValueError("expected original H2E length/offset reads exactly once")
    block = block.replace(old_order, new_order, 1)

    old_output = (
        '        cout << indent << "Length: " << length << endl;\n'
        '        cout << indent << "Offset: " << offset << endl;\n'
        '        cout << indent << "Unknown: " << unsigned(unknown) << endl;\n'
        '        \n'
        '        is.extract(path+\'/\'+"userarea.img", offset, length);'
    )
    new_output = (
        '        cout << indent << "Destination offset: " << offset << endl;\n'
        '        cout << indent << "Payload length: " << length << endl;\n'
        '        cout << indent << "Payload available: " << is.available() << endl;\n'
        '        cout << indent << "Unknown: " << unsigned(unknown) << endl;\n'
        '        if (length > is.available())\n'
        '            throw "SOS-USER payload length exceeds remaining FPSX bytes";\n'
        '        is.extract(path+\'/\'+"userarea.img", offset, length, true);'
    )
    if block.count(old_output) != 1:
        raise ValueError("expected original H2E output/extract sequence exactly once")
    block = block.replace(old_output, new_output, 1)
    return source[:start] + block + source[end:]


def self_test() -> None:
    sample = (
        START + "\n"
        "        uint32_t length=wis.readInt();\n"
        "        uint32_t offset=wis.readInt();\n"
        '        cout << indent << "Length: " << length << endl;\n'
        '        cout << indent << "Offset: " << offset << endl;\n'
        '        cout << indent << "Unknown: " << unsigned(unknown) << endl;\n'
        "        \n"
        '        is.extract(path+\'/\'+"userarea.img", offset, length);\n'
        + END
    )
    patched = patch_source(sample)
    assert "uint32_t offset=wis.readInt();\n        uint32_t length=wis.readInt();" in patched
    assert "Destination offset:" in patched and "Payload length:" in patched
    assert "length > is.available()" in patched
    assert 'is.extract(path+\'/\'+"userarea.img", offset, length, true);' in patched
    assert "uint32_t length=wis.readInt();\n        uint32_t offset=wis.readInt();" not in patched
    print("Step114 H2E field-order patch self-test: PASS")


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
    patched = patch_source(original)
    before = hashlib.sha256(original.encode("utf-8")).hexdigest()
    after = hashlib.sha256(patched.encode("utf-8")).hexdigest()
    args.source.write_text(patched, encoding="utf-8")

    report = "\n".join([
        "# Step114 — UDA FPSX H2E field-order patch",
        "",
        "- Status: **PATCHED**",
        "- Scope: only BLOCK_TYPE_H2E (SOS-USER)",
        "- First 32-bit field: destination offset",
        "- Second 32-bit field: payload byte length",
        "- Guard: payload length must not exceed BinaryReader::available()",
        "- Output: truncating userarea.img extraction at the declared destination offset",
        "- Other FPSX block branches: unchanged",
        f"- Source SHA-256 before: {before}",
        f"- Source SHA-256 after: {after}",
        "",
        "This is a format hypothesis. It is not accepted as correct until Step112 finds a valid FAT16 BPB and directory tree in the resulting UDA image.",
        "",
    ])
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(report, encoding="utf-8")
    print(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
