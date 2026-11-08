#!/usr/bin/env python3
"""Map selected original N-Gage imports to S60 3.1 FP1 ARMv5 DSO exports."""
from __future__ import annotations
import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path

CASES = [
    ("euser", 1407, "_ZN9E32Loader13ProcessLoadedER18TProcessCreateInfo", "_ZN7TPtrC16C1EPKt", 1169),
    ("euser", 1575, "_ZNK15RSubSessionBase13DoSendReceiveEiPK8TIpcArgsR14TRequestStatus", None, None),
    ("cone", 160, "_ZN7CCoeEnv18LeaveWithErrorTextERK7TDesC16PS1_", "_ZNK11CCoeControl4RectEv", 276),
    ("gdi", 101, "_ZN18MGraphicsDeviceMapD0Ev", "_ZN10TFontStyle10SetPostureE12TFontPosture", 12),
    ("gdi", 108, "_ZN19TBidirectionalState12InternalizeLER11RReadStream", "_ZN10TFontStyle15SetStrokeWeightE17TFontStrokeWeight", 14),
    ("gdi", 151, "_ZN8CPicture14SetSizeInTwipsERK5TSize", "_ZN9TFontSpecC1ERK7TDesC16i", 169),
    ("eikcore", 224, "_ZN9CEikonEnv18DestroyEnvironmentEv", "_ZN9CEikAppUiC2Ev", 178),
]
RUNTIME = {
    "euser": {"memmove": 1954, "memset": 1955},
    "estlib": {"__stderr": 18, "exit": 130, "fprintf": 141, "strcmp": 247, "strncmp": 257},
}


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True, stderr=subprocess.STDOUT)


def parse_symbols(text: str) -> dict[int, str]:
    result = {}
    for line in text.splitlines():
        m = re.match(r"\s*\d+:\s+([0-9a-fA-F]+)\s+\d+\s+\S+\s+GLOBAL\s+DEFAULT\s+(\S+)\s+(.+)$", line)
        if not m or m.group(2) == "UND":
            continue
        value = int(m.group(1), 16)
        if value % 4:
            continue
        raw = m.group(3).strip().split("@@", 1)[0]
        result[value // 4 + 1] = raw
    return result


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sdk-root", type=Path, required=True)
    ap.add_argument("--readelf", default="readelf")
    ap.add_argument("--output-dir", type=Path, default=Path("step58-report"))
    args = ap.parse_args()

    libdir = args.sdk_root / "Epoc32/release/armv5/lib"
    dlls = sorted({c[0] for c in CASES} | set(RUNTIME))
    exports = {}
    metadata = {}
    for dll in dlls:
        path = libdir / f"{dll}.dso"
        if not path.is_file():
            raise SystemExit(f"missing target DSO: {path}")
        header = run(args.readelf, "-h", str(path))
        if "ELF32" not in header or "ARM" not in header or "Version4 EABI" not in header:
            raise SystemExit(f"unexpected target DSO ABI for {path}:\n{header}")
        text = run(args.readelf, "-Ws", str(path))
        metadata[dll] = {
            "path": str(path),
            "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            "abi": "ELF32 ARM EABI4",
        }
        exports[dll] = parse_symbols(text)

    rows = []
    failures = []
    for dll, old_ord, collision, expected, expected_ord in CASES:
        actual_collision = exports[dll].get(old_ord)
        actual_expected_ord = next((o for o, s in exports[dll].items() if s == expected), None) if expected else None
        ok = actual_collision == collision and actual_expected_ord == expected_ord
        if not ok:
            failures.append(
                f"{dll} old#{old_ord}: collision={actual_collision!r}, expected={collision!r}; "
                f"API ordinal={actual_expected_ord}, expected={expected_ord}"
            )
        rows.append({
            "dll": dll,
            "original_ngage_ordinal": old_ord,
            "target_symbol_at_same_ordinal": actual_collision,
            "target_api_symbol": expected,
            "target_api_ordinal": actual_expected_ord,
            "status": "PASS" if ok else "FAIL",
        })

    runtime_rows = []
    for dll, symbols in RUNTIME.items():
        reverse = {symbol: ordinal for ordinal, symbol in exports[dll].items()}
        for symbol, expected_ord in symbols.items():
            actual_ord = reverse.get(symbol)
            ok = actual_ord == expected_ord
            if not ok:
                failures.append(f"runtime {dll}:{symbol} ordinal={actual_ord}, expected={expected_ord}")
            runtime_rows.append({
                "dll": dll, "symbol": symbol, "ordinal": actual_ord,
                "status": "PASS" if ok else "FAIL",
            })

    int64_names = [s for s in exports["euser"].values() if "TInt64" in s]
    report = {
        "target_sdk": "Nokia S60 3.1 FP1 / Symbian OS 9.2 SDK ARMv5",
        "ordinal_rule": "ELF DSO dynsym st_value / 4 + 1; only aligned GLOBAL DEFAULT defined symbols",
        "dsos": metadata,
        "game_import_remaps": rows,
        "runtime_imports": runtime_rows,
        "euser_exports_containing_TInt64": int64_names,
        "tint64_operator_not_equal_exported": any("TInt64" in s and "ne" in s for s in int64_names),
        "result": "PASS" if not failures else "FAIL",
        "failures": failures,
        "device_rom_verified": False,
    }
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "target-export-remap.json").write_text(json.dumps(report, indent=2) + "\n")

    lines = [
        "# Step 58 — N95 S60 3.1 FP1 target export remap", "",
        "Target: S60 3.1 FP1 / Symbian OS 9.2 SDK ARMv5 DSO export tables.",
        "Ordinal derivation: defined GLOBAL DSO dynsym st_value / 4 + 1.",
        "This is SDK evidence, not a dump of the user's N95 ROM.", "",
        "## Game import ordinal collisions and replacements", "",
        "| DLL | Original N-Gage ordinal | Target export at unchanged ordinal | Correct target API export | Target ordinal | Result |",
        "|---|---:|---|---|---:|---|",
    ]
    for r in rows:
        lines.append(
            f"| {r['dll'].upper()} | {r['original_ngage_ordinal']} | "
            f"`{r['target_symbol_at_same_ordinal']}` | "
            f"`{r['target_api_symbol'] or 'not exported'}` | "
            f"{r['target_api_ordinal'] or '—'} | {r['status']} |"
        )
    lines += ["", "## C/OpenC runtime imports", "", "| DLL | Symbol | Target ordinal | Result |", "|---|---|---:|---|"]
    for r in runtime_rows:
        lines.append(f"| {r['dll'].upper()} | `{r['symbol']}` | {r['ordinal']} | {r['status']} |")
    lines += [
        "", "## TInt64 operator", "",
        f"EUSER DSO exports containing `TInt64`: {len(int64_names)}.",
        "The original N-Gage ARM import for `TInt64::operator!=` has no matching named export in this S60 EUSER DSO; implement it locally or patch the import callsite only after confirming the exact comparison semantics.",
        "", "## Boundaries", "",
        "- The target DSO tables are from the pinned S60 3.1 FP1 SDK, not a physical N95 ROM dump.",
        "- The target DSO ABI is EABI4; the recovered ARMv6 object set is EABI5. The final link/loader compatibility between these artifacts remains a separate validation gate.",
        "- CEikAppUi C2 (ordinal 178) is the candidate base-object constructor because the game constructs CEikAppUi as a base subobject. Verify the target header layout before patching the import.",
        "- No binary import patch has been applied by this audit.", "",
    ]
    (args.output_dir / "STEP58_N95_TARGET_EXPORT_REMAP.md").write_text("\n".join(lines))
    print(json.dumps({
        "result": report["result"],
        "game_remaps": len(rows),
        "runtime_imports": len(runtime_rows),
        "failures": failures,
    }, indent=2))
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
