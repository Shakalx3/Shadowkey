# Step 52 — WINS UDEB EIKCORE DLL probe

This is a semantic/reference probe of the SDK's WINS UDEB EIKCORE DLL.
It is not ARM UREL code and cannot supply ARM vtable addresses or prove
the exact ARM constructor implementation.

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/udeb/eikcore.dll
- Size: 110648 bytes
- SHA-256: 70b7fdd5c2aa4e4262ee18a589146d7471db0d219e8938fdcc5daa815553f665

## File identification

~~~text
/tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/udeb/eikcore.dll: PE32 executable for MS Windows 4.00 (DLL), Intel i386, 7 sections
~~~

## PE headers and exports

- Exit code: 0
~~~text

File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/udeb/eikcore.dll
Format: COFF-i386
Arch: i386
AddressSize: 32bit
ImageFileHeader {
  Machine: IMAGE_FILE_MACHINE_I386 (0x14C)
  SectionCount: 7
  TimeDateStamp: 2003-04-14 14:07:09 (0x3E9AC08D)
  PointerToSymbolTable: 0x0
  SymbolCount: 0
  StringTableSize: 0
  OptionalHeaderSize: 224
  Characteristics [ (0x210E)
    IMAGE_FILE_32BIT_MACHINE (0x100)
    IMAGE_FILE_DLL (0x2000)
    IMAGE_FILE_EXECUTABLE_IMAGE (0x2)
    IMAGE_FILE_LINE_NUMS_STRIPPED (0x4)
    IMAGE_FILE_LOCAL_SYMS_STRIPPED (0x8)
  ]
}
ImageOptionalHeader {
  Magic: 0x10B
  MajorLinkerVersion: 6
  MinorLinkerVersion: 0
  SizeOfCode: 77824
  SizeOfInitializedData: 32768
  SizeOfUninitializedData: 0
  AddressOfEntryPoint: 0x126AE
  BaseOfCode: 0x1000
  BaseOfData: 0x14000
  ImageBase: 0x75300000
  SectionAlignment: 4096
  FileAlignment: 4096
  MajorOperatingSystemVersion: 4
  MinorOperatingSystemVersion: 0
  MajorImageVersion: 0
  MinorImageVersion: 0
  MajorSubsystemVersion: 4
  MinorSubsystemVersion: 0
  SizeOfImage: 114688
  SizeOfHeaders: 4096
  CheckSum: 0x0
  Subsystem: IMAGE_SUBSYSTEM_WINDOWS_GUI (0x2)
  Characteristics [ (0x0)
  ]
  SizeOfStackReserve: 1048576
  SizeOfStackCommit: 4096
  SizeOfHeapReserve: 1048576
  SizeOfHeapCommit: 4096
  NumberOfRvaAndSize: 16
  DataDirectory {
    ExportTableRVA: 0x14F10
    ExportTableSize: 0x6AE
    ImportTableRVA: 0x17000
    ImportTableSize: 0x190
    ResourceTableRVA: 0x0
    ResourceTableSize: 0x0
    ExceptionTableRVA: 0x0
    ExceptionTableSize: 0x0
    CertificateTableRVA: 0x0
    CertificateTableSize: 0x0
    BaseRelocationTableRVA: 0x1B000
    BaseRelocationTableSize: 0x760
    DebugRVA: 0x14000
    DebugSize: 0x1C
    ArchitectureRVA: 0x0
    ArchitectureSize: 0x0
    GlobalPtrRVA: 0x0
    GlobalPtrSize: 0x0
    TLSTableRVA: 0x0
    TLSTableSize: 0x0
    LoadConfigTableRVA: 0x0
    LoadConfigTableSize: 0x0
    BoundImportRVA: 0x0
    BoundImportSize: 0x0
    IATRVA: 0x17CDC
    IATSize: 0xB4C
    DelayImportDescriptorRVA: 0x0
    DelayImportDescriptorSize: 0x0
    CLRRuntimeHeaderRVA: 0x0
    CLRRuntimeHeaderSize: 0x0
    ReservedRVA: 0x0
    ReservedSize: 0x0
  }
}
DOSHeader {
  Magic: MZ
  UsedBytesInTheLastPage: 144
  FileSizeInPages: 3
  NumberOfRelocationItems: 0
  HeaderSizeInParagraphs: 4
  MinimumExtraParagraphs: 0
  MaximumExtraParagraphs: 65535
  InitialRelativeSS: 0
  InitialSP: 184
  Checksum: 0
  InitialIP: 0
  InitialRelativeCS: 0
  AddressOfRelocationTable: 64
  OverlayNumber: 0
  OEMid: 0
  OEMinfo: 0
  AddressOfNewExeHeader: 200
}
Export {
  Ordinal: 1
  Name: 
  RVA: 0x14E2
}
Export {
  Ordinal: 2
  Name: 
  RVA: 0x12DA
}
Export {
  Ordinal: 3
  Name: 
  RVA: 0x1BA4
}
Export {
  Ordinal: 4
  Name: 
  RVA: 0x1C8A
}
Export {
  Ordinal: 5
  Name: 
  RVA: 0x1F0A
}
Export {
  Ordinal: 6
  Name: 
  RVA: 0x197E
}
Export {
  Ordinal: 7
  Name: 
  RVA: 0x1DE3
}
Export {
  Ordinal: 8
  Name: 
  RVA: 0x10EB
}
Export {
  Ordinal: 9
  Name: 
  RVA: 0x1CCB
}
Export {
  Ordinal: 10
  Name: 
  RVA: 0x186B
}
Export {
  Ordinal: 11
  Name: 
  RVA: 0x138E
}
Export {
  Ordinal: 12
  Name: 
  RVA: 0x1613
}
Export {
  Ordinal: 13
  Name: 
  RVA: 0x107D
}
Export {
  Ordinal: 14
  Name: 
  RVA: 0x1DFC
}
Export {
  Ordinal: 15
  Name: 
  RVA: 0x14A6
}
Export {
  Ordinal: 16
  Name: 
  RVA: 0x1AD2
}
Export {
  Ordinal: 17
  Name: 
  RVA: 0x1415
}
Export {
  Ordinal: 18
  Name: 
  RVA: 0x1AFF
}
Export {
  Ordinal: 19
  Name: 
  RVA: 0x1348
}
Export {
  Ordinal: 20
  Name: 
  RVA: 0x1488
}
Export {
  Ordinal: 21
  Name: 
  RVA: 0x1DF2
}
Export {
  Ordinal: 22
  Name: 
  RVA: 0x16A4
}
Export {
  Ordinal: 23
  Name: 
  RVA: 0x1B54
}
Export {
  Ordinal: 24
  Name: 
  RVA: 0x1A64
}
Export {
  Ordinal: 25
  Name: 
  RVA: 0x179E
}
Export {
  Ordinal: 26
  Name: 
  RVA: 0x1906
}
Export {
  Ordinal: 27
  Name: 
  RVA: 0x122B
}
~~~

## C++ symbol table matches

- Exit code: 0
- Matching lines: 0
~~~text
<no matching public/debug symbols>
~~~

## Printable class-name strings

- Matches: 0
~~~text
<no matching strings>
~~~

## Interpretation boundary

If symbols or constructor code are recovered here, use them only to
understand field initialization and control flow. Do not transplant WINS
addresses, vtables, calling conventions or export ordinals into the ARM
game. The current live trace is blocked at ARM UREL EIKCORE ordinal 224;
a matching N-Gage ARM EIKCORE DLL or ROM dump is still needed to resolve
its remaining secondary-vtable initialization with confidence.
