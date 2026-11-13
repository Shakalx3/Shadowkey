# Step117 — Symbian-native E32 decompression path

Date: 2026-11-13

## Verified prior state

- Step96 target GCCE ABI compile-time checks pass: TInt64 is 8 bytes; TTrap is 76 bytes with offsets 0/64/68/72.
- Step100 confirms target TInt64 is a signed built-in integer. This explains why the legacy N-Gage TInt64::operator!= member has no same-signature EUSER export on the N95; EUSER ordinal 1575 must not be redirected to the unrelated target API.
- Step99 builds a structurally valid, 244-byte test E32 DLL. Step102 builds a 667-byte EKA2 loader-probe EXE and publishes a reversible test package. Neither has been run on a Symbian loader or physical N95.
- The historical firmware run 42604419519 failed at link time because the CI linker could not find libunix++; later workflow revisions corrected the library path. It was not a firmware-image parsing failure.

## Firmware filesystem findings

The successful firmware workflow run 43410099945 (2026-11-13) reports:

- C0R/CORE: FPSX extraction produced PAPUBKEYS and a sparse rofs.img; the carved SOS+ROFS partition was parsed into 1,441 files by the bounded ROFS path.
- PPM: FPSX extraction produced a sparse rofs.img; its carved partition has the ROFx marker. The generic upstream ROFS unpacker rejects that marker, but the project-specific ROFx/base merge resolves all 1,441 external references against the C0R base by exact address, path, size and UID bytes. The merged tree contains 5,909 files / 40,035,661 bytes.
- UDA: the FPSX parser creates a 41,206,272-byte sparse userarea.img with one 115,200-byte H2E data block at offset 41,091,072. Step112 finds no FAT16 BPB at offset zero, an MBR partition start, or a 512-byte-aligned offset. Step115's raw bytes confirm the H2E length/offset fields are big-endian values 115200 and 41091072; the payload begins with structured binary data, not a FAT boot sector. No usable UDA filesystem tree has been extracted.
- The RM320_31.0.002_025_xxx_U01_uda.fpsx name alongside RM-320 v35.0.001 C0R/PPM is consistent with archived firmware-package listings; the version difference alone is not evidence of a mismatched package. See the historical RM-320 firmware file listing: https://forum.gsmhosting.com/vbb/12668116-post19.html.

## Why Step109 reports zero decoded modules

Step109 found 135 EPOC-signature E32 candidates: 134 use compression UID 0x101F7AFC and one uses 0x102822AA. Its zlib-based Deflate attempt failed for all 134; its flat BytePair attempt failed for the remaining candidate. This is an algorithm/layout mismatch, not evidence that the modules are corrupt.

The pinned upstream fedor4ever/elf2e32 source contains the relevant Symbian implementations:

- E32Parser::DecompressImage dispatches 0x101F7AFC to InflateUnCompress, a Symbian-specific Huffman bitstream decoder in source/inflate.cpp, not RFC zlib.
- BytePair images are paged: source/e32parser.cpp calls DecompressPages separately for code and data; source/pagedcompress.cpp parses a 10-byte index header, a uint16 compressed-size table, then independently calls Unpak for each 4 KiB page.
- The tool supports repacking an existing E32 image with --e32input and --compressionmethod=none.

Sources:
- https://github.com/fedor4ever/elf2e32
- https://github.com/fedor4ever/elf2e32/blob/ecfc39742dce03f3a5f4d83db18e8c1f395f3c47/source/e32parser.cpp
- https://github.com/fedor4ever/elf2e32/blob/ecfc39742dce03f3a5f4d83db18e8c1f395f3c47/source/inflate.cpp
- https://github.com/fedor4ever/elf2e32/blob/ecfc39742dce03f3a5f4d83db18e8c1f395f3c47/source/pagedcompress.cpp

## Step117 probe

tools/step117_native_e32_decompress.py invokes the same upstream elf2e32 binary built in Step99. It selects one candidate for each compression UID, writes only to the temporary workflow workspace, and verifies:

- the source SHA-256 still matches Step109's inventory;
- the source E32 header compression UID matches the inventory row;
- the output retains the same UIDs and iCodeOffset;
- the output compression UID is zero;
- the output size and code/data bounds are consistent with the uncompressed header.

The workflow then runs the existing Step109 structural parser on the decompressed sample tree. If both samples pass, the next checkpoint can safely expand this to all 135 candidates and produce the complete N95 ROM module/export/import inventory.

## Draft-code caveat

tools/step116_e32_native_codec.cpp is not part of the verified build path. It references common.hpp and codec symbols that do not exist in the pinned upstream source (DeCompressInflate, DecompressBPE, CompressBPE, CompressDeflate). It also does not implement the upstream paged BytePair index-table traversal. Step117 deliberately uses the upstream elf2e32 command-line path rather than treating that draft as a working decoder.

## Safety boundary

- No ROM DLL, firmware image or source game binary is modified or committed.
- E32 structural validation is not a loader test and not a real-device compatibility result.
- The Step102 ZIP contains only ShadowkeyCompat.dll, ShadowkeyAbiProbe.exe, README and SHA256SUMS. Its rollback is to delete those two files from the writable drive's sys/bin; it does not overwrite ROM files or flash firmware.
