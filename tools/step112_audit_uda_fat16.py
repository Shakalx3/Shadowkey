#!/usr/bin/env python3
"""Read-only FAT16 audit for the Nokia RM-320 UDA user-area image.

The tool locates a FAT16 BPB at offset zero, an MBR partition start, or a
512-byte-aligned offset in the first 2 MiB. It walks directories and FAT
chains without extracting or changing any file data.
"""
from __future__ import annotations

import argparse
import hashlib
import math
import struct
from pathlib import Path

FAT16_MIN_CLUSTERS = 4085
FAT16_MAX_CLUSTERS = 65524
# Search the complete expected RM-320 UDA image, with a bounded 128 MiB cap.
MAX_SCAN_BYTES = 128 * 1024 * 1024
MAX_DIRECTORY_DEPTH = 32


def u16(data: bytes, off: int) -> int:
    return struct.unpack_from("<H", data, off)[0]


def u32(data: bytes, off: int) -> int:
    return struct.unpack_from("<I", data, off)[0]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def parse_bpb(image: bytes, offset: int) -> dict | None:
    if offset < 0 or offset + 512 > len(image):
        return None
    boot = image[offset:offset + 512]
    if boot[510:512] != b"\x55\xAA":
        return None
    bps = u16(boot, 0x0B)
    spc = boot[0x0D]
    reserved = u16(boot, 0x0E)
    fats = boot[0x10]
    root_entries = u16(boot, 0x11)
    total16 = u16(boot, 0x13)
    media = boot[0x15]
    fat_size = u16(boot, 0x16)
    total32 = u32(boot, 0x20)
    total_sectors = total16 or total32
    if bps not in (512, 1024, 2048, 4096):
        return None
    if spc == 0 or spc > 128 or (spc & (spc - 1)):
        return None
    if reserved == 0 or fats not in (1, 2) or root_entries == 0 or fat_size == 0:
        return None
    if total_sectors == 0 or media not in (0xF0, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF):
        return None
    root_dir_sectors = math.ceil(root_entries * 32 / bps)
    first_data_sector = reserved + fats * fat_size + root_dir_sectors
    if total_sectors <= first_data_sector:
        return None
    cluster_count = (total_sectors - first_data_sector) // spc
    if not (FAT16_MIN_CLUSTERS <= cluster_count <= FAT16_MAX_CLUSTERS):
        return None
    if fat_size * bps // 2 < cluster_count + 2:
        return None
    volume_bytes = total_sectors * bps
    if offset + volume_bytes > len(image):
        return None
    return {
        "offset": offset,
        "bytes_per_sector": bps,
        "sectors_per_cluster": spc,
        "reserved_sectors": reserved,
        "fat_count": fats,
        "root_entries": root_entries,
        "total_sectors": total_sectors,
        "media_descriptor": f"0x{media:02X}",
        "fat_sectors": fat_size,
        "root_dir_sectors": root_dir_sectors,
        "first_data_sector": first_data_sector,
        "cluster_count": cluster_count,
        "cluster_size": bps * spc,
        "volume_bytes": volume_bytes,
        "fat_type": "FAT16",
    }


def candidate_offsets(image: bytes) -> list[int]:
    offsets = {0}
    if len(image) >= 512 and image[510:512] == b"\x55\xAA":
        for index in range(4):
            pos = 0x1BE + index * 16
            partition_type = image[pos + 4]
            start_lba = u32(image, pos + 8)
            size_lba = u32(image, pos + 12)
            if partition_type in (0x04, 0x06, 0x0E) and start_lba and size_lba:
                offsets.add(start_lba * 512)
    scan_end = min(len(image) - 512, MAX_SCAN_BYTES)
    for offset in range(512, scan_end + 1, 512):
        offsets.add(offset)
    return sorted(offsets)


def short_name(entry: bytes) -> str:
    raw = bytearray(entry[:11])
    if raw[0] == 0x05:
        raw[0] = 0xE5
    base = bytes(raw[:8]).decode("cp437", "replace").rstrip()
    ext = bytes(raw[8:11]).decode("cp437", "replace").rstrip()
    return base + (("." + ext) if ext else "")


def lfn_piece(entry: bytes) -> str:
    words = (
        list(struct.unpack_from("<5H", entry, 1))
        + list(struct.unpack_from("<6H", entry, 14))
        + list(struct.unpack_from("<2H", entry, 28))
    )
    raw = struct.pack("<13H", *words)
    return raw.decode("utf-16le", errors="replace").split("\0", 1)[0].replace("\uffff", "")


def inspect_volume(image: bytes, bpb: dict) -> dict:
    base = bpb["offset"]
    bps = bpb["bytes_per_sector"]
    spc = bpb["sectors_per_cluster"]
    cluster_size = bpb["cluster_size"]
    reserved = bpb["reserved_sectors"]
    fats = bpb["fat_count"]
    fat_sectors = bpb["fat_sectors"]
    root_entries = bpb["root_entries"]
    first_data_sector = bpb["first_data_sector"]
    cluster_count = bpb["cluster_count"]

    fat_offset = base + reserved * bps
    fat_bytes = fat_sectors * bps
    root_offset = base + (reserved + fats * fat_sectors) * bps
    root_bytes = root_entries * 32
    data_offset = base + first_data_sector * bps
    fat = image[fat_offset:fat_offset + fat_bytes]
    if len(fat) != fat_bytes:
        raise ValueError("truncated FAT16 allocation table")

    def next_cluster(cluster: int) -> int:
        if cluster < 0 or (cluster + 1) * 2 > len(fat):
            raise ValueError(f"FAT entry outside table for cluster {cluster}")
        return u16(fat, cluster * 2)

    def cluster_chain(start: int, expected_size: int | None = None) -> list[int]:
        if start == 0:
            if expected_size:
                raise ValueError("non-empty file/directory has cluster zero")
            return []
        chain = []
        seen = set()
        current = start
        while True:
            if current < 2 or current > cluster_count + 1:
                raise ValueError(f"cluster {current} outside FAT16 data range")
            if current in seen:
                raise ValueError(f"cluster-chain loop at {current}")
            seen.add(current)
            chain.append(current)
            nxt = next_cluster(current)
            if nxt >= 0xFFF8:
                break
            if nxt == 0 or nxt == 0xFFF7 or nxt >= 0xFFF0 or nxt < 2:
                raise ValueError(f"invalid FAT16 next-cluster value 0x{nxt:04X}")
            current = nxt
            if len(chain) > cluster_count:
                raise ValueError("cluster chain exceeds volume cluster count")
        if expected_size is not None and len(chain) * cluster_size < expected_size:
            raise ValueError(
                f"cluster chain too short: {len(chain) * cluster_size} < {expected_size}"
            )
        return chain

    def read_chain(chain: list[int]) -> bytes:
        chunks = []
        for cluster in chain:
            off = data_offset + (cluster - 2) * cluster_size
            end = off + cluster_size
            if off < data_offset or end > base + bpb["volume_bytes"]:
                raise ValueError(f"cluster {cluster} data lies outside volume")
            chunks.append(image[off:end])
        return b"".join(chunks)

    files = []
    directories = []
    errors = []
    seen_dirs = set()
    total_file_bytes = 0

    def walk_directory(raw: bytes, prefix: str, depth: int) -> None:
        nonlocal total_file_bytes
        if depth > MAX_DIRECTORY_DEPTH:
            errors.append(f"directory depth limit reached at {prefix or '/'}")
            return
        pending_lfn = {}
        for pos in range(0, len(raw) - 31, 32):
            entry = raw[pos:pos + 32]
            first = entry[0]
            if first == 0x00:
                break
            if first == 0xE5:
                pending_lfn.clear()
                continue
            attr = entry[11]
            if attr == 0x0F:
                seq = first & 0x1F
                if first & 0x40:
                    pending_lfn.clear()
                if seq:
                    pending_lfn[seq] = lfn_piece(entry)
                continue
            if attr & 0x08:
                pending_lfn.clear()
                continue
            name = "".join(pending_lfn[k] for k in sorted(pending_lfn)) if pending_lfn else short_name(entry)
            pending_lfn.clear()
            if not name or name in (".", ".."):
                continue
            full = f"{prefix}/{name}" if prefix else name
            is_dir = bool(attr & 0x10)
            start_cluster = u16(entry, 0x1A)
            file_size = u32(entry, 0x1C)
            if is_dir:
                directories.append(full)
                try:
                    if start_cluster in seen_dirs:
                        raise ValueError(f"directory cluster reused at {full}")
                    seen_dirs.add(start_cluster)
                    chain = cluster_chain(start_cluster)
                    if not chain:
                        raise ValueError(f"directory {full} has no cluster chain")
                    walk_directory(read_chain(chain), full, depth + 1)
                except ValueError as exc:
                    errors.append(f"{full}: {exc}")
            else:
                total_file_bytes += file_size
                chain_count = 0
                try:
                    chain = cluster_chain(start_cluster, file_size)
                    chain_count = len(chain)
                except ValueError as exc:
                    errors.append(f"{full}: {exc}")
                files.append({
                    "path": full,
                    "size": file_size,
                    "start_cluster": start_cluster,
                    "clusters": chain_count,
                    "attributes": f"0x{attr:02X}",
                })

    root = image[root_offset:root_offset + root_bytes]
    if len(root) != root_bytes:
        raise ValueError("truncated FAT16 fixed root directory")
    walk_directory(root, "", 0)
    sys_bin = any(path.lower() == "sys/bin" for path in directories)
    return {
        **bpb,
        "file_count": len(files),
        "directory_count": len(directories),
        "total_file_bytes": total_file_bytes,
        "sys_bin_present": sys_bin,
        "errors": errors,
        "files": files,
        "directories": directories,
    }


def inspect_image(path: Path) -> dict:
    if not path.is_file():
        return {"status": "MISSING", "path": str(path)}
    image = path.read_bytes()
    candidates = []
    for offset in candidate_offsets(image):
        bpb = parse_bpb(image, offset)
        if bpb:
            candidates.append(bpb)
    unique = {row["offset"]: row for row in candidates}
    if not unique:
        return {
            "status": "NO_FAT16_VOLUME_FOUND",
            "path": str(path),
            "size": len(image),
            "sha256": sha256(path),
            "scan_limit_bytes": min(len(image), MAX_SCAN_BYTES),
        }
    volumes = []
    for bpb in unique.values():
        try:
            volumes.append(inspect_volume(image, bpb))
        except ValueError as exc:
            volumes.append({**bpb, "status": "INVALID", "errors": [str(exc)]})
    valid = [v for v in volumes if "file_count" in v]
    return {
        "status": "FAT16_FOUND" if valid else "FAT16_BPB_FOUND_BUT_TREE_INVALID",
        "path": str(path),
        "size": len(image),
        "sha256": sha256(path),
        "volumes": volumes,
    }


def build_test_volume() -> bytes:
    bps = 512
    total_sectors = 5000
    reserved = 1
    fat_sectors = 20
    root_entries = 16
    root_sectors = 1
    first_data_sector = reserved + fat_sectors + root_sectors
    image = bytearray(total_sectors * bps)
    boot = memoryview(image)[:bps]
    boot[0:3] = b"\xEB\x3C\x90"
    boot[3:11] = b"MSDOS5.0"
    struct.pack_into("<H", boot, 0x0B, bps)
    boot[0x0D] = 1
    struct.pack_into("<H", boot, 0x0E, reserved)
    boot[0x10] = 1
    struct.pack_into("<H", boot, 0x11, root_entries)
    struct.pack_into("<H", boot, 0x13, total_sectors)
    boot[0x15] = 0xF8
    struct.pack_into("<H", boot, 0x16, fat_sectors)
    boot[510:512] = b"\x55\xAA"

    fat_offset = reserved * bps
    fat = memoryview(image)[fat_offset:fat_offset + fat_sectors * bps]
    for cluster in (0, 1, 2, 3, 4, 5):
        struct.pack_into("<H", fat, cluster * 2, 0xFFF8 if cluster == 0 else 0xFFFF)

    root_offset = (reserved + fat_sectors) * bps
    root = memoryview(image)[root_offset:root_offset + root_entries * 32]

    def short_entry(buf: memoryview, index: int, name: bytes, attr: int, cluster: int, size: int) -> None:
        pos = index * 32
        buf[pos:pos + 11] = name.ljust(11, b" ")
        buf[pos + 11] = attr
        struct.pack_into("<H", buf, pos + 26, cluster)
        struct.pack_into("<I", buf, pos + 28, size)

    short_entry(root, 0, b"HELLO   TXT", 0x20, 2, 3)
    short_entry(root, 1, b"SYS", 0x10, 3, 0)

    data_offset = first_data_sector * bps

    def cluster_view(cluster: int) -> memoryview:
        off = data_offset + (cluster - 2) * bps
        return memoryview(image)[off:off + bps]

    sys_dir = cluster_view(3)
    short_entry(sys_dir, 0, b".", 0x10, 3, 0)
    short_entry(sys_dir, 1, b"..", 0x10, 0, 0)
    short_entry(sys_dir, 2, b"BIN", 0x10, 4, 0)

    bin_dir = cluster_view(4)
    short_entry(bin_dir, 0, b".", 0x10, 4, 0)
    short_entry(bin_dir, 1, b"..", 0x10, 3, 0)
    short_entry(bin_dir, 2, b"EUSER   DLL", 0x20, 5, 3)
    cluster_view(2)[:3] = b"abc"
    cluster_view(5)[:3] = b"dll"
    return bytes(image)


def self_test() -> None:
    image = build_test_volume()
    bpb = parse_bpb(image, 0)
    assert bpb and bpb["fat_type"] == "FAT16", bpb
    result = inspect_volume(image, bpb)
    assert result["file_count"] == 2, result
    assert result["directory_count"] == 2, result
    assert result["sys_bin_present"], result
    paths = {row["path"] for row in result["files"]}
    assert paths == {"HELLO.TXT", "SYS/BIN/EUSER.DLL"}, paths

    mbr = bytearray(512 + len(image))
    mbr[510:512] = b"\x55\xAA"
    entry = 0x1BE
    mbr[entry + 4] = 0x06
    struct.pack_into("<I", mbr, entry + 8, 1)
    struct.pack_into("<I", mbr, entry + 12, len(image) // 512)
    mbr[512:] = image
    offsets = candidate_offsets(bytes(mbr))
    assert 512 in offsets, offsets
    bpb2 = parse_bpb(bytes(mbr), 512)
    assert bpb2 and inspect_volume(bytes(mbr), bpb2)["sys_bin_present"]

    # A valid BPB may live well beyond the old 2 MiB scan window.
    late_offset = 3 * 1024 * 1024
    late_image = b"\\0" * late_offset + image
    assert late_offset in candidate_offsets(late_image)
    late_bpb = parse_bpb(late_image, late_offset)
    assert late_bpb and inspect_volume(late_image, late_bpb)["sys_bin_present"]
    print("Step112 UDA FAT16 self-tests: PASS (3/3)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", type=Path, required=True)
    parser.add_argument("--out", type=Path, default=Path("firmware-input/STEP112_UDA_FAT16_AUDIT.md"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    if args.self_test:
        self_test()
    result = inspect_image(args.image)
    args.out.parent.mkdir(parents=True, exist_ok=True)

    lines = [
        "# Step112 — UDA user-area filesystem audit",
        "",
        f"- Input: {args.image}",
        f"- Status: **{result.get('status', 'UNKNOWN')}**",
        f"- Image size: {result.get('size', 0):,} bytes",
    ]
    if result.get("sha256"):
        lines.append(f"- SHA-256: {result['sha256']}")
    if result.get("status") == "FAT16_FOUND":
        for index, volume in enumerate(result["volumes"], 1):
            if "file_count" not in volume:
                continue
            lines += [
                "",
                f"## FAT16 volume {index}",
                "",
                f"- Byte offset: {volume['offset']:,}",
                f"- Volume bytes: {volume['volume_bytes']:,}",
                f"- Cluster count: {volume['cluster_count']:,}",
                f"- Files: **{volume['file_count']}**",
                f"- Directories: **{volume['directory_count']}**",
                f"- Total file bytes: {volume['total_file_bytes']:,}",
                f"- SYS/BIN present: **{volume['sys_bin_present']}**",
                f"- FAT-chain / directory errors: **{len(volume['errors'])}**",
            ]
            if volume["errors"]:
                lines += ["", "### Errors", ""] + [f"- {x}" for x in volume["errors"][:30]]
            lines += ["", "### First 60 files", ""]
            for row in volume["files"][:60]:
                lines.append(f"- {row['path']} — {row['size']} bytes, cluster {row['start_cluster']}")
    elif result.get("status") == "FAT16_BPB_FOUND_BUT_TREE_INVALID":
        lines += ["", "## Candidate volumes", ""]
        for volume in result.get("volumes", []):
            lines.append(f"- Offset {volume['offset']}: {volume.get('errors', [])}")
    else:
        lines += [
            "",
            f"No valid FAT16 BPB was found at offset zero, an MBR FAT16 partition start, or a 512-byte-aligned offset within the first {result['scan_limit_bytes']:,} bytes.",
            "This is not proof that the UDA container is corrupt; it may use a different volume layout or filesystem.",
        ]
    report = "\n".join(lines) + "\n"
    args.out.write_text(report, encoding="utf-8")
    print(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
