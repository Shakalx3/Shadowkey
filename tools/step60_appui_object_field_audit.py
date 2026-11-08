#!/usr/bin/env python3
"""Extract the CEikAppUi construction callsite and locate related binary pointers."""
from __future__ import annotations
import hashlib
import json
import re
import struct
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


    # Map the vtable VAs back into the legacy E32 code payload and decode
    # their first function-pointer slots. This is separate from raw-byte hits.
    e32_image = ROOT / "6R51.APP"
    e32_header = None
    vtable_tables = []
    if e32_image.is_file():
        image = e32_image.read_bytes()
        if len(image) >= 0x80 and image[0x10:0x14] == b"EPOC":
            u32 = lambda off: struct.unpack_from("<I", image, off)[0]
            base, code_size, data_size = u32(0x4c), u32(0x30), u32(0x34)
            text_size, code_off = u32(0x60), u32(0x64)
            e32_header = {
                "file": str(e32_image), "file_size": len(image),
                "sha256": hashlib.sha256(image).hexdigest(),
                "base": f"0x{base:08x}", "code_size": code_size,
                "data_size": data_size, "text_size": text_size,
                "code_file_offset": code_off,
            }
            registry_map = {}
            for m in re.finditer(r"\\{\\s*(0x[0-9a-fA-F]+)u,\\s*(sub_[0-9a-fA-F]+)\\s*\\}", registry):
                registry_map[int(m.group(1), 16)] = m.group(2)
            vtable_addresses = {
                "primary_final": 0x100fc4d8,
                "menu_observer": 0x100fff00,
                "message_observer": 0x100fff64,
                "object_provider": 0x100fff54,
                "derived_table_a": 0x100fff34,
                "derived_table_b": 0x100fff40,
                "primary_initial_overwritten": 0x100ffe88,
                "temporary_a_overwritten": 0x100fdc90,
                "temporary_b_overwritten": 0x100fe050,
            }
            for label, va in vtable_addresses.items():
                row = {"label": label, "va": f"0x{va:08x}", "slots": []}
                rel = va - base
                if rel < 0 or rel + 4 > code_size:
                    row["status"] = "outside_code_segment"
                else:
                    off = code_off + rel
                    row["file_offset"] = off
                    row["status"] = "mapped_into_code_payload"
                    for slot in range(20):
                        pos = off + slot * 4
                        if pos + 4 > len(image):
                            break
                        value = struct.unpack_from("<I", image, pos)[0]
                        row["slots"].append({
                            "slot": slot, "value": f"0x{value:08x}",
                            "function": registry_map.get(value),
                            "points_into_code": base <= value < base + code_size,
                        })
                        if value == 0:
                            break
                vtable_tables.append(row)
            lines = [f"E32 image: {e32_image}", f"base={base:#010x} code_size={code_size:#x} text_size={text_size:#x} code_off={code_off:#x}"]
            for row in vtable_tables:
                lines.append(f"[{row['label']}] VA={row['va']} status={row['status']} file_off={row.get('file_offset')}")
                for slot in row["slots"]:
                    lines.append(f"  [{slot['slot']:02d}] {slot['value']} function={slot['function']} in_code={slot['points_into_code']}")
            (Path("step60-appui-audit") / "vtable-tables.txt").write_text("\\n".join(lines) + "\\n")
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
        "e32_image_header": e32_header,
        "vtable_tables": vtable_tables,
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
