# Step 45 — SDK-mapped import correction and validation

- Step46 recovered the original game's ARM UREL archive-index identities; WINS UDEB names are reference data only.
- EUSER3=CBase::newL; EUSER1407=TPtrC16 constructor; EUSER1575=TInt64 inequality; EUSER1582=CBase::operator new.
- EUSER1373/530/711=TRect constructor/Height/Move; CONE160=CCoeControl::Rect.
- GDI151=TFontSpec constructor; GDI108/101=TFontStyle stroke-weight/posture setters.
- Corrected HLE routes are exercised by the passing host regression suite; target N95 ROM exports are not yet cross-checked.

## Host regression suite

BEGIN HOST LOG
PASS: all three sites pass the engine bitmap-object field at +0x2E4
PASS: two sites store the return as a pixel-buffer pointer at engine-child +0x480
PASS: first consumer zero-fills 0x11E00 bytes through that return pointer
PASS: third site stores the same return in engine +0x300 for later propagation
PASS: ordinal 17 is called with only the bitmap receiver deliberately set
INFERENCE: ordinal 135 = CFbsBitmap construction; ordinal 16 = Create(TSize&,TDisplayMode)
INFERENCE: ordinal 17 = CFbsBitmap::DataAddress() (high confidence; no FP1 EAT proof)
  GFX HLE: DrawText(gc=10100000 desc=10100100 point=10100200 (-2,3) baseline=-15 align=2 margin=7) [diagnostic only; no glyph rasterization]
  GFX RAW descriptor @10100100: 05 00 00 30 00 01 00 00 48 00 45 00 4c 00 4c 00 4f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  GFX RAW point @10100200: fe ff ff ff 03 00 00 00
  GFX RAW stack-args @10100300: 02 00 00 00 07 00 00 00
PASS: DrawText ABI register/stack decode; TPoint coordinates; no unintended pixel writes
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000017 r2=fffffff8 r3=deadbeef sp=10101000 lr=00000000 cpsr=00000000
  HLE ARM EUSER711 TRect::Move this=10100000 dx=23 dy=-8
PASS: ARM UREL EUSER711 TRect::Move translates top-left and bottom-right
PASS: ARM UREL TPtrC16, TInt64, TRect, CCoeControl::Rect and TFontStyle helpers
PASS: ARM Operand2 LSL/LSR/ASR/ROR/RRX immediate and register semantics, including shifter carry
PASS: 4961 shifted ARM data-processing instructions now use full Operand2 semantics; generator cases pass
IMPORT dll=EUSER[100039e5].DLL ord=1373 r0=10100000 r1=fffffffb r2=00000007 r3=00000064 sp=10101000 lr=10022c60 cpsr=00000000
  HLE ARM EUSER1373 TRect ctor this=10100000 (-5,7)-(100,160)
IMPORT dll=EUSER[100039e5].DLL ord=530 r0=10100000 r1=fffffffb r2=00000007 r3=00000064 sp=10101000 lr=10022c68 cpsr=00000000
  HLE ARM EUSER530 TRect::Height this=10100000 -> 153
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000017 r2=fffffff8 r3=00000064 sp=10101000 lr=1002350c cpsr=00000000
  HLE ARM EUSER711 TRect::Move this=10100000 dx=23 dy=-8
PASS: ARM UREL EUSER1373 TRect ctor, EUSER530 Height, EUSER711 Move
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=10001000 r1=10002000 r2=00000000 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER1407 TPtrC16 this=10001000 source=10002000 length=5
IMPORT dll=GDI[10003b15].DLL ord=151 r0=10003000 r1=10001000 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM GDI151 TFontSpec this=10003000 nameDesc=10001000 heightTwips=213 size=64
IMPORT dll=GDI[10003b15].DLL ord=108 r0=1000303c r1=00000001 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM GDI108 TFontStyle::SetStrokeWeight this=1000303c value=1 flags=00000002
IMPORT dll=GDI[10003b15].DLL ord=101 r0=1000303c r1=00000001 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM GDI101 TFontStyle::SetPosture this=1000303c value=1 flags=00000003
IMPORT dll=CONE[10003a41].DLL ord=160 r0=10005000 r1=10004000 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM CONE160 CCoeControl::Rect this=10004000 -> (17,-23)-(97,22)
IMPORT dll=EUSER[100039e5].DLL ord=1575 r0=10006000 r1=10006010 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER1575 TInt64::operator!= lhs=10006000 rhs=10006010 -> 1
IMPORT dll=EUSER[100039e5].DLL ord=1582 r0=0000022c r1=10006010 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER1582 CBase::operator new size=556 -> 10120000
IMPORT dll=EUSER[100039e5].DLL ord=3 r0=00000028 r1=10006010 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER3 CBase::newL size=40 -> 10120230
IMPORT dll=EIKCORE[10004892].DLL ord=222 r0=10008000 r1=10006010 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EIKCORE222 CEikApplication this=10008000 caption=TBuf<256> size=556
IMPORT dll=EIKCORE[10004892].DLL ord=219 r0=10009000 r1=10008000 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EIKCORE219 CEikDocument this=10009000 app=10008000 process=1000b000
IMPORT dll=EUSER[100039e5].DLL ord=858 r0=10009000 r1=10008000 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER858 CleanupStack::PushL ptr=10009000 depth=1
IMPORT dll=EUSER[100039e5].DLL ord=828 r0=00000000 r1=10008000 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER828 CleanupStack::Pop depth=0
PASS: ARM UREL TPtrC16, TFontSpec64, TFontStyle, CCoeControl::Rect, TInt64, CBase allocation, CEikApplication, CEikDocument and CleanupStack constructors/operations
END HOST LOG

## Live trace runner


Live trace exit code: 95. Exit 95 is an intentional fail-closed stop.

## Selected trace evidence

  HLE ARM EUSER1582 CBase::operator new size=556 -> 10110000
  HLE ARM EIKCORE222 CEikApplication this=10110000 caption=TBuf<256> size=556
  HLE ARM EUSER3 CBase::newL size=40 -> 10110230
  HLE ARM EIKCORE219 CEikDocument this=10110230 app=10110000 process=00000000
  HLE ARM EUSER858 CleanupStack::PushL ptr=10110230 depth=1
  HLE ARM EUSER828 CleanupStack::Pop depth=0
  HLE ARM EUSER3 CBase::newL size=108 -> 10110258
HALT UNIMPLEMENTED Shadowkey import: EIKCORE[10004892].DLL ordinal=224 r0=10110258 r1=10110000 r2=00000000 r3=100fd828 sp=102feff0 lr=10021144

## ARM callsite context

# Step 50 — lifted ARM callsite context for EIKCORE constructors

Generated from the committed lifted ARM source. The listed import thunk
addresses come from shadowkey_import_dispatch.c and the ARM UREL names
come from docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md.

## EIKCORE 222 CEikApplication constructor

- Thunk: 0x1009fa00u
- Call sites: 1

### sub_1002841c, source line 78016

~~~c
}

void sub_1002841c(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_1002841c; goto L_10028420; goto L_10028424; goto L_10028428; goto L_1002842c; goto L_10028430; goto L_10028434; goto L_10028438; goto L_1002843c; goto L_10028440; goto L_10028444; goto L_1002844c; goto L_10028450; }
L_1002841c:
    c->r[13] -= 8u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[14]); /* push {r4, lr} */
L_10028420:
    c->r[0] = 0x0000022cu; /* mov r0, #556 */
L_10028424:
    c->r[14] = 0x10028428u; ngage_call(c, 0x1009eef0u); goto L_10028428; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10028428:
    c->r[4] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r4, r0, #0 */
L_1002842c:
    if (ngage_zf(c)) { goto L_10028440; } /* beq 0x28440 <shadowkey_code+0x28440> */
L_10028430:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_10028434:
    c->r[14] = 0x10028438u; ngage_call(c, 0x1009fa00u); goto L_10028438; /* bl 0x9fa00 <shadowkey_code+0x9fa00> */
L_10028438:
    c->r[3] = 0x100fd9bcu; /* literal 0x10028448 */ /* ldr r3, [pc, #0x8] */
L_1002843c:
    ngage_w32(c, c->r[4], (uint32_t)c->r[3]); /* str r3, [r4] */
L_10028440:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_10028444:
    goto L_1002844c; /* b 0x2844c <shadowkey_code+0x2844c> */
L_1002844c:
    c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[14] = ngage_r32(c, c->r[13] + 4u); c->r[13] += 8u; /* pop {r4, lr} */
L_10028450:
    return; /* bx lr */
}

void sub_1002845c(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_1002845c; goto L_10028460; goto L_10028464; goto L_10028468; goto L_1002846c; goto L_10028470; goto L_10028474; goto L_10028478; goto L_1002847c; goto L_10028480; goto L_10028484; goto L_10028488; goto L_1002848c; goto L_10028490; goto L_10028494; goto L_10028498; goto L_1002849c; goto L_100284a0; goto L_100284a4; goto L_100284a8; goto L_100284ac; goto L_100284b0; goto L_100284b4; goto L_100284b8; goto L_100284bc; goto L_100284c0; goto L_100284c4; goto L_100284d0; goto L_100284d4; goto L_100284d8; }
L_1002845c:
    c->r[13] -= 16u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[14]); /* push {r4, r5, r6, lr} */
L_10028460:
    c->r[13] = c->r[13] - 0x00000008u; /* sub sp, sp, #8 */
~~~

## EIKCORE 219 CEikDocument constructor

- Thunk: 0x1009f900u
- Call sites: 1

### sub_10028390, source line 77920

~~~c
L_10028370:
    if (!ngage_zf(c)) { c->r[14] = 0x10028374u; ngage_call(c, 0x10021138u); goto L_10028374; } /* blne 0x21138 <shadowkey_code+0x21138> */
L_10028374:
    ngage_w32(c, (c->r[4] + 36u), (uint32_t)c->r[0]); /* str r0, [r4, #0x24] */
L_10028378:
    c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[14] = ngage_r32(c, c->r[13] + 4u); c->r[13] += 8u; /* pop {r4, lr} */
L_1002837c:
    return; /* bx lr */
}

void sub_10028390(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_10028390; goto L_10028394; goto L_10028398; goto L_1002839c; goto L_100283a0; goto L_100283a4; goto L_100283a8; goto L_100283b0; goto L_100283b4; }
L_10028390:
    c->r[13] -= 8u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[14]); /* push {r4, lr} */
L_10028394:
    c->r[4] = c->r[0]; /* mov r4, r0 */
L_10028398:
    c->r[14] = 0x1002839cu; ngage_call(c, 0x1009f900u); goto L_1002839c; /* bl 0x9f900 <shadowkey_code+0x9f900> */
L_1002839c:
    c->r[3] = 0x100fd828u; /* literal 0x100283ac */ /* ldr r3, [pc, #0x8] */
L_100283a0:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_100283a4:
    ngage_w32(c, c->r[4], (uint32_t)c->r[3]); /* str r3, [r4] */
L_100283a8:
    goto L_100283b0; /* b 0x283b0 <shadowkey_code+0x283b0> */
L_100283b0:
    c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[14] = ngage_r32(c, c->r[13] + 4u); c->r[13] += 8u; /* pop {r4, lr} */
L_100283b4:
    return; /* bx lr */
}

void sub_100283b8(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_100283b8; }
L_100283b8:
    return; /* bx lr */
}

~~~

## EIKCORE 224 CEikAppUi constructor

- Thunk: 0x1009f700u
- Call sites: 1

### sub_10021138, source line 63925

~~~c
L_10021110:
    c->r[14] = 0x10021114u; ngage_call(c, 0x1009fae0u); goto L_10021114; /* bl 0x9fae0 <shadowkey_code+0x9fae0> */
L_10021114:
    goto L_10021130; /* b 0x21130 <shadowkey_code+0x21130> */
L_10021130:
    c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[14] = ngage_r32(c, c->r[13] + 8u); c->r[13] += 12u; /* pop {r4, r5, lr} */
L_10021134:
    return; /* bx lr */
}

void sub_10021138(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_10021138; goto L_1002113c; goto L_10021140; goto L_10021144; goto L_10021148; goto L_1002114c; goto L_10021150; goto L_10021154; goto L_10021158; goto L_1002115c; goto L_10021160; goto L_10021164; goto L_10021168; goto L_1002116c; goto L_10021170; goto L_10021174; goto L_10021178; goto L_1002117c; goto L_10021180; goto L_10021184; goto L_10021188; goto L_1002118c; goto L_10021190; goto L_100211b8; goto L_100211bc; }
L_10021138:
    c->r[13] -= 8u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[14]); /* push {r4, lr} */
L_1002113c:
    c->r[4] = c->r[0]; /* mov r4, r0 */
L_10021140:
    c->r[14] = 0x10021144u; ngage_call(c, 0x1009f700u); goto L_10021144; /* bl 0x9f700 <shadowkey_code+0x9f700> */
L_10021144:
    c->r[3] = 0x100fdc90u; /* literal 0x10021194 */ /* ldr r3, [pc, #0x48] */
L_10021148:
    ngage_w32(c, (c->r[4] + 72u), (uint32_t)c->r[3]); /* str r3, [r4, #0x48] */
L_1002114c:
    c->r[2] = 0x100fe050u; /* literal 0x10021198 */ /* ldr r2, [pc, #0x44] */
L_10021150:
    ngage_w32(c, (c->r[4] + 76u), (uint32_t)c->r[2]); /* str r2, [r4, #0x4c] */
L_10021154:
    c->r[0] = 0x100fff54u; /* literal 0x1002119c */ /* ldr r0, [pc, #0x40] */
L_10021158:
    ngage_w32(c, (c->r[4] + 28u), (uint32_t)c->r[0]); /* str r0, [r4, #0x1c] */
L_1002115c:
    c->r[3] = 0x100ffe88u; /* literal 0x100211a0 */ /* ldr r3, [pc, #0x3c] */
L_10021160:
    ngage_w32(c, c->r[4], (uint32_t)c->r[3]); /* str r3, [r4] */
L_10021164:
    c->r[14] = 0x100fff00u; /* literal 0x100211a4 */ /* ldr lr, [pc, #0x38] */
L_10021168:
    ngage_w32(c, (c->r[4] + 20u), (uint32_t)c->r[14]); /* str lr, [r4, #0x14] */
L_1002116c:
~~~

## EUSER 1582 CBase::operator new

- Thunk: 0x1009eef0u
- Call sites: 10

### sub_10008fe8, source line 17553

~~~c
L_10008fe0:
    c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[9] = ngage_r32(c, c->r[13] + 20u); c->r[10] = ngage_r32(c, c->r[13] + 24u); c->r[14] = ngage_r32(c, c->r[13] + 28u); c->r[13] += 32u; /* pop {r4, r5, r6, r7, r8, r9, r10, lr} */
L_10008fe4:
    return; /* bx lr */
}

void sub_10008fe8(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_10008fe8; goto L_10008fec; goto L_10008ff0; goto L_10008ff4; goto L_10008ff8; goto L_10008ffc; goto L_10009000; goto L_10009004; goto L_10009008; goto L_1000900c; goto L_10009010; goto L_10009014; goto L_10009018; goto L_1000901c; goto L_10009020; goto L_10009024; goto L_10009028; goto L_1000902c; goto L_10009030; goto L_10009034; goto L_10009038; goto L_1000903c; goto L_10009040; goto L_10009044; goto L_10009048; goto L_1000904c; goto L_10009050; goto L_10009054; goto L_10009058; goto L_1000905c; goto L_10009060; goto L_10009064; goto L_10009068; goto L_1000906c; goto L_10009070; goto L_10009074; goto L_10009078; goto L_1000907c; goto L_10009080; goto L_10009084; goto L_10009088; goto L_1000908c; goto L_10009090; goto L_10009094; goto L_10009098; goto L_1000909c; goto L_100090a0; goto L_100090a4; goto L_100090a8; goto L_100090b0; goto L_100090b4; goto L_100090b8; }
L_10008fe8:
    c->r[13] -= 16u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[14]); /* push {r4, r5, r6, lr} */
L_10008fec:
    c->r[13] = c->r[13] - 0x0000005cu; /* sub sp, sp, #92 */
L_10008ff0:
    c->r[6] = c->r[0]; /* mov r6, r0 */
L_10008ff4:
    c->r[0] = 0x00000014u; /* mov r0, #20 */
L_10008ff8:
    c->r[14] = 0x10008ffcu; ngage_call(c, 0x1009eef0u); goto L_10008ffc; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10008ffc:
    c->r[5] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r5, r0, #0 */
L_10009000:
    if (ngage_zf(c)) { goto L_10009010; } /* beq 0x9010 <shadowkey_code+0x9010> */
L_10009004:
    c->r[0] = c->r[5]; /* mov r0, r5 */
L_10009008:
    c->r[14] = 0x1000900cu; ngage_call(c, 0x1009ef00u); goto L_1000900c; /* bl 0x9ef00 <shadowkey_code+0x9ef00> */
L_1000900c:
    c->r[5] = c->r[0]; /* mov r5, r0 */
L_10009010:
    c->r[0] = c->r[5]; /* mov r0, r5 */
L_10009014:
    c->r[14] = 0x10009018u; ngage_call(c, 0x1009ef10u); goto L_10009018; /* bl 0x9ef10 <shadowkey_code+0x9ef10> */
L_10009018:
    c->r[0] = c->r[5]; /* mov r0, r5 */
L_1000901c:
    c->r[14] = 0x10009020u; ngage_call(c, 0x1009ef20u); goto L_10009020; /* bl 0x9ef20 <shadowkey_code+0x9ef20> */
L_10009020:
    c->r[0] = c->r[13] + 0x00000010u; /* add r0, sp, #16 */
L_10009024:
~~~

### sub_10023ad0, source line 69361

~~~c
    c->r[14] = 0x10023d68u; ngage_call(c, 0x1008117cu); goto L_10023d68; /* bl 0x8117c <shadowkey_code+0x8117c> */
L_10023d68:
    c->r[3] = ngage_r32(c, (c->r[7] + 48u)); /* ldr r3, [r7, #0x30] */
L_10023d6c:
    ngage_w32(c, (c->r[3] + 8u), (uint32_t)c->r[7]); /* str r7, [r3, #0x8] */
L_10023d70:
    c->r[0] = c->r[8]; /* mov r0, r8 */
L_10023d74:
    c->r[1] = c->r[4]; /* mov r1, r4 */
L_10023d78:
    c->r[14] = 0x10023d7cu; ngage_call(c, 0x10080e28u); goto L_10023d7c; /* bl 0x80e28 <shadowkey_code+0x80e28> */
L_10023d7c:
    c->r[0] = c->r[7]; /* mov r0, r7 */
L_10023d80:
    c->r[14] = 0x10023d84u; ngage_call(c, 0x10027aecu); goto L_10023d84; /* bl 0x27aec <shadowkey_code+0x27aec> */
L_10023d84:
    c->r[0] = 0x0000002cu; /* mov r0, #44 */
L_10023d88:
    c->r[14] = 0x10023d8cu; ngage_call(c, 0x1009eef0u); goto L_10023d8c; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10023d8c:
    ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
L_10023d90:
    if (!ngage_zf(c)) { c->r[14] = 0x10023d94u; ngage_call(c, 0x100a02e0u); goto L_10023d94; } /* blne 0xa02e0 <shadowkey_code+0xa02e0> */
L_10023d94:
    ngage_w32(c, (c->r[7] + 928u), (uint32_t)c->r[0]); /* str r0, [r7, #0x3a0] */
L_10023d98:
    c->r[14] = 0x10023d9cu; ngage_call(c, 0x100a02f0u); goto L_10023d9c; /* bl 0xa02f0 <shadowkey_code+0xa02f0> */
L_10023d9c:
    c->r[0] = 0x00000018u; /* mov r0, #24 */
L_10023da0:
    c->r[14] = 0x10023da4u; ngage_call(c, 0x1009eef0u); goto L_10023da4; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10023da4:
    c->r[6] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r6, r0, #0 */
L_10023da8:
    if (ngage_zf(c)) { goto L_10023de8; } /* beq 0x23de8 <shadowkey_code+0x23de8> */
L_10023dac:
    c->r[4] = ngage_r32(c, (c->r[7] + 928u)); /* ldr r4, [r7, #0x3a0] */
L_10023db0:
    c->r[0] = c->r[6]; /* mov r0, r6 */
L_10023db4:
~~~

### sub_10023ad0, source line 69373

~~~c
    c->r[0] = c->r[7]; /* mov r0, r7 */
L_10023d80:
    c->r[14] = 0x10023d84u; ngage_call(c, 0x10027aecu); goto L_10023d84; /* bl 0x27aec <shadowkey_code+0x27aec> */
L_10023d84:
    c->r[0] = 0x0000002cu; /* mov r0, #44 */
L_10023d88:
    c->r[14] = 0x10023d8cu; ngage_call(c, 0x1009eef0u); goto L_10023d8c; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10023d8c:
    ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
L_10023d90:
    if (!ngage_zf(c)) { c->r[14] = 0x10023d94u; ngage_call(c, 0x100a02e0u); goto L_10023d94; } /* blne 0xa02e0 <shadowkey_code+0xa02e0> */
L_10023d94:
    ngage_w32(c, (c->r[7] + 928u), (uint32_t)c->r[0]); /* str r0, [r7, #0x3a0] */
L_10023d98:
    c->r[14] = 0x10023d9cu; ngage_call(c, 0x100a02f0u); goto L_10023d9c; /* bl 0xa02f0 <shadowkey_code+0xa02f0> */
L_10023d9c:
    c->r[0] = 0x00000018u; /* mov r0, #24 */
L_10023da0:
    c->r[14] = 0x10023da4u; ngage_call(c, 0x1009eef0u); goto L_10023da4; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10023da4:
    c->r[6] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r6, r0, #0 */
L_10023da8:
    if (ngage_zf(c)) { goto L_10023de8; } /* beq 0x23de8 <shadowkey_code+0x23de8> */
L_10023dac:
    c->r[4] = ngage_r32(c, (c->r[7] + 928u)); /* ldr r4, [r7, #0x3a0] */
L_10023db0:
    c->r[0] = c->r[6]; /* mov r0, r6 */
L_10023db4:
    c->r[14] = 0x10023db8u; ngage_call(c, 0x1009edb0u); goto L_10023db8; /* bl 0x9edb0 <shadowkey_code+0x9edb0> */
L_10023db8:
    c->r[5] = 0x00000000u; /* mov r5, #0 */
L_10023dbc:
    ngage_w32(c, (c->r[6] + 4u), (uint32_t)c->r[5]); /* str r5, [r6, #0x4] */
L_10023dc0:
    ngage_w32(c, (c->r[6] + 8u), (uint32_t)c->r[4]); /* str r4, [r6, #0x8] */
L_10023dc4:
    c->r[3] = 0x100fd9b0u; /* literal 0x10023eb8 */ /* ldr r3, [pc, #0xec] */
L_10023dc8:
    ngage_w32(c, c->r[6], (uint32_t)c->r[3]); /* str r3, [r6] */
L_10023dcc:
~~~

### sub_1002841c, source line 78008

~~~c
L_1002840c:
    c->r[14] = 0x10028410u; ngage_call(c, 0x1009f050u); goto L_10028410; /* bl 0x9f050 <shadowkey_code+0x9f050> */
L_10028410:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_10028414:
    c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[14] = ngage_r32(c, c->r[13] + 4u); c->r[13] += 8u; /* pop {r4, lr} */
L_10028418:
    return; /* bx lr */
}

void sub_1002841c(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_1002841c; goto L_10028420; goto L_10028424; goto L_10028428; goto L_1002842c; goto L_10028430; goto L_10028434; goto L_10028438; goto L_1002843c; goto L_10028440; goto L_10028444; goto L_1002844c; goto L_10028450; }
L_1002841c:
    c->r[13] -= 8u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[14]); /* push {r4, lr} */
L_10028420:
    c->r[0] = 0x0000022cu; /* mov r0, #556 */
L_10028424:
    c->r[14] = 0x10028428u; ngage_call(c, 0x1009eef0u); goto L_10028428; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10028428:
    c->r[4] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r4, r0, #0 */
L_1002842c:
    if (ngage_zf(c)) { goto L_10028440; } /* beq 0x28440 <shadowkey_code+0x28440> */
L_10028430:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_10028434:
    c->r[14] = 0x10028438u; ngage_call(c, 0x1009fa00u); goto L_10028438; /* bl 0x9fa00 <shadowkey_code+0x9fa00> */
L_10028438:
    c->r[3] = 0x100fd9bcu; /* literal 0x10028448 */ /* ldr r3, [pc, #0x8] */
L_1002843c:
    ngage_w32(c, c->r[4], (uint32_t)c->r[3]); /* str r3, [r4] */
L_10028440:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_10028444:
    goto L_1002844c; /* b 0x2844c <shadowkey_code+0x2844c> */
L_1002844c:
    c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[14] = ngage_r32(c, c->r[13] + 4u); c->r[13] += 8u; /* pop {r4, lr} */
L_10028450:
    return; /* bx lr */
}
~~~

### <enclosing function not identified>, source line 212195

~~~c
    c->r[3] = ngage_r32(c, (c->r[7] + 12u)); /* ldr r3, [r7, #0xc] */
L_1006e16c:
    ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
L_1006e170:
    if (ngage_zf(c)) { c->r[0] = ~(0x00000001u); } /* mvneq r0, #1 */
L_1006e174:
    if (ngage_zf(c)) { c->r[14] = 0x1006e178u; ngage_call(c, 0x1009ee00u); goto L_1006e178; } /* bleq 0x9ee00 <shadowkey_code+0x9ee00> */
L_1006e178:
    c->r[1] = ngage_r32(c, (c->r[7] + 4u)); /* ldr r1, [r7, #0x4] */
L_1006e17c:
    c->r[0] = c->r[13] + 0x00000870u; /* add r0, sp, #2160 */
L_1006e180:
    c->r[0] = c->r[0] + 0x00000004u; /* add r0, r0, #4 */
L_1006e184:
    c->r[14] = 0x1006e188u; ngage_call(c, 0x100a0140u); goto L_1006e188; /* bl 0xa0140 <shadowkey_code+0xa0140> */
L_1006e188:
    c->r[0] = 0x00000070u; /* mov r0, #112 */
L_1006e18c:
    c->r[14] = 0x1006e190u; ngage_call(c, 0x1009eef0u); goto L_1006e190; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_1006e190:
    c->r[4] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r4, r0, #0 */
L_1006e194:
    if (ngage_zf(c)) { goto L_1006e1a8; } /* beq 0x6e1a8 <shadowkey_code+0x6e1a8> */
L_1006e198:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_1006e19c:
    c->r[1] = c->r[10]; /* mov r1, r10 */
L_1006e1a0:
    c->r[14] = 0x1006e1a4u; ngage_call(c, 0x100914a0u); goto L_1006e1a4; /* bl 0x914a0 <shadowkey_code+0x914a0> */
L_1006e1a4:
    c->r[4] = c->r[0]; /* mov r4, r0 */
L_1006e1a8:
    c->r[3] = ngage_r32(c, (c->r[13] + 2168u)); /* ldr r3, [sp, #0x878] */
L_1006e1ac:
    c->r[1] = 0x100b2174u; /* literal 0x1006e1dc */ /* ldr r1, [pc, #0x28] */
L_1006e1b0:
    ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
L_1006e1b4:
    if (!ngage_zf(c)) { c->r[1] = ngage_r32(c, c->r[3]); } /* ldrne r1, [r3] */
L_1006e1b8:
~~~

### <enclosing function not identified>, source line 212507

~~~c
    if (ngage_zf(c)) { c->r[14] = 0x1006e43cu; ngage_call(c, 0x1009ee00u); goto L_1006e43c; } /* bleq 0x9ee00 <shadowkey_code+0x9ee00> */
L_1006e43c:
    c->r[0] = ngage_r32(c, (c->r[7] + 4u)); /* ldr r0, [r7, #0x4] */
L_1006e440:
    c->r[14] = 0x1006e444u; ngage_call(c, 0x100a0110u); goto L_1006e444; /* bl 0xa0110 <shadowkey_code+0xa0110> */
L_1006e444:
    c->r[2] = ngage_r32(c, (c->r[10] + 52u)); /* ldr r2, [r10, #0x34] */
L_1006e448:
    c->r[3] = 0x0000df00u; /* mov r3, #57088 */
L_1006e44c:
    c->r[3] = c->r[3] + 0x00000068u; /* add r3, r3, #104 */
L_1006e450:
    ngage_w32(c, (c->r[2] + c->r[3]), (uint32_t)c->r[0]); /* str r0, [r2, r3] */
L_1006e454:
    goto L_1006dd3c; /* b 0x6dd3c <shadowkey_code+0x6dd3c> */
L_1006e458:
    c->r[0] = 0x00000030u; /* mov r0, #48 */
L_1006e45c:
    c->r[14] = 0x1006e460u; ngage_call(c, 0x1009eef0u); goto L_1006e460; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_1006e460:
    c->r[4] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r4, r0, #0 */
L_1006e464:
    if (ngage_zf(c)) { goto L_1006e488; } /* beq 0x6e488 <shadowkey_code+0x6e488> */
L_1006e468:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_1006e46c:
    c->r[14] = 0x1006e470u; ngage_call(c, 0x100a03f0u); goto L_1006e470; /* bl 0xa03f0 <shadowkey_code+0xa03f0> */
L_1006e470:
    c->r[3] = 0x100fb8b8u; /* literal 0x1006e4d8 */ /* ldr r3, [pc, #0x60] */
L_1006e474:
    ngage_w32(c, (c->r[4] + 4u), (uint32_t)c->r[3]); /* str r3, [r4, #0x4] */
L_1006e478:
    c->r[2] = 0x100fb8acu; /* literal 0x1006e4dc */ /* ldr r2, [pc, #0x5c] */
L_1006e47c:
    ngage_w32(c, c->r[4], (uint32_t)c->r[2]); /* str r2, [r4] */
L_1006e480:
    c->r[0] = c->r[4] + 0x00000008u; /* add r0, r4, #8 */
L_1006e484:
    c->r[14] = 0x1006e488u; ngage_call(c, 0x1008c7e0u); goto L_1006e488; /* bl 0x8c7e0 <shadowkey_code+0x8c7e0> */
L_1006e488:
~~~

### sub_10073bd8, source line 222778

~~~c
    ngage_w32(c, (c->r[5] + 44u), (uint32_t)c->r[3]); /* str r3, [r5, #0x2c] */
L_10073c68:
    c->r[7] = 0x00000000u; /* mov r7, #0 */
L_10073c6c:
    ngage_w32(c, (c->r[5] + 124u), (uint32_t)c->r[7]); /* str r7, [r5, #0x7c] */
L_10073c70:
    ngage_w32(c, (c->r[5] + 68u), (uint32_t)c->r[7]); /* str r7, [r5, #0x44] */
L_10073c74:
    ngage_w32(c, (c->r[5] + 100u), (uint32_t)c->r[7]); /* str r7, [r5, #0x64] */
L_10073c78:
    ngage_w8(c, (c->r[5] + 72u), (uint8_t)c->r[7]); /* strb r7, [r5, #0x48] */
L_10073c7c:
    ngage_w8(c, (c->r[5] + 73u), (uint8_t)c->r[7]); /* strb r7, [r5, #0x49] */
L_10073c80:
    ngage_w8(c, (c->r[5] + 96u), (uint8_t)c->r[7]); /* strb r7, [r5, #0x60] */
L_10073c84:
    c->r[0] = 0x0000002cu; /* mov r0, #44 */
L_10073c88:
    c->r[14] = 0x10073c8cu; ngage_call(c, 0x1009eef0u); goto L_10073c8c; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10073c8c:
    ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
L_10073c90:
    if (!ngage_zf(c)) { c->r[14] = 0x10073c94u; ngage_call(c, 0x100a02e0u); goto L_10073c94; } /* blne 0xa02e0 <shadowkey_code+0xa02e0> */
L_10073c94:
    ngage_w32(c, (c->r[5] + 128u), (uint32_t)c->r[0]); /* str r0, [r5, #0x80] */
L_10073c98:
    c->r[14] = 0x10073c9cu; ngage_call(c, 0x100a02f0u); goto L_10073c9c; /* bl 0xa02f0 <shadowkey_code+0xa02f0> */
L_10073c9c:
    c->r[0] = 0x00000018u; /* mov r0, #24 */
L_10073ca0:
    c->r[14] = 0x10073ca4u; ngage_call(c, 0x1009eef0u); goto L_10073ca4; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10073ca4:
    c->r[6] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r6, r0, #0 */
L_10073ca8:
    if (ngage_zf(c)) { goto L_10073ce4; } /* beq 0x73ce4 <shadowkey_code+0x73ce4> */
L_10073cac:
    c->r[4] = ngage_r32(c, (c->r[5] + 128u)); /* ldr r4, [r5, #0x80] */
L_10073cb0:
    c->r[0] = c->r[6]; /* mov r0, r6 */
L_10073cb4:
~~~

### sub_10073bd8, source line 222790

~~~c
    ngage_w8(c, (c->r[5] + 73u), (uint8_t)c->r[7]); /* strb r7, [r5, #0x49] */
L_10073c80:
    ngage_w8(c, (c->r[5] + 96u), (uint8_t)c->r[7]); /* strb r7, [r5, #0x60] */
L_10073c84:
    c->r[0] = 0x0000002cu; /* mov r0, #44 */
L_10073c88:
    c->r[14] = 0x10073c8cu; ngage_call(c, 0x1009eef0u); goto L_10073c8c; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10073c8c:
    ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
L_10073c90:
    if (!ngage_zf(c)) { c->r[14] = 0x10073c94u; ngage_call(c, 0x100a02e0u); goto L_10073c94; } /* blne 0xa02e0 <shadowkey_code+0xa02e0> */
L_10073c94:
    ngage_w32(c, (c->r[5] + 128u), (uint32_t)c->r[0]); /* str r0, [r5, #0x80] */
L_10073c98:
    c->r[14] = 0x10073c9cu; ngage_call(c, 0x100a02f0u); goto L_10073c9c; /* bl 0xa02f0 <shadowkey_code+0xa02f0> */
L_10073c9c:
    c->r[0] = 0x00000018u; /* mov r0, #24 */
L_10073ca0:
    c->r[14] = 0x10073ca4u; ngage_call(c, 0x1009eef0u); goto L_10073ca4; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_10073ca4:
    c->r[6] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r6, r0, #0 */
L_10073ca8:
    if (ngage_zf(c)) { goto L_10073ce4; } /* beq 0x73ce4 <shadowkey_code+0x73ce4> */
L_10073cac:
    c->r[4] = ngage_r32(c, (c->r[5] + 128u)); /* ldr r4, [r5, #0x80] */
L_10073cb0:
    c->r[0] = c->r[6]; /* mov r0, r6 */
L_10073cb4:
    c->r[14] = 0x10073cb8u; ngage_call(c, 0x1009edb0u); goto L_10073cb8; /* bl 0x9edb0 <shadowkey_code+0x9edb0> */
L_10073cb8:
    ngage_w32(c, (c->r[6] + 4u), (uint32_t)c->r[7]); /* str r7, [r6, #0x4] */
L_10073cbc:
    ngage_w32(c, (c->r[6] + 8u), (uint32_t)c->r[4]); /* str r4, [r6, #0x8] */
L_10073cc0:
    c->r[3] = 0x100fd9b0u; /* literal 0x10073d2c */ /* ldr r3, [pc, #0x64] */
L_10073cc4:
    ngage_w32(c, c->r[6], (uint32_t)c->r[3]); /* str r3, [r6] */
L_10073cc8:
    c->r[4] = c->r[6] + 0x0000000cu; /* add r4, r6, #12 */
L_10073ccc:
~~~

### sub_100a08b0, source line 311829

~~~c

void sub_100a08a8(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_100a08a8; goto L_100a08ac; }
L_100a08a8:
    c->r[0] = 0x00000001u; /* mov r0, #1 */
L_100a08ac:
    return; /* bx lr */
}

void sub_100a08b0(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_100a08b0; goto L_100a08b4; goto L_100a08b8; goto L_100a08bc; goto L_100a08c0; goto L_100a08c4; goto L_100a08c8; goto L_100a08cc; }
L_100a08b0:
    { uint32_t _b = c->r[13]; ngage_w32(c, _b - 4u, c->r[14]); c->r[13] = _b - 4u; } /* stmdb sp!, {lr} */
L_100a08b4:
    c->r[0] = 0x00000038u; /* mov r0, #56 */
L_100a08b8:
    c->r[14] = 0x100a08bcu; ngage_call(c, 0x1009eef0u); goto L_100a08bc; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_100a08bc:
    ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
L_100a08c0:
    if (ngage_zf(c)) { { uint32_t _b = c->r[13]; c->r[12] = ngage_r32(c, _b); c->r[13] = _b + 4u; } } /* ldmeq sp!, {r12} */
L_100a08c4:
    if (ngage_zf(c)) { ngage_call(c, c->r[12]); return; } /* bxeq r12 */
L_100a08c8:
    { uint32_t _b = c->r[13]; c->r[14] = ngage_r32(c, _b); c->r[13] = _b + 4u; } /* ldm sp!, {lr} */
L_100a08cc:
    ngage_call(c, 0x1008e518u); return; /* b 0x8e518 <shadowkey_code+0x8e518> */
}

void sub_100a08d0(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_100a08d0; goto L_100a08d4; goto L_100a08d8; goto L_100a08dc; goto L_100a08e0; goto L_100a08e4; goto L_100a08e8; goto L_100a08ec; goto L_100a08f0; goto L_100a08f4; goto L_100a08f8; goto L_100a08fc; goto L_100a0900; goto L_100a0904; goto L_100a0908; goto L_100a090c; goto L_100a0910; goto L_100a0914; goto L_100a0918; goto L_100a091c; goto L_100a0920; goto L_100a092c; goto L_100a0930; }
L_100a08d0:
    c->r[13] -= 8u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[14]); /* push {r4, lr} */
L_100a08d4:
    c->r[0] = 0x00000044u; /* mov r0, #68 */
L_100a08d8:
    c->r[14] = 0x100a08dcu; ngage_call(c, 0x1009eef0u); goto L_100a08dc; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
~~~

### sub_100a08d0, source line 311850

~~~c
L_100a08c0:
    if (ngage_zf(c)) { { uint32_t _b = c->r[13]; c->r[12] = ngage_r32(c, _b); c->r[13] = _b + 4u; } } /* ldmeq sp!, {r12} */
L_100a08c4:
    if (ngage_zf(c)) { ngage_call(c, c->r[12]); return; } /* bxeq r12 */
L_100a08c8:
    { uint32_t _b = c->r[13]; c->r[14] = ngage_r32(c, _b); c->r[13] = _b + 4u; } /* ldm sp!, {lr} */
L_100a08cc:
    ngage_call(c, 0x1008e518u); return; /* b 0x8e518 <shadowkey_code+0x8e518> */
}

void sub_100a08d0(ngage_cpu_t *c) {
    (void)c;
    if (0) { goto L_100a08d0; goto L_100a08d4; goto L_100a08d8; goto L_100a08dc; goto L_100a08e0; goto L_100a08e4; goto L_100a08e8; goto L_100a08ec; goto L_100a08f0; goto L_100a08f4; goto L_100a08f8; goto L_100a08fc; goto L_100a0900; goto L_100a0904; goto L_100a0908; goto L_100a090c; goto L_100a0910; goto L_100a0914; goto L_100a0918; goto L_100a091c; goto L_100a0920; goto L_100a092c; goto L_100a0930; }
L_100a08d0:
    c->r[13] -= 8u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[14]); /* push {r4, lr} */
L_100a08d4:
    c->r[0] = 0x00000044u; /* mov r0, #68 */
L_100a08d8:
    c->r[14] = 0x100a08dcu; ngage_call(c, 0x1009eef0u); goto L_100a08dc; /* bl 0x9eef0 <shadowkey_code+0x9eef0> */
L_100a08dc:
    c->r[4] = ngage_sub_flags(c, c->r[0], 0x00000000u); /* subs r4, r0, #0 */
L_100a08e0:
    if (ngage_zf(c)) { goto L_100a091c; } /* beq 0xa091c <shadowkey_code+0xa091c> */
L_100a08e4:
    c->r[0] = c->r[4]; /* mov r0, r4 */
L_100a08e8:
    c->r[14] = 0x100a08ecu; ngage_call(c, 0x1008e518u); goto L_100a08ec; /* bl 0x8e518 <shadowkey_code+0x8e518> */
L_100a08ec:
    c->r[3] = 0x00000001u; /* mov r3, #1 */
L_100a08f0:
    ngage_w8(c, (c->r[4] + 66u), (uint8_t)c->r[3]); /* strb r3, [r4, #0x42] */
L_100a08f4:
    c->r[1] = 0x00000000u; /* mov r1, #0 */
L_100a08f8:
    ngage_w32(c, (c->r[4] + 56u), (uint32_t)c->r[1]); /* str r1, [r4, #0x38] */
L_100a08fc:
    ngage_w32(c, (c->r[4] + 60u), (uint32_t)c->r[1]); /* str r1, [r4, #0x3c] */
L_100a0900:
    ngage_w8(c, (c->r[4] + 64u), (uint8_t)c->r[1]); /* strb r1, [r4, #0x40] */
L_100a0904:
~~~

## Interpretation boundary

This is lifted host C generated from the ARM image, not original compiler
source. Register assignments and call order are useful for ABI analysis,
but the snippet does not by itself establish object construction side
effects or a real EKA1/EKA2 runtime.

## Interpretation limits

- The live trace stops at the first unresolved import; no full startup or asset-load success is claimed.
- The original N-Gage SDK ARM UREL map is not the N95 RM-320 / Symbian OS 9.2 ROM export table.
- No physical Nokia N95 launch is claimed.
