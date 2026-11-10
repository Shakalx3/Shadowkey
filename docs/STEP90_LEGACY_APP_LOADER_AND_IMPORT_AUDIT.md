# Step90 — legacy APP loader contract and complete import audit

Date: 2026-11-10

## 1. Original application image

The original 6R51.APP is an E32 DLL, not a standalone EXE:

| Field | Value |
|---|---:|
| UID1 | 0x10000079 (DLL) |
| UID2 | 0x100039CE (Symbian application DLL) |
| UID3 | 0x101FD3F6 |
| E32 flags | 0x01000003 |
| Entry point | 0x00000000 |
| Export count | 1 |
| DLL references | 20 |
| Import address table slots | 415 |

The single export is ordinal 1 at VA 0x1002841C (ARM state). Disassembly shows it allocating a 0x22C-byte object, calling its constructor, installing a vtable pointer at 0x100FD9BC, and returning the object pointer. This is consistent with the legacy application factory convention (NewApplication).

The launch architecture remains a small S60 3.1 / EKA2 host EXE that loads the patched 6R51.APP DLL, resolves ordinal 1, and passes the factory to the target EikStart application runner. This is a design direction, not a device-tested launcher.

## 2. E32 and IAT integrity

Both bundled private DLLs passed strict E32 boundary checks:

- SIMKIN.DLL: export directory and code segment end at the import-table boundary.
- GAMECOMMS.DLL: same checks passed.
- All 91 imports from 6R51.APP into those two DLLs point to an in-range, nonzero export.

The game image has 415 IAT slots. All IAT values match the ordinal arrays in the E32 import table. The normal ARM thunk recognizer found 414 slots; the remaining slot is a second MEDIACLIENTAUDIOSTREAM[10003996].DLL ordinal-1 entry at 0x101008A8. Its code stub uses a nonstandard two-instruction tail (ldr ip,[ip]; bx ip) rather than the common three-instruction import stub. It is included in the map as well: the exact API signature maps it to N95 mediaclientaudiostream.dll ordinal 3. Its caller/stub pattern remains under investigation.

## 3. Current import-map totals

The mapping run uses 24 N95 ROM target modules and 15,325 symbolized ROM/SDK export-map rows.

| Image | Imports/IAT slots | No target signature | Other unresolved/candidate statuses |
|---|---:|---:|---|
| 6R51.APP | 415 | 34 | 6 destructor candidates; 1 RFs subsession wrapper; 1 AVKON base-class alias; 6 PASS; 23 same-address aliases; 1 typedef match; 91 bundled-private imports |
| SIMKIN.DLL | 79 | 28 | 1 destructor candidate; 1 const-member ABI match; 1 provisional forwarder; 1 RFs subsession wrapper; 6 same-address aliases; 41 exact matches |
| GAMECOMMS.DLL | 205 | 16 | 3 destructor candidates; 3 const-member ABI matches; 5 cross-DLL matches/aliases; 26 same-address aliases; 2 PASS; 150 exact matches |

Candidate statuses are not all approved for binary patching. Destructor candidates and provisional forwarders still require ABI review.

### Confirmed Bluetooth-related mappings

- Five BTMANCLIENT imports resolve by exact signature to exports in N95 bluetooth.dll.
- Three TBTDeviceClass methods resolve to the same-class N95 exports; the target methods add a C++ const qualifier, which does not alter the ARM member-function calling convention.
- CAknAppUi::KeySounds maps to the N95 CAknAppUiBase::KeySounds() const base-class export.
- RFsBase::Close is not mapped directly to RHandleBase::Close. The old class derives from RSubSessionBase; the N95 target API RSubSessionBase::CloseSubSession(TInt) (EUSER ordinal 387) needs a wrapper that supplies the file-server close function code.

### BTENG caution

The N-Gage SDK bteng.lib contains 57 ordinal imports (1–57); the N95 ROM bteng.dll has 87 exports and the same UID3 (0x10005952) as the GAMECOMMS dependency. Six imported ordinals are 11, 22, 24, 31, 47, and 48.

UID3 equality is not sufficient proof of ordinal stability: BTMANCLIENT has the same UID3 on both platforms, yet old ordinal 61 is TBTServiceSecurity construction while N95 ordinal 61 is TBTCommPortSettings::SetNoSecurity. Therefore the six BTENG same-ordinal results remain candidates until their target functions are independently verified.

## 4. EKA2 host prototype attempt

The workflow now compiles a minimal host EXE that loads 6R51.APP, resolves ordinal 1, wraps the factory in TApaApplicationFactory, and calls EikStart::RunApplication. The first automated attempt (run 42797908530) failed inside the GCCE host-build script before producing a verified 6R51Host.exe. The step is non-blocking so a launcher-prototype failure cannot suppress the ROM export and import audits. A diagnostic trap has been added to print the build-log tail on the next attempt; the precise compiler/linker cause remains to be captured.

## 5. Next work

1. Capture and resolve the Step90 GCCE/elf2e32 build failure; do not count the host EXE as built until the E32 header and output-file checks pass.
2. Validate the seven core ROM export maps independently, especially EUSER, CONE and GDI.
3. Resolve remaining EUSER/compiler-runtime imports, distinguishing functions that can be implemented in a compatibility DLL from APIs needing semantic wrappers.
4. Verify remaining BTMANCLIENT and BTENG imports from target code and headers; do not reuse old ordinals solely because UID3 matches.
5. Build an E32 import-table patcher that preserves every IAT slot, including duplicate dependency blocks.
6. Validate on an actual RM-320 when the device is available.

No real-device launch or runtime compatibility test has been performed yet.
