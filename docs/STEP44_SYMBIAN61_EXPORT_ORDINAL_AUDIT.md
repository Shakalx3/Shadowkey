# Step 44 — Symbian 6.1 SDK export ordinal audit

Resolved against the original N-Gage/S60 1.2 SDK WINS/UREL DLL export directories, not inferred from newer Symbian releases.

## EFSRV.DLL

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/urel/efsrv.dll (45056 bytes)
- Export ordinal base: 1; functions: 231; named exports: 0

| Ordinal | Export name | RVA |
|---:|---|---:|
| 18 | <NONAME> | 0x00001439 |
| 136 | <NONAME> | 0x000035ee |
| 137 | <NONAME> | 0x000035ee |
| 138 | <NONAME> | 0x00002384 |
| 139 | <NONAME> | 0x000023c2 |
| 140 | <NONAME> | 0x000026dd |
| 141 | <NONAME> | 0x000051e5 |
| 142 | <NONAME> | 0x00005270 |
| 143 | <NONAME> | 0x00001dad |
| 185 | <NONAME> | 0x00005e20 |

## EUSER.DLL

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/urel/euser.dll (274432 bytes)
- Export ordinal base: 1; functions: 1684; named exports: 0

| Ordinal | Export name | RVA |
|---:|---|---:|
| 1407 | <NONAME> | 0x0002b72e |
| 1575 | <NONAME> | 0x0002986a |

## CONE.DLL

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/urel/cone.dll (49152 bytes)
- Export ordinal base: 1; functions: 317; named exports: 0

| Ordinal | Export name | RVA |
|---:|---|---:|
| 160 | <NONAME> | 0x0000237a |

## GDI.DLL

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/urel/gdi.dll (40960 bytes)
- Export ordinal base: 1; functions: 195; named exports: 0

| Ordinal | Export name | RVA |
|---:|---|---:|
| 101 | <NONAME> | 0x00002afa |
| 108 | <NONAME> | 0x0000343a |
| 151 | <NONAME> | 0x0000387f |

## WINS UDEB COFF import-library ordinal map

The short-import records are parsed directly. NameType=0 means the 16-bit field is an export ordinal.

### EFSRV.LIB

- Import-object records: 231
- Ordinal 18: ??ACDir@@QBEABVTEntry@@H@Z; NameType=[0]
- Ordinal 136: ?NotifyFileManOperation@MFileManObserver@@UAE?AW4TControl@1@XZ; NameType=[0]
- Ordinal 137: ?NotifyFileManStarted@MFileManObserver@@UAE?AW4TControl@1@XZ; NameType=[0]
- Ordinal 138: ?Open@RDir@@QAEHAAVRFs@@ABVTDesC16@@ABVTUidType@@@Z; NameType=[0]
- Ordinal 139: ?Open@RDir@@QAEHAAVRFs@@ABVTDesC16@@I@Z; NameType=[0]
- Ordinal 140: ?Open@RFile@@QAEHAAVRFs@@ABVTDesC16@@I@Z; NameType=[0]
- Ordinal 141: ?Open@RFormat@@QAEHAAVRFs@@ABVTDesC16@@IAAH@Z; NameType=[0]
- Ordinal 142: ?Open@RRawDisk@@QAEHAAVRFs@@H@Z; NameType=[0]
- Ordinal 143: ?Parse@RFs@@QBEHABVTDesC16@@0AAVTParse@@@Z; NameType=[0]
- Ordinal 185: ?Set@TParse@@QAEHABVTDesC16@@PBV2@1@Z; NameType=[0]

### EUSER.LIB

- Import-object records: 1684
- Ordinal 1407: ?SetOffset@TDblQueBase@@QAEXH@Z; NameType=[0]
- Ordinal 1575: ?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z; NameType=[0]

### CONE.LIB

- Import-object records: 317
- Ordinal 160: ?Position@CCoeControl@@QBE?AVTPoint@@XZ; NameType=[0]

### GDI.LIB

- Import-object records: 195
- Ordinal 101: ?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z; NameType=[0]
- Ordinal 108: ?NewL@CPalette@@SAPAV1@H@Z; NameType=[0]
- Ordinal 151: ?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z; NameType=[0]

## Exact symbol map for imports used by 6R51.APP

- Game import slots mapped: 0
| Thunk | Slot | DLL | Ordinal | Original SDK symbol |
|---:|---:|---|---:|---|

## ARM import library symbol scan

The WINS PE DLLs export by ordinal only. The ARM import libraries are scanned for symbol names to recover the ordinal/name map.

### EFSRV.LIB

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/efsrv.lib (201972 bytes)
- file(1): /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/efsrv.lib: current ar archive 
- nm exit=0; stdout lines=0; stderr=nm: dt.o: file format not recognized
nm: dh.o: file format not recognized
nm: ds00001.o: file format not recognized
nm: ds00221.o: file format not recognized
nm: ds00229.o: file format not recognized
nm: ds00220.o: file format not recognized
nm: ds00219.o: file format not recognized
nm: ds00218.o: file format not recognized
nm: ds00217.o: file format not recognized
nm: ds00216.o: file format not recognized
nm: ds00215.o: file format not recognized
nm: ds00230.o: file format not recognized
nm: ds
- nm symbol-name matches: 0

- strings lines=5110; relevant matches=1068
  - __as__10TDriveUnitRC7TDesC16
  - __imp___as__10TDriveUnitRC7TDesC16
  - _imp____as__10TDriveUnitRC7TDesC16
  - __9TParsePtrR6TDes16
  - __imp___9TParsePtrR6TDes16
  - _imp____9TParsePtrR6TDes16
  - __9TFindFileR3RFs
  - __imp___9TFindFileR3RFs
  - _imp____9TFindFileR3RFs
  - __9CFileBaseR3RFs
  - __imp___9CFileBaseR3RFs
  - _imp____9CFileBaseR3RFs
  - __6TParse
  - __imp___6TParse
  - _imp____6TParse
  - __13TOpenFileScanR3RFs
  - __imp___13TOpenFileScanR3RFs
  - _imp____13TOpenFileScanR3RFs
  - __10TParsePtrCRC7TDesC16
  - __imp___10TParsePtrCRC7TDesC16
  - _imp____10TParsePtrCRC7TDesC16
  - __10TParseBase
  - __imp___10TParseBase
  - _imp____10TParseBase
  - __10TDriveUnitRC7TDesC16
  - __imp___10TDriveUnitRC7TDesC16
  - _imp____10TDriveUnitRC7TDesC16
  - Write__9TFileTextRC7TDesC16
  - __imp_Write__9TFileTextRC7TDesC16
  - _imp__Write__9TFileTextRC7TDesC16
  - Write__8RRawDiskiR6TDesC8
  - __imp_Write__8RRawDiskiR6TDesC8
  - _imp__Write__8RRawDiskiR6TDesC8
  - Write__5RFileiRC6TDesC8iR14TRequestStatus
  - __imp_Write__5RFileiRC6TDesC8iR14TRequestStatus
  - _imp__Write__5RFileiRC6TDesC8iR14TRequestStatus
  - Write__5RFileiRC6TDesC8i
  - __imp_Write__5RFileiRC6TDesC8i
  - _imp__Write__5RFileiRC6TDesC8i
  - Write__5RFileiRC6TDesC8R14TRequestStatus
  - __imp_Write__5RFileiRC6TDesC8R14TRequestStatus
  - _imp__Write__5RFileiRC6TDesC8R14TRequestStatus
  - Write__5RFileiRC6TDesC8
  - __imp_Write__5RFileiRC6TDesC8
  - _imp__Write__5RFileiRC6TDesC8
  - Write__5RFileRC6TDesC8iR14TRequestStatus
  - __imp_Write__5RFileRC6TDesC8iR14TRequestStatus
  - _imp__Write__5RFileRC6TDesC8iR14TRequestStatus
  - Write__5RFileRC6TDesC8i
  - __imp_Write__5RFileRC6TDesC8i
  - _imp__Write__5RFileRC6TDesC8i
  - Write__5RFileRC6TDesC8R14TRequestStatus
  - __imp_Write__5RFileRC6TDesC8R14TRequestStatus
  - _imp__Write__5RFileRC6TDesC8R14TRequestStatus
  - Write__5RFileRC6TDesC8
  - __imp_Write__5RFileRC6TDesC8
  - _imp__Write__5RFileRC6TDesC8
  - Volume__C3RFsR11TVolumeInfoi
  - __imp_Volume__C3RFsR11TVolumeInfoi
  - _imp__Volume__C3RFsR11TVolumeInfoi
  - Version__C3RFs
  - __imp_Version__C3RFs
  - _imp__Version__C3RFs
  - UnlockDrive__3RFsiRCt5TBuf81i16i
  - __imp_UnlockDrive__3RFsiRCt5TBuf81i16i
  - _imp__UnlockDrive__3RFsiRCt5TBuf81i16i
  - UnLock__C5RFileii
  - __imp_UnLock__C5RFileii
  - _imp__UnLock__C5RFileii
  - Temp__5RFileR3RFsRC7TDesC16Rt4TBuf1i256Ui
  - __imp_Temp__5RFileR3RFsRC7TDesC16Rt4TBuf1i256Ui
  - _imp__Temp__5RFileR3RFsRC7TDesC16Rt4TBuf1i256Ui
  - Subst__C3RFsR6TDes16i
  - __imp_Subst__C3RFsR6TDes16i
  - _imp__Subst__C3RFsR6TDes16i
  - Size__C5RFileRi
  - __imp_Size__C5RFileRi
  - _imp__Size__C5RFileRi
  - Set__9TFileTextR5RFile
  - __imp_Set__9TFileTextR5RFile
  - _imp__Set__9TFileTextR5RFile
  - Set__6TParseRC7TDesC16PC7TDesC16T2
  - __imp_Set__6TParseRC7TDesC16PC7TDesC16T2
  - _imp__Set__6TParseRC7TDesC16PC7TDesC16T2
  - Set__5RFileRC5TTimeUiUi
  - __imp_Set__5RFileRC5TTimeUiUi
  - _imp__Set__5RFileRC5TTimeUiUi
  - SetVolumeLabel__3RFsRC7TDesC16i
  - __imp_SetVolumeLabel__3RFsRC7TDesC16i
  - _imp__SetVolumeLabel__3RFsRC7TDesC16i
  - SetSubst__3RFsRC7TDesC16i
  - __imp_SetSubst__3RFsRC7TDesC16i
  - _imp__SetSubst__3RFsRC7TDesC16i
  - SetSize__5RFilei
  - __imp_SetSize__5RFilei
  - _imp__SetSize__5RFilei
  - SetSessionPath__3RFsRC7TDesC16
  - __imp_SetSessionPath__3RFsRC7TDesC16
  - _imp__SetSessionPath__3RFsRC7TDesC16
  - SetScanDataL__8CDirScanRC7TDesC16UiUiQ28CDirScan14TScanDirection
  - __imp_SetScanDataL__8CDirScanRC7TDesC16UiUiQ28CDirScan14TScanDirection
  - _imp__SetScanDataL__8CDirScanRC7TDesC16UiUiQ28CDirScan14TScanDirection
  - SetNotifyUser__3RFsi
  - __imp_SetNotifyUser__3RFsi
  - _imp__SetNotifyUser__3RFsi
  - SetNoWild__6TParseRC7TDesC16PC7TDesC16T2
  - __imp_SetNoWild__6TParseRC7TDesC16PC7TDesC16T2
  - _imp__SetNoWild__6TParseRC7TDesC16PC7TDesC16T2
  - SetModified__5RFileRC5TTime
  - __imp_SetModified__5RFileRC5TTime
  - _imp__SetModified__5RFileRC5TTime
  - SetModified__3RFsRC7TDesC16RC5TTime
  - __imp_SetModified__3RFsRC7TDesC16RC5TTime
  - _imp__SetModified__3RFsRC7TDesC16RC5TTime
  - SetErrorCondition__3RFsii
  - __imp_SetErrorCondition__3RFsii
  - _imp__SetErrorCondition__3RFsii
  - SetEntry__3RFsRC7TDesC16RC5TTimeUiUi
  - __imp_SetEntry__3RFsRC7TDesC16RC5TTimeUiUi
  - _imp__SetEntry__3RFsRC7TDesC16RC5TTimeUiUi
  - SetDriveName__3RFsiRC7TDesC16
  - __imp_SetDriveName__3RFsiRC7TDesC16
  - _imp__SetDriveName__3RFsiRC7TDesC16
  - SetDefaultPath__3RFsRC7TDesC16
  - __imp_SetDefaultPath__3RFsRC7TDesC16
  - _imp__SetDefaultPath__3RFsRC7TDesC16
  - SetDebugRegister__3RFsi
  - __imp_SetDebugRegister__3RFsi
  - _imp__SetDebugRegister__3RFsi
  - SetAtt__5RFileUiUi
  - __imp_SetAtt__5RFileUiUi
  - _imp__SetAtt__5RFileUiUi
  - SetAtt__3RFsRC7TDesC16UiUi
  - __imp_SetAtt__3RFsRC7TDesC16UiUi
  - _imp__SetAtt__3RFsRC7TDesC16UiUi
  - SetAllocFailure__3RFsi
  - __imp_SetAllocFailure__3RFsi
  - _imp__SetAllocFailure__3RFsi
  - SessionPath__C3RFsR6TDes16
  - __imp_SessionPath__C3RFsR6TDes16
  - _imp__SessionPath__C3RFsR6TDes16
  - Seek__C5RFile5TSeekRi
  - __imp_Seek__C5RFile5TSeekRi
  - _imp__Seek__C5RFile5TSeekRi
  - ScanDrive__C3RFsRC7TDesC16
  - __imp_ScanDrive__C3RFsRC7TDesC16
  - _imp__ScanDrive__C3RFsRC7TDesC16
  - RmDir__8CFileManRC7TDesC16R14TRequestStatus
  - __imp_RmDir__8CFileManRC7TDesC16R14TRequestStatus
  - _imp__RmDir__8CFileManRC7TDesC16R14TRequestStatus
  - RmDir__8CFileManRC7TDesC16
  - __imp_RmDir__8CFileManRC7TDesC16
  - _imp__RmDir__8CFileManRC7TDesC16
  - RmDir__3RFsRC7TDesC16
  - __imp_RmDir__3RFsRC7TDesC16
  - _imp__RmDir__3RFsRC7TDesC16
  - ResourceCount__C3RFs
  - __imp_ResourceCount__C3RFs
  - _imp__ResourceCount__C3RFs
  - ResourceCountMarkStart__C3RFs

### EUSER.LIB

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/euser.lib (1430680 bytes)
- file(1): /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/euser.lib: current ar archive 
- nm exit=0; stdout lines=0; stderr=nm: dt.o: file format not recognized
nm: dh.o: file format not recognized
nm: ds00003.o: file format not recognized
nm: ds00001.o: file format not recognized
nm: ds00002.o: file format not recognized
nm: ds01621.o: file format not recognized
nm: ds01620.o: file format not recognized
nm: ds01619.o: file format not recognized
nm: ds01618.o: file format not recognized
nm: ds01617.o: file format not recognized
nm: ds01616.o: file format not recognized
nm: ds01641.o: file format not recognized
nm: ds
- nm symbol-name matches: 0

- strings lines=36966; relevant matches=2598
  - __pl__C6TPointRC6TPoint
  - __imp___pl__C6TPointRC6TPoint
  - _imp____pl__C6TPointRC6TPoint
  - __pl__C6TPointRC5TSize
  - __imp___pl__C6TPointRC5TSize
  - _imp____pl__C6TPointRC5TSize
  - __pl__C5TSizeRC6TPoint
  - __imp___pl__C5TSizeRC6TPoint
  - _imp____pl__C5TSizeRC6TPoint
  - __pl__C5TSizeRC5TSize
  - __imp___pl__C5TSizeRC5TSize
  - _imp____pl__C5TSizeRC5TSize
  - __ne__C6TPointRC6TPoint
  - __imp___ne__C6TPointRC6TPoint
  - _imp____ne__C6TPointRC6TPoint
  - __ne__C5TSizeRC5TSize
  - __imp___ne__C5TSizeRC5TSize
  - _imp____ne__C5TSizeRC5TSize
  - __mi__C6TPointRC6TPoint
  - __imp___mi__C6TPointRC6TPoint
  - _imp____mi__C6TPointRC6TPoint
  - __mi__C6TPointRC5TSize
  - __imp___mi__C6TPointRC5TSize
  - _imp____mi__C6TPointRC5TSize
  - __mi__C6TPoint
  - __imp___mi__C6TPoint
  - _imp____mi__C6TPoint
  - __mi__C5TSizeRC6TPoint
  - __imp___mi__C5TSizeRC6TPoint
  - _imp____mi__C5TSizeRC6TPoint
  - __mi__C5TSizeRC5TSize
  - __imp___mi__C5TSizeRC5TSize
  - _imp____mi__C5TSizeRC5TSize
  - __mi__C5TSize
  - __imp___mi__C5TSize
  - _imp____mi__C5TSize
  - __eq__C6TPointRC6TPoint
  - __imp___eq__C6TPointRC6TPoint
  - _imp____eq__C6TPointRC6TPoint
  - __eq__C5TSizeRC5TSize
  - __imp___eq__C5TSizeRC5TSize
  - _imp____eq__C5TSizeRC5TSize
  - __as__7HBufC16RC7TDesC16
  - __imp___as__7HBufC16RC7TDesC16
  - _imp____as__7HBufC16RC7TDesC16
  - __as__7HBufC16PCUs
  - __imp___as__7HBufC16PCUs
  - _imp____as__7HBufC16PCUs
  - __as__6HBufC8RC6TDesC8
  - __imp___as__6HBufC8RC6TDesC8
  - _imp____as__6HBufC8RC6TDesC8
  - __as__6HBufC8PCUc
  - __imp___as__6HBufC8PCUc
  - _imp____as__6HBufC8PCUc
  - __apl__6TPointRC6TPoint
  - __imp___apl__6TPointRC6TPoint
  - _imp____apl__6TPointRC6TPoint
  - __apl__6TPointRC5TSize
  - __imp___apl__6TPointRC5TSize
  - _imp____apl__6TPointRC5TSize
  - __apl__5TSizeRC6TPoint
  - __imp___apl__5TSizeRC6TPoint
  - _imp____apl__5TSizeRC6TPoint
  - __apl__5TSizeRC5TSize
  - __imp___apl__5TSizeRC5TSize
  - _imp____apl__5TSizeRC5TSize
  - __ami__6TPointRC6TPoint
  - __imp___ami__6TPointRC6TPoint
  - _imp____ami__6TPointRC6TPoint
  - __ami__6TPointRC5TSize
  - __imp___ami__6TPointRC5TSize
  - _imp____ami__6TPointRC5TSize
  - __ami__5TSizeRC6TPoint
  - __imp___ami__5TSizeRC6TPoint
  - _imp____ami__5TSizeRC6TPoint
  - __ami__5TSizeRC5TSize
  - __imp___ami__5TSizeRC5TSize
  - _imp____ami__5TSizeRC5TSize
  - __DbgTestInvariant__C7TDesC16
  - __imp___DbgTestInvariant__C7TDesC16
  - _imp____DbgTestInvariant__C7TDesC16
  - __DbgTestInvariant__C7HBufC16
  - __imp___DbgTestInvariant__C7HBufC16
  - _imp____DbgTestInvariant__C7HBufC16
  - __DbgTestInvariant__C6TDesC8
  - __imp___DbgTestInvariant__C6TDesC8
  - _imp____DbgTestInvariant__C6TDesC8
  - __DbgTestInvariant__C6TDes16
  - __imp___DbgTestInvariant__C6TDes16
  - _imp____DbgTestInvariant__C6TDes16
  - __DbgTestInvariant__C6HBufC8
  - __imp___DbgTestInvariant__C6HBufC8
  - _imp____DbgTestInvariant__C6HBufC8
  - __DbgTestInvariant__C5TDes8
  - __imp___DbgTestInvariant__C5TDes8
  - _imp____DbgTestInvariant__C5TDes8
  - __DbgMarkCheck__5RHeapiiRC6TDesC8i
  - __imp___DbgMarkCheck__5RHeapiiRC6TDesC8i
  - _imp____DbgMarkCheck__5RHeapiiRC6TDesC8i
  - __DbgMarkCheck__4UserQ25RHeap12TDbgHeapTypeiiRC6TDesC8i
  - __imp___DbgMarkCheck__4UserQ25RHeap12TDbgHeapTypeiiRC6TDesC8i
  - _imp____DbgMarkCheck__4UserQ25RHeap12TDbgHeapTypeiiRC6TDesC8i
  - __9TBufBase8ii
  - __imp___9TBufBase8ii
  - _imp____9TBufBase8ii
  - __9TBufBase8i
  - __imp___9TBufBase8i
  - _imp____9TBufBase8i
  - __9TBufBase8RC6TDesC8i
  - __imp___9TBufBase8RC6TDesC8i
  - _imp____9TBufBase8RC6TDesC8i
  - __9TBufBase8PCUci
  - __imp___9TBufBase8PCUci
  - _imp____9TBufBase8PCUci
  - __7TPtrC16RC7TDesC16
  - __imp___7TPtrC16RC7TDesC16
  - _imp____7TPtrC16RC7TDesC16
  - __6TPtrC8RC6TDesC8
  - __imp___6TPtrC8RC6TDesC8
  - _imp____6TPtrC8RC6TDesC8
  - __6TPtr16R11TBufCBase16i
  - __imp___6TPtr16R11TBufCBase16i
  - _imp____6TPtr16R11TBufCBase16i
  - __5TTimeRC7TDesC16
  - __imp___5TTimeRC7TDesC16
  - _imp____5TTimeRC7TDesC16
  - __5TRectRC6TPointT1
  - __imp___5TRectRC6TPointT1
  - _imp____5TRectRC6TPointT1
  - __5TRectRC6TPointRC5TSize
  - __imp___5TRectRC6TPointRC5TSize
  - _imp____5TRectRC6TPointRC5TSize
  - __5TRectRC5TSize
  - __imp___5TRectRC5TSize
  - _imp____5TRectRC5TSize
  - __5TPtr8R10TBufCBase8i
  - __imp___5TPtr8R10TBufCBase8i
  - _imp____5TPtr8R10TBufCBase8i
  - __5RTestRC7TDesC16i
  - __imp___5RTestRC7TDesC16i
  - _imp____5RTestRC7TDesC16i
  - __5RTestRC7TDesC16
  - __imp___5RTestRC7TDesC16
  - _imp____5RTestRC7TDesC16
  - __20TShortDateFormatSpec
  - __imp___20TShortDateFormatSpec
  - _imp____20TShortDateFormatSpec
  - __19TLongDateFormatSpec
  - __imp___19TLongDateFormatSpec
  - _imp____19TLongDateFormatSpec
  - __15TTimeFormatSpec
  - __imp___15TTimeFormatSpec
  - _imp____15TTimeFormatSpec
  - __15TFindHandleBaseRC7TDesC16
  - __imp___15TFindHandleBaseRC7TDesC16
  - _imp____15TFindHandleBaseRC7TDesC16
  - __11TRealFormatii
  - __imp___11TRealFormatii
  - _imp____11TRealFormatii
  - __11TRealFormati

### CONE.LIB

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/cone.lib (299776 bytes)
- file(1): /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/cone.lib: current ar archive 
- nm exit=0; stdout lines=0; stderr=nm: dt.o: file format not recognized
nm: dh.o: file format not recognized
nm: ds00245.o: file format not recognized
nm: ds00001.o: file format not recognized
nm: ds00009.o: file format not recognized
nm: ds00243.o: file format not recognized
nm: ds00060.o: file format not recognized
nm: ds00242.o: file format not recognized
nm: ds00241.o: file format not recognized
nm: ds00300.o: file format not recognized
nm: ds00067.o: file format not recognized
nm: ds00083.o: file format not recognized
nm: ds
- nm symbol-name matches: 0

- strings lines=7002; relevant matches=744
  - __15TCoeHelpContextG4TUidRC7TDesC16
  - __imp___15TCoeHelpContextG4TUidRC7TDesC16
  - _imp____15TCoeHelpContextG4TUidRC7TDesC16
  - __11CCoeControl
  - __imp___11CCoeControl
  - _imp____11CCoeControl
  - _._11CCoeControl
  - __imp__._11CCoeControl
  - _imp___._11CCoeControl
  - WriteInternalStateL__C11CCoeControlR12RWriteStream
  - __imp_WriteInternalStateL__C11CCoeControlR12RWriteStream
  - _imp__WriteInternalStateL__C11CCoeControlR12RWriteStream
  - Window__C11CCoeControl
  - __imp_Window__C11CCoeControl
  - _imp__Window__C11CCoeControl
  - UpdateViewStackedControlFlags__9CCoeAppUiRC8MCoeViewP11CCoeControlii
  - __imp_UpdateViewStackedControlFlags__9CCoeAppUiRC8MCoeViewP11CCoeControlii
  - _imp__UpdateViewStackedControlFlags__9CCoeAppUiRC8MCoeViewP11CCoeControlii
  - UpdateStackedControlFlags__9CCoeAppUiP11CCoeControlii
  - __imp_UpdateStackedControlFlags__9CCoeAppUiP11CCoeControlii
  - _imp__UpdateStackedControlFlags__9CCoeAppUiP11CCoeControlii
  - SystemGc__C11CCoeControl
  - __imp_SystemGc__C11CCoeControl
  - _imp__SystemGc__C11CCoeControl
  - Size__C11CCoeControl
  - __imp_Size__C11CCoeControl
  - _imp__Size__C11CCoeControl
  - SizeChanged__11CCoeControl
  - __imp_SizeChanged__11CCoeControl
  - _imp__SizeChanged__11CCoeControl
  - SetUpFepL__7CCoeEnvP17CCoeFepParametersRC7TDesC16
  - __imp_SetUpFepL__7CCoeEnvP17CCoeFepParametersRC7TDesC16
  - _imp__SetUpFepL__7CCoeEnvP17CCoeFepParametersRC7TDesC16
  - SetSize__11CCoeControlRC5TSize
  - __imp_SetSize__11CCoeControlRC5TSize
  - _imp__SetSize__11CCoeControlRC5TSize
  - SetSizeWithoutNotification__11CCoeControlRC5TSize
  - __imp_SetSizeWithoutNotification__11CCoeControlRC5TSize
  - _imp__SetSizeWithoutNotification__11CCoeControlRC5TSize
  - SetRootControl__15CCoeAppUiSimpleP11CCoeControl
  - __imp_SetRootControl__15CCoeAppUiSimpleP11CCoeControl
  - _imp__SetRootControl__15CCoeAppUiSimpleP11CCoeControl
  - SetRect__11CCoeControlRC5TRect
  - __imp_SetRect__11CCoeControlRC5TRect
  - _imp__SetRect__11CCoeControlRC5TRect
  - SetPosition__11CCoeControlRC6TPoint
  - __imp_SetPosition__11CCoeControlRC6TPoint
  - _imp__SetPosition__11CCoeControlRC6TPoint
  - SetPointerCapture__11CCoeControli
  - __imp_SetPointerCapture__11CCoeControli
  - _imp__SetPointerCapture__11CCoeControli
  - SetObserver__11CCoeControlP19MCoeControlObserver
  - __imp_SetObserver__11CCoeControlP19MCoeControlObserver
  - _imp__SetObserver__11CCoeControlP19MCoeControlObserver
  - SetNonFocusing__11CCoeControl
  - __imp_SetNonFocusing__11CCoeControl
  - _imp__SetNonFocusing__11CCoeControl
  - SetNeighbor__11CCoeControlP11CCoeControl
  - __imp_SetNeighbor__11CCoeControlP11CCoeControl
  - _imp__SetNeighbor__11CCoeControlP11CCoeControl
  - SetMopParent__11CCoeControlP15MObjectProvider
  - __imp_SetMopParent__11CCoeControlP15MObjectProvider
  - _imp__SetMopParent__11CCoeControlP15MObjectProvider
  - SetGloballyCapturing__11CCoeControli
  - __imp_SetGloballyCapturing__11CCoeControli
  - _imp__SetGloballyCapturing__11CCoeControli
  - SetFocusing__11CCoeControli
  - __imp_SetFocusing__11CCoeControli
  - _imp__SetFocusing__11CCoeControli
  - SetFocus__11CCoeControli8TDrawNow
  - __imp_SetFocus__11CCoeControli8TDrawNow
  - _imp__SetFocus__11CCoeControli8TDrawNow
  - SetExtent__11CCoeControlRC6TPointRC5TSize
  - __imp_SetExtent__11CCoeControlRC6TPointRC5TSize
  - _imp__SetExtent__11CCoeControlRC6TPointRC5TSize
  - SetExtentToWholeScreen__11CCoeControl
  - __imp_SetExtentToWholeScreen__11CCoeControl
  - _imp__SetExtentToWholeScreen__11CCoeControl
  - SetDimmed__11CCoeControli
  - __imp_SetDimmed__11CCoeControli
  - _imp__SetDimmed__11CCoeControli
  - SetCornerAndSize__11CCoeControlG13TGulAlignmentRC5TSize
  - __imp_SetCornerAndSize__11CCoeControlG13TGulAlignmentRC5TSize
  - _imp__SetCornerAndSize__11CCoeControlG13TGulAlignmentRC5TSize
  - SetControlContext__11CCoeControlP18MCoeControlContext
  - __imp_SetControlContext__11CCoeControlP18MCoeControlContext
  - _imp__SetControlContext__11CCoeControlP18MCoeControlContext
  - SetContainerWindowL__11CCoeControlRC11CCoeControl
  - __imp_SetContainerWindowL__11CCoeControlRC11CCoeControl
  - _imp__SetContainerWindowL__11CCoeControlRC11CCoeControl
  - SetContainerWindowL__11CCoeControlR7RWindow
  - __imp_SetContainerWindowL__11CCoeControlR7RWindow
  - _imp__SetContainerWindowL__11CCoeControlR7RWindow
  - SetContainerWindowL__11CCoeControlR15RBackedUpWindow
  - __imp_SetContainerWindowL__11CCoeControlR15RBackedUpWindow
  - _imp__SetContainerWindowL__11CCoeControlR15RBackedUpWindow
  - SetComponentsToInheritVisibility__11CCoeControli
  - __imp_SetComponentsToInheritVisibility__11CCoeControli
  - _imp__SetComponentsToInheritVisibility__11CCoeControli
  - SetCanDrawOutsideRect__11CCoeControl
  - __imp_SetCanDrawOutsideRect__11CCoeControl
  - _imp__SetCanDrawOutsideRect__11CCoeControl
  - SetBrushStyle__22CCoeBrushAndPenContextQ216CGraphicsContext11TBrushStyle
  - __imp_SetBrushStyle__22CCoeBrushAndPenContextQ216CGraphicsContext11TBrushStyle
  - _imp__SetBrushStyle__22CCoeBrushAndPenContextQ216CGraphicsContext11TBrushStyle
  - SetBlank__11CCoeControl
  - __imp_SetBlank__11CCoeControl
  - _imp__SetBlank__11CCoeControl
  - SetAllowStrayPointers__11CCoeControl
  - __imp_SetAllowStrayPointers__11CCoeControl
  - _imp__SetAllowStrayPointers__11CCoeControl
  - SetAdjacent__11CCoeControli
  - __imp_SetAdjacent__11CCoeControli
  - _imp__SetAdjacent__11CCoeControli
  - ResetGc__C11CCoeControl
  - __imp_ResetGc__C11CCoeControl
  - _imp__ResetGc__C11CCoeControl
  - Reserved_2__11CCoeControl
  - __imp_Reserved_2__11CCoeControl
  - _imp__Reserved_2__11CCoeControl
  - ReportEventL__11CCoeControlQ219MCoeControlObserver9TCoeEvent
  - __imp_ReportEventL__11CCoeControlQ219MCoeControlObserver9TCoeEvent
  - _imp__ReportEventL__11CCoeControlQ219MCoeControlObserver9TCoeEvent
  - RemoveFromViewStack__9CCoeAppUiRC8MCoeViewP11CCoeControl
  - __imp_RemoveFromViewStack__9CCoeAppUiRC8MCoeViewP11CCoeControl
  - _imp__RemoveFromViewStack__9CCoeAppUiRC8MCoeViewP11CCoeControl
  - RemoveFromStack__9CCoeAppUiP11CCoeControl
  - __imp_RemoveFromStack__9CCoeAppUiP11CCoeControl
  - _imp__RemoveFromStack__9CCoeAppUiP11CCoeControl
  - ReleaseScreenFont__C7CCoeEnvP5CFont
  - __imp_ReleaseScreenFont__C7CCoeEnvP5CFont
  - _imp__ReleaseScreenFont__C7CCoeEnvP5CFont
  - RecursivelyMergedInputCapabilities__C11CCoeControl
  - __imp_RecursivelyMergedInputCapabilities__C11CCoeControl
  - _imp__RecursivelyMergedInputCapabilities__C11CCoeControl
  - Rect__C11CCoeControl
  - __imp_Rect__C11CCoeControl
  - _imp__Rect__C11CCoeControl
  - ReadResourceAsDes8__C7CCoeEnvR5TDes8i
  - __imp_ReadResourceAsDes8__C7CCoeEnvR5TDes8i
  - _imp__ReadResourceAsDes8__C7CCoeEnvR5TDes8i
  - ReadResourceAsDes16__C7CCoeEnvR6TDes16i
  - __imp_ReadResourceAsDes16__C7CCoeEnvR6TDes16i
  - _imp__ReadResourceAsDes16__C7CCoeEnvR6TDes16i
  - PrepareForFocusLossL__11CCoeControl
  - __imp_PrepareForFocusLossL__11CCoeControl
  - _imp__PrepareForFocusLossL__11CCoeControl
  - PrepareForFocusGainL__11CCoeControl
  - __imp_PrepareForFocusGainL__11CCoeControl
  - _imp__PrepareForFocusGainL__11CCoeControl
  - Position__C11CCoeControl
  - __imp_Position__C11CCoeControl
  - _imp__Position__C11CCoeControl
  - PositionRelativeToScreen__C11CCoeControl
  - __imp_PositionRelativeToScreen__C11CCoeControl
  - _imp__PositionRelativeToScreen__C11CCoeControl
  - PositionChanged__11CCoeControl
  - __imp_PositionChanged__11CCoeControl
  - _imp__PositionChanged__11CCoeControl
  - OwnsWindow__C11CCoeControl

### GDI.LIB

- File: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/gdi.lib (175970 bytes)
- file(1): /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel/gdi.lib: current ar archive 
- nm exit=0; stdout lines=0; stderr=nm: dt.o: file format not recognized
nm: dh.o: file format not recognized
nm: ds00001.o: file format not recognized
nm: ds00160.o: file format not recognized
nm: ds00159.o: file format not recognized
nm: ds00158.o: file format not recognized
nm: ds00157.o: file format not recognized
nm: ds00156.o: file format not recognized
nm: ds00155.o: file format not recognized
nm: ds00186.o: file format not recognized
nm: ds00154.o: file format not recognized
nm: ds00153.o: file format not recognized
nm: ds
- nm symbol-name matches: 0

- strings lines=4318; relevant matches=318
  - __eq__C9TFontSpecRC9TFontSpec
  - __imp___eq__C9TFontSpecRC9TFontSpec
  - _imp____eq__C9TFontSpecRC9TFontSpec
  - __9TPageSpecQ29TPageSpec16TPageOrientationRC5TSize
  - __imp___9TPageSpecQ29TPageSpec16TPageOrientationRC5TSize
  - _imp____9TPageSpecQ29TPageSpec16TPageOrientationRC5TSize
  - __9TFontSpecRC7TDesC16i
  - __imp___9TFontSpecRC7TDesC16i
  - _imp____9TFontSpecRC7TDesC16i
  - __9TFontSpec
  - __imp___9TFontSpec
  - _imp____9TFontSpec
  - __10TFontStyle12TFontPosture17TFontStrokeWeight18TFontPrintPosition
  - __imp___10TFontStyle12TFontPosture17TFontStrokeWeight18TFontPrintPosition
  - _imp____10TFontStyle12TFontPosture17TFontStrokeWeight18TFontPrintPosition
  - __10TFontStyle
  - __imp___10TFontStyle
  - _imp____10TFontStyle
  - __10CFontCachei
  - __imp___10CFontCachei
  - _imp____10CFontCachei
  - __10CFontCache
  - __imp___10CFontCache
  - _imp____10CFontCache
  - _._5CFont
  - __imp__._5CFont
  - _imp___._5CFont
  - _._10CFontCache
  - __imp__._10CFontCache
  - _imp___._10CFontCache
  - WidthZeroInPixels__C5CFont
  - __imp_WidthZeroInPixels__C5CFont
  - _imp__WidthZeroInPixels__C5CFont
  - TwipsToPixels__C18MGraphicsDeviceMapRC6TPoint
  - __imp_TwipsToPixels__C18MGraphicsDeviceMapRC6TPoint
  - _imp__TwipsToPixels__C18MGraphicsDeviceMapRC6TPoint
  - SuperSubHeight__14CTypefaceStorei18TFontPrintPosition
  - __imp_SuperSubHeight__14CTypefaceStorei18TFontPrintPosition
  - _imp__SuperSubHeight__14CTypefaceStorei18TFontPrintPosition
  - StrokeWeight__C10TFontStyle
  - __imp_StrokeWeight__C10TFontStyle
  - _imp__StrokeWeight__C10TFontStyle
  - SingleStep__10TLinearDDAR6TPoint
  - __imp_SingleStep__10TLinearDDAR6TPoint
  - _imp__SingleStep__10TLinearDDAR6TPoint
  - SingleScanline__10TLinearDDAR6TPointT1
  - __imp_SingleScanline__10TLinearDDAR6TPointT1
  - _imp__SingleScanline__10TLinearDDAR6TPointT1
  - SetTwipToPixelMapping__11TZoomFactorRC5TSizeT1
  - __imp_SetTwipToPixelMapping__11TZoomFactorRC5TSizeT1
  - _imp__SetTwipToPixelMapping__11TZoomFactorRC5TSizeT1
  - SetStrokeWeight__10TFontStyle17TFontStrokeWeight
  - __imp_SetStrokeWeight__10TFontStyle17TFontStrokeWeight
  - _imp__SetStrokeWeight__10TFontStyle17TFontStrokeWeight
  - SetSizeInTwips__8CPictureRC5TSize
  - __imp_SetSizeInTwips__8CPictureRC5TSize
  - _imp__SetSizeInTwips__8CPictureRC5TSize
  - SetSizeInPixels__8CPictureP18MGraphicsDeviceMapRC5TSize
  - __imp_SetSizeInPixels__8CPictureP18MGraphicsDeviceMapRC5TSize
  - _imp__SetSizeInPixels__8CPictureP18MGraphicsDeviceMapRC5TSize
  - SetPrintPosition__10TFontStyle18TFontPrintPosition
  - __imp_SetPrintPosition__10TFontStyle18TFontPrintPosition
  - _imp__SetPrintPosition__10TFontStyle18TFontPrintPosition
  - SetPosture__10TFontStyle12TFontPosture
  - __imp_SetPosture__10TFontStyle12TFontPosture
  - _imp__SetPosture__10TFontStyle12TFontPosture
  - Search__10CFontCacheRC9TFontSpec
  - __imp_Search__10CFontCacheRC9TFontSpec
  - _imp__Search__10CFontCacheRC9TFontSpec
  - Reserved__5CFont
  - __imp_Reserved__5CFont
  - _imp__Reserved__5CFont
  - Reserved__16CGraphicsContext
  - __imp_Reserved__16CGraphicsContext
  - _imp__Reserved__16CGraphicsContext
  - RemoveFirstEntry__10CFontCache
  - __imp_RemoveFirstEntry__10CFontCache
  - _imp__RemoveFirstEntry__10CFontCache
  - ReleaseFont__14CTypefaceStoreP5CFont
  - __imp_ReleaseFont__14CTypefaceStoreP5CFont
  - _imp__ReleaseFont__14CTypefaceStoreP5CFont
  - ReleaseFont__11TZoomFactorP5CFont
  - __imp_ReleaseFont__11TZoomFactorP5CFont
  - _imp__ReleaseFont__11TZoomFactorP5CFont
  - PrintPosition__C10TFontStyle
  - __imp_PrintPosition__C10TFontStyle
  - _imp__PrintPosition__C10TFontStyle
  - Posture__C10TFontStyle
  - __imp_Posture__C10TFontStyle
  - _imp__Posture__C10TFontStyle
  - PixelsToTwips__C18MGraphicsDeviceMapRC6TPoint
  - __imp_PixelsToTwips__C18MGraphicsDeviceMapRC6TPoint
  - _imp__PixelsToTwips__C18MGraphicsDeviceMapRC6TPoint
  - OpenPdrL__14CPrinterDriverRC7TDesC16
  - __imp_OpenPdrL__14CPrinterDriverRC7TDesC16
  - _imp__OpenPdrL__14CPrinterDriverRC7TDesC16
  - NextStep__10TLinearDDAR6TPoint
  - __imp_NextStep__10TLinearDDAR6TPoint
  - _imp__NextStep__10TLinearDDAR6TPoint
  - MeasureText__C5CFontRC7TDesC16PCQ25CFont17TMeasureTextInputPQ25CFont18TMeasureTextOutput
  - __imp_MeasureText__C5CFontRC7TDesC16PCQ25CFont17TMeasureTextInputPQ25CFont18TMeasureTextOutput
  - _imp__MeasureText__C5CFontRC7TDesC16PCQ25CFont17TMeasureTextInputPQ25CFont18TMeasureTextOutput
  - JustificationInPixels__16CGraphicsContextiiii
  - __imp_JustificationInPixels__16CGraphicsContextiiii
  - _imp__JustificationInPixels__16CGraphicsContextiiii
  - JustificationInPixels__16CGraphicsContextRiT1
  - __imp_JustificationInPixels__16CGraphicsContextRiT1
  - _imp__JustificationInPixels__16CGraphicsContextRiT1
  - InternalizeL__9TFontSpecR11RReadStream
  - __imp_InternalizeL__9TFontSpecR11RReadStream
  - _imp__InternalizeL__9TFontSpecR11RReadStream
  - InternalizeL__10TFontStyleR11RReadStream
  - __imp_InternalizeL__10TFontStyleR11RReadStream
  - _imp__InternalizeL__10TFontStyleR11RReadStream
  - GetSizeInTwips__C8CPictureR5TSize
  - __imp_GetSizeInTwips__C8CPictureR5TSize
  - _imp__GetSizeInTwips__C8CPictureR5TSize
  - GetSizeInPixels__C8CPictureP18MGraphicsDeviceMapR5TSize
  - __imp_GetSizeInPixels__C8CPictureP18MGraphicsDeviceMapR5TSize
  - _imp__GetSizeInPixels__C8CPictureP18MGraphicsDeviceMapR5TSize
  - GetNearestFontInTwips__11TZoomFactorRP5CFontRC9TFontSpec
  - __imp_GetNearestFontInTwips__11TZoomFactorRP5CFontRC9TFontSpec
  - _imp__GetNearestFontInTwips__11TZoomFactorRP5CFontRC9TFontSpec
  - GetCharacterPosition__C5CFontRQ25CFont14TPositionParam
  - __imp_GetCharacterPosition__C5CFontRQ25CFont14TPositionParam
  - _imp__GetCharacterPosition__C5CFontRQ25CFont14TPositionParam
  - GetCharacterData__C5CFontUiR20TOpenFontCharMetricsRPCUcR5TSize
  - __imp_GetCharacterData__C5CFontUiR20TOpenFontCharMetricsRPCUcR5TSize
  - _imp__GetCharacterData__C5CFontUiR20TOpenFontCharMetricsRPCUcR5TSize
  - ExternalizeL__C9TFontSpecR12RWriteStream
  - __imp_ExternalizeL__C9TFontSpecR12RWriteStream
  - _imp__ExternalizeL__C9TFontSpecR12RWriteStream
  - ExternalizeL__C10TFontStyleR12RWriteStream
  - __imp_ExternalizeL__C10TFontStyleR12RWriteStream
  - _imp__ExternalizeL__C10TFontStyleR12RWriteStream
  - DrawText__16CGraphicsContextRC7TDesC16RC6TPointRCQ216CGraphicsContext14TDrawTextParam
  - __imp_DrawText__16CGraphicsContextRC7TDesC16RC6TPointRCQ216CGraphicsContext14TDrawTextParam
  - _imp__DrawText__16CGraphicsContextRC7TDesC16RC6TPointRCQ216CGraphicsContext14TDrawTextParam
  - DrawTextExtended__16CGraphicsContextRC7TDesC16RC6TPointRCQ216CGraphicsContext22TDrawTextExtendedParam
  - __imp_DrawTextExtended__16CGraphicsContextRC7TDesC16RC6TPointRCQ216CGraphicsContext22TDrawTextExtendedParam
  - _imp__DrawTextExtended__16CGraphicsContextRC7TDesC16RC6TPointRCQ216CGraphicsContext22TDrawTextExtendedParam
  - DescentInPixels__C5CFont
  - __imp_DescentInPixels__C5CFont
  - _imp__DescentInPixels__C5CFont
  - Construct__10TLinearDDARC6TPointT1Q210TLinearDDA9TLineMode
  - __imp_Construct__10TLinearDDARC6TPointT1Q210TLinearDDA9TLineMode
  - _imp__Construct__10TLinearDDARC6TPointT1Q210TLinearDDA9TLineMode
  - BaselineOffset__14CTypefaceStorei18TFontPrintPosition
  - __imp_BaselineOffset__14CTypefaceStorei18TFontPrintPosition
  - _imp__BaselineOffset__14CTypefaceStorei18TFontPrintPosition
  - AddFontL__14CTypefaceStoreP5CFont
  - __imp_AddFontL__14CTypefaceStoreP5CFont
  - _imp__AddFontL__14CTypefaceStoreP5CFont
  - AddEntryL__10CFontCacheP5CFontRC9TFontSpec
  - __imp_AddEntryL__10CFontCacheP5CFontRC9TFontSpec
  - _imp__AddEntryL__10CFontCacheP5CFontRC9TFontSpec
  - AddDirectoryL__13CPdrModelListRC7TDesC16
  - __imp_AddDirectoryL__13CPdrModelListRC7TDesC16
  - _imp__AddDirectoryL__13CPdrModelListRC7TDesC16
  - __eq__C9TFontSpecRC9TFontSpec

