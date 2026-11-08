# Step 46 — ARM UREL import-library ordinal cross-check

The ARM UREL archive linker index maps decorated symbol names to dsNNNNN.o members; this is the primary ARM import identity evidence. WINS UDEB names are shown separately for comparison only.

- Game import slots: 414
- Distinct DLLs: 19
- ARM member naming convention is checked against archive tables; a member named dsNNNNN.o is treated as candidate ordinal NNNNN, not assumed to be correct until its contents are inspected.

## APPARC.LIB

- dt.o: 400 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_APPARC_LIB_iname
- dh.o: 540 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_APPARC_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_APPARC_LIB_iname
- Archive members: 112; dsNNNNN ordinal-like members: 110
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 3 | AppFullName__C15CApaApplication | ??0CApaFileRecognizerType@@IAE@XZ | ds00003.o | 714 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 6 | Capability__C12CApaDocument | ??0TApaAppEntry@@QAE@XZ | ds00006.o | 702 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 27 | GlassPictureL__12CApaDocument | ?ConstructL@CApaProcess@@IAEXXZ | ds00027.o | 708 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 71 | ValidatePasswordL__C12CApaDocument | ?Reserved_2@CApaDocument@@EAEXXZ | ds00071.o | 723 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## AVKON.LIB

- dt.o: 395 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_AVKON_LIB_iname
- dh.o: 538 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_AVKON_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_AVKON_LIB_iname
- Archive members: 2276; dsNNNNN ordinal-like members: 2274
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 63 | BaseConstructL__9CAknAppUii | ??0CAknIpFieldSettingPage@@QAE@PBVTDesC16@@HHHHAAVTInetAddr@@@Z | ds00063.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 662 | ExecuteLD__22CAknResourceNoteDialogRC7TDesC16 | ?ConstructL@CAknPopupSettingList@@QAEXXZ | ds00662.o | 755 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 750 | HandleError__9CAknAppUiiRC14SExtendedErrorR6TDes16T3 | ?CreateNavigationLabelL@CAknNavigationControlContainer@@QAEPAVCAknNavigationDecorator@@ABVTDesC16@@@Z | ds00750.o | 776 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 757 | HandleForegroundEventL__9CAknAppUii | ?CreateTabGroupL@CAknNavigationControlContainer@@UAEPAVCAknNavigationDecorator@@XZ | ds00757.o | 725 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 802 | HandleStatusPaneSizeChange__9CAknAppUi | ?DiscardFont@CAknAnimatedGc@@MAEXXZ | ds00802.o | 734 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 803 | HandleSystemEventL__9CAknAppUiRC8TWsEvent | ?DismissL@CAknSettingPage@@IAEXH@Z | ds00803.o | 743 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 805 | HandleViewDeactivation__9CAknAppUiRC10TVwsViewIdT1 | ?DisplayMenuL@CAknDialog@@IAEXXZ | ds00805.o | 770 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 808 | HandleWsEventL__9CAknAppUiRC8TWsEventP11CCoeControl | ?DoMoveL@CAknGridView@@IAEXW4TCursorMovement@CListBoxView@@W4TSelectionMode@3@@Z | ds00808.o | 773 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 874 | KeySounds__9CAknAppUi | ?DrawItem@CSingleHeadingStyleItemDrawer@@UBEXHVTPoint@@HHHH@Z | ds00874.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1206 | OpenIniFileLC__C15CAknApplicationR3RFs | ?LayoutText@TAknLayoutText@@QAEXABVTRect@@ABVTAknTextLineLayout@@PBVCFont@@@Z | ds01206.o | 734 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1213 | PopContext__18CAknKeySoundSystem | ?ListBox@CAknPopupList@@QAEPAVCEikListBox@@XZ | ds01213.o | 716 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1234 | PreDocConstructL__15CAknApplication | ?LogicalPosFromDataIndex@CAknGridView@@QBEXHAAH0@Z | ds01234.o | 725 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1254 | PrepareToExit__9CAknAppUi | ?MaxTextLength@CAknQueryDialog@@SAHPBVCAknQueryControl@@ABVTDes16@@H@Z | ds01254.o | 695 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1267 | ProcessCommandL__9CAknAppUii | ?MdcaCount@CAknQueryValueNumberArray@@UBEHXZ | ds01267.o | 704 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1272 | PushContextL__18CAknKeySoundSystemi | ?MdcaCount@CSelectionItemList@@UBEHXZ | ds01272.o | 725 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1348 | Reserved_MtsmObject__9CAknAppUi | ?MoveToNextOrPreviousItemL@CAknGrid@@IAEXVTPoint@@@Z | ds01348.o | 713 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1352 | Reserved_MtsmPosition__9CAknAppUi | ?NeedToDismissQueryL@CAknMultiLineDataQueryDialog@@MAEHABUTKeyEvent@@@Z | ds01352.o | 719 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1529 | SetKeyBlockMode__9CAknAppUi16TAknKeyBlockMode | ?PreLayoutDynInitL@CAknProgressDialog@@MAEXXZ | ds01529.o | 755 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2048 | _._9CAknAppUi | ?SizeChanged@CAknDoubleTimeStyleListBox@@UAEXXZ | ds02048.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2105 | __19CAknInformationNote | ?StopSchedulerWaitWithBusyMessage@CAknEnv@@SAXAAVCActiveSchedulerWait@@@Z | ds02105.o | 689 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## BITGDI.LIB

- dt.o: 400 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_BITGDI_LIB_iname
- dh.o: 540 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_BITGDI_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_BITGDI_LIB_iname
- Archive members: 163; dsNNNNN ordinal-like members: 161
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 23 | CreateContext__10CFbsDeviceRP9CFbsBitGc | ?CancelSprite@CFbsScreenDevice@@UBEXXZ | ds00023.o | 738 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | NewL__16CFbsBitmapDeviceP10CFbsBitmap | ?HorizontalTwipsToPixels@CFbsBitmapDevice@@UBEHH@Z | ds00086.o | 732 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 112 | SetDitherOrigin__9CFbsBitGcRC6TPoint | ?Resize@CFbsBitmapDevice@@QAEHABVTSize@@@Z | ds00112.o | 729 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 120 | SetShadowMode__9CFbsBitGci | ?SetClippingRegion@CFbsBitGc@@QAEXPBVTRegion@@@Z | ds00120.o | 699 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 123 | SetUserDisplayMode__9CFbsBitGc12TDisplayMode | ?SetOrigin@CFbsBitGc@@UAEXABVTPoint@@@Z | ds00123.o | 753 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## CONE.LIB

- dt.o: 394 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_CONE_LIB_iname
- dh.o: 536 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_CONE_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_CONE_LIB_iname
- Archive members: 319; dsNNNNN ordinal-like members: 317
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 3 | ActivateL__11CCoeControl | ??0CCoeControl@@QAE@XZ | ds00003.o | 691 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 12 | AddToStackL__9CCoeAppUiP11CCoeControlii | ??8TCoeHelpContext@@QBEHABV0@@Z | ds00012.o | 736 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 28 | ComponentControl__C11CCoeControli | ?AllocReadResourceAsDes16L@CCoeEnv@@QBEPAVHBufC16@@H@Z | ds00028.o | 718 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | ConstructFromResourceL__11CCoeControlR15TResourceReader | ?AllocReadResourceAsDes16LC@CCoeEnv@@QBEPAVHBufC16@@H@Z | ds00029.o | 784 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 33 | CountComponentControls__C11CCoeControl | ?BackedUpWindow@CCoeControl@@IBEAAVRBackedUpWindow@@XZ | ds00033.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 40 | CreateWindowL__11CCoeControl | ?CloseWindow@CCoeControl@@IAEXXZ | ds00040.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 55 | DrawableWindow__C11CCoeControl | ?CreateWindowL@CCoeControl@@IAEXPBV1@@Z | ds00055.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 72 | GetColorUseListL__C11CCoeControlRt9CArrayFix1Z12TCoeColorUse | ?ExecuteFepSettingsDialogL@CCoeEnv@@QAEXABVTDesC16@@@Z | ds00072.o | 799 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | GetHelpContext__C11CCoeControlR15TCoeHelpContext | ?SupportsWesternNumericReal@TCoeInputCapabilities@@QBEHXZ | ds00074.o | 763 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | HandleKeyEventL__9CCoeAppUiRC9TKeyEvent10TEventCode | ?Format128@CCoeEnv@@QAAXAAVTDes16@@HZZ | ds00082.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 83 | __21TCoeInputCapabilitiesUi | ?Format256@CCoeEnv@@QAAXAAVTDes16@@HZZ | ds00083.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 84 | HandlePointerBufferReadyL__11CCoeControl | ?GetActiveViewId@CCoeAppUi@@QBEHAAVTVwsViewId@@@Z | ds00084.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 87 | HandleResourceChange__11CCoeControli | ?GetHelpContext@CCoeControl@@UBEXAAVTCoeHelpContext@@@Z | ds00087.o | 727 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 90 | HandleSwitchOnEventL__9CCoeAppUiP11CCoeControl | ?HandleComponentControlsResourceChange@CCoeControl@@IAEXH@Z | ds00090.o | 757 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 95 | HasBorder__C11CCoeControl | ?HandleKeyEventL@CCoeAppUiSimple@@EAEXABUTKeyEvent@@W4TEventCode@@@Z | ds00095.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 96 | HelpContextL__C9CCoeAppUi | ?SupportsWesternNumericIntegerNegative@TCoeInputCapabilities@@QBEHXZ | ds00096.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 101 | InputCapabilities__C9CCoeAppUi | ?HandleStackChanged@CCoeAppUi@@QAEXXZ | ds00101.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 138 | MakeVisible__11CCoeControli | ?IsVisible@CCoeControl@@QBEHXZ | ds00138.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 139 | MinimumSize__11CCoeControl | ?IsWservEventPending@CCoeEnv@@QBEHXZ | ds00139.o | 697 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | OfferKeyEventL__11CCoeControlRC9TKeyEvent10TEventCode | ?MCoeFocusObserver_Reserved_2@MCoeFocusObserver@@EAEXXZ | ds00143.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 147 | PositionChanged__11CCoeControl | ?SupportsNavigation@TCoeInputCapabilities@@QBEHXZ | ds00147.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 153 | PrepareForFocusLossL__11CCoeControl | ?NameOfInstalledFepL@CCoeEnv@@QAEPAVHBufC16@@XZ | ds00153.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 160 | Rect__C11CCoeControl | ?Position@CCoeControl@@QBE?AVTPoint@@XZ | ds00160.o | 679 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 167 | RemoveFromStack__9CCoeAppUiP11CCoeControl | ?PrepareToExit@CCoeAppUiBase@@UAEXXZ | ds00167.o | 742 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 173 | WriteInternalStateL__C11CCoeControlR12RWriteStream | ?Rect@CCoeControl@@QBE?AVTRect@@XZ | ds00173.o | 769 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 177 | Reserved_2__11CCoeControl | ?RemoveFepObserver@CCoeEnv@@QAEXAAVMCoeFepObserver@@@Z | ds00177.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | SetAdjacent__11CCoeControli | ?ReportEventL@CCoeControl@@IAEXW4TCoeEvent@MCoeControlObserver@@@Z | ds00185.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 187 | SetAndDrawFocus__9CCoeAppUii | ?Reserved_1@CCoeAppUiBase@@EAEXXZ | ds00187.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 197 | SetContainerWindowL__11CCoeControlRC11CCoeControl | ?RunL@CCoeEnv@@UAEXXZ | ds00197.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 200 | SetDimmed__11CCoeControli | ?SetAndDrawFocus@CCoeAppUi@@EAEXH@Z | ds00200.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 208 | SetNeighbor__11CCoeControlP11CCoeControl | ?SetContainerWindowL@CCoeControl@@QAEXAAVRBackedUpWindow@@@Z | ds00208.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 214 | SetRect__11CCoeControlRC5TRect | ?SetExtent@CCoeControl@@QAEXABVTPoint@@ABVTSize@@@Z | ds00214.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 221 | SizeChanged__11CCoeControl | ?SetNeighbor@CCoeControl@@UAEXPAV1@@Z | ds00221.o | 697 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 223 | Static__7CCoeEnv | ?SetObserver@CCoeControl@@QAEXPAVMCoeControlObserver@@@Z | ds00223.o | 667 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 226 | SystemGc__C11CCoeControl | ?SetPosition@CCoeControl@@QAEXABVTPoint@@@Z | ds00226.o | 691 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 232 | _._11CCoeControl | ?SetUse@TCoeColorUse@@QAEXH@Z | ds00232.o | 667 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 236 | __11CCoeControl | ?Static@CCoeEnv@@SAPAV1@XZ | ds00236.o | 664 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 255 | MCoeMessageObserver_Reserved_1__19MCoeMessageObserver | ?DisplayError@CCoeScheduler@@UBEXH@Z | ds00255.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 256 | MCoeMessageObserver_Reserved_2__19MCoeMessageObserver | ?FepAwareTextEditor@TCoeInputCapabilities@@QBEPAVMCoeFepAwareTextEditor@@XZ | ds00256.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 292 | MCoeViewDeactivationObserver_Reserved_1__28MCoeViewDeactivationObserver | ?MCoeViewActivationObserver_Reserved_2@MCoeViewActivationObserver@@EAEXXZ | ds00292.o | 832 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 293 | MCoeViewDeactivationObserver_Reserved_2__28MCoeViewDeactivationObserver | ?MCoeViewDeactivationObserver_Reserved_1@MCoeViewDeactivationObserver@@EAEXXZ | ds00293.o | 832 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 312 | MopNext__11CCoeControl | ?MopNext@CCoeControl@@EAEPAVMObjectProvider@@XZ | ds00312.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 314 | MopSupplyObject__11CCoeControlG8TTypeUid | ?MopSupplyObject@CCoeControl@@MAE?AVPtr@TTypeUid@@V3@@Z | ds00314.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## EFSRV.LIB

- dt.o: 395 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_EFSRV_LIB_iname
- dh.o: 538 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_EFSRV_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_EFSRV_LIB_iname
- Archive members: 233; dsNNNNN ordinal-like members: 231
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 15 | Close__7RFsBase | ??1CFileBase@@MAE@XZ | ds00015.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 18 | Connect__3RFsi | ??ACDir@@QBEABVTEntry@@H@Z | ds00018.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | Copy__8CFileManRC7TDesC16T1Ui | ?AbbreviatedPath@CFileBase@@QAE?AVTPtrC16@@XZ | ds00021.o | 707 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 25 | Create__5RFileR3RFsRC7TDesC16Ui | ?Att@RFile@@QBEHAAI@Z | ds00025.o | 713 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | Delete__3RFsRC7TDesC16 | ?BytesTransferredByCopyStep@CFileMan@@QAEHXZ | ds00029.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 33 | DriveAndPath__C10TParseBase | ?ClearPassword@RFs@@QAEHHABV?$TBuf8@$0BA@@@@Z | ds00033.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | FullName__C10TParseBase | ?DismountFileSystem@RFs@@QBEHABVTDesC16@@H@Z | ds00051.o | 689 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | MkDir__3RFsRC7TDesC16 | ?IsExtWild@TParseBase@@QBEHXZ | ds00086.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 106 | NewL__8CFileManR3RFs | ?Modified@RFile@@QBEHAAVTTime@@@Z | ds00106.o | 680 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 121 | Open__5RFileR3RFsRC7TDesC16Ui | ?NamePresent@TParseBase@@QBEHXZ | ds00121.o | 707 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 136 | Read__C5RFileR5TDes8 | ?NotifyFileManOperation@MFileManObserver@@UAE?AW4TControl@1@XZ | ds00136.o | 680 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 146 | Rename__3RFsRC7TDesC16T1 | ?PathPresent@TParseBase@@QBEHXZ | ds00146.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 162 | Seek__C5RFile5TSeekRi | ?ReadFileSection@RFs@@QBEHABVTDesC16@@HAAVTDes8@@H@Z | ds00162.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 183 | Set__6TParseRC7TDesC16PC7TDesC16T2 | ?Set@RFile@@QAEHABVTTime@@II@Z | ds00183.o | 722 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | Size__C5RFileRi | ?Set@TParse@@QAEHABVTDesC16@@PBV2@1@Z | ds00185.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 193 | Volume__C3RFsR11TVolumeInfoi | ?SetErrorCondition@RFs@@QAEHHH@Z | ds00193.o | 704 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 194 | Write__5RFileRC6TDesC8 | ?SetModified@RFile@@QAEHABVTTime@@@Z | ds00194.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 212 | __11TVolumeInfo | ?Volume@RFs@@QBEHAAVTVolumeInfo@@H@Z | ds00212.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 230 | __6TParse | ??0TParse@@QAE@XZ | ds00230.o | 647 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## EIKCORE.LIB

- dt.o: 401 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_EIKCORE_LIB_iname
- dh.o: 542 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_EIKCORE_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_EIKCORE_LIB_iname
- Archive members: 292; dsNNNNN ordinal-like members: 290
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 17 | Application__C9CEikAppUi | ??1CEikonEnv@@UAE@XZ | ds00017.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 20 | BitmapStoreName__C15CEikApplication | ?AddAlertDialogLikeControlToStackL@CEikonEnv@@QAEXPAVCCoeControl@@@Z | ds00020.o | 727 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 30 | Capability__C15CEikApplicationR5TDes8 | ?AddWindowShadow@CEikonEnv@@SAXPAVCCoeControl@@@Z | ds00030.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 31 | CheckHotKeyNotDimmedL__16MEikMenuObserveri | ?AlertWin@CEikonEnv@@QAEXABVTDesC16@@0@Z | ds00031.o | 748 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 40 | ConstructL__9CEikAppUi | ?Application@CEikAppUi@@QBEPAVCEikApplication@@XZ | ds00040.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 48 | CreateCustomCommandControlL__19MEikCommandObserveri | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@@Z | ds00048.o | 775 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 49 | CreateDocumentL__15CEikApplicationP11CApaProcess | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTGulAlignment@@@Z | ds00049.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | CreateFileL__9CEikAppUiRC7TDesC16 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTTimeIntervalMicroSeconds32@@@Z | ds00051.o | 721 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 52 | CreateFileStoreLC__12CEikDocumentR3RFsRC7TDesC16 | ?BusyMsgL@CEikonEnv@@QAEXH@Z | ds00052.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 61 | Document__C9CEikAppUi | ?CommandTailEnd@CEikProcess@@QBE?AVTPtrC16@@XZ | ds00061.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 64 | DynInitMenuBarL__16MEikMenuObserveriP11CEikMenuBar | ?ConstructL@CEikAppUi@@UAEXXZ | ds00064.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 65 | DynInitMenuPaneL__16MEikMenuObserveriP12CEikMenuPane | ?ConstructL@CEikEmbeddableAppList@@QAEXXZ | ds00065.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 66 | EditL__12CEikDocumentP23MApaEmbeddedDocObserveri | ?ConstructL@CEikMsgWin@@QAEXAAVRWindowGroup@@@Z | ds00066.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 67 | Exit__9CEikAppUi | ?ConstructL@CEikonEnv@@QAEXXZ | ds00067.o | 670 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 68 | ExternalizeL__C12CEikDocumentR12RWriteStream | ?ControlColor@CEikonEnv@@QBE?AVTRgb@@W4TLogicalColor@@ABVCCoeControl@@@Z | ds00068.o | 754 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 71 | GetDefaultDocumentFileName__C15CEikApplicationRt4TBuf1i256 | ?CreateByTypeL@EikControlFactory@@SA?AUSEikControlInfo@@H@Z | ds00071.o | 796 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | HandleApplicationSpecificEventL__9CEikAppUiiRC8TWsEvent | ?CreateCustomCommandControlL@MEikCommandObserver@@UAEPAVCCoeControl@@H@Z | ds00074.o | 787 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 75 | HandleAttemptDimmedSelectionL__16MEikMenuObserveri | ?CreateDocumentL@CEikApplication@@MAEPAVCApaDocument@@PAVCApaProcess@@@Z | ds00075.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 76 | HandleCommandL__9CEikAppUii | ?CreateEmbeddedDocumentL@CEikEmbeddableAppList@@QAEPAVCEikDocument@@HPAVCApaProcess@@@Z | ds00076.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 80 | HandleMessageL__9CEikAppUiUlG4TUidRC6TDesC8 | ?CreateIconFromMaskedBitmapL@CEikonEnv@@SAPAVCGulIcon@@ABVCApaMaskedBitmap@@@Z | ds00080.o | 751 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 81 | HandleModelChangeL__9CEikAppUi | ?CreateIconL@CEikonEnv@@QAEPAVCGulIcon@@ABVTDesC16@@HH@Z | ds00081.o | 712 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | HandleResourceChangeL__9CEikAppUii | ?CreateScreenFontL@EikResourceUtils@@SAPAVCFbsFont@@HPAVCEikonEnv@@@Z | ds00082.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 84 | HandleSideBarMenuL__9CEikAppUiiRC6TPointiPC15CEikHotKeyTable | ?DefaultDisplayMode@CEikonEnv@@QBE?AW4TDisplayMode@@XZ | ds00084.o | 802 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | HasChanged__C12CEikDocument | ?DestroyEnvironment@CEikonEnv@@MAEXXZ | ds00086.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 100 | IsEmpty__C12CEikDocument | ?ExternalizeL@CEikDocument@@UBEXAAVRWriteStream@@@Z | ds00100.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 116 | NewDocumentL__12CEikDocument | ?HandleModelChangeL@CEikAppUi@@UAEXXZ | ds00116.o | 706 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 121 | OfferKeyToAppL__16MEikMenuObserverRC9TKeyEvent10TEventCode | ?HandleWsEventL@CAknWsEventMonitor@@UAEXABVTWsEvent@@PAVCCoeControl@@@Z | ds00121.o | 796 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 122 | OpenAppInfoFileLC__C15CEikApplication | ?HandleWsEventL@CEikAppUi@@MAEXABVTWsEvent@@PAVCCoeControl@@@Z | ds00122.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 123 | OpenFileL__12CEikDocumentiRC7TDesC16R3RFs | ?HasChanged@CEikDocument@@UBEHXZ | ds00123.o | 745 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 124 | OpenFileL__9CEikAppUiRC7TDesC16 | ?HideCursor@CEikonEnv@@QAEXPBVCCoeControl@@@Z | ds00124.o | 715 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 130 | PrintL__12CEikDocumentRC12CStreamStore | ?InfoMsgCancel@CEikonEnv@@QAEXXZ | ds00130.o | 736 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 133 | ProcessCommandParametersL__9CEikAppUi11TApaCommandRt4TBuf1i256RC6TDesC8 | ?InfoMsgWithAlignment@CEikonEnv@@QAEXVTGulAlignment@@HQAPAC@Z | ds00133.o | 835 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 134 | ProcessMessageL__9CEikAppUiG4TUidRC6TDesC8 | ?InfoMsgWithAlignmentAndDuration@CEikonEnv@@QAAXVTGulAlignment@@HVTTimeIntervalMicroSeconds32@@ZZ | ds00134.o | 748 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 142 | Reserved_1__12CEikDocument | ?InitSystemFontsL@CEikonEnv@@EAEXXZ | ds00142.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | Reserved_1__15CEikApplication | ?InternalizeL@@YAXAAW4TEikPortFlag@@AAVRReadStream@@@Z | ds00143.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 144 | Reserved_1__9CEikAppUi | ?IsBusy@CEikonEnv@@QBEHXZ | ds00144.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 146 | Reserved_2__12CEikDocument | ?IsForeground@CEikAppUi@@QBEHXZ | ds00146.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 147 | Reserved_2__9CEikAppUi | ?IsSystem@CEikonEnv@@QBEHXZ | ds00147.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 149 | Reserved_3__9CEikAppUi | ?LafEnv@CEikonEnv@@QBEAAVMLafEnv@@XZ | ds00149.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 150 | Reserved_4__9CEikAppUi | ?LastUsedFileL@CEikProcess@@QBE?AV?$TBuf@$0BAA@@@W4TLastUsedFile@1@@Z | ds00150.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 151 | ResourceFileName__C15CEikApplication | ?LaunchPopupMenuL@CEikAppUi@@QAEXHABVTPoint@@W4TPopupTargetPosType@@PBVCEikHotKeyTable@@@Z | ds00151.o | 730 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 155 | RestoreL__12CEikDocumentRC12CStreamStoreRC17CStreamDictionary | ?LegendFont@CEikonEnv@@QBEPBVCFont@@XZ | ds00155.o | 805 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 157 | RestoreMenuL__16MEikMenuObserverP11CCoeControliQ216MEikMenuObserver9TMenuType | ?MEikPictureFactory_Reserved_2@MEikPictureFactory@@EAEXXZ | ds00157.o | 853 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 161 | SaveL__12CEikDocument | ?MdcaPoint@CEikEmbeddableAppList@@EBE?AVTPtrC16@@H@Z | ds00161.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 179 | SetEmphasis__9CEikAppUiP11CCoeControli | ?PictureFactory@CEikonEnv@@QBEPAVMPictureFactory@@XZ | ds00179.o | 736 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 198 | StopDisplayingMenuBar__9CEikAppUi | ?RemoveObserver@CAknWsEventMonitor@@QAEXPBVMAknWsEventObserver@@@Z | ds00198.o | 721 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 200 | StoreL__C12CEikDocumentR12CStreamStoreR17CStreamDictionary | ?ReportResourceChangedToAppL@CEikAppUi@@QAEXH@Z | ds00200.o | 796 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 204 | UpdateTaskNameL__12CEikDocumentP19CApaWindowGroupName | ?Reserved_1@CEikDocument@@EAEXXZ | ds00204.o | 781 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 206 | ValidFileType__C9CEikAppUiG4TUid | ?Reserved_1_MenuObserver@MEikAutoMenuObserver@@EAEXXZ | ds00206.o | 718 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 213 | _._12CEikDocument | ?ResourceFileName@CEikApplication@@UBE?AV?$TBuf@$0BAA@@@XZ | ds00213.o | 673 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 214 | _._15CEikApplication | ?ResourceFileVersionNumber@CEikonEnv@@EBEHXZ | ds00214.o | 682 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 219 | __12CEikDocumentR15CEikApplication | ?RestoreMenuL@MEikMenuObserver@@UAEXPAVCCoeControl@@HW4TMenuType@1@@Z | ds00219.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 222 | __15CEikApplication | ?SaveAnyChangesL@CEikAppUi@@IAEXXZ | ds00222.o | 679 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 224 | __9CEikAppUi | ?SaveL@CEikDocument@@UAEXW4TSaveType@MSaveObserver@@@Z | ds00224.o | 658 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 226 | Reserved_1_MenuObserver__16MEikMenuObserver | ?SaveToDirectFileStoreL@CEikProcess@@QAEXPAVCEikDocument@@PBV?$TBuf@$0BAA@@@@Z | ds00226.o | 751 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 233 | ApplicationRect__C9CEikAppUi | ?SetBusy@CEikonEnv@@QAEXH@Z | ds00233.o | 706 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 243 | LegendFont__C9CEikonEnv | ?SetEmphasis@MEikAutoMenuObserver@@UAEXPAVCCoeControl@@H@Z | ds00243.o | 691 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 253 | SaveL__12CEikDocumentQ213MSaveObserver9TSaveType | ?SetRespondsToSwitchFilesEvent@CEikonEnv@@QAEXH@Z | ds00253.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 264 | MopSupplyObject__9CEikAppUiG8TTypeUid | ?StopDisplayingMenuBar@CEikAppUi@@UAEXXZ | ds00264.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 290 | MopNext__9CEikAppUi | ?IsPartialForeground@CEikAppUi@@QBEHXZ | ds00290.o | 679 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## ESOCK.LIB

- dt.o: 395 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_ESOCK_LIB_iname
- dh.o: 538 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_ESOCK_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_ESOCK_LIB_iname
- Archive members: 242; dsNNNNN ordinal-like members: 240
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 45 | Close__7RSocket | ?Cancel@RMBufAsyncRequest@@QAEXXZ | ds00045.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 48 | Connect__11RSocketServUi | ?CancelAccept@RSocket@@QAEXXZ | ds00048.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 62 | FindProtocol__11RSocketServRCt4TBuf1i32R13TProtocolDesc | ?Close@RSocket@@QAEXXZ | ds00062.o | 785 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 87 | GetOpt__7RSocketUiUiR5TDes8 | ?Free@RMBuf@@QAEXXZ | ds00087.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 129 | Open__7RSocketR11RSocketServUiUiUi | ?Name@RSocket@@QAEHAAV?$TBuf@$0IA@@@@Z | ds00129.o | 722 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 209 | __11RSocketServ | ?StopProtocol@RSocketServ@@QAEXIIIAAVTRequestStatus@@@Z | ds00209.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 217 | __7RSocket | ?Version@RSocketServ@@QBE?AVTVersion@@XZ | ds00217.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## ESTLIB.LIB

- dt.o: 400 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_ESTLIB_LIB_iname
- dh.o: 540 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_ESTLIB_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_ESTLIB_LIB_iname
- Archive members: 349; dsNNNNN ordinal-like members: 347
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 3 | malloc | _malloc | ds00003.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 6 | free | _free | ds00006.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 9 | strlen | _strlen | ds00009.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 49 | fclose | _fclose | ds00049.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | feof | _feof | ds00051.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 56 | fgets | _fgets | ds00056.o | 630 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 58 | fopen | _fopen | ds00058.o | 630 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 59 | fprintf | _fprintf | ds00059.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 64 | fscanf | _fscanf | ds00064.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 65 | fseek | _fseek | ds00065.o | 630 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | sprintf | _sprintf | ds00082.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 83 | sscanf | _sscanf | ds00083.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 128 | atoi | _atoi | ds00128.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 157 | time | _time | ds00157.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 171 | toupper | _toupper | ds00171.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 173 | memchr | _memchr | ds00173.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 174 | memcmp | _memcmp | ds00174.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 177 | strcasecmp | _strcasecmp | ds00177.o | 651 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 178 | strcat | _strcat | ds00178.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 180 | strcmp | _strcmp | ds00180.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 181 | strcpy | _strcpy | ds00181.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 187 | strncmp | _strncmp | ds00187.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 188 | strncpy | _strncpy | ds00188.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 193 | strtok | _strtok | ds00193.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 291 | CloseSTDLIB | _wait | ds00291.o | 654 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 315 | wcscat | _wclosedir | ds00315.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 316 | wcscmp | _wcscat | ds00316.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 317 | wcscpy | _wcscmp | ds00317.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 342 | wcslen | _wcsdup | ds00342.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## ETEL.LIB

- dt.o: 394 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_ETEL_LIB_iname
- dh.o: 536 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_ETEL_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_ETEL_LIB_iname
- Archive members: 230; dsNNNNN ordinal-like members: 228
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 26 | Close__5RLine | ??1CTelObject@@UAE@XZ | ds00026.o | 658 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 27 | Close__6RPhone | ?AcquireOwnership@RCall@@QBEXAAVTRequestStatus@@@Z | ds00027.o | 661 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | Connect__10RTelServeri | ?AnswerIncomingCall@RCall@@QAEXAAVTRequestStatus@@@Z | ds00029.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 55 | EnumerateLines__C6RPhoneRi | ?Connect@RCall@@QAEXAAVTRequestStatus@@ABVTDesC8@@@Z | ds00055.o | 697 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 56 | EnumeratePhones__C10RTelServerRi | ?Connect@RCall@@QBEHABVTDesC8@@@Z | ds00056.o | 715 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 72 | GetLineInfo__C6RPhoneiRQ26RPhone9TLineInfo | ?Destruct@RLine@@MAEXXZ | ds00072.o | 745 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | GetPhoneInfo__C10RTelServeriRQ210RTelServer10TPhoneInfo | ?Dial@RCall@@QAEXAAVTRequestStatus@@ABVTDesC16@@@Z | ds00074.o | 784 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 77 | GetStatus__C5RLineRQ25RCall7TStatus | ?Dial@RCall@@QBEHABVTDesC8@@ABVTDesC16@@@Z | ds00077.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 102 | LoadPhoneModule__C10RTelServerRC7TDesC16 | ?GetFaxSettings@RCall@@QBEHAAUTFaxSessionSettings@1@@Z | ds00102.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 125 | NotifyStatusChangeCancel__C5RLine | ?IsDefault@TCallParams@RCall@@QAEHXZ | ds00125.o | 718 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 127 | NotifyStatusChange__5RLineR14TRequestStatusRQ25RCall7TStatus | ?LoadPhoneModule@RTelServer@@QBEHABVTDesC16@@@Z | ds00127.o | 799 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 152 | Open__5RLineR6RPhoneRC7TDesC16 | ?NotifyStatusChangeCancel@RLine@@QBEXXZ | ds00152.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 153 | Open__6RPhoneR10RTelServerRC7TDesC16 | ?NullMethod1@CSubSessionExtBase@@IAEXXZ | ds00153.o | 727 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 204 | __10RTelServer | ?Set@RTelSubSessionBase@@IBEXHAAVTRequestStatus@@ABVTDesC16@@1W4TReqPriorityType@1@@Z | ds00204.o | 661 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 210 | __5RLine | ?SetFaxSettings@RCall@@QBEHABUTFaxSessionSettings@1@@Z | ds00210.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 211 | __6RPhone | ?SetOwnership@CCallBase@@UAEHK@Z | ds00211.o | 646 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## EUSER.LIB

- dt.o: 392 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - _____EPOC32_RELEASE_ARMI_UREL_EUSER_LIB_iname
- dh.o: 532 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head____EPOC32_RELEASE_ARMI_UREL_EUSER_LIB
  - _____EPOC32_RELEASE_ARMI_UREL_EUSER_LIB_iname
- Archive members: 1681; dsNNNNN ordinal-like members: 1679
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 1 | memset | __ftol | ds00001.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2 | memcpy | ??0CActive@@IAE@H@Z | ds00002.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 3 | newL__5CBaseUi | ??0CActiveScheduler@@QAE@XZ | ds00003.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 13 | Add__16CActiveSchedulerP7CActive | ??0CBufFlat@@IAE@H@Z | ds00013.o | 713 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | After__4UserG27TTimeIntervalMicroSeconds32 | ??0CIdle@@IAE@H@Z | ds00021.o | 743 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 35 | AllocL__4Useri | ??0MBusDev@@QAE@XZ | ds00035.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 41 | AllocSize__4UserRi | ??0RHeap@@IAE@H@Z | ds00041.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 45 | Alloc__4Useri | ??0RPointerArrayBase@@IAE@XZ | ds00045.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 77 | AppendNum__5TDes8i | ??0TDayName@@QAE@W4TDay@@@Z | ds00077.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 85 | Append__5TDes8G5TChar | ??0TDeltaQueBase@@IAE@XZ | ds00085.o | 680 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 89 | Append__6TDes16G5TChar | ??0THeapWalk@@QAE@ABVRHeap@@@Z | ds00089.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 90 | Append__6TDes16PCUsi | ??0TInt64@@QAE@H@Z | ds00090.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 91 | Append__6TDes16RC7TDesC16 | ??0TInt64@@QAE@N@Z | ds00091.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 99 | AtC__C7TDesC16i | ??0TKeyArrayPak@@QAE@HW4TKeyCmpNumeric@@@Z | ds00099.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 152 | Cancel__7CActive | ??0TTime@@QAE@ABVTDateTime@@@Z | ds00152.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 172 | Close__11RHandleBase | ??1CBufSeg@@UAE@XZ | ds00172.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 207 | Compare__C7TDesC16RC7TDesC16 | ??8TPoint@@QBEHABV0@@Z | ds00207.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 211 | CompressAllHeaps__4User | ??8TUidType@@QBEHABV0@@Z | ds00211.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 245 | Copy__5TDes8PCUci | ??GTSize@@QBE?AV0@ABVTPoint@@@Z | ds00245.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 248 | Copy__6TDes16PCUs | ??GTTime@@QBE?AV0@VTTimeIntervalHours@@@Z | ds00248.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 251 | Copy__6TDes16RC7TDesC16 | ??GTTime@@QBE?AV0@VTTimeIntervalMinutes@@@Z | ds00251.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 274 | CreateGlobal__10RSemaphoreRC7TDesC16i10TOwnerType | ??LTRealX@@QBE?AV0@ABV0@@Z | ds00274.o | 764 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 289 | Create__7RThreadRC7TDesC16PFPv_iiP5RHeapPv10TOwnerType | ??YTTime@@QAEAAV0@VTTimeIntervalDays@@@Z | ds00289.o | 779 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 411 | FillZ__3MemPvi | ?Assign@TLex16@@QAEXABVTDesC16@@@Z | ds00411.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 418 | Fill__5TDes8G5TChari | ?At@CObjectCon@@QBEPAVCObject@@H@Z | ds00418.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 467 | Format__6TDes16Gt11TRefByValue1ZC7TDesC16e | ?Cancel@RServer@@QAEXXZ | ds00467.o | 743 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 476 | Free__4UserPv | ?ChangeLocale@UserSvr@@SAHVRLibrary@@@Z | ds00476.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 501 | GetTInt__C6TInt64 | ?Collate@TDes16@@QAEXXZ | ds00501.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 530 | Height__C5TRect | ?Compress@CArrayPakBase@@QAEXXZ | ds00530.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 531 | HomeTime__5TTime | ?Compress@CArrayVarBase@@QAEXXZ | ds00531.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 569 | Install__16CActiveSchedulerP16CActiveScheduler | ?CopyLC@TDes8@@QAEXABVTDesC8@@@Z | ds00569.o | 755 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 621 | Kill__7RThreadi | ?DaysFrom@TTime@@QBE?AVTTimeIntervalDays@@V1@@Z | ds00621.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 625 | Language__4User | ?DebugThreadPanic@@YAXKABVTDesC16@@0H@Z | ds00625.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 627 | LeaveIfError__4Useri | ?Decompose@TChar@@QBEHAAVTPtrC16@@@Z | ds00627.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 630 | Leave__4Useri | ?Delete@CArrayFixBase@@QAEXHH@Z | ds00630.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 632 | Left__C7TDesC16i | ?Delete@CArrayPakBase@@QAEXHH@Z | ds00632.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 711 | Move__5TRectii | ?EmulatorDataPath@@YA?AVTPtrC16@@XZ | ds00711.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 738 | NewL__9CPeriodici | ?FRand@Math@@SANAAVTInt64@@@Z | ds00738.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 746 | New__12CTrapCleanup | ?Fill@TDes16@@QAEXVTChar@@@Z | ds00746.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 809 | Panic__4UserRC7TDesC16i | ?Free@User@@SAXPAX@Z | ds00809.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 824 | PopAndDestroy__12CleanupStack | ?GetCategory@TChar@@QBE?AW4TCategory@1@XZ | ds00824.o | 704 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 825 | PopAndDestroy__12CleanupStacki | ?GetCategory@TUnicode@@QBE?AW4TCategory@TChar@@PBUTUnicodeDataSet@@@Z | ds00825.o | 707 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 828 | Pop__12CleanupStack | ?GetCurrentDirectoryU@@YAP6GKKPAG@ZXZ | ds00828.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 855 | Ptr__C6TDesC8 | ?GetTitleCase@TChar@@QBEIXZ | ds00855.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 856 | Ptr__C7TDesC16 | ?GetUpperCase@TChar@@QBEIXZ | ds00856.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 858 | PushL__12CleanupStackP5CBase | ?GetVolumeInformationU@@YAP6GHPBGPAGKPAK221K@ZXZ | ds00858.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 869 | Rand__4MathR6TInt64 | ?HandleInfo@RHandleBase@@QAEXPAVTHandleInfo@@@Z | ds00869.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 875 | ReAlloc__4UserPvi | ?HeapSortSigned@RPointerArrayBase@@IAEXXZ | ds00875.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 933 | ResetInactivityTime__4User | ?IsContainedBy@TRegion@@QBEHABVTRect@@@Z | ds00933.o | 695 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 954 | Resume__C7RThread | ?IsNaN@TRealX@@QBEHXZ | ds00954.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 956 | Right__C7TDesC16i | ?IsPresent@TUidType@@QBEHVTUid@@@Z | ds00956.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 962 | RunError__7CActivei | ?IsUpper@TChar@@QBEHXZ | ds00962.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 979 | SetActive__7CActive | ?LeaveIfError@User@@SAHH@Z | ds00979.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1016 | SetPriority__C7RThread15TThreadPriority | ?Logon@RProcess@@QBEXAAVTRequestStatus@@@Z | ds01016.o | 734 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1078 | Signal__10RSemaphore | ?Neg@TInt64A@@QAEXXZ | ds01078.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1086 | Size__C5TRect | ?New@HBufC8@@SAPAV1@H@Z | ds01086.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1107 | Start__16CActiveScheduler | ?NewMax@HBufC8@@SAPAV1@H@Z | ds01107.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1111 | Start__9CPeriodicG27TTimeIntervalMicroSeconds32T1G9TCallBack | ?NewMaxLC@HBufC8@@SAPAV1@H@Z | ds01111.o | 797 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1113 | Stop__16CActiveScheduler | ?Next@TFindChunk@@QAEHAAV?$TBuf@$0BAA@@@@Z | ds01113.o | 689 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1122 | Suspend__C7RThread | ?Next@TFindThread@@QAEHAAV?$TBuf@$0BAA@@@@Z | ds01122.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1148 | Trap__5TTrapRi | ?Offset@TLex8@@QBEHXZ | ds01148.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1164 | UnTrap__5TTrap | ?OpenGlobal@RSemaphore@@QAEHABVTDesC16@@W4TOwnerType@@@Z | ds01164.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1212 | Wait__10RSemaphore | ?Protected@RThread@@QBEHXZ | ds01212.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1246 | Zero__5TDes8 | ?Read@TBusLocalDrive@@QAEHVTInt64@@HPBXHH@Z | ds01246.o | 653 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1247 | Zero__6TDes16 | ?ReadL@CSession@@QBEXPBXAAVTDes16@@@Z | ds01247.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1262 | _._5CBase | ?RectangleListW@TRegion@@IAEPAVTRect@@XZ | ds01262.o | 644 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1265 | _._7CActive | ?RegisterClassU@@YAP6GGPBUtagWNDCLASSW@@@ZXZ | ds01265.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1282 | __10TBufBase16RC7TDesC16i | ?Rename@RProcess@@QAEHABVTDesC16@@@Z | ds01282.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1283 | __10TBufBase16i | ?Rename@RThread@@QBEHABVTDesC16@@@Z | ds01283.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1343 | __16CActiveScheduler | ?ServerStarted@UserSvr@@SAXXZ | ds01343.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1359 | __5CBase | ?Set@TLongDateFormatSpec@@QAEXXZ | ds01359.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1366 | __5TPtr8PUci | ?Set@TRealX@@QAEHH@Z | ds01366.o | 653 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1367 | __5TPtr8PUcii | ?Set@TRealX@@QAEHI@Z | ds01367.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1370 | __5TRectRC5TSize | ?Set@TShortDateFormatSpec@@QAEXXZ | ds01370.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1373 | __5TRectiiii | ?SetActive@CActive@@IAEXXZ | ds01373.o | 653 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1379 | __6TInt64i | ?SetEnabled@Password@@SAHABV?$TBuf@$0BA@@@H@Z | ds01379.o | 647 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1386 | __6TPtrC8PCUci | ?SetHour@TDateTime@@QAEHH@Z | ds01386.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1395 | __7CActivei | ?SetLength@TDes8@@QAEXH@Z | ds01395.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1407 | __7TPtrC16PCUs | ?SetOffset@TDblQueBase@@QAEXH@Z | ds01407.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1422 | __8TVersion | ?SetReserveFlatL@CArrayFixBase@@IAEXH@Z | ds01422.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1431 | __9TBufBase8i | ?SetToLast@TDblQueIterBase@@QAEXXZ | ds01431.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1432 | __9TBufBase8ii | ?SetTrapHandler@User@@SAPAVTTrapHandler@@PAV2@@Z | ds01432.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1455 | __addsf3 | ?Size@CBitMapAllocator@@QAEHXZ | ds01455.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1504 | __builtin_delete | ?Terminate@CSession@@QBEXH@Z | ds01504.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1505 | __builtin_new | ?Terminate@RMessage@@QBEXH@Z | ds01505.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1506 | __builtin_vec_delete | ?Terminate@RProcess@@QAEXH@Z | ds01506.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1507 | __builtin_vec_new | ?Terminate@RThread@@QAEXH@Z | ds01507.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1514 | __divsi3 | ?TokenLength@TLex16@@QBEHVTLexMark16@@@Z | ds01514.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1515 | __dv__C6TInt64RC6TInt64 | ?TokenLength@TLex8@@QBEHVTLexMark8@@@Z | ds01515.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1520 | __eq__C6TInt64RC6TInt64 | ?TrapHandler@User@@SAPAVTTrapHandler@@XZ | ds01520.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1527 | __fixsfsi | ?TrimRight@TDes16@@QAEXXZ | ds01527.o | 644 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1529 | __floatsisf | ?Type@RHeap@@QBE?AW4THeapType@RHeapBase@@XZ | ds01529.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1557 | __mi__C6TInt64RC6TInt64 | ?Val@TLex16@@QAEHAANVTChar@@@Z | ds01557.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1569 | __modsi3 | ?Val@TLex8@@QAEHAAKW4TRadix@@I@Z | ds01569.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1571 | __mulsf3 | ?Val@TLex8@@QAEHAAMVTChar@@@Z | ds01571.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1575 | __ne__C6TInt64RC6TInt64 | ?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z | ds01575.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1582 | __nw__5CBaseUi | ?Wait@RSemaphore@@QAEXXZ | ds01582.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1611 | __pure_virtual | ?WritePasswordData@TBusLocalDrive@@SAHAAVTDesC8@@@Z | ds01611.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1614 | __subsf3 | ?WsSwitchOnScreen@UserSvr@@SAXXZ | ds01614.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1616 | __udivsi3 | ?Zero@TDes16@@QAEXXZ | ds01616.o | 644 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1636 | __divdi3 | ?__DbgTestInvariant@TPtr8@@QBEXXZ | ds01636.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## EZLIB.LIB

- dt.o: 395 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_EZLIB_LIB_iname
- dh.o: 538 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_EZLIB_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_EZLIB_LIB_iname
- Archive members: 69; dsNNNNN ordinal-like members: 67
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 65 | uncompress__FPUcPUlPCUcUl | ?uncompress@@YAHPAEPAKPBEK@Z | ds00065.o | 695 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## FBSCLI.LIB

- dt.o: 400 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_FBSCLI_LIB_iname
- dh.o: 540 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_FBSCLI_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_FBSCLI_LIB_iname
- Archive members: 157; dsNNNNN ordinal-like members: 155
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 16 | Create__10CFbsBitmapRC5TSize12TDisplayMode | ?Alloc@CChunkPile@@QAEPAEIPAVCBitwiseBitmap@@@Z | ds00016.o | 747 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 17 | DataAddress__C10CFbsBitmap | ?AscentInPixels@CFbsFont@@UBEHXZ | ds00017.o | 699 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | DisplayMode__C10CFbsBitmap | ?CallBack@RFbsSession@@QAEXXZ | ds00021.o | 699 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 76 | Load__10CFbsBitmapRC7TDesC16li | ?IncYPos@TBitmapUtil@@QAEXXZ | ds00076.o | 711 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 110 | SizeInPixels__C10CFbsBitmap | ?Save@CFbsBitmapAsyncStreamer@@QAEHABVTDesC16@@PAVCFbsBitmap@@AAJAAH@Z | ds00110.o | 702 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 135 | __10CFbsBitmap | ?UnlockHeap@CFbsBitmap@@IBEXH@Z | ds00135.o | 663 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## GAMECOMMS.LIB

- ARM UREL import library absent from this SDK tree.

## GDI.LIB

- dt.o: 393 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_GDI_LIB_iname
- dh.o: 534 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_GDI_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_GDI_LIB_iname
- Archive members: 197; dsNNNNN ordinal-like members: 195
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 101 | SetPosture__10TFontStyle12TFontPosture | ?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z | ds00101.o | 732 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 108 | SetStrokeWeight__10TFontStyle17TFontStrokeWeight | ?NewL@CPalette@@SAPAV1@H@Z | ds00108.o | 762 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 151 | __9TFontSpecRC7TDesC16i | ?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z | ds00151.o | 687 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## HAL.LIB

- dt.o: 390 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - _____EPOC32_RELEASE_ARMI_UREL_HAL_LIB_iname
- dh.o: 528 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head____EPOC32_RELEASE_ARMI_UREL_HAL_LIB
  - _____EPOC32_RELEASE_ARMI_UREL_HAL_LIB_iname
- Archive members: 5; dsNNNNN ordinal-like members: 3
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 1 | Get__3HALQ27HALData10TAttributeRi | ?Get@HAL@@SAHW4TAttribute@HALData@@AAH@Z | ds00001.o | 714 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## MEDIACLIENTAUDIOSTREAM.LIB

- dt.o: 432 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_MEDIACLIENTAUDIOSTREAM_LIB_iname
- dh.o: 572 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_MEDIACLIENTAUDIOSTREAM_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_MEDIACLIENTAUDIOSTREAM_LIB_iname
- Archive members: 3; dsNNNNN ordinal-like members: 1
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 1 | NewL__21CMdaAudioOutputStreamR29MMdaAudioOutputStreamCallbackP10CMdaServer | ?NewL@CMdaAudioOutputStream@@SAPAV1@AAVMMdaAudioOutputStreamCallback@@PAVCMdaServer@@@Z | ds00001.o | 859 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## MSGS.LIB

- dt.o: 394 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_MSGS_LIB_iname
- dh.o: 536 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_MSGS_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_MSGS_LIB_iname
- Archive members: 375; dsNNNNN ordinal-like members: 373
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 3 | AddObserverL__11CMsvSessionR19MMsvSessionObserver | ??0CMsgActive@@IAE@H@Z | ds00003.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | OpenAsyncL__11CMsvSessionR19MMsvSessionObserver | ?HasDirectoryL@CMsvServerEntry@@QBEHXZ | ds00143.o | 760 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | RemoveObserver__11CMsvSessionR19MMsvSessionObserver | ?NewL@CMsvServerEntry@@SAPAV1@AAVCMsvServer@@J@Z | ds00185.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

## SIMKIN.LIB

- ARM UREL import library absent from this SDK tree.

## WS32.LIB

- dt.o: 394 bytes; strings=10; named strings=3
  - @.idata$5
  - @.idata$7
  - ________EPOC32_RELEASE_ARMI_UREL_WS32_LIB_iname
- dh.o: 536 bytes; strings=12; named strings=4
  - @.idata$5
  - @.idata$4
  - _head_______EPOC32_RELEASE_ARMI_UREL_WS32_LIB
  - ________EPOC32_RELEASE_ARMI_UREL_WS32_LIB_iname
- Archive members: 359; dsNNNNN ordinal-like members: 357
| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |
|---:|---|---|---:|---:|---|
| 43 | Connect__10RWsSession | ?BitBlt@CWindowGc@@UAEXABVTPoint@@PBVCWsBitmap@@@Z | ds00043.o | 682 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | Close__10RWsSession | ?Construct@CWsScreenDevice@@QAEHXZ | ds00074.o | 676 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 109 | Flush__10RWsSession | ?DrawEllipse@CWindowGc@@UAEXABVTRect@@@Z | ds00109.o | 676 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 268 | __10RWsSession | ?SetWindowGroupOrdinalPosition@RWsSession@@QAEHHH@Z | ds00268.o | 661 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
