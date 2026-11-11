#!/usr/bin/env python3
"""Read-only feasibility audit for redirecting legacy EUSER!1575 to a local E32 shim."""
from __future__ import annotations

import argparse
import json
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from step86_inspect_game_e32_header import inspect  # noqa: E402


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def word_sum(data: bytes) -> int:
    padded = data + (b"\0" * ((-len(data)) & 3))
    if not padded:
        return 0
    return sum(struct.unpack("<" + "I" * (len(padded) // 4), padded)) & 0xFFFFFFFF


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--game", type=Path, required=True)
    ap.add_argument("--dispatch", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--custom-dll-name", default="ShadowkeyCompat{000a0000}[E000BEEF].dll")
    args = ap.parse_args()

    data = args.game.read_bytes()
    header, blocks, _exports, slots = inspect(args.game)
    code_off = int(header["code_offset"])
    code_size = int(header["code_size"])
    text_size = int(header["text_size"])
    code_base = int(header["code_base"], 16)
    import_off = int(header["import_offset"])
    import_size = int(header["import_table_size"])
    import_end = import_off + import_size
    total_imports = int(header["iat_slots"])

    # EKA1 and EKA2 headers share later code/import offsets, but differ in
    # the words immediately after the EPOC signature. Validate, don't guess.
    word14, word18, word1c, word20 = (u32(data, x) for x in (0x14, 0x18, 0x1C, 0x20))
    cpu_names = {0x1000: "x86", 0x2000: "ARM", 0x4000: "MCore"}
    code_checksum = word_sum(data[code_off:code_off + text_size])
    data_off = int(header["data_offset"])
    data_size = int(header["data_size"])
    data_checksum = word_sum(data[data_off:data_off + data_size])
    legacy_header_match = (
        word14 in cpu_names and word18 == code_checksum and word1c == data_checksum
    )

    # Recover the exact import-descriptor byte range and all DLL-name offsets.
    pos = import_off + 4
    descriptors = []
    for index in range(int(header["dll_ref_count"])):
        if pos + 8 > import_end:
            raise SystemExit(f"descriptor {index} exceeds import table")
        name_rel, count = struct.unpack_from("<II", data, pos)
        name_off = import_off + name_rel
        end = data.find(b"\0", name_off, import_end)
        if end < 0:
            raise SystemExit(f"unterminated DLL name for descriptor {index}")
        name = data[name_off:end].decode("ascii", "replace")
        desc_end = pos + 8 + 4 * count
        if desc_end > import_end:
            raise SystemExit(f"ordinal array for {name} exceeds import table")
        ordinals = list(struct.unpack_from("<" + "I" * count, data, pos + 8)) if count else []
        descriptors.append({
            "index": index,
            "dependency": name,
            "descriptor_file_offset": pos,
            "name_file_offset": name_off,
            "import_count": count,
            "ordinals": ordinals,
            "descriptor_end": desc_end,
        })
        pos = desc_end
    descriptor_end = pos
    name_start = min((x["name_file_offset"] for x in descriptors), default=import_end)

    matches = []
    global_index = 0
    for block in descriptors:
        for within, ordinal in enumerate(block["ordinals"]):
            if block["dependency"].split("[")[0].lower() == "euser" and ordinal == 1575:
                matches.append({
                    "block_index": block["index"],
                    "dependency": block["dependency"],
                    "ordinal": ordinal,
                    "ordinal_index_in_block": within,
                    "global_iat_index": global_index,
                    "slot_address": code_base + text_size + 4 * global_index,
                    "descriptor_file_offset": block["descriptor_file_offset"],
                    "descriptor_end": block["descriptor_end"],
                    "block_import_count": block["import_count"],
                })
            global_index += 1
    if len(matches) != 1:
        raise SystemExit(f"expected exactly one EUSER!1575 import, found {len(matches)}")
    target = matches[0]

    dispatch_text = args.dispatch.read_text(encoding="utf-8", errors="replace")
    rx = re.compile(
        r'\{\s*(0x[0-9a-fA-F]+)u,\s*(0x[0-9a-fA-F]+)u,\s*"([A-Z0-9]+)\[[^]]+\]\.DLL",\s*(\d+)u\s*\}'
    )
    dispatch = []
    for thunk, slot, dll, ordinal in rx.findall(dispatch_text):
        if dll.lower() == "euser" and int(ordinal) == 1575:
            dispatch.append({
                "thunk_address": int(thunk, 16),
                "slot_address": int(slot, 16),
                "dll": dll,
                "ordinal": int(ordinal),
            })
    if len(dispatch) != 1:
        raise SystemExit(f"expected one EUSER!1575 dispatch row, found {len(dispatch)}")
    thunk = dispatch[0]
    if thunk["slot_address"] != target["slot_address"]:
        raise SystemExit("dispatch IAT address does not match parsed import-table order")

    thunk_file_off = code_off + (thunk["thunk_address"] - code_base)
    thunk_words = list(struct.unpack_from("<III", data, thunk_file_off))
    thunk_literal = u32(data, thunk_file_off + 12)
    expected_words = [0xE59FC004, 0xE59CC000, 0xE12FFF1C]
    target_slot_rows = [
        x for x in slots
        if x["dependency"].split("[")[0].lower() == "euser" and x["ordinal"] == 1575
    ]
    if len(target_slot_rows) != 1:
        raise SystemExit(f"step86 IAT scan found {len(target_slot_rows)} EUSER!1575 slots")
    slot_row = target_slot_rows[0]
    ref_offsets = [int(x, 16) for x in slot_row["reference_offsets"].split(",") if x]
    thunk_literal_file_off = thunk_file_off + 12
    thunk_consistent = (
        thunk_words == expected_words
        and thunk_literal == target["slot_address"]
        and ref_offsets == [thunk_literal_file_off]
        and slot_row["reference_count"] == 1
    )
    if not thunk_consistent:
        raise SystemExit("EUSER!1575 thunk/literal/IAT cross-check failed")

    iat_start_va = code_base + text_size
    iat_end_offset = text_size + 4 * total_imports
    iat_tail_bytes = code_size - iat_end_offset
    if iat_tail_bytes < 0:
        raise SystemExit("IAT exceeds code segment")
    new_slot_index = total_imports - 1
    new_slot_va = iat_start_va + 4 * new_slot_index

    code_reloc_off = u32(data, 0x70)
    code_reloc_size = u32(data, 0x74)
    data_reloc_off = u32(data, 0x78)
    data_reloc_size = u32(data, 0x7C)
    relocations = []
    for name, off, size in (
        ("code", code_reloc_off, code_reloc_size),
        ("data", data_reloc_off, data_reloc_size),
    ):
        relocations.append({
            "kind": name,
            "offset": off,
            "size": size,
            "present": bool(off and size),
            "starts_after_import_table": bool(off and off >= import_end),
        })

    # Remove one ordinal from EUSER (-4 descriptor bytes), then append a
    # one-ordinal DLL block (+12 descriptor bytes). The IAT count is unchanged.
    name_bytes = args.custom_dll_name.encode("ascii") + b"\0"
    name_padded = (len(name_bytes) + 3) & ~3
    descriptor_growth = 8
    import_table_growth = descriptor_growth + name_padded
    all_slot_refs = sum(int(x["reference_count"]) for x in slots)
    zero_ref_slots = sum(1 for x in slots if int(x["reference_count"]) == 0)

    result = {
        "format": "read-only feasibility audit; original binary not modified",
        "game_file": str(args.game),
        "file_size": len(data),
        "header_words_after_epoc": {
            "offset_0x14": f"0x{word14:08X}",
            "offset_0x18": f"0x{word18:08X}",
            "offset_0x1C": f"0x{word1c:08X}",
            "offset_0x20": f"0x{word20:08X}",
            "legacy_cpu_guess": cpu_names.get(word14, "not a known EKA1 CPU marker"),
            "legacy_code_checksum_computed": f"0x{code_checksum:08X}",
            "legacy_data_checksum_computed": f"0x{data_checksum:08X}",
            "legacy_eka1_header_interpretation_matches": legacy_header_match,
        },
        "e32_layout": {
            "flags": header["flags"],
            "code_base": header["code_base"],
            "code_offset": code_off,
            "code_size": code_size,
            "text_size": text_size,
            "data_offset": data_off,
            "data_size": data_size,
            "import_offset": import_off,
            "import_size": import_size,
            "import_end": import_end,
            "code_ends_at_import_offset": header["code_ends_at_import_offset"],
            "dll_ref_count": header["dll_ref_count"],
            "iat_slots": total_imports,
            "iat_start_va": f"0x{iat_start_va:08X}",
            "iat_end_offset_in_code": iat_end_offset,
            "iat_tail_bytes": iat_tail_bytes,
            "import_descriptor_end": descriptor_end,
            "first_name_offset": name_start,
            "bytes_between_descriptors_and_import_end": import_end - descriptor_end,
            "relocations": relocations,
        },
        "target_import": {
            **target,
            "thunk_address": f"0x{thunk['thunk_address']:08X}",
            "thunk_file_offset": f"0x{thunk_file_off:08X}",
            "thunk_words": [f"0x{x:08X}" for x in thunk_words],
            "literal_file_offset": f"0x{thunk_literal_file_off:08X}",
            "literal_value": f"0x{thunk_literal:08X}",
            "literal_reference_count": slot_row["reference_count"],
            "literal_reference_offsets": slot_row["reference_offsets"],
        },
        "candidate_local_shim_import": {
            "dll_name": args.custom_dll_name,
            "ordinal": 1,
            "new_global_iat_index_if_appended": new_slot_index,
            "new_iat_slot_va_if_appended": f"0x{new_slot_va:08X}",
            "descriptor_growth_bytes": descriptor_growth,
            "new_name_storage_bytes_aligned": name_padded,
            "net_import_table_growth_bytes": import_table_growth,
            "iat_count_remains_unchanged": True,
            "required_code_pointer_rewrites": {
                "old_slot": f"0x{target['slot_address']:08X}",
                "new_slot": f"0x{new_slot_va:08X}",
                "slots_after_removed_global_index": "rebase each referenced IAT pointer by -4 bytes",
                "old_euser_1575_thunk": "rewrite its literal to the appended custom-DLL IAT slot",
            },
            "all_iat_literal_reference_count": all_slot_refs,
            "iat_slots_with_no_literal_references": zero_ref_slots,
        },
        "safety_gates": [
            "Do not patch until EKA1/EKA2 header format is conclusively identified.",
            "Recompute the correct code checksum or header CRC after any code/import change.",
            "Account for relocation-table movement if either relocation section follows the import table.",
            "Verify every IAT literal rewrite against ARM disassembly, not only byte-pattern scans.",
            "Write a separate patched copy and byte-compare all untouched ranges; never overwrite 6R51.APP.",
            "Test the patched image with an EKA2 loader before any game launch attempt.",
        ],
    }

    args.out_dir.mkdir(parents=True, exist_ok=True)
    (args.out_dir / "STEP103_LOCAL_SHIM_PATCH_FEASIBILITY.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="utf-8"
    )
    lines = [
        "# Step103 — EUSER!1575 local-shim patch feasibility",
        "",
        "Read-only analysis. The original 6R51.APP is not modified.",
        "",
        "## Header-format discriminator",
        "",
        f"- Word at 0x14: {result['header_words_after_epoc']['offset_0x14']} ({result['header_words_after_epoc']['legacy_cpu_guess']})",
        f"- Word at 0x18: {result['header_words_after_epoc']['offset_0x18']}; computed legacy code checksum: {result['header_words_after_epoc']['legacy_code_checksum_computed']}",
        f"- Word at 0x1C: {result['header_words_after_epoc']['offset_0x1C']}; computed legacy data checksum: {result['header_words_after_epoc']['legacy_data_checksum_computed']}",
        f"- EKA1 legacy-header interpretation matches: **{legacy_header_match}**",
        "",
        "## Exact import and thunk",
        "",
        f"- Import: {target['dependency']}!{target['ordinal']}",
        f"- Import block: {target['block_index']}; ordinal index in block: {target['ordinal_index_in_block']}; global IAT index: {target['global_iat_index']}",
        f"- IAT slot: 0x{target['slot_address']:08X}",
        f"- ARM thunk: 0x{thunk['thunk_address']:08X}; literal at 0x{thunk_literal_file_off:08X} points to the IAT slot",
        f"- Exact thunk/literal cross-check: **{thunk_consistent}**; literal references: {slot_row['reference_count']}",
        "",
        "## Import-table growth and relocation constraints",
        "",
        f"- Current imports: {total_imports} IAT slots across {header['dll_ref_count']} DLL blocks",
        f"- IAT begins at 0x{iat_start_va:08X}; {iat_tail_bytes} bytes remain after its current end inside the code segment",
        f"- Import table: file offset 0x{import_off:X}, size 0x{import_size:X}, descriptor end 0x{descriptor_end:X}, end 0x{import_end:X}",
        f"- Proposed split-and-append grows the import table by {import_table_growth} bytes while keeping the IAT slot count unchanged",
        f"- Relocation sections: {relocations}",
        "",
        "## Candidate plan (not applied)",
        "",
        "Remove only EUSER ordinal 1575 from its existing block; append a new one-entry block for the custom DLL at ordinal 1; rebuild the IAT in block order; move the removed import's thunk literal to the new final IAT slot; and rebase every later IAT literal pointer by -4. This avoids reusing an unrelated N95 ordinal. It is only a candidate until the header/checksum/relocation gates below are resolved.",
        "",
        "## Mandatory safety gates",
        "",
    ] + [f"- {x}" for x in result["safety_gates"]] + [""]
    (args.out_dir / "STEP103_LOCAL_SHIM_PATCH_FEASIBILITY.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
