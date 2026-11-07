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

## Guest pixel writer source at PC 0x100677d0

---
Function sub_100677cc: 125236 source lines
1: void sub_100677cc(ngage_cpu_t *c) {
2:     (void)c;
3:     if (0) { goto L_100677cc; goto L_100677d0; goto L_100677d4; goto L_100677d8; goto L_100677dc; goto L_100677e0; goto L_100677e4; goto L_100677e8; goto L_100677ec; goto L_100677f0; goto L_100677f4; goto L_100677f8; goto L_100677fc; goto L_10067800; goto L_10067804; goto L_10067808; goto L_1006780c; }
4: L_100677cc:
5:     c->r[13] -= 12u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[14]); /* push {r4, r5, lr} */
6: L_100677d0:
7:     c->r[4] = 0x00000000u; /* mov r4, #0 */
8: L_100677d4:
9:     c->r[5] = c->r[0]; /* mov r5, r0 */
10: L_100677d8:
11:     goto L_100677f4; /* b 0x677f4 <shadowkey_code+0x677f4> */
12: L_100677dc:
13:     c->r[3] = (c->r[4] << 1); /* lsl r3, r4, #1 */
14: L_100677e0:
15:     c->r[2] = ngage_r16(c, (c->r[3] + c->r[5])); /* ldrh r2, [r3, r5] */
16: L_100677e4:
17:     ngage_sub_flags(c, c->r[2], 0x0000007bu); /* cmp r2, #123 */
18: L_100677e8:
19:     if (ngage_zf(c)) { c->r[0] = 0x00000000u; } /* moveq r0, #0 */
20: L_100677ec:
21:     if (ngage_zf(c)) { goto L_10067808; } /* beq 0x67808 <shadowkey_code+0x67808> */
22: L_100677f0:
23:     c->r[4] = c->r[4] + 0x00000001u; /* add r4, r4, #1 */
24: L_100677f4:
25:     c->r[0] = c->r[5]; /* mov r0, r5 */
26: L_100677f8:
27:     c->r[14] = 0x100677fcu; ngage_call(c, 0x100a0530u); goto L_100677fc; /* bl 0xa0530 <shadowkey_code+0xa0530> */
28: L_100677fc:
29:     ngage_sub_flags(c, c->r[4], c->r[0]); /* cmp r4, r0 */
30: L_10067800:
31:     if (!ngage_cf(c)) { goto L_100677dc; } /* blo 0x677dc <shadowkey_code+0x677dc> */
32: L_10067804:
33:     c->r[0] = 0x00000001u; /* mov r0, #1 */
34: L_10067808:
35:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[14] = ngage_r32(c, c->r[13] + 8u); c->r[13] += 12u; /* pop {r4, r5, lr} */
36: L_1006780c:
37:     return; /* bx lr */
38: }
39: 
40: void sub_10067810(ngage_cpu_t *c) {
41:     (void)c;
42:     if (0) { goto L_10067810; goto L_10067814; goto L_10067818; goto L_1006781c; goto L_10067820; goto L_10067824; goto L_10067828; goto L_1006782c; goto L_10067830; goto L_10067834; goto L_10067838; goto L_1006783c; goto L_10067840; goto L_10067844; goto L_10067848; goto L_1006784c; goto L_10067850; goto L_10067854; goto L_10067858; goto L_1006785c; goto L_10067860; goto L_10067864; goto L_10067868; goto L_1006786c; goto L_10067870; goto L_10067874; goto L_10067878; goto L_1006787c; goto L_10067880; goto L_10067884; goto L_10067888; goto L_1006788c; goto L_10067890; goto L_10067894; }
43: L_10067810:
44:     c->r[13] -= 24u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[14]); /* push {r4, r5, r6, r7, r8, lr} */
45: L_10067814:
46:     c->r[7] = c->r[0]; /* mov r7, r0 */
47: L_10067818:
48:     c->r[4] = c->r[1]; /* mov r4, r1 */
49: L_1006781c:
50:     c->r[8] = c->r[2]; /* mov r8, r2 */
51: L_10067820:
52:     c->r[14] = 0x10067824u; ngage_call(c, 0x100a0530u); goto L_10067824; /* bl 0xa0530 <shadowkey_code+0xa0530> */
53: L_10067824:
54:     ngage_sub_flags(c, c->r[8], c->r[0]); /* cmp r8, r0 */
55: L_10067828:
56:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_10067834; } /* blt 0x67834 <shadowkey_code+0x67834> */
57: L_1006782c:
58:     c->r[0] = ~(0x00000000u); /* mvn r0, #0 */
59: L_10067830:
60:     goto L_10067890; /* b 0x67890 <shadowkey_code+0x67890> */
61: L_10067834:
62:     c->r[12] = 0x00000000u; /* mov r12, #0 */
63: L_10067838:
64:     ngage_sub_flags(c, c->r[12], c->r[8]); /* cmp r12, r8 */
65: L_1006783c:
66:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_1006788c; } /* bge 0x6788c <shadowkey_code+0x6788c> */
67: L_10067840:
68:     c->r[6] = c->r[4] + 0x00000001u; /* add r6, r4, #1 */
69: L_10067844:
70:     c->r[5] = c->r[4]; /* mov r5, r4 */
71: L_10067848:
72:     c->r[4] = c->r[7] + 0x00000001u; /* add r4, r7, #1 */
73: L_1006784c:
74:     c->r[14] = c->r[7]; /* mov lr, r7 */
75: L_10067850:
76:     c->r[2] = ngage_r8(c, c->r[14]); /* ldrb r2, [lr] */
77: L_10067854:
78:     c->r[0] = ngage_r8(c, c->r[4]); /* ldrb r0, [r4] */
79: L_10067858:
80:     c->r[3] = ngage_r8(c, c->r[5]); /* ldrb r3, [r5] */
81: L_1006785c:
82:     c->r[1] = ngage_r8(c, c->r[6]); /* ldrb r1, [r6] */
83: L_10067860:
84:     c->r[4] = c->r[4] + 0x00000002u; /* add r4, r4, #2 */
85: L_10067864:
86:     c->r[6] = c->r[6] + 0x00000002u; /* add r6, r6, #2 */
87: L_10067868:
88:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
89: L_1006786c:
90:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r3, r3, r1, lsl #8 */
91: L_10067870:
92:     ngage_sub_flags(c, c->r[2], c->r[3]); /* cmp r2, r3 */
93: L_10067874:
94:     if (!ngage_zf(c)) { goto L_1006782c; } /* bne 0x6782c <shadowkey_code+0x6782c> */
95: L_10067878:
96:     c->r[5] = c->r[5] + 0x00000002u; /* add r5, r5, #2 */
97: L_1006787c:
98:     c->r[14] = c->r[14] + 0x00000002u; /* add lr, lr, #2 */
99: L_10067880:
100:     c->r[12] = c->r[12] + 0x00000001u; /* add r12, r12, #1 */
101: L_10067884:
102:     ngage_sub_flags(c, c->r[12], c->r[8]); /* cmp r12, r8 */
103: L_10067888:
104:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_10067850; } /* blt 0x67850 <shadowkey_code+0x67850> */
105: L_1006788c:
106:     c->r[0] = 0x00000001u; /* mov r0, #1 */
107: L_10067890:
108:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[14] = ngage_r32(c, c->r[13] + 20u); c->r[13] += 24u; /* pop {r4, r5, r6, r7, r8, lr} */
109: L_10067894:
110:     return; /* bx lr */
111: }
112: 
113: void sub_10067898(ngage_cpu_t *c) {
114:     (void)c;
115:     if (0) { goto L_10067898; goto L_1006789c; goto L_100678a0; goto L_100678a4; goto L_100678a8; goto L_100678ac; goto L_100678b0; goto L_100678b4; goto L_100678b8; goto L_100678bc; goto L_100678c0; goto L_100678c4; goto L_100678c8; goto L_100678cc; goto L_100678d0; goto L_100678d4; goto L_100678d8; goto L_100678dc; goto L_100678e0; goto L_100678e4; goto L_100678e8; goto L_100678ec; goto L_100678f0; goto L_100678f4; goto L_100678f8; goto L_100678fc; goto L_10067900; goto L_10067904; goto L_10067908; goto L_1006790c; goto L_10067910; goto L_10067914; goto L_10067918; goto L_1006791c; goto L_10067920; goto L_10067924; goto L_10067928; goto L_1006792c; goto L_10067930; goto L_10067934; goto L_10067938; goto L_1006793c; goto L_10067940; goto L_10067944; goto L_10067948; goto L_1006794c; goto L_10067950; goto L_10067954; goto L_10067958; goto L_10067968; goto L_1006796c; }
116: L_10067898:
117:     c->r[13] -= 12u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[14]); /* push {r4, r5, lr} */
118: L_1006789c:
119:     c->r[4] = c->r[0]; /* mov r4, r0 */
120: L_100678a0:
121:     c->r[14] = 0x100678a4u; ngage_call(c, 0x10060d54u); goto L_100678a4; /* bl 0x60d54 <shadowkey_code+0x60d54> */
122: L_100678a4:
123:     c->r[3] = 0x00000144u; /* mov r3, #324 */
124: L_100678a8:
125:     c->r[3] = c->r[3] + 0x00000002u; /* add r3, r3, #2 */
126: L_100678ac:
127:     c->r[0] = ~(0x00000000u); /* mvn r0, #0 */
128: L_100678b0:
129:     ngage_w16(c, (c->r[4] + c->r[3]), (uint16_t)c->r[0]); /* strh r0, [r4, r3] */
130: L_100678b4:
131:     c->r[2] = 0x00000144u; /* mov r2, #324 */
132: L_100678b8:
133:     ngage_w16(c, (c->r[4] + c->r[2]), (uint16_t)c->r[0]); /* strh r0, [r4, r2] */
134: L_100678bc:
135:     c->r[3] = 0x0000013cu; /* mov r3, #316 */
136: L_100678c0:
137:     c->r[3] = c->r[3] + 0x00000002u; /* add r3, r3, #2 */
138: L_100678c4:
139:     ngage_w16(c, (c->r[4] + c->r[3]), (uint16_t)c->r[0]); /* strh r0, [r4, r3] */
140: L_100678c8:
141:     c->r[1] = 0x00000000u; /* mov r1, #0 */
142: L_100678cc:
143:     ngage_w32(c, (c->r[4] + 304u), (uint32_t)c->r[1]); /* str r1, [r4, #0x130] */
144: L_100678d0:
145:     ngage_w32(c, (c->r[4] + 300u), (uint32_t)c->r[0]); /* str r0, [r4, #0x12c] */
146: L_100678d4:
147:     c->r[3] = 0x00000134u; /* mov r3, #308 */
148: L_100678d8:
149:     ngage_w8(c, (c->r[4] + c->r[3]), (uint8_t)c->r[1]); /* strb r1, [r4, r3] */
150: L_100678dc:
151:     c->r[2] = 0x0000013cu; /* mov r2, #316 */
152: L_100678e0:
153:     ngage_w16(c, (c->r[4] + c->r[2]), (uint16_t)c->r[0]); /* strh r0, [r4, r2] */
154: L_100678e4:
155:     ngage_w32(c, (c->r[4] + 312u), (uint32_t)c->r[1]); /* str r1, [r4, #0x138] */
156: L_100678e8:
157:     ngage_w32(c, (c->r[4] + 320u), (uint32_t)c->r[1]); /* str r1, [r4, #0x140] */
158: L_100678ec:
159:     ngage_w32(c, (c->r[4] + 84u), (uint32_t)c->r[1]); /* str r1, [r4, #0x54] */
160: L_100678f0:
161:     c->r[12] = c->r[0]; /* mov r12, r0 */
162: L_100678f4:
163:     c->r[3] = 0x00000148u; /* mov r3, #328 */
164: L_100678f8:
165:     ngage_w8(c, (c->r[4] + c->r[3]), (uint8_t)c->r[12]); /* strb r12, [r4, r3] */
166: L_100678fc:
167:     c->r[14] = 0x100fbd18u; /* literal 0x1006795c */ /* ldr lr, [pc, #0x58] */
168: L_10067900:
169:     ngage_w32(c, (c->r[4] + 8u), (uint32_t)c->r[14]); /* str lr, [r4, #0x8] */
170: L_10067904:
171:     c->r[3] = c->r[3] + 0x00000001u; /* add r3, r3, #1 */
172: L_10067908:
173:     ngage_w8(c, (c->r[4] + c->r[3]), (uint8_t)c->r[12]); /* strb r12, [r4, r3] */
174: L_1006790c:
175:     c->r[2] = 0x100fbbb4u; /* literal 0x10067960 */ /* ldr r2, [pc, #0x4c] */
176: L_10067910:
177:     ngage_w32(c, (c->r[4] + 4u), (uint32_t)c->r[2]); /* str r2, [r4, #0x4] */
178: L_10067914:
179:     ngage_w32(c, (c->r[4] + 332u), (uint32_t)c->r[1]); /* str r1, [r4, #0x14c] */
180: L_10067918:
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
