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

- Game import slots mapped: 166
| Thunk | Slot | DLL | Ordinal | Original SDK symbol |
|---:|---:|---|---:|---|
| 0x1009eda0 | 0x101007bc | EUSER | 1505 | ?Terminate@RMessage@@QBEXH@Z |
| 0x1009edb0 | 0x10100784 | EUSER | 1359 | ?Set@TLongDateFormatSpec@@QAEXXZ |
| 0x1009edc0 | 0x1010077c | EUSER | 1283 | ?Rename@RThread@@QBEHABVTDesC16@@@Z |
| 0x1009edd0 | 0x10100770 | EUSER | 1262 | ?RectangleListW@TRegion@@IAEPAVTRect@@XZ |
| 0x1009ede0 | 0x101007c0 | EUSER | 1506 | ?Terminate@RProcess@@QAEXH@Z |
| 0x1009edf0 | 0x101007c8 | EUSER | 1514 | ?TokenLength@TLex16@@QBEHVTLexMark16@@@Z |
| 0x1009ee00 | 0x101006f4 | EUSER | 630 | ?Delete@CArrayFixBase@@QAEXHH@Z |
| 0x1009ee10 | 0x10100680 | EUSER | 35 | ??0MBusDev@@QAE@XZ |
| 0x1009ee20 | 0x1010067c | EUSER | 21 | ??0CIdle@@IAE@H@Z |
| 0x1009ee30 | 0x101007b8 | EUSER | 1504 | ?Terminate@CSession@@QBEXH@Z |
| 0x1009ee40 | 0x101007c4 | EUSER | 1507 | ?Terminate@RThread@@QAEXH@Z |
| 0x1009ee50 | 0x101007f0 | EUSER | 1611 | ?WritePasswordData@TBusLocalDrive@@SAHAAVTDesC8@@@Z |
| 0x1009ee60 | 0x1010078c | EUSER | 1367 | ?Set@TRealX@@QAEHI@Z |
| 0x1009ee70 | 0x101006c8 | EUSER | 411 | ?Assign@TLex16@@QAEXABVTDesC16@@@Z |
| 0x1009ee80 | 0x10100788 | EUSER | 1366 | ?Set@TRealX@@QAEHH@Z |
| 0x1009ee90 | 0x101006c0 | EUSER | 274 | ??LTRealX@@QBE?AV0@ABV0@@Z |
| 0x1009eea0 | 0x101006c4 | EUSER | 289 | ??YTTime@@QAEAAV0@VTTimeIntervalDays@@@Z |
| 0x1009eeb0 | 0x10100740 | EUSER | 1016 | ?Logon@RProcess@@QBEXAAVTRequestStatus@@@Z |
| 0x1009eec0 | 0x10100730 | EUSER | 954 | ?IsNaN@TRealX@@QBEHXZ |
| 0x1009eed0 | 0x101006a8 | EUSER | 172 | ??1CBufSeg@@UAE@XZ |
| 0x1009eee0 | 0x10100754 | EUSER | 1113 | ?Next@TFindChunk@@QAEHAAV?$TBuf@$0BAA@@@@Z |
| 0x1009eef0 | 0x101007ec | EUSER | 1582 | ?Wait@RSemaphore@@QAEXXZ |
| 0x1009ef00 | 0x10100780 | EUSER | 1343 | ?ServerStarted@UserSvr@@SAXXZ |
| 0x1009ef10 | 0x10100720 | EUSER | 858 | ?GetVolumeInformationU@@YAP6GHPBGPAGKPAK221K@ZXZ |
| 0x1009ef20 | 0x101006e4 | EUSER | 569 | ?CopyLC@TDes8@@QAEXABVTDesC8@@@Z |
| 0x1009ef30 | 0x1010075c | EUSER | 1148 | ?Offset@TLex8@@QBEHXZ |
| 0x1009ef40 | 0x10100760 | EUSER | 1164 | ?OpenGlobal@RSemaphore@@QAEHABVTDesC16@@W4TOwnerType@@@Z |
| 0x1009ef50 | 0x10100700 | EUSER | 738 | ?FRand@Math@@SANAAVTInt64@@@Z |
| 0x1009ef60 | 0x10100750 | EUSER | 1111 | ?NewMaxLC@HBufC8@@SAPAV1@H@Z |
| 0x1009ef70 | 0x1010074c | EUSER | 1107 | ?NewMax@HBufC8@@SAPAV1@H@Z |
| 0x1009ef80 | 0x10100710 | EUSER | 825 | ?GetCategory@TUnicode@@QBE?AW4TCategory@TChar@@PBUTUnicodeDataSet@@@Z |
| 0x1009ef90 | 0x10100764 | EUSER | 1212 | ?Protected@RThread@@QBEHXZ |
| 0x1009efa0 | 0x10100744 | EUSER | 1078 | ?Neg@TInt64A@@QAEXXZ |
| 0x1009efb0 | 0x10100704 | EUSER | 746 | ?Fill@TDes16@@QAEXVTChar@@@Z |
| 0x1009efc0 | 0x10100758 | EUSER | 1122 | ?Next@TFindThread@@QAEHAAV?$TBuf@$0BAA@@@@Z |
| 0x1009efd0 | 0x101006a4 | EUSER | 152 | ??0TTime@@QAE@ABVTDateTime@@@Z |
| 0x1009efe0 | 0x10100694 | EUSER | 89 | ??0THeapWalk@@QAE@ABVRHeap@@@Z |
| 0x1009eff0 | 0x10100698 | EUSER | 90 | ??0TInt64@@QAE@H@Z |
| 0x1009f000 | 0x1010079c | EUSER | 1386 | ?SetHour@TDateTime@@QAEHH@Z |
| 0x1009f010 | 0x101006d8 | EUSER | 501 | ?Collate@TDes16@@QAEXXZ |
| 0x1009f020 | 0x10100674 | EUSER | 3 | ??0CActiveScheduler@@QAE@XZ |
| 0x1009f030 | 0x101006f0 | EUSER | 627 | ?Decompose@TChar@@QBEHAAVTPtrC16@@@Z |
| 0x1009f040 | 0x10100790 | EUSER | 1370 | ?Set@TShortDateFormatSpec@@QAEXXZ |
| 0x1009f050 | 0x10100714 | EUSER | 828 | ?GetCurrentDirectoryU@@YAP6GKKPAG@ZXZ |
| 0x1009f060 | 0x1010070c | EUSER | 824 | ?GetCategory@TChar@@QBE?AW4TCategory@1@XZ |
| 0x1009f070 | 0x101007b0 | EUSER | 1432 | ?SetTrapHandler@User@@SAPAVTTrapHandler@@PAV2@@Z |
| 0x1009f080 | 0x101007a8 | EUSER | 1422 | ?SetReserveFlatL@CArrayFixBase@@IAEXH@Z |
| 0x1009f090 | 0x10100778 | EUSER | 1282 | ?Rename@RProcess@@QAEHABVTDesC16@@@Z |
| 0x1009f0a0 | 0x101006bc | EUSER | 251 | ??GTTime@@QBE?AV0@VTTimeIntervalMinutes@@@Z |
| 0x1009f0b0 | 0x101006f8 | EUSER | 632 | ?Delete@CArrayPakBase@@QAEXHH@Z |
| 0x1009f0c0 | 0x1010071c | EUSER | 856 | ?GetUpperCase@TChar@@QBEIXZ |
| 0x1009f0d0 | 0x1010066c | EUSER | 1 | __ftol |
| 0x1009f0e0 | 0x10100670 | EUSER | 2 | ??0CActive@@IAE@H@Z |
| 0x1009f0f0 | 0x101007a4 | EUSER | 1407 | ?SetOffset@TDblQueBase@@QAEXH@Z |
| 0x1009f100 | 0x101006d0 | EUSER | 467 | ?Cancel@RServer@@QAEXXZ |
| 0x1009f110 | 0x101006ac | EUSER | 207 | ??8TPoint@@QBEHABV0@@Z |
| 0x1009f120 | 0x1010069c | EUSER | 91 | ??0TInt64@@QAE@N@Z |
| 0x1009f130 | 0x101006a0 | EUSER | 99 | ??0TKeyArrayPak@@QAE@HW4TKeyCmpNumeric@@@Z |
| 0x1009f140 | 0x10100734 | EUSER | 956 | ?IsPresent@TUidType@@QBEHVTUid@@@Z |
| 0x1009f150 | 0x101007d8 | EUSER | 1529 | ?Type@RHeap@@QBE?AW4THeapType@RHeapBase@@XZ |
| 0x1009f160 | 0x101007f4 | EUSER | 1614 | ?WsSwitchOnScreen@UserSvr@@SAXXZ |
| 0x1009f170 | 0x101007e4 | EUSER | 1571 | ?Val@TLex8@@QAEHAAMVTChar@@@Z |
| 0x1009f180 | 0x101007d4 | EUSER | 1527 | ?TrimRight@TDes16@@QAEXXZ |
| 0x1009f190 | 0x101007b4 | EUSER | 1455 | ?Size@CBitMapAllocator@@QAEHXZ |
| 0x1009f1a0 | 0x10100684 | EUSER | 41 | ??0RHeap@@IAE@H@Z |
| 0x1009f1b0 | 0x101007e0 | EUSER | 1569 | ?Val@TLex8@@QAEHAAKW4TRadix@@I@Z |
| 0x1009f1c0 | 0x10100724 | EUSER | 869 | ?HandleInfo@RHandleBase@@QAEXPAVTHandleInfo@@@Z |
| 0x1009f1d0 | 0x10100708 | EUSER | 809 | ?Free@User@@SAXPAX@Z |
| 0x1009f1e0 | 0x101007ac | EUSER | 1431 | ?SetToLast@TDblQueIterBase@@QAEXXZ |
| 0x1009f1f0 | 0x10100690 | EUSER | 85 | ??0TDeltaQueBase@@IAE@XZ |
| 0x1009f200 | 0x10100748 | EUSER | 1086 | ?New@HBufC8@@SAPAV1@H@Z |
| 0x1009f210 | 0x101006e8 | EUSER | 621 | ?DaysFrom@TTime@@QBE?AVTTimeIntervalDays@@V1@@Z |
| 0x1009f220 | 0x101006b8 | EUSER | 248 | ??GTTime@@QBE?AV0@VTTimeIntervalHours@@@Z |
| 0x1009f230 | 0x101006e0 | EUSER | 531 | ?Compress@CArrayVarBase@@QAEXXZ |
| 0x1009f240 | 0x101007e8 | EUSER | 1575 | ?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z |
| 0x1009f250 | 0x101007dc | EUSER | 1557 | ?Val@TLex16@@QAEHAANVTChar@@@Z |
| 0x1009f260 | 0x10100798 | EUSER | 1379 | ?SetEnabled@Password@@SAHABV?$TBuf@$0BA@@@H@Z |
| 0x1009f270 | 0x101007cc | EUSER | 1515 | ?TokenLength@TLex8@@QBEHVTLexMark8@@@Z |
| 0x1009f280 | 0x10100794 | EUSER | 1373 | ?SetActive@CActive@@IAEXXZ |
| 0x1009f290 | 0x101006dc | EUSER | 530 | ?Compress@CArrayPakBase@@QAEXXZ |
| 0x1009f2a0 | 0x101006fc | EUSER | 711 | ?EmulatorDataPath@@YA?AVTPtrC16@@XZ |
| 0x1009f2b0 | 0x101006ec | EUSER | 625 | ?DebugThreadPanic@@YAXKABVTDesC16@@0H@Z |
| 0x1009f2c0 | 0x101006b0 | EUSER | 211 | ??8TUidType@@QBEHABV0@@Z |
| 0x1009f2d0 | 0x1010072c | EUSER | 933 | ?IsContainedBy@TRegion@@QBEHABVTRect@@@Z |
| 0x1009f2e0 | 0x10100718 | EUSER | 855 | ?GetTitleCase@TChar@@QBEIXZ |
| 0x1009f2f0 | 0x1010076c | EUSER | 1247 | ?ReadL@CSession@@QBEXPBXAAVTDes16@@@Z |
| 0x1009f300 | 0x101007d0 | EUSER | 1520 | ?TrapHandler@User@@SAPAVTTrapHandler@@XZ |
| 0x1009f310 | 0x1010068c | EUSER | 77 | ??0TDayName@@QAE@W4TDay@@@Z |
| 0x1009f320 | 0x10100768 | EUSER | 1246 | ?Read@TBusLocalDrive@@QAEHVTInt64@@HPBXHH@Z |
| 0x1009f330 | 0x1010073c | EUSER | 979 | ?LeaveIfError@User@@SAHH@Z |
| 0x1009f340 | 0x10100774 | EUSER | 1265 | ?RegisterClassU@@YAP6GGPBUtagWNDCLASSW@@@ZXZ |
| 0x1009f350 | 0x101007a0 | EUSER | 1395 | ?SetLength@TDes8@@QAEXH@Z |
| 0x1009f360 | 0x10100678 | EUSER | 13 | ??0CBufFlat@@IAE@H@Z |
| 0x1009f370 | 0x10100738 | EUSER | 962 | ?IsUpper@TChar@@QBEHXZ |
| 0x1009f380 | 0x101007f8 | EUSER | 1616 | ?Zero@TDes16@@QAEXXZ |
| 0x1009f390 | 0x10100688 | EUSER | 45 | ??0RPointerArrayBase@@IAE@XZ |
| 0x1009f3a0 | 0x10100728 | EUSER | 875 | ?HeapSortSigned@RPointerArrayBase@@IAEXXZ |
| 0x1009f3b0 | 0x101006d4 | EUSER | 476 | ?ChangeLocale@UserSvr@@SAHVRLibrary@@@Z |
| 0x1009f3c0 | 0x101006cc | EUSER | 418 | ?At@CObjectCon@@QBEPAVCObject@@H@Z |
| 0x1009f3d0 | 0x101006b4 | EUSER | 245 | ??GTSize@@QBE?AV0@ABVTPoint@@@Z |
| 0x1009f3e0 | 0x101007fc | EUSER | 1636 | ?__DbgTestInvariant@TPtr8@@QBEXXZ |
| 0x1009f440 | 0x10100410 | CONE | 167 | ?PrepareToExit@CCoeAppUiBase@@UAEXXZ |
| 0x1009f450 | 0x101003b8 | CONE | 12 | ??8TCoeHelpContext@@QBEHABV0@@Z |
| 0x1009f460 | 0x101003f4 | CONE | 101 | ?HandleStackChanged@CCoeAppUi@@QAEXXZ |
| 0x1009f470 | 0x101003d8 | CONE | 82 | ?Format128@CCoeEnv@@QAAXAAVTDes16@@HZZ |
| 0x1009f480 | 0x101003e8 | CONE | 90 | ?HandleComponentControlsResourceChange@CCoeControl@@IAEXH@Z |
| 0x1009f490 | 0x10100420 | CONE | 187 | ?Reserved_1@CCoeAppUiBase@@EAEXXZ |
| 0x1009f4a0 | 0x101003f0 | CONE | 96 | ?SupportsWesternNumericIntegerNegative@TCoeInputCapabilities@@QBEHXZ |
| 0x1009f4b0 | 0x1010044c | CONE | 292 | ?MCoeViewActivationObserver_Reserved_2@MCoeViewActivationObserver@@EAEXXZ |
| 0x1009f4c0 | 0x10100450 | CONE | 293 | ?MCoeViewDeactivationObserver_Reserved_1@MCoeViewDeactivationObserver@@EAEXXZ |
| 0x1009f4d0 | 0x10100444 | CONE | 255 | ?DisplayError@CCoeScheduler@@UBEXH@Z |
| 0x1009f4e0 | 0x10100448 | CONE | 256 | ?FepAwareTextEditor@TCoeInputCapabilities@@QBEPAVMCoeFepAwareTextEditor@@XZ |
| 0x1009f4f0 | 0x101003c8 | CONE | 40 | ?CloseWindow@CCoeControl@@IAEXXZ |
| 0x1009f500 | 0x1010045c | CONE | 214 | ?SetExtent@CCoeControl@@QAEXABVTPoint@@ABVTSize@@@Z |
| 0x1009f510 | 0x1010040c | CONE | 160 | ?Position@CCoeControl@@QBE?AVTPoint@@XZ |
| 0x1009f520 | 0x10100440 | CONE | 236 | ?Static@CCoeEnv@@SAPAV1@XZ |
| 0x1009f530 | 0x1010043c | CONE | 232 | ?SetUse@TCoeColorUse@@QAEXH@Z |
| 0x1009f540 | 0x10100438 | CONE | 226 | ?SetPosition@CCoeControl@@QAEXABVTPoint@@@Z |
| 0x1009f550 | 0x10100400 | CONE | 143 | ?MCoeFocusObserver_Reserved_2@MCoeFocusObserver@@EAEXXZ |
| 0x1009f560 | 0x101003cc | CONE | 55 | ?CreateWindowL@CCoeControl@@IAEXPBV1@@Z |
| 0x1009f570 | 0x101003f8 | CONE | 138 | ?IsVisible@CCoeControl@@QBEHXZ |
| 0x1009f580 | 0x10100428 | CONE | 200 | ?SetAndDrawFocus@CCoeAppUi@@EAEXH@Z |
| 0x1009f590 | 0x10100424 | CONE | 197 | ?RunL@CCoeEnv@@UAEXXZ |
| 0x1009f5a0 | 0x101003c0 | CONE | 29 | ?AllocReadResourceAsDes16LC@CCoeEnv@@QBEPAVHBufC16@@H@Z |
| 0x1009f5b0 | 0x101003b4 | CONE | 3 | ??0CCoeControl@@QAE@XZ |
| 0x1009f5c0 | 0x10100408 | CONE | 153 | ?NameOfInstalledFepL@CCoeEnv@@QAEPAVHBufC16@@XZ |
| 0x1009f5d0 | 0x1010041c | CONE | 185 | ?ReportEventL@CCoeControl@@IAEXW4TCoeEvent@MCoeControlObserver@@@Z |
| 0x1009f5e0 | 0x1010042c | CONE | 208 | ?SetContainerWindowL@CCoeControl@@QAEXAAVRBackedUpWindow@@@Z |
| 0x1009f5f0 | 0x101003ec | CONE | 95 | ?HandleKeyEventL@CCoeAppUiSimple@@EAEXABUTKeyEvent@@W4TEventCode@@@Z |
| 0x1009f600 | 0x101003fc | CONE | 139 | ?IsWservEventPending@CCoeEnv@@QBEHXZ |
| 0x1009f610 | 0x101003e4 | CONE | 87 | ?GetHelpContext@CCoeControl@@UBEXAAVTCoeHelpContext@@@Z |
| 0x1009f620 | 0x101003d0 | CONE | 72 | ?ExecuteFepSettingsDialogL@CCoeEnv@@QAEXABVTDesC16@@@Z |
| 0x1009f630 | 0x101003d4 | CONE | 74 | ?SupportsWesternNumericReal@TCoeInputCapabilities@@QBEHXZ |
| 0x1009f640 | 0x101003e0 | CONE | 84 | ?GetActiveViewId@CCoeAppUi@@QBEHAAVTVwsViewId@@@Z |
| 0x1009f650 | 0x10100430 | CONE | 221 | ?SetNeighbor@CCoeControl@@UAEXPAV1@@Z |
| 0x1009f660 | 0x10100404 | CONE | 147 | ?SupportsNavigation@TCoeInputCapabilities@@QBEHXZ |
| 0x1009f670 | 0x101003c4 | CONE | 33 | ?BackedUpWindow@CCoeControl@@IBEAAVRBackedUpWindow@@XZ |
| 0x1009f680 | 0x101003bc | CONE | 28 | ?AllocReadResourceAsDes16L@CCoeEnv@@QBEPAVHBufC16@@H@Z |
| 0x1009f690 | 0x10100414 | CONE | 173 | ?Rect@CCoeControl@@QBE?AVTRect@@XZ |
| 0x1009f6a0 | 0x10100418 | CONE | 177 | ?RemoveFepObserver@CCoeEnv@@QAEXAAVMCoeFepObserver@@@Z |
| 0x1009f6b0 | 0x10100458 | CONE | 314 | ?MopSupplyObject@CCoeControl@@MAE?AVPtr@TTypeUid@@V3@@Z |
| 0x1009f6c0 | 0x10100454 | CONE | 312 | ?MopNext@CCoeControl@@EAEPAVMObjectProvider@@XZ |
| 0x1009f6d0 | 0x101003dc | CONE | 83 | ?Format256@CCoeEnv@@QAAXAAVTDes16@@HZZ |
| 0x1009f6e0 | 0x10100434 | CONE | 223 | ?SetObserver@CCoeControl@@QAEXPAVMCoeControlObserver@@@Z |
| 0x1009fda0 | 0x10100464 | EFSRV | 18 | ??ACDir@@QBEABVTEntry@@H@Z |
| 0x1009fdb0 | 0x1010048c | EFSRV | 146 | ?PathPresent@TParseBase@@QBEHXZ |
| 0x1009fdc0 | 0x10100480 | EFSRV | 106 | ?Modified@RFile@@QBEHAAVTTime@@@Z |
| 0x1009fdd0 | 0x10100468 | EFSRV | 21 | ?AbbreviatedPath@CFileBase@@QAE?AVTPtrC16@@XZ |
| 0x1009fde0 | 0x10100484 | EFSRV | 121 | ?NamePresent@TParseBase@@QBEHXZ |
| 0x1009fdf0 | 0x1010046c | EFSRV | 25 | ?Att@RFile@@QBEHAAI@Z |
| 0x1009fe00 | 0x10100498 | EFSRV | 185 | ?Set@TParse@@QAEHABVTDesC16@@PBV2@1@Z |
| 0x1009fe10 | 0x10100488 | EFSRV | 136 | ?NotifyFileManOperation@MFileManObserver@@UAE?AW4TControl@1@XZ |
| 0x1009fe20 | 0x101004a0 | EFSRV | 194 | ?SetModified@RFile@@QAEHABVTTime@@@Z |
| 0x1009fe30 | 0x10100490 | EFSRV | 162 | ?ReadFileSection@RFs@@QBEHABVTDesC16@@HAAVTDes8@@H@Z |
| 0x1009fe40 | 0x10100460 | EFSRV | 15 | ??1CFileBase@@MAE@XZ |
| 0x1009fe50 | 0x10100470 | EFSRV | 29 | ?BytesTransferredByCopyStep@CFileMan@@QAEHXZ |
| 0x1009fe60 | 0x1010047c | EFSRV | 86 | ?IsExtWild@TParseBase@@QBEHXZ |
| 0x1009fe70 | 0x101004a4 | EFSRV | 212 | ?Volume@RFs@@QBEHAAVTVolumeInfo@@H@Z |
| 0x1009fe80 | 0x1010049c | EFSRV | 193 | ?SetErrorCondition@RFs@@QAEHHH@Z |
| 0x1009fe90 | 0x101004a8 | EFSRV | 230 | ??0TParse@@QAE@XZ |
| 0x1009fea0 | 0x10100494 | EFSRV | 183 | ?Set@RFile@@QAEHABVTTime@@II@Z |
| 0x1009feb0 | 0x10100474 | EFSRV | 33 | ?ClearPassword@RFs@@QAEHHABV?$TBuf8@$0BA@@@@Z |
| 0x1009fec0 | 0x10100478 | EFSRV | 51 | ?DismountFileSystem@RFs@@QBEHABVTDesC16@@H@Z |
| 0x100a00a0 | 0x10100890 | GDI | 151 | ?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z |
| 0x100a00b0 | 0x10100888 | GDI | 101 | ?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z |
| 0x100a00c0 | 0x1010088c | GDI | 108 | ?NewL@CPalette@@SAPAV1@H@Z |

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

