# Step 69 — legacy CWindowGc slot-remap contract

Date: 2026-11-09

## Purpose

Turn the corrected Step68 byte-offset mapping into a small, reusable C contract for the future native graphics adapter. This is metadata and a lookup helper only; it is not a CWindowGc implementation, renderer, or HLE.

## Contract

The old game vptr includes an 8-byte header. The five observed byte-offset remaps are:

| Legacy byte offset | Target byte offset | Method |
|---:|---:|---|
| 0x48 | 0x48 | SetPenColor |
| 0xB8 | 0xC0 | Clear |
| 0xC0 | 0xC8 | CopyRect |
| 0xD8 | 0xE0 | BitBltMasked(CWsBitmap) |
| 0xDC | 0xE4 | MapColors |

Files:
- `source_bundle/shadowkey_step35_work/shadowkey_legacy_cwindowgc_slots.h`
- `source_bundle/shadowkey_step35_work/shadowkey_legacy_cwindowgc_slots.c`

The function `shadowkey_cwindowgc_target_offset()` maps only the five known legacy byte offsets. Unknown offsets fail closed and do not get guessed.

## Test

`tools/step69_legacy_gc_slot_contract_test.c` verifies:
- the 8-byte prefix;
- all five legacy-to-target byte offsets;
- null output pointer rejection;
- unknown offset rejection.

The test is compiled with GCC using C99, `-Wall -Wextra -Werror`, then executed in the static-audit workflow.

<badge color="success">Host contract test PASS</badge>

- GitHub Actions run: `42573335365`, completed successfully.
- Workflow: `.github/workflows/shadowkey-static-audits.yml`.

## Limits

Passing this test confirms only that the committed remap table matches the Step68 analysis. It does not prove that a native proxy vtable exists, that forwarding thunks have correct register/stack argument handling, or that graphics work on Symbian. Those remain implementation and device-validation tasks.
