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

### APPARC.LIB

- Import-object records: 110; imports used by game: 4
- Ordinal 3: ??0CApaFileRecognizerType@@IAE@XZ; NameType=[0]
- Ordinal 6: ??0TApaAppEntry@@QAE@XZ; NameType=[0]
- Ordinal 27: ?ConstructL@CApaProcess@@IAEXXZ; NameType=[0]
- Ordinal 71: ?Reserved_2@CApaDocument@@EAEXXZ; NameType=[0]

### AVKON.LIB

- Import-object records: 2274; imports used by game: 20
- Ordinal 63: ??0CAknIpFieldSettingPage@@QAE@PBVTDesC16@@HHHHAAVTInetAddr@@@Z; NameType=[0]
- Ordinal 662: ?ConstructL@CAknPopupSettingList@@QAEXXZ; NameType=[0]
- Ordinal 750: ?CreateNavigationLabelL@CAknNavigationControlContainer@@QAEPAVCAknNavigationDecorator@@ABVTDesC16@@@Z; NameType=[0]
- Ordinal 757: ?CreateTabGroupL@CAknNavigationControlContainer@@UAEPAVCAknNavigationDecorator@@XZ; NameType=[0]
- Ordinal 802: ?DiscardFont@CAknAnimatedGc@@MAEXXZ; NameType=[0]
- Ordinal 803: ?DismissL@CAknSettingPage@@IAEXH@Z; NameType=[0]
- Ordinal 805: ?DisplayMenuL@CAknDialog@@IAEXXZ; NameType=[0]
- Ordinal 808: ?DoMoveL@CAknGridView@@IAEXW4TCursorMovement@CListBoxView@@W4TSelectionMode@3@@Z; NameType=[0]
- Ordinal 874: ?DrawItem@CSingleHeadingStyleItemDrawer@@UBEXHVTPoint@@HHHH@Z; NameType=[0]
- Ordinal 1206: ?LayoutText@TAknLayoutText@@QAEXABVTRect@@ABVTAknTextLineLayout@@PBVCFont@@@Z; NameType=[0]
- Ordinal 1213: ?ListBox@CAknPopupList@@QAEPAVCEikListBox@@XZ; NameType=[0]
- Ordinal 1234: ?LogicalPosFromDataIndex@CAknGridView@@QBEXHAAH0@Z; NameType=[0]
- Ordinal 1254: ?MaxTextLength@CAknQueryDialog@@SAHPBVCAknQueryControl@@ABVTDes16@@H@Z; NameType=[0]
- Ordinal 1267: ?MdcaCount@CAknQueryValueNumberArray@@UBEHXZ; NameType=[0]
- Ordinal 1272: ?MdcaCount@CSelectionItemList@@UBEHXZ; NameType=[0]
- Ordinal 1348: ?MoveToNextOrPreviousItemL@CAknGrid@@IAEXVTPoint@@@Z; NameType=[0]
- Ordinal 1352: ?NeedToDismissQueryL@CAknMultiLineDataQueryDialog@@MAEHABUTKeyEvent@@@Z; NameType=[0]
- Ordinal 1529: ?PreLayoutDynInitL@CAknProgressDialog@@MAEXXZ; NameType=[0]
- Ordinal 2048: ?SizeChanged@CAknDoubleTimeStyleListBox@@UAEXXZ; NameType=[0]
- Ordinal 2105: ?StopSchedulerWaitWithBusyMessage@CAknEnv@@SAXAAVCActiveSchedulerWait@@@Z; NameType=[0]

### BITGDI.LIB

- Import-object records: 161; imports used by game: 5
- Ordinal 23: ?CancelSprite@CFbsScreenDevice@@UBEXXZ; NameType=[0]
- Ordinal 86: ?HorizontalTwipsToPixels@CFbsBitmapDevice@@UBEHH@Z; NameType=[0]
- Ordinal 112: ?Resize@CFbsBitmapDevice@@QAEHABVTSize@@@Z; NameType=[0]
- Ordinal 120: ?SetClippingRegion@CFbsBitGc@@QAEXPBVTRegion@@@Z; NameType=[0]
- Ordinal 123: ?SetOrigin@CFbsBitGc@@UAEXABVTPoint@@@Z; NameType=[0]

### CONE.LIB

- Import-object records: 317; imports used by game: 43
- Ordinal 3: ??0CCoeControl@@QAE@XZ; NameType=[0]
- Ordinal 12: ??8TCoeHelpContext@@QBEHABV0@@Z; NameType=[0]
- Ordinal 28: ?AllocReadResourceAsDes16L@CCoeEnv@@QBEPAVHBufC16@@H@Z; NameType=[0]
- Ordinal 29: ?AllocReadResourceAsDes16LC@CCoeEnv@@QBEPAVHBufC16@@H@Z; NameType=[0]
- Ordinal 33: ?BackedUpWindow@CCoeControl@@IBEAAVRBackedUpWindow@@XZ; NameType=[0]
- Ordinal 40: ?CloseWindow@CCoeControl@@IAEXXZ; NameType=[0]
- Ordinal 55: ?CreateWindowL@CCoeControl@@IAEXPBV1@@Z; NameType=[0]
- Ordinal 72: ?ExecuteFepSettingsDialogL@CCoeEnv@@QAEXABVTDesC16@@@Z; NameType=[0]
- Ordinal 74: ?SupportsWesternNumericReal@TCoeInputCapabilities@@QBEHXZ; NameType=[0]
- Ordinal 82: ?Format128@CCoeEnv@@QAAXAAVTDes16@@HZZ; NameType=[0]
- Ordinal 83: ?Format256@CCoeEnv@@QAAXAAVTDes16@@HZZ; NameType=[0]
- Ordinal 84: ?GetActiveViewId@CCoeAppUi@@QBEHAAVTVwsViewId@@@Z; NameType=[0]
- Ordinal 87: ?GetHelpContext@CCoeControl@@UBEXAAVTCoeHelpContext@@@Z; NameType=[0]
- Ordinal 90: ?HandleComponentControlsResourceChange@CCoeControl@@IAEXH@Z; NameType=[0]
- Ordinal 95: ?HandleKeyEventL@CCoeAppUiSimple@@EAEXABUTKeyEvent@@W4TEventCode@@@Z; NameType=[0]
- Ordinal 96: ?SupportsWesternNumericIntegerNegative@TCoeInputCapabilities@@QBEHXZ; NameType=[0]
- Ordinal 101: ?HandleStackChanged@CCoeAppUi@@QAEXXZ; NameType=[0]
- Ordinal 138: ?IsVisible@CCoeControl@@QBEHXZ; NameType=[0]
- Ordinal 139: ?IsWservEventPending@CCoeEnv@@QBEHXZ; NameType=[0]
- Ordinal 143: ?MCoeFocusObserver_Reserved_2@MCoeFocusObserver@@EAEXXZ; NameType=[0]
- Ordinal 147: ?SupportsNavigation@TCoeInputCapabilities@@QBEHXZ; NameType=[0]
- Ordinal 153: ?NameOfInstalledFepL@CCoeEnv@@QAEPAVHBufC16@@XZ; NameType=[0]
- Ordinal 160: ?Position@CCoeControl@@QBE?AVTPoint@@XZ; NameType=[0]
- Ordinal 167: ?PrepareToExit@CCoeAppUiBase@@UAEXXZ; NameType=[0]
- Ordinal 173: ?Rect@CCoeControl@@QBE?AVTRect@@XZ; NameType=[0]
- Ordinal 177: ?RemoveFepObserver@CCoeEnv@@QAEXAAVMCoeFepObserver@@@Z; NameType=[0]
- Ordinal 185: ?ReportEventL@CCoeControl@@IAEXW4TCoeEvent@MCoeControlObserver@@@Z; NameType=[0]
- Ordinal 187: ?Reserved_1@CCoeAppUiBase@@EAEXXZ; NameType=[0]
- Ordinal 197: ?RunL@CCoeEnv@@UAEXXZ; NameType=[0]
- Ordinal 200: ?SetAndDrawFocus@CCoeAppUi@@EAEXH@Z; NameType=[0]
- Ordinal 208: ?SetContainerWindowL@CCoeControl@@QAEXAAVRBackedUpWindow@@@Z; NameType=[0]
- Ordinal 214: ?SetExtent@CCoeControl@@QAEXABVTPoint@@ABVTSize@@@Z; NameType=[0]
- Ordinal 221: ?SetNeighbor@CCoeControl@@UAEXPAV1@@Z; NameType=[0]
- Ordinal 223: ?SetObserver@CCoeControl@@QAEXPAVMCoeControlObserver@@@Z; NameType=[0]
- Ordinal 226: ?SetPosition@CCoeControl@@QAEXABVTPoint@@@Z; NameType=[0]
- Ordinal 232: ?SetUse@TCoeColorUse@@QAEXH@Z; NameType=[0]
- Ordinal 236: ?Static@CCoeEnv@@SAPAV1@XZ; NameType=[0]
- Ordinal 255: ?DisplayError@CCoeScheduler@@UBEXH@Z; NameType=[0]
- Ordinal 256: ?FepAwareTextEditor@TCoeInputCapabilities@@QBEPAVMCoeFepAwareTextEditor@@XZ; NameType=[0]
- Ordinal 292: ?MCoeViewActivationObserver_Reserved_2@MCoeViewActivationObserver@@EAEXXZ; NameType=[0]
- Ordinal 293: ?MCoeViewDeactivationObserver_Reserved_1@MCoeViewDeactivationObserver@@EAEXXZ; NameType=[0]
- Ordinal 312: ?MopNext@CCoeControl@@EAEPAVMObjectProvider@@XZ; NameType=[0]
- Ordinal 314: ?MopSupplyObject@CCoeControl@@MAE?AVPtr@TTypeUid@@V3@@Z; NameType=[0]

### EFSRV.LIB

- Import-object records: 231; imports used by game: 19
- Ordinal 15: ??1CFileBase@@MAE@XZ; NameType=[0]
- Ordinal 18: ??ACDir@@QBEABVTEntry@@H@Z; NameType=[0]
- Ordinal 21: ?AbbreviatedPath@CFileBase@@QAE?AVTPtrC16@@XZ; NameType=[0]
- Ordinal 25: ?Att@RFile@@QBEHAAI@Z; NameType=[0]
- Ordinal 29: ?BytesTransferredByCopyStep@CFileMan@@QAEHXZ; NameType=[0]
- Ordinal 33: ?ClearPassword@RFs@@QAEHHABV?$TBuf8@$0BA@@@@Z; NameType=[0]
- Ordinal 51: ?DismountFileSystem@RFs@@QBEHABVTDesC16@@H@Z; NameType=[0]
- Ordinal 86: ?IsExtWild@TParseBase@@QBEHXZ; NameType=[0]
- Ordinal 106: ?Modified@RFile@@QBEHAAVTTime@@@Z; NameType=[0]
- Ordinal 121: ?NamePresent@TParseBase@@QBEHXZ; NameType=[0]
- Ordinal 136: ?NotifyFileManOperation@MFileManObserver@@UAE?AW4TControl@1@XZ; NameType=[0]
- Ordinal 146: ?PathPresent@TParseBase@@QBEHXZ; NameType=[0]
- Ordinal 162: ?ReadFileSection@RFs@@QBEHABVTDesC16@@HAAVTDes8@@H@Z; NameType=[0]
- Ordinal 183: ?Set@RFile@@QAEHABVTTime@@II@Z; NameType=[0]
- Ordinal 185: ?Set@TParse@@QAEHABVTDesC16@@PBV2@1@Z; NameType=[0]
- Ordinal 193: ?SetErrorCondition@RFs@@QAEHHH@Z; NameType=[0]
- Ordinal 194: ?SetModified@RFile@@QAEHABVTTime@@@Z; NameType=[0]
- Ordinal 212: ?Volume@RFs@@QBEHAAVTVolumeInfo@@H@Z; NameType=[0]
- Ordinal 230: ??0TParse@@QAE@XZ; NameType=[0]

### EIKCORE.LIB

- Import-object records: 290; imports used by game: 60
- Ordinal 17: ??1CEikonEnv@@UAE@XZ; NameType=[0]
- Ordinal 20: ?AddAlertDialogLikeControlToStackL@CEikonEnv@@QAEXPAVCCoeControl@@@Z; NameType=[0]
- Ordinal 30: ?AddWindowShadow@CEikonEnv@@SAXPAVCCoeControl@@@Z; NameType=[0]
- Ordinal 31: ?AlertWin@CEikonEnv@@QAEXABVTDesC16@@0@Z; NameType=[0]
- Ordinal 40: ?Application@CEikAppUi@@QBEPAVCEikApplication@@XZ; NameType=[0]
- Ordinal 48: ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@@Z; NameType=[0]
- Ordinal 49: ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTGulAlignment@@@Z; NameType=[0]
- Ordinal 51: ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTTimeIntervalMicroSeconds32@@@Z; NameType=[0]
- Ordinal 52: ?BusyMsgL@CEikonEnv@@QAEXH@Z; NameType=[0]
- Ordinal 61: ?CommandTailEnd@CEikProcess@@QBE?AVTPtrC16@@XZ; NameType=[0]
- Ordinal 64: ?ConstructL@CEikAppUi@@UAEXXZ; NameType=[0]
- Ordinal 65: ?ConstructL@CEikEmbeddableAppList@@QAEXXZ; NameType=[0]
- Ordinal 66: ?ConstructL@CEikMsgWin@@QAEXAAVRWindowGroup@@@Z; NameType=[0]
- Ordinal 67: ?ConstructL@CEikonEnv@@QAEXXZ; NameType=[0]
- Ordinal 68: ?ControlColor@CEikonEnv@@QBE?AVTRgb@@W4TLogicalColor@@ABVCCoeControl@@@Z; NameType=[0]
- Ordinal 71: ?CreateByTypeL@EikControlFactory@@SA?AUSEikControlInfo@@H@Z; NameType=[0]
- Ordinal 74: ?CreateCustomCommandControlL@MEikCommandObserver@@UAEPAVCCoeControl@@H@Z; NameType=[0]
- Ordinal 75: ?CreateDocumentL@CEikApplication@@MAEPAVCApaDocument@@PAVCApaProcess@@@Z; NameType=[0]
- Ordinal 76: ?CreateEmbeddedDocumentL@CEikEmbeddableAppList@@QAEPAVCEikDocument@@HPAVCApaProcess@@@Z; NameType=[0]
- Ordinal 80: ?CreateIconFromMaskedBitmapL@CEikonEnv@@SAPAVCGulIcon@@ABVCApaMaskedBitmap@@@Z; NameType=[0]
- Ordinal 81: ?CreateIconL@CEikonEnv@@QAEPAVCGulIcon@@ABVTDesC16@@HH@Z; NameType=[0]
- Ordinal 82: ?CreateScreenFontL@EikResourceUtils@@SAPAVCFbsFont@@HPAVCEikonEnv@@@Z; NameType=[0]
- Ordinal 84: ?DefaultDisplayMode@CEikonEnv@@QBE?AW4TDisplayMode@@XZ; NameType=[0]
- Ordinal 86: ?DestroyEnvironment@CEikonEnv@@MAEXXZ; NameType=[0]
- Ordinal 100: ?ExternalizeL@CEikDocument@@UBEXAAVRWriteStream@@@Z; NameType=[0]
- Ordinal 116: ?HandleModelChangeL@CEikAppUi@@UAEXXZ; NameType=[0]
- Ordinal 121: ?HandleWsEventL@CAknWsEventMonitor@@UAEXABVTWsEvent@@PAVCCoeControl@@@Z; NameType=[0]
- Ordinal 122: ?HandleWsEventL@CEikAppUi@@MAEXABVTWsEvent@@PAVCCoeControl@@@Z; NameType=[0]
- Ordinal 123: ?HasChanged@CEikDocument@@UBEHXZ; NameType=[0]
- Ordinal 124: ?HideCursor@CEikonEnv@@QAEXPBVCCoeControl@@@Z; NameType=[0]
- Ordinal 130: ?InfoMsgCancel@CEikonEnv@@QAEXXZ; NameType=[0]
- Ordinal 133: ?InfoMsgWithAlignment@CEikonEnv@@QAEXVTGulAlignment@@HQAPAC@Z; NameType=[0]
- Ordinal 134: ?InfoMsgWithAlignmentAndDuration@CEikonEnv@@QAAXVTGulAlignment@@HVTTimeIntervalMicroSeconds32@@ZZ; NameType=[0]
- Ordinal 142: ?InitSystemFontsL@CEikonEnv@@EAEXXZ; NameType=[0]
- Ordinal 143: ?InternalizeL@@YAXAAW4TEikPortFlag@@AAVRReadStream@@@Z; NameType=[0]
- Ordinal 144: ?IsBusy@CEikonEnv@@QBEHXZ; NameType=[0]
- Ordinal 146: ?IsForeground@CEikAppUi@@QBEHXZ; NameType=[0]
- Ordinal 147: ?IsSystem@CEikonEnv@@QBEHXZ; NameType=[0]
- Ordinal 149: ?LafEnv@CEikonEnv@@QBEAAVMLafEnv@@XZ; NameType=[0]
- Ordinal 150: ?LastUsedFileL@CEikProcess@@QBE?AV?$TBuf@$0BAA@@@W4TLastUsedFile@1@@Z; NameType=[0]
- Ordinal 151: ?LaunchPopupMenuL@CEikAppUi@@QAEXHABVTPoint@@W4TPopupTargetPosType@@PBVCEikHotKeyTable@@@Z; NameType=[0]
- Ordinal 155: ?LegendFont@CEikonEnv@@QBEPBVCFont@@XZ; NameType=[0]
- Ordinal 157: ?MEikPictureFactory_Reserved_2@MEikPictureFactory@@EAEXXZ; NameType=[0]
- Ordinal 161: ?MdcaPoint@CEikEmbeddableAppList@@EBE?AVTPtrC16@@H@Z; NameType=[0]
- Ordinal 179: ?PictureFactory@CEikonEnv@@QBEPAVMPictureFactory@@XZ; NameType=[0]
- Ordinal 198: ?RemoveObserver@CAknWsEventMonitor@@QAEXPBVMAknWsEventObserver@@@Z; NameType=[0]
- Ordinal 200: ?ReportResourceChangedToAppL@CEikAppUi@@QAEXH@Z; NameType=[0]
- Ordinal 204: ?Reserved_1@CEikDocument@@EAEXXZ; NameType=[0]
- Ordinal 206: ?Reserved_1_MenuObserver@MEikAutoMenuObserver@@EAEXXZ; NameType=[0]
- Ordinal 213: ?ResourceFileName@CEikApplication@@UBE?AV?$TBuf@$0BAA@@@XZ; NameType=[0]
- Ordinal 214: ?ResourceFileVersionNumber@CEikonEnv@@EBEHXZ; NameType=[0]
- Ordinal 219: ?RestoreMenuL@MEikMenuObserver@@UAEXPAVCCoeControl@@HW4TMenuType@1@@Z; NameType=[0]
- Ordinal 222: ?SaveAnyChangesL@CEikAppUi@@IAEXXZ; NameType=[0]
- Ordinal 224: ?SaveL@CEikDocument@@UAEXW4TSaveType@MSaveObserver@@@Z; NameType=[0]
- Ordinal 226: ?SaveToDirectFileStoreL@CEikProcess@@QAEXPAVCEikDocument@@PBV?$TBuf@$0BAA@@@@Z; NameType=[0]
- Ordinal 233: ?SetBusy@CEikonEnv@@QAEXH@Z; NameType=[0]
- Ordinal 243: ?SetEmphasis@MEikAutoMenuObserver@@UAEXPAVCCoeControl@@H@Z; NameType=[0]
- Ordinal 253: ?SetRespondsToSwitchFilesEvent@CEikonEnv@@QAEXH@Z; NameType=[0]
- Ordinal 264: ?StopDisplayingMenuBar@CEikAppUi@@UAEXXZ; NameType=[0]
- Ordinal 290: ?IsPartialForeground@CEikAppUi@@QBEHXZ; NameType=[0]

### ESOCK.LIB

- Import-object records: 240; imports used by game: 7
- Ordinal 45: ?Cancel@RMBufAsyncRequest@@QAEXXZ; NameType=[0]
- Ordinal 48: ?CancelAccept@RSocket@@QAEXXZ; NameType=[0]
- Ordinal 62: ?Close@RSocket@@QAEXXZ; NameType=[0]
- Ordinal 87: ?Free@RMBuf@@QAEXXZ; NameType=[0]
- Ordinal 129: ?Name@RSocket@@QAEHAAV?$TBuf@$0IA@@@@Z; NameType=[0]
- Ordinal 209: ?StopProtocol@RSocketServ@@QAEXIIIAAVTRequestStatus@@@Z; NameType=[0]
- Ordinal 217: ?Version@RSocketServ@@QBE?AVTVersion@@XZ; NameType=[0]

### ESTLIB.LIB

- Import-object records: 349; imports used by game: 29
- Ordinal 3: _malloc; NameType=[0]
- Ordinal 6: _free; NameType=[0]
- Ordinal 9: _strlen; NameType=[0]
- Ordinal 49: _fclose; NameType=[0]
- Ordinal 51: _feof; NameType=[0]
- Ordinal 56: _fgets; NameType=[0]
- Ordinal 58: _fopen; NameType=[0]
- Ordinal 59: _fprintf; NameType=[0]
- Ordinal 64: _fscanf; NameType=[0]
- Ordinal 65: _fseek; NameType=[0]
- Ordinal 82: _sprintf; NameType=[0]
- Ordinal 83: _sscanf; NameType=[0]
- Ordinal 128: _atoi; NameType=[0]
- Ordinal 157: _time; NameType=[0]
- Ordinal 171: _toupper; NameType=[0]
- Ordinal 173: _memchr; NameType=[0]
- Ordinal 174: _memcmp; NameType=[0]
- Ordinal 177: _strcasecmp; NameType=[0]
- Ordinal 178: _strcat; NameType=[0]
- Ordinal 180: _strcmp; NameType=[0]
- Ordinal 181: _strcpy; NameType=[0]
- Ordinal 187: _strncmp; NameType=[0]
- Ordinal 188: _strncpy; NameType=[0]
- Ordinal 193: _strtok; NameType=[0]
- Ordinal 291: _wait; NameType=[0]
- Ordinal 315: _wclosedir; NameType=[0]
- Ordinal 316: _wcscat; NameType=[0]
- Ordinal 317: _wcscmp; NameType=[0]
- Ordinal 342: _wcsdup; NameType=[0]

### ETEL.LIB

- Import-object records: 228; imports used by game: 16
- Ordinal 26: ??1CTelObject@@UAE@XZ; NameType=[0]
- Ordinal 27: ?AcquireOwnership@RCall@@QBEXAAVTRequestStatus@@@Z; NameType=[0]
- Ordinal 29: ?AnswerIncomingCall@RCall@@QAEXAAVTRequestStatus@@@Z; NameType=[0]
- Ordinal 55: ?Connect@RCall@@QAEXAAVTRequestStatus@@ABVTDesC8@@@Z; NameType=[0]
- Ordinal 56: ?Connect@RCall@@QBEHABVTDesC8@@@Z; NameType=[0]
- Ordinal 72: ?Destruct@RLine@@MAEXXZ; NameType=[0]
- Ordinal 74: ?Dial@RCall@@QAEXAAVTRequestStatus@@ABVTDesC16@@@Z; NameType=[0]
- Ordinal 77: ?Dial@RCall@@QBEHABVTDesC8@@ABVTDesC16@@@Z; NameType=[0]
- Ordinal 102: ?GetFaxSettings@RCall@@QBEHAAUTFaxSessionSettings@1@@Z; NameType=[0]
- Ordinal 125: ?IsDefault@TCallParams@RCall@@QAEHXZ; NameType=[0]
- Ordinal 127: ?LoadPhoneModule@RTelServer@@QBEHABVTDesC16@@@Z; NameType=[0]
- Ordinal 152: ?NotifyStatusChangeCancel@RLine@@QBEXXZ; NameType=[0]
- Ordinal 153: ?NullMethod1@CSubSessionExtBase@@IAEXXZ; NameType=[0]
- Ordinal 204: ?Set@RTelSubSessionBase@@IBEXHAAVTRequestStatus@@ABVTDesC16@@1W4TReqPriorityType@1@@Z; NameType=[0]
- Ordinal 210: ?SetFaxSettings@RCall@@QBEHABUTFaxSessionSettings@1@@Z; NameType=[0]
- Ordinal 211: ?SetOwnership@CCallBase@@UAEHK@Z; NameType=[0]

### EUSER.LIB

- Import-object records: 1684; imports used by game: 101
- Ordinal 1: __ftol; NameType=[0]
- Ordinal 2: ??0CActive@@IAE@H@Z; NameType=[0]
- Ordinal 3: ??0CActiveScheduler@@QAE@XZ; NameType=[0]
- Ordinal 13: ??0CBufFlat@@IAE@H@Z; NameType=[0]
- Ordinal 21: ??0CIdle@@IAE@H@Z; NameType=[0]
- Ordinal 35: ??0MBusDev@@QAE@XZ; NameType=[0]
- Ordinal 41: ??0RHeap@@IAE@H@Z; NameType=[0]
- Ordinal 45: ??0RPointerArrayBase@@IAE@XZ; NameType=[0]
- Ordinal 77: ??0TDayName@@QAE@W4TDay@@@Z; NameType=[0]
- Ordinal 85: ??0TDeltaQueBase@@IAE@XZ; NameType=[0]
- Ordinal 89: ??0THeapWalk@@QAE@ABVRHeap@@@Z; NameType=[0]
- Ordinal 90: ??0TInt64@@QAE@H@Z; NameType=[0]
- Ordinal 91: ??0TInt64@@QAE@N@Z; NameType=[0]
- Ordinal 99: ??0TKeyArrayPak@@QAE@HW4TKeyCmpNumeric@@@Z; NameType=[0]
- Ordinal 152: ??0TTime@@QAE@ABVTDateTime@@@Z; NameType=[0]
- Ordinal 172: ??1CBufSeg@@UAE@XZ; NameType=[0]
- Ordinal 207: ??8TPoint@@QBEHABV0@@Z; NameType=[0]
- Ordinal 211: ??8TUidType@@QBEHABV0@@Z; NameType=[0]
- Ordinal 245: ??GTSize@@QBE?AV0@ABVTPoint@@@Z; NameType=[0]
- Ordinal 248: ??GTTime@@QBE?AV0@VTTimeIntervalHours@@@Z; NameType=[0]
- Ordinal 251: ??GTTime@@QBE?AV0@VTTimeIntervalMinutes@@@Z; NameType=[0]
- Ordinal 274: ??LTRealX@@QBE?AV0@ABV0@@Z; NameType=[0]
- Ordinal 289: ??YTTime@@QAEAAV0@VTTimeIntervalDays@@@Z; NameType=[0]
- Ordinal 411: ?Assign@TLex16@@QAEXABVTDesC16@@@Z; NameType=[0]
- Ordinal 418: ?At@CObjectCon@@QBEPAVCObject@@H@Z; NameType=[0]
- Ordinal 467: ?Cancel@RServer@@QAEXXZ; NameType=[0]
- Ordinal 476: ?ChangeLocale@UserSvr@@SAHVRLibrary@@@Z; NameType=[0]
- Ordinal 501: ?Collate@TDes16@@QAEXXZ; NameType=[0]
- Ordinal 530: ?Compress@CArrayPakBase@@QAEXXZ; NameType=[0]
- Ordinal 531: ?Compress@CArrayVarBase@@QAEXXZ; NameType=[0]
- Ordinal 569: ?CopyLC@TDes8@@QAEXABVTDesC8@@@Z; NameType=[0]
- Ordinal 621: ?DaysFrom@TTime@@QBE?AVTTimeIntervalDays@@V1@@Z; NameType=[0]
- Ordinal 625: ?DebugThreadPanic@@YAXKABVTDesC16@@0H@Z; NameType=[0]
- Ordinal 627: ?Decompose@TChar@@QBEHAAVTPtrC16@@@Z; NameType=[0]
- Ordinal 630: ?Delete@CArrayFixBase@@QAEXHH@Z; NameType=[0]
- Ordinal 632: ?Delete@CArrayPakBase@@QAEXHH@Z; NameType=[0]
- Ordinal 711: ?EmulatorDataPath@@YA?AVTPtrC16@@XZ; NameType=[0]
- Ordinal 738: ?FRand@Math@@SANAAVTInt64@@@Z; NameType=[0]
- Ordinal 746: ?Fill@TDes16@@QAEXVTChar@@@Z; NameType=[0]
- Ordinal 809: ?Free@User@@SAXPAX@Z; NameType=[0]
- Ordinal 824: ?GetCategory@TChar@@QBE?AW4TCategory@1@XZ; NameType=[0]
- Ordinal 825: ?GetCategory@TUnicode@@QBE?AW4TCategory@TChar@@PBUTUnicodeDataSet@@@Z; NameType=[0]
- Ordinal 828: ?GetCurrentDirectoryU@@YAP6GKKPAG@ZXZ; NameType=[0]
- Ordinal 855: ?GetTitleCase@TChar@@QBEIXZ; NameType=[0]
- Ordinal 856: ?GetUpperCase@TChar@@QBEIXZ; NameType=[0]
- Ordinal 858: ?GetVolumeInformationU@@YAP6GHPBGPAGKPAK221K@ZXZ; NameType=[0]
- Ordinal 869: ?HandleInfo@RHandleBase@@QAEXPAVTHandleInfo@@@Z; NameType=[0]
- Ordinal 875: ?HeapSortSigned@RPointerArrayBase@@IAEXXZ; NameType=[0]
- Ordinal 933: ?IsContainedBy@TRegion@@QBEHABVTRect@@@Z; NameType=[0]
- Ordinal 954: ?IsNaN@TRealX@@QBEHXZ; NameType=[0]
- Ordinal 956: ?IsPresent@TUidType@@QBEHVTUid@@@Z; NameType=[0]
- Ordinal 962: ?IsUpper@TChar@@QBEHXZ; NameType=[0]
- Ordinal 979: ?LeaveIfError@User@@SAHH@Z; NameType=[0]
- Ordinal 1016: ?Logon@RProcess@@QBEXAAVTRequestStatus@@@Z; NameType=[0]
- Ordinal 1078: ?Neg@TInt64A@@QAEXXZ; NameType=[0]
- Ordinal 1086: ?New@HBufC8@@SAPAV1@H@Z; NameType=[0]
- Ordinal 1107: ?NewMax@HBufC8@@SAPAV1@H@Z; NameType=[0]
- Ordinal 1111: ?NewMaxLC@HBufC8@@SAPAV1@H@Z; NameType=[0]
- Ordinal 1113: ?Next@TFindChunk@@QAEHAAV?$TBuf@$0BAA@@@@Z; NameType=[0]
- Ordinal 1122: ?Next@TFindThread@@QAEHAAV?$TBuf@$0BAA@@@@Z; NameType=[0]
- Ordinal 1148: ?Offset@TLex8@@QBEHXZ; NameType=[0]
- Ordinal 1164: ?OpenGlobal@RSemaphore@@QAEHABVTDesC16@@W4TOwnerType@@@Z; NameType=[0]
- Ordinal 1212: ?Protected@RThread@@QBEHXZ; NameType=[0]
- Ordinal 1246: ?Read@TBusLocalDrive@@QAEHVTInt64@@HPBXHH@Z; NameType=[0]
- Ordinal 1247: ?ReadL@CSession@@QBEXPBXAAVTDes16@@@Z; NameType=[0]
- Ordinal 1262: ?RectangleListW@TRegion@@IAEPAVTRect@@XZ; NameType=[0]
- Ordinal 1265: ?RegisterClassU@@YAP6GGPBUtagWNDCLASSW@@@ZXZ; NameType=[0]
- Ordinal 1282: ?Rename@RProcess@@QAEHABVTDesC16@@@Z; NameType=[0]
- Ordinal 1283: ?Rename@RThread@@QBEHABVTDesC16@@@Z; NameType=[0]
- Ordinal 1343: ?ServerStarted@UserSvr@@SAXXZ; NameType=[0]
- Ordinal 1359: ?Set@TLongDateFormatSpec@@QAEXXZ; NameType=[0]
- Ordinal 1366: ?Set@TRealX@@QAEHH@Z; NameType=[0]
- Ordinal 1367: ?Set@TRealX@@QAEHI@Z; NameType=[0]
- Ordinal 1370: ?Set@TShortDateFormatSpec@@QAEXXZ; NameType=[0]
- Ordinal 1373: ?SetActive@CActive@@IAEXXZ; NameType=[0]
- Ordinal 1379: ?SetEnabled@Password@@SAHABV?$TBuf@$0BA@@@H@Z; NameType=[0]
- Ordinal 1386: ?SetHour@TDateTime@@QAEHH@Z; NameType=[0]
- Ordinal 1395: ?SetLength@TDes8@@QAEXH@Z; NameType=[0]
- Ordinal 1407: ?SetOffset@TDblQueBase@@QAEXH@Z; NameType=[0]
- Ordinal 1422: ?SetReserveFlatL@CArrayFixBase@@IAEXH@Z; NameType=[0]
- Ordinal 1431: ?SetToLast@TDblQueIterBase@@QAEXXZ; NameType=[0]
- Ordinal 1432: ?SetTrapHandler@User@@SAPAVTTrapHandler@@PAV2@@Z; NameType=[0]
- Ordinal 1455: ?Size@CBitMapAllocator@@QAEHXZ; NameType=[0]
- Ordinal 1504: ?Terminate@CSession@@QBEXH@Z; NameType=[0]
- Ordinal 1505: ?Terminate@RMessage@@QBEXH@Z; NameType=[0]
- Ordinal 1506: ?Terminate@RProcess@@QAEXH@Z; NameType=[0]
- Ordinal 1507: ?Terminate@RThread@@QAEXH@Z; NameType=[0]
- Ordinal 1514: ?TokenLength@TLex16@@QBEHVTLexMark16@@@Z; NameType=[0]
- Ordinal 1515: ?TokenLength@TLex8@@QBEHVTLexMark8@@@Z; NameType=[0]
- Ordinal 1520: ?TrapHandler@User@@SAPAVTTrapHandler@@XZ; NameType=[0]
- Ordinal 1527: ?TrimRight@TDes16@@QAEXXZ; NameType=[0]
- Ordinal 1529: ?Type@RHeap@@QBE?AW4THeapType@RHeapBase@@XZ; NameType=[0]
- Ordinal 1557: ?Val@TLex16@@QAEHAANVTChar@@@Z; NameType=[0]
- Ordinal 1569: ?Val@TLex8@@QAEHAAKW4TRadix@@I@Z; NameType=[0]
- Ordinal 1571: ?Val@TLex8@@QAEHAAMVTChar@@@Z; NameType=[0]
- Ordinal 1575: ?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z; NameType=[0]
- Ordinal 1582: ?Wait@RSemaphore@@QAEXXZ; NameType=[0]
- Ordinal 1611: ?WritePasswordData@TBusLocalDrive@@SAHAAVTDesC8@@@Z; NameType=[0]
- Ordinal 1614: ?WsSwitchOnScreen@UserSvr@@SAXXZ; NameType=[0]
- Ordinal 1616: ?Zero@TDes16@@QAEXXZ; NameType=[0]
- Ordinal 1636: ?__DbgTestInvariant@TPtr8@@QBEXXZ; NameType=[0]

### EZLIB.LIB

- Import-object records: 67; imports used by game: 1
- Ordinal 65: ?uncompress@@YAHPAEPAKPBEK@Z; NameType=[0]

### FBSCLI.LIB

- Import-object records: 155; imports used by game: 6
- Ordinal 16: ?Alloc@CChunkPile@@QAEPAEIPAVCBitwiseBitmap@@@Z; NameType=[0]
- Ordinal 17: ?AscentInPixels@CFbsFont@@UBEHXZ; NameType=[0]
- Ordinal 21: ?CallBack@RFbsSession@@QAEXXZ; NameType=[0]
- Ordinal 76: ?IncYPos@TBitmapUtil@@QAEXXZ; NameType=[0]
- Ordinal 110: ?Save@CFbsBitmapAsyncStreamer@@QAEHABVTDesC16@@PAVCFbsBitmap@@AAJAAH@Z; NameType=[0]
- Ordinal 135: ?UnlockHeap@CFbsBitmap@@IBEXH@Z; NameType=[0]

### GAMECOMMS.LIB

- Import-object records: 0; imports used by game: 27
- Ordinal 1: <no ordinal import record>; NameType=[]
- Ordinal 2: <no ordinal import record>; NameType=[]
- Ordinal 3: <no ordinal import record>; NameType=[]
- Ordinal 5: <no ordinal import record>; NameType=[]
- Ordinal 6: <no ordinal import record>; NameType=[]
- Ordinal 7: <no ordinal import record>; NameType=[]
- Ordinal 8: <no ordinal import record>; NameType=[]
- Ordinal 9: <no ordinal import record>; NameType=[]
- Ordinal 11: <no ordinal import record>; NameType=[]
- Ordinal 14: <no ordinal import record>; NameType=[]
- Ordinal 15: <no ordinal import record>; NameType=[]
- Ordinal 20: <no ordinal import record>; NameType=[]
- Ordinal 24: <no ordinal import record>; NameType=[]
- Ordinal 27: <no ordinal import record>; NameType=[]
- Ordinal 28: <no ordinal import record>; NameType=[]
- Ordinal 30: <no ordinal import record>; NameType=[]
- Ordinal 32: <no ordinal import record>; NameType=[]
- Ordinal 33: <no ordinal import record>; NameType=[]
- Ordinal 34: <no ordinal import record>; NameType=[]
- Ordinal 36: <no ordinal import record>; NameType=[]
- Ordinal 37: <no ordinal import record>; NameType=[]
- Ordinal 39: <no ordinal import record>; NameType=[]
- Ordinal 40: <no ordinal import record>; NameType=[]
- Ordinal 41: <no ordinal import record>; NameType=[]
- Ordinal 53: <no ordinal import record>; NameType=[]
- Ordinal 56: <no ordinal import record>; NameType=[]
- Ordinal 57: <no ordinal import record>; NameType=[]

### GDI.LIB

- Import-object records: 195; imports used by game: 3
- Ordinal 101: ?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z; NameType=[0]
- Ordinal 108: ?NewL@CPalette@@SAPAV1@H@Z; NameType=[0]
- Ordinal 151: ?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z; NameType=[0]

### HAL.LIB

- Import-object records: 3; imports used by game: 1
- Ordinal 1: ?Get@HAL@@SAHW4TAttribute@HALData@@AAH@Z; NameType=[0]

### MEDIACLIENTAUDIOSTREAM.LIB

- Import-object records: 1; imports used by game: 1
- Ordinal 1: ?NewL@CMdaAudioOutputStream@@SAPAV1@AAVMMdaAudioOutputStreamCallback@@PAVCMdaServer@@@Z; NameType=[0]

### MSGS.LIB

- Import-object records: 373; imports used by game: 3
- Ordinal 3: ??0CMsgActive@@IAE@H@Z; NameType=[0]
- Ordinal 143: ?HasDirectoryL@CMsvServerEntry@@QBEHXZ; NameType=[0]
- Ordinal 185: ?NewL@CMsvServerEntry@@SAPAV1@AAVCMsvServer@@J@Z; NameType=[0]

### SIMKIN.LIB

- Import-object records: 0; imports used by game: 64
- Ordinal 2: <no ordinal import record>; NameType=[]
- Ordinal 9: <no ordinal import record>; NameType=[]
- Ordinal 11: <no ordinal import record>; NameType=[]
- Ordinal 17: <no ordinal import record>; NameType=[]
- Ordinal 20: <no ordinal import record>; NameType=[]
- Ordinal 22: <no ordinal import record>; NameType=[]
- Ordinal 26: <no ordinal import record>; NameType=[]
- Ordinal 29: <no ordinal import record>; NameType=[]
- Ordinal 37: <no ordinal import record>; NameType=[]
- Ordinal 38: <no ordinal import record>; NameType=[]
- Ordinal 40: <no ordinal import record>; NameType=[]
- Ordinal 42: <no ordinal import record>; NameType=[]
- Ordinal 43: <no ordinal import record>; NameType=[]
- Ordinal 50: <no ordinal import record>; NameType=[]
- Ordinal 59: <no ordinal import record>; NameType=[]
- Ordinal 60: <no ordinal import record>; NameType=[]
- Ordinal 80: <no ordinal import record>; NameType=[]
- Ordinal 83: <no ordinal import record>; NameType=[]
- Ordinal 84: <no ordinal import record>; NameType=[]
- Ordinal 85: <no ordinal import record>; NameType=[]
- Ordinal 87: <no ordinal import record>; NameType=[]
- Ordinal 88: <no ordinal import record>; NameType=[]
- Ordinal 89: <no ordinal import record>; NameType=[]
- Ordinal 101: <no ordinal import record>; NameType=[]
- Ordinal 102: <no ordinal import record>; NameType=[]
- Ordinal 105: <no ordinal import record>; NameType=[]
- Ordinal 106: <no ordinal import record>; NameType=[]
- Ordinal 107: <no ordinal import record>; NameType=[]
- Ordinal 108: <no ordinal import record>; NameType=[]
- Ordinal 109: <no ordinal import record>; NameType=[]
- Ordinal 117: <no ordinal import record>; NameType=[]
- Ordinal 118: <no ordinal import record>; NameType=[]
- Ordinal 120: <no ordinal import record>; NameType=[]
- Ordinal 121: <no ordinal import record>; NameType=[]
- Ordinal 132: <no ordinal import record>; NameType=[]
- Ordinal 140: <no ordinal import record>; NameType=[]
- Ordinal 141: <no ordinal import record>; NameType=[]
- Ordinal 154: <no ordinal import record>; NameType=[]
- Ordinal 156: <no ordinal import record>; NameType=[]
- Ordinal 157: <no ordinal import record>; NameType=[]
- Ordinal 158: <no ordinal import record>; NameType=[]
- Ordinal 159: <no ordinal import record>; NameType=[]
- Ordinal 160: <no ordinal import record>; NameType=[]
- Ordinal 161: <no ordinal import record>; NameType=[]
- Ordinal 163: <no ordinal import record>; NameType=[]
- Ordinal 164: <no ordinal import record>; NameType=[]
- Ordinal 165: <no ordinal import record>; NameType=[]
- Ordinal 177: <no ordinal import record>; NameType=[]
- Ordinal 183: <no ordinal import record>; NameType=[]
- Ordinal 184: <no ordinal import record>; NameType=[]
- Ordinal 185: <no ordinal import record>; NameType=[]
- Ordinal 191: <no ordinal import record>; NameType=[]
- Ordinal 192: <no ordinal import record>; NameType=[]
- Ordinal 198: <no ordinal import record>; NameType=[]
- Ordinal 200: <no ordinal import record>; NameType=[]
- Ordinal 211: <no ordinal import record>; NameType=[]
- Ordinal 229: <no ordinal import record>; NameType=[]
- Ordinal 232: <no ordinal import record>; NameType=[]
- Ordinal 233: <no ordinal import record>; NameType=[]
- Ordinal 234: <no ordinal import record>; NameType=[]
- Ordinal 235: <no ordinal import record>; NameType=[]
- Ordinal 236: <no ordinal import record>; NameType=[]
- Ordinal 237: <no ordinal import record>; NameType=[]
- Ordinal 259: <no ordinal import record>; NameType=[]

### WS32.LIB

- Import-object records: 359; imports used by game: 4
- Ordinal 43: ?BitBlt@CWindowGc@@UAEXABVTPoint@@PBVCWsBitmap@@@Z; NameType=[0]
- Ordinal 74: ?Construct@CWsScreenDevice@@QAEHXZ; NameType=[0]
- Ordinal 109: ?DrawEllipse@CWindowGc@@UAEXABVTRect@@@Z; NameType=[0]
- Ordinal 268: ?SetWindowGroupOrdinalPosition@RWsSession@@QAEHHH@Z; NameType=[0]

## Exact symbol map for imports used by 6R51.APP

- Game import slots: 414
- DLLs referenced: 19
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
| 0x1009f3f0 | 0x10100800 | EZLIB | 65 | ?uncompress@@YAHPAEPAKPBEK@Z |
| 0x1009f400 | 0x10100348 | APPARC | 27 | ?ConstructL@CApaProcess@@IAEXXZ |
| 0x1009f410 | 0x1010034c | APPARC | 71 | ?Reserved_2@CApaDocument@@EAEXXZ |
| 0x1009f420 | 0x10100344 | APPARC | 6 | ??0TApaAppEntry@@QAE@XZ |
| 0x1009f430 | 0x10100340 | APPARC | 3 | ??0CApaFileRecognizerType@@IAE@XZ |
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
| 0x1009f6f0 | 0x101004e0 | EIKCORE | 67 | ?ConstructL@CEikonEnv@@QAEXXZ |
| 0x1009f700 | 0x10100580 | EIKCORE | 224 | ?SaveL@CEikDocument@@UAEXW4TSaveType@MSaveObserver@@@Z |
| 0x1009f710 | 0x10100588 | EIKCORE | 233 | ?SetBusy@CEikonEnv@@QAEXH@Z |
| 0x1009f720 | 0x10100538 | EIKCORE | 144 | ?IsBusy@CEikonEnv@@QBEHXZ |
| 0x1009f730 | 0x10100540 | EIKCORE | 147 | ?IsSystem@CEikonEnv@@QBEHXZ |
| 0x1009f740 | 0x101004ec | EIKCORE | 74 | ?CreateCustomCommandControlL@MEikCommandObserver@@UAEPAVCCoeControl@@H@Z |
| 0x1009f750 | 0x101004fc | EIKCORE | 81 | ?CreateIconL@CEikonEnv@@QAEPAVCGulIcon@@ABVTDesC16@@HH@Z |
| 0x1009f760 | 0x10100528 | EIKCORE | 133 | ?InfoMsgWithAlignment@CEikonEnv@@QAEXVTGulAlignment@@HQAPAC@Z |
| 0x1009f770 | 0x10100560 | EIKCORE | 198 | ?RemoveObserver@CAknWsEventMonitor@@QAEXPBVMAknWsEventObserver@@@Z |
| 0x1009f780 | 0x1010052c | EIKCORE | 134 | ?InfoMsgWithAlignmentAndDuration@CEikonEnv@@QAAXVTGulAlignment@@HVTTimeIntervalMicroSeconds32@@ZZ |
| 0x1009f790 | 0x10100520 | EIKCORE | 124 | ?HideCursor@CEikonEnv@@QAEXPBVCCoeControl@@@Z |
| 0x1009f7a0 | 0x101004c8 | EIKCORE | 51 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTTimeIntervalMicroSeconds32@@@Z |
| 0x1009f7b0 | 0x10100500 | EIKCORE | 82 | ?CreateScreenFontL@EikResourceUtils@@SAPAVCFbsFont@@HPAVCEikonEnv@@@Z |
| 0x1009f7c0 | 0x1010056c | EIKCORE | 206 | ?Reserved_1_MenuObserver@MEikAutoMenuObserver@@EAEXXZ |
| 0x1009f7d0 | 0x10100544 | EIKCORE | 149 | ?LafEnv@CEikonEnv@@QBEAAVMLafEnv@@XZ |
| 0x1009f7e0 | 0x10100548 | EIKCORE | 150 | ?LastUsedFileL@CEikProcess@@QBE?AV?$TBuf@$0BAA@@@W4TLastUsedFile@1@@Z |
| 0x1009f7f0 | 0x10100504 | EIKCORE | 84 | ?DefaultDisplayMode@CEikonEnv@@QBE?AW4TDisplayMode@@XZ |
| 0x1009f800 | 0x1010055c | EIKCORE | 179 | ?PictureFactory@CEikonEnv@@QBEPAVMPictureFactory@@XZ |
| 0x1009f810 | 0x101004c0 | EIKCORE | 48 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@@Z |
| 0x1009f820 | 0x101004f0 | EIKCORE | 75 | ?CreateDocumentL@CEikApplication@@MAEPAVCApaDocument@@PAVCApaProcess@@@Z |
| 0x1009f830 | 0x101004b8 | EIKCORE | 31 | ?AlertWin@CEikonEnv@@QAEXABVTDesC16@@0@Z |
| 0x1009f840 | 0x10100554 | EIKCORE | 157 | ?MEikPictureFactory_Reserved_2@MEikPictureFactory@@EAEXXZ |
| 0x1009f850 | 0x101004d8 | EIKCORE | 65 | ?ConstructL@CEikEmbeddableAppList@@QAEXXZ |
| 0x1009f860 | 0x101004d4 | EIKCORE | 64 | ?ConstructL@CEikAppUi@@UAEXXZ |
| 0x1009f870 | 0x10100514 | EIKCORE | 121 | ?HandleWsEventL@CAknWsEventMonitor@@UAEXABVTWsEvent@@PAVCCoeControl@@@Z |
| 0x1009f880 | 0x10100584 | EIKCORE | 226 | ?SaveToDirectFileStoreL@CEikProcess@@QAEXPAVCEikDocument@@PBV?$TBuf@$0BAA@@@@Z |
| 0x1009f890 | 0x101004bc | EIKCORE | 40 | ?Application@CEikAppUi@@QBEPAVCEikApplication@@XZ |
| 0x1009f8a0 | 0x101004f4 | EIKCORE | 76 | ?CreateEmbeddedDocumentL@CEikEmbeddableAppList@@QAEPAVCEikDocument@@HPAVCApaProcess@@@Z |
| 0x1009f8b0 | 0x10100594 | EIKCORE | 264 | ?StopDisplayingMenuBar@CEikAppUi@@UAEXXZ |
| 0x1009f8c0 | 0x10100598 | EIKCORE | 290 | ?IsPartialForeground@CEikAppUi@@QBEHXZ |
| 0x1009f8d0 | 0x101004f8 | EIKCORE | 80 | ?CreateIconFromMaskedBitmapL@CEikonEnv@@SAPAVCGulIcon@@ABVCApaMaskedBitmap@@@Z |
| 0x1009f8e0 | 0x1010058c | EIKCORE | 243 | ?SetEmphasis@MEikAutoMenuObserver@@UAEXPAVCCoeControl@@H@Z |
| 0x1009f8f0 | 0x10100570 | EIKCORE | 213 | ?ResourceFileName@CEikApplication@@UBE?AV?$TBuf@$0BAA@@@XZ |
| 0x1009f900 | 0x10100578 | EIKCORE | 219 | ?RestoreMenuL@MEikMenuObserver@@UAEXPAVCCoeControl@@HW4TMenuType@1@@Z |
| 0x1009f910 | 0x10100510 | EIKCORE | 116 | ?HandleModelChangeL@CEikAppUi@@UAEXXZ |
| 0x1009f920 | 0x101004cc | EIKCORE | 52 | ?BusyMsgL@CEikonEnv@@QAEXH@Z |
| 0x1009f930 | 0x101004dc | EIKCORE | 66 | ?ConstructL@CEikMsgWin@@QAEXAAVRWindowGroup@@@Z |
| 0x1009f940 | 0x10100524 | EIKCORE | 130 | ?InfoMsgCancel@CEikonEnv@@QAEXXZ |
| 0x1009f950 | 0x10100558 | EIKCORE | 161 | ?MdcaPoint@CEikEmbeddableAppList@@EBE?AVTPtrC16@@H@Z |
| 0x1009f960 | 0x10100564 | EIKCORE | 200 | ?ReportResourceChangedToAppL@CEikAppUi@@QAEXH@Z |
| 0x1009f970 | 0x10100550 | EIKCORE | 155 | ?LegendFont@CEikonEnv@@QBEPBVCFont@@XZ |
| 0x1009f980 | 0x101004e4 | EIKCORE | 68 | ?ControlColor@CEikonEnv@@QBE?AVTRgb@@W4TLogicalColor@@ABVCCoeControl@@@Z |
| 0x1009f990 | 0x1010050c | EIKCORE | 100 | ?ExternalizeL@CEikDocument@@UBEXAAVRWriteStream@@@Z |
| 0x1009f9a0 | 0x10100508 | EIKCORE | 86 | ?DestroyEnvironment@CEikonEnv@@MAEXXZ |
| 0x1009f9b0 | 0x10100530 | EIKCORE | 142 | ?InitSystemFontsL@CEikonEnv@@EAEXXZ |
| 0x1009f9c0 | 0x1010053c | EIKCORE | 146 | ?IsForeground@CEikAppUi@@QBEHXZ |
| 0x1009f9d0 | 0x1010051c | EIKCORE | 123 | ?HasChanged@CEikDocument@@UBEHXZ |
| 0x1009f9e0 | 0x10100568 | EIKCORE | 204 | ?Reserved_1@CEikDocument@@EAEXXZ |
| 0x1009f9f0 | 0x10100590 | EIKCORE | 253 | ?SetRespondsToSwitchFilesEvent@CEikonEnv@@QAEXH@Z |
| 0x1009fa00 | 0x1010057c | EIKCORE | 222 | ?SaveAnyChangesL@CEikAppUi@@IAEXXZ |
| 0x1009fa10 | 0x101004c4 | EIKCORE | 49 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTGulAlignment@@@Z |
| 0x1009fa20 | 0x10100518 | EIKCORE | 122 | ?HandleWsEventL@CEikAppUi@@MAEXABVTWsEvent@@PAVCCoeControl@@@Z |
| 0x1009fa30 | 0x101004b4 | EIKCORE | 30 | ?AddWindowShadow@CEikonEnv@@SAXPAVCCoeControl@@@Z |
| 0x1009fa40 | 0x10100534 | EIKCORE | 143 | ?InternalizeL@@YAXAAW4TEikPortFlag@@AAVRReadStream@@@Z |
| 0x1009fa50 | 0x101004e8 | EIKCORE | 71 | ?CreateByTypeL@EikControlFactory@@SA?AUSEikControlInfo@@H@Z |
| 0x1009fa60 | 0x101004b0 | EIKCORE | 20 | ?AddAlertDialogLikeControlToStackL@CEikonEnv@@QAEXPAVCCoeControl@@@Z |
| 0x1009fa70 | 0x1010054c | EIKCORE | 151 | ?LaunchPopupMenuL@CEikAppUi@@QAEXHABVTPoint@@W4TPopupTargetPosType@@PBVCEikHotKeyTable@@@Z |
| 0x1009fa80 | 0x10100574 | EIKCORE | 214 | ?ResourceFileVersionNumber@CEikonEnv@@EBEHXZ |
| 0x1009fa90 | 0x101004ac | EIKCORE | 17 | ??1CEikonEnv@@UAE@XZ |
| 0x1009faa0 | 0x101004d0 | EIKCORE | 61 | ?CommandTailEnd@CEikProcess@@QBE?AVTPtrC16@@XZ |
| 0x1009fab0 | 0x1010035c | AVKON | 757 | ?CreateTabGroupL@CAknNavigationControlContainer@@UAEPAVCAknNavigationDecorator@@XZ |
| 0x1009fac0 | 0x10100378 | AVKON | 1213 | ?ListBox@CAknPopupList@@QAEPAVCEikListBox@@XZ |
| 0x1009fad0 | 0x10100394 | AVKON | 1529 | ?PreLayoutDynInitL@CAknProgressDialog@@MAEXXZ |
| 0x1009fae0 | 0x10100398 | AVKON | 2048 | ?SizeChanged@CAknDoubleTimeStyleListBox@@UAEXXZ |
| 0x1009faf0 | 0x10100350 | AVKON | 63 | ??0CAknIpFieldSettingPage@@QAE@PBVTDesC16@@HHHHAAVTInetAddr@@@Z |
| 0x1009fb00 | 0x10100370 | AVKON | 874 | ?DrawItem@CSingleHeadingStyleItemDrawer@@UBEXHVTPoint@@HHHH@Z |
| 0x1009fb10 | 0x10100388 | AVKON | 1272 | ?MdcaCount@CSelectionItemList@@UBEHXZ |
| 0x1009fb20 | 0x1010036c | AVKON | 808 | ?DoMoveL@CAknGridView@@IAEXW4TCursorMovement@CListBoxView@@W4TSelectionMode@3@@Z |
| 0x1009fb30 | 0x10100380 | AVKON | 1254 | ?MaxTextLength@CAknQueryDialog@@SAHPBVCAknQueryControl@@ABVTDes16@@H@Z |
| 0x1009fb40 | 0x10100364 | AVKON | 803 | ?DismissL@CAknSettingPage@@IAEXH@Z |
| 0x1009fb50 | 0x10100358 | AVKON | 750 | ?CreateNavigationLabelL@CAknNavigationControlContainer@@QAEPAVCAknNavigationDecorator@@ABVTDesC16@@@Z |
| 0x1009fb60 | 0x10100390 | AVKON | 1352 | ?NeedToDismissQueryL@CAknMultiLineDataQueryDialog@@MAEHABUTKeyEvent@@@Z |
| 0x1009fb70 | 0x1010038c | AVKON | 1348 | ?MoveToNextOrPreviousItemL@CAknGrid@@IAEXVTPoint@@@Z |
| 0x1009fb80 | 0x10100360 | AVKON | 802 | ?DiscardFont@CAknAnimatedGc@@MAEXXZ |
| 0x1009fb90 | 0x10100368 | AVKON | 805 | ?DisplayMenuL@CAknDialog@@IAEXXZ |
| 0x1009fba0 | 0x10100384 | AVKON | 1267 | ?MdcaCount@CAknQueryValueNumberArray@@UBEHXZ |
| 0x1009fbb0 | 0x1010037c | AVKON | 1234 | ?LogicalPosFromDataIndex@CAknGridView@@QBEXHAAH0@Z |
| 0x1009fbc0 | 0x10100374 | AVKON | 1206 | ?LayoutText@TAknLayoutText@@QAEXABVTRect@@ABVTAknTextLineLayout@@PBVCFont@@@Z |
| 0x1009fbd0 | 0x1010039c | AVKON | 2105 | ?StopSchedulerWaitWithBusyMessage@CAknEnv@@SAXAAVCActiveSchedulerWait@@@Z |
| 0x1009fbe0 | 0x10100354 | AVKON | 662 | ?ConstructL@CAknPopupSettingList@@QAEXXZ |
| 0x1009fbf0 | 0x10100634 | ETEL | 29 | ?AnswerIncomingCall@RCall@@QAEXAAVTRequestStatus@@@Z |
| 0x1009fc00 | 0x1010064c | ETEL | 102 | ?GetFaxSettings@RCall@@QBEHAAUTFaxSessionSettings@1@@Z |
| 0x1009fc10 | 0x1010063c | ETEL | 56 | ?Connect@RCall@@QBEHABVTDesC8@@@Z |
| 0x1009fc20 | 0x10100644 | ETEL | 74 | ?Dial@RCall@@QAEXAAVTRequestStatus@@ABVTDesC16@@@Z |
| 0x1009fc30 | 0x1010065c | ETEL | 153 | ?NullMethod1@CSubSessionExtBase@@IAEXXZ |
| 0x1009fc40 | 0x10100638 | ETEL | 55 | ?Connect@RCall@@QAEXAAVTRequestStatus@@ABVTDesC8@@@Z |
| 0x1009fc50 | 0x10100640 | ETEL | 72 | ?Destruct@RLine@@MAEXXZ |
| 0x1009fc60 | 0x10100658 | ETEL | 152 | ?NotifyStatusChangeCancel@RLine@@QBEXXZ |
| 0x1009fc70 | 0x10100654 | ETEL | 127 | ?LoadPhoneModule@RTelServer@@QBEHABVTDesC16@@@Z |
| 0x1009fc80 | 0x10100648 | ETEL | 77 | ?Dial@RCall@@QBEHABVTDesC8@@ABVTDesC16@@@Z |
| 0x1009fc90 | 0x10100650 | ETEL | 125 | ?IsDefault@TCallParams@RCall@@QAEHXZ |
| 0x1009fca0 | 0x1010062c | ETEL | 26 | ??1CTelObject@@UAE@XZ |
| 0x1009fcb0 | 0x10100630 | ETEL | 27 | ?AcquireOwnership@RCall@@QBEXAAVTRequestStatus@@@Z |
| 0x1009fcc0 | 0x10100660 | ETEL | 204 | ?Set@RTelSubSessionBase@@IBEXHAAVTRequestStatus@@ABVTDesC16@@1W4TReqPriorityType@1@@Z |
| 0x1009fcd0 | 0x10100668 | ETEL | 211 | ?SetOwnership@CCallBase@@UAEHK@Z |
| 0x1009fce0 | 0x10100664 | ETEL | 210 | ?SetFaxSettings@RCall@@QBEHABUTFaxSessionSettings@1@@Z |
| 0x1009fcf0 | 0x10100814 | FBSCLI | 135 | ?UnlockHeap@CFbsBitmap@@IBEXH@Z |
| 0x1009fd00 | 0x10100818 | FBSCLI | 76 | ?IncYPos@TBitmapUtil@@QAEXXZ |
| 0x1009fd10 | 0x1010080c | FBSCLI | 21 | ?CallBack@RFbsSession@@QAEXXZ |
| 0x1009fd20 | 0x10100810 | FBSCLI | 110 | ?Save@CFbsBitmapAsyncStreamer@@QAEHABVTDesC16@@PAVCFbsBitmap@@AAJAAH@Z |
| 0x1009fd30 | 0x10100804 | FBSCLI | 16 | ?Alloc@CChunkPile@@QAEPAEIPAVCBitwiseBitmap@@@Z |
| 0x1009fd40 | 0x10100808 | FBSCLI | 17 | ?AscentInPixels@CFbsFont@@UBEHXZ |
| 0x1009fd50 | 0x101003b0 | BITGDI | 86 | ?HorizontalTwipsToPixels@CFbsBitmapDevice@@UBEHH@Z |
| 0x1009fd60 | 0x101003a0 | BITGDI | 23 | ?CancelSprite@CFbsScreenDevice@@UBEXXZ |
| 0x1009fd70 | 0x101003a4 | BITGDI | 112 | ?Resize@CFbsBitmapDevice@@QAEHABVTSize@@@Z |
| 0x1009fd80 | 0x101003a8 | BITGDI | 120 | ?SetClippingRegion@CFbsBitGc@@QAEXPBVTRegion@@@Z |
| 0x1009fd90 | 0x101003ac | BITGDI | 123 | ?SetOrigin@CFbsBitGc@@UAEXABVTPoint@@@Z |
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
| 0x1009fed0 | 0x10100898 | MEDIACLIENTAUDIOSTREAM | 1 | ?NewL@CMdaAudioOutputStream@@SAPAV1@AAVMMdaAudioOutputStreamCallback@@PAVCMdaServer@@@Z |
| 0x1009fee0 | 0x1010081c | GAMECOMMS | 1 | <NO MATCH / library absent> |
| 0x1009fef0 | 0x10100858 | GAMECOMMS | 30 | <NO MATCH / library absent> |
| 0x1009ff00 | 0x1010086c | GAMECOMMS | 37 | <NO MATCH / library absent> |
| 0x1009ff10 | 0x10100878 | GAMECOMMS | 41 | <NO MATCH / library absent> |
| 0x1009ff20 | 0x10100850 | GAMECOMMS | 27 | <NO MATCH / library absent> |
| 0x1009ff30 | 0x10100854 | GAMECOMMS | 28 | <NO MATCH / library absent> |
| 0x1009ff40 | 0x10100848 | GAMECOMMS | 20 | <NO MATCH / library absent> |
| 0x1009ff50 | 0x10100820 | GAMECOMMS | 2 | <NO MATCH / library absent> |
| 0x1009ff60 | 0x10100864 | GAMECOMMS | 34 | <NO MATCH / library absent> |
| 0x1009ff70 | 0x1010082c | GAMECOMMS | 6 | <NO MATCH / library absent> |
| 0x1009ff80 | 0x10100874 | GAMECOMMS | 40 | <NO MATCH / library absent> |
| 0x1009ff90 | 0x10100868 | GAMECOMMS | 36 | <NO MATCH / library absent> |
| 0x1009ffa0 | 0x10100870 | GAMECOMMS | 39 | <NO MATCH / library absent> |
| 0x1009ffb0 | 0x1010084c | GAMECOMMS | 24 | <NO MATCH / library absent> |
| 0x1009ffc0 | 0x10100824 | GAMECOMMS | 3 | <NO MATCH / library absent> |
| 0x1009ffd0 | 0x10100884 | GAMECOMMS | 57 | <NO MATCH / library absent> |
| 0x1009ffe0 | 0x10100838 | GAMECOMMS | 9 | <NO MATCH / library absent> |
| 0x1009fff0 | 0x10100844 | GAMECOMMS | 15 | <NO MATCH / library absent> |
| 0x100a0000 | 0x10100840 | GAMECOMMS | 14 | <NO MATCH / library absent> |
| 0x100a0010 | 0x10100834 | GAMECOMMS | 8 | <NO MATCH / library absent> |
| 0x100a0020 | 0x1010083c | GAMECOMMS | 11 | <NO MATCH / library absent> |
| 0x100a0030 | 0x10100830 | GAMECOMMS | 7 | <NO MATCH / library absent> |
| 0x100a0040 | 0x10100880 | GAMECOMMS | 56 | <NO MATCH / library absent> |
| 0x100a0050 | 0x10100860 | GAMECOMMS | 33 | <NO MATCH / library absent> |
| 0x100a0060 | 0x1010085c | GAMECOMMS | 32 | <NO MATCH / library absent> |
| 0x100a0070 | 0x10100828 | GAMECOMMS | 5 | <NO MATCH / library absent> |
| 0x100a0080 | 0x1010087c | GAMECOMMS | 53 | <NO MATCH / library absent> |
| 0x100a00a0 | 0x10100890 | GDI | 151 | ?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z |
| 0x100a00b0 | 0x10100888 | GDI | 101 | ?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z |
| 0x100a00c0 | 0x1010088c | GDI | 108 | ?NewL@CPalette@@SAPAV1@H@Z |
| 0x100a00d0 | 0x10100894 | HAL | 1 | ?Get@HAL@@SAHW4TAttribute@HALData@@AAH@Z |
| 0x100a00e0 | 0x101008a4 | MSGS | 185 | ?NewL@CMsvServerEntry@@SAPAV1@AAVCMsvServer@@J@Z |
| 0x100a00f0 | 0x101008a0 | MSGS | 143 | ?HasDirectoryL@CMsvServerEntry@@QBEHXZ |
| 0x100a0100 | 0x1010089c | MSGS | 3 | ??0CMsgActive@@IAE@H@Z |
| 0x100a0110 | 0x10100974 | SIMKIN | 185 | <NO MATCH / library absent> |
| 0x100a0120 | 0x101008f8 | SIMKIN | 85 | <NO MATCH / library absent> |
| 0x100a0130 | 0x101008c8 | SIMKIN | 29 | <NO MATCH / library absent> |
| 0x100a0140 | 0x101009a4 | SIMKIN | 237 | <NO MATCH / library absent> |
| 0x100a0150 | 0x101008d8 | SIMKIN | 42 | <NO MATCH / library absent> |
| 0x100a0160 | 0x101008cc | SIMKIN | 37 | <NO MATCH / library absent> |
| 0x100a0170 | 0x101008d4 | SIMKIN | 40 | <NO MATCH / library absent> |
| 0x100a0180 | 0x101008ec | SIMKIN | 80 | <NO MATCH / library absent> |
| 0x100a0190 | 0x101008c0 | SIMKIN | 22 | <NO MATCH / library absent> |
| 0x100a01a0 | 0x101008b0 | SIMKIN | 9 | <NO MATCH / library absent> |
| 0x100a01b0 | 0x1010097c | SIMKIN | 192 | <NO MATCH / library absent> |
| 0x100a01c0 | 0x1010094c | SIMKIN | 158 | <NO MATCH / library absent> |
| 0x100a01d0 | 0x10100920 | SIMKIN | 109 | <NO MATCH / library absent> |
| 0x100a01e0 | 0x10100930 | SIMKIN | 121 | <NO MATCH / library absent> |
| 0x100a01f0 | 0x10100970 | SIMKIN | 184 | <NO MATCH / library absent> |
| 0x100a0200 | 0x101008f4 | SIMKIN | 84 | <NO MATCH / library absent> |
| 0x100a0210 | 0x10100900 | SIMKIN | 88 | <NO MATCH / library absent> |
| 0x100a0220 | 0x101009a0 | SIMKIN | 236 | <NO MATCH / library absent> |
| 0x100a0230 | 0x1010093c | SIMKIN | 141 | <NO MATCH / library absent> |
| 0x100a0240 | 0x10100990 | SIMKIN | 232 | <NO MATCH / library absent> |
| 0x100a0250 | 0x1010095c | SIMKIN | 163 | <NO MATCH / library absent> |
| 0x100a0260 | 0x10100928 | SIMKIN | 118 | <NO MATCH / library absent> |
| 0x100a0270 | 0x1010091c | SIMKIN | 108 | <NO MATCH / library absent> |
| 0x100a0280 | 0x10100918 | SIMKIN | 107 | <NO MATCH / library absent> |
| 0x100a0290 | 0x10100958 | SIMKIN | 161 | <NO MATCH / library absent> |
| 0x100a02a0 | 0x10100948 | SIMKIN | 157 | <NO MATCH / library absent> |
| 0x100a02b0 | 0x10100940 | SIMKIN | 154 | <NO MATCH / library absent> |
| 0x100a02c0 | 0x10100998 | SIMKIN | 234 | <NO MATCH / library absent> |
| 0x100a02d0 | 0x10100964 | SIMKIN | 165 | <NO MATCH / library absent> |
| 0x100a02e0 | 0x101008bc | SIMKIN | 20 | <NO MATCH / library absent> |
| 0x100a02f0 | 0x10100968 | SIMKIN | 177 | <NO MATCH / library absent> |
| 0x100a0300 | 0x101008e4 | SIMKIN | 59 | <NO MATCH / library absent> |
| 0x100a0310 | 0x101008dc | SIMKIN | 43 | <NO MATCH / library absent> |
| 0x100a0320 | 0x101008e8 | SIMKIN | 60 | <NO MATCH / library absent> |
| 0x100a0330 | 0x10100908 | SIMKIN | 101 | <NO MATCH / library absent> |
| 0x100a0340 | 0x101008d0 | SIMKIN | 38 | <NO MATCH / library absent> |
| 0x100a0350 | 0x10100950 | SIMKIN | 159 | <NO MATCH / library absent> |
| 0x100a0360 | 0x10100980 | SIMKIN | 198 | <NO MATCH / library absent> |
| 0x100a0370 | 0x10100984 | SIMKIN | 200 | <NO MATCH / library absent> |
| 0x100a0380 | 0x101008e0 | SIMKIN | 50 | <NO MATCH / library absent> |
| 0x100a0390 | 0x10100988 | SIMKIN | 211 | <NO MATCH / library absent> |
| 0x100a03a0 | 0x1010098c | SIMKIN | 229 | <NO MATCH / library absent> |
| 0x100a03b0 | 0x10100934 | SIMKIN | 132 | <NO MATCH / library absent> |
| 0x100a03c0 | 0x101008c4 | SIMKIN | 26 | <NO MATCH / library absent> |
| 0x100a03d0 | 0x101009a8 | SIMKIN | 259 | <NO MATCH / library absent> |
| 0x100a03e0 | 0x101008b4 | SIMKIN | 11 | <NO MATCH / library absent> |
| 0x100a03f0 | 0x101008b8 | SIMKIN | 17 | <NO MATCH / library absent> |
| 0x100a0400 | 0x1010092c | SIMKIN | 120 | <NO MATCH / library absent> |
| 0x100a0410 | 0x1010096c | SIMKIN | 183 | <NO MATCH / library absent> |
| 0x100a0420 | 0x101008f0 | SIMKIN | 83 | <NO MATCH / library absent> |
| 0x100a0430 | 0x101008fc | SIMKIN | 87 | <NO MATCH / library absent> |
| 0x100a0440 | 0x1010099c | SIMKIN | 235 | <NO MATCH / library absent> |
| 0x100a0450 | 0x10100938 | SIMKIN | 140 | <NO MATCH / library absent> |
| 0x100a0460 | 0x10100994 | SIMKIN | 233 | <NO MATCH / library absent> |
| 0x100a0470 | 0x10100960 | SIMKIN | 164 | <NO MATCH / library absent> |
| 0x100a0480 | 0x10100978 | SIMKIN | 191 | <NO MATCH / library absent> |
| 0x100a0490 | 0x10100924 | SIMKIN | 117 | <NO MATCH / library absent> |
| 0x100a04a0 | 0x10100914 | SIMKIN | 106 | <NO MATCH / library absent> |
| 0x100a04b0 | 0x10100910 | SIMKIN | 105 | <NO MATCH / library absent> |
| 0x100a04c0 | 0x10100954 | SIMKIN | 160 | <NO MATCH / library absent> |
| 0x100a04d0 | 0x10100944 | SIMKIN | 156 | <NO MATCH / library absent> |
| 0x100a04e0 | 0x101008ac | SIMKIN | 2 | <NO MATCH / library absent> |
| 0x100a04f0 | 0x1010090c | SIMKIN | 102 | <NO MATCH / library absent> |
| 0x100a0500 | 0x10100904 | SIMKIN | 89 | <NO MATCH / library absent> |
| 0x100a0510 | 0x101005e0 | ESTLIB | 82 | _sprintf |
| 0x100a0520 | 0x10100620 | ESTLIB | 316 | _wcscat |
| 0x100a0530 | 0x10100628 | ESTLIB | 342 | _wcsdup |
| 0x100a0540 | 0x10100624 | ESTLIB | 317 | _wcscmp |
| 0x100a0550 | 0x10100610 | ESTLIB | 188 | _strncpy |
| 0x100a0560 | 0x10100604 | ESTLIB | 180 | _strcmp |
| 0x100a0570 | 0x10100614 | ESTLIB | 193 | _strtok |
| 0x100a0580 | 0x101005e4 | ESTLIB | 83 | _sscanf |
| 0x100a0590 | 0x101005c0 | ESTLIB | 9 | _strlen |
| 0x100a05a0 | 0x10100608 | ESTLIB | 181 | _strcpy |
| 0x100a05b0 | 0x101005fc | ESTLIB | 177 | _strcasecmp |
| 0x100a05c0 | 0x1010061c | ESTLIB | 315 | _wclosedir |
| 0x100a05d0 | 0x101005ec | ESTLIB | 157 | _time |
| 0x100a05e0 | 0x1010060c | ESTLIB | 187 | _strncmp |
| 0x100a05f0 | 0x101005d0 | ESTLIB | 58 | _fopen |
| 0x100a0600 | 0x101005d8 | ESTLIB | 64 | _fscanf |
| 0x100a0610 | 0x101005c8 | ESTLIB | 51 | _feof |
| 0x100a0620 | 0x101005c4 | ESTLIB | 49 | _fclose |
| 0x100a0630 | 0x101005d4 | ESTLIB | 59 | _fprintf |
| 0x100a0640 | 0x101005bc | ESTLIB | 6 | _free |
| 0x100a0650 | 0x10100618 | ESTLIB | 291 | _wait |
| 0x100a0660 | 0x101005e8 | ESTLIB | 128 | _atoi |
| 0x100a0670 | 0x10100600 | ESTLIB | 178 | _strcat |
| 0x100a0680 | 0x101005cc | ESTLIB | 56 | _fgets |
| 0x100a0690 | 0x101005b8 | ESTLIB | 3 | _malloc |
| 0x100a06a0 | 0x101005dc | ESTLIB | 65 | _fseek |
| 0x100a06b0 | 0x101005f4 | ESTLIB | 173 | _memchr |
| 0x100a06c0 | 0x101005f0 | ESTLIB | 171 | _toupper |
| 0x100a06d0 | 0x101005f8 | ESTLIB | 174 | _memcmp |
| 0x100a06e0 | 0x101009b8 | WS32 | 268 | ?SetWindowGroupOrdinalPosition@RWsSession@@QAEHHH@Z |
| 0x100a06f0 | 0x101009ac | WS32 | 43 | ?BitBlt@CWindowGc@@UAEXABVTPoint@@PBVCWsBitmap@@@Z |
| 0x100a0700 | 0x101009b4 | WS32 | 109 | ?DrawEllipse@CWindowGc@@UAEXABVTRect@@@Z |
| 0x100a0710 | 0x101009b0 | WS32 | 74 | ?Construct@CWsScreenDevice@@QAEHXZ |
| 0x100a0720 | 0x101005b0 | ESOCK | 209 | ?StopProtocol@RSocketServ@@QAEXIIIAAVTRequestStatus@@@Z |
| 0x100a0730 | 0x101005b4 | ESOCK | 217 | ?Version@RSocketServ@@QBE?AVTVersion@@XZ |
| 0x100a0740 | 0x101005a0 | ESOCK | 48 | ?CancelAccept@RSocket@@QAEXXZ |
| 0x100a0750 | 0x101005a4 | ESOCK | 62 | ?Close@RSocket@@QAEXXZ |
| 0x100a0760 | 0x101005ac | ESOCK | 129 | ?Name@RSocket@@QAEHAAV?$TBuf@$0IA@@@@Z |
| 0x100a0770 | 0x101005a8 | ESOCK | 87 | ?Free@RMBuf@@QAEXXZ |
| 0x100a0780 | 0x1010059c | ESOCK | 45 | ?Cancel@RMBufAsyncRequest@@QAEXXZ |

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

