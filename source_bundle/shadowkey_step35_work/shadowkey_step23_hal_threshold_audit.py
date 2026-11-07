#!/usr/bin/env python3
from pathlib import Path
import sys

if len(sys.argv) != 3:
    raise SystemExit("usage: shadowkey_step23_hal_threshold_audit.py LOG FREE_RAM_BYTES")
log = Path(sys.argv[1]).read_text(errors="replace")
free_ram = int(sys.argv[2], 0)
threshold = 0x68afff

def req(ok, msg):
    if not ok:
        raise SystemExit("FAIL: " + msg)

req(f"HLE HAL::Get EMemoryRAMFree={free_ram} bytes" in log,
    "HAL::Get did not return the configured free-RAM model")
if free_ram > threshold:
    req("ENGINE before: +0x30=00000000 +0x34=00000000" in log,
        "high-free-RAM constructor branch did not initialize engine+0x34 to zero")
    req("GFX HLE: DrawText(gc=" in log,
        "unforced single RunL did not reach DrawText with high free-RAM model")
    req("GFX HLE: DiscardFont(gc=" in log,
        "unforced single RunL did not reach DiscardFont")
    print("PASS: HAL free-RAM model crosses the original constructor threshold; unmodified engine state reaches DrawText")
else:
    req("ENGINE before: +0x30=00000000 +0x34=00000001" in log,
        "low-free-RAM constructor branch did not initialize engine+0x34 to one")
    req("ENGINE RUNL live-state returned" in log,
        "RunL did not return to harness")
    req("GFX HLE: DrawText(gc=" not in log,
        "low-memory path unexpectedly reached DrawText")
    print("PASS: low-memory branch remains distinct and does not reach DrawText")
req("ngage_w32(&c,engine+0x34u,0u)" not in Path("shadowkey_engine_init_live_test.c").read_text(),
    "live harness forcibly changes engine+0x34")
print(f"PASS: no forced engine+0x34 write in live harness; threshold=0x{threshold:08x}")
print("LIMITATION: direct RunL invocation still bypasses CActiveScheduler; HAL free RAM is a configurable diagnostic model, not a measured N95 reading")
