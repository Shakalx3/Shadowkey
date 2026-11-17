#!/usr/bin/env python3
"""Read-only feasibility audit for redirecting legacy EUSER!1575 to a local E32 shim."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from step86_inspect_game_e32_header import inspect  # noqa: E402


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def word_sum(data: bytes, byteorder: str = "<") -> int:
    padded = data + (b"\0" * ((-len(data)) & 3))
    if not padded:
        return 0
    return sum(struct.unpack(byteorder + "I" * (len(padded) // 4), padded)) & 0xFFFFFFFF


def parse_eka1_reloc(data: bytes, off: int, code_off: int, expected_file_offsets=(), target_file_offset=None):
    if off == 0:
        return {"present": False, "offset": 0}
    if off < 0 or off + 8 > len(data):
        return {"present": True, "offset": off, "valid_header_bounds": False}
    section_size, declared_count = struct.unpack_from("<II", data, off)
    expected_rel = {x - code_off for x in expected_file_offsets}
    # step86's bytewise scan also finds unaligned coincidental 32-bit patterns.
    # ARM literal-pool/IAT pointer words must be word-aligned relocation sites.
    aligned_expected_rel = {x for x in expected_rel if (x & 3) == 0}
    unaligned_expected_rel = expected_rel - aligned_expected_rel
    attempts = []
    for includes_header in (True, False):
        end = off + section_size if includes_header else off + 8 + section_size
        pos = off + 8
        blocks = count = bad_types = bad_pages = 0
        type_counts = {1: 0, 2: 0, 3: 0}
        targets = set()
        first_blocks = []
        error = None
        if end > len(data) or end < pos:
            error = "section end outside file"
        while error is None and pos < end:
            if pos + 8 > end:
                error = "truncated relocation block header"
                break
            page_off, block_size = struct.unpack_from("<II", data, pos)
            if block_size < 8 or block_size % 4 or pos + block_size > end:
                error = "invalid relocation block size"
                break
            if page_off % 0x1000:
                bad_pages += 1
            nbytes = block_size - 8
            entries = struct.unpack_from("<" + "H" * (nbytes // 2), data, pos + 8) if nbytes else ()
            nonzero = 0
            for entry in entries:
                if entry == 0:
                    continue
                nonzero += 1
                kind = entry >> 12
                if kind in type_counts:
                    type_counts[kind] += 1
                else:
                    bad_types += 1
                targets.add(page_off + (entry & 0x0FFF))
            if len(first_blocks) < 4:
                first_blocks.append({"page_offset": page_off, "block_size": block_size, "nonzero_entries": nonzero})
            count += nonzero
            blocks += 1
            pos += block_size
        valid = error is None and pos == end and count == declared_count and bad_types == 0 and bad_pages == 0
        attempts.append({
            "size_includes_header": includes_header, "candidate_end": end,
            "candidate_section_bytes": end - off, "parsed_end": pos,
            "block_count": blocks, "parsed_relocation_count": count,
            "declared_relocation_count": declared_count, "type_counts": type_counts,
            "bad_type_entries": bad_types, "unaligned_page_offsets": bad_pages,
            "expected_iat_references": len(expected_rel),
            "unaligned_byte_scan_matches": len(unaligned_expected_rel),
            "aligned_expected_iat_references": len(aligned_expected_rel),
            "matched_aligned_iat_references": len(aligned_expected_rel & targets),
            "missing_aligned_iat_references": [f"0x{x + code_off:08X}" for x in sorted(aligned_expected_rel - targets)],
            "matched_iat_references_all_offsets": len(expected_rel & targets),
            "missing_iat_references": [f"0x{x + code_off:08X}" for x in sorted(expected_rel - targets)[:24]],
            "target_literal_relocated": target_file_offset is not None and (target_file_offset - code_off) in targets,
            "first_blocks": first_blocks, "error": error, "valid": valid
        })
    valid_attempts = [x for x in attempts if x["valid"]]
    chosen = next((x for x in valid_attempts if x["size_includes_header"]), valid_attempts[0] if valid_attempts else attempts[0])
    return {
        "present": True, "offset": off, "section_size_field": section_size,
        "declared_relocation_count": declared_count, "header_hex": data[off:off+16].hex(),
        "attempts": attempts, "chosen_interpretation": chosen, "valid": chosen["valid"],
        "trailing_bytes_after_chosen_end": len(data) - chosen["candidate_end"] if chosen["valid"] else None,
        "trailing_hex": data[chosen["candidate_end"]:chosen["candidate_end"]+16].hex() if chosen["valid"] else None
    }



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

    # Legacy EKA1 field map: separate structural layout validation from checksum validation.
    word14, word18, word1c, word20 = (u32(data, x) for x in (0x14, 0x18, 0x1C, 0x20))
    cpu_names = {0x1000: "x86", 0x2000: "ARM", 0x4000: "MCore"}
    code_checksum_text = word_sum(data[code_off:code_off + text_size], "<")
    code_checksum_code = word_sum(data[code_off:code_off + code_size], "<")
    code_checksum_text_big = word_sum(data[code_off:code_off + text_size], ">")
    code_checksum_code_big = word_sum(data[code_off:code_off + code_size], ">")
    data_off = int(header["data_offset"])
    data_size = int(header["data_size"])
    data_checksum = word_sum(data[data_off:data_off + data_size])
    priority = u32(data, 0x78)
    legacy_header_layout_match = (
        word14 in cpu_names and code_off == 0x7C and code_off + code_size == import_off
    )
    legacy_code_checksum_matches_code = word18 == code_checksum_code
    legacy_code_checksum_matches_code_big_endian = word18 == code_checksum_code_big

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

    # EKA1 uses offsets at 0x70/0x74 and a 32-bit process priority at 0x78.
    code_reloc_off = u32(data, 0x70)
    data_reloc_off = u32(data, 0x74)
    all_iat_reference_file_offsets = [
        int(off, 16) for row in slots for off in row["reference_offsets"].split(",") if off
    ]
    code_reloc = parse_eka1_reloc(
        data, code_reloc_off, code_off, all_iat_reference_file_offsets, thunk_literal_file_off
    )
    data_reloc = parse_eka1_reloc(data, data_reloc_off, code_off)
    relocations = [
        {"kind": "code", **code_reloc, "starts_after_import_table": bool(code_reloc_off and code_reloc_off >= import_end)},
        {"kind": "data", **data_reloc, "starts_after_import_table": bool(data_reloc_off and data_reloc_off >= import_end)},
    ]

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
        "game_sha256": hashlib.sha256(data).hexdigest(),
        "header_words_after_epoc": {
            "offset_0x14": f"0x{word14:08X}",
            "offset_0x18": f"0x{word18:08X}",
            "offset_0x1C": f"0x{word1c:08X}",
            "offset_0x20": f"0x{word20:08X}",
            "legacy_cpu_guess": cpu_names.get(word14, "not a known EKA1 CPU marker"),
            "legacy_code_checksum_text_size": f"0x{code_checksum_text:08X}",
            "legacy_code_checksum_code_size": f"0x{code_checksum_code:08X}",
            "legacy_code_checksum_text_big_endian": f"0x{code_checksum_text_big:08X}",
            "legacy_code_checksum_code_big_endian": f"0x{code_checksum_code_big:08X}",
            "legacy_code_checksum_matches_code_size": legacy_code_checksum_matches_code,
            "legacy_code_checksum_matches_big_endian_code_size": legacy_code_checksum_matches_code_big_endian,
            "legacy_data_checksum_computed": f"0x{data_checksum:08X}",
            "legacy_eka1_header_layout_matches": legacy_header_layout_match,
            "legacy_priority_at_0x78": priority,
        },
        "e32_image_identity": {
            "uid1": header["uid1"],
            "uid2": header["uid2"],
            "uid3": header["uid3"],
            "module_kind": header["module_kind"],
            "flags": header["flags"],
            "entry_point": header["entry_point"],
            "export_count": header["export_count"],
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
            "priority_at_0x78": priority,
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
            "required_header_updates": {
                "iCodeRelocOffset_0x70_before": f"0x{code_reloc_off:08X}",
                "iCodeRelocOffset_0x70_after": f"0x{(code_reloc_off + import_table_growth) if code_reloc_off else 0:08X}",
                "iDataRelocOffset_0x74_unchanged": f"0x{data_reloc_off:08X}",
                "iPriority_0x78_unchanged": priority,
                "code_relocation_section_bytes_unchanged": True,
            },
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
            "The EKA1 layout is structurally consistent, but this does not make the legacy image loadable by the N95 EKA2 loader.",
            ("The stored code checksum matches the ARM little-endian word sum over iCodeSize."
             if legacy_code_checksum_matches_code else
             "The stored code checksum does not match the ARM little-endian word sum over iCodeSize; resolve this before modifying code bytes."),
            ("The big-endian diagnostic code word sum matches the stored checksum; this is not accepted as an ARM checksum."
             if legacy_code_checksum_matches_code_big_endian else
             "The big-endian diagnostic code word sum does not match the stored checksum."),
            "Use EKA1 relocation offsets at 0x70 and 0x74; 0x78 is process priority, not a relocation offset or size.",
            "The code relocation section follows the import table; update iCodeRelocOffset by the import-table growth.",
            "Verify parsed relocation blocks and word-aligned IAT-literal coverage before any patch.",
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
        f"- Input SHA-256: `{hashlib.sha256(data).hexdigest()}`",
        "",
        "## Header-format discriminator",
        "",
        f"- CPU at 0x14: {result['header_words_after_epoc']['offset_0x14']} ({result['header_words_after_epoc']['legacy_cpu_guess']})",
        f"- Code checksum stored: {result['header_words_after_epoc']['offset_0x18']}; little-endian text/code sums: {result['header_words_after_epoc']['legacy_code_checksum_text_size']} / {result['header_words_after_epoc']['legacy_code_checksum_code_size']}; big-endian text/code sums: {result['header_words_after_epoc']['legacy_code_checksum_text_big_endian']} / {result['header_words_after_epoc']['legacy_code_checksum_code_big_endian']}",
        f"- Data checksum stored/computed: {result['header_words_after_epoc']['offset_0x1C']} / {result['header_words_after_epoc']['legacy_data_checksum_computed']}",
        f"- EKA1 layout structural match: **{legacy_header_layout_match}**; code checksum match: **{legacy_code_checksum_matches_code}**",
        f"- EKA1 priority at 0x78: {priority}",
        "",
        "## E32 image identity",
        "",
        f"- UID1/UID2/UID3: {header['uid1']} / {header['uid2']} / {header['uid3']} ({header['module_kind']})",
        f"- Flags: {header['flags']}; entry point: {header['entry_point']}; exports: {header['export_count']}",
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
