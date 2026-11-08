#!/usr/bin/env python3
"""Extract the CEikAppUi construction callsite and locate related binary pointers."""
from __future__ import annotations
import json
import re
from pathlib import Path

ROOT = Path("source_bundle/shadowkey_step35_work")
SOURCE = ROOT / "shadowkey_lifted_v6.c"
REGISTRY = ROOT / "shadowkey_function_registry.c"
ADDRESSES = {
    "game_primary_vtable": 0x100FFE88,
    "game_menu_observer_vtable": 0x100FFF00,
    "game_object_provider_vtable": 0x100FFF54,
    "game_method_pointer_1": 0x100FDC90,
    "game_method_pointer_2": 0x100FE050,
    "ceikappui_constructor_callsite": 0x10021138,
    "runtime_object_address": 0x10110258,
}


def extract_function(text: str, name: str) -> str | None:
    marker = name + "("
    start = text.find(marker)
    if start < 0:
        return None
    brace = text.find("{", start)
    if brace < 0:
        return None
    depth = 0
    in_string = False
    escaped = False
    for i in range(brace, len(text)):
        ch = text[i]
        if in_string:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                in_string = False
            continue
        if ch == '"':
            in_string = True
        elif ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return text[start:i + 1]
    return None


def main() -> int:
    if not SOURCE.is_file() or not REGISTRY.is_file():
        raise SystemExit("required lifted source or function registry is missing")
    source = SOURCE.read_text(errors="replace")
    registry = REGISTRY.read_text(errors="replace")
    function = extract_function(source, "sub_10021138")
    if function is None:
        raise SystemExit("could not extract sub_10021138 from lifted source")

    text_hits = {}
    for label, value in ADDRESSES.items():
        token = f"0x{value:08x}"
        text_hits[label] = [
            {"file": str(p), "line": i + 1, "text": line.strip()}
            for p in [SOURCE, REGISTRY]
            for i, line in enumerate(p.read_text(errors="replace").splitlines())
            if token in line.lower()
        ]

    function_names = {}
    for label in ("game_method_pointer_1", "game_method_pointer_2"):
        value = ADDRESSES[label]
        needle = f"0x{value:08x}u"
        function_names[label] = [
            line.strip() for line in registry.splitlines() if needle in line.lower()
        ]

    # Search the archive tree for raw little-endian references to the known
    # game vtable/method pointers. This locates the source binary/data blobs
    # without assuming their file names or E32 file offsets.
    binary_hits = []
    patterns = {label: value.to_bytes(4, "little") for label, value in ADDRESSES.items()}
    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue
        try:
            data = path.read_bytes()
        except OSError:
            continue
        if len(data) > 64 * 1024 * 1024:
            continue
        for label, pattern in patterns.items():
            pos = data.find(pattern)
            if pos >= 0:
                binary_hits.append({"file": str(path), "address_label": label, "first_file_offset": pos})

    out = Path("step60-appui-audit")
    out.mkdir(exist_ok=True)
    (out / "sub_10021138.txt").write_text(function + "\n")
    report = {
        "callsite_function": "sub_10021138",
        "callsite_function_bytes": len(function),
        "function_body": function,
        "address_text_hits": text_hits,
        "method_pointer_registry_matches": function_names,
        "binary_first_hits": binary_hits,
        "scope_note": "A raw byte hit is a locator only; it is not yet an E32 VA-to-file-offset proof or a decoded vtable.",
    }
    (out / "appui-object-field-audit.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({
        "callsite_extracted": True,
        "callsite_bytes": len(function),
        "binary_hits": len(binary_hits),
        "method_pointer_registry_matches": function_names,
    }, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
