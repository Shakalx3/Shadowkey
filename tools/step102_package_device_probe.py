#!/usr/bin/env python3
"""Package only the custom Step102 test DLL/EXE and reversible-use instructions."""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
import zipfile
from pathlib import Path


def e32(path: Path) -> tuple[bytes, dict]:
    data = path.read_bytes()
    if len(data) < 0x7C or data[0x10:0x14] != b"EPOC":
        raise SystemExit(f"{path} is not a valid E32 image")

    def u(offset: int) -> int:
        return struct.unpack_from("<I", data, offset)[0]

    header = {
        "size": len(data),
        "uid1": u(0x00),
        "uid2": u(0x04),
        "uid3": u(0x08),
        "flags": u(0x2C),
        "code_size": u(0x30),
        "dll_ref_count": u(0x54),
        "export_count": u(0x5C),
    }
    if header["code_size"] <= 0:
        raise SystemExit(f"{path} has no code")
    return data, header


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dll", type=Path, required=True)
    ap.add_argument("--exe", type=Path, required=True)
    ap.add_argument("--readme", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    dll_data, dll_header = e32(args.dll)
    exe_data, exe_header = e32(args.exe)

    if (dll_header["uid1"], dll_header["uid2"], dll_header["uid3"]) != (
        0x10000079, 0x1000008D, 0xE000BEEF
    ):
        raise SystemExit(f"unexpected test DLL UIDs: {dll_header}")
    if not (dll_header["flags"] & 1) or dll_header["export_count"] != 1:
        raise SystemExit(f"test DLL header is not a one-export DLL: {dll_header}")
    if dll_header["dll_ref_count"] != 0:
        raise SystemExit(f"test DLL unexpectedly imports other DLLs: {dll_header}")

    if (exe_header["uid1"], exe_header["uid2"], exe_header["uid3"]) != (
        0x1000007A, 0x100039CE, 0xE000BEF0
    ):
        raise SystemExit(f"unexpected test EXE UIDs: {exe_header}")
    if (exe_header["flags"] & 1) or exe_header["export_count"] != 0:
        raise SystemExit(f"test EXE header is not an EXE: {exe_header}")
    if exe_header["dll_ref_count"] < 1:
        raise SystemExit(f"test EXE has no EUSER import dependency: {exe_header}")

    readme = args.readme.read_bytes()
    sums = (
        f"{sha256(dll_data)}  ShadowkeyCompat.dll\n"
        f"{sha256(exe_data)}  ShadowkeyAbiProbe.exe\n"
        f"{sha256(readme)}  README_FIRST_DEVICE_TEST.txt\n"
    ).encode("ascii")

    args.out.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(args.out, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        zf.writestr("ShadowkeyCompat.dll", dll_data)
        zf.writestr("ShadowkeyAbiProbe.exe", exe_data)
        zf.writestr("README_FIRST_DEVICE_TEST.txt", readme)
        zf.writestr("SHA256SUMS.txt", sums)

    sidecar = args.out.with_suffix(".sha256")
    sidecar.write_text(f"{sha256(args.out.read_bytes())}  {args.out.name}\n", encoding="ascii")
    print(json.dumps({
        "package": str(args.out),
        "package_size": args.out.stat().st_size,
        "package_sha256": sha256(args.out.read_bytes()),
        "dll": dll_header,
        "exe": exe_header,
        "contents": [
            "ShadowkeyCompat.dll",
            "ShadowkeyAbiProbe.exe",
            "README_FIRST_DEVICE_TEST.txt",
            "SHA256SUMS.txt",
        ],
    }, indent=2))


if __name__ == "__main__":
    main()
