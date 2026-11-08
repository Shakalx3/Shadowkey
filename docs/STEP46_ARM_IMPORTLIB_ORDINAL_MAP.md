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
| 3 | ??0CApaFileRecognizerType@@IAE@XZ | ds00003.o | 714 | AR_INDEX:AppFullName__C15CApaApplication; AR_INDEX:__imp_AppFullName__C15CApaApplication; AR_INDEX:_imp__AppFullName__C15CApaApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 6 | ??0TApaAppEntry@@QAE@XZ | ds00006.o | 702 | AR_INDEX:Capability__C12CApaDocument; AR_INDEX:__imp_Capability__C12CApaDocument; AR_INDEX:_imp__Capability__C12CApaDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 27 | ?ConstructL@CApaProcess@@IAEXXZ | ds00027.o | 708 | AR_INDEX:GlassPictureL__12CApaDocument; AR_INDEX:__imp_GlassPictureL__12CApaDocument; AR_INDEX:_imp__GlassPictureL__12CApaDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 71 | ?Reserved_2@CApaDocument@@EAEXXZ | ds00071.o | 723 | AR_INDEX:ValidatePasswordL__C12CApaDocument; AR_INDEX:__imp_ValidatePasswordL__C12CApaDocument; AR_INDEX:_imp__ValidatePasswordL__C12CApaDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 63 | ??0CAknIpFieldSettingPage@@QAE@PBVTDesC16@@HHHHAAVTInetAddr@@@Z | ds00063.o | 701 | AR_INDEX:BaseConstructL__9CAknAppUii; AR_INDEX:__imp_BaseConstructL__9CAknAppUii; AR_INDEX:_imp__BaseConstructL__9CAknAppUii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 662 | ?ConstructL@CAknPopupSettingList@@QAEXXZ | ds00662.o | 755 | AR_INDEX:ExecuteLD__22CAknResourceNoteDialogRC7TDesC16; AR_INDEX:__imp_ExecuteLD__22CAknResourceNoteDialogRC7TDesC16; AR_INDEX:_imp__ExecuteLD__22CAknResourceNoteDialogRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 750 | ?CreateNavigationLabelL@CAknNavigationControlContainer@@QAEPAVCAknNavigationDecorator@@ABVTDesC16@@@Z | ds00750.o | 776 | AR_INDEX:HandleError__9CAknAppUiiRC14SExtendedErrorR6TDes16T3; AR_INDEX:__imp_HandleError__9CAknAppUiiRC14SExtendedErrorR6TDes16T3; AR_INDEX:_imp__HandleError__9CAknAppUiiRC14SExtendedErrorR6TDes16T3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 757 | ?CreateTabGroupL@CAknNavigationControlContainer@@UAEPAVCAknNavigationDecorator@@XZ | ds00757.o | 725 | AR_INDEX:HandleForegroundEventL__9CAknAppUii; AR_INDEX:__imp_HandleForegroundEventL__9CAknAppUii; AR_INDEX:_imp__HandleForegroundEventL__9CAknAppUii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 802 | ?DiscardFont@CAknAnimatedGc@@MAEXXZ | ds00802.o | 734 | AR_INDEX:HandleStatusPaneSizeChange__9CAknAppUi; AR_INDEX:__imp_HandleStatusPaneSizeChange__9CAknAppUi; AR_INDEX:_imp__HandleStatusPaneSizeChange__9CAknAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 803 | ?DismissL@CAknSettingPage@@IAEXH@Z | ds00803.o | 743 | AR_INDEX:HandleSystemEventL__9CAknAppUiRC8TWsEvent; AR_INDEX:__imp_HandleSystemEventL__9CAknAppUiRC8TWsEvent; AR_INDEX:_imp__HandleSystemEventL__9CAknAppUiRC8TWsEvent; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 805 | ?DisplayMenuL@CAknDialog@@IAEXXZ | ds00805.o | 770 | AR_INDEX:HandleViewDeactivation__9CAknAppUiRC10TVwsViewIdT1; AR_INDEX:__imp_HandleViewDeactivation__9CAknAppUiRC10TVwsViewIdT1; AR_INDEX:_imp__HandleViewDeactivation__9CAknAppUiRC10TVwsViewIdT1; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 808 | ?DoMoveL@CAknGridView@@IAEXW4TCursorMovement@CListBoxView@@W4TSelectionMode@3@@Z | ds00808.o | 773 | AR_INDEX:HandleWsEventL__9CAknAppUiRC8TWsEventP11CCoeControl; AR_INDEX:__imp_HandleWsEventL__9CAknAppUiRC8TWsEventP11CCoeControl; AR_INDEX:_imp__HandleWsEventL__9CAknAppUiRC8TWsEventP11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 874 | ?DrawItem@CSingleHeadingStyleItemDrawer@@UBEXHVTPoint@@HHHH@Z | ds00874.o | 683 | AR_INDEX:KeySounds__9CAknAppUi; AR_INDEX:__imp_KeySounds__9CAknAppUi; AR_INDEX:_imp__KeySounds__9CAknAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1206 | ?LayoutText@TAknLayoutText@@QAEXABVTRect@@ABVTAknTextLineLayout@@PBVCFont@@@Z | ds01206.o | 734 | AR_INDEX:OpenIniFileLC__C15CAknApplicationR3RFs; AR_INDEX:__imp_OpenIniFileLC__C15CAknApplicationR3RFs; AR_INDEX:_imp__OpenIniFileLC__C15CAknApplicationR3RFs; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1213 | ?ListBox@CAknPopupList@@QAEPAVCEikListBox@@XZ | ds01213.o | 716 | AR_INDEX:PopContext__18CAknKeySoundSystem; AR_INDEX:__imp_PopContext__18CAknKeySoundSystem; AR_INDEX:_imp__PopContext__18CAknKeySoundSystem; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1234 | ?LogicalPosFromDataIndex@CAknGridView@@QBEXHAAH0@Z | ds01234.o | 725 | AR_INDEX:PreDocConstructL__15CAknApplication; AR_INDEX:__imp_PreDocConstructL__15CAknApplication; AR_INDEX:_imp__PreDocConstructL__15CAknApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1254 | ?MaxTextLength@CAknQueryDialog@@SAHPBVCAknQueryControl@@ABVTDes16@@H@Z | ds01254.o | 695 | AR_INDEX:PrepareToExit__9CAknAppUi; AR_INDEX:__imp_PrepareToExit__9CAknAppUi; AR_INDEX:_imp__PrepareToExit__9CAknAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1267 | ?MdcaCount@CAknQueryValueNumberArray@@UBEHXZ | ds01267.o | 704 | AR_INDEX:ProcessCommandL__9CAknAppUii; AR_INDEX:__imp_ProcessCommandL__9CAknAppUii; AR_INDEX:_imp__ProcessCommandL__9CAknAppUii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1272 | ?MdcaCount@CSelectionItemList@@UBEHXZ | ds01272.o | 725 | AR_INDEX:PushContextL__18CAknKeySoundSystemi; AR_INDEX:__imp_PushContextL__18CAknKeySoundSystemi; AR_INDEX:_imp__PushContextL__18CAknKeySoundSystemi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1348 | ?MoveToNextOrPreviousItemL@CAknGrid@@IAEXVTPoint@@@Z | ds01348.o | 713 | AR_INDEX:Reserved_MtsmObject__9CAknAppUi; AR_INDEX:__imp_Reserved_MtsmObject__9CAknAppUi; AR_INDEX:_imp__Reserved_MtsmObject__9CAknAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1352 | ?NeedToDismissQueryL@CAknMultiLineDataQueryDialog@@MAEHABUTKeyEvent@@@Z | ds01352.o | 719 | AR_INDEX:Reserved_MtsmPosition__9CAknAppUi; AR_INDEX:__imp_Reserved_MtsmPosition__9CAknAppUi; AR_INDEX:_imp__Reserved_MtsmPosition__9CAknAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1529 | ?PreLayoutDynInitL@CAknProgressDialog@@MAEXXZ | ds01529.o | 755 | AR_INDEX:SetKeyBlockMode__9CAknAppUi16TAknKeyBlockMode; AR_INDEX:__imp_SetKeyBlockMode__9CAknAppUi16TAknKeyBlockMode; AR_INDEX:_imp__SetKeyBlockMode__9CAknAppUi16TAknKeyBlockMode; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2048 | ?SizeChanged@CAknDoubleTimeStyleListBox@@UAEXXZ | ds02048.o | 659 | AR_INDEX:_._9CAknAppUi; AR_INDEX:__imp__._9CAknAppUi; AR_INDEX:_imp___._9CAknAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2105 | ?StopSchedulerWaitWithBusyMessage@CAknEnv@@SAXAAVCActiveSchedulerWait@@@Z | ds02105.o | 689 | AR_INDEX:__19CAknInformationNote; AR_INDEX:__imp___19CAknInformationNote; AR_INDEX:_imp____19CAknInformationNote; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 23 | ?CancelSprite@CFbsScreenDevice@@UBEXXZ | ds00023.o | 738 | AR_INDEX:CreateContext__10CFbsDeviceRP9CFbsBitGc; AR_INDEX:__imp_CreateContext__10CFbsDeviceRP9CFbsBitGc; AR_INDEX:_imp__CreateContext__10CFbsDeviceRP9CFbsBitGc; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | ?HorizontalTwipsToPixels@CFbsBitmapDevice@@UBEHH@Z | ds00086.o | 732 | AR_INDEX:NewL__16CFbsBitmapDeviceP10CFbsBitmap; AR_INDEX:__imp_NewL__16CFbsBitmapDeviceP10CFbsBitmap; AR_INDEX:_imp__NewL__16CFbsBitmapDeviceP10CFbsBitmap; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 112 | ?Resize@CFbsBitmapDevice@@QAEHABVTSize@@@Z | ds00112.o | 729 | AR_INDEX:SetDitherOrigin__9CFbsBitGcRC6TPoint; AR_INDEX:__imp_SetDitherOrigin__9CFbsBitGcRC6TPoint; AR_INDEX:_imp__SetDitherOrigin__9CFbsBitGcRC6TPoint; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 120 | ?SetClippingRegion@CFbsBitGc@@QAEXPBVTRegion@@@Z | ds00120.o | 699 | AR_INDEX:SetShadowMode__9CFbsBitGci; AR_INDEX:__imp_SetShadowMode__9CFbsBitGci; AR_INDEX:_imp__SetShadowMode__9CFbsBitGci; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 123 | ?SetOrigin@CFbsBitGc@@UAEXABVTPoint@@@Z | ds00123.o | 753 | AR_INDEX:SetUserDisplayMode__9CFbsBitGc12TDisplayMode; AR_INDEX:__imp_SetUserDisplayMode__9CFbsBitGc12TDisplayMode; AR_INDEX:_imp__SetUserDisplayMode__9CFbsBitGc12TDisplayMode; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 3 | ??0CCoeControl@@QAE@XZ | ds00003.o | 691 | AR_INDEX:ActivateL__11CCoeControl; AR_INDEX:__imp_ActivateL__11CCoeControl; AR_INDEX:_imp__ActivateL__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 12 | ??8TCoeHelpContext@@QBEHABV0@@Z | ds00012.o | 736 | AR_INDEX:AddToStackL__9CCoeAppUiP11CCoeControlii; AR_INDEX:__imp_AddToStackL__9CCoeAppUiP11CCoeControlii; AR_INDEX:_imp__AddToStackL__9CCoeAppUiP11CCoeControlii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 28 | ?AllocReadResourceAsDes16L@CCoeEnv@@QBEPAVHBufC16@@H@Z | ds00028.o | 718 | AR_INDEX:ComponentControl__C11CCoeControli; AR_INDEX:__imp_ComponentControl__C11CCoeControli; AR_INDEX:_imp__ComponentControl__C11CCoeControli; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | ?AllocReadResourceAsDes16LC@CCoeEnv@@QBEPAVHBufC16@@H@Z | ds00029.o | 784 | AR_INDEX:ConstructFromResourceL__11CCoeControlR15TResourceReader; AR_INDEX:__imp_ConstructFromResourceL__11CCoeControlR15TResourceReader; AR_INDEX:_imp__ConstructFromResourceL__11CCoeControlR15TResourceReader; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 33 | ?BackedUpWindow@CCoeControl@@IBEAAVRBackedUpWindow@@XZ | ds00033.o | 733 | AR_INDEX:CountComponentControls__C11CCoeControl; AR_INDEX:__imp_CountComponentControls__C11CCoeControl; AR_INDEX:_imp__CountComponentControls__C11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 40 | ?CloseWindow@CCoeControl@@IAEXXZ | ds00040.o | 703 | AR_INDEX:CreateWindowL__11CCoeControl; AR_INDEX:__imp_CreateWindowL__11CCoeControl; AR_INDEX:_imp__CreateWindowL__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 55 | ?CreateWindowL@CCoeControl@@IAEXPBV1@@Z | ds00055.o | 709 | AR_INDEX:DrawableWindow__C11CCoeControl; AR_INDEX:__imp_DrawableWindow__C11CCoeControl; AR_INDEX:_imp__DrawableWindow__C11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 72 | ?ExecuteFepSettingsDialogL@CCoeEnv@@QAEXABVTDesC16@@@Z | ds00072.o | 799 | AR_INDEX:GetColorUseListL__C11CCoeControlRt9CArrayFix1Z12TCoeColorUse; AR_INDEX:__imp_GetColorUseListL__C11CCoeControlRt9CArrayFix1Z12TCoeColorUse; AR_INDEX:_imp__GetColorUseListL__C11CCoeControlRt9CArrayFix1Z12TCoeColorUse; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?SupportsWesternNumericReal@TCoeInputCapabilities@@QBEHXZ | ds00074.o | 763 | AR_INDEX:GetHelpContext__C11CCoeControlR15TCoeHelpContext; AR_INDEX:__imp_GetHelpContext__C11CCoeControlR15TCoeHelpContext; AR_INDEX:_imp__GetHelpContext__C11CCoeControlR15TCoeHelpContext; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | ?Format128@CCoeEnv@@QAAXAAVTDes16@@HZZ | ds00082.o | 772 | AR_INDEX:HandleKeyEventL__9CCoeAppUiRC9TKeyEvent10TEventCode; AR_INDEX:__imp_HandleKeyEventL__9CCoeAppUiRC9TKeyEvent10TEventCode; AR_INDEX:_imp__HandleKeyEventL__9CCoeAppUiRC9TKeyEvent10TEventCode; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 83 | ?Format256@CCoeEnv@@QAAXAAVTDes16@@HZZ | ds00083.o | 700 | AR_INDEX:__21TCoeInputCapabilitiesUi; AR_INDEX:__imp___21TCoeInputCapabilitiesUi; AR_INDEX:_imp____21TCoeInputCapabilitiesUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 84 | ?GetActiveViewId@CCoeAppUi@@QBEHAAVTVwsViewId@@@Z | ds00084.o | 739 | AR_INDEX:HandlePointerBufferReadyL__11CCoeControl; AR_INDEX:__imp_HandlePointerBufferReadyL__11CCoeControl; AR_INDEX:_imp__HandlePointerBufferReadyL__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 87 | ?GetHelpContext@CCoeControl@@UBEXAAVTCoeHelpContext@@@Z | ds00087.o | 727 | AR_INDEX:HandleResourceChange__11CCoeControli; AR_INDEX:__imp_HandleResourceChange__11CCoeControli; AR_INDEX:_imp__HandleResourceChange__11CCoeControli; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 90 | ?HandleComponentControlsResourceChange@CCoeControl@@IAEXH@Z | ds00090.o | 757 | AR_INDEX:HandleSwitchOnEventL__9CCoeAppUiP11CCoeControl; AR_INDEX:__imp_HandleSwitchOnEventL__9CCoeAppUiP11CCoeControl; AR_INDEX:_imp__HandleSwitchOnEventL__9CCoeAppUiP11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 95 | ?HandleKeyEventL@CCoeAppUiSimple@@EAEXABUTKeyEvent@@W4TEventCode@@@Z | ds00095.o | 694 | AR_INDEX:HasBorder__C11CCoeControl; AR_INDEX:__imp_HasBorder__C11CCoeControl; AR_INDEX:_imp__HasBorder__C11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 96 | ?SupportsWesternNumericIntegerNegative@TCoeInputCapabilities@@QBEHXZ | ds00096.o | 694 | AR_INDEX:HelpContextL__C9CCoeAppUi; AR_INDEX:__imp_HelpContextL__C9CCoeAppUi; AR_INDEX:_imp__HelpContextL__C9CCoeAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 101 | ?HandleStackChanged@CCoeAppUi@@QAEXXZ | ds00101.o | 709 | AR_INDEX:InputCapabilities__C9CCoeAppUi; AR_INDEX:__imp_InputCapabilities__C9CCoeAppUi; AR_INDEX:_imp__InputCapabilities__C9CCoeAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 138 | ?IsVisible@CCoeControl@@QBEHXZ | ds00138.o | 700 | AR_INDEX:MakeVisible__11CCoeControli; AR_INDEX:__imp_MakeVisible__11CCoeControli; AR_INDEX:_imp__MakeVisible__11CCoeControli; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 139 | ?IsWservEventPending@CCoeEnv@@QBEHXZ | ds00139.o | 697 | AR_INDEX:MinimumSize__11CCoeControl; AR_INDEX:__imp_MinimumSize__11CCoeControl; AR_INDEX:_imp__MinimumSize__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | ?MCoeFocusObserver_Reserved_2@MCoeFocusObserver@@EAEXXZ | ds00143.o | 778 | AR_INDEX:OfferKeyEventL__11CCoeControlRC9TKeyEvent10TEventCode; AR_INDEX:__imp_OfferKeyEventL__11CCoeControlRC9TKeyEvent10TEventCode; AR_INDEX:_imp__OfferKeyEventL__11CCoeControlRC9TKeyEvent10TEventCode; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 147 | ?SupportsNavigation@TCoeInputCapabilities@@QBEHXZ | ds00147.o | 709 | AR_INDEX:PositionChanged__11CCoeControl; AR_INDEX:__imp_PositionChanged__11CCoeControl; AR_INDEX:_imp__PositionChanged__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 153 | ?NameOfInstalledFepL@CCoeEnv@@QAEPAVHBufC16@@XZ | ds00153.o | 724 | AR_INDEX:PrepareForFocusLossL__11CCoeControl; AR_INDEX:__imp_PrepareForFocusLossL__11CCoeControl; AR_INDEX:_imp__PrepareForFocusLossL__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 160 | ?Position@CCoeControl@@QBE?AVTPoint@@XZ | ds00160.o | 679 | AR_INDEX:Rect__C11CCoeControl; AR_INDEX:__imp_Rect__C11CCoeControl; AR_INDEX:_imp__Rect__C11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 167 | ?PrepareToExit@CCoeAppUiBase@@UAEXXZ | ds00167.o | 742 | AR_INDEX:RemoveFromStack__9CCoeAppUiP11CCoeControl; AR_INDEX:__imp_RemoveFromStack__9CCoeAppUiP11CCoeControl; AR_INDEX:_imp__RemoveFromStack__9CCoeAppUiP11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 173 | ?Rect@CCoeControl@@QBE?AVTRect@@XZ | ds00173.o | 769 | AR_INDEX:WriteInternalStateL__C11CCoeControlR12RWriteStream; AR_INDEX:__imp_WriteInternalStateL__C11CCoeControlR12RWriteStream; AR_INDEX:_imp__WriteInternalStateL__C11CCoeControlR12RWriteStream; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 177 | ?RemoveFepObserver@CCoeEnv@@QAEXAAVMCoeFepObserver@@@Z | ds00177.o | 694 | AR_INDEX:Reserved_2__11CCoeControl; AR_INDEX:__imp_Reserved_2__11CCoeControl; AR_INDEX:_imp__Reserved_2__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | ?ReportEventL@CCoeControl@@IAEXW4TCoeEvent@MCoeControlObserver@@@Z | ds00185.o | 700 | AR_INDEX:SetAdjacent__11CCoeControli; AR_INDEX:__imp_SetAdjacent__11CCoeControli; AR_INDEX:_imp__SetAdjacent__11CCoeControli; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 187 | ?Reserved_1@CCoeAppUiBase@@EAEXXZ | ds00187.o | 703 | AR_INDEX:SetAndDrawFocus__9CCoeAppUii; AR_INDEX:__imp_SetAndDrawFocus__9CCoeAppUii; AR_INDEX:_imp__SetAndDrawFocus__9CCoeAppUii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 197 | ?RunL@CCoeEnv@@UAEXXZ | ds00197.o | 766 | AR_INDEX:SetContainerWindowL__11CCoeControlRC11CCoeControl; AR_INDEX:__imp_SetContainerWindowL__11CCoeControlRC11CCoeControl; AR_INDEX:_imp__SetContainerWindowL__11CCoeControlRC11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 200 | ?SetAndDrawFocus@CCoeAppUi@@EAEXH@Z | ds00200.o | 694 | AR_INDEX:SetDimmed__11CCoeControli; AR_INDEX:__imp_SetDimmed__11CCoeControli; AR_INDEX:_imp__SetDimmed__11CCoeControli; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 208 | ?SetContainerWindowL@CCoeControl@@QAEXAAVRBackedUpWindow@@@Z | ds00208.o | 739 | AR_INDEX:SetNeighbor__11CCoeControlP11CCoeControl; AR_INDEX:__imp_SetNeighbor__11CCoeControlP11CCoeControl; AR_INDEX:_imp__SetNeighbor__11CCoeControlP11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 214 | ?SetExtent@CCoeControl@@QAEXABVTPoint@@ABVTSize@@@Z | ds00214.o | 709 | AR_INDEX:SetRect__11CCoeControlRC5TRect; AR_INDEX:__imp_SetRect__11CCoeControlRC5TRect; AR_INDEX:_imp__SetRect__11CCoeControlRC5TRect; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 221 | ?SetNeighbor@CCoeControl@@UAEXPAV1@@Z | ds00221.o | 697 | AR_INDEX:SizeChanged__11CCoeControl; AR_INDEX:__imp_SizeChanged__11CCoeControl; AR_INDEX:_imp__SizeChanged__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 223 | ?SetObserver@CCoeControl@@QAEXPAVMCoeControlObserver@@@Z | ds00223.o | 667 | AR_INDEX:Static__7CCoeEnv; AR_INDEX:__imp_Static__7CCoeEnv; AR_INDEX:_imp__Static__7CCoeEnv; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 226 | ?SetPosition@CCoeControl@@QAEXABVTPoint@@@Z | ds00226.o | 691 | AR_INDEX:SystemGc__C11CCoeControl; AR_INDEX:__imp_SystemGc__C11CCoeControl; AR_INDEX:_imp__SystemGc__C11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 232 | ?SetUse@TCoeColorUse@@QAEXH@Z | ds00232.o | 667 | AR_INDEX:_._11CCoeControl; AR_INDEX:__imp__._11CCoeControl; AR_INDEX:_imp___._11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 236 | ?Static@CCoeEnv@@SAPAV1@XZ | ds00236.o | 664 | AR_INDEX:__11CCoeControl; AR_INDEX:__imp___11CCoeControl; AR_INDEX:_imp____11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 255 | ?DisplayError@CCoeScheduler@@UBEXH@Z | ds00255.o | 778 | AR_INDEX:MCoeMessageObserver_Reserved_1__19MCoeMessageObserver; AR_INDEX:__imp_MCoeMessageObserver_Reserved_1__19MCoeMessageObserver; AR_INDEX:_imp__MCoeMessageObserver_Reserved_1__19MCoeMessageObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 256 | ?FepAwareTextEditor@TCoeInputCapabilities@@QBEPAVMCoeFepAwareTextEditor@@XZ | ds00256.o | 778 | AR_INDEX:MCoeMessageObserver_Reserved_2__19MCoeMessageObserver; AR_INDEX:__imp_MCoeMessageObserver_Reserved_2__19MCoeMessageObserver; AR_INDEX:_imp__MCoeMessageObserver_Reserved_2__19MCoeMessageObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 292 | ?MCoeViewActivationObserver_Reserved_2@MCoeViewActivationObserver@@EAEXXZ | ds00292.o | 832 | AR_INDEX:MCoeViewDeactivationObserver_Reserved_1__28MCoeViewDeactivationObserver; AR_INDEX:__imp_MCoeViewDeactivationObserver_Reserved_1__28MCoeViewDeactivationObserver; AR_INDEX:_imp__MCoeViewDeactivationObserver_Reserved_1__28MCoeViewDeactivationObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 293 | ?MCoeViewDeactivationObserver_Reserved_1@MCoeViewDeactivationObserver@@EAEXXZ | ds00293.o | 832 | AR_INDEX:MCoeViewDeactivationObserver_Reserved_2__28MCoeViewDeactivationObserver; AR_INDEX:__imp_MCoeViewDeactivationObserver_Reserved_2__28MCoeViewDeactivationObserver; AR_INDEX:_imp__MCoeViewDeactivationObserver_Reserved_2__28MCoeViewDeactivationObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 312 | ?MopNext@CCoeControl@@EAEPAVMObjectProvider@@XZ | ds00312.o | 685 | AR_INDEX:MopNext__11CCoeControl; AR_INDEX:__imp_MopNext__11CCoeControl; AR_INDEX:_imp__MopNext__11CCoeControl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 314 | ?MopSupplyObject@CCoeControl@@MAE?AVPtr@TTypeUid@@V3@@Z | ds00314.o | 739 | AR_INDEX:MopSupplyObject__11CCoeControlG8TTypeUid; AR_INDEX:__imp_MopSupplyObject__11CCoeControlG8TTypeUid; AR_INDEX:_imp__MopSupplyObject__11CCoeControlG8TTypeUid; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 15 | ??1CFileBase@@MAE@XZ | ds00015.o | 665 | AR_INDEX:Close__7RFsBase; AR_INDEX:__imp_Close__7RFsBase; AR_INDEX:_imp__Close__7RFsBase; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 18 | ??ACDir@@QBEABVTEntry@@H@Z | ds00018.o | 662 | AR_INDEX:Connect__3RFsi; AR_INDEX:__imp_Connect__3RFsi; AR_INDEX:_imp__Connect__3RFsi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | ?AbbreviatedPath@CFileBase@@QAE?AVTPtrC16@@XZ | ds00021.o | 707 | AR_INDEX:Copy__8CFileManRC7TDesC16T1Ui; AR_INDEX:__imp_Copy__8CFileManRC7TDesC16T1Ui; AR_INDEX:_imp__Copy__8CFileManRC7TDesC16T1Ui; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 25 | ?Att@RFile@@QBEHAAI@Z | ds00025.o | 713 | AR_INDEX:Create__5RFileR3RFsRC7TDesC16Ui; AR_INDEX:__imp_Create__5RFileR3RFsRC7TDesC16Ui; AR_INDEX:_imp__Create__5RFileR3RFsRC7TDesC16Ui; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | ?BytesTransferredByCopyStep@CFileMan@@QAEHXZ | ds00029.o | 686 | AR_INDEX:Delete__3RFsRC7TDesC16; AR_INDEX:__imp_Delete__3RFsRC7TDesC16; AR_INDEX:_imp__Delete__3RFsRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 33 | ?ClearPassword@RFs@@QAEHHABV?$TBuf8@$0BA@@@@Z | ds00033.o | 701 | AR_INDEX:DriveAndPath__C10TParseBase; AR_INDEX:__imp_DriveAndPath__C10TParseBase; AR_INDEX:_imp__DriveAndPath__C10TParseBase; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | ?DismountFileSystem@RFs@@QBEHABVTDesC16@@H@Z | ds00051.o | 689 | AR_INDEX:FullName__C10TParseBase; AR_INDEX:__imp_FullName__C10TParseBase; AR_INDEX:_imp__FullName__C10TParseBase; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | ?IsExtWild@TParseBase@@QBEHXZ | ds00086.o | 683 | AR_INDEX:MkDir__3RFsRC7TDesC16; AR_INDEX:__imp_MkDir__3RFsRC7TDesC16; AR_INDEX:_imp__MkDir__3RFsRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 106 | ?Modified@RFile@@QBEHAAVTTime@@@Z | ds00106.o | 680 | AR_INDEX:NewL__8CFileManR3RFs; AR_INDEX:__imp_NewL__8CFileManR3RFs; AR_INDEX:_imp__NewL__8CFileManR3RFs; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 121 | ?NamePresent@TParseBase@@QBEHXZ | ds00121.o | 707 | AR_INDEX:Open__5RFileR3RFsRC7TDesC16Ui; AR_INDEX:__imp_Open__5RFileR3RFsRC7TDesC16Ui; AR_INDEX:_imp__Open__5RFileR3RFsRC7TDesC16Ui; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 136 | ?NotifyFileManOperation@MFileManObserver@@UAE?AW4TControl@1@XZ | ds00136.o | 680 | AR_INDEX:Read__C5RFileR5TDes8; AR_INDEX:__imp_Read__C5RFileR5TDes8; AR_INDEX:_imp__Read__C5RFileR5TDes8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 146 | ?PathPresent@TParseBase@@QBEHXZ | ds00146.o | 692 | AR_INDEX:Rename__3RFsRC7TDesC16T1; AR_INDEX:__imp_Rename__3RFsRC7TDesC16T1; AR_INDEX:_imp__Rename__3RFsRC7TDesC16T1; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 162 | ?ReadFileSection@RFs@@QBEHABVTDesC16@@HAAVTDes8@@H@Z | ds00162.o | 683 | AR_INDEX:Seek__C5RFile5TSeekRi; AR_INDEX:__imp_Seek__C5RFile5TSeekRi; AR_INDEX:_imp__Seek__C5RFile5TSeekRi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 183 | ?Set@RFile@@QAEHABVTTime@@II@Z | ds00183.o | 722 | AR_INDEX:Set__6TParseRC7TDesC16PC7TDesC16T2; AR_INDEX:__imp_Set__6TParseRC7TDesC16PC7TDesC16T2; AR_INDEX:_imp__Set__6TParseRC7TDesC16PC7TDesC16T2; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | ?Set@TParse@@QAEHABVTDesC16@@PBV2@1@Z | ds00185.o | 665 | AR_INDEX:Size__C5RFileRi; AR_INDEX:__imp_Size__C5RFileRi; AR_INDEX:_imp__Size__C5RFileRi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 193 | ?SetErrorCondition@RFs@@QAEHHH@Z | ds00193.o | 704 | AR_INDEX:Volume__C3RFsR11TVolumeInfoi; AR_INDEX:__imp_Volume__C3RFsR11TVolumeInfoi; AR_INDEX:_imp__Volume__C3RFsR11TVolumeInfoi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 194 | ?SetModified@RFile@@QAEHABVTTime@@@Z | ds00194.o | 686 | AR_INDEX:Write__5RFileRC6TDesC8; AR_INDEX:__imp_Write__5RFileRC6TDesC8; AR_INDEX:_imp__Write__5RFileRC6TDesC8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 212 | ?Volume@RFs@@QBEHAAVTVolumeInfo@@H@Z | ds00212.o | 665 | AR_INDEX:__11TVolumeInfo; AR_INDEX:__imp___11TVolumeInfo; AR_INDEX:_imp____11TVolumeInfo; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 230 | ??0TParse@@QAE@XZ | ds00230.o | 647 | AR_INDEX:__6TParse; AR_INDEX:__imp___6TParse; AR_INDEX:_imp____6TParse; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 17 | ??1CEikonEnv@@UAE@XZ | ds00017.o | 694 | AR_INDEX:Application__C9CEikAppUi; AR_INDEX:__imp_Application__C9CEikAppUi; AR_INDEX:_imp__Application__C9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 20 | ?AddAlertDialogLikeControlToStackL@CEikonEnv@@QAEXPAVCCoeControl@@@Z | ds00020.o | 727 | AR_INDEX:BitmapStoreName__C15CEikApplication; AR_INDEX:__imp_BitmapStoreName__C15CEikApplication; AR_INDEX:_imp__BitmapStoreName__C15CEikApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 30 | ?AddWindowShadow@CEikonEnv@@SAXPAVCCoeControl@@@Z | ds00030.o | 733 | AR_INDEX:Capability__C15CEikApplicationR5TDes8; AR_INDEX:__imp_Capability__C15CEikApplicationR5TDes8; AR_INDEX:_imp__Capability__C15CEikApplicationR5TDes8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 31 | ?AlertWin@CEikonEnv@@QAEXABVTDesC16@@0@Z | ds00031.o | 748 | AR_INDEX:CheckHotKeyNotDimmedL__16MEikMenuObserveri; AR_INDEX:__imp_CheckHotKeyNotDimmedL__16MEikMenuObserveri; AR_INDEX:_imp__CheckHotKeyNotDimmedL__16MEikMenuObserveri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 40 | ?Application@CEikAppUi@@QBEPAVCEikApplication@@XZ | ds00040.o | 688 | AR_INDEX:ConstructL__9CEikAppUi; AR_INDEX:__imp_ConstructL__9CEikAppUi; AR_INDEX:_imp__ConstructL__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 48 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@@Z | ds00048.o | 775 | AR_INDEX:CreateCustomCommandControlL__19MEikCommandObserveri; AR_INDEX:__imp_CreateCustomCommandControlL__19MEikCommandObserveri; AR_INDEX:_imp__CreateCustomCommandControlL__19MEikCommandObserveri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 49 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTGulAlignment@@@Z | ds00049.o | 766 | AR_INDEX:CreateDocumentL__15CEikApplicationP11CApaProcess; AR_INDEX:__imp_CreateDocumentL__15CEikApplicationP11CApaProcess; AR_INDEX:_imp__CreateDocumentL__15CEikApplicationP11CApaProcess; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | ?BusyMsgL@CEikonEnv@@QAEXABVTDesC16@@VTTimeIntervalMicroSeconds32@@@Z | ds00051.o | 721 | AR_INDEX:CreateFileL__9CEikAppUiRC7TDesC16; AR_INDEX:__imp_CreateFileL__9CEikAppUiRC7TDesC16; AR_INDEX:_imp__CreateFileL__9CEikAppUiRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 52 | ?BusyMsgL@CEikonEnv@@QAEXH@Z | ds00052.o | 766 | AR_INDEX:CreateFileStoreLC__12CEikDocumentR3RFsRC7TDesC16; AR_INDEX:__imp_CreateFileStoreLC__12CEikDocumentR3RFsRC7TDesC16; AR_INDEX:_imp__CreateFileStoreLC__12CEikDocumentR3RFsRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 61 | ?CommandTailEnd@CEikProcess@@QBE?AVTPtrC16@@XZ | ds00061.o | 685 | AR_INDEX:Document__C9CEikAppUi; AR_INDEX:__imp_Document__C9CEikAppUi; AR_INDEX:_imp__Document__C9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 64 | ?ConstructL@CEikAppUi@@UAEXXZ | ds00064.o | 772 | AR_INDEX:DynInitMenuBarL__16MEikMenuObserveriP11CEikMenuBar; AR_INDEX:__imp_DynInitMenuBarL__16MEikMenuObserveriP11CEikMenuBar; AR_INDEX:_imp__DynInitMenuBarL__16MEikMenuObserveriP11CEikMenuBar; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 65 | ?ConstructL@CEikEmbeddableAppList@@QAEXXZ | ds00065.o | 778 | AR_INDEX:DynInitMenuPaneL__16MEikMenuObserveriP12CEikMenuPane; AR_INDEX:__imp_DynInitMenuPaneL__16MEikMenuObserveriP12CEikMenuPane; AR_INDEX:_imp__DynInitMenuPaneL__16MEikMenuObserveriP12CEikMenuPane; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 66 | ?ConstructL@CEikMsgWin@@QAEXAAVRWindowGroup@@@Z | ds00066.o | 766 | AR_INDEX:EditL__12CEikDocumentP23MApaEmbeddedDocObserveri; AR_INDEX:__imp_EditL__12CEikDocumentP23MApaEmbeddedDocObserveri; AR_INDEX:_imp__EditL__12CEikDocumentP23MApaEmbeddedDocObserveri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 67 | ?ConstructL@CEikonEnv@@QAEXXZ | ds00067.o | 670 | AR_INDEX:Exit__9CEikAppUi; AR_INDEX:__imp_Exit__9CEikAppUi; AR_INDEX:_imp__Exit__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 68 | ?ControlColor@CEikonEnv@@QBE?AVTRgb@@W4TLogicalColor@@ABVCCoeControl@@@Z | ds00068.o | 754 | AR_INDEX:ExternalizeL__C12CEikDocumentR12RWriteStream; AR_INDEX:__imp_ExternalizeL__C12CEikDocumentR12RWriteStream; AR_INDEX:_imp__ExternalizeL__C12CEikDocumentR12RWriteStream; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 71 | ?CreateByTypeL@EikControlFactory@@SA?AUSEikControlInfo@@H@Z | ds00071.o | 796 | AR_INDEX:GetDefaultDocumentFileName__C15CEikApplicationRt4TBuf1i256; AR_INDEX:__imp_GetDefaultDocumentFileName__C15CEikApplicationRt4TBuf1i256; AR_INDEX:_imp__GetDefaultDocumentFileName__C15CEikApplicationRt4TBuf1i256; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?CreateCustomCommandControlL@MEikCommandObserver@@UAEPAVCCoeControl@@H@Z | ds00074.o | 787 | AR_INDEX:HandleApplicationSpecificEventL__9CEikAppUiiRC8TWsEvent; AR_INDEX:__imp_HandleApplicationSpecificEventL__9CEikAppUiiRC8TWsEvent; AR_INDEX:_imp__HandleApplicationSpecificEventL__9CEikAppUiiRC8TWsEvent; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 75 | ?CreateDocumentL@CEikApplication@@MAEPAVCApaDocument@@PAVCApaProcess@@@Z | ds00075.o | 772 | AR_INDEX:HandleAttemptDimmedSelectionL__16MEikMenuObserveri; AR_INDEX:__imp_HandleAttemptDimmedSelectionL__16MEikMenuObserveri; AR_INDEX:_imp__HandleAttemptDimmedSelectionL__16MEikMenuObserveri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 76 | ?CreateEmbeddedDocumentL@CEikEmbeddableAppList@@QAEPAVCEikDocument@@HPAVCApaProcess@@@Z | ds00076.o | 703 | AR_INDEX:HandleCommandL__9CEikAppUii; AR_INDEX:__imp_HandleCommandL__9CEikAppUii; AR_INDEX:_imp__HandleCommandL__9CEikAppUii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 80 | ?CreateIconFromMaskedBitmapL@CEikonEnv@@SAPAVCGulIcon@@ABVCApaMaskedBitmap@@@Z | ds00080.o | 751 | AR_INDEX:HandleMessageL__9CEikAppUiUlG4TUidRC6TDesC8; AR_INDEX:__imp_HandleMessageL__9CEikAppUiUlG4TUidRC6TDesC8; AR_INDEX:_imp__HandleMessageL__9CEikAppUiUlG4TUidRC6TDesC8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 81 | ?CreateIconL@CEikonEnv@@QAEPAVCGulIcon@@ABVTDesC16@@HH@Z | ds00081.o | 712 | AR_INDEX:HandleModelChangeL__9CEikAppUi; AR_INDEX:__imp_HandleModelChangeL__9CEikAppUi; AR_INDEX:_imp__HandleModelChangeL__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | ?CreateScreenFontL@EikResourceUtils@@SAPAVCFbsFont@@HPAVCEikonEnv@@@Z | ds00082.o | 724 | AR_INDEX:HandleResourceChangeL__9CEikAppUii; AR_INDEX:__imp_HandleResourceChangeL__9CEikAppUii; AR_INDEX:_imp__HandleResourceChangeL__9CEikAppUii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 84 | ?DefaultDisplayMode@CEikonEnv@@QBE?AW4TDisplayMode@@XZ | ds00084.o | 802 | AR_INDEX:HandleSideBarMenuL__9CEikAppUiiRC6TPointiPC15CEikHotKeyTable; AR_INDEX:__imp_HandleSideBarMenuL__9CEikAppUiiRC6TPointiPC15CEikHotKeyTable; AR_INDEX:_imp__HandleSideBarMenuL__9CEikAppUiiRC6TPointiPC15CEikHotKeyTable; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 86 | ?DestroyEnvironment@CEikonEnv@@MAEXXZ | ds00086.o | 703 | AR_INDEX:HasChanged__C12CEikDocument; AR_INDEX:__imp_HasChanged__C12CEikDocument; AR_INDEX:_imp__HasChanged__C12CEikDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 100 | ?ExternalizeL@CEikDocument@@UBEXAAVRWriteStream@@@Z | ds00100.o | 694 | AR_INDEX:IsEmpty__C12CEikDocument; AR_INDEX:__imp_IsEmpty__C12CEikDocument; AR_INDEX:_imp__IsEmpty__C12CEikDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 116 | ?HandleModelChangeL@CEikAppUi@@UAEXXZ | ds00116.o | 706 | AR_INDEX:NewDocumentL__12CEikDocument; AR_INDEX:__imp_NewDocumentL__12CEikDocument; AR_INDEX:_imp__NewDocumentL__12CEikDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 121 | ?HandleWsEventL@CAknWsEventMonitor@@UAEXABVTWsEvent@@PAVCCoeControl@@@Z | ds00121.o | 796 | AR_INDEX:OfferKeyToAppL__16MEikMenuObserverRC9TKeyEvent10TEventCode; AR_INDEX:__imp_OfferKeyToAppL__16MEikMenuObserverRC9TKeyEvent10TEventCode; AR_INDEX:_imp__OfferKeyToAppL__16MEikMenuObserverRC9TKeyEvent10TEventCode; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 122 | ?HandleWsEventL@CEikAppUi@@MAEXABVTWsEvent@@PAVCCoeControl@@@Z | ds00122.o | 733 | AR_INDEX:OpenAppInfoFileLC__C15CEikApplication; AR_INDEX:__imp_OpenAppInfoFileLC__C15CEikApplication; AR_INDEX:_imp__OpenAppInfoFileLC__C15CEikApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 123 | ?HasChanged@CEikDocument@@UBEHXZ | ds00123.o | 745 | AR_INDEX:OpenFileL__12CEikDocumentiRC7TDesC16R3RFs; AR_INDEX:__imp_OpenFileL__12CEikDocumentiRC7TDesC16R3RFs; AR_INDEX:_imp__OpenFileL__12CEikDocumentiRC7TDesC16R3RFs; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 124 | ?HideCursor@CEikonEnv@@QAEXPBVCCoeControl@@@Z | ds00124.o | 715 | AR_INDEX:OpenFileL__9CEikAppUiRC7TDesC16; AR_INDEX:__imp_OpenFileL__9CEikAppUiRC7TDesC16; AR_INDEX:_imp__OpenFileL__9CEikAppUiRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 130 | ?InfoMsgCancel@CEikonEnv@@QAEXXZ | ds00130.o | 736 | AR_INDEX:PrintL__12CEikDocumentRC12CStreamStore; AR_INDEX:__imp_PrintL__12CEikDocumentRC12CStreamStore; AR_INDEX:_imp__PrintL__12CEikDocumentRC12CStreamStore; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 133 | ?InfoMsgWithAlignment@CEikonEnv@@QAEXVTGulAlignment@@HQAPAC@Z | ds00133.o | 835 | AR_INDEX:ProcessCommandParametersL__9CEikAppUi11TApaCommandRt4TBuf1i256RC6TDesC8; AR_INDEX:__imp_ProcessCommandParametersL__9CEikAppUi11TApaCommandRt4TBuf1i256RC6TDesC8; AR_INDEX:_imp__ProcessCommandParametersL__9CEikAppUi11TApaCommandRt4TBuf1i256RC6TDesC8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 134 | ?InfoMsgWithAlignmentAndDuration@CEikonEnv@@QAAXVTGulAlignment@@HVTTimeIntervalMicroSeconds32@@ZZ | ds00134.o | 748 | AR_INDEX:ProcessMessageL__9CEikAppUiG4TUidRC6TDesC8; AR_INDEX:__imp_ProcessMessageL__9CEikAppUiG4TUidRC6TDesC8; AR_INDEX:_imp__ProcessMessageL__9CEikAppUiG4TUidRC6TDesC8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 142 | ?InitSystemFontsL@CEikonEnv@@EAEXXZ | ds00142.o | 700 | AR_INDEX:Reserved_1__12CEikDocument; AR_INDEX:__imp_Reserved_1__12CEikDocument; AR_INDEX:_imp__Reserved_1__12CEikDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | ?InternalizeL@@YAXAAW4TEikPortFlag@@AAVRReadStream@@@Z | ds00143.o | 709 | AR_INDEX:Reserved_1__15CEikApplication; AR_INDEX:__imp_Reserved_1__15CEikApplication; AR_INDEX:_imp__Reserved_1__15CEikApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 144 | ?IsBusy@CEikonEnv@@QBEHXZ | ds00144.o | 688 | AR_INDEX:Reserved_1__9CEikAppUi; AR_INDEX:__imp_Reserved_1__9CEikAppUi; AR_INDEX:_imp__Reserved_1__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 146 | ?IsForeground@CEikAppUi@@QBEHXZ | ds00146.o | 700 | AR_INDEX:Reserved_2__12CEikDocument; AR_INDEX:__imp_Reserved_2__12CEikDocument; AR_INDEX:_imp__Reserved_2__12CEikDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 147 | ?IsSystem@CEikonEnv@@QBEHXZ | ds00147.o | 688 | AR_INDEX:Reserved_2__9CEikAppUi; AR_INDEX:__imp_Reserved_2__9CEikAppUi; AR_INDEX:_imp__Reserved_2__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 149 | ?LafEnv@CEikonEnv@@QBEAAVMLafEnv@@XZ | ds00149.o | 688 | AR_INDEX:Reserved_3__9CEikAppUi; AR_INDEX:__imp_Reserved_3__9CEikAppUi; AR_INDEX:_imp__Reserved_3__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 150 | ?LastUsedFileL@CEikProcess@@QBE?AV?$TBuf@$0BAA@@@W4TLastUsedFile@1@@Z | ds00150.o | 688 | AR_INDEX:Reserved_4__9CEikAppUi; AR_INDEX:__imp_Reserved_4__9CEikAppUi; AR_INDEX:_imp__Reserved_4__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 151 | ?LaunchPopupMenuL@CEikAppUi@@QAEXHABVTPoint@@W4TPopupTargetPosType@@PBVCEikHotKeyTable@@@Z | ds00151.o | 730 | AR_INDEX:ResourceFileName__C15CEikApplication; AR_INDEX:__imp_ResourceFileName__C15CEikApplication; AR_INDEX:_imp__ResourceFileName__C15CEikApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 155 | ?LegendFont@CEikonEnv@@QBEPBVCFont@@XZ | ds00155.o | 805 | AR_INDEX:RestoreL__12CEikDocumentRC12CStreamStoreRC17CStreamDictionary; AR_INDEX:__imp_RestoreL__12CEikDocumentRC12CStreamStoreRC17CStreamDictionary; AR_INDEX:_imp__RestoreL__12CEikDocumentRC12CStreamStoreRC17CStreamDictionary; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 157 | ?MEikPictureFactory_Reserved_2@MEikPictureFactory@@EAEXXZ | ds00157.o | 853 | AR_INDEX:RestoreMenuL__16MEikMenuObserverP11CCoeControliQ216MEikMenuObserver9TMenuType; AR_INDEX:__imp_RestoreMenuL__16MEikMenuObserverP11CCoeControliQ216MEikMenuObserver9TMenuType; AR_INDEX:_imp__RestoreMenuL__16MEikMenuObserverP11CCoeControliQ216MEikMenuObserver9TMenuType; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 161 | ?MdcaPoint@CEikEmbeddableAppList@@EBE?AVTPtrC16@@H@Z | ds00161.o | 685 | AR_INDEX:SaveL__12CEikDocument; AR_INDEX:__imp_SaveL__12CEikDocument; AR_INDEX:_imp__SaveL__12CEikDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 179 | ?PictureFactory@CEikonEnv@@QBEPAVMPictureFactory@@XZ | ds00179.o | 736 | AR_INDEX:SetEmphasis__9CEikAppUiP11CCoeControli; AR_INDEX:__imp_SetEmphasis__9CEikAppUiP11CCoeControli; AR_INDEX:_imp__SetEmphasis__9CEikAppUiP11CCoeControli; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 198 | ?RemoveObserver@CAknWsEventMonitor@@QAEXPBVMAknWsEventObserver@@@Z | ds00198.o | 721 | AR_INDEX:StopDisplayingMenuBar__9CEikAppUi; AR_INDEX:__imp_StopDisplayingMenuBar__9CEikAppUi; AR_INDEX:_imp__StopDisplayingMenuBar__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 200 | ?ReportResourceChangedToAppL@CEikAppUi@@QAEXH@Z | ds00200.o | 796 | AR_INDEX:StoreL__C12CEikDocumentR12CStreamStoreR17CStreamDictionary; AR_INDEX:__imp_StoreL__C12CEikDocumentR12CStreamStoreR17CStreamDictionary; AR_INDEX:_imp__StoreL__C12CEikDocumentR12CStreamStoreR17CStreamDictionary; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 204 | ?Reserved_1@CEikDocument@@EAEXXZ | ds00204.o | 781 | AR_INDEX:UpdateTaskNameL__12CEikDocumentP19CApaWindowGroupName; AR_INDEX:__imp_UpdateTaskNameL__12CEikDocumentP19CApaWindowGroupName; AR_INDEX:_imp__UpdateTaskNameL__12CEikDocumentP19CApaWindowGroupName; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 206 | ?Reserved_1_MenuObserver@MEikAutoMenuObserver@@EAEXXZ | ds00206.o | 718 | AR_INDEX:ValidFileType__C9CEikAppUiG4TUid; AR_INDEX:__imp_ValidFileType__C9CEikAppUiG4TUid; AR_INDEX:_imp__ValidFileType__C9CEikAppUiG4TUid; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 213 | ?ResourceFileName@CEikApplication@@UBE?AV?$TBuf@$0BAA@@@XZ | ds00213.o | 673 | AR_INDEX:_._12CEikDocument; AR_INDEX:__imp__._12CEikDocument; AR_INDEX:_imp___._12CEikDocument; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 214 | ?ResourceFileVersionNumber@CEikonEnv@@EBEHXZ | ds00214.o | 682 | AR_INDEX:_._15CEikApplication; AR_INDEX:__imp__._15CEikApplication; AR_INDEX:_imp___._15CEikApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 219 | ?RestoreMenuL@MEikMenuObserver@@UAEXPAVCCoeControl@@HW4TMenuType@1@@Z | ds00219.o | 724 | AR_INDEX:__12CEikDocumentR15CEikApplication; AR_INDEX:__imp___12CEikDocumentR15CEikApplication; AR_INDEX:_imp____12CEikDocumentR15CEikApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 222 | ?SaveAnyChangesL@CEikAppUi@@IAEXXZ | ds00222.o | 679 | AR_INDEX:__15CEikApplication; AR_INDEX:__imp___15CEikApplication; AR_INDEX:_imp____15CEikApplication; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 224 | ?SaveL@CEikDocument@@UAEXW4TSaveType@MSaveObserver@@@Z | ds00224.o | 658 | AR_INDEX:__9CEikAppUi; AR_INDEX:__imp___9CEikAppUi; AR_INDEX:_imp____9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 226 | ?SaveToDirectFileStoreL@CEikProcess@@QAEXPAVCEikDocument@@PBV?$TBuf@$0BAA@@@@Z | ds00226.o | 751 | AR_INDEX:Reserved_1_MenuObserver__16MEikMenuObserver; AR_INDEX:__imp_Reserved_1_MenuObserver__16MEikMenuObserver; AR_INDEX:_imp__Reserved_1_MenuObserver__16MEikMenuObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 233 | ?SetBusy@CEikonEnv@@QAEXH@Z | ds00233.o | 706 | AR_INDEX:ApplicationRect__C9CEikAppUi; AR_INDEX:__imp_ApplicationRect__C9CEikAppUi; AR_INDEX:_imp__ApplicationRect__C9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 243 | ?SetEmphasis@MEikAutoMenuObserver@@UAEXPAVCCoeControl@@H@Z | ds00243.o | 691 | AR_INDEX:LegendFont__C9CEikonEnv; AR_INDEX:__imp_LegendFont__C9CEikonEnv; AR_INDEX:_imp__LegendFont__C9CEikonEnv; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 253 | ?SetRespondsToSwitchFilesEvent@CEikonEnv@@QAEXH@Z | ds00253.o | 766 | AR_INDEX:SaveL__12CEikDocumentQ213MSaveObserver9TSaveType; AR_INDEX:__imp_SaveL__12CEikDocumentQ213MSaveObserver9TSaveType; AR_INDEX:_imp__SaveL__12CEikDocumentQ213MSaveObserver9TSaveType; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 264 | ?StopDisplayingMenuBar@CEikAppUi@@UAEXXZ | ds00264.o | 733 | AR_INDEX:MopSupplyObject__9CEikAppUiG8TTypeUid; AR_INDEX:__imp_MopSupplyObject__9CEikAppUiG8TTypeUid; AR_INDEX:_imp__MopSupplyObject__9CEikAppUiG8TTypeUid; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 290 | ?IsPartialForeground@CEikAppUi@@QBEHXZ | ds00290.o | 679 | AR_INDEX:MopNext__9CEikAppUi; AR_INDEX:__imp_MopNext__9CEikAppUi; AR_INDEX:_imp__MopNext__9CEikAppUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 45 | ?Cancel@RMBufAsyncRequest@@QAEXXZ | ds00045.o | 665 | AR_INDEX:Close__7RSocket; AR_INDEX:__imp_Close__7RSocket; AR_INDEX:_imp__Close__7RSocket; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 48 | ?CancelAccept@RSocket@@QAEXXZ | ds00048.o | 692 | AR_INDEX:Connect__11RSocketServUi; AR_INDEX:__imp_Connect__11RSocketServUi; AR_INDEX:_imp__Connect__11RSocketServUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 62 | ?Close@RSocket@@QAEXXZ | ds00062.o | 785 | AR_INDEX:FindProtocol__11RSocketServRCt4TBuf1i32R13TProtocolDesc; AR_INDEX:__imp_FindProtocol__11RSocketServRCt4TBuf1i32R13TProtocolDesc; AR_INDEX:_imp__FindProtocol__11RSocketServRCt4TBuf1i32R13TProtocolDesc; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 87 | ?Free@RMBuf@@QAEXXZ | ds00087.o | 701 | AR_INDEX:GetOpt__7RSocketUiUiR5TDes8; AR_INDEX:__imp_GetOpt__7RSocketUiUiR5TDes8; AR_INDEX:_imp__GetOpt__7RSocketUiUiR5TDes8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 129 | ?Name@RSocket@@QAEHAAV?$TBuf@$0IA@@@@Z | ds00129.o | 722 | AR_INDEX:Open__7RSocketR11RSocketServUiUiUi; AR_INDEX:__imp_Open__7RSocketR11RSocketServUiUiUi; AR_INDEX:_imp__Open__7RSocketR11RSocketServUiUiUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 209 | ?StopProtocol@RSocketServ@@QAEXIIIAAVTRequestStatus@@@Z | ds00209.o | 665 | AR_INDEX:__11RSocketServ; AR_INDEX:__imp___11RSocketServ; AR_INDEX:_imp____11RSocketServ; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 217 | ?Version@RSocketServ@@QBE?AVTVersion@@XZ | ds00217.o | 650 | AR_INDEX:__7RSocket; AR_INDEX:__imp___7RSocket; AR_INDEX:_imp____7RSocket; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 3 | _malloc | ds00003.o | 632 | AR_INDEX:malloc; AR_INDEX:__imp_malloc; AR_INDEX:_imp__malloc; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 6 | _free | ds00006.o | 628 | AR_INDEX:free; AR_INDEX:__imp_free; AR_INDEX:_imp__free; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 9 | _strlen | ds00009.o | 632 | AR_INDEX:strlen; AR_INDEX:__imp_strlen; AR_INDEX:_imp__strlen; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 49 | _fclose | ds00049.o | 632 | AR_INDEX:fclose; AR_INDEX:__imp_fclose; AR_INDEX:_imp__fclose; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 51 | _feof | ds00051.o | 628 | AR_INDEX:feof; AR_INDEX:__imp_feof; AR_INDEX:_imp__feof; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 56 | _fgets | ds00056.o | 630 | AR_INDEX:fgets; AR_INDEX:__imp_fgets; AR_INDEX:_imp__fgets; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 58 | _fopen | ds00058.o | 630 | AR_INDEX:fopen; AR_INDEX:__imp_fopen; AR_INDEX:_imp__fopen; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 59 | _fprintf | ds00059.o | 634 | AR_INDEX:fprintf; AR_INDEX:__imp_fprintf; AR_INDEX:_imp__fprintf; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 64 | _fscanf | ds00064.o | 632 | AR_INDEX:fscanf; AR_INDEX:__imp_fscanf; AR_INDEX:_imp__fscanf; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 65 | _fseek | ds00065.o | 630 | AR_INDEX:fseek; AR_INDEX:__imp_fseek; AR_INDEX:_imp__fseek; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 82 | _sprintf | ds00082.o | 634 | AR_INDEX:sprintf; AR_INDEX:__imp_sprintf; AR_INDEX:_imp__sprintf; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 83 | _sscanf | ds00083.o | 632 | AR_INDEX:sscanf; AR_INDEX:__imp_sscanf; AR_INDEX:_imp__sscanf; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 128 | _atoi | ds00128.o | 628 | AR_INDEX:atoi; AR_INDEX:__imp_atoi; AR_INDEX:_imp__atoi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 157 | _time | ds00157.o | 628 | AR_INDEX:time; AR_INDEX:__imp_time; AR_INDEX:_imp__time; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 171 | _toupper | ds00171.o | 634 | AR_INDEX:toupper; AR_INDEX:__imp_toupper; AR_INDEX:_imp__toupper; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 173 | _memchr | ds00173.o | 632 | AR_INDEX:memchr; AR_INDEX:__imp_memchr; AR_INDEX:_imp__memchr; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 174 | _memcmp | ds00174.o | 632 | AR_INDEX:memcmp; AR_INDEX:__imp_memcmp; AR_INDEX:_imp__memcmp; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 177 | _strcasecmp | ds00177.o | 651 | AR_INDEX:strcasecmp; AR_INDEX:__imp_strcasecmp; AR_INDEX:_imp__strcasecmp; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 178 | _strcat | ds00178.o | 632 | AR_INDEX:strcat; AR_INDEX:__imp_strcat; AR_INDEX:_imp__strcat; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 180 | _strcmp | ds00180.o | 632 | AR_INDEX:strcmp; AR_INDEX:__imp_strcmp; AR_INDEX:_imp__strcmp; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 181 | _strcpy | ds00181.o | 632 | AR_INDEX:strcpy; AR_INDEX:__imp_strcpy; AR_INDEX:_imp__strcpy; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 187 | _strncmp | ds00187.o | 634 | AR_INDEX:strncmp; AR_INDEX:__imp_strncmp; AR_INDEX:_imp__strncmp; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 188 | _strncpy | ds00188.o | 634 | AR_INDEX:strncpy; AR_INDEX:__imp_strncpy; AR_INDEX:_imp__strncpy; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 193 | _strtok | ds00193.o | 632 | AR_INDEX:strtok; AR_INDEX:__imp_strtok; AR_INDEX:_imp__strtok; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 291 | _wait | ds00291.o | 654 | AR_INDEX:CloseSTDLIB; AR_INDEX:__imp_CloseSTDLIB; AR_INDEX:_imp__CloseSTDLIB; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 315 | _wclosedir | ds00315.o | 632 | AR_INDEX:wcscat; AR_INDEX:__imp_wcscat; AR_INDEX:_imp__wcscat; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 316 | _wcscat | ds00316.o | 632 | AR_INDEX:wcscmp; AR_INDEX:__imp_wcscmp; AR_INDEX:_imp__wcscmp; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 317 | _wcscmp | ds00317.o | 632 | AR_INDEX:wcscpy; AR_INDEX:__imp_wcscpy; AR_INDEX:_imp__wcscpy; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 342 | _wcsdup | ds00342.o | 632 | AR_INDEX:wcslen; AR_INDEX:__imp_wcslen; AR_INDEX:_imp__wcslen; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 26 | ??1CTelObject@@UAE@XZ | ds00026.o | 658 | AR_INDEX:Close__5RLine; AR_INDEX:__imp_Close__5RLine; AR_INDEX:_imp__Close__5RLine; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 27 | ?AcquireOwnership@RCall@@QBEXAAVTRequestStatus@@@Z | ds00027.o | 661 | AR_INDEX:Close__6RPhone; AR_INDEX:__imp_Close__6RPhone; AR_INDEX:_imp__Close__6RPhone; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 29 | ?AnswerIncomingCall@RCall@@QAEXAAVTRequestStatus@@@Z | ds00029.o | 685 | AR_INDEX:Connect__10RTelServeri; AR_INDEX:__imp_Connect__10RTelServeri; AR_INDEX:_imp__Connect__10RTelServeri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 55 | ?Connect@RCall@@QAEXAAVTRequestStatus@@ABVTDesC8@@@Z | ds00055.o | 697 | AR_INDEX:EnumerateLines__C6RPhoneRi; AR_INDEX:__imp_EnumerateLines__C6RPhoneRi; AR_INDEX:_imp__EnumerateLines__C6RPhoneRi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 56 | ?Connect@RCall@@QBEHABVTDesC8@@@Z | ds00056.o | 715 | AR_INDEX:EnumeratePhones__C10RTelServerRi; AR_INDEX:__imp_EnumeratePhones__C10RTelServerRi; AR_INDEX:_imp__EnumeratePhones__C10RTelServerRi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 72 | ?Destruct@RLine@@MAEXXZ | ds00072.o | 745 | AR_INDEX:GetLineInfo__C6RPhoneiRQ26RPhone9TLineInfo; AR_INDEX:__imp_GetLineInfo__C6RPhoneiRQ26RPhone9TLineInfo; AR_INDEX:_imp__GetLineInfo__C6RPhoneiRQ26RPhone9TLineInfo; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?Dial@RCall@@QAEXAAVTRequestStatus@@ABVTDesC16@@@Z | ds00074.o | 784 | AR_INDEX:GetPhoneInfo__C10RTelServeriRQ210RTelServer10TPhoneInfo; AR_INDEX:__imp_GetPhoneInfo__C10RTelServeriRQ210RTelServer10TPhoneInfo; AR_INDEX:_imp__GetPhoneInfo__C10RTelServeriRQ210RTelServer10TPhoneInfo; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 77 | ?Dial@RCall@@QBEHABVTDesC8@@ABVTDesC16@@@Z | ds00077.o | 724 | AR_INDEX:GetStatus__C5RLineRQ25RCall7TStatus; AR_INDEX:__imp_GetStatus__C5RLineRQ25RCall7TStatus; AR_INDEX:_imp__GetStatus__C5RLineRQ25RCall7TStatus; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 102 | ?GetFaxSettings@RCall@@QBEHAAUTFaxSessionSettings@1@@Z | ds00102.o | 739 | AR_INDEX:LoadPhoneModule__C10RTelServerRC7TDesC16; AR_INDEX:__imp_LoadPhoneModule__C10RTelServerRC7TDesC16; AR_INDEX:_imp__LoadPhoneModule__C10RTelServerRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 125 | ?IsDefault@TCallParams@RCall@@QAEHXZ | ds00125.o | 718 | AR_INDEX:NotifyStatusChangeCancel__C5RLine; AR_INDEX:__imp_NotifyStatusChangeCancel__C5RLine; AR_INDEX:_imp__NotifyStatusChangeCancel__C5RLine; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 127 | ?LoadPhoneModule@RTelServer@@QBEHABVTDesC16@@@Z | ds00127.o | 799 | AR_INDEX:NotifyStatusChange__5RLineR14TRequestStatusRQ25RCall7TStatus; AR_INDEX:__imp_NotifyStatusChange__5RLineR14TRequestStatusRQ25RCall7TStatus; AR_INDEX:_imp__NotifyStatusChange__5RLineR14TRequestStatusRQ25RCall7TStatus; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 152 | ?NotifyStatusChangeCancel@RLine@@QBEXXZ | ds00152.o | 709 | AR_INDEX:Open__5RLineR6RPhoneRC7TDesC16; AR_INDEX:__imp_Open__5RLineR6RPhoneRC7TDesC16; AR_INDEX:_imp__Open__5RLineR6RPhoneRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 153 | ?NullMethod1@CSubSessionExtBase@@IAEXXZ | ds00153.o | 727 | AR_INDEX:Open__6RPhoneR10RTelServerRC7TDesC16; AR_INDEX:__imp_Open__6RPhoneR10RTelServerRC7TDesC16; AR_INDEX:_imp__Open__6RPhoneR10RTelServerRC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 204 | ?Set@RTelSubSessionBase@@IBEXHAAVTRequestStatus@@ABVTDesC16@@1W4TReqPriorityType@1@@Z | ds00204.o | 661 | AR_INDEX:__10RTelServer; AR_INDEX:__imp___10RTelServer; AR_INDEX:_imp____10RTelServer; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 210 | ?SetFaxSettings@RCall@@QBEHABUTFaxSessionSettings@1@@Z | ds00210.o | 634 | AR_INDEX:__5RLine; AR_INDEX:__imp___5RLine; AR_INDEX:_imp____5RLine; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 211 | ?SetOwnership@CCallBase@@UAEHK@Z | ds00211.o | 646 | AR_INDEX:__6RPhone; AR_INDEX:__imp___6RPhone; AR_INDEX:_imp____6RPhone; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 1 | __ftol | ds00001.o | 628 | AR_INDEX:memset; AR_INDEX:__imp_memset; AR_INDEX:_imp__memset; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 2 | ??0CActive@@IAE@H@Z | ds00002.o | 628 | AR_INDEX:memcpy; AR_INDEX:__imp_memcpy; AR_INDEX:_imp__memcpy; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 3 | ??0CActiveScheduler@@QAE@XZ | ds00003.o | 659 | AR_INDEX:newL__5CBaseUi; AR_INDEX:__imp_newL__5CBaseUi; AR_INDEX:_imp__newL__5CBaseUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 13 | ??0CBufFlat@@IAE@H@Z | ds00013.o | 713 | AR_INDEX:Add__16CActiveSchedulerP7CActive; AR_INDEX:__imp_Add__16CActiveSchedulerP7CActive; AR_INDEX:_imp__Add__16CActiveSchedulerP7CActive; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | ??0CIdle@@IAE@H@Z | ds00021.o | 743 | AR_INDEX:After__4UserG27TTimeIntervalMicroSeconds32; AR_INDEX:__imp_After__4UserG27TTimeIntervalMicroSeconds32; AR_INDEX:_imp__After__4UserG27TTimeIntervalMicroSeconds32; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 35 | ??0MBusDev@@QAE@XZ | ds00035.o | 659 | AR_INDEX:AllocL__4Useri; AR_INDEX:__imp_AllocL__4Useri; AR_INDEX:_imp__AllocL__4Useri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 41 | ??0RHeap@@IAE@H@Z | ds00041.o | 671 | AR_INDEX:AllocSize__4UserRi; AR_INDEX:__imp_AllocSize__4UserRi; AR_INDEX:_imp__AllocSize__4UserRi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 45 | ??0RPointerArrayBase@@IAE@XZ | ds00045.o | 656 | AR_INDEX:Alloc__4Useri; AR_INDEX:__imp_Alloc__4Useri; AR_INDEX:_imp__Alloc__4Useri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 77 | ??0TDayName@@QAE@W4TDay@@@Z | ds00077.o | 671 | AR_INDEX:AppendNum__5TDes8i; AR_INDEX:__imp_AppendNum__5TDes8i; AR_INDEX:_imp__AppendNum__5TDes8i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 85 | ??0TDeltaQueBase@@IAE@XZ | ds00085.o | 680 | AR_INDEX:Append__5TDes8G5TChar; AR_INDEX:__imp_Append__5TDes8G5TChar; AR_INDEX:_imp__Append__5TDes8G5TChar; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 89 | ??0THeapWalk@@QAE@ABVRHeap@@@Z | ds00089.o | 683 | AR_INDEX:Append__6TDes16G5TChar; AR_INDEX:__imp_Append__6TDes16G5TChar; AR_INDEX:_imp__Append__6TDes16G5TChar; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 90 | ??0TInt64@@QAE@H@Z | ds00090.o | 677 | AR_INDEX:Append__6TDes16PCUsi; AR_INDEX:__imp_Append__6TDes16PCUsi; AR_INDEX:_imp__Append__6TDes16PCUsi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 91 | ??0TInt64@@QAE@N@Z | ds00091.o | 692 | AR_INDEX:Append__6TDes16RC7TDesC16; AR_INDEX:__imp_Append__6TDes16RC7TDesC16; AR_INDEX:_imp__Append__6TDes16RC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 99 | ??0TKeyArrayPak@@QAE@HW4TKeyCmpNumeric@@@Z | ds00099.o | 662 | AR_INDEX:AtC__C7TDesC16i; AR_INDEX:__imp_AtC__C7TDesC16i; AR_INDEX:_imp__AtC__C7TDesC16i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 152 | ??0TTime@@QAE@ABVTDateTime@@@Z | ds00152.o | 665 | AR_INDEX:Cancel__7CActive; AR_INDEX:__imp_Cancel__7CActive; AR_INDEX:_imp__Cancel__7CActive; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 172 | ??1CBufSeg@@UAE@XZ | ds00172.o | 677 | AR_INDEX:Close__11RHandleBase; AR_INDEX:__imp_Close__11RHandleBase; AR_INDEX:_imp__Close__11RHandleBase; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 207 | ??8TPoint@@QBEHABV0@@Z | ds00207.o | 701 | AR_INDEX:Compare__C7TDesC16RC7TDesC16; AR_INDEX:__imp_Compare__C7TDesC16RC7TDesC16; AR_INDEX:_imp__Compare__C7TDesC16RC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 211 | ??8TUidType@@QBEHABV0@@Z | ds00211.o | 686 | AR_INDEX:CompressAllHeaps__4User; AR_INDEX:__imp_CompressAllHeaps__4User; AR_INDEX:_imp__CompressAllHeaps__4User; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 245 | ??GTSize@@QBE?AV0@ABVTPoint@@@Z | ds00245.o | 668 | AR_INDEX:Copy__5TDes8PCUci; AR_INDEX:__imp_Copy__5TDes8PCUci; AR_INDEX:_imp__Copy__5TDes8PCUci; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 248 | ??GTTime@@QBE?AV0@VTTimeIntervalHours@@@Z | ds00248.o | 668 | AR_INDEX:Copy__6TDes16PCUs; AR_INDEX:__imp_Copy__6TDes16PCUs; AR_INDEX:_imp__Copy__6TDes16PCUs; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 251 | ??GTTime@@QBE?AV0@VTTimeIntervalMinutes@@@Z | ds00251.o | 686 | AR_INDEX:Copy__6TDes16RC7TDesC16; AR_INDEX:__imp_Copy__6TDes16RC7TDesC16; AR_INDEX:_imp__Copy__6TDes16RC7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 274 | ??LTRealX@@QBE?AV0@ABV0@@Z | ds00274.o | 764 | AR_INDEX:CreateGlobal__10RSemaphoreRC7TDesC16i10TOwnerType; AR_INDEX:__imp_CreateGlobal__10RSemaphoreRC7TDesC16i10TOwnerType; AR_INDEX:_imp__CreateGlobal__10RSemaphoreRC7TDesC16i10TOwnerType; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 289 | ??YTTime@@QAEAAV0@VTTimeIntervalDays@@@Z | ds00289.o | 779 | AR_INDEX:Create__7RThreadRC7TDesC16PFPv_iiP5RHeapPv10TOwnerType; AR_INDEX:__imp_Create__7RThreadRC7TDesC16PFPv_iiP5RHeapPv10TOwnerType; AR_INDEX:_imp__Create__7RThreadRC7TDesC16PFPv_iiP5RHeapPv10TOwnerType; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 411 | ?Assign@TLex16@@QAEXABVTDesC16@@@Z | ds00411.o | 659 | AR_INDEX:FillZ__3MemPvi; AR_INDEX:__imp_FillZ__3MemPvi; AR_INDEX:_imp__FillZ__3MemPvi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 418 | ?At@CObjectCon@@QBEPAVCObject@@H@Z | ds00418.o | 677 | AR_INDEX:Fill__5TDes8G5TChari; AR_INDEX:__imp_Fill__5TDes8G5TChari; AR_INDEX:_imp__Fill__5TDes8G5TChari; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 467 | ?Cancel@RServer@@QAEXXZ | ds00467.o | 743 | AR_INDEX:Format__6TDes16Gt11TRefByValue1ZC7TDesC16e; AR_INDEX:__imp_Format__6TDes16Gt11TRefByValue1ZC7TDesC16e; AR_INDEX:_imp__Format__6TDes16Gt11TRefByValue1ZC7TDesC16e; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 476 | ?ChangeLocale@UserSvr@@SAHVRLibrary@@@Z | ds00476.o | 656 | AR_INDEX:Free__4UserPv; AR_INDEX:__imp_Free__4UserPv; AR_INDEX:_imp__Free__4UserPv; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 501 | ?Collate@TDes16@@QAEXXZ | ds00501.o | 668 | AR_INDEX:GetTInt__C6TInt64; AR_INDEX:__imp_GetTInt__C6TInt64; AR_INDEX:_imp__GetTInt__C6TInt64; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 530 | ?Compress@CArrayPakBase@@QAEXXZ | ds00530.o | 662 | AR_INDEX:Height__C5TRect; AR_INDEX:__imp_Height__C5TRect; AR_INDEX:_imp__Height__C5TRect; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 531 | ?Compress@CArrayVarBase@@QAEXXZ | ds00531.o | 665 | AR_INDEX:HomeTime__5TTime; AR_INDEX:__imp_HomeTime__5TTime; AR_INDEX:_imp__HomeTime__5TTime; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 569 | ?CopyLC@TDes8@@QAEXABVTDesC8@@@Z | ds00569.o | 755 | AR_INDEX:Install__16CActiveSchedulerP16CActiveScheduler; AR_INDEX:__imp_Install__16CActiveSchedulerP16CActiveScheduler; AR_INDEX:_imp__Install__16CActiveSchedulerP16CActiveScheduler; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 621 | ?DaysFrom@TTime@@QBE?AVTTimeIntervalDays@@V1@@Z | ds00621.o | 662 | AR_INDEX:Kill__7RThreadi; AR_INDEX:__imp_Kill__7RThreadi; AR_INDEX:_imp__Kill__7RThreadi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 625 | ?DebugThreadPanic@@YAXKABVTDesC16@@0H@Z | ds00625.o | 662 | AR_INDEX:Language__4User; AR_INDEX:__imp_Language__4User; AR_INDEX:_imp__Language__4User; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 627 | ?Decompose@TChar@@QBEHAAVTPtrC16@@@Z | ds00627.o | 677 | AR_INDEX:LeaveIfError__4Useri; AR_INDEX:__imp_LeaveIfError__4Useri; AR_INDEX:_imp__LeaveIfError__4Useri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 630 | ?Delete@CArrayFixBase@@QAEXHH@Z | ds00630.o | 656 | AR_INDEX:Leave__4Useri; AR_INDEX:__imp_Leave__4Useri; AR_INDEX:_imp__Leave__4Useri; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 632 | ?Delete@CArrayPakBase@@QAEXHH@Z | ds00632.o | 665 | AR_INDEX:Left__C7TDesC16i; AR_INDEX:__imp_Left__C7TDesC16i; AR_INDEX:_imp__Left__C7TDesC16i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 711 | ?EmulatorDataPath@@YA?AVTPtrC16@@XZ | ds00711.o | 659 | AR_INDEX:Move__5TRectii; AR_INDEX:__imp_Move__5TRectii; AR_INDEX:_imp__Move__5TRectii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 738 | ?FRand@Math@@SANAAVTInt64@@@Z | ds00738.o | 668 | AR_INDEX:NewL__9CPeriodici; AR_INDEX:__imp_NewL__9CPeriodici; AR_INDEX:_imp__NewL__9CPeriodici; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 746 | ?Fill@TDes16@@QAEXVTChar@@@Z | ds00746.o | 674 | AR_INDEX:New__12CTrapCleanup; AR_INDEX:__imp_New__12CTrapCleanup; AR_INDEX:_imp__New__12CTrapCleanup; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 809 | ?Free@User@@SAXPAX@Z | ds00809.o | 686 | AR_INDEX:Panic__4UserRC7TDesC16i; AR_INDEX:__imp_Panic__4UserRC7TDesC16i; AR_INDEX:_imp__Panic__4UserRC7TDesC16i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 824 | ?GetCategory@TChar@@QBE?AW4TCategory@1@XZ | ds00824.o | 704 | AR_INDEX:PopAndDestroy__12CleanupStack; AR_INDEX:__imp_PopAndDestroy__12CleanupStack; AR_INDEX:_imp__PopAndDestroy__12CleanupStack; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 825 | ?GetCategory@TUnicode@@QBE?AW4TCategory@TChar@@PBUTUnicodeDataSet@@@Z | ds00825.o | 707 | AR_INDEX:PopAndDestroy__12CleanupStacki; AR_INDEX:__imp_PopAndDestroy__12CleanupStacki; AR_INDEX:_imp__PopAndDestroy__12CleanupStacki; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 828 | ?GetCurrentDirectoryU@@YAP6GKKPAG@ZXZ | ds00828.o | 674 | AR_INDEX:Pop__12CleanupStack; AR_INDEX:__imp_Pop__12CleanupStack; AR_INDEX:_imp__Pop__12CleanupStack; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 855 | ?GetTitleCase@TChar@@QBEIXZ | ds00855.o | 656 | AR_INDEX:Ptr__C6TDesC8; AR_INDEX:__imp_Ptr__C6TDesC8; AR_INDEX:_imp__Ptr__C6TDesC8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 856 | ?GetUpperCase@TChar@@QBEIXZ | ds00856.o | 659 | AR_INDEX:Ptr__C7TDesC16; AR_INDEX:__imp_Ptr__C7TDesC16; AR_INDEX:_imp__Ptr__C7TDesC16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 858 | ?GetVolumeInformationU@@YAP6GHPBGPAGKPAK221K@ZXZ | ds00858.o | 701 | AR_INDEX:PushL__12CleanupStackP5CBase; AR_INDEX:__imp_PushL__12CleanupStackP5CBase; AR_INDEX:_imp__PushL__12CleanupStackP5CBase; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 869 | ?HandleInfo@RHandleBase@@QAEXPAVTHandleInfo@@@Z | ds00869.o | 674 | AR_INDEX:Rand__4MathR6TInt64; AR_INDEX:__imp_Rand__4MathR6TInt64; AR_INDEX:_imp__Rand__4MathR6TInt64; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 875 | ?HeapSortSigned@RPointerArrayBase@@IAEXXZ | ds00875.o | 668 | AR_INDEX:ReAlloc__4UserPvi; AR_INDEX:__imp_ReAlloc__4UserPvi; AR_INDEX:_imp__ReAlloc__4UserPvi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 933 | ?IsContainedBy@TRegion@@QBEHABVTRect@@@Z | ds00933.o | 695 | AR_INDEX:ResetInactivityTime__4User; AR_INDEX:__imp_ResetInactivityTime__4User; AR_INDEX:_imp__ResetInactivityTime__4User; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 954 | ?IsNaN@TRealX@@QBEHXZ | ds00954.o | 668 | AR_INDEX:Resume__C7RThread; AR_INDEX:__imp_Resume__C7RThread; AR_INDEX:_imp__Resume__C7RThread; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 956 | ?IsPresent@TUidType@@QBEHVTUid@@@Z | ds00956.o | 668 | AR_INDEX:Right__C7TDesC16i; AR_INDEX:__imp_Right__C7TDesC16i; AR_INDEX:_imp__Right__C7TDesC16i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 962 | ?IsUpper@TChar@@QBEHXZ | ds00962.o | 674 | AR_INDEX:RunError__7CActivei; AR_INDEX:__imp_RunError__7CActivei; AR_INDEX:_imp__RunError__7CActivei; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 979 | ?LeaveIfError@User@@SAHH@Z | ds00979.o | 674 | AR_INDEX:SetActive__7CActive; AR_INDEX:__imp_SetActive__7CActive; AR_INDEX:_imp__SetActive__7CActive; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1016 | ?Logon@RProcess@@QBEXAAVTRequestStatus@@@Z | ds01016.o | 734 | AR_INDEX:SetPriority__C7RThread15TThreadPriority; AR_INDEX:__imp_SetPriority__C7RThread15TThreadPriority; AR_INDEX:_imp__SetPriority__C7RThread15TThreadPriority; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1078 | ?Neg@TInt64A@@QAEXXZ | ds01078.o | 677 | AR_INDEX:Signal__10RSemaphore; AR_INDEX:__imp_Signal__10RSemaphore; AR_INDEX:_imp__Signal__10RSemaphore; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1086 | ?New@HBufC8@@SAPAV1@H@Z | ds01086.o | 656 | AR_INDEX:Size__C5TRect; AR_INDEX:__imp_Size__C5TRect; AR_INDEX:_imp__Size__C5TRect; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1107 | ?NewMax@HBufC8@@SAPAV1@H@Z | ds01107.o | 692 | AR_INDEX:Start__16CActiveScheduler; AR_INDEX:__imp_Start__16CActiveScheduler; AR_INDEX:_imp__Start__16CActiveScheduler; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1111 | ?NewMaxLC@HBufC8@@SAPAV1@H@Z | ds01111.o | 797 | AR_INDEX:Start__9CPeriodicG27TTimeIntervalMicroSeconds32T1G9TCallBack; AR_INDEX:__imp_Start__9CPeriodicG27TTimeIntervalMicroSeconds32T1G9TCallBack; AR_INDEX:_imp__Start__9CPeriodicG27TTimeIntervalMicroSeconds32T1G9TCallBack; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1113 | ?Next@TFindChunk@@QAEHAAV?$TBuf@$0BAA@@@@Z | ds01113.o | 689 | AR_INDEX:Stop__16CActiveScheduler; AR_INDEX:__imp_Stop__16CActiveScheduler; AR_INDEX:_imp__Stop__16CActiveScheduler; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1122 | ?Next@TFindThread@@QAEHAAV?$TBuf@$0BAA@@@@Z | ds01122.o | 671 | AR_INDEX:Suspend__C7RThread; AR_INDEX:__imp_Suspend__C7RThread; AR_INDEX:_imp__Suspend__C7RThread; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1148 | ?Offset@TLex8@@QBEHXZ | ds01148.o | 659 | AR_INDEX:Trap__5TTrapRi; AR_INDEX:__imp_Trap__5TTrapRi; AR_INDEX:_imp__Trap__5TTrapRi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1164 | ?OpenGlobal@RSemaphore@@QAEHABVTDesC16@@W4TOwnerType@@@Z | ds01164.o | 659 | AR_INDEX:UnTrap__5TTrap; AR_INDEX:__imp_UnTrap__5TTrap; AR_INDEX:_imp__UnTrap__5TTrap; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1212 | ?Protected@RThread@@QBEHXZ | ds01212.o | 671 | AR_INDEX:Wait__10RSemaphore; AR_INDEX:__imp_Wait__10RSemaphore; AR_INDEX:_imp__Wait__10RSemaphore; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1246 | ?Read@TBusLocalDrive@@QAEHVTInt64@@HPBXHH@Z | ds01246.o | 653 | AR_INDEX:Zero__5TDes8; AR_INDEX:__imp_Zero__5TDes8; AR_INDEX:_imp__Zero__5TDes8; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1247 | ?ReadL@CSession@@QBEXPBXAAVTDes16@@@Z | ds01247.o | 656 | AR_INDEX:Zero__6TDes16; AR_INDEX:__imp_Zero__6TDes16; AR_INDEX:_imp__Zero__6TDes16; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1262 | ?RectangleListW@TRegion@@IAEPAVTRect@@XZ | ds01262.o | 644 | AR_INDEX:_._5CBase; AR_INDEX:__imp__._5CBase; AR_INDEX:_imp___._5CBase; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1265 | ?RegisterClassU@@YAP6GGPBUtagWNDCLASSW@@@ZXZ | ds01265.o | 650 | AR_INDEX:_._7CActive; AR_INDEX:__imp__._7CActive; AR_INDEX:_imp___._7CActive; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1282 | ?Rename@RProcess@@QAEHABVTDesC16@@@Z | ds01282.o | 692 | AR_INDEX:__10TBufBase16RC7TDesC16i; AR_INDEX:__imp___10TBufBase16RC7TDesC16i; AR_INDEX:_imp____10TBufBase16RC7TDesC16i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1283 | ?Rename@RThread@@QBEHABVTDesC16@@@Z | ds01283.o | 662 | AR_INDEX:__10TBufBase16i; AR_INDEX:__imp___10TBufBase16i; AR_INDEX:_imp____10TBufBase16i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1343 | ?ServerStarted@UserSvr@@SAXXZ | ds01343.o | 677 | AR_INDEX:__16CActiveScheduler; AR_INDEX:__imp___16CActiveScheduler; AR_INDEX:_imp____16CActiveScheduler; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1359 | ?Set@TLongDateFormatSpec@@QAEXXZ | ds01359.o | 632 | AR_INDEX:__5CBase; AR_INDEX:__imp___5CBase; AR_INDEX:_imp____5CBase; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1366 | ?Set@TRealX@@QAEHH@Z | ds01366.o | 653 | AR_INDEX:__5TPtr8PUci; AR_INDEX:__imp___5TPtr8PUci; AR_INDEX:_imp____5TPtr8PUci; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1367 | ?Set@TRealX@@QAEHI@Z | ds01367.o | 656 | AR_INDEX:__5TPtr8PUcii; AR_INDEX:__imp___5TPtr8PUcii; AR_INDEX:_imp____5TPtr8PUcii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1370 | ?Set@TShortDateFormatSpec@@QAEXXZ | ds01370.o | 665 | AR_INDEX:__5TRectRC5TSize; AR_INDEX:__imp___5TRectRC5TSize; AR_INDEX:_imp____5TRectRC5TSize; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1373 | ?SetActive@CActive@@IAEXXZ | ds01373.o | 653 | AR_INDEX:__5TRectiiii; AR_INDEX:__imp___5TRectiiii; AR_INDEX:_imp____5TRectiiii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1379 | ?SetEnabled@Password@@SAHABV?$TBuf@$0BA@@@H@Z | ds01379.o | 647 | AR_INDEX:__6TInt64i; AR_INDEX:__imp___6TInt64i; AR_INDEX:_imp____6TInt64i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1386 | ?SetHour@TDateTime@@QAEHH@Z | ds01386.o | 659 | AR_INDEX:__6TPtrC8PCUci; AR_INDEX:__imp___6TPtrC8PCUci; AR_INDEX:_imp____6TPtrC8PCUci; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1395 | ?SetLength@TDes8@@QAEXH@Z | ds01395.o | 650 | AR_INDEX:__7CActivei; AR_INDEX:__imp___7CActivei; AR_INDEX:_imp____7CActivei; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1407 | ?SetOffset@TDblQueBase@@QAEXH@Z | ds01407.o | 659 | AR_INDEX:__7TPtrC16PCUs; AR_INDEX:__imp___7TPtrC16PCUs; AR_INDEX:_imp____7TPtrC16PCUs; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1422 | ?SetReserveFlatL@CArrayFixBase@@IAEXH@Z | ds01422.o | 650 | AR_INDEX:__8TVersion; AR_INDEX:__imp___8TVersion; AR_INDEX:_imp____8TVersion; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1431 | ?SetToLast@TDblQueIterBase@@QAEXXZ | ds01431.o | 656 | AR_INDEX:__9TBufBase8i; AR_INDEX:__imp___9TBufBase8i; AR_INDEX:_imp____9TBufBase8i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1432 | ?SetTrapHandler@User@@SAPAVTTrapHandler@@PAV2@@Z | ds01432.o | 659 | AR_INDEX:__9TBufBase8ii; AR_INDEX:__imp___9TBufBase8ii; AR_INDEX:_imp____9TBufBase8ii; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1455 | ?Size@CBitMapAllocator@@QAEHXZ | ds01455.o | 632 | AR_INDEX:__addsf3; AR_INDEX:__imp___addsf3; AR_INDEX:_imp____addsf3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1504 | ?Terminate@CSession@@QBEXH@Z | ds01504.o | 665 | AR_INDEX:__builtin_delete; AR_INDEX:__imp___builtin_delete; AR_INDEX:_imp____builtin_delete; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1505 | ?Terminate@RMessage@@QBEXH@Z | ds01505.o | 656 | AR_INDEX:__builtin_new; AR_INDEX:__imp___builtin_new; AR_INDEX:_imp____builtin_new; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1506 | ?Terminate@RProcess@@QAEXH@Z | ds01506.o | 677 | AR_INDEX:__builtin_vec_delete; AR_INDEX:__imp___builtin_vec_delete; AR_INDEX:_imp____builtin_vec_delete; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1507 | ?Terminate@RThread@@QAEXH@Z | ds01507.o | 668 | AR_INDEX:__builtin_vec_new; AR_INDEX:__imp___builtin_vec_new; AR_INDEX:_imp____builtin_vec_new; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1514 | ?TokenLength@TLex16@@QBEHVTLexMark16@@@Z | ds01514.o | 632 | AR_INDEX:__divsi3; AR_INDEX:__imp___divsi3; AR_INDEX:_imp____divsi3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1515 | ?TokenLength@TLex8@@QBEHVTLexMark8@@@Z | ds01515.o | 686 | AR_INDEX:__dv__C6TInt64RC6TInt64; AR_INDEX:__imp___dv__C6TInt64RC6TInt64; AR_INDEX:_imp____dv__C6TInt64RC6TInt64; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1520 | ?TrapHandler@User@@SAPAVTTrapHandler@@XZ | ds01520.o | 686 | AR_INDEX:__eq__C6TInt64RC6TInt64; AR_INDEX:__imp___eq__C6TInt64RC6TInt64; AR_INDEX:_imp____eq__C6TInt64RC6TInt64; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1527 | ?TrimRight@TDes16@@QAEXXZ | ds01527.o | 644 | AR_INDEX:__fixsfsi; AR_INDEX:__imp___fixsfsi; AR_INDEX:_imp____fixsfsi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1529 | ?Type@RHeap@@QBE?AW4THeapType@RHeapBase@@XZ | ds01529.o | 650 | AR_INDEX:__floatsisf; AR_INDEX:__imp___floatsisf; AR_INDEX:_imp____floatsisf; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1557 | ?Val@TLex16@@QAEHAANVTChar@@@Z | ds01557.o | 686 | AR_INDEX:__mi__C6TInt64RC6TInt64; AR_INDEX:__imp___mi__C6TInt64RC6TInt64; AR_INDEX:_imp____mi__C6TInt64RC6TInt64; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1569 | ?Val@TLex8@@QAEHAAKW4TRadix@@I@Z | ds01569.o | 632 | AR_INDEX:__modsi3; AR_INDEX:__imp___modsi3; AR_INDEX:_imp____modsi3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1571 | ?Val@TLex8@@QAEHAAMVTChar@@@Z | ds01571.o | 632 | AR_INDEX:__mulsf3; AR_INDEX:__imp___mulsf3; AR_INDEX:_imp____mulsf3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1575 | ?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z | ds01575.o | 686 | AR_INDEX:__ne__C6TInt64RC6TInt64; AR_INDEX:__imp___ne__C6TInt64RC6TInt64; AR_INDEX:_imp____ne__C6TInt64RC6TInt64; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1582 | ?Wait@RSemaphore@@QAEXXZ | ds01582.o | 659 | AR_INDEX:__nw__5CBaseUi; AR_INDEX:__imp___nw__5CBaseUi; AR_INDEX:_imp____nw__5CBaseUi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1611 | ?WritePasswordData@TBusLocalDrive@@SAHAAVTDesC8@@@Z | ds01611.o | 659 | AR_INDEX:__pure_virtual; AR_INDEX:__imp___pure_virtual; AR_INDEX:_imp____pure_virtual; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1614 | ?WsSwitchOnScreen@UserSvr@@SAXXZ | ds01614.o | 632 | AR_INDEX:__subsf3; AR_INDEX:__imp___subsf3; AR_INDEX:_imp____subsf3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1616 | ?Zero@TDes16@@QAEXXZ | ds01616.o | 644 | AR_INDEX:__udivsi3; AR_INDEX:__imp___udivsi3; AR_INDEX:_imp____udivsi3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 1636 | ?__DbgTestInvariant@TPtr8@@QBEXXZ | ds01636.o | 632 | AR_INDEX:__divdi3; AR_INDEX:__imp___divdi3; AR_INDEX:_imp____divdi3; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 65 | ?uncompress@@YAHPAEPAKPBEK@Z | ds00065.o | 695 | AR_INDEX:uncompress__FPUcPUlPCUcUl; AR_INDEX:__imp_uncompress__FPUcPUlPCUcUl; AR_INDEX:_imp__uncompress__FPUcPUlPCUcUl; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 16 | ?Alloc@CChunkPile@@QAEPAEIPAVCBitwiseBitmap@@@Z | ds00016.o | 747 | AR_INDEX:Create__10CFbsBitmapRC5TSize12TDisplayMode; AR_INDEX:__imp_Create__10CFbsBitmapRC5TSize12TDisplayMode; AR_INDEX:_imp__Create__10CFbsBitmapRC5TSize12TDisplayMode; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 17 | ?AscentInPixels@CFbsFont@@UBEHXZ | ds00017.o | 699 | AR_INDEX:DataAddress__C10CFbsBitmap; AR_INDEX:__imp_DataAddress__C10CFbsBitmap; AR_INDEX:_imp__DataAddress__C10CFbsBitmap; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 21 | ?CallBack@RFbsSession@@QAEXXZ | ds00021.o | 699 | AR_INDEX:DisplayMode__C10CFbsBitmap; AR_INDEX:__imp_DisplayMode__C10CFbsBitmap; AR_INDEX:_imp__DisplayMode__C10CFbsBitmap; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 76 | ?IncYPos@TBitmapUtil@@QAEXXZ | ds00076.o | 711 | AR_INDEX:Load__10CFbsBitmapRC7TDesC16li; AR_INDEX:__imp_Load__10CFbsBitmapRC7TDesC16li; AR_INDEX:_imp__Load__10CFbsBitmapRC7TDesC16li; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 110 | ?Save@CFbsBitmapAsyncStreamer@@QAEHABVTDesC16@@PAVCFbsBitmap@@AAJAAH@Z | ds00110.o | 702 | AR_INDEX:SizeInPixels__C10CFbsBitmap; AR_INDEX:__imp_SizeInPixels__C10CFbsBitmap; AR_INDEX:_imp__SizeInPixels__C10CFbsBitmap; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 135 | ?UnlockHeap@CFbsBitmap@@IBEXH@Z | ds00135.o | 663 | AR_INDEX:__10CFbsBitmap; AR_INDEX:__imp___10CFbsBitmap; AR_INDEX:_imp____10CFbsBitmap; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 101 | ?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z | ds00101.o | 732 | AR_INDEX:SetPosture__10TFontStyle12TFontPosture; AR_INDEX:__imp_SetPosture__10TFontStyle12TFontPosture; AR_INDEX:_imp__SetPosture__10TFontStyle12TFontPosture; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 108 | ?NewL@CPalette@@SAPAV1@H@Z | ds00108.o | 762 | AR_INDEX:SetStrokeWeight__10TFontStyle17TFontStrokeWeight; AR_INDEX:__imp_SetStrokeWeight__10TFontStyle17TFontStrokeWeight; AR_INDEX:_imp__SetStrokeWeight__10TFontStyle17TFontStrokeWeight; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 151 | ?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z | ds00151.o | 687 | AR_INDEX:__9TFontSpecRC7TDesC16i; AR_INDEX:__imp___9TFontSpecRC7TDesC16i; AR_INDEX:_imp____9TFontSpecRC7TDesC16i; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 1 | ?Get@HAL@@SAHW4TAttribute@HALData@@AAH@Z | ds00001.o | 714 | AR_INDEX:Get__3HALQ27HALData10TAttributeRi; AR_INDEX:__imp_Get__3HALQ27HALData10TAttributeRi; AR_INDEX:_imp__Get__3HALQ27HALData10TAttributeRi; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 1 | ?NewL@CMdaAudioOutputStream@@SAPAV1@AAVMMdaAudioOutputStreamCallback@@PAVCMdaServer@@@Z | ds00001.o | 859 | AR_INDEX:NewL__21CMdaAudioOutputStreamR29MMdaAudioOutputStreamCallbackP10CMdaServer; AR_INDEX:__imp_NewL__21CMdaAudioOutputStreamR29MMdaAudioOutputStreamCallbackP10CMdaServer; AR_INDEX:_imp__NewL__21CMdaAudioOutputStreamR29MMdaAudioOutputStreamCallbackP10CMdaServer; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 3 | ??0CMsgActive@@IAE@H@Z | ds00003.o | 766 | AR_INDEX:AddObserverL__11CMsvSessionR19MMsvSessionObserver; AR_INDEX:__imp_AddObserverL__11CMsvSessionR19MMsvSessionObserver; AR_INDEX:_imp__AddObserverL__11CMsvSessionR19MMsvSessionObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 143 | ?HasDirectoryL@CMsvServerEntry@@QBEHXZ | ds00143.o | 760 | AR_INDEX:OpenAsyncL__11CMsvSessionR19MMsvSessionObserver; AR_INDEX:__imp_OpenAsyncL__11CMsvSessionR19MMsvSessionObserver; AR_INDEX:_imp__OpenAsyncL__11CMsvSessionR19MMsvSessionObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 185 | ?NewL@CMsvServerEntry@@SAPAV1@AAVCMsvServer@@J@Z | ds00185.o | 772 | AR_INDEX:RemoveObserver__11CMsvSessionR19MMsvSessionObserver; AR_INDEX:__imp_RemoveObserver__11CMsvSessionR19MMsvSessionObserver; AR_INDEX:_imp__RemoveObserver__11CMsvSessionR19MMsvSessionObserver; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |

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
| 43 | ?BitBlt@CWindowGc@@UAEXABVTPoint@@PBVCWsBitmap@@@Z | ds00043.o | 682 | AR_INDEX:Connect__10RWsSession; AR_INDEX:__imp_Connect__10RWsSession; AR_INDEX:_imp__Connect__10RWsSession; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 74 | ?Construct@CWsScreenDevice@@QAEHXZ | ds00074.o | 676 | AR_INDEX:Close__10RWsSession; AR_INDEX:__imp_Close__10RWsSession; AR_INDEX:_imp__Close__10RWsSession; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 109 | ?DrawEllipse@CWindowGc@@UAEXABVTRect@@@Z | ds00109.o | 676 | AR_INDEX:Flush__10RWsSession; AR_INDEX:__imp_Flush__10RWsSession; AR_INDEX:_imp__Flush__10RWsSession; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
| 268 | ?SetWindowGroupOrdinalPosition@RWsSession@@QAEHHH@Z | ds00268.o | 661 | AR_INDEX:__10RWsSession; AR_INDEX:__imp___10RWsSession; AR_INDEX:_imp____10RWsSession; .text; `.data; .idata$7; @.idata$5; @.idata$4; @.idata$6 |
