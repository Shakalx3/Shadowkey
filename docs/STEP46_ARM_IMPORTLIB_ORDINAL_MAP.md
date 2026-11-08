# Step 46 — ARM UREL import-library ordinal cross-check

This report inspects ARM UREL import-library members and compares their extracted symbol evidence with the WINS UDEB COFF import-library names recorded in Step 44. A dsNNNNN.o member name alone is only an ordinal candidate, not proof of symbol identity.

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 3 | ??0CApaFileRecognizerType@@IAE@XZ | ds00003.o | 714 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 6 | ??0TApaAppEntry@@QAE@XZ | ds00006.o | 702 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 27 | ?ConstructL@CApaProcess@@IAEXXZ | ds00027.o | 708 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 71 | ?Reserved_2@CApaDocument@@EAEXXZ | ds00071.o | 723 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 63 | ??0CAknIpFieldSettingPage@@QAE@PBVTDesC16@@HHHHAAVTInetAddr@@@Z | ds00063.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 662 | ?ConstructL@CAknPopupSettingList@@QAEXXZ | ds00662.o | 755 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 750 | ?CreateNavigationLabelL@CAknNavigationControlContainer@@QAEPAVCAknNavigationDecorator@@ABVTDesC16@@@Z | ds00750.o | 776 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 757 | ?CreateTabGroupL@CAknNavigationControlContainer@@UAEPAVCAknNavigationDecorator@@XZ | ds00757.o | 725 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 802 | ?DiscardFont@CAknAnimatedGc@@MAEXXZ | ds00802.o | 734 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 803 | ?DismissL@CAknSettingPage@@IAEXH@Z | ds00803.o | 743 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 805 | ?DisplayMenuL@CAknDialog@@IAEXXZ | ds00805.o | 770 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 808 | ?DoMoveL@CAknGridView@@IAEXW4TCursorMovement@CListBoxView@@W4TSelectionMode@3@@Z | ds00808.o | 773 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 874 | ?DrawItem@CSingleHeadingStyleItemDrawer@@UBEXHVTPoint@@HHHH@Z | ds00874.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1206 | ?LayoutText@TAknLayoutText@@QAEXABVTRect@@ABVTAknTextLineLayout@@PBVCFont@@@Z | ds01206.o | 734 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1213 | ?ListBox@CAknPopupList@@QAEPAVCEikListBox@@XZ | ds01213.o | 716 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1234 | ?LogicalPosFromDataIndex@CAknGridView@@QBEXHAAH0@Z | ds01234.o | 725 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1254 | ?MaxTextLength@CAknQueryDialog@@SAHPBVCAknQueryControl@@ABVTDes16@@H@Z | ds01254.o | 695 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1267 | ?MdcaCount@CAknQueryValueNumberArray@@UBEHXZ | ds01267.o | 704 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1272 | ?MdcaCount@CSelectionItemList@@UBEHXZ | ds01272.o | 725 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1348 | ?MoveToNextOrPreviousItemL@CAknGrid@@IAEXVTPoint@@@Z | ds01348.o | 713 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1352 | ?NeedToDismissQueryL@CAknMultiLineDataQueryDialog@@MAEHABUTKeyEvent@@@Z | ds01352.o | 719 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1529 | ?PreLayoutDynInitL@CAknProgressDialog@@MAEXXZ | ds01529.o | 755 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2048 | ?SizeChanged@CAknDoubleTimeStyleListBox@@UAEXXZ | ds02048.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2105 | ?StopSchedulerWaitWithBusyMessage@CAknEnv@@SAXAAVCActiveSchedulerWait@@@Z | ds02105.o | 689 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 23 | ?CancelSprite@CFbsScreenDevice@@UBEXXZ | ds00023.o | 738 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | ?HorizontalTwipsToPixels@CFbsBitmapDevice@@UBEHH@Z | ds00086.o | 732 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 112 | ?Resize@CFbsBitmapDevice@@QAEHABVTSize@@@Z | ds00112.o | 729 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 120 | ?SetClippingRegion@CFbsBitGc@@QAEXPBVTRegion@@@Z | ds00120.o | 699 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 123 | ?SetOrigin@CFbsBitGc@@UAEXABVTPoint@@@Z | ds00123.o | 753 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 3 | ??0CCoeControl@@QAE@XZ | ds00003.o | 691 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 12 | ??8TCoeHelpContext@@QBEHABV0@@Z | ds00012.o | 736 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 28 | ?AllocReadResourceAsDes16L@CCoeEnv@@QBEPAVHBufC16@@H@Z | ds00028.o | 718 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | ?AllocReadResourceAsDes16LC@CCoeEnv@@QBEPAVHBufC16@@H@Z | ds00029.o | 784 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 33 | ?BackedUpWindow@CCoeControl@@IBEAAVRBackedUpWindow@@XZ | ds00033.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 40 | ?CloseWindow@CCoeControl@@IAEXXZ | ds00040.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 55 | ?CreateWindowL@CCoeControl@@IAEXPBV1@@Z | ds00055.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 72 | ?ExecuteFepSettingsDialogL@CCoeEnv@@QAEXABVTDesC16@@@Z | ds00072.o | 799 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?SupportsWesternNumericReal@TCoeInputCapabilities@@QBEHXZ | ds00074.o | 763 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | ?Format128@CCoeEnv@@QAAXAAVTDes16@@HZZ | ds00082.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 83 | ?Format256@CCoeEnv@@QAAXAAVTDes16@@HZZ | ds00083.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 84 | ?GetActiveViewId@CCoeAppUi@@QBEHAAVTVwsViewId@@@Z | ds00084.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 87 | ?GetHelpContext@CCoeControl@@UBEXAAVTCoeHelpContext@@@Z | ds00087.o | 727 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 90 | ?HandleComponentControlsResourceChange@CCoeControl@@IAEXH@Z | ds00090.o | 757 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 95 | ?HandleKeyEventL@CCoeAppUiSimple@@EAEXABUTKeyEvent@@W4TEventCode@@@Z | ds00095.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 96 | ?SupportsWesternNumericIntegerNegative@TCoeInputCapabilities@@QBEHXZ | ds00096.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 101 | ?HandleStackChanged@CCoeAppUi@@QAEXXZ | ds00101.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 138 | ?IsVisible@CCoeControl@@QBEHXZ | ds00138.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 139 | ?IsWservEventPending@CCoeEnv@@QBEHXZ | ds00139.o | 697 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | ?MCoeFocusObserver_Reserved_2@MCoeFocusObserver@@EAEXXZ | ds00143.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 147 | ?SupportsNavigation@TCoeInputCapabilities@@QBEHXZ | ds00147.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 153 | ?NameOfInstalledFepL@CCoeEnv@@QAEPAVHBufC16@@XZ | ds00153.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 160 | ?Position@CCoeControl@@QBE?AVTPoint@@XZ | ds00160.o | 679 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 167 | ?PrepareToExit@CCoeAppUiBase@@UAEXXZ | ds00167.o | 742 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 173 | ?Rect@CCoeControl@@QBE?AVTRect@@XZ | ds00173.o | 769 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 177 | ?RemoveFepObserver@CCoeEnv@@QAEXAAVMCoeFepObserver@@@Z | ds00177.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | ?ReportEventL@CCoeControl@@IAEXW4TCoeEvent@MCoeControlObserver@@@Z | ds00185.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 187 | ?Reserved_1@CCoeAppUiBase@@EAEXXZ | ds00187.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 197 | ?RunL@CCoeEnv@@UAEXXZ | ds00197.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 200 | ?SetAndDrawFocus@CCoeAppUi@@EAEXH@Z | ds00200.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 208 | ?SetContainerWindowL@CCoeControl@@QAEXAAVRBackedUpWindow@@@Z | ds00208.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 214 | ?SetExtent@CCoeControl@@QAEXABVTPoint@@ABVTSize@@@Z | ds00214.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 221 | ?SetNeighbor@CCoeControl@@UAEXPAV1@@Z | ds00221.o | 697 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 223 | ?SetObserver@CCoeControl@@QAEXPAVMCoeControlObserver@@@Z | ds00223.o | 667 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 226 | ?SetPosition@CCoeControl@@QAEXABVTPoint@@@Z | ds00226.o | 691 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 232 | ?SetUse@TCoeColorUse@@QAEXH@Z | ds00232.o | 667 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 236 | ?Static@CCoeEnv@@SAPAV1@XZ | ds00236.o | 664 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 255 | ?DisplayError@CCoeScheduler@@UBEXH@Z | ds00255.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 256 | ?FepAwareTextEditor@TCoeInputCapabilities@@QBEPAVMCoeFepAwareTextEditor@@XZ | ds00256.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 292 | ?MCoeViewActivationObserver_Reserved_2@MCoeViewActivationObserver@@EAEXXZ | ds00292.o | 832 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 293 | ?MCoeViewDeactivationObserver_Reserved_1@MCoeViewDeactivationObserver@@EAEXXZ | ds00293.o | 832 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 312 | ?MopNext@CCoeControl@@EAEPAVMObjectProvider@@XZ | ds00312.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 314 | ?MopSupplyObject@CCoeControl@@MAE?AVPtr@TTypeUid@@V3@@Z | ds00314.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 15 | ??1CFileBase@@MAE@XZ | ds00015.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 18 | ??ACDir@@QBEABVTEntry@@H@Z | ds00018.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | ?AbbreviatedPath@CFileBase@@QAE?AVTPtrC16@@XZ | ds00021.o | 707 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 25 | ?Att@RFile@@QBEHAAI@Z | ds00025.o | 713 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | ?BytesTransferredByCopyStep@CFileMan@@QAEHXZ | ds00029.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 33 | ?ClearPassword@RFs@@QAEHHABV?$TBuf8@$0BA@@@@Z | ds00033.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | ?DismountFileSystem@RFs@@QBEHABVTDesC16@@H@Z | ds00051.o | 689 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | ?IsExtWild@TParseBase@@QBEHXZ | ds00086.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 106 | ?Modified@RFile@@QBEHAAVTTime@@@Z | ds00106.o | 680 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 121 | ?NamePresent@TParseBase@@QBEHXZ | ds00121.o | 707 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 136 | ?NotifyFileManOperation@MFileManObserver@@UAE?AW4TControl@1@XZ | ds00136.o | 680 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 146 | ?PathPresent@TParseBase@@QBEHXZ | ds00146.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 162 | ?ReadFileSection@RFs@@QBEHABVTDesC16@@HAAVTDes8@@H@Z | ds00162.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 183 | ?Set@RFile@@QAEHABVTTime@@II@Z | ds00183.o | 722 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | ?Set@TParse@@QAEHABVTDesC16@@PBV2@1@Z | ds00185.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 193 | ?SetErrorCondition@RFs@@QAEHHH@Z | ds00193.o | 704 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 194 | ?SetModified@RFile@@QAEHABVTTime@@@Z | ds00194.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 212 | ?Volume@RFs@@QBEHAAVTVolumeInfo@@H@Z | ds00212.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 230 | ??0TParse@@QAE@XZ | ds00230.o | 647 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 17 | ??1CEikonEnv@@UAE@XZ | ds00017.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 20 | ?AddAlertDialogLikeControlToStackL@CEikonEnv@@QAEXPAVCCoeControl@@@Z | ds00020.o | 727 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 30 | ?AddWindowShadow@CEikonEnv@@SAXPAVCCoeControl@@@Z | ds00030.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 31 | ?AlertWin@CEikonEnv@@QAEXABVTDesC16@@0@Z | ds00031.o | 748 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 40 | ?Application@CEikAppUi@@QBEPAVCEikApplication@@XZ | ds00040.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 48 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@@Z | ds00048.o | 775 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 49 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTGulAlignment@@@Z | ds00049.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTTimeIntervalMicroSeconds32@@@Z | ds00051.o | 721 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 52 | ?BusyMsgL@CEikonEnv@@QAEXH@Z | ds00052.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 61 | ?CommandTailEnd@CEikProcess@@QBE?AVTPtrC16@@XZ | ds00061.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 64 | ?ConstructL@CEikAppUi@@UAEXXZ | ds00064.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 65 | ?ConstructL@CEikEmbeddableAppList@@QAEXXZ | ds00065.o | 778 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 66 | ?ConstructL@CEikMsgWin@@QAEXAAVRWindowGroup@@@Z | ds00066.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 67 | ?ConstructL@CEikonEnv@@QAEXXZ | ds00067.o | 670 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 68 | ?ControlColor@CEikonEnv@@QBE?AVTRgb@@W4TLogicalColor@@ABVCCoeControl@@@Z | ds00068.o | 754 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 71 | ?CreateByTypeL@EikControlFactory@@SA?AUSEikControlInfo@@H@Z | ds00071.o | 796 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?CreateCustomCommandControlL@MEikCommandObserver@@UAEPAVCCoeControl@@H@Z | ds00074.o | 787 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 75 | ?CreateDocumentL@CEikApplication@@MAEPAVCApaDocument@@PAVCApaProcess@@@Z | ds00075.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 76 | ?CreateEmbeddedDocumentL@CEikEmbeddableAppList@@QAEPAVCEikDocument@@HPAVCApaProcess@@@Z | ds00076.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 80 | ?CreateIconFromMaskedBitmapL@CEikonEnv@@SAPAVCGulIcon@@ABVCApaMaskedBitmap@@@Z | ds00080.o | 751 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 81 | ?CreateIconL@CEikonEnv@@QAEPAVCGulIcon@@ABVTDesC16@@HH@Z | ds00081.o | 712 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | ?CreateScreenFontL@EikResourceUtils@@SAPAVCFbsFont@@HPAVCEikonEnv@@@Z | ds00082.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 84 | ?DefaultDisplayMode@CEikonEnv@@QBE?AW4TDisplayMode@@XZ | ds00084.o | 802 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | ?DestroyEnvironment@CEikonEnv@@MAEXXZ | ds00086.o | 703 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 100 | ?ExternalizeL@CEikDocument@@UBEXAAVRWriteStream@@@Z | ds00100.o | 694 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 116 | ?HandleModelChangeL@CEikAppUi@@UAEXXZ | ds00116.o | 706 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 121 | ?HandleWsEventL@CAknWsEventMonitor@@UAEXABVTWsEvent@@PAVCCoeControl@@@Z | ds00121.o | 796 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 122 | ?HandleWsEventL@CEikAppUi@@MAEXABVTWsEvent@@PAVCCoeControl@@@Z | ds00122.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 123 | ?HasChanged@CEikDocument@@UBEHXZ | ds00123.o | 745 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 124 | ?HideCursor@CEikonEnv@@QAEXPBVCCoeControl@@@Z | ds00124.o | 715 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 130 | ?InfoMsgCancel@CEikonEnv@@QAEXXZ | ds00130.o | 736 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 133 | ?InfoMsgWithAlignment@CEikonEnv@@QAEXVTGulAlignment@@HQAPAC@Z | ds00133.o | 835 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 134 | ?InfoMsgWithAlignmentAndDuration@CEikonEnv@@QAAXVTGulAlignment@@HVTTimeIntervalMicroSeconds32@@ZZ | ds00134.o | 748 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 142 | ?InitSystemFontsL@CEikonEnv@@EAEXXZ | ds00142.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | ?InternalizeL@@YAXAAW4TEikPortFlag@@AAVRReadStream@@@Z | ds00143.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 144 | ?IsBusy@CEikonEnv@@QBEHXZ | ds00144.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 146 | ?IsForeground@CEikAppUi@@QBEHXZ | ds00146.o | 700 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 147 | ?IsSystem@CEikonEnv@@QBEHXZ | ds00147.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 149 | ?LafEnv@CEikonEnv@@QBEAAVMLafEnv@@XZ | ds00149.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 150 | ?LastUsedFileL@CEikProcess@@QBE?AV?$TBuf@$0BAA@@@W4TLastUsedFile@1@@Z | ds00150.o | 688 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 151 | ?LaunchPopupMenuL@CEikAppUi@@QAEXHABVTPoint@@W4TPopupTargetPosType@@PBVCEikHotKeyTable@@@Z | ds00151.o | 730 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 155 | ?LegendFont@CEikonEnv@@QBEPBVCFont@@XZ | ds00155.o | 805 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 157 | ?MEikPictureFactory_Reserved_2@MEikPictureFactory@@EAEXXZ | ds00157.o | 853 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 161 | ?MdcaPoint@CEikEmbeddableAppList@@EBE?AVTPtrC16@@H@Z | ds00161.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 179 | ?PictureFactory@CEikonEnv@@QBEPAVMPictureFactory@@XZ | ds00179.o | 736 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 198 | ?RemoveObserver@CAknWsEventMonitor@@QAEXPBVMAknWsEventObserver@@@Z | ds00198.o | 721 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 200 | ?ReportResourceChangedToAppL@CEikAppUi@@QAEXH@Z | ds00200.o | 796 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 204 | ?Reserved_1@CEikDocument@@EAEXXZ | ds00204.o | 781 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 206 | ?Reserved_1_MenuObserver@MEikAutoMenuObserver@@EAEXXZ | ds00206.o | 718 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 213 | ?ResourceFileName@CEikApplication@@UBE?AV?$TBuf@$0BAA@@@XZ | ds00213.o | 673 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 214 | ?ResourceFileVersionNumber@CEikonEnv@@EBEHXZ | ds00214.o | 682 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 219 | ?RestoreMenuL@MEikMenuObserver@@UAEXPAVCCoeControl@@HW4TMenuType@1@@Z | ds00219.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 222 | ?SaveAnyChangesL@CEikAppUi@@IAEXXZ | ds00222.o | 679 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 224 | ?SaveL@CEikDocument@@UAEXW4TSaveType@MSaveObserver@@@Z | ds00224.o | 658 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 226 | ?SaveToDirectFileStoreL@CEikProcess@@QAEXPAVCEikDocument@@PBV?$TBuf@$0BAA@@@@Z | ds00226.o | 751 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 233 | ?SetBusy@CEikonEnv@@QAEXH@Z | ds00233.o | 706 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 243 | ?SetEmphasis@MEikAutoMenuObserver@@UAEXPAVCCoeControl@@H@Z | ds00243.o | 691 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 253 | ?SetRespondsToSwitchFilesEvent@CEikonEnv@@QAEXH@Z | ds00253.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 264 | ?StopDisplayingMenuBar@CEikAppUi@@UAEXXZ | ds00264.o | 733 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 290 | ?IsPartialForeground@CEikAppUi@@QBEHXZ | ds00290.o | 679 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 45 | ?Cancel@RMBufAsyncRequest@@QAEXXZ | ds00045.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 48 | ?CancelAccept@RSocket@@QAEXXZ | ds00048.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 62 | ?Close@RSocket@@QAEXXZ | ds00062.o | 785 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 87 | ?Free@RMBuf@@QAEXXZ | ds00087.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 129 | ?Name@RSocket@@QAEHAAV?$TBuf@$0IA@@@@Z | ds00129.o | 722 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 209 | ?StopProtocol@RSocketServ@@QAEXIIIAAVTRequestStatus@@@Z | ds00209.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 217 | ?Version@RSocketServ@@QBE?AVTVersion@@XZ | ds00217.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 3 | _malloc | ds00003.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 6 | _free | ds00006.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 9 | _strlen | ds00009.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 49 | _fclose | ds00049.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | _feof | ds00051.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 56 | _fgets | ds00056.o | 630 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 58 | _fopen | ds00058.o | 630 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 59 | _fprintf | ds00059.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 64 | _fscanf | ds00064.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 65 | _fseek | ds00065.o | 630 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | _sprintf | ds00082.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 83 | _sscanf | ds00083.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 128 | _atoi | ds00128.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 157 | _time | ds00157.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 171 | _toupper | ds00171.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 173 | _memchr | ds00173.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 174 | _memcmp | ds00174.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 177 | _strcasecmp | ds00177.o | 651 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 178 | _strcat | ds00178.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 180 | _strcmp | ds00180.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 181 | _strcpy | ds00181.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 187 | _strncmp | ds00187.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 188 | _strncpy | ds00188.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 193 | _strtok | ds00193.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 291 | _wait | ds00291.o | 654 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 315 | _wclosedir | ds00315.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 316 | _wcscat | ds00316.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 317 | _wcscmp | ds00317.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 342 | _wcsdup | ds00342.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 26 | ??1CTelObject@@UAE@XZ | ds00026.o | 658 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 27 | ?AcquireOwnership@RCall@@QBEXAAVTRequestStatus@@@Z | ds00027.o | 661 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | ?AnswerIncomingCall@RCall@@QAEXAAVTRequestStatus@@@Z | ds00029.o | 685 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 55 | ?Connect@RCall@@QAEXAAVTRequestStatus@@ABVTDesC8@@@Z | ds00055.o | 697 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 56 | ?Connect@RCall@@QBEHABVTDesC8@@@Z | ds00056.o | 715 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 72 | ?Destruct@RLine@@MAEXXZ | ds00072.o | 745 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?Dial@RCall@@QAEXAAVTRequestStatus@@ABVTDesC16@@@Z | ds00074.o | 784 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 77 | ?Dial@RCall@@QBEHABVTDesC8@@ABVTDesC16@@@Z | ds00077.o | 724 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 102 | ?GetFaxSettings@RCall@@QBEHAAUTFaxSessionSettings@1@@Z | ds00102.o | 739 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 125 | ?IsDefault@TCallParams@RCall@@QAEHXZ | ds00125.o | 718 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 127 | ?LoadPhoneModule@RTelServer@@QBEHABVTDesC16@@@Z | ds00127.o | 799 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 152 | ?NotifyStatusChangeCancel@RLine@@QBEXXZ | ds00152.o | 709 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 153 | ?NullMethod1@CSubSessionExtBase@@IAEXXZ | ds00153.o | 727 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 204 | ?Set@RTelSubSessionBase@@IBEXHAAVTRequestStatus@@ABVTDesC16@@1W4TReqPriorityType@1@@Z | ds00204.o | 661 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 210 | ?SetFaxSettings@RCall@@QBEHABUTFaxSessionSettings@1@@Z | ds00210.o | 634 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 211 | ?SetOwnership@CCallBase@@UAEHK@Z | ds00211.o | 646 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 1 | __ftol | ds00001.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2 | ??0CActive@@IAE@H@Z | ds00002.o | 628 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 3 | ??0CActiveScheduler@@QAE@XZ | ds00003.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 13 | ??0CBufFlat@@IAE@H@Z | ds00013.o | 713 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | ??0CIdle@@IAE@H@Z | ds00021.o | 743 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 35 | ??0MBusDev@@QAE@XZ | ds00035.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 41 | ??0RHeap@@IAE@H@Z | ds00041.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 45 | ??0RPointerArrayBase@@IAE@XZ | ds00045.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 77 | ??0TDayName@@QAE@W4TDay@@@Z | ds00077.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 85 | ??0TDeltaQueBase@@IAE@XZ | ds00085.o | 680 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 89 | ??0THeapWalk@@QAE@ABVRHeap@@@Z | ds00089.o | 683 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 90 | ??0TInt64@@QAE@H@Z | ds00090.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 91 | ??0TInt64@@QAE@N@Z | ds00091.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 99 | ??0TKeyArrayPak@@QAE@HW4TKeyCmpNumeric@@@Z | ds00099.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 152 | ??0TTime@@QAE@ABVTDateTime@@@Z | ds00152.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 172 | ??1CBufSeg@@UAE@XZ | ds00172.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 207 | ??8TPoint@@QBEHABV0@@Z | ds00207.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 211 | ??8TUidType@@QBEHABV0@@Z | ds00211.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 245 | ??GTSize@@QBE?AV0@ABVTPoint@@@Z | ds00245.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 248 | ??GTTime@@QBE?AV0@VTTimeIntervalHours@@@Z | ds00248.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 251 | ??GTTime@@QBE?AV0@VTTimeIntervalMinutes@@@Z | ds00251.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 274 | ??LTRealX@@QBE?AV0@ABV0@@Z | ds00274.o | 764 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 289 | ??YTTime@@QAEAAV0@VTTimeIntervalDays@@@Z | ds00289.o | 779 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 411 | ?Assign@TLex16@@QAEXABVTDesC16@@@Z | ds00411.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 418 | ?At@CObjectCon@@QBEPAVCObject@@H@Z | ds00418.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 467 | ?Cancel@RServer@@QAEXXZ | ds00467.o | 743 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 476 | ?ChangeLocale@UserSvr@@SAHVRLibrary@@@Z | ds00476.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 501 | ?Collate@TDes16@@QAEXXZ | ds00501.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 530 | ?Compress@CArrayPakBase@@QAEXXZ | ds00530.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 531 | ?Compress@CArrayVarBase@@QAEXXZ | ds00531.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 569 | ?CopyLC@TDes8@@QAEXABVTDesC8@@@Z | ds00569.o | 755 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 621 | ?DaysFrom@TTime@@QBE?AVTTimeIntervalDays@@V1@@Z | ds00621.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 625 | ?DebugThreadPanic@@YAXKABVTDesC16@@0H@Z | ds00625.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 627 | ?Decompose@TChar@@QBEHAAVTPtrC16@@@Z | ds00627.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 630 | ?Delete@CArrayFixBase@@QAEXHH@Z | ds00630.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 632 | ?Delete@CArrayPakBase@@QAEXHH@Z | ds00632.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 711 | ?EmulatorDataPath@@YA?AVTPtrC16@@XZ | ds00711.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 738 | ?FRand@Math@@SANAAVTInt64@@@Z | ds00738.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 746 | ?Fill@TDes16@@QAEXVTChar@@@Z | ds00746.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 809 | ?Free@User@@SAXPAX@Z | ds00809.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 824 | ?GetCategory@TChar@@QBE?AW4TCategory@1@XZ | ds00824.o | 704 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 825 | ?GetCategory@TUnicode@@QBE?AW4TCategory@TChar@@PBUTUnicodeDataSet@@@Z | ds00825.o | 707 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 828 | ?GetCurrentDirectoryU@@YAP6GKKPAG@ZXZ | ds00828.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 855 | ?GetTitleCase@TChar@@QBEIXZ | ds00855.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 856 | ?GetUpperCase@TChar@@QBEIXZ | ds00856.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 858 | ?GetVolumeInformationU@@YAP6GHPBGPAGKPAK221K@ZXZ | ds00858.o | 701 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 869 | ?HandleInfo@RHandleBase@@QAEXPAVTHandleInfo@@@Z | ds00869.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 875 | ?HeapSortSigned@RPointerArrayBase@@IAEXXZ | ds00875.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 933 | ?IsContainedBy@TRegion@@QBEHABVTRect@@@Z | ds00933.o | 695 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 954 | ?IsNaN@TRealX@@QBEHXZ | ds00954.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 956 | ?IsPresent@TUidType@@QBEHVTUid@@@Z | ds00956.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 962 | ?IsUpper@TChar@@QBEHXZ | ds00962.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 979 | ?LeaveIfError@User@@SAHH@Z | ds00979.o | 674 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1016 | ?Logon@RProcess@@QBEXAAVTRequestStatus@@@Z | ds01016.o | 734 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1078 | ?Neg@TInt64A@@QAEXXZ | ds01078.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1086 | ?New@HBufC8@@SAPAV1@H@Z | ds01086.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1107 | ?NewMax@HBufC8@@SAPAV1@H@Z | ds01107.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1111 | ?NewMaxLC@HBufC8@@SAPAV1@H@Z | ds01111.o | 797 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1113 | ?Next@TFindChunk@@QAEHAAV?$TBuf@$0BAA@@@@Z | ds01113.o | 689 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1122 | ?Next@TFindThread@@QAEHAAV?$TBuf@$0BAA@@@@Z | ds01122.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1148 | ?Offset@TLex8@@QBEHXZ | ds01148.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1164 | ?OpenGlobal@RSemaphore@@QAEHABVTDesC16@@W4TOwnerType@@@Z | ds01164.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1212 | ?Protected@RThread@@QBEHXZ | ds01212.o | 671 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1246 | ?Read@TBusLocalDrive@@QAEHVTInt64@@HPBXHH@Z | ds01246.o | 653 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1247 | ?ReadL@CSession@@QBEXPBXAAVTDes16@@@Z | ds01247.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1262 | ?RectangleListW@TRegion@@IAEPAVTRect@@XZ | ds01262.o | 644 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1265 | ?RegisterClassU@@YAP6GGPBUtagWNDCLASSW@@@ZXZ | ds01265.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1282 | ?Rename@RProcess@@QAEHABVTDesC16@@@Z | ds01282.o | 692 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1283 | ?Rename@RThread@@QBEHABVTDesC16@@@Z | ds01283.o | 662 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1343 | ?ServerStarted@UserSvr@@SAXXZ | ds01343.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1359 | ?Set@TLongDateFormatSpec@@QAEXXZ | ds01359.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1366 | ?Set@TRealX@@QAEHH@Z | ds01366.o | 653 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1367 | ?Set@TRealX@@QAEHI@Z | ds01367.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1370 | ?Set@TShortDateFormatSpec@@QAEXXZ | ds01370.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1373 | ?SetActive@CActive@@IAEXXZ | ds01373.o | 653 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1379 | ?SetEnabled@Password@@SAHABV?$TBuf@$0BA@@@H@Z | ds01379.o | 647 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1386 | ?SetHour@TDateTime@@QAEHH@Z | ds01386.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1395 | ?SetLength@TDes8@@QAEXH@Z | ds01395.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1407 | ?SetOffset@TDblQueBase@@QAEXH@Z | ds01407.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1422 | ?SetReserveFlatL@CArrayFixBase@@IAEXH@Z | ds01422.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1431 | ?SetToLast@TDblQueIterBase@@QAEXXZ | ds01431.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1432 | ?SetTrapHandler@User@@SAPAVTTrapHandler@@PAV2@@Z | ds01432.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1455 | ?Size@CBitMapAllocator@@QAEHXZ | ds01455.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1504 | ?Terminate@CSession@@QBEXH@Z | ds01504.o | 665 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1505 | ?Terminate@RMessage@@QBEXH@Z | ds01505.o | 656 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1506 | ?Terminate@RProcess@@QAEXH@Z | ds01506.o | 677 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1507 | ?Terminate@RThread@@QAEXH@Z | ds01507.o | 668 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1514 | ?TokenLength@TLex16@@QBEHVTLexMark16@@@Z | ds01514.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1515 | ?TokenLength@TLex8@@QBEHVTLexMark8@@@Z | ds01515.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1520 | ?TrapHandler@User@@SAPAVTTrapHandler@@XZ | ds01520.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1527 | ?TrimRight@TDes16@@QAEXXZ | ds01527.o | 644 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1529 | ?Type@RHeap@@QBE?AW4THeapType@RHeapBase@@XZ | ds01529.o | 650 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1557 | ?Val@TLex16@@QAEHAANVTChar@@@Z | ds01557.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1569 | ?Val@TLex8@@QAEHAAKW4TRadix@@I@Z | ds01569.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1571 | ?Val@TLex8@@QAEHAAMVTChar@@@Z | ds01571.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1575 | ?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z | ds01575.o | 686 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1582 | ?Wait@RSemaphore@@QAEXXZ | ds01582.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1611 | ?WritePasswordData@TBusLocalDrive@@SAHAAVTDesC8@@@Z | ds01611.o | 659 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1614 | ?WsSwitchOnScreen@UserSvr@@SAXXZ | ds01614.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1616 | ?Zero@TDes16@@QAEXXZ | ds01616.o | 644 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1636 | ?__DbgTestInvariant@TPtr8@@QBEXXZ | ds01636.o | 632 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 65 | ?uncompress@@YAHPAEPAKPBEK@Z | ds00065.o | 695 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 16 | ?Alloc@CChunkPile@@QAEPAEIPAVCBitwiseBitmap@@@Z | ds00016.o | 747 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 17 | ?AscentInPixels@CFbsFont@@UBEHXZ | ds00017.o | 699 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | ?CallBack@RFbsSession@@QAEXXZ | ds00021.o | 699 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 76 | ?IncYPos@TBitmapUtil@@QAEXXZ | ds00076.o | 711 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 110 | ?Save@CFbsBitmapAsyncStreamer@@QAEHABVTDesC16@@PAVCFbsBitmap@@AAJAAH@Z | ds00110.o | 702 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 135 | ?UnlockHeap@CFbsBitmap@@IBEXH@Z | ds00135.o | 663 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 101 | ?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z | ds00101.o | 732 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 108 | ?NewL@CPalette@@SAPAV1@H@Z | ds00108.o | 762 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 151 | ?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z | ds00151.o | 687 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 1 | ?Get@HAL@@SAHW4TAttribute@HALData@@AAH@Z | ds00001.o | 714 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 1 | ?NewL@CMdaAudioOutputStream@@SAPAV1@AAVMMdaAudioOutputStreamCallback@@PAVCMdaServer@@@Z | ds00001.o | 859 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 3 | ??0CMsgActive@@IAE@H@Z | ds00003.o | 766 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | ?HasDirectoryL@CMsvServerEntry@@QBEHXZ | ds00143.o | 760 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | ?NewL@CMsvServerEntry@@SAPAV1@AAVCMsvServer@@J@Z | ds00185.o | 772 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |
|---:|---|---|---:|---|
| 43 | ?BitBlt@CWindowGc@@UAEXABVTPoint@@PBVCWsBitmap@@@Z | ds00043.o | 682 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?Construct@CWsScreenDevice@@QAEHXZ | ds00074.o | 676 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 109 | ?DrawEllipse@CWindowGc@@UAEXABVTRect@@@Z | ds00109.o | 676 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 268 | ?SetWindowGroupOrdinalPosition@RWsSession@@QAEHHH@Z | ds00268.o | 661 | .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
