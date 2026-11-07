# Step 42 — EUSER1575 and CONE160 runtime forensics

Read-only probes were added at the import boundary. They dump caller-owned output and receiver memory before the unresolved imports; they do not write guest memory or force success.

## Host regression suite

---
  VFS RFile::Size wrote 252 to 1017f530 for /home/runner/work/Shadowkey/Shadowkey/source_bundle/shadowkey_step35_work/game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51/menu_sprites.txt
IMPORT dll=EFSRV[100039e4].DLL ord=15 r0=1017f534 r1=1017f530 r2=1017f54c r3=00000002 sp=00000000 lr=00000000 cpsr=00000000
  EFSRV probe ord=15 args: r0=1017f534[00000000 00000000 00000000 00000000] r1=1017f530[000000fc 00000000 00000000 00000000] r2=1017f54c[30000024 00000100 003a0065 0073005c] r3=00000002
  VFS EFSRV ordinal 15 close /home/runner/work/Shadowkey/Shadowkey/source_bundle/shadowkey_step35_work/game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51/menu_sprites.txt (preserve r0=1017f534; Close is void)
PASS: EFSRV ordinal 185 call-site ABI writes RFile::Size(TInt&) output without changing the file handle
PASS: CONE ordinal 226 has four this-only call sites
PASS: ordinal 55 has two matching this-only call sites
PASS: both paired sites call returned object's vtable slot +0xD8 with ordinal-55 result
PASS: remaining ordinal-226 sites use returned object's graphics-context slots +0x48 / +0xB8
INFERENCE: ordinal 226 = CCoeControl::SystemGc() (high confidence, not export-table proven)
INFERENCE: ordinal 55 = CCoeControl::DrawableWindow() (high confidence, not export-table proven)
PASS: FBSCLI ordinal 17 maps to thunk 0x1009FD40 and has exactly three guest call sites
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
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000000 r2=0000000d r3=fffffff1 sp=10101000 lr=00000000 cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (0,13)
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000017 r2=0000000d r3=fffffff8 sp=10101000 lr=00000000 cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (23,13)
PASS: EUSER 711 TPoint ABI writes only this->x/this->y; r3 and stack are not arguments
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=10100000 r1=100b1068 r2=00000000 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=10100000 r1=100ac718 r2=00000000 r3=00000000)
PASS: EUSER1407 Swiss literal-only subset at all five font callsites; non-font/unknown inputs fail closed
PASS: ARM Operand2 LSL/LSR/ASR/ROR/RRX immediate and register semantics, including shifter carry
PASS: 4961 shifted ARM data-processing instructions now use full Operand2 semantics; generator cases pass
IMPORT dll=EUSER[100039e5].DLL ord=1373 r0=10100000 r1=00000000 r2=000000a0 r3=00000000 sp=00000000 lr=10023314 cpsr=00000000
  EUSER1373 object forensic @10100000
  TRACE EUSER font/spec object @10100000: ef be ad de ce fa ed fe 78 56 34 12 21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  HLE EUSER1373 TPoint set site=10023314 point=10100000 (0,160)
IMPORT dll=EUSER[100039e5].DLL ord=530 r0=10100000 r1=00000000 r2=000000a0 r3=00000000 sp=00000000 lr=1002331c cpsr=00000000
  EUSER530 object forensic @10100000
  TRACE EUSER font/spec object @10100000: 00 00 00 00 a0 00 00 00 78 56 34 12 21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  HLE EUSER530 TPoint::Y site=1002331c point=10100000 -> 160
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000000 r2=0000000d r3=fffffff8 sp=10101000 lr=1002350c cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (0,13)
PASS: EUSER1373 TPoint set, EUSER530 Y getter, EUSER711 TPoint constructor; callsite ABI and 8-byte writes verified
---

## Live trace runner

---
PASS: HAL free-RAM model crosses the original constructor threshold; unmodified engine state reaches DrawText
PASS: no forced engine+0x34 write in live harness; threshold=0x0068afff
LIMITATION: direct RunL invocation still bypasses CActiveScheduler; HAL free RAM is a configurable diagnostic model, not a measured N95 reading
---

## GDI forensic audit

---
PASS: all five GDI108 callsites are accounted for
PASS: each receiver is exactly TFontSpec candidate base + 0x3C; source descriptor starts at receiver + 4
PASS: conflicting legacy GDI151 layout is isolated behind a separate opt-in
PASS: live watch instruments guest WRITE8/WRITE16/WRITE32 paths
PASS: watch armed on receiver subobject
PASS: no guest CPU writes to receiver range before GDI108
PASS: pre-call first 12 bytes captured
PASS: GDI108 experimental default writes 12 zero bytes
PASS: post-call style block is zero
PASS: GDI151 candidate prefix is 60 bytes of a 72-byte spec
PASS: font lookup reads the 72-byte candidate
PASS: first DrawText reached
PASS: second DrawText reached
PASS: unmodified live-state RunL returned
PASS: GDI101 was skipped in this observed call path
LIMIT: the TFontSpec72/TBufC<24>/GDI108 mapping remains a cross-checked experiment, not N95 ROM-confirmed ABI
LIMIT: DrawText is diagnostic only; no glyph rasterization or physical N95 launch
---

## Raw framebuffer capture

---
PNG .build/live_run_bitmap.png: 176x233, RGB565 mode=10, stride=352, nonzero_pixels=3491/41008, bitmap=0x10110718, pixels=0x10311000
---

## Guest pixel writer source at PC 0x100677d0 (stale interpreter PC; active guest function 0x1006a488)

---
Function sub_1006a488: 119487 source lines
1: void sub_1006a488(ngage_cpu_t *c) {
2:     uint32_t imgdec_dest = c->r[1];
3:     (void)c;
4:     if (0) { goto L_1006a488; goto L_1006a48c; goto L_1006a490; goto L_1006a494; goto L_1006a498; goto L_1006a49c; goto L_1006a4a0; goto L_1006a4a4; goto L_1006a4a8; goto L_1006a4ac; goto L_1006a4b0; goto L_1006a4b4; goto L_1006a4b8; goto L_1006a4bc; goto L_1006a4c0; goto L_1006a4c4; goto L_1006a4c8; goto L_1006a4cc; goto L_1006a4d0; goto L_1006a4d4; goto L_1006a4d8; goto L_1006a4dc; goto L_1006a4e0; goto L_1006a4e4; goto L_1006a4e8; goto L_1006a4ec; goto L_1006a4f0; goto L_1006a4f4; goto L_1006a4f8; goto L_1006a4fc; goto L_1006a500; goto L_1006a504; goto L_1006a508; goto L_1006a50c; goto L_1006a510; goto L_1006a514; goto L_1006a518; goto L_1006a51c; goto L_1006a520; goto L_1006a524; goto L_1006a528; goto L_1006a52c; goto L_1006a530; goto L_1006a534; goto L_1006a538; goto L_1006a53c; goto L_1006a540; goto L_1006a544; goto L_1006a548; goto L_1006a54c; goto L_1006a550; goto L_1006a554; goto L_1006a558; goto L_1006a55c; goto L_1006a560; goto L_1006a564; goto L_1006a568; goto L_1006a56c; goto L_1006a570; goto L_1006a574; goto L_1006a578; goto L_1006a57c; goto L_1006a580; goto L_1006a584; goto L_1006a588; goto L_1006a58c; goto L_1006a590; goto L_1006a594; goto L_1006a598; goto L_1006a59c; goto L_1006a5a0; goto L_1006a5a4; goto L_1006a5a8; goto L_1006a5ac; goto L_1006a5b0; goto L_1006a5b4; goto L_1006a5b8; goto L_1006a5bc; goto L_1006a5c0; goto L_1006a5c4; goto L_1006a5c8; goto L_1006a5cc; goto L_1006a5d0; goto L_1006a5d4; goto L_1006a5d8; goto L_1006a5dc; goto L_1006a5e0; goto L_1006a5e4; goto L_1006a5e8; goto L_1006a5ec; goto L_1006a5f0; goto L_1006a5f4; goto L_1006a5f8; goto L_1006a5fc; goto L_1006a600; goto L_1006a604; goto L_1006a608; goto L_1006a60c; goto L_1006a610; goto L_1006a614; goto L_1006a618; goto L_1006a61c; goto L_1006a620; goto L_1006a624; goto L_1006a628; goto L_1006a62c; goto L_1006a630; goto L_1006a634; goto L_1006a638; goto L_1006a63c; goto L_1006a640; goto L_1006a644; goto L_1006a648; goto L_1006a64c; goto L_1006a650; goto L_1006a654; goto L_1006a658; goto L_1006a65c; goto L_1006a660; goto L_1006a664; goto L_1006a668; goto L_1006a66c; goto L_1006a670; goto L_1006a674; goto L_1006a678; goto L_1006a67c; goto L_1006a680; goto L_1006a684; goto L_1006a688; goto L_1006a68c; }
5: L_1006a488:
6:     c->r[13] -= 32u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[9]); ngage_w32(c, c->r[13] + 24u, c->r[10]); ngage_w32(c, c->r[13] + 28u, c->r[14]); /* push {r4, r5, r6, r7, r8, r9, r10, lr} */
7: L_1006a48c:
8:     c->r[13] = c->r[13] - 0x00000024u; /* sub sp, sp, #36 */
9: L_1006a490:
10:     ngage_w32(c, (c->r[13] + 32u), (uint32_t)c->r[1]); /* str r1, [sp, #0x20] */
11: L_1006a494:
12:     ngage_w32(c, (c->r[13] + 28u), (uint32_t)c->r[2]); /* str r2, [sp, #0x1c] */
13: L_1006a498:
14:     c->r[12] = ngage_r32(c, (c->r[13] + 68u)); /* ldr r12, [sp, #0x44] */
15: L_1006a49c:
16:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[3]); /* str r3, [sp, #0x18] */
17: L_1006a4a0:
18:     c->r[14] = c->r[12] + 0x00000204u; /* add lr, r12, #516 */
19: L_1006a4a4:
20:     c->r[12] = c->r[12] + 0x00000004u; /* add r12, r12, #4 */
21: L_1006a4a8:
22:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
23: L_1006a4ac:
24:     c->r[7] = ngage_r32(c, (c->r[13] + 80u)); /* ldr r7, [sp, #0x50] */
25: L_1006a4b0:
26:     c->r[9] = ngage_r32(c, (c->r[13] + 72u)); /* ldr r9, [sp, #0x48] */
27: L_1006a4b4:
28:     c->r[0] = c->r[7] - c->r[9]; /* rsb r0, r9, r7 */
29: L_1006a4b8:
30:     ngage_sub_flags(c, c->r[0], 0x000000b0u); /* cmp r0, #176 */
31: L_1006a4bc:
32:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { c->r[7] = c->r[9] + 0x000000b0u; } /* addgt r7, r9, #176 */
33: L_1006a4c0:
34:     ngage_w32(c, (c->r[13] + 80u), (uint32_t)c->r[7]); /* str r7, [sp, #0x50] */
35: L_1006a4c4:
36:     c->r[7] = ngage_r32(c, (c->r[13] + 76u)); /* ldr r7, [sp, #0x4c] */
37: L_1006a4c8:
38:     c->r[4] = 0x00000000u; /* mov r4, #0 */
39: L_1006a4cc:
40:     ngage_sub_flags(c, c->r[4], c->r[7]); /* cmp r4, r7 */
41: L_1006a4d0:
42:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_1006a514; } /* bge 0x6a514 <shadowkey_code+0x6a514> */
43: L_1006a4d4:
44:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
45: L_1006a4d8:
46:     c->r[0] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r0, [lr, #0x1] */
47: L_1006a4dc:
48:     c->r[9] = ngage_r32(c, (c->r[13] + 76u)); /* ldr r9, [sp, #0x4c] */
49: L_1006a4e0:
50:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); c->r[14] = (c->r[14] + 2u); /* ldrb r2, [lr, #0x2]! */
51: L_1006a4e4:
52:     c->r[1] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r1, [lr, #0x1] */
53: L_1006a4e8:
54:     c->r[4] = c->r[4] + 0x00000001u; /* add r4, r4, #1 */
55: L_1006a4ec:
56:     ngage_sub_flags(c, c->r[4], c->r[9]); /* cmp r4, r9 */
57: L_1006a4f0:
58:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
59: L_1006a4f4:
60:     c->r[3] = (c->r[3] << 16); /* lsl r3, r3, #16 */
61: L_1006a4f8:
62:     c->r[3] = ((uint32_t)((int32_t)c->r[3] >> 16)); /* asr r3, r3, #16 */
63: L_1006a4fc:
64:     c->r[14] = c->r[14] + 0x00000002u; /* add lr, lr, #2 */
65: L_1006a500:
66:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r2, r2, r1, lsl #8 */
67: L_1006a504:
68:     c->r[2] = (c->r[2] << 16); /* lsl r2, r2, #16 */
69: L_1006a508:
70:     c->r[3] = shadowkey_arm_shift_operand(c, c->r[2], 2u, 16u, 1u, 0u) - c->r[3]; /* rsb r3, r3, r2, asr #16 */
71: L_1006a50c:
72:     c->r[14] = c->r[14] + c->r[3]; /* add lr, lr, r3 */
73: L_1006a510:
74:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_1006a4d4; } /* blt 0x6a4d4 <shadowkey_code+0x6a4d4> */
75: L_1006a514:
76:     c->r[10] = ngage_r32(c, (c->r[13] + 76u)); /* ldr r10, [sp, #0x4c] */
77: L_1006a518:
78:     c->r[7] = ngage_r32(c, (c->r[13] + 84u)); /* ldr r7, [sp, #0x54] */
79: L_1006a51c:
80:     c->r[4] = c->r[14]; /* mov r4, lr */
81: L_1006a520:
82:     ngage_sub_flags(c, c->r[10], c->r[7]); /* cmp r10, r7 */
83: L_1006a524:
84:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_1006a684; } /* bge 0x6a684 <shadowkey_code+0x6a684> */
85: L_1006a528:
86:     c->r[9] = 0x0000ff00u; /* mov r9, #65280 */
87: L_1006a52c:
88:     c->r[9] = c->r[9] + 0x000000ffu; /* add r9, r9, #255 */
89: L_1006a530:
90:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[9]); /* str r9, [sp, #0x10] */
91: L_1006a534:
92:     c->r[14] = ngage_r8(c, c->r[4]); /* ldrb lr, [r4] */
93: L_1006a538:
94:     c->r[0] = ngage_r8(c, (c->r[4] + 1u)); /* ldrb r0, [r4, #0x1] */
95: L_1006a53c:
96:     c->r[12] = ngage_r8(c, (c->r[4] + 2u)); /* ldrb r12, [r4, #0x2] */
97: L_1006a540:
98:     c->r[1] = ngage_r8(c, (c->r[4] + 3u)); /* ldrb r1, [r4, #0x3] */
99: L_1006a544:
100:     c->r[4] = c->r[4] + 0x00000004u; /* add r4, r4, #4 */
101: L_1006a548:
102:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[4]); /* str r4, [sp, #0x4] */
103: L_1006a54c:
104:     c->r[7] = ngage_r32(c, (c->r[13] + 76u)); /* ldr r7, [sp, #0x4c] */
105: L_1006a550:
106:     c->r[9] = ngage_r32(c, (c->r[13] + 24u)); /* ldr r9, [sp, #0x18] */
107: L_1006a554:
108:     c->r[5] = ngage_r32(c, (c->r[13] + 72u)); /* ldr r5, [sp, #0x48] */
109: L_1006a558:
110:     c->r[8] = ngage_r32(c, (c->r[13] + 80u)); /* ldr r8, [sp, #0x50] */
111: L_1006a55c:
112:     c->r[3] = c->r[10] - c->r[7]; /* rsb r3, r7, r10 */
113: L_1006a560:
114:     c->r[7] = ngage_r32(c, (c->r[13] + 32u)); /* ldr r7, [sp, #0x20] */
115: L_1006a564:
116:     c->r[3] = c->r[9] + c->r[3]; /* add r3, r9, r3 */
117: L_1006a568:
118:     c->r[9] = ngage_r32(c, (c->r[13] + 16u)); /* ldr r9, [sp, #0x10] */
119: L_1006a56c:
120:     c->r[2] = c->r[3] + shadowkey_arm_shift_operand(c, c->r[3], 0u, 2u, 1u, 0u); /* add r2, r3, r3, lsl #2 */
121: L_1006a570:
122:     c->r[3] = c->r[3] + shadowkey_arm_shift_operand(c, c->r[2], 0u, 1u, 1u, 0u); /* add r3, r3, r2, lsl #1 */
123: L_1006a574:
124:     c->r[2] = c->r[14] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, lr, r0, lsl #8 */
125: L_1006a578:
126:     c->r[1] = c->r[12] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r1, r12, r1, lsl #8 */
127: L_1006a57c:
128:     c->r[6] = c->r[7] + shadowkey_arm_shift_operand(c, c->r[3], 0u, 5u, 1u, 0u); /* add r6, r7, r3, lsl #5 */
129: L_1006a580:
130:     ngage_sub_flags(c, c->r[1], c->r[9]); /* cmp r1, r9 */
131: L_1006a584:
132:     if (!ngage_zf(c)) { ngage_sub_flags(c, c->r[2], c->r[9]); } /* cmpne r2, r9 */
133: L_1006a588:
134:     if (ngage_zf(c)) { goto L_1006a674; } /* beq 0x6a674 <shadowkey_code+0x6a674> */
135: L_1006a58c:
136:     c->r[7] = ngage_r32(c, (c->r[13] + 24u)); /* ldr r7, [sp, #0x18] */
137: L_1006a590:
138:     c->r[1] = c->r[1] - c->r[2]; /* rsb r1, r2, r1 */
139: L_1006a594:
140:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[1]); /* str r1, [sp, #0x8] */
141: L_1006a598:
142:     c->r[7] = c->r[10] + c->r[7]; /* add r7, r10, r7 */
143: L_1006a59c:
144:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[7]); /* str r7, [sp, #0xc] */
145: L_1006a5a0:
146:     c->r[3] = c->r[2] - c->r[5]; /* rsb r3, r5, r2 */
147: L_1006a5a4:
148:     c->r[5] = c->r[5] + c->r[3]; /* add r5, r5, r3 */
149: L_1006a5a8:
150:     c->r[6] = c->r[6] + shadowkey_arm_shift_operand(c, c->r[3], 0u, 1u, 1u, 0u); /* add r6, r6, r3, lsl #1 */
151: L_1006a5ac:
152:     c->r[2] = c->r[8] - c->r[5]; /* rsb r2, r5, r8 */
153: L_1006a5b0:
154:     ngage_sub_flags(c, c->r[2], c->r[1]); /* cmp r2, r1 */
155: L_1006a5b4:
156:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { c->r[8] = c->r[5] + c->r[1]; } /* addgt r8, r5, r1 */
157: L_1006a5b8:
158:     c->r[4] = c->r[5]; /* mov r4, r5 */
159: L_1006a5bc:
160:     ngage_sub_flags(c, c->r[4], c->r[8]); /* cmp r4, r8 */
161: L_1006a5c0:
162:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_1006a65c; } /* bge 0x6a65c <shadowkey_code+0x6a65c> */
163: L_1006a5c4:
164:     c->r[9] = 0x00000f00u; /* mov r9, #3840 */
165: L_1006a5c8:
166:     c->r[9] = c->r[9] + 0x0000000fu; /* add r9, r9, #15 */
167: L_1006a5cc:
168:     ngage_w32(c, c->r[13], (uint32_t)c->r[9]); /* str r9, [sp] */
169: L_1006a5d0:
170:     c->r[12] = 0x00000ee0u; /* mov r12, #3808 */
171: L_1006a5d4:
172:     c->r[12] = c->r[12] + 0x0000000eu; /* add r12, r12, #14 */
173: L_1006a5d8:
174:     c->r[7] = ngage_r32(c, (c->r[13] + 4u)); /* ldr r7, [sp, #0x4] */
175: L_1006a5dc:
176:     c->r[9] = ngage_r32(c, (c->r[13] + 20u)); /* ldr r9, [sp, #0x14] */
177: L_1006a5e0:
178:     c->r[0] = c->r[4] - c->r[5]; /* rsb r0, r5, r4 */
179: L_1006a5e4:
180:     c->r[3] = ngage_r8(c, (c->r[7] + c->r[0])); /* ldrb r3, [r7, r0] */
---

## Runtime evidence

---
  CONE160 FORENSIC hidden-result=102fed24 this=101102c8 sp=102fed18 lr=10021404\n  TRACE CONE160 hidden-result PRE @102fed24: 53 70 61 63 65 20 69 6e
  TRACE CONE160 control object prefix @101102c8: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 80 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102fed24 r1=101102c8 r2=0000039c r3=000003ad)
BITMAP CPU WRITE WATCH armed 10311000..10325060 (82016 bytes)
  EUSER1575 FORENSIC r0(out)=102feae0 r1(obj+310)=101105d8 r2=00000000 r3=101105e8 sp=102feaac lr=10022910\n  TRACE EUSER1575 arg0/out-candidate PRE @102feae0: 00 00 00 00 00 00 00 00 63 3a 5c 73 79 73 74 65
  TRACE EUSER1575 arg1 object fields around +310 @101105c8: 00 10 31 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 object[-0x10] buffer pointer @10311000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 arg3 object @101105e8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 caller stack args @102feaac: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 72 74 00 73 79 73 74 65 6d 5c 61 70 70 73 5c 36 52 35 31 5c 64 72 61 67 6f 6e 73 74 61 72 2e 73
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1575 (r0=102feae0 r1=101105d8 r2=00000000 r3=101105e8)
  CONE160 FORENSIC hidden-result=102feae8 this=101102c8 sp=102feaac lr=10022ad8\n  TRACE CONE160 hidden-result PRE @102feae8: 63 3a 5c 73 79 73 74 65
  TRACE CONE160 control object prefix @101102c8: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 12 11 10 00 00 00 00 01 80 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102feae8 r1=101102c8 r2=00000000 r3=00000000)
  HLE EUSER1407 Format literal-only: TBuf16<6> length=5 text=Swiss lr=10023230
  GDI FORENSIC ordinal=151 args=(102fecf0,102fed30,000000d5,000000a0) stack=102fe6ac
  TRACE GDI151 TFontSpec before @102fecf0: 00 00 00 00 70 fe 0f 10 00 00 00 00 48 ed 2f 10 40 ed 2f 10 1c ed 2f 10 64 ef 2f 10 5c ef 2f 10 e8 4a 02 10 70 fe 0f 10 00 00 00 00 70 fe 0f 10 00 00 00 00 64 fe 0f 10 00 20 69 6e
  TRACE GDI151 descriptor @102fed30: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
  EXPERIMENT GDI151 TFontSpec prefix: name-length=5 height=213 twips prefix=60 total=72; TBufC<24> candidate
  TRACE GDI151 experimental TFontSpec prefix @102fecf0: 05 00 00 40 18 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d5 00 00 00
  EXPERIMENT GDI108 TFontStyle default: dst=102fed2c spec=102fecf0+0x3c fields={0,0,0} size=12
  GFX HLE GetNearestFontInTwips: TFontSpec72 name='Swiss' height=213 twips style=(0,0,0) -> provisional 14 px (96 dpi model)
  GFX HLE: DrawText(gc=10110770 desc=102fe8e8 point=102fecf0 (0,160) baseline=83 align=0 margin=0) [diagnostic only; no glyph rasterization]
  GFX HLE: DrawText(gc=10110770 desc=102fe6e0 point=102fecf0 (0,13) baseline=83 align=0 margin=0) [diagnostic only; no glyph rasterization]
  GFX HLE: DiscardFont(gc=10110770)
  EUSER1575 FORENSIC r0(out)=102feee4 r1(obj+310)=101105d8 r2=10111288 r3=101105e8 sp=102feeb0 lr=10022910\n  TRACE EUSER1575 arg0/out-candidate PRE @102feee4: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 arg1 object fields around +310 @101105c8: 00 10 31 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 object[-0x10] buffer pointer @10311000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 arg2 pointee @10111288: 00 00 00 00 a4 f9 0f 10 c8 02 11 10 00 00 00 00 14 01 10 10 00 f8 00 3c c2 01 8a 02 80 00 c8 00 00 00 00 00 00 00 00 00 30 7b 23 10 40 00 00 00
  TRACE EUSER1575 arg3 object @101105e8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 caller stack args @102feeb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1575 (r0=102feee4 r1=101105d8 r2=10111288 r3=101105e8)
  CONE160 FORENSIC hidden-result=102feeec this=101102c8 sp=102feeb0 lr=10022ad8\n  TRACE CONE160 hidden-result PRE @102feeec: 00 00 00 00 00 00 00 00
  TRACE CONE160 control object prefix @101102c8: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 12 11 10 00 00 00 00 01 80 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102feeec r1=101102c8 r2=10111288 r3=00000000)
BITMAP CPU WRITE WATCH result: guest_store_ops=36608 nonzero_store_ops=3491 nonzero_samples=24
BITMAP CPU WRITE sample[0] width=2 addr=103150be value=00000600 pc=100677d0 function=1006a488 lr=00000600 sp=102feba8
BITMAP CPU WRITE sample[1] width=2 addr=103150c0 value=00000c01 pc=100677d0 function=1006a488 lr=00000c01 sp=102feba8
BITMAP CPU WRITE sample[2] width=2 addr=103150c2 value=00000d11 pc=100677d0 function=1006a488 lr=00000d11 sp=102feba8
BITMAP CPU WRITE sample[3] width=2 addr=103150c4 value=00000901 pc=100677d0 function=1006a488 lr=00000901 sp=102feba8
BITMAP CPU WRITE sample[4] width=2 addr=103150c6 value=00000400 pc=100677d0 function=1006a488 lr=00000400 sp=102feba8
BITMAP CPU WRITE sample[5] width=2 addr=103150e4 value=00000800 pc=100677d0 function=1006a488 lr=00000800 sp=102feba8
BITMAP CPU WRITE sample[6] width=2 addr=103150e6 value=00000a01 pc=100677d0 function=1006a488 lr=00000a01 sp=102feba8
BITMAP CPU WRITE sample[7] width=2 addr=103150e8 value=00000a01 pc=100677d0 function=1006a488 lr=00000a01 sp=102feba8
BITMAP CPU WRITE sample[8] width=2 addr=103150ea value=00000a01 pc=100677d0 function=1006a488 lr=00000a01 sp=102feba8
BITMAP CPU WRITE sample[9] width=2 addr=103150ec value=00000901 pc=100677d0 function=1006a488 lr=00000901 sp=102feba8
BITMAP CPU WRITE sample[10] width=2 addr=10315108 value=00000555 pc=100677d0 function=1006a488 lr=00000555 sp=102feba8
BITMAP CPU WRITE sample[11] width=2 addr=1031510a value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[12] width=2 addr=1031510c value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[13] width=2 addr=1031510e value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[14] width=2 addr=10315110 value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[15] width=2 addr=10315112 value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[16] width=2 addr=10315114 value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[17] width=2 addr=10315116 value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[18] width=2 addr=10315118 value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[19] width=2 addr=1031511a value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[20] width=2 addr=1031511c value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[21] width=2 addr=1031511e value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[22] width=2 addr=10315120 value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
BITMAP CPU WRITE sample[23] width=2 addr=10315122 value=00000aaa pc=100677d0 function=1006a488 lr=00000aaa sp=102feba8
---

## Interpretation limits

- EUSER1575 remains unimplemented; its nonzero-success branch is not fabricated.
- CONE160 remains unimplemented; its hidden-result ABI is observed, but the returned TPoint/TSize semantics are not assumed.
- GDI151/GDI108 remain opt-in experimental probes; DrawText remains diagnostic-only.
- Host trace calls RunL directly and does not instantiate CActiveScheduler or represent a physical N95 launch.
