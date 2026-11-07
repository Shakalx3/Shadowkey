#!/usr/bin/env python3
"""Verify the v8.4 diagnostic GC milestone and preserve the next stop point."""
from pathlib import Path
import sys

log_path = Path(sys.argv[1] if len(sys.argv) > 1 else ".build/asset_vfs_trace.log")
log = log_path.read_text(errors="replace")
checks = {
    "SystemGc returned a stable synthetic GC object": "CONE HLE SystemGc -> synthetic CWindowGc=102fe100",
    "DrawableWindow returned a synthetic window": "CONE HLE DrawableWindow -> synthetic window=102fe200",
    "GC Activate virtual dispatch completed": "CONE GC Activate(this=102fe100, window=102fe200)",
    "GC Deactivate virtual dispatch completed": "CONE GC Deactivate(this=102fe100)",
    "entities.txt opened": "entities.txt' -> '" ,
    "menu_sprites.txt opened": "menu_sprites.txt' -> '",
    "EUSER ordinal 1 is executed as memset": "HLE memset dst=10162918 value=00 length=36608",
    "next failure is the newly localized 0x80 dereference": "OOB 00000080/4",
    "next failure has a null manager table entry": "source+0x14a3c=00000000",
}
missing = [label for label, needle in checks.items() if needle not in log]
if "UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1 (" in log:
    missing.append("EUSER ordinal 1 memset is still unimplemented")
if "OOB 00000000/4 lr=100228a8" in log:
    missing.append("old ordinal-226 null-return crash is still present")
if missing:
    for item in missing:
        print("FAIL:", item)
    raise SystemExit(1)
for item in checks:
    print("PASS:", item)
print("PASS: original trace advanced beyond the ordinal-226 null dereference")
