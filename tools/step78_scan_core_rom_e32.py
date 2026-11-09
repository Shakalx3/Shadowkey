#!/usr/bin/env python3
"""Inspect the carved SOS+CORE payload for Symbian E32 images."""
from pathlib import Path
import hashlib
import struct

rom = Path("firmware-parsed/carved/rom-sos-core.img")
out = Path("firmware-input/STEP78_CORE_ROM_E32_SCAN.txt")
lines = []
if not rom.exists():
    lines.append("SOS+CORE image missing")
else:
    size = rom.stat().st_size
    h = hashlib.sha256()
    with rom.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
        f.seek(0)
        first = f.read(256)
    lines.append(f"path={rom} size={size} sha256={h.hexdigest()}")
    lines.append("first256=" + first.hex())
    lines.append("ascii=" + "".join(chr(b) if 32 <= b < 127 else "." for b in first))
    hits = []
    with rom.open("rb") as f:
        carry = b""
        absolute = 0
        while True:
            chunk = f.read(1024 * 1024)
            if not chunk:
                break
            data = carry + chunk
            base = absolute - len(carry)
            pos = 0
            while True:
                pos = data.find(b"EPOC", pos)
                if pos < 0:
                    break
                header = base + pos - 0x10
                if header >= 0:
                    fpos = f.tell()
                    f.seek(header)
                    b = f.read(0x80)
                    f.seek(fpos)
                    if len(b) >= 0x60:
                        uid1, uid2, uid3 = struct.unpack_from("<III", b, 0)
                        if uid1 in (0x10000079, 0x1000007A):
                            version = struct.unpack_from("<I", b, 0x18)[0]
                            export_field = struct.unpack_from("<I", b, 0x5C)[0]
                            hits.append((header, uid1, uid2, uid3, version, export_field))
                pos += 4
            absolute += len(chunk)
            carry = data[-3:]
    lines.append(f"valid_E32_headers={len(hits)}")
    for off, uid1, uid2, uid3, version, export_field in hits:
        lines.append(f"0x{off:08X}\t{uid1:08X}\t{uid2:08X}\t{uid3:08X}\t{version:08X}\t0x{export_field:08X}")
    for name in (b"EUSER.DLL", b"CONE.DLL", b"GDI.DLL", b"FBSCLI.DLL", b"EIKCORE.DLL"):
        with rom.open("rb") as f:
            positions = []
            start = 0
            while True:
                f.seek(start)
                block = f.read(1024 * 1024)
                if not block:
                    break
                p = block.find(name)
                if p >= 0:
                    positions.append(start + p)
                start += max(1, len(block) - len(name) + 1)
        lines.append(f"{name.decode()}: " + (", ".join(f"0x{x:X}" for x in positions) if positions else "not found"))
text = "\n".join(lines) + "\n"
out.write_text(text, encoding="utf-8")
print(text, end="")
