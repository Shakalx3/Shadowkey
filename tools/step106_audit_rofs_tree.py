#!/usr/bin/env python3
"""Read-only audit of Nokia ROFS/ROFx directory trees using Symbian rofs.h layout.

This inventories metadata first; it does not modify source images.
It mirrors the official TExtensionRofsHeader adjustment and TDirectoryEntry walk.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import struct
from pathlib import Path


def u16(b: bytes, o: int) -> int:
    return struct.unpack_from("<H", b, o)[0]


def u32le(b: bytes, o: int) -> int:
    return struct.unpack_from("<I", b, o)[0]


def u32be(b: bytes, o: int) -> int:
    return struct.unpack_from(">I", b, o)[0]


class Audit:
    def __init__(self, data: bytes, label: str):
        self.data = data
        self.label = label
        self.errors: list[str] = []
        self.warnings: list[str] = []
        self.directories: list[dict] = []
        self.files: list[dict] = []
        self.visited: set[int] = set()
        self.max_depth = 64
        self.wrapper_offset = 0
        self.payload = b""
        self.magic = ""
        self.header: dict = {}
        self.adjustment = 0
        self.root_offset = 0
        self.local_files = 0
        self.external_files = 0
        self.invalid_file_ranges = 0
        self.dir_tree_start = 0
        self.dir_tree_end = 0
        self.file_entries_start = 0
        self.file_entries_end = 0
        self.entry_boundary_crossings: list[dict] = []

    def adjusted(self, address: int, what: str) -> int:
        if address < self.adjustment:
            raise ValueError(
                f"{what}: address 0x{address:X} is below extension adjustment 0x{self.adjustment:X}"
            )
        return address - self.adjustment

    def parse_entry(self, pos: int, limit: int, context: str) -> tuple[dict, int]:
        if pos + 2 > limit:
            raise ValueError(f"{context}: truncated entry-size at 0x{pos:X}")
        struct_size = u16(self.payload, pos)
        if struct_size < 32:
            raise ValueError(
                f"{context}: entry structSize={struct_size} below fixed TRofsEntry size 32 at 0x{pos:X}"
            )
        end = pos + struct_size
        if end > limit:
            raise ValueError(
                f"{context}: entry at 0x{pos:X} size 0x{struct_size:X} exceeds block end 0x{limit:X}"
            )
        name_length = self.payload[pos + 29]
        if name_length == 0:
            raise ValueError(f"{context}: zero-length name at 0x{pos:X}")
        name_end = pos + 30 + name_length * 2
        if name_end > end:
            raise ValueError(
                f"{context}: name length {name_length} exceeds entry size {struct_size} at 0x{pos:X}"
            )
        try:
            name = self.payload[pos + 30:name_end].decode("utf-16le")
        except UnicodeDecodeError as exc:
            raise ValueError(f"{context}: invalid UTF-16 name at 0x{pos:X}: {exc}") from exc
        if not name or "\x00" in name or "/" in name or "\\" in name:
            raise ValueError(f"{context}: unsafe/empty path component {name!r} at 0x{pos:X}")
        entry = {
            "entry_offset": pos,
            "struct_size": struct_size,
            "uid_bytes": self.payload[pos + 2:pos + 18].hex(),
            "name_offset": self.payload[pos + 18],
            "attributes": self.payload[pos + 19],
            "file_size": u32le(self.payload, pos + 20),
            "file_address": u32le(self.payload, pos + 24),
            "attributes_extra": self.payload[pos + 28],
            "name_length": name_length,
            "name": name,
        }
        return entry, end

    def parse_file_block(self, address: int, size: int, path: str, dir_tree_offset: int):
        if not address and not size:
            return
        if not address or not size:
            self.errors.append(f"{path}: inconsistent file block address/size 0x{address:X}/{size}")
            return
        try:
            start = self.adjusted(address, f"{path} file block")
        except ValueError as exc:
            self.errors.append(str(exc))
            return
        end = start + size
        if start < self.file_entries_start or end > self.file_entries_end:
            self.errors.append(
                f"{path}: file block [0x{start:X},0x{end:X}) is outside enclosing file-entry table "
                f"[0x{self.file_entries_start:X},0x{self.file_entries_end:X})"
            )
            return
        pos = start
        count = 0
        while pos < end:
            remaining = end - pos
            if remaining <= 3:
                tail = self.payload[pos:end]
                if not any(tail):
                    self.warnings.append(
                        f"{path}: {len(tail)} zero trailing byte(s) in file-entry block at 0x{pos:X}"
                    )
                    break
            try:
                entry, next_pos = self.parse_entry(pos, self.file_entries_end, f"{path} file entry")
            except ValueError as exc:
                self.errors.append(str(exc))
                break
            entry_path = f"{path}/{entry['name']}" if path else entry["name"]
            address_value = entry["file_address"]
            record = {
                "path": entry_path,
                "size": entry["file_size"],
                "address": address_value,
                "entry_offset": entry["entry_offset"],
                "attributes": entry["attributes"],
                "attributes_extra": entry["attributes_extra"],
                "uid_bytes": entry["uid_bytes"],
            }
            if address_value == 0:
                record["storage"] = "no-data-reference"
                record["payload_offset"] = None
            elif self.magic == "ROFx" and address_value <= dir_tree_offset:
                record["storage"] = "external-reference"
                record["payload_offset"] = None
                self.external_files += 1
            else:
                try:
                    payload_offset = self.adjusted(address_value, f"{entry_path} data")
                    record["payload_offset"] = payload_offset
                    record["storage"] = "local"
                    if payload_offset + entry["file_size"] > len(self.payload):
                        record["storage"] = "invalid-range"
                        self.invalid_file_ranges += 1
                        self.errors.append(
                            f"{entry_path}: data [0x{payload_offset:X},"
                            f"0x{payload_offset + entry['file_size']:X}) exceeds payload "
                            f"0x{len(self.payload):X}"
                        )
                    else:
                        self.local_files += 1
                except ValueError as exc:
                    record["storage"] = "invalid-address"
                    record["payload_offset"] = None
                    self.invalid_file_ranges += 1
                    self.errors.append(str(exc))
            self.files.append(record)
            count += 1
            if next_pos > end:
                self.entry_boundary_crossings.append({
                    "kind": "file-block", "path": path or "/", "entry_offset": pos,
                    "record_end": next_pos, "cursor_end": end, "overrun": next_pos - end,
                })
                self.warnings.append(
                    f"{path or '/'}: final file entry at 0x{pos:X} crosses per-directory "
                    f"file-block end by {next_pos - end} byte(s); complete record remains "
                    "inside the enclosing file-entry table"
                )
            pos = next_pos
        if pos < end and count == 0:
            self.warnings.append(f"{path}: no file entries parsed from non-empty block")

    def parse_directory(self, address: int, path: str = "", depth: int = 0):
        if depth > self.max_depth:
            self.errors.append(f"{path}: directory recursion exceeds {self.max_depth}")
            return
        try:
            pos = self.adjusted(address, f"{path or '/'} directory")
        except ValueError as exc:
            self.errors.append(str(exc))
            return
        if pos in self.visited:
            self.warnings.append(f"{path or '/'}: repeated directory offset 0x{pos:X}")
            return
        self.visited.add(pos)
        if pos < 0 or pos + 12 > len(self.payload):
            self.errors.append(f"{path or '/'}: directory header outside payload at 0x{pos:X}")
            return
        dir_size = u16(self.payload, pos)
        first_entry_offset = self.payload[pos + 3]
        file_block_address = u32le(self.payload, pos + 4)
        file_block_size = u32le(self.payload, pos + 8)
        if dir_size < 12:
            self.errors.append(f"{path or '/'}: directory structSize {dir_size} < 12 at 0x{pos:X}")
            return
        dir_end = pos + dir_size
        if pos < self.dir_tree_start or dir_end > self.dir_tree_end:
            self.errors.append(
                f"{path or '/'}: directory range [0x{pos:X},0x{dir_end:X}) is outside "
                f"enclosing directory tree [0x{self.dir_tree_start:X},0x{self.dir_tree_end:X})"
            )
            return
        if first_entry_offset != 12:
            self.warnings.append(
                f"{path or '/'}: firstEntryOffset={first_entry_offset}, official header size is 12"
            )
        self.directories.append({
            "path": path or "/",
            "offset": pos,
            "struct_size": dir_size,
            "first_entry_offset": first_entry_offset,
            "file_block_address": file_block_address,
            "file_block_size": file_block_size,
        })
        self.parse_file_block(file_block_address, file_block_size, path, self.header["dir_tree_offset"])

        # The published Symbian reader starts subdirectory entries immediately
        # after the 12-byte fixed TRofsDir header; it logs but does not use
        # iFirstEntryOffset as an alternate cursor.
        child_pos = pos + 12
        while child_pos < dir_end:
            remaining = dir_end - child_pos
            if remaining <= 3:
                tail = self.payload[child_pos:dir_end]
                if not any(tail):
                    self.warnings.append(
                        f"{path or '/'}: {len(tail)} zero trailing byte(s) in subdirectory list"
                    )
                    break
            try:
                entry, next_pos = self.parse_entry(
                    child_pos, self.dir_tree_end, f"{path or '/'} subdirectory entry"
                )
            except ValueError as exc:
                self.errors.append(str(exc))
                break
            if next_pos > dir_end:
                self.entry_boundary_crossings.append({
                    "kind": "subdirectory-list", "path": path or "/", "entry_offset": child_pos,
                    "record_end": next_pos, "cursor_end": dir_end, "overrun": next_pos - dir_end,
                })
                self.warnings.append(
                    f"{path or '/'}: final subdirectory entry at 0x{child_pos:X} crosses "
                    f"directory cursor end by {next_pos - dir_end} byte(s); complete record "
                    "remains inside the enclosing directory tree"
                )
            child_path = f"{path}/{entry['name']}" if path else entry["name"]
            self.parse_directory(entry["file_address"], child_path, depth + 1)
            # Official TDirectoryEntry::AddSubDirs rounds each entry to 32-bit alignment.
            child_pos = next_pos + ((4 - entry["struct_size"]) & 3)
            if child_pos > self.dir_tree_end:
                self.errors.append(
                    f"{path or '/'}: aligned subdirectory cursor 0x{child_pos:X} exceeds "
                    f"directory-tree end 0x{self.dir_tree_end:X}"
                )
                break

    def run(self) -> dict:
        if len(self.data) >= 1028 and self.data[1024:1028] in (b"ROFS", b"ROFx"):
            self.wrapper_offset = 1024
        elif self.data[:4] in (b"ROFS", b"ROFx"):
            self.wrapper_offset = 0
        else:
            self.errors.append("ROFS/ROFx magic not found at offset 0 or 0x400")
            return self.result()
        self.payload = self.data[self.wrapper_offset:]
        self.magic = self.payload[:4].decode("ascii")
        if len(self.payload) < 48:
            self.errors.append("truncated 48-byte ROFS header")
            return self.result()
        header_size = self.payload[4]
        version = u16(self.payload, 6)
        self.header = {
            "magic": self.magic,
            "header_size": header_size,
            "format_version": version,
            "dir_tree_offset": u32le(self.payload, 8),
            "dir_tree_size": u32le(self.payload, 12),
            "file_entries_offset": u32le(self.payload, 16),
            "file_entries_size": u32le(self.payload, 20),
            "image_size": u32be(self.payload, 36),
            "checksum": u32be(self.payload, 40),
            "max_image_size": u32be(self.payload, 44),
            "payload_size": len(self.payload),
            "wrapper_offset": self.wrapper_offset,
        }
        if header_size != 48:
            self.errors.append(f"unexpected header size {header_size}; expected 48")
        if version != 0x0200:
            self.errors.append(f"unsupported ROFS format version 0x{version:04X}")
        if self.header["dir_tree_offset"] < header_size:
            self.errors.append("directory tree offset precedes the end of the header")
        if self.header["dir_tree_size"] == 0:
            self.errors.append("empty directory tree")
        if self.header["file_entries_size"] == 0:
            self.warnings.append("header file-entry block size is zero")
        self.adjustment = (
            self.header["dir_tree_offset"] - header_size if self.magic == "ROFx" else 0
        )
        self.root_offset = self.header["dir_tree_offset"] - self.adjustment
        self.file_entries_start = self.header["file_entries_offset"] - self.adjustment
        self.dir_tree_start = self.root_offset
        self.dir_tree_end = self.dir_tree_start + self.header["dir_tree_size"]
        self.file_entries_end = self.file_entries_start + self.header["file_entries_size"]
        if self.dir_tree_start < 0 or self.dir_tree_end > len(self.payload):
            self.errors.append("header directory-tree range exceeds payload")
        if self.file_entries_start < 0 or self.file_entries_end > len(self.payload):
            self.errors.append("header file-entry range exceeds payload")
        if self.dir_tree_end != self.file_entries_start:
            self.warnings.append(
                "adjusted directory-tree end does not equal adjusted file-entry start: "
                f"0x{self.dir_tree_end:X} vs 0x{self.file_entries_start:X}"
            )
        if self.errors:
            return self.result()
        self.parse_directory(self.header["dir_tree_offset"])
        return self.result()

    def result(self) -> dict:
        return {
            "label": self.label,
            "magic": self.magic or None,
            "source_size": len(self.data),
            "source_sha256": hashlib.sha256(self.data).hexdigest(),
            "wrapper_offset": self.wrapper_offset,
            "header": self.header,
            "extension_adjustment": self.adjustment,
            "root_payload_offset": self.root_offset,
            "directories": len(self.directories),
            "file_entries": len(self.files),
            "local_files": self.local_files,
            "external_references": self.external_files,
            "invalid_file_ranges": self.invalid_file_ranges,
            "entry_boundary_crossings": len(self.entry_boundary_crossings),
            "errors": self.errors,
            "warnings": self.warnings,
            "status": "PASS" if not self.errors else "PARTIAL",
            "directory_rows": self.directories,
            "file_rows": self.files,
        }


def synthetic_image(magic: bytes, short_file_block_by: int = 0) -> bytes:
    # One directory with one one-character file. ROFx virtual addresses are
    # shifted by 0x1000; the official extension adjustment reverses that shift.
    adjustment = 0x1000 if magic == b"ROFx" else 0
    tree_offset = 48 + adjustment
    file_block_offset = 60 + adjustment
    file_data_offset = 92 + adjustment
    entry = bytearray(32)
    struct.pack_into("<H", entry, 0, 32)
    struct.pack_into("<I", entry, 20, 4)
    struct.pack_into("<I", entry, 24, file_data_offset)
    entry[29] = 1
    entry[30:32] = "A".encode("utf-16le")
    directory = bytearray(12)
    struct.pack_into("<H", directory, 0, 12)
    directory[3] = 12
    struct.pack_into("<I", directory, 4, file_block_offset)
    struct.pack_into("<I", directory, 8, len(entry) - short_file_block_by)
    payload = bytearray(96)
    payload[:4] = magic
    payload[4] = 48
    struct.pack_into("<H", payload, 6, 0x0200)
    struct.pack_into("<IIII", payload, 8, tree_offset, 12, file_block_offset, len(entry))
    struct.pack_into(">III", payload, 36, len(payload), 0, len(payload))
    payload[48:60] = directory
    payload[60:92] = entry
    payload[92:96] = b"DATA"
    return bytes(payload)


def synthetic_subdirectory_crossing_image(magic: bytes) -> bytes:
    adjustment = 0x1000 if magic == b"ROFx" else 0
    tree_offset = 48 + adjustment
    child_dir_address = 92 + adjustment
    file_entries_offset = 104 + adjustment
    payload = bytearray(104)
    payload[:4] = magic
    payload[4] = 48
    struct.pack_into("<H", payload, 6, 0x0200)
    struct.pack_into("<IIII", payload, 8, tree_offset, 56, file_entries_offset, 0)
    struct.pack_into(">III", payload, 36, len(payload), 0, len(payload))
    root = bytearray(12)
    struct.pack_into("<H", root, 0, 42)
    root[3] = 12
    payload[48:60] = root
    child = bytearray(32)
    struct.pack_into("<H", child, 0, 32)
    struct.pack_into("<I", child, 24, child_dir_address)
    child[29] = 1
    child[30:32] = "D".encode("utf-16le")
    payload[60:92] = child
    child_dir = bytearray(12)
    struct.pack_into("<H", child_dir, 0, 12)
    child_dir[3] = 12
    payload[92:104] = child_dir
    return bytes(payload)


def self_test():
    for magic in (b"ROFS", b"ROFx"):
        result = Audit(synthetic_image(magic), magic.decode()).run()
        assert result["status"] == "PASS", result
        assert result["directories"] == 1, result
        assert result["file_entries"] == 1, result
        assert result["local_files"] == 1, result
        assert result["file_rows"][0]["payload_offset"] == 92, result

        short = Audit(synthetic_image(magic, short_file_block_by=2), "short-file-block").run()
        assert short["status"] == "PASS", short
        assert short["file_entries"] == 1, short
        assert short["entry_boundary_crossings"] == 1, short

        subdir = Audit(synthetic_subdirectory_crossing_image(magic), "subdir-crossing").run()
        assert subdir["status"] == "PASS", subdir
        assert subdir["directories"] == 2, subdir
        assert subdir["entry_boundary_crossings"] == 1, subdir

    print("Step107 synthetic ROFS/ROFx cursor-boundary tests: PASS (6/6)")


def write_reports(results: list[dict], out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    stem = "STEP106_ROFS_DIRECTORY_AUDIT"
    summary = {
        "results": [{k: v for k, v in r.items() if k not in ("directory_rows", "file_rows")} for r in results]
    }
    (out_dir / f"{stem}.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    tsv = ["image\tpath\tkind\tsize\taddress\tpayload_offset\tstorage\tattributes"]
    for r in results:
        for d in r["directory_rows"]:
            tsv.append(
                f"{r['label']}\t{d['path']}\tDIR\t{d['struct_size']}\t"
                f"{d['offset']:08X}\t\t\t"
            )
        for f in r["file_rows"]:
            off = "" if f["payload_offset"] is None else f"{f['payload_offset']:08X}"
            tsv.append(
                f"{r['label']}\t{f['path']}\tFILE\t{f['size']}\t{f['address']:08X}\t"
                f"{off}\t{f['storage']}\t{f['attributes']:02X}"
            )
    (out_dir / f"{stem}.tsv").write_text("\n".join(tsv) + "\n", encoding="utf-8")
    lines = ["# Step106 — Symbian-layout ROFS/ROFx directory audit", ""]
    for r in results:
        h = r["header"]
        lines += [
            f"## {r['label']} — {r['status']}",
            "",
            f"- Magic/version/header: {r['magic']} / 0x{h.get('format_version', 0):04X} / {h.get('header_size')}",
            f"- Source size/SHA-256: {r['source_size']} / {r['source_sha256']}",
            f"- Wrapper offset: 0x{r['wrapper_offset']:X}; extension adjustment: 0x{r['extension_adjustment']:X}",
            f"- Directory tree: virtual 0x{h.get('dir_tree_offset', 0):X} + {h.get('dir_tree_size', 0)} bytes; payload root 0x{r['root_payload_offset']:X}",
            f"- File-entry block: virtual 0x{h.get('file_entries_offset', 0):X} + {h.get('file_entries_size', 0)} bytes",
            f"- Parsed directories/files: {r['directories']} / {r['file_entries']}",
            f"- Local files / external references / invalid local ranges: {r['local_files']} / {r['external_references']} / {r['invalid_file_ranges']}",
            f"- Final entries crossing per-directory cursor ends: {r['entry_boundary_crossings']}",
        ]
        if r["errors"]:
            lines += ["", "Errors:"] + [f"- {x}" for x in r["errors"]]
        if r["warnings"]:
            lines += ["", "Warnings:"] + [f"- {x}" for x in r["warnings"]]
        lines.append("")
    lines += [
        "## Method and limits",
        "",
        "- Uses the published Symbian TRofsDir, TRofsEntry, and TExtensionRofsHeader field layout.",
        "- For ROFx, uses the official adjustment iDirTreeOffset minus the file position immediately after the 48-byte header.",
        "- Mirrors the official cursor rule: test the entry start against the per-directory end, then read the full record against the enclosing global metadata-table boundary.",
        "- A final record may cross a per-directory cursor end; it is accepted only when the complete record remains inside the enclosing global table and the crossing is reported.",
        "- A ROFx file address at or below iDirTreeOffset is classified as an external/base-image reference, matching the official reader.",
        "- Header tree/file-entry sizes describe global regions; the root directory's own structSize and file block are not expected to equal those global sizes.",
        "- This audit does not modify firmware and does not claim every referenced base-image file is present in the extension.",
        "- PASS means the metadata walk and local ranges passed these structural checks; it is not a device compatibility result.",
        "",
    ]
    (out_dir / f"{stem}.md").write_text("\n".join(lines), encoding="utf-8")
    print("\n".join(lines))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--image", action="append", default=[], metavar="LABEL=PATH")
    ap.add_argument("--out-dir", type=Path, default=Path("."))
    ap.add_argument("--self-test", action="store_true")
    args = ap.parse_args()
    if args.self_test:
        self_test()
    results = []
    for spec in args.image:
        if "=" not in spec:
            ap.error("--image must be LABEL=PATH")
        label, path = spec.split("=", 1)
        result = Audit(Path(path).read_bytes(), label).run()
        results.append(result)
    if results:
        write_reports(results, args.out_dir)
    elif not args.self_test:
        ap.error("provide --self-test and/or --image LABEL=PATH")
    # Structural anomalies are recorded for inspection but do not suppress later CI stages.
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
