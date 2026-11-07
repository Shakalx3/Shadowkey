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

## Image decoder caller audit

---
sub_1006a488 direct callsites: 30

## Call 1: caller=sub_10024b3c, lifted_line=71133
71063:     c->r[0] = c->r[13] + 0x00000018u; /* add r0, sp, #24 */
71064: L_10024bf0:
71065:     c->r[6] = (c->r[12] << 2); /* lsl r6, r12, #2 */
71066: L_10024bf4:
71067:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_10024c10; } /* bge 0x24c10 <shadowkey_code+0x24c10> */
71068: L_10024bf8:
71069:     c->r[14] = c->r[4]; /* mov lr, r4 */
71070: L_10024bfc:
71071:     c->r[3] = ngage_r32(c, c->r[14]); c->r[14] += 4u; /* ldr r3, [lr], #4 */
71072: L_10024c00:
71073:     c->r[2] = c->r[2] + 0x00000001u; /* add r2, r2, #1 */
71074: L_10024c04:
71075:     ngage_sub_flags(c, c->r[2], c->r[12]); /* cmp r2, r12 */
71076: L_10024c08:
71077:     c->r[1] = c->r[1] + c->r[3]; /* add r1, r1, r3 */
71078: L_10024c0c:
71079:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_10024bfc; } /* blt 0x24bfc <shadowkey_code+0x24bfc> */
71080: L_10024c10:
71081:     c->r[2] = ngage_r32(c, (c->r[4] + (c->r[12] << 2))); /* ldr r2, [r4, r12, lsl #2] */
71082:     fprintf(stderr,"TRACE resource index=%08x table=%08x offset=%08x\n",c->r[12],c->r[4],c->r[2]);
71083: L_10024c14:
71084:     c->r[14] = 0x10024c18u; ngage_call(c, 0x100275e4u); goto L_10024c18; /* bl 0x275e4 <shadowkey_code+0x275e4> */
71085: L_10024c18:
71086:     fprintf(stderr,"TRACE loaded resource r0=%08x engine=%08x\n",c->r[0],c->r[5]);
71087:     c->r[12] = ngage_r32(c, (c->r[5] + 48u)); /* ldr r12, [r5, #0x30] */
71088: L_10024c1c:
71089:     c->r[3] = 0x00004400u; /* mov r3, #17408 */
71090: L_10024c20:
71091:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
71092: L_10024c24:
71093:     c->r[12] = c->r[12] + c->r[3]; /* add r12, r12, r3 */
71094: L_10024c28:
71095:     ngage_w32(c, (c->r[12] + c->r[6]), (uint32_t)c->r[0]); /* str r0, [r12, r6] */
71096: L_10024c2c:
71097:     c->r[0] = ngage_r32(c, (c->r[5] + 48u)); /* ldr r0, [r5, #0x30] */
71098: L_10024c30:
71099:     c->r[3] = c->r[0] + c->r[3]; /* add r3, r0, r3 */
71100: L_10024c34:
71101:     c->r[4] = ngage_r32(c, (c->r[3] + c->r[6])); /* ldr r4, [r3, r6] */
71102: L_10024c38:
71103:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
71104: L_10024c3c:
71105:     ngage_w32(c, c->r[13], (uint32_t)c->r[4]); /* str r4, [sp] */
71106: L_10024c40:
71107:     c->r[2] = 0x00000000u; /* mov r2, #0 */
71108: L_10024c44:
71109:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
71110: L_10024c48:
71111:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
71112: L_10024c4c:
71113:     c->r[3] = ngage_r8(c, c->r[4]); /* ldrb r3, [r4] */
71114: L_10024c50:
71115:     c->r[14] = ngage_r8(c, (c->r[4] + 1u)); /* ldrb lr, [r4, #0x1] */
71116: L_10024c54:
71117:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[14], 0u, 8u, 1u, 0u); /* orr r3, r3, lr, lsl #8 */
71118: L_10024c58:
71119:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
71120: L_10024c5c:
71121:     c->r[12] = ngage_r8(c, (c->r[4] + 2u)); /* ldrb r12, [r4, #0x2] */
71122: L_10024c60:
71123:     c->r[14] = ngage_r8(c, (c->r[4] + 3u)); /* ldrb lr, [r4, #0x3] */
71124: L_10024c64:
71125:     c->r[12] = c->r[12] | shadowkey_arm_shift_operand(c, c->r[14], 0u, 8u, 1u, 0u); /* orr r12, r12, lr, lsl #8 */
71126: L_10024c68:
71127:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[12]); /* str r12, [sp, #0x10] */
71128: L_10024c6c:
71129:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
71130: L_10024c70:
71131:     c->r[3] = c->r[2]; /* mov r3, r2 */
71132: L_10024c74:
71133:     c->r[14] = 0x10024c78u; ngage_call(c, 0x1006a488u); goto L_10024c78; /* bl 0x6a488 <shadowkey_code+0x6a488> */
71134: L_10024c78:
71135:     c->r[0] = c->r[5]; /* mov r0, r5 */
71136: L_10024c7c:
71137:     c->r[14] = 0x10024c80u; ngage_call(c, 0x10027af0u); goto L_10024c80; /* bl 0x27af0 <shadowkey_code+0x27af0> */
71138: L_10024c80:
71139:     c->r[13] = c->r[13] + 0x00000118u; /* add sp, sp, #280 */
71140: L_10024c84:
71141:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[14] = ngage_r32(c, c->r[13] + 12u); c->r[13] += 16u; /* pop {r4, r5, r6, lr} */
71142: L_10024c88:
71143:     return; /* bx lr */
71144: }
71145: 
71146: void sub_10024c8c(ngage_cpu_t *c) {
71147:     (void)c;
71148:     if (0) { goto L_10024c8c; goto L_10024c90; goto L_10024c94; goto L_10024c98; goto L_10024c9c; goto L_10024ca0; goto L_10024ca4; goto L_10024ca8; goto L_10024cac; goto L_10024cb0; goto L_10024cb4; goto L_10024cb8; goto L_10024cbc; goto L_10024cc0; goto L_10024cc4; goto L_10024cc8; goto L_10024ccc; goto L_10024cd0; goto L_10024cd4; goto L_10024cd8; goto L_10024cdc; goto L_10024ce0; goto L_10024ce4; goto L_10024ce8; goto L_10024cec; goto L_10024cf0; goto L_10024cf4; goto L_10024cf8; goto L_10024cfc; goto L_10024d00; goto L_10024d04; goto L_10024d08; goto L_10024d0c; goto L_10024d10; goto L_10024d14; goto L_10024d18; goto L_10024d1c; goto L_10024d20; goto L_10024d24; goto L_10024d28; goto L_10024d2c; goto L_10024d30; goto L_10024d34; goto L_10024d38; goto L_10024d3c; goto L_10024d40; goto L_10024d44; goto L_10024d48; goto L_10024d4c; goto L_10024d50; goto L_10024d54; goto L_10024d58; goto L_10024d5c; goto L_10024d60; goto L_10024d64; goto L_10024d68; goto L_10024d6c; goto L_10024d70; goto L_10024d74; goto L_10024d78; goto L_10024d7c; goto L_10024d80; goto L_10024d84; goto L_10024d88; goto L_10024d8c; goto L_10024d90; goto L_10024d94; goto L_10024d98; goto L_10024d9c; goto L_10024da0; goto L_10024da4; goto L_10024da8; goto L_10024dac; goto L_10024db0; goto L_10024db4; goto L_10024db8; goto L_10024dbc; goto L_10024dc0; goto L_10024dc4; goto L_10024dc8; goto L_10024dcc; goto L_10024de0; goto L_10024de4; goto L_10024de8; }
71149: L_10024c8c:
71150:     c->r[13] -= 32u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[9]); ngage_w32(c, c->r[13] + 24u, c->r[10]); ngage_w32(c, c->r[13] + 28u, c->r[14]); /* push {r4, r5, r6, r7, r8, r9, r10, lr} */
71151: L_10024c90:
71152:     c->r[2] = 0x00000180u; /* mov r2, #384 */
71153: L_10024c94:
71154:     c->r[13] = c->r[13] - 0x00000384u; /* sub sp, sp, #900 */
71155: L_10024c98:
71156:     c->r[7] = c->r[0]; /* mov r7, r0 */
71157: L_10024c9c:
71158:     c->r[0] = c->r[13] + 0x00000004u; /* add r0, sp, #4 */
71159: L_10024ca0:
71160:     c->r[6] = c->r[1]; /* mov r6, r1 */
71161: L_10024ca4:
71162:     c->r[1] = 0x00000000u; /* mov r1, #0 */
71163: L_10024ca8:
71164:     c->r[14] = 0x10024cacu; ngage_call(c, 0x1009f0d0u); goto L_10024cac; /* bl 0x9f0d0 <shadowkey_code+0x9f0d0> */
71165: L_10024cac:
71166:     c->r[1] = 0x100acbe8u; /* literal 0x10024dd0 */ /* ldr r1, [pc, #0x11c] */
71167: L_10024cb0:

## Call 2: caller=sub_10029cb0, lifted_line=81118
81048:     c->r[9] = ngage_r32(c, (c->r[6] + 120u)); /* ldr r9, [r6, #0x78] */
81049: L_10029cc0:
81050:     ngage_w32(c, (c->r[13] + 48u), (uint32_t)c->r[9]); /* str r9, [sp, #0x30] */
81051: L_10029cc4:
81052:     c->r[14] = ngage_r32(c, (c->r[6] + 20u)); /* ldr lr, [r6, #0x14] */
81053: L_10029cc8:
81054:     c->r[7] = 0x00014c00u; /* mov r7, #84992 */
81055: L_10029ccc:
81056:     c->r[7] = c->r[7] + 0x000000c3u; /* add r7, r7, #195 */
81057: L_10029cd0:
81058:     c->r[3] = ngage_r8(c, (c->r[14] + c->r[7])); /* ldrsb r3, [lr, r7] */
81059: L_10029cd4:
81060:     c->r[8] = 0x00000000u; /* mov r8, #0 */
81061: L_10029cd8:
81062:     ngage_add_flags(c, c->r[3], 0x00000001u, 0); /* cmn r3, #1 */
81063: L_10029cdc:
81064:     if (ngage_zf(c)) { goto L_10029fb4; } /* beq 0x29fb4 <shadowkey_code+0x29fb4> */
81065: L_10029ce0:
81066:     c->r[3] = ngage_r32(c, (c->r[14] + 1484u)); /* ldr r3, [lr, #0x5cc] */
81067: L_10029ce4:
81068:     c->r[1] = ngage_r8(c, (c->r[14] + c->r[7])); /* ldrsb r1, [lr, r7] */
81069: L_10029ce8:
81070:     c->r[2] = ngage_r32(c, (c->r[3] + 52u)); /* ldr r2, [r3, #0x34] */
81071: L_10029cec:
81072:     ngage_sub_flags(c, c->r[1], c->r[2]); /* cmp r1, r2 */
81073: L_10029cf0:
81074:     if (ngage_zf(c)) { goto L_10029fb4; } /* beq 0x29fb4 <shadowkey_code+0x29fb4> */
81075: L_10029cf4:
81076:     c->r[3] = c->r[14] + 0x00004400u; /* add r3, lr, #17408 */
81077: L_10029cf8:
81078:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
81079: L_10029cfc:
81080:     c->r[12] = ngage_r32(c, (c->r[3] + 696u)); /* ldr r12, [r3, #0x2b8] */
81081: L_10029d00:
81082:     ngage_sub_flags(c, c->r[12], c->r[8]); /* cmp r12, r8 */
81083: L_10029d04:
81084:     if (ngage_zf(c)) { goto L_10029d4c; } /* beq 0x29d4c <shadowkey_code+0x29d4c> */
81085: L_10029d08:
81086:     c->r[1] = ngage_r32(c, (c->r[14] + 1152u)); /* ldr r1, [lr, #0x480] */
81087: L_10029d0c:
81088:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
81089: L_10029d10:
81090:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[8]); /* str r8, [sp, #0x4] */
81091: L_10029d14:
81092:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[8]); /* str r8, [sp, #0x8] */
81093: L_10029d18:
81094:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
81095: L_10029d1c:
81096:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
81097: L_10029d20:
81098:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
81099: L_10029d24:
81100:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
81101: L_10029d28:
81102:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
81103: L_10029d2c:
81104:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
81105: L_10029d30:
81106:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
81107: L_10029d34:
81108:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
81109: L_10029d38:
81110:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[8]); /* str r8, [sp, #0x14] */
81111: L_10029d3c:
81112:     c->r[3] = c->r[8]; /* mov r3, r8 */
81113: L_10029d40:
81114:     c->r[0] = c->r[14]; /* mov r0, lr */
81115: L_10029d44:
81116:     c->r[2] = c->r[8]; /* mov r2, r8 */
81117: L_10029d48:
81118:     c->r[14] = 0x10029d4cu; ngage_call(c, 0x1006a488u); goto L_10029d4c; /* bl 0x6a488 <shadowkey_code+0x6a488> */
81119: L_10029d4c:
81120:     c->r[5] = c->r[13] + 0x00000234u; /* add r5, sp, #564 */
81121: L_10029d50:
81122:     c->r[0] = c->r[5]; /* mov r0, r5 */
81123: L_10029d54:
81124:     c->r[14] = 0x10029d58u; ngage_call(c, 0x1009edb0u); goto L_10029d58; /* bl 0x9edb0 <shadowkey_code+0x9edb0> */
81125: L_10029d58:
81126:     c->r[4] = 0x100ffe70u; /* literal 0x10029fa8 */ /* ldr r4, [pc, #0x248] */
81127: L_10029d5c:
81128:     ngage_w32(c, (c->r[13] + 564u), (uint32_t)c->r[4]); /* str r4, [sp, #0x234] */
81129: L_10029d60:
81130:     ngage_w32(c, (c->r[5] + 4u), (uint32_t)c->r[8]); /* str r8, [r5, #0x4] */
81131: L_10029d64:
81132:     c->r[3] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r3, [r6, #0x14] */
81133: L_10029d68:
81134:     c->r[0] = ngage_r32(c, (c->r[3] + 1484u)); /* ldr r0, [r3, #0x5cc] */
81135: L_10029d6c:
81136:     c->r[7] = ngage_r8(c, (c->r[3] + c->r[7])); /* ldrsb r7, [r3, r7] */
81137: L_10029d70:
81138:     c->r[14] = 0x10029d74u; ngage_call(c, 0x1000db04u); goto L_10029d74; /* bl 0xdb04 <shadowkey_code+0xdb04> */
81139: L_10029d74:
81140:     ngage_w32(c, (c->r[13] + 44u), (uint32_t)c->r[4]); /* str r4, [sp, #0x2c] */
81141: L_10029d78:
81142:     ngage_set_nz(c, c->r[0] & 0x000000ffu); /* tst r0, #255 */
81143: L_10029d7c:
81144:     if (!ngage_zf(c)) { goto L_10029da0; } /* bne 0x29da0 <shadowkey_code+0x29da0> */
81145: L_10029d80:
81146:     c->r[3] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r3, [r6, #0x14] */
81147: L_10029d84:
81148:     c->r[0] = ngage_r32(c, (c->r[3] + 1560u)); /* ldr r0, [r3, #0x618] */
81149: L_10029d88:
81150:     c->r[2] = ngage_r32(c, (c->r[0] + 4u)); /* ldr r2, [r0, #0x4] */
81151: L_10029d8c:
81152:     c->r[12] = ngage_r32(c, (c->r[2] + 368u)); /* ldr r12, [r2, #0x170] */

## Call 3: caller=sub_10029cb0, lifted_line=81536
81466:     if (ngage_zf(c)) { goto L_1002a030; } /* beq 0x2a030 <shadowkey_code+0x2a030> */
81467: L_1002a010:
81468:     c->r[3] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r3, [r6, #0x14] */
81469: L_1002a014:
81470:     c->r[0] = ngage_r32(c, (c->r[3] + 1484u)); /* ldr r0, [r3, #0x5cc] */
81471: L_1002a018:
81472:     c->r[14] = 0x1002a01cu; ngage_call(c, 0x1000db04u); goto L_1002a01c; /* bl 0xdb04 <shadowkey_code+0xdb04> */
81473: L_1002a01c:
81474:     ngage_set_nz(c, c->r[0] & 0x000000ffu); /* tst r0, #255 */
81475: L_1002a020:
81476:     if (!ngage_zf(c)) { goto L_1002a14c; } /* bne 0x2a14c <shadowkey_code+0x2a14c> */
81477: L_1002a024:
81478:     c->r[3] = ngage_r8(c, (c->r[5] + 43u)); /* ldrb r3, [r5, #0x2b] */
81479: L_1002a028:
81480:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
81481: L_1002a02c:
81482:     if (!ngage_zf(c)) { goto L_1002a14c; } /* bne 0x2a14c <shadowkey_code+0x2a14c> */
81483: L_1002a030:
81484:     c->r[14] = ngage_r32(c, (c->r[6] + 20u)); /* ldr lr, [r6, #0x14] */
81485: L_1002a034:
81486:     c->r[3] = ngage_r32(c, (c->r[14] + 8u)); /* ldr r3, [lr, #0x8] */
81487: L_1002a038:
81488:     c->r[4] = ngage_r8(c, (c->r[3] + 60u)); /* ldrb r4, [r3, #0x3c] */
81489: L_1002a03c:
81490:     ngage_sub_flags(c, c->r[4], 0x00000000u); /* cmp r4, #0 */
81491: L_1002a040:
81492:     if (!ngage_zf(c)) { goto L_1002a14c; } /* bne 0x2a14c <shadowkey_code+0x2a14c> */
81493: L_1002a044:
81494:     c->r[3] = c->r[14] + 0x00004400u; /* add r3, lr, #17408 */
81495: L_1002a048:
81496:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
81497: L_1002a04c:
81498:     c->r[12] = ngage_r32(c, (c->r[3] + 696u)); /* ldr r12, [r3, #0x2b8] */
81499: L_1002a050:
81500:     ngage_sub_flags(c, c->r[12], 0x00000000u); /* cmp r12, #0 */
81501: L_1002a054:
81502:     if (ngage_zf(c)) { goto L_1002a09c; } /* beq 0x2a09c <shadowkey_code+0x2a09c> */
81503: L_1002a058:
81504:     c->r[1] = ngage_r32(c, (c->r[14] + 1152u)); /* ldr r1, [lr, #0x480] */
81505: L_1002a05c:
81506:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
81507: L_1002a060:
81508:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[4]); /* str r4, [sp, #0x4] */
81509: L_1002a064:
81510:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[4]); /* str r4, [sp, #0x8] */
81511: L_1002a068:
81512:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
81513: L_1002a06c:
81514:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
81515: L_1002a070:
81516:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
81517: L_1002a074:
81518:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
81519: L_1002a078:
81520:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
81521: L_1002a07c:
81522:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
81523: L_1002a080:
81524:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
81525: L_1002a084:
81526:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
81527: L_1002a088:
81528:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[4]); /* str r4, [sp, #0x14] */
81529: L_1002a08c:
81530:     c->r[3] = c->r[4]; /* mov r3, r4 */
81531: L_1002a090:
81532:     c->r[0] = c->r[14]; /* mov r0, lr */
81533: L_1002a094:
81534:     c->r[2] = c->r[4]; /* mov r2, r4 */
81535: L_1002a098:
81536:     c->r[14] = 0x1002a09cu; ngage_call(c, 0x1006a488u); goto L_1002a09c; /* bl 0x6a488 <shadowkey_code+0x6a488> */
81537: L_1002a09c:
81538:     c->r[14] = ngage_r8(c, (c->r[5] + 40u)); /* ldrb lr, [r5, #0x28] */
81539: L_1002a0a0:
81540:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
81541: L_1002a0a4:
81542:     if (ngage_zf(c)) { goto L_1002a0dc; } /* beq 0x2a0dc <shadowkey_code+0x2a0dc> */
81543: L_1002a0a8:
81544:     c->r[1] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r1, [r6, #0x14] */
81545: L_1002a0ac:
81546:     c->r[0] = ngage_r32(c, (c->r[1] + 1468u)); /* ldr r0, [r1, #0x5bc] */
81547: L_1002a0b0:
81548:     c->r[3] = 0x00014800u; /* mov r3, #83968 */
81549: L_1002a0b4:
81550:     c->r[3] = c->r[3] + 0x0000023cu; /* add r3, r3, #572 */
81551: L_1002a0b8:
81552:     c->r[12] = ngage_r32(c, (c->r[1] + c->r[3])); /* ldr r12, [r1, r3] */
81553: L_1002a0bc:
81554:     c->r[2] = 0x00003b80u; /* mov r2, #15232 */
81555: L_1002a0c0:
81556:     c->r[2] = c->r[2] + 0x00000020u; /* add r2, r2, #32 */
81557: L_1002a0c4:
81558:     c->r[1] = ngage_r32(c, (c->r[12] + c->r[2])); /* ldr r1, [r12, r2] */
81559: L_1002a0c8:
81560:     ngage_w32(c, c->r[13], (uint32_t)c->r[4]); /* str r4, [sp] */
81561: L_1002a0cc:
81562:     c->r[3] = 0x00000001u; /* mov r3, #1 */
81563: L_1002a0d0:
81564:     { uint32_t _b = c->r[13]; ngage_w32(c, _b + 4u, c->r[3]); ngage_w32(c, _b + 8u, c->r[4]); } /* stmib sp, {r3, r4} */
81565: L_1002a0d4:
81566:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[4]); /* str r4, [sp, #0xc] */
81567: L_1002a0d8:
81568:     goto L_1002a10c; /* b 0x2a10c <shadowkey_code+0x2a10c> */
81569: L_1002a0dc:
81570:     c->r[1] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r1, [r6, #0x14] */

## Call 4: caller=sub_10029cb0, lifted_line=81926
81856:     if (!ngage_zf(c)) { goto L_1002a334; } /* bne 0x2a334 <shadowkey_code+0x2a334> */
81857: L_1002a324:
81858:     c->r[3] = ngage_r32(c, (c->r[2] + 1448u)); /* ldr r3, [r2, #0x5a8] */
81859: L_1002a328:
81860:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
81861: L_1002a32c:
81862:     if (ngage_zf(c)) { c->r[9] = ngage_r32(c, (c->r[13] + 48u)); } /* ldreq r9, [sp, #0x30] */
81863: L_1002a330:
81864:     if (ngage_zf(c)) { ngage_w32(c, (c->r[6] + 120u), (uint32_t)c->r[9]); } /* streq r9, [r6, #0x78] */
81865: L_1002a334:
81866:     c->r[3] = ngage_r32(c, (c->r[6] + 120u)); /* ldr r3, [r6, #0x78] */
81867: L_1002a338:
81868:     ngage_sub_flags(c, c->r[3], 0x0000000au); /* cmp r3, #10 */
81869: L_1002a33c:
81870:     if (!ngage_zf(c)) { ngage_sub_flags(c, c->r[3], 0x00000003u); } /* cmpne r3, #3 */
81871: L_1002a340:
81872:     if (ngage_zf(c)) { goto L_1002a354; } /* beq 0x2a354 <shadowkey_code+0x2a354> */
81873: L_1002a344:
81874:     ngage_sub_flags(c, c->r[3], 0x0000001fu); /* cmp r3, #31 */
81875: L_1002a348:
81876:     if (ngage_zf(c)) { goto L_1002a354; } /* beq 0x2a354 <shadowkey_code+0x2a354> */
81877: L_1002a34c:
81878:     ngage_sub_flags(c, c->r[3], 0x00000004u); /* cmp r3, #4 */
81879: L_1002a350:
81880:     if (!ngage_zf(c)) { goto L_1002a514; } /* bne 0x2a514 <shadowkey_code+0x2a514> */
81881: L_1002a354:
81882:     c->r[4] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r4, [r6, #0x14] */
81883: L_1002a358:
81884:     c->r[3] = c->r[4] + 0x00004400u; /* add r3, r4, #17408 */
81885: L_1002a35c:
81886:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
81887: L_1002a360:
81888:     c->r[14] = ngage_r32(c, (c->r[3] + 696u)); /* ldr lr, [r3, #0x2b8] */
81889: L_1002a364:
81890:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
81891: L_1002a368:
81892:     if (ngage_zf(c)) { goto L_1002a3b0; } /* beq 0x2a3b0 <shadowkey_code+0x2a3b0> */
81893: L_1002a36c:
81894:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
81895: L_1002a370:
81896:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
81897: L_1002a374:
81898:     c->r[2] = 0x00000000u; /* mov r2, #0 */
81899: L_1002a378:
81900:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
81901: L_1002a37c:
81902:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
81903: L_1002a380:
81904:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
81905: L_1002a384:
81906:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
81907: L_1002a388:
81908:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
81909: L_1002a38c:
81910:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
81911: L_1002a390:
81912:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
81913: L_1002a394:
81914:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
81915: L_1002a398:
81916:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
81917: L_1002a39c:
81918:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
81919: L_1002a3a0:
81920:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
81921: L_1002a3a4:
81922:     c->r[3] = c->r[2]; /* mov r3, r2 */
81923: L_1002a3a8:
81924:     c->r[0] = c->r[4]; /* mov r0, r4 */
81925: L_1002a3ac:
81926:     c->r[14] = 0x1002a3b0u; ngage_call(c, 0x1006a488u); goto L_1002a3b0; /* bl 0x6a488 <shadowkey_code+0x6a488> */
81927: L_1002a3b0:
81928:     c->r[3] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r3, [r6, #0x14] */
81929: L_1002a3b4:
81930:     c->r[2] = ngage_r32(c, (c->r[3] + 8u)); /* ldr r2, [r3, #0x8] */
81931: L_1002a3b8:
81932:     c->r[0] = ngage_r32(c, (c->r[3] + 40u)); /* ldr r0, [r3, #0x28] */
81933: L_1002a3bc:
81934:     c->r[1] = ngage_r32(c, (c->r[2] + 1032u)); /* ldr r1, [r2, #0x408] */
81935: L_1002a3c0:
81936:     c->r[4] = ngage_r32(c, (c->r[0] + 4u)); /* ldr r4, [r0, #0x4] */
81937: L_1002a3c4:
81938:     c->r[7] = 0x00000000u; /* mov r7, #0 */
81939: L_1002a3c8:
81940:     ngage_w32(c, c->r[13], (uint32_t)c->r[7]); /* str r7, [sp] */
81941: L_1002a3cc:
81942:     { uint32_t _b = c->r[13]; ngage_w32(c, _b + 4u, c->r[1]); ngage_w32(c, _b + 8u, c->r[7]); } /* stmib sp, {r1, r7} */
81943: L_1002a3d0:
81944:     c->r[3] = c->r[7]; /* mov r3, r7 */
81945: L_1002a3d4:
81946:     c->r[2] = c->r[7]; /* mov r2, r7 */
81947: L_1002a3d8:
81948:     c->r[1] = c->r[7]; /* mov r1, r7 */
81949: L_1002a3dc:
81950:     c->r[12] = ngage_r32(c, (c->r[4] + 68u)); /* ldr r12, [r4, #0x44] */
81951: L_1002a3e0:
81952:     c->r[14] = 0x1002a3e8u; /* mov lr, pc (ARM PC semantics) */
81953: L_1002a3e4:
81954:     ngage_call(c, c->r[12]); goto L_1002a3e8; /* bx r12 */
81955: L_1002a3e8:
81956:     c->r[12] = ngage_r32(c, (c->r[6] + 120u)); /* ldr r12, [r6, #0x78] */
81957: L_1002a3ec:
81958:     ngage_sub_flags(c, c->r[12], 0x0000000au); /* cmp r12, #10 */
81959: L_1002a3f0:
81960:     if (!ngage_zf(c)) { ngage_sub_flags(c, c->r[12], 0x00000003u); } /* cmpne r12, #3 */

## Call 5: caller=sub_10029cb0, lifted_line=82156
82086:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
82087: L_1002a4f0:
82088:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[2]); /* str r2, [sp, #0x18] */
82089: L_1002a4f4:
82090:     ngage_w32(c, (c->r[13] + 28u), (uint32_t)c->r[2]); /* str r2, [sp, #0x1c] */
82091: L_1002a4f8:
82092:     c->r[3] = 0x00000019u; /* mov r3, #25 */
82093: L_1002a4fc:
82094:     ngage_w32(c, (c->r[13] + 36u), (uint32_t)c->r[3]); /* str r3, [sp, #0x24] */
82095: L_1002a500:
82096:     ngage_w32(c, (c->r[13] + 32u), (uint32_t)c->r[2]); /* str r2, [sp, #0x20] */
82097: L_1002a504:
82098:     c->r[1] = c->r[1] + 0x00000002u; /* add r1, r1, #2 */
82099: L_1002a508:
82100:     c->r[1] = c->r[12] + c->r[1]; /* add r1, r12, r1 */
82101: L_1002a50c:
82102:     c->r[3] = 0x0000006eu; /* mov r3, #110 */
82103: L_1002a510:
82104:     c->r[14] = 0x1002a514u; ngage_call(c, 0x100231b4u); goto L_1002a514; /* bl 0x231b4 <shadowkey_code+0x231b4> */
82105: L_1002a514:
82106:     c->r[3] = ngage_r32(c, (c->r[6] + 120u)); /* ldr r3, [r6, #0x78] */
82107: L_1002a518:
82108:     ngage_sub_flags(c, c->r[3], 0x00000004u); /* cmp r3, #4 */
82109: L_1002a51c:
82110:     if (!ngage_zf(c)) { goto L_1002a57c; } /* bne 0x2a57c <shadowkey_code+0x2a57c> */
82111: L_1002a520:
82112:     c->r[4] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r4, [r6, #0x14] */
82113: L_1002a524:
82114:     c->r[3] = c->r[4] + 0x00004400u; /* add r3, r4, #17408 */
82115: L_1002a528:
82116:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
82117: L_1002a52c:
82118:     c->r[14] = ngage_r32(c, (c->r[3] + 696u)); /* ldr lr, [r3, #0x2b8] */
82119: L_1002a530:
82120:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
82121: L_1002a534:
82122:     if (ngage_zf(c)) { goto L_1002a57c; } /* beq 0x2a57c <shadowkey_code+0x2a57c> */
82123: L_1002a538:
82124:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
82125: L_1002a53c:
82126:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
82127: L_1002a540:
82128:     c->r[2] = 0x00000000u; /* mov r2, #0 */
82129: L_1002a544:
82130:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
82131: L_1002a548:
82132:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
82133: L_1002a54c:
82134:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
82135: L_1002a550:
82136:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
82137: L_1002a554:
82138:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
82139: L_1002a558:
82140:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
82141: L_1002a55c:
82142:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
82143: L_1002a560:
82144:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
82145: L_1002a564:
82146:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
82147: L_1002a568:
82148:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
82149: L_1002a56c:
82150:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
82151: L_1002a570:
82152:     c->r[3] = c->r[2]; /* mov r3, r2 */
82153: L_1002a574:
82154:     c->r[0] = c->r[4]; /* mov r0, r4 */
82155: L_1002a578:
82156:     c->r[14] = 0x1002a57cu; ngage_call(c, 0x1006a488u); goto L_1002a57c; /* bl 0x6a488 <shadowkey_code+0x6a488> */
82157: L_1002a57c:
82158:     c->r[0] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r0, [r6, #0x14] */
82159: L_1002a580:
82160:     c->r[3] = ngage_r32(c, (c->r[0] + 40u)); /* ldr r3, [r0, #0x28] */
82161: L_1002a584:
82162:     c->r[2] = ngage_r32(c, (c->r[3] + 32u)); /* ldr r2, [r3, #0x20] */
82163: L_1002a588:
82164:     c->r[1] = ngage_r8(c, (c->r[2] + 72u)); /* ldrb r1, [r2, #0x48] */
82165: L_1002a58c:
82166:     ngage_sub_flags(c, c->r[1], 0x00000000u); /* cmp r1, #0 */
82167: L_1002a590:
82168:     if (!ngage_zf(c)) { goto L_1002a6c8; } /* bne 0x2a6c8 <shadowkey_code+0x2a6c8> */
82169: L_1002a594:
82170:     c->r[3] = ngage_r32(c, (c->r[6] + 316u)); /* ldr r3, [r6, #0x13c] */
82171: L_1002a598:
82172:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
82173: L_1002a59c:
82174:     if (!ngage_zf(c)) { goto L_1002a688; } /* bne 0x2a688 <shadowkey_code+0x2a688> */
82175: L_1002a5a0:
82176:     ngage_w32(c, (c->r[6] + 320u), (uint32_t)c->r[3]); /* str r3, [r6, #0x140] */
82177: L_1002a5a4:
82178:     ngage_w32(c, (c->r[6] + 324u), (uint32_t)c->r[3]); /* str r3, [r6, #0x144] */
82179: L_1002a5a8:
82180:     c->r[1] = ngage_r32(c, (c->r[0] + 1560u)); /* ldr r1, [r0, #0x618] */
82181: L_1002a5ac:
82182:     ngage_sub_flags(c, c->r[1], 0x00000000u); /* cmp r1, #0 */
82183: L_1002a5b0:
82184:     if (ngage_zf(c)) { goto L_1002a6c8; } /* beq 0x2a6c8 <shadowkey_code+0x2a6c8> */
82185: L_1002a5b4:
82186:     c->r[3] = ngage_r32(c, (c->r[0] + 40u)); /* ldr r3, [r0, #0x28] */
82187: L_1002a5b8:
82188:     c->r[2] = ngage_r32(c, (c->r[3] + 120u)); /* ldr r2, [r3, #0x78] */
82189: L_1002a5bc:
82190:     ngage_sub_flags(c, c->r[2], 0x00000005u); /* cmp r2, #5 */

## Call 6: caller=sub_1002ae88, lifted_line=83683
83613:     c->r[12] = ngage_r32(c, (c->r[14] + c->r[3])); /* ldr r12, [lr, r3] */
83614: L_1002b118:
83615:     ngage_sub_flags(c, c->r[12], c->r[5]); /* cmp r12, r5 */
83616: L_1002b11c:
83617:     if (ngage_zf(c)) { goto L_1002b1a4; } /* beq 0x2b1a4 <shadowkey_code+0x2b1a4> */
83618: L_1002b120:
83619:     c->r[1] = ngage_r32(c, (c->r[14] + 1152u)); /* ldr r1, [lr, #0x480] */
83620: L_1002b124:
83621:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
83622: L_1002b128:
83623:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[5]); /* str r5, [sp, #0x4] */
83624: L_1002b12c:
83625:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
83626: L_1002b130:
83627:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
83628: L_1002b134:
83629:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
83630: L_1002b138:
83631:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
83632: L_1002b13c:
83633:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
83634: L_1002b140:
83635:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
83636: L_1002b144:
83637:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
83638: L_1002b148:
83639:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
83640: L_1002b14c:
83641:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
83642: L_1002b150:
83643:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[4]); /* str r4, [sp, #0x14] */
83644: L_1002b154:
83645:     c->r[0] = c->r[14]; /* mov r0, lr */
83646: L_1002b158:
83647:     c->r[2] = c->r[5]; /* mov r2, r5 */
83648: L_1002b15c:
83649:     c->r[3] = c->r[2]; /* mov r3, r2 */
83650: L_1002b160:
83651:     goto L_1002b1a0; /* b 0x2b1a0 <shadowkey_code+0x2b1a0> */
83652: L_1002b164:
83653:     c->r[1] = ngage_r32(c, (c->r[12] + 1152u)); /* ldr r1, [r12, #0x480] */
83654: L_1002b168:
83655:     { uint32_t _b = c->r[13]; ngage_w32(c, _b, c->r[4]); ngage_w32(c, _b + 4u, c->r[5]); } /* stm sp, {r4, r5} */
83656: L_1002b16c:
83657:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
83658: L_1002b170:
83659:     c->r[3] = ngage_r8(c, c->r[4]); /* ldrb r3, [r4] */
83660: L_1002b174:
83661:     c->r[0] = ngage_r8(c, (c->r[4] + 1u)); /* ldrb r0, [r4, #0x1] */
83662: L_1002b178:
83663:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
83664: L_1002b17c:
83665:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
83666: L_1002b180:
83667:     c->r[2] = ngage_r8(c, (c->r[4] + 2u)); /* ldrb r2, [r4, #0x2] */
83668: L_1002b184:
83669:     c->r[0] = ngage_r8(c, (c->r[4] + 3u)); /* ldrb r0, [r4, #0x3] */
83670: L_1002b188:
83671:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
83672: L_1002b18c:
83673:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
83674: L_1002b190:
83675:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[5]); /* str r5, [sp, #0x14] */
83676: L_1002b194:
83677:     c->r[3] = 0x000000a2u; /* mov r3, #162 */
83678: L_1002b198:
83679:     c->r[0] = c->r[12]; /* mov r0, r12 */
83680: L_1002b19c:
83681:     c->r[2] = c->r[5]; /* mov r2, r5 */
83682: L_1002b1a0:
83683:     c->r[14] = 0x1002b1a4u; ngage_call(c, 0x1006a488u); goto L_1002b1a4; /* bl 0x6a488 <shadowkey_code+0x6a488> */
83684: L_1002b1a4:
83685:     c->r[13] = c->r[13] + 0x0000001cu; /* add sp, sp, #28 */
83686: L_1002b1a8:
83687:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[10] = ngage_r32(c, c->r[13] + 20u); c->r[14] = ngage_r32(c, c->r[13] + 24u); c->r[13] += 28u; /* pop {r4, r5, r6, r7, r8, r10, lr} */
83688: L_1002b1ac:
83689:     return; /* bx lr */
83690: }
83691: 
83692: void sub_1002b1b0(ngage_cpu_t *c) {
83693:     (void)c;
83694:     if (0) { goto L_1002b1b0; goto L_1002b1b4; goto L_1002b1b8; goto L_1002b1bc; goto L_1002b1c0; goto L_1002b1c4; goto L_1002b1c8; goto L_1002b1cc; goto L_1002b1d0; goto L_1002b1d4; goto L_1002b1d8; goto L_1002b1dc; goto L_1002b1e0; goto L_1002b1e4; goto L_1002b1e8; goto L_1002b1ec; goto L_1002b1f0; goto L_1002b1f4; goto L_1002b1f8; goto L_1002b1fc; goto L_1002b200; goto L_1002b204; goto L_1002b208; goto L_1002b20c; goto L_1002b210; goto L_1002b214; goto L_1002b218; goto L_1002b21c; goto L_1002b220; goto L_1002b224; goto L_1002b228; goto L_1002b22c; goto L_1002b230; goto L_1002b234; goto L_1002b238; goto L_1002b23c; goto L_1002b240; goto L_1002b244; goto L_1002b248; goto L_1002b24c; goto L_1002b250; goto L_1002b254; goto L_1002b258; goto L_1002b25c; goto L_1002b260; goto L_1002b264; goto L_1002b268; goto L_1002b26c; goto L_1002b270; goto L_1002b274; goto L_1002b278; goto L_1002b27c; goto L_1002b280; goto L_1002b284; goto L_1002b288; goto L_1002b28c; goto L_1002b290; goto L_1002b294; goto L_1002b298; goto L_1002b29c; goto L_1002b2a0; goto L_1002b2a4; goto L_1002b2a8; goto L_1002b2ac; goto L_1002b2b0; goto L_1002b2b4; goto L_1002b2b8; goto L_1002b2bc; goto L_1002b2c0; goto L_1002b2c4; goto L_1002b2c8; goto L_1002b2cc; goto L_1002b2d0; goto L_1002b2d4; goto L_1002b2d8; goto L_1002b2dc; goto L_1002b2e0; goto L_1002b2e4; goto L_1002b2e8; goto L_1002b2ec; goto L_1002b2f0; goto L_1002b2f4; goto L_1002b2f8; goto L_1002b2fc; goto L_1002b300; goto L_1002b304; goto L_1002b308; goto L_1002b30c; goto L_1002b310; goto L_1002b314; goto L_1002b318; goto L_1002b31c; goto L_1002b320; goto L_1002b324; goto L_1002b328; goto L_1002b32c; goto L_1002b334; goto L_1002b338; goto L_1002b33c; goto L_1002b340; goto L_1002b344; goto L_1002b348; goto L_1002b34c; goto L_1002b350; goto L_1002b354; goto L_1002b358; goto L_1002b35c; goto L_1002b360; goto L_1002b364; goto L_1002b368; goto L_1002b36c; goto L_1002b370; goto L_1002b374; goto L_1002b378; goto L_1002b37c; goto L_1002b380; goto L_1002b384; goto L_1002b388; goto L_1002b38c; goto L_1002b390; goto L_1002b394; goto L_1002b398; goto L_1002b39c; goto L_1002b3a0; goto L_1002b3a4; goto L_1002b3a8; goto L_1002b3ac; goto L_1002b3b0; goto L_1002b3b4; goto L_1002b3b8; goto L_1002b3bc; goto L_1002b3c0; goto L_1002b3c4; goto L_1002b3c8; goto L_1002b3cc; goto L_1002b3d0; goto L_1002b3d4; goto L_1002b3d8; goto L_1002b3dc; goto L_1002b3e0; goto L_1002b3e4; goto L_1002b3e8; goto L_1002b3ec; goto L_1002b3f0; goto L_1002b3f4; goto L_1002b3f8; goto L_1002b3fc; goto L_1002b400; goto L_1002b404; goto L_1002b408; goto L_1002b40c; goto L_1002b410; goto L_1002b414; goto L_1002b418; goto L_1002b41c; goto L_1002b424; goto L_1002b428; goto L_1002b42c; }
83695: L_1002b1b0:
83696:     c->r[13] -= 24u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[14]); /* push {r4, r5, r6, r7, r8, lr} */
83697: L_1002b1b4:
83698:     c->r[13] = c->r[13] - 0x00000018u; /* sub sp, sp, #24 */
83699: L_1002b1b8:
83700:     c->r[5] = c->r[0]; /* mov r5, r0 */
83701: L_1002b1bc:
83702:     c->r[0] = ngage_r32(c, (c->r[5] + 20u)); /* ldr r0, [r5, #0x14] */
83703: L_1002b1c0:
83704:     c->r[1] = ngage_r32(c, (c->r[0] + 1560u)); /* ldr r1, [r0, #0x618] */
83705: L_1002b1c4:
83706:     c->r[3] = ngage_r32(c, (c->r[1] + 516u)); /* ldr r3, [r1, #0x204] */
83707: L_1002b1c8:
83708:     c->r[6] = ngage_r32(c, (c->r[3] + 412u)); /* ldr r6, [r3, #0x19c] */
83709: L_1002b1cc:
83710:     c->r[4] = 0x00000000u; /* mov r4, #0 */
83711: L_1002b1d0:
83712:     c->r[7] = c->r[4]; /* mov r7, r4 */
83713: L_1002b1d4:
83714:     ngage_sub_flags(c, c->r[6], c->r[4]); /* cmp r6, r4 */
83715: L_1002b1d8:
83716:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_1002b424; } /* blt 0x2b424 <shadowkey_code+0x2b424> */
83717: L_1002b1dc:

## Call 7: caller=sub_1002b1b0, lifted_line=84002
83932:     c->r[0] = c->r[2]; /* mov r0, r2 */
83933: L_1002b390:
83934:     ngage_sub_flags(c, c->r[7], c->r[2]); /* cmp r7, r2 */
83935: L_1002b394:
83936:     if ((ngage_nf(c) != ngage_vf(c))) { c->r[0] = 0x00000000u - c->r[7]; } /* rsblt r0, r7, #0 */
83937: L_1002b398:
83938:     if ((ngage_nf(c) != ngage_vf(c))) { c->r[7] = c->r[2]; } /* movlt r7, r2 */
83939: L_1002b39c:
83940:     ngage_sub_flags(c, c->r[4], 0x00000000u); /* cmp r4, #0 */
83941: L_1002b3a0:
83942:     if ((ngage_nf(c) != ngage_vf(c))) { c->r[2] = 0x00000000u - c->r[4]; } /* rsblt r2, r4, #0 */
83943: L_1002b3a4:
83944:     if ((ngage_nf(c) != ngage_vf(c))) { c->r[4] = 0x00000000u; } /* movlt r4, #0 */
83945: L_1002b3a8:
83946:     ngage_add_flags(c, c->r[6], 0x00000001u, 0); /* cmn r6, #1 */
83947: L_1002b3ac:
83948:     if (ngage_zf(c)) { goto L_1002b424; } /* beq 0x2b424 <shadowkey_code+0x2b424> */
83949: L_1002b3b0:
83950:     c->r[12] = c->r[5] + 0x00004400u; /* add r12, r5, #17408 */
83951: L_1002b3b4:
83952:     c->r[12] = c->r[12] + 0x00000060u; /* add r12, r12, #96 */
83953: L_1002b3b8:
83954:     c->r[14] = (c->r[6] << 2); /* lsl lr, r6, #2 */
83955: L_1002b3bc:
83956:     c->r[3] = ngage_r32(c, (c->r[12] + c->r[14])); /* ldr r3, [r12, lr] */
83957: L_1002b3c0:
83958:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
83959: L_1002b3c4:
83960:     if (ngage_zf(c)) { goto L_1002b424; } /* beq 0x2b424 <shadowkey_code+0x2b424> */
83961: L_1002b3c8:
83962:     c->r[1] = ngage_r32(c, (c->r[5] + 1152u)); /* ldr r1, [r5, #0x480] */
83963: L_1002b3cc:
83964:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
83965: L_1002b3d0:
83966:     { uint32_t _b = c->r[13]; ngage_w32(c, _b + 4u, c->r[0]); ngage_w32(c, _b + 8u, c->r[2]); } /* stmib sp, {r0, r2} */
83967: L_1002b3d4:
83968:     c->r[0] = ngage_r32(c, (c->r[12] + c->r[14])); /* ldr r0, [r12, lr] */
83969: L_1002b3d8:
83970:     c->r[3] = ngage_r8(c, c->r[0]); /* ldrb r3, [r0] */
83971: L_1002b3dc:
83972:     c->r[2] = ngage_r8(c, (c->r[0] + 1u)); /* ldrb r2, [r0, #0x1] */
83973: L_1002b3e0:
83974:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr r3, r3, r2, lsl #8 */
83975: L_1002b3e4:
83976:     c->r[3] = c->r[3] - c->r[7]; /* rsb r3, r7, r3 */
83977: L_1002b3e8:
83978:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
83979: L_1002b3ec:
83980:     c->r[0] = ngage_r32(c, (c->r[12] + c->r[14])); /* ldr r0, [r12, lr] */
83981: L_1002b3f0:
83982:     c->r[2] = ngage_r8(c, (c->r[0] + 2u)); /* ldrb r2, [r0, #0x2] */
83983: L_1002b3f4:
83984:     c->r[3] = ngage_r8(c, (c->r[0] + 3u)); /* ldrb r3, [r0, #0x3] */
83985: L_1002b3f8:
83986:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[3], 0u, 8u, 1u, 0u); /* orr r2, r2, r3, lsl #8 */
83987: L_1002b3fc:
83988:     c->r[2] = c->r[2] - c->r[4]; /* rsb r2, r4, r2 */
83989: L_1002b400:
83990:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
83991: L_1002b404:
83992:     c->r[3] = 0x00000000u; /* mov r3, #0 */
83993: L_1002b408:
83994:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[3]); /* str r3, [sp, #0x14] */
83995: L_1002b40c:
83996:     c->r[0] = c->r[5]; /* mov r0, r5 */
83997: L_1002b410:
83998:     c->r[2] = c->r[7]; /* mov r2, r7 */
83999: L_1002b414:
84000:     c->r[3] = c->r[4]; /* mov r3, r4 */
84001: L_1002b418:
84002:     c->r[14] = 0x1002b41cu; ngage_call(c, 0x1006a488u); goto L_1002b41c; /* bl 0x6a488 <shadowkey_code+0x6a488> */
84003: L_1002b41c:
84004:     goto L_1002b424; /* b 0x2b424 <shadowkey_code+0x2b424> */
84005: L_1002b424:
84006:     c->r[13] = c->r[13] + 0x00000018u; /* add sp, sp, #24 */
84007: L_1002b428:
84008:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[14] = ngage_r32(c, c->r[13] + 20u); c->r[13] += 24u; /* pop {r4, r5, r6, r7, r8, lr} */
84009: L_1002b42c:
84010:     return; /* bx lr */
84011: }
84012: 
84013: void sub_1002b430(ngage_cpu_t *c) {
84014:     (void)c;
84015:     if (0) { goto L_1002b430; goto L_1002b434; goto L_1002b438; goto L_1002b43c; goto L_1002b440; goto L_1002b444; goto L_1002b448; goto L_1002b44c; goto L_1002b450; goto L_1002b454; goto L_1002b458; goto L_1002b45c; goto L_1002b460; goto L_1002b464; goto L_1002b468; goto L_1002b46c; goto L_1002b470; goto L_1002b474; goto L_1002b478; goto L_1002b47c; goto L_1002b480; goto L_1002b484; goto L_1002b488; goto L_1002b48c; goto L_1002b490; goto L_1002b494; goto L_1002b498; goto L_1002b49c; goto L_1002b4a0; goto L_1002b4a4; goto L_1002b4a8; goto L_1002b4ac; goto L_1002b4b0; goto L_1002b4b4; goto L_1002b4b8; goto L_1002b4bc; goto L_1002b4c0; goto L_1002b4c4; goto L_1002b4c8; goto L_1002b4cc; goto L_1002b4d0; goto L_1002b4d4; goto L_1002b4d8; goto L_1002b4dc; goto L_1002b4e0; goto L_1002b4e4; goto L_1002b4e8; goto L_1002b4ec; goto L_1002b4f0; goto L_1002b4f4; goto L_1002b4f8; goto L_1002b4fc; goto L_1002b500; goto L_1002b504; goto L_1002b508; goto L_1002b50c; goto L_1002b510; goto L_1002b514; goto L_1002b518; goto L_1002b51c; goto L_1002b520; goto L_1002b524; goto L_1002b528; goto L_1002b52c; goto L_1002b530; goto L_1002b534; goto L_1002b538; goto L_1002b53c; goto L_1002b540; goto L_1002b544; goto L_1002b548; goto L_1002b54c; goto L_1002b550; goto L_1002b554; goto L_1002b558; goto L_1002b55c; goto L_1002b560; goto L_1002b564; goto L_1002b568; goto L_1002b56c; goto L_1002b570; goto L_1002b574; goto L_1002b578; goto L_1002b57c; goto L_1002b580; goto L_1002b584; goto L_1002b588; goto L_1002b58c; goto L_1002b590; goto L_1002b594; goto L_1002b598; goto L_1002b59c; goto L_1002b5a0; goto L_1002b5a4; goto L_1002b5a8; goto L_1002b5ac; goto L_1002b5b0; goto L_1002b5b4; goto L_1002b5b8; goto L_1002b5bc; goto L_1002b5c0; goto L_1002b5c4; goto L_1002b5c8; goto L_1002b5cc; goto L_1002b5d0; goto L_1002b5d4; goto L_1002b5d8; goto L_1002b5dc; goto L_1002b5e0; goto L_1002b5e4; goto L_1002b5e8; goto L_1002b5ec; goto L_1002b5f0; goto L_1002b5f4; goto L_1002b5f8; goto L_1002b5fc; goto L_1002b600; goto L_1002b604; goto L_1002b608; goto L_1002b60c; goto L_1002b610; goto L_1002b614; goto L_1002b618; goto L_1002b61c; goto L_1002b620; goto L_1002b624; goto L_1002b628; goto L_1002b62c; goto L_1002b630; goto L_1002b634; goto L_1002b638; goto L_1002b63c; goto L_1002b640; goto L_1002b644; goto L_1002b648; goto L_1002b64c; goto L_1002b650; goto L_1002b654; goto L_1002b658; goto L_1002b65c; goto L_1002b660; goto L_1002b664; goto L_1002b668; goto L_1002b66c; goto L_1002b670; goto L_1002b674; goto L_1002b678; goto L_1002b67c; goto L_1002b680; goto L_1002b684; goto L_1002b688; goto L_1002b68c; goto L_1002b690; goto L_1002b694; goto L_1002b698; goto L_1002b69c; goto L_1002b6a0; goto L_1002b6a4; goto L_1002b6a8; goto L_1002b6ac; goto L_1002b6b0; goto L_1002b6b4; goto L_1002b6b8; goto L_1002b6bc; goto L_1002b6c0; goto L_1002b6c8; goto L_1002b6cc; goto L_1002b6d0; goto L_1002b6d4; goto L_1002b6d8; goto L_1002b6dc; goto L_1002b6e0; goto L_1002b6e4; goto L_1002b6e8; goto L_1002b6ec; goto L_1002b6f0; goto L_1002b6f4; goto L_1002b6f8; goto L_1002b6fc; goto L_1002b700; goto L_1002b704; goto L_1002b708; goto L_1002b70c; goto L_1002b710; goto L_1002b714; goto L_1002b718; goto L_1002b71c; goto L_1002b720; goto L_1002b724; goto L_1002b728; goto L_1002b72c; goto L_1002b730; goto L_1002b734; goto L_1002b738; goto L_1002b73c; goto L_1002b740; goto L_1002b744; goto L_1002b748; goto L_1002b74c; goto L_1002b750; goto L_1002b754; goto L_1002b758; goto L_1002b75c; goto L_1002b760; goto L_1002b764; goto L_1002b768; goto L_1002b76c; goto L_1002b770; goto L_1002b774; goto L_1002b778; goto L_1002b77c; goto L_1002b780; goto L_1002b784; goto L_1002b788; goto L_1002b78c; goto L_1002b790; goto L_1002b794; goto L_1002b798; goto L_1002b79c; goto L_1002b7a0; goto L_1002b7a4; goto L_1002b7a8; goto L_1002b7ac; goto L_1002b7b0; goto L_1002b7b4; goto L_1002b7b8; goto L_1002b7bc; goto L_1002b7c0; goto L_1002b7c4; goto L_1002b7c8; goto L_1002b7cc; goto L_1002b7d0; goto L_1002b7d4; goto L_1002b7d8; goto L_1002b7dc; goto L_1002b7e0; goto L_1002b7e4; goto L_1002b7e8; goto L_1002b7ec; goto L_1002b7f0; goto L_1002b7f4; goto L_1002b7f8; goto L_1002b7fc; goto L_1002b800; goto L_1002b804; goto L_1002b808; goto L_1002b80c; goto L_1002b810; goto L_1002b814; goto L_1002b818; goto L_1002b81c; goto L_1002b820; goto L_1002b824; goto L_1002b828; goto L_1002b82c; goto L_1002b830; goto L_1002b834; goto L_1002b838; goto L_1002b83c; goto L_1002b840; goto L_1002b844; goto L_1002b848; goto L_1002b84c; goto L_1002b850; goto L_1002b854; goto L_1002b858; goto L_1002b85c; goto L_1002b860; goto L_1002b864; goto L_1002b868; goto L_1002b86c; goto L_1002b870; goto L_1002b874; goto L_1002b878; goto L_1002b87c; goto L_1002b880; goto L_1002b884; goto L_1002b888; goto L_1002b88c; goto L_1002b890; goto L_1002b894; goto L_1002b898; goto L_1002b89c; goto L_1002b8a0; goto L_1002b8a4; goto L_1002b8a8; goto L_1002b8ac; goto L_1002b8b0; goto L_1002b8b4; goto L_1002b8b8; goto L_1002b8bc; goto L_1002b8c0; goto L_1002b8c4; goto L_1002b8c8; goto L_1002b8cc; goto L_1002b8d0; goto L_1002b8d4; goto L_1002b8d8; goto L_1002b8dc; goto L_1002b8e0; goto L_1002b8e4; goto L_1002b8e8; goto L_1002b8ec; goto L_1002b8f0; goto L_1002b8f4; goto L_1002b8f8; goto L_1002b8fc; goto L_1002b900; goto L_1002b904; goto L_1002b908; goto L_1002b90c; goto L_1002b910; goto L_1002b914; goto L_1002b918; goto L_1002b91c; goto L_1002b920; goto L_1002b924; goto L_1002b928; goto L_1002b92c; goto L_1002b930; goto L_1002b934; goto L_1002b938; goto L_1002b93c; goto L_1002b940; goto L_1002b944; goto L_1002b948; goto L_1002b94c; goto L_1002b950; goto L_1002b954; goto L_1002b958; goto L_1002b95c; goto L_1002b960; goto L_1002b964; goto L_1002b968; goto L_1002b96c; goto L_1002b970; goto L_1002b974; goto L_1002b978; goto L_1002b97c; goto L_1002b980; goto L_1002b984; goto L_1002b988; goto L_1002b98c; goto L_1002b990; goto L_1002b994; goto L_1002b998; goto L_1002b99c; goto L_1002b9a0; goto L_1002b9a4; goto L_1002b9a8; goto L_1002b9ac; goto L_1002b9b0; goto L_1002b9b4; goto L_1002b9b8; goto L_1002b9bc; goto L_1002b9c0; goto L_1002b9c4; goto L_1002b9c8; goto L_1002b9cc; goto L_1002b9d0; goto L_1002b9d4; goto L_1002b9d8; goto L_1002b9dc; goto L_1002b9e0; goto L_1002b9e4; goto L_1002b9e8; goto L_1002b9ec; goto L_1002b9f0; goto L_1002b9f4; goto L_1002b9f8; goto L_1002b9fc; goto L_1002ba00; goto L_1002ba04; goto L_1002ba08; goto L_1002ba0c; goto L_1002ba10; goto L_1002ba14; goto L_1002ba18; goto L_1002ba1c; goto L_1002ba20; goto L_1002ba24; goto L_1002ba28; goto L_1002ba2c; goto L_1002ba30; goto L_1002ba34; goto L_1002ba38; goto L_1002ba3c; goto L_1002ba40; goto L_1002ba44; goto L_1002ba48; goto L_1002ba4c; goto L_1002ba50; goto L_1002ba54; goto L_1002ba58; goto L_1002ba5c; goto L_1002ba60; }
84016: L_1002b430:
84017:     c->r[13] -= 32u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[9]); ngage_w32(c, c->r[13] + 24u, c->r[10]); ngage_w32(c, c->r[13] + 28u, c->r[14]); /* push {r4, r5, r6, r7, r8, r9, r10, lr} */
84018: L_1002b434:
84019:     c->r[13] = c->r[13] - 0x00000158u; /* sub sp, sp, #344 */
84020: L_1002b438:
84021:     c->r[10] = c->r[0]; /* mov r10, r0 */
84022: L_1002b43c:
84023:     c->r[4] = ngage_r32(c, (c->r[10] + 20u)); /* ldr r4, [r10, #0x14] */
84024: L_1002b440:
84025:     c->r[7] = ngage_r32(c, (c->r[4] + 1136u)); /* ldr r7, [r4, #0x470] */
84026: L_1002b444:
84027:     c->r[3] = 0x00004400u; /* mov r3, #17408 */
84028: L_1002b448:
84029:     c->r[3] = c->r[3] + 0x000000b0u; /* add r3, r3, #176 */
84030: L_1002b44c:
84031:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
84032: L_1002b450:
84033:     ngage_w32(c, (c->r[13] + 84u), (uint32_t)c->r[7]); /* str r7, [sp, #0x54] */
84034: L_1002b454:
84035:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
84036: L_1002b458:

## Call 8: caller=sub_1002b430, lifted_line=84071
84001: L_1002b418:
84002:     c->r[14] = 0x1002b41cu; ngage_call(c, 0x1006a488u); goto L_1002b41c; /* bl 0x6a488 <shadowkey_code+0x6a488> */
84003: L_1002b41c:
84004:     goto L_1002b424; /* b 0x2b424 <shadowkey_code+0x2b424> */
84005: L_1002b424:
84006:     c->r[13] = c->r[13] + 0x00000018u; /* add sp, sp, #24 */
84007: L_1002b428:
84008:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[14] = ngage_r32(c, c->r[13] + 20u); c->r[13] += 24u; /* pop {r4, r5, r6, r7, r8, lr} */
84009: L_1002b42c:
84010:     return; /* bx lr */
84011: }
84012: 
84013: void sub_1002b430(ngage_cpu_t *c) {
84014:     (void)c;
84015:     if (0) { goto L_1002b430; goto L_1002b434; goto L_1002b438; goto L_1002b43c; goto L_1002b440; goto L_1002b444; goto L_1002b448; goto L_1002b44c; goto L_1002b450; goto L_1002b454; goto L_1002b458; goto L_1002b45c; goto L_1002b460; goto L_1002b464; goto L_1002b468; goto L_1002b46c; goto L_1002b470; goto L_1002b474; goto L_1002b478; goto L_1002b47c; goto L_1002b480; goto L_1002b484; goto L_1002b488; goto L_1002b48c; goto L_1002b490; goto L_1002b494; goto L_1002b498; goto L_1002b49c; goto L_1002b4a0; goto L_1002b4a4; goto L_1002b4a8; goto L_1002b4ac; goto L_1002b4b0; goto L_1002b4b4; goto L_1002b4b8; goto L_1002b4bc; goto L_1002b4c0; goto L_1002b4c4; goto L_1002b4c8; goto L_1002b4cc; goto L_1002b4d0; goto L_1002b4d4; goto L_1002b4d8; goto L_1002b4dc; goto L_1002b4e0; goto L_1002b4e4; goto L_1002b4e8; goto L_1002b4ec; goto L_1002b4f0; goto L_1002b4f4; goto L_1002b4f8; goto L_1002b4fc; goto L_1002b500; goto L_1002b504; goto L_1002b508; goto L_1002b50c; goto L_1002b510; goto L_1002b514; goto L_1002b518; goto L_1002b51c; goto L_1002b520; goto L_1002b524; goto L_1002b528; goto L_1002b52c; goto L_1002b530; goto L_1002b534; goto L_1002b538; goto L_1002b53c; goto L_1002b540; goto L_1002b544; goto L_1002b548; goto L_1002b54c; goto L_1002b550; goto L_1002b554; goto L_1002b558; goto L_1002b55c; goto L_1002b560; goto L_1002b564; goto L_1002b568; goto L_1002b56c; goto L_1002b570; goto L_1002b574; goto L_1002b578; goto L_1002b57c; goto L_1002b580; goto L_1002b584; goto L_1002b588; goto L_1002b58c; goto L_1002b590; goto L_1002b594; goto L_1002b598; goto L_1002b59c; goto L_1002b5a0; goto L_1002b5a4; goto L_1002b5a8; goto L_1002b5ac; goto L_1002b5b0; goto L_1002b5b4; goto L_1002b5b8; goto L_1002b5bc; goto L_1002b5c0; goto L_1002b5c4; goto L_1002b5c8; goto L_1002b5cc; goto L_1002b5d0; goto L_1002b5d4; goto L_1002b5d8; goto L_1002b5dc; goto L_1002b5e0; goto L_1002b5e4; goto L_1002b5e8; goto L_1002b5ec; goto L_1002b5f0; goto L_1002b5f4; goto L_1002b5f8; goto L_1002b5fc; goto L_1002b600; goto L_1002b604; goto L_1002b608; goto L_1002b60c; goto L_1002b610; goto L_1002b614; goto L_1002b618; goto L_1002b61c; goto L_1002b620; goto L_1002b624; goto L_1002b628; goto L_1002b62c; goto L_1002b630; goto L_1002b634; goto L_1002b638; goto L_1002b63c; goto L_1002b640; goto L_1002b644; goto L_1002b648; goto L_1002b64c; goto L_1002b650; goto L_1002b654; goto L_1002b658; goto L_1002b65c; goto L_1002b660; goto L_1002b664; goto L_1002b668; goto L_1002b66c; goto L_1002b670; goto L_1002b674; goto L_1002b678; goto L_1002b67c; goto L_1002b680; goto L_1002b684; goto L_1002b688; goto L_1002b68c; goto L_1002b690; goto L_1002b694; goto L_1002b698; goto L_1002b69c; goto L_1002b6a0; goto L_1002b6a4; goto L_1002b6a8; goto L_1002b6ac; goto L_1002b6b0; goto L_1002b6b4; goto L_1002b6b8; goto L_1002b6bc; goto L_1002b6c0; goto L_1002b6c8; goto L_1002b6cc; goto L_1002b6d0; goto L_1002b6d4; goto L_1002b6d8; goto L_1002b6dc; goto L_1002b6e0; goto L_1002b6e4; goto L_1002b6e8; goto L_1002b6ec; goto L_1002b6f0; goto L_1002b6f4; goto L_1002b6f8; goto L_1002b6fc; goto L_1002b700; goto L_1002b704; goto L_1002b708; goto L_1002b70c; goto L_1002b710; goto L_1002b714; goto L_1002b718; goto L_1002b71c; goto L_1002b720; goto L_1002b724; goto L_1002b728; goto L_1002b72c; goto L_1002b730; goto L_1002b734; goto L_1002b738; goto L_1002b73c; goto L_1002b740; goto L_1002b744; goto L_1002b748; goto L_1002b74c; goto L_1002b750; goto L_1002b754; goto L_1002b758; goto L_1002b75c; goto L_1002b760; goto L_1002b764; goto L_1002b768; goto L_1002b76c; goto L_1002b770; goto L_1002b774; goto L_1002b778; goto L_1002b77c; goto L_1002b780; goto L_1002b784; goto L_1002b788; goto L_1002b78c; goto L_1002b790; goto L_1002b794; goto L_1002b798; goto L_1002b79c; goto L_1002b7a0; goto L_1002b7a4; goto L_1002b7a8; goto L_1002b7ac; goto L_1002b7b0; goto L_1002b7b4; goto L_1002b7b8; goto L_1002b7bc; goto L_1002b7c0; goto L_1002b7c4; goto L_1002b7c8; goto L_1002b7cc; goto L_1002b7d0; goto L_1002b7d4; goto L_1002b7d8; goto L_1002b7dc; goto L_1002b7e0; goto L_1002b7e4; goto L_1002b7e8; goto L_1002b7ec; goto L_1002b7f0; goto L_1002b7f4; goto L_1002b7f8; goto L_1002b7fc; goto L_1002b800; goto L_1002b804; goto L_1002b808; goto L_1002b80c; goto L_1002b810; goto L_1002b814; goto L_1002b818; goto L_1002b81c; goto L_1002b820; goto L_1002b824; goto L_1002b828; goto L_1002b82c; goto L_1002b830; goto L_1002b834; goto L_1002b838; goto L_1002b83c; goto L_1002b840; goto L_1002b844; goto L_1002b848; goto L_1002b84c; goto L_1002b850; goto L_1002b854; goto L_1002b858; goto L_1002b85c; goto L_1002b860; goto L_1002b864; goto L_1002b868; goto L_1002b86c; goto L_1002b870; goto L_1002b874; goto L_1002b878; goto L_1002b87c; goto L_1002b880; goto L_1002b884; goto L_1002b888; goto L_1002b88c; goto L_1002b890; goto L_1002b894; goto L_1002b898; goto L_1002b89c; goto L_1002b8a0; goto L_1002b8a4; goto L_1002b8a8; goto L_1002b8ac; goto L_1002b8b0; goto L_1002b8b4; goto L_1002b8b8; goto L_1002b8bc; goto L_1002b8c0; goto L_1002b8c4; goto L_1002b8c8; goto L_1002b8cc; goto L_1002b8d0; goto L_1002b8d4; goto L_1002b8d8; goto L_1002b8dc; goto L_1002b8e0; goto L_1002b8e4; goto L_1002b8e8; goto L_1002b8ec; goto L_1002b8f0; goto L_1002b8f4; goto L_1002b8f8; goto L_1002b8fc; goto L_1002b900; goto L_1002b904; goto L_1002b908; goto L_1002b90c; goto L_1002b910; goto L_1002b914; goto L_1002b918; goto L_1002b91c; goto L_1002b920; goto L_1002b924; goto L_1002b928; goto L_1002b92c; goto L_1002b930; goto L_1002b934; goto L_1002b938; goto L_1002b93c; goto L_1002b940; goto L_1002b944; goto L_1002b948; goto L_1002b94c; goto L_1002b950; goto L_1002b954; goto L_1002b958; goto L_1002b95c; goto L_1002b960; goto L_1002b964; goto L_1002b968; goto L_1002b96c; goto L_1002b970; goto L_1002b974; goto L_1002b978; goto L_1002b97c; goto L_1002b980; goto L_1002b984; goto L_1002b988; goto L_1002b98c; goto L_1002b990; goto L_1002b994; goto L_1002b998; goto L_1002b99c; goto L_1002b9a0; goto L_1002b9a4; goto L_1002b9a8; goto L_1002b9ac; goto L_1002b9b0; goto L_1002b9b4; goto L_1002b9b8; goto L_1002b9bc; goto L_1002b9c0; goto L_1002b9c4; goto L_1002b9c8; goto L_1002b9cc; goto L_1002b9d0; goto L_1002b9d4; goto L_1002b9d8; goto L_1002b9dc; goto L_1002b9e0; goto L_1002b9e4; goto L_1002b9e8; goto L_1002b9ec; goto L_1002b9f0; goto L_1002b9f4; goto L_1002b9f8; goto L_1002b9fc; goto L_1002ba00; goto L_1002ba04; goto L_1002ba08; goto L_1002ba0c; goto L_1002ba10; goto L_1002ba14; goto L_1002ba18; goto L_1002ba1c; goto L_1002ba20; goto L_1002ba24; goto L_1002ba28; goto L_1002ba2c; goto L_1002ba30; goto L_1002ba34; goto L_1002ba38; goto L_1002ba3c; goto L_1002ba40; goto L_1002ba44; goto L_1002ba48; goto L_1002ba4c; goto L_1002ba50; goto L_1002ba54; goto L_1002ba58; goto L_1002ba5c; goto L_1002ba60; }
84016: L_1002b430:
84017:     c->r[13] -= 32u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[9]); ngage_w32(c, c->r[13] + 24u, c->r[10]); ngage_w32(c, c->r[13] + 28u, c->r[14]); /* push {r4, r5, r6, r7, r8, r9, r10, lr} */
84018: L_1002b434:
84019:     c->r[13] = c->r[13] - 0x00000158u; /* sub sp, sp, #344 */
84020: L_1002b438:
84021:     c->r[10] = c->r[0]; /* mov r10, r0 */
84022: L_1002b43c:
84023:     c->r[4] = ngage_r32(c, (c->r[10] + 20u)); /* ldr r4, [r10, #0x14] */
84024: L_1002b440:
84025:     c->r[7] = ngage_r32(c, (c->r[4] + 1136u)); /* ldr r7, [r4, #0x470] */
84026: L_1002b444:
84027:     c->r[3] = 0x00004400u; /* mov r3, #17408 */
84028: L_1002b448:
84029:     c->r[3] = c->r[3] + 0x000000b0u; /* add r3, r3, #176 */
84030: L_1002b44c:
84031:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
84032: L_1002b450:
84033:     ngage_w32(c, (c->r[13] + 84u), (uint32_t)c->r[7]); /* str r7, [sp, #0x54] */
84034: L_1002b454:
84035:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
84036: L_1002b458:
84037:     if (ngage_zf(c)) { goto L_1002b4a0; } /* beq 0x2b4a0 <shadowkey_code+0x2b4a0> */
84038: L_1002b45c:
84039:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
84040: L_1002b460:
84041:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
84042: L_1002b464:
84043:     c->r[2] = 0x00000000u; /* mov r2, #0 */
84044: L_1002b468:
84045:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
84046: L_1002b46c:
84047:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
84048: L_1002b470:
84049:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
84050: L_1002b474:
84051:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
84052: L_1002b478:
84053:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
84054: L_1002b47c:
84055:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
84056: L_1002b480:
84057:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
84058: L_1002b484:
84059:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
84060: L_1002b488:
84061:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
84062: L_1002b48c:
84063:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
84064: L_1002b490:
84065:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
84066: L_1002b494:
84067:     c->r[3] = c->r[2]; /* mov r3, r2 */
84068: L_1002b498:
84069:     c->r[0] = c->r[4]; /* mov r0, r4 */
84070: L_1002b49c:
84071:     c->r[14] = 0x1002b4a0u; ngage_call(c, 0x1006a488u); goto L_1002b4a0; /* bl 0x6a488 <shadowkey_code+0x6a488> */
84072: L_1002b4a0:
84073:     c->r[2] = ngage_r32(c, (c->r[10] + 20u)); /* ldr r2, [r10, #0x14] */
84074: L_1002b4a4:
84075:     c->r[0] = ngage_r32(c, (c->r[2] + 40u)); /* ldr r0, [r2, #0x28] */
84076: L_1002b4a8:
84077:     c->r[4] = c->r[13] + 0x00000058u; /* add r4, sp, #88 */
84078: L_1002b4ac:
84079:     c->r[1] = c->r[4]; /* mov r1, r4 */
84080: L_1002b4b0:
84081:     c->r[0] = c->r[0] + 0x00000028u; /* add r0, r0, #40 */
84082: L_1002b4b4:
84083:     c->r[14] = 0x1002b4b8u; ngage_call(c, 0x100290a8u); goto L_1002b4b8; /* bl 0x290a8 <shadowkey_code+0x290a8> */
84084: L_1002b4b8:
84085:     c->r[3] = ngage_r32(c, (c->r[10] + 20u)); /* ldr r3, [r10, #0x14] */
84086: L_1002b4bc:
84087:     c->r[0] = ngage_r32(c, (c->r[3] + 1468u)); /* ldr r0, [r3, #0x5bc] */
84088: L_1002b4c0:
84089:     c->r[2] = 0x00000001u; /* mov r2, #1 */
84090: L_1002b4c4:
84091:     ngage_w32(c, c->r[13], (uint32_t)c->r[2]); /* str r2, [sp] */
84092: L_1002b4c8:
84093:     c->r[3] = 0x00000000u; /* mov r3, #0 */
84094: L_1002b4cc:
84095:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[3]); /* str r3, [sp, #0x4] */
84096: L_1002b4d0:
84097:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[3]); /* str r3, [sp, #0x8] */
84098: L_1002b4d4:
84099:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
84100: L_1002b4d8:
84101:     c->r[1] = c->r[4]; /* mov r1, r4 */
84102: L_1002b4dc:
84103:     c->r[2] = 0x0000000au; /* mov r2, #10 */
84104: L_1002b4e0:
84105:     c->r[3] = 0x00000ff0u; /* mov r3, #4080 */

## Call 9: caller=sub_1002ba64, lifted_line=84926
84856:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
84857: L_1002babc:
84858:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
84859: L_1002bac0:
84860:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
84861: L_1002bac4:
84862:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
84863: L_1002bac8:
84864:     c->r[3] = c->r[12] + 0x00000044u; /* add r3, r12, #68 */
84865: L_1002bacc:
84866:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
84867: L_1002bad0:
84868:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
84869: L_1002bad4:
84870:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
84871: L_1002bad8:
84872:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[5]); /* str r5, [sp, #0x14] */
84873: L_1002badc:
84874:     c->r[0] = c->r[4]; /* mov r0, r4 */
84875: L_1002bae0:
84876:     c->r[2] = 0x00000034u; /* mov r2, #52 */
84877: L_1002bae4:
84878:     c->r[3] = 0x00000005u; /* mov r3, #5 */
84879: L_1002bae8:
84880:     c->r[14] = 0x1002baecu; ngage_call(c, 0x1006a690u); goto L_1002baec; /* bl 0x6a690 <shadowkey_code+0x6a690> */
84881: L_1002baec:
84882:     c->r[12] = ngage_r32(c, (c->r[7] + 20u)); /* ldr r12, [r7, #0x14] */
84883: L_1002baf0:
84884:     c->r[3] = 0x00000001u; /* mov r3, #1 */
84885: L_1002baf4:
84886:     c->r[2] = c->r[12] + c->r[6]; /* add r2, r12, r6 */
84887: L_1002baf8:
84888:     c->r[14] = ngage_r32(c, (c->r[2] + (c->r[3] << 2))); /* ldr lr, [r2, r3, lsl #2] */
84889: L_1002bafc:
84890:     ngage_sub_flags(c, c->r[14], c->r[5]); /* cmp lr, r5 */
84891: L_1002bb00:
84892:     if (ngage_zf(c)) { goto L_1002bb48; } /* beq 0x2bb48 <shadowkey_code+0x2bb48> */
84893: L_1002bb04:
84894:     c->r[1] = ngage_r32(c, (c->r[12] + 1152u)); /* ldr r1, [r12, #0x480] */
84895: L_1002bb08:
84896:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
84897: L_1002bb0c:
84898:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[5]); /* str r5, [sp, #0x4] */
84899: L_1002bb10:
84900:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
84901: L_1002bb14:
84902:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
84903: L_1002bb18:
84904:     c->r[0] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r0, [lr, #0x1] */
84905: L_1002bb1c:
84906:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
84907: L_1002bb20:
84908:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
84909: L_1002bb24:
84910:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r2, [lr, #0x2] */
84911: L_1002bb28:
84912:     c->r[0] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r0, [lr, #0x3] */
84913: L_1002bb2c:
84914:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
84915: L_1002bb30:
84916:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
84917: L_1002bb34:
84918:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[5]); /* str r5, [sp, #0x14] */
84919: L_1002bb38:
84920:     c->r[0] = c->r[12]; /* mov r0, r12 */
84921: L_1002bb3c:
84922:     c->r[2] = c->r[5]; /* mov r2, r5 */
84923: L_1002bb40:
84924:     c->r[3] = c->r[2]; /* mov r3, r2 */
84925: L_1002bb44:
84926:     c->r[14] = 0x1002bb48u; ngage_call(c, 0x1006a488u); goto L_1002bb48; /* bl 0x6a488 <shadowkey_code+0x6a488> */
84927: L_1002bb48:
84928:     c->r[13] = c->r[13] + 0x00000018u; /* add sp, sp, #24 */
84929: L_1002bb4c:
84930:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[14] = ngage_r32(c, c->r[13] + 16u); c->r[13] += 20u; /* pop {r4, r5, r6, r7, lr} */
84931: L_1002bb50:
84932:     return; /* bx lr */
84933: }
84934: 
84935: void sub_1002bb54(ngage_cpu_t *c) {
84936:     (void)c;
84937:     if (0) { goto L_1002bb54; goto L_1002bb58; goto L_1002bb5c; goto L_1002bb60; goto L_1002bb64; goto L_1002bb68; goto L_1002bb6c; goto L_1002bb70; goto L_1002bb74; goto L_1002bb78; goto L_1002bb7c; goto L_1002bb80; goto L_1002bb84; goto L_1002bb88; goto L_1002bb8c; goto L_1002bb90; goto L_1002bb94; goto L_1002bb98; goto L_1002bb9c; goto L_1002bba0; goto L_1002bba4; goto L_1002bba8; goto L_1002bbac; goto L_1002bbb0; goto L_1002bbb4; goto L_1002bbb8; goto L_1002bbbc; goto L_1002bbc0; goto L_1002bbc4; goto L_1002bbc8; goto L_1002bbcc; goto L_1002bbd0; goto L_1002bbd4; goto L_1002bbd8; goto L_1002bbdc; goto L_1002bbe0; goto L_1002bbe4; goto L_1002bbe8; goto L_1002bbec; goto L_1002bbf0; goto L_1002bbf4; goto L_1002bbf8; goto L_1002bbfc; goto L_1002bc00; goto L_1002bc04; goto L_1002bc08; goto L_1002bc0c; goto L_1002bc10; goto L_1002bc14; goto L_1002bc18; goto L_1002bc1c; goto L_1002bc20; goto L_1002bc24; goto L_1002bc28; goto L_1002bc2c; goto L_1002bc30; goto L_1002bc34; goto L_1002bc38; goto L_1002bc3c; goto L_1002bc40; goto L_1002bc44; goto L_1002bc48; goto L_1002bc4c; goto L_1002bc50; goto L_1002bc54; goto L_1002bc58; goto L_1002bc5c; goto L_1002bc60; goto L_1002bc64; goto L_1002bc68; }
84938: L_1002bb54:
84939:     c->r[13] -= 16u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[14]); /* push {r4, r5, r6, lr} */
84940: L_1002bb58:
84941:     c->r[13] = c->r[13] - 0x00000018u; /* sub sp, sp, #24 */
84942: L_1002bb5c:
84943:     c->r[6] = c->r[0]; /* mov r6, r0 */
84944: L_1002bb60:
84945:     c->r[3] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r3, [r6, #0x14] */
84946: L_1002bb64:
84947:     c->r[5] = ngage_r32(c, (c->r[3] + 1560u)); /* ldr r5, [r3, #0x618] */
84948: L_1002bb68:
84949:     ngage_sub_flags(c, c->r[5], 0x00000000u); /* cmp r5, #0 */
84950: L_1002bb6c:
84951:     if (ngage_zf(c)) { c->r[0] = c->r[5]; } /* moveq r0, r5 */
84952: L_1002bb70:
84953:     if (!ngage_zf(c)) { c->r[0] = c->r[5] + 0x000003acu; } /* addne r0, r5, #940 */
84954: L_1002bb74:
84955:     c->r[0] = ngage_r32(c, (c->r[0] + 76u)); /* ldr r0, [r0, #0x4c] */
84956: L_1002bb78:
84957:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
84958: L_1002bb7c:
84959:     if (ngage_zf(c)) { goto L_1002bbe4; } /* beq 0x2bbe4 <shadowkey_code+0x2bbe4> */
84960: L_1002bb80:

## Call 10: caller=sub_1002bb54, lifted_line=85009
84939:     c->r[13] -= 16u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[14]); /* push {r4, r5, r6, lr} */
84940: L_1002bb58:
84941:     c->r[13] = c->r[13] - 0x00000018u; /* sub sp, sp, #24 */
84942: L_1002bb5c:
84943:     c->r[6] = c->r[0]; /* mov r6, r0 */
84944: L_1002bb60:
84945:     c->r[3] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r3, [r6, #0x14] */
84946: L_1002bb64:
84947:     c->r[5] = ngage_r32(c, (c->r[3] + 1560u)); /* ldr r5, [r3, #0x618] */
84948: L_1002bb68:
84949:     ngage_sub_flags(c, c->r[5], 0x00000000u); /* cmp r5, #0 */
84950: L_1002bb6c:
84951:     if (ngage_zf(c)) { c->r[0] = c->r[5]; } /* moveq r0, r5 */
84952: L_1002bb70:
84953:     if (!ngage_zf(c)) { c->r[0] = c->r[5] + 0x000003acu; } /* addne r0, r5, #940 */
84954: L_1002bb74:
84955:     c->r[0] = ngage_r32(c, (c->r[0] + 76u)); /* ldr r0, [r0, #0x4c] */
84956: L_1002bb78:
84957:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
84958: L_1002bb7c:
84959:     if (ngage_zf(c)) { goto L_1002bbe4; } /* beq 0x2bbe4 <shadowkey_code+0x2bbe4> */
84960: L_1002bb80:
84961:     c->r[14] = 0x1002bb84u; ngage_call(c, 0x1002edf4u); goto L_1002bb84; /* bl 0x2edf4 <shadowkey_code+0x2edf4> */
84962: L_1002bb84:
84963:     c->r[4] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r4, [r6, #0x14] */
84964: L_1002bb88:
84965:     c->r[3] = c->r[4] + 0x00004400u; /* add r3, r4, #17408 */
84966: L_1002bb8c:
84967:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
84968: L_1002bb90:
84969:     c->r[14] = ngage_r32(c, (c->r[3] + (c->r[0] << 2))); /* ldr lr, [r3, r0, lsl #2] */
84970: L_1002bb94:
84971:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
84972: L_1002bb98:
84973:     if (ngage_zf(c)) { goto L_1002bbe4; } /* beq 0x2bbe4 <shadowkey_code+0x2bbe4> */
84974: L_1002bb9c:
84975:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
84976: L_1002bba0:
84977:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
84978: L_1002bba4:
84979:     c->r[12] = 0x00000000u; /* mov r12, #0 */
84980: L_1002bba8:
84981:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
84982: L_1002bbac:
84983:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[12]); /* str r12, [sp, #0x8] */
84984: L_1002bbb0:
84985:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
84986: L_1002bbb4:
84987:     c->r[0] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r0, [lr, #0x1] */
84988: L_1002bbb8:
84989:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
84990: L_1002bbbc:
84991:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
84992: L_1002bbc0:
84993:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r2, [lr, #0x2] */
84994: L_1002bbc4:
84995:     c->r[0] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r0, [lr, #0x3] */
84996: L_1002bbc8:
84997:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
84998: L_1002bbcc:
84999:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
85000: L_1002bbd0:
85001:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
85002: L_1002bbd4:
85003:     c->r[3] = 0x00000005u; /* mov r3, #5 */
85004: L_1002bbd8:
85005:     c->r[0] = c->r[4]; /* mov r0, r4 */
85006: L_1002bbdc:
85007:     c->r[2] = 0x0000008bu; /* mov r2, #139 */
85008: L_1002bbe0:
85009:     c->r[14] = 0x1002bbe4u; ngage_call(c, 0x1006a488u); goto L_1002bbe4; /* bl 0x6a488 <shadowkey_code+0x6a488> */
85010: L_1002bbe4:
85011:     ngage_sub_flags(c, c->r[5], 0x00000000u); /* cmp r5, #0 */
85012: L_1002bbe8:
85013:     if (ngage_zf(c)) { c->r[0] = c->r[5]; } /* moveq r0, r5 */
85014: L_1002bbec:
85015:     if (!ngage_zf(c)) { c->r[0] = c->r[5] + 0x000003acu; } /* addne r0, r5, #940 */
85016: L_1002bbf0:
85017:     c->r[0] = ngage_r32(c, (c->r[0] + 72u)); /* ldr r0, [r0, #0x48] */
85018: L_1002bbf4:
85019:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
85020: L_1002bbf8:
85021:     if (ngage_zf(c)) { goto L_1002bc60; } /* beq 0x2bc60 <shadowkey_code+0x2bc60> */
85022: L_1002bbfc:
85023:     c->r[14] = 0x1002bc00u; ngage_call(c, 0x1002edf4u); goto L_1002bc00; /* bl 0x2edf4 <shadowkey_code+0x2edf4> */
85024: L_1002bc00:
85025:     c->r[4] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r4, [r6, #0x14] */
85026: L_1002bc04:
85027:     c->r[3] = c->r[4] + 0x00004400u; /* add r3, r4, #17408 */
85028: L_1002bc08:
85029:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
85030: L_1002bc0c:
85031:     c->r[14] = ngage_r32(c, (c->r[3] + (c->r[0] << 2))); /* ldr lr, [r3, r0, lsl #2] */
85032: L_1002bc10:
85033:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
85034: L_1002bc14:
85035:     if (ngage_zf(c)) { goto L_1002bc60; } /* beq 0x2bc60 <shadowkey_code+0x2bc60> */
85036: L_1002bc18:
85037:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
85038: L_1002bc1c:
85039:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
85040: L_1002bc20:
85041:     c->r[12] = 0x00000000u; /* mov r12, #0 */
85042: L_1002bc24:
85043:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */

## Call 11: caller=sub_1002bb54, lifted_line=85071
85001:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
85002: L_1002bbd4:
85003:     c->r[3] = 0x00000005u; /* mov r3, #5 */
85004: L_1002bbd8:
85005:     c->r[0] = c->r[4]; /* mov r0, r4 */
85006: L_1002bbdc:
85007:     c->r[2] = 0x0000008bu; /* mov r2, #139 */
85008: L_1002bbe0:
85009:     c->r[14] = 0x1002bbe4u; ngage_call(c, 0x1006a488u); goto L_1002bbe4; /* bl 0x6a488 <shadowkey_code+0x6a488> */
85010: L_1002bbe4:
85011:     ngage_sub_flags(c, c->r[5], 0x00000000u); /* cmp r5, #0 */
85012: L_1002bbe8:
85013:     if (ngage_zf(c)) { c->r[0] = c->r[5]; } /* moveq r0, r5 */
85014: L_1002bbec:
85015:     if (!ngage_zf(c)) { c->r[0] = c->r[5] + 0x000003acu; } /* addne r0, r5, #940 */
85016: L_1002bbf0:
85017:     c->r[0] = ngage_r32(c, (c->r[0] + 72u)); /* ldr r0, [r0, #0x48] */
85018: L_1002bbf4:
85019:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
85020: L_1002bbf8:
85021:     if (ngage_zf(c)) { goto L_1002bc60; } /* beq 0x2bc60 <shadowkey_code+0x2bc60> */
85022: L_1002bbfc:
85023:     c->r[14] = 0x1002bc00u; ngage_call(c, 0x1002edf4u); goto L_1002bc00; /* bl 0x2edf4 <shadowkey_code+0x2edf4> */
85024: L_1002bc00:
85025:     c->r[4] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r4, [r6, #0x14] */
85026: L_1002bc04:
85027:     c->r[3] = c->r[4] + 0x00004400u; /* add r3, r4, #17408 */
85028: L_1002bc08:
85029:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
85030: L_1002bc0c:
85031:     c->r[14] = ngage_r32(c, (c->r[3] + (c->r[0] << 2))); /* ldr lr, [r3, r0, lsl #2] */
85032: L_1002bc10:
85033:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
85034: L_1002bc14:
85035:     if (ngage_zf(c)) { goto L_1002bc60; } /* beq 0x2bc60 <shadowkey_code+0x2bc60> */
85036: L_1002bc18:
85037:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
85038: L_1002bc1c:
85039:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
85040: L_1002bc20:
85041:     c->r[12] = 0x00000000u; /* mov r12, #0 */
85042: L_1002bc24:
85043:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
85044: L_1002bc28:
85045:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[12]); /* str r12, [sp, #0x8] */
85046: L_1002bc2c:
85047:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
85048: L_1002bc30:
85049:     c->r[0] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r0, [lr, #0x1] */
85050: L_1002bc34:
85051:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
85052: L_1002bc38:
85053:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
85054: L_1002bc3c:
85055:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r2, [lr, #0x2] */
85056: L_1002bc40:
85057:     c->r[0] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r0, [lr, #0x3] */
85058: L_1002bc44:
85059:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
85060: L_1002bc48:
85061:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
85062: L_1002bc4c:
85063:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
85064: L_1002bc50:
85065:     c->r[0] = c->r[4]; /* mov r0, r4 */
85066: L_1002bc54:
85067:     c->r[2] = 0x00000005u; /* mov r2, #5 */
85068: L_1002bc58:
85069:     c->r[3] = c->r[2]; /* mov r3, r2 */
85070: L_1002bc5c:
85071:     c->r[14] = 0x1002bc60u; ngage_call(c, 0x1006a488u); goto L_1002bc60; /* bl 0x6a488 <shadowkey_code+0x6a488> */
85072: L_1002bc60:
85073:     c->r[13] = c->r[13] + 0x00000018u; /* add sp, sp, #24 */
85074: L_1002bc64:
85075:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[14] = ngage_r32(c, c->r[13] + 12u); c->r[13] += 16u; /* pop {r4, r5, r6, lr} */
85076: L_1002bc68:
85077:     return; /* bx lr */
85078: }
85079: 
85080: void sub_1002bc6c(ngage_cpu_t *c) {
85081:     (void)c;
85082:     if (0) { goto L_1002bc6c; goto L_1002bc70; goto L_1002bc74; goto L_1002bc78; goto L_1002bc7c; goto L_1002bc80; goto L_1002bc84; goto L_1002bc88; goto L_1002bc8c; goto L_1002bc90; goto L_1002bc94; goto L_1002bc98; goto L_1002bc9c; goto L_1002bca0; goto L_1002bca4; goto L_1002bca8; goto L_1002bcac; goto L_1002bcb0; goto L_1002bcb4; goto L_1002bcb8; goto L_1002bcbc; goto L_1002bcc0; goto L_1002bcc4; goto L_1002bce0; goto L_1002bce4; goto L_1002bce8; goto L_1002bcec; goto L_1002bcf0; goto L_1002bcf4; goto L_1002bcf8; goto L_1002bcfc; goto L_1002bd00; goto L_1002bd04; goto L_1002bd08; goto L_1002bd0c; goto L_1002bd10; goto L_1002bd14; goto L_1002bd18; goto L_1002bd1c; goto L_1002bd20; goto L_1002bd24; goto L_1002bd28; goto L_1002bd2c; goto L_1002bd30; goto L_1002bd34; goto L_1002bd38; goto L_1002bd3c; goto L_1002bd40; goto L_1002bd44; goto L_1002bd48; goto L_1002bd4c; goto L_1002bd50; goto L_1002bd54; goto L_1002bd58; goto L_1002bd5c; goto L_1002bd60; goto L_1002bd64; goto L_1002bd68; goto L_1002bd6c; goto L_1002bd70; goto L_1002bd74; goto L_1002bd78; goto L_1002bd7c; goto L_1002bd80; goto L_1002bd84; goto L_1002bd88; goto L_1002bd8c; goto L_1002bd90; goto L_1002bd94; goto L_1002bd98; goto L_1002bd9c; goto L_1002bda0; goto L_1002bda4; goto L_1002bda8; goto L_1002bdac; goto L_1002bdb0; goto L_1002bdb4; goto L_1002bdb8; goto L_1002bdbc; goto L_1002bdc0; goto L_1002bdc4; goto L_1002bdc8; goto L_1002bdcc; goto L_1002bdd0; goto L_1002bdd4; goto L_1002bdd8; goto L_1002bddc; goto L_1002bde0; goto L_1002bde4; goto L_1002bde8; goto L_1002bdec; goto L_1002bdf0; }
85083: L_1002bc6c:
85084:     c->r[13] -= 12u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[14]); /* push {r4, r5, lr} */
85085: L_1002bc70:
85086:     c->r[5] = c->r[0]; /* mov r5, r0 */
85087: L_1002bc74:
85088:     c->r[3] = ngage_r32(c, (c->r[5] + 20u)); /* ldr r3, [r5, #0x14] */
85089: L_1002bc78:
85090:     c->r[0] = ngage_r32(c, (c->r[3] + 1560u)); /* ldr r0, [r3, #0x618] */
85091: L_1002bc7c:
85092:     c->r[12] = 0x00000000u; /* mov r12, #0 */
85093: L_1002bc80:
85094:     ngage_w32(c, (c->r[0] + 152u), (uint32_t)c->r[12]); /* str r12, [r0, #0x98] */
85095: L_1002bc84:
85096:     c->r[3] = ngage_r32(c, (c->r[5] + 20u)); /* ldr r3, [r5, #0x14] */
85097: L_1002bc88:
85098:     c->r[2] = ngage_r32(c, (c->r[3] + 1560u)); /* ldr r2, [r3, #0x618] */
85099: L_1002bc8c:
85100:     ngage_w32(c, (c->r[2] + 160u), (uint32_t)c->r[12]); /* str r12, [r2, #0xa0] */
85101: L_1002bc90:
85102:     c->r[0] = ngage_r32(c, (c->r[5] + 20u)); /* ldr r0, [r5, #0x14] */
85103: L_1002bc94:
85104:     c->r[3] = 0x000005c0u; /* mov r3, #1472 */
85105: L_1002bc98:

## Call 12: caller=sub_1002bdf4, lifted_line=85449
85379:     c->r[2] = ngage_r8(c, (c->r[1] + c->r[3])); /* ldrb r2, [r1, r3] */
85380: L_1002becc:
85381:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
85382: L_1002bed0:
85383:     if (!ngage_zf(c)) { c->r[0] = ngage_r32(c, (c->r[1] + 1488u)); } /* ldrne r0, [r1, #0x5d0] */
85384: L_1002bed4:
85385:     if (!ngage_zf(c)) { c->r[3] = ngage_r32(c, (c->r[0] + 4u)); } /* ldrne r3, [r0, #0x4] */
85386: L_1002bed8:
85387:     if (!ngage_zf(c)) { c->r[1] = 0x00000000u; } /* movne r1, #0 */
85388: L_1002bedc:
85389:     if (!ngage_zf(c)) { c->r[12] = ngage_r32(c, (c->r[3] + 96u)); } /* ldrne r12, [r3, #0x60] */
85390: L_1002bee0:
85391:     if (!ngage_zf(c)) { c->r[14] = 0x1002bee8u; } /* movne lr, pc */
85392: L_1002bee4:
85393:     if (!ngage_zf(c)) { ngage_call(c, c->r[12]); goto L_1002bee8; } /* bxne r12 */
85394: L_1002bee8:
85395:     c->r[1] = ngage_r32(c, (c->r[4] + 120u)); /* ldr r1, [r4, #0x78] */
85396: L_1002beec:
85397:     c->r[5] = ngage_r32(c, (c->r[4] + 20u)); /* ldr r5, [r4, #0x14] */
85398: L_1002bef0:
85399:     c->r[2] = ngage_r32(c, (c->r[4] + 352u)); /* ldr r2, [r4, #0x160] */
85400: L_1002bef4:
85401:     c->r[3] = c->r[5] + 0x00004400u; /* add r3, r5, #17408 */
85402: L_1002bef8:
85403:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
85404: L_1002befc:
85405:     c->r[6] = c->r[1] - 0x00000020u; /* sub r6, r1, #32 */
85406: L_1002bf00:
85407:     c->r[2] = c->r[2] + c->r[6]; /* add r2, r2, r6 */
85408: L_1002bf04:
85409:     c->r[14] = ngage_r32(c, (c->r[3] + (c->r[2] << 2))); /* ldr lr, [r3, r2, lsl #2] */
85410: L_1002bf08:
85411:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
85412: L_1002bf0c:
85413:     if (ngage_zf(c)) { goto L_1002bf58; } /* beq 0x2bf58 <shadowkey_code+0x2bf58> */
85414: L_1002bf10:
85415:     c->r[1] = ngage_r32(c, (c->r[5] + 1152u)); /* ldr r1, [r5, #0x480] */
85416: L_1002bf14:
85417:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
85418: L_1002bf18:
85419:     c->r[12] = 0x00000000u; /* mov r12, #0 */
85420: L_1002bf1c:
85421:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
85422: L_1002bf20:
85423:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[12]); /* str r12, [sp, #0x8] */
85424: L_1002bf24:
85425:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
85426: L_1002bf28:
85427:     c->r[0] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r0, [lr, #0x1] */
85428: L_1002bf2c:
85429:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
85430: L_1002bf30:
85431:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
85432: L_1002bf34:
85433:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r2, [lr, #0x2] */
85434: L_1002bf38:
85435:     c->r[0] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r0, [lr, #0x3] */
85436: L_1002bf3c:
85437:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
85438: L_1002bf40:
85439:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
85440: L_1002bf44:
85441:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
85442: L_1002bf48:
85443:     c->r[3] = 0x00000005u; /* mov r3, #5 */
85444: L_1002bf4c:
85445:     c->r[0] = c->r[5]; /* mov r0, r5 */
85446: L_1002bf50:
85447:     c->r[2] = 0x0000000eu; /* mov r2, #14 */
85448: L_1002bf54:
85449:     c->r[14] = 0x1002bf58u; ngage_call(c, 0x1006a488u); goto L_1002bf58; /* bl 0x6a488 <shadowkey_code+0x6a488> */
85450: L_1002bf58:
85451:     c->r[1] = ngage_r32(c, (c->r[4] + 20u)); /* ldr r1, [r4, #0x14] */
85452: L_1002bf5c:
85453:     c->r[2] = ngage_r32(c, (c->r[4] + 360u)); /* ldr r2, [r4, #0x168] */
85454: L_1002bf60:
85455:     c->r[0] = ngage_r32(c, (c->r[1] + 8u)); /* ldr r0, [r1, #0x8] */
85456: L_1002bf64:
85457:     c->r[3] = 0x00014800u; /* mov r3, #83968 */
85458: L_1002bf68:
85459:     c->r[3] = c->r[3] + 0x0000023cu; /* add r3, r3, #572 */
85460: L_1002bf6c:
85461:     c->r[12] = ngage_r32(c, (c->r[1] + c->r[3])); /* ldr r12, [r1, r3] */
85462: L_1002bf70:
85463:     c->r[2] = c->r[2] + c->r[6]; /* add r2, r2, r6 */
85464: L_1002bf74:
85465:     c->r[1] = ngage_r32(c, (c->r[12] + (c->r[2] << 2))); /* ldr r1, [r12, r2, lsl #2] */
85466: L_1002bf78:
85467:     c->r[3] = 0x000000abu; /* mov r3, #171 */
85468: L_1002bf7c:
85469:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
85470: L_1002bf80:
85471:     c->r[3] = 0x000000ffu; /* mov r3, #255 */
85472: L_1002bf84:
85473:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[3]); /* str r3, [sp, #0x8] */
85474: L_1002bf88:
85475:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
85476: L_1002bf8c:
85477:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[3]); /* str r3, [sp, #0x10] */
85478: L_1002bf90:
85479:     c->r[2] = 0x000000aau; /* mov r2, #170 */
85480: L_1002bf94:
85481:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
85482: L_1002bf98:
85483:     c->r[3] = 0x00000001u; /* mov r3, #1 */

## Call 13: caller=sub_1002c010, lifted_line=85647
85577:     c->r[5] = 0x00004700u; /* mov r5, #18176 */
85578: L_1002c044:
85579:     c->r[3] = c->r[5] + 0x00000094u; /* add r3, r5, #148 */
85580: L_1002c048:
85581:     c->r[3] = ngage_r32(c, (c->r[0] + c->r[3])); /* ldr r3, [r0, r3] */
85582: L_1002c04c:
85583:     c->r[12] = ((uint32_t)((int32_t)c->r[12] >> 16)); /* asr r12, r12, #16 */
85584: L_1002c050:
85585:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
85586: L_1002c054:
85587:     if (ngage_zf(c)) { goto L_1002c088; } /* beq 0x2c088 <shadowkey_code+0x2c088> */
85588: L_1002c058:
85589:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
85590: L_1002c05c:
85591:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
85592: L_1002c060:
85593:     c->r[2] = 0x00000000u; /* mov r2, #0 */
85594: L_1002c064:
85595:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
85596: L_1002c068:
85597:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
85598: L_1002c06c:
85599:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
85600: L_1002c070:
85601:     c->r[3] = 0x00000009u; /* mov r3, #9 */
85602: L_1002c074:
85603:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[3]); /* str r3, [sp, #0x10] */
85604: L_1002c078:
85605:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[12]); /* str r12, [sp, #0xc] */
85606: L_1002c07c:
85607:     c->r[2] = 0x0000002cu; /* mov r2, #44 */
85608: L_1002c080:
85609:     c->r[3] = 0x000000b6u; /* mov r3, #182 */
85610: L_1002c084:
85611:     c->r[14] = 0x1002c088u; ngage_call(c, 0x1006a690u); goto L_1002c088; /* bl 0x6a690 <shadowkey_code+0x6a690> */
85612: L_1002c088:
85613:     c->r[0] = ngage_r32(c, (c->r[4] + 20u)); /* ldr r0, [r4, #0x14] */
85614: L_1002c08c:
85615:     c->r[3] = c->r[5] + 0x00000098u; /* add r3, r5, #152 */
85616: L_1002c090:
85617:     c->r[3] = ngage_r32(c, (c->r[0] + c->r[3])); /* ldr r3, [r0, r3] */
85618: L_1002c094:
85619:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
85620: L_1002c098:
85621:     if (ngage_zf(c)) { goto L_1002c0d8; } /* beq 0x2c0d8 <shadowkey_code+0x2c0d8> */
85622: L_1002c09c:
85623:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
85624: L_1002c0a0:
85625:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
85626: L_1002c0a4:
85627:     c->r[12] = 0x00000000u; /* mov r12, #0 */
85628: L_1002c0a8:
85629:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
85630: L_1002c0ac:
85631:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[12]); /* str r12, [sp, #0x8] */
85632: L_1002c0b0:
85633:     c->r[2] = 0x0000002au; /* mov r2, #42 */
85634: L_1002c0b4:
85635:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
85636: L_1002c0b8:
85637:     c->r[3] = 0x0000005eu; /* mov r3, #94 */
85638: L_1002c0bc:
85639:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
85640: L_1002c0c0:
85641:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
85642: L_1002c0c4:
85643:     c->r[2] = 0x00000028u; /* mov r2, #40 */
85644: L_1002c0c8:
85645:     c->r[3] = 0x000000a6u; /* mov r3, #166 */
85646: L_1002c0cc:
85647:     c->r[14] = 0x1002c0d0u; ngage_call(c, 0x1006a488u); goto L_1002c0d0; /* bl 0x6a488 <shadowkey_code+0x6a488> */
85648: L_1002c0d0:
85649:     goto L_1002c0d8; /* b 0x2c0d8 <shadowkey_code+0x2c0d8> */
85650: L_1002c0d8:
85651:     c->r[13] = c->r[13] + 0x00000018u; /* add sp, sp, #24 */
85652: L_1002c0dc:
85653:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[14] = ngage_r32(c, c->r[13] + 12u); c->r[13] += 16u; /* pop {r4, r5, r6, lr} */
85654: L_1002c0e0:
85655:     return; /* bx lr */
85656: }
85657: 
85658: void sub_1002c100(ngage_cpu_t *c) {
85659:     (void)c;
85660:     if (0) { goto L_1002c100; }
85661: L_1002c100:
85662:     return; /* bx lr */
85663: }
85664: 
85665: void sub_1002c104(ngage_cpu_t *c) {
85666:     (void)c;
85667:     if (0) { goto L_1002c104; goto L_1002c108; goto L_1002c10c; goto L_1002c110; goto L_1002c114; goto L_1002c118; goto L_1002c11c; goto L_1002c120; goto L_1002c124; goto L_1002c128; goto L_1002c12c; goto L_1002c130; goto L_1002c134; goto L_1002c138; goto L_1002c13c; goto L_1002c140; goto L_1002c144; goto L_1002c148; goto L_1002c14c; goto L_1002c150; goto L_1002c154; goto L_1002c158; goto L_1002c15c; goto L_1002c160; goto L_1002c164; goto L_1002c168; goto L_1002c16c; goto L_1002c170; goto L_1002c174; goto L_1002c178; goto L_1002c17c; goto L_1002c180; goto L_1002c184; goto L_1002c188; goto L_1002c18c; goto L_1002c190; goto L_1002c19c; goto L_1002c1a0; goto L_1002c1a4; }
85668: L_1002c104:
85669:     c->r[13] -= 20u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[14]); /* push {r4, r5, r6, r7, lr} */
85670: L_1002c108:
85671:     c->r[1] = 0x100ad9e4u; /* literal 0x1002c194 */ /* ldr r1, [pc, #0x84] */
85672: L_1002c10c:
85673:     c->r[13] = c->r[13] - 0x00000220u; /* sub sp, sp, #544 */
85674: L_1002c110:
85675:     c->r[7] = c->r[0]; /* mov r7, r0 */
85676: L_1002c114:
85677:     c->r[3] = ngage_r32(c, (c->r[7] + 20u)); /* ldr r3, [r7, #0x14] */
85678: L_1002c118:
85679:     c->r[0] = ngage_r32(c, (c->r[3] + 1560u)); /* ldr r0, [r3, #0x618] */
85680: L_1002c11c:
85681:     c->r[2] = ngage_r32(c, (c->r[0] + 148u)); /* ldr r2, [r0, #0x94] */

## Call 14: caller=sub_10032aa4, lifted_line=98820
98750: }
98751: 
98752: void sub_10032aa4(ngage_cpu_t *c) {
98753:     (void)c;
98754:     if (0) { goto L_10032aa4; goto L_10032aa8; goto L_10032aac; goto L_10032ab0; goto L_10032ab4; goto L_10032ab8; goto L_10032abc; goto L_10032ac0; goto L_10032ac4; goto L_10032ac8; goto L_10032acc; goto L_10032ad0; goto L_10032ad4; goto L_10032ad8; goto L_10032adc; goto L_10032ae0; goto L_10032ae4; goto L_10032ae8; goto L_10032aec; goto L_10032af0; goto L_10032af4; goto L_10032af8; goto L_10032afc; goto L_10032b00; goto L_10032b04; goto L_10032b08; goto L_10032b0c; goto L_10032b10; goto L_10032b14; goto L_10032b18; goto L_10032b1c; goto L_10032b20; goto L_10032b24; goto L_10032b28; goto L_10032b2c; goto L_10032b30; goto L_10032b34; goto L_10032b38; goto L_10032b3c; goto L_10032b40; goto L_10032b44; goto L_10032b48; goto L_10032b4c; goto L_10032b50; goto L_10032b54; goto L_10032b58; goto L_10032b5c; goto L_10032b60; goto L_10032b64; goto L_10032b68; goto L_10032b6c; goto L_10032b70; goto L_10032b74; goto L_10032b78; goto L_10032b7c; goto L_10032b80; goto L_10032b84; goto L_10032b88; goto L_10032b8c; goto L_10032b90; goto L_10032b94; goto L_10032b98; goto L_10032b9c; goto L_10032ba0; goto L_10032ba4; goto L_10032ba8; goto L_10032bac; goto L_10032bb0; goto L_10032bb4; goto L_10032bb8; goto L_10032bbc; goto L_10032bc0; goto L_10032bc4; goto L_10032bc8; goto L_10032bcc; goto L_10032bd0; goto L_10032bd4; goto L_10032bd8; goto L_10032bdc; goto L_10032be0; goto L_10032be4; goto L_10032be8; goto L_10032bec; goto L_10032bf0; goto L_10032bf4; goto L_10032bf8; goto L_10032bfc; goto L_10032c00; goto L_10032c04; goto L_10032c08; goto L_10032c0c; goto L_10032c10; goto L_10032c14; goto L_10032c18; goto L_10032c1c; goto L_10032c20; goto L_10032c24; goto L_10032c28; goto L_10032c2c; goto L_10032c30; goto L_10032c34; goto L_10032c38; goto L_10032c3c; goto L_10032c40; goto L_10032c44; goto L_10032c48; goto L_10032c4c; goto L_10032c50; goto L_10032c54; goto L_10032c58; goto L_10032c5c; goto L_10032c60; goto L_10032c64; goto L_10032c68; goto L_10032c6c; goto L_10032c70; goto L_10032c74; goto L_10032c78; goto L_10032c7c; goto L_10032c80; goto L_10032c84; }
98755: L_10032aa4:
98756:     c->r[13] -= 16u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[14]); /* push {r4, r5, r6, lr} */
98757: L_10032aa8:
98758:     c->r[13] = c->r[13] - 0x00000018u; /* sub sp, sp, #24 */
98759: L_10032aac:
98760:     c->r[4] = c->r[0]; /* mov r4, r0 */
98761: L_10032ab0:
98762:     c->r[2] = ngage_r32(c, (c->r[4] + 152u)); /* ldr r2, [r4, #0x98] */
98763: L_10032ab4:
98764:     c->r[6] = c->r[1]; /* mov r6, r1 */
98765: L_10032ab8:
98766:     ngage_add_flags(c, c->r[2], 0x00000001u, 0); /* cmn r2, #1 */
98767: L_10032abc:
98768:     if (ngage_zf(c)) { goto L_10032b28; } /* beq 0x32b28 <shadowkey_code+0x32b28> */
98769: L_10032ac0:
98770:     c->r[5] = ngage_r32(c, (c->r[4] + 112u)); /* ldr r5, [r4, #0x70] */
98771: L_10032ac4:
98772:     c->r[3] = c->r[5] + 0x00004400u; /* add r3, r5, #17408 */
98773: L_10032ac8:
98774:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
98775: L_10032acc:
98776:     c->r[14] = ngage_r32(c, (c->r[3] + (c->r[2] << 2))); /* ldr lr, [r3, r2, lsl #2] */
98777: L_10032ad0:
98778:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
98779: L_10032ad4:
98780:     if (ngage_zf(c)) { goto L_10032b28; } /* beq 0x32b28 <shadowkey_code+0x32b28> */
98781: L_10032ad8:
98782:     c->r[1] = ngage_r32(c, (c->r[5] + 1152u)); /* ldr r1, [r5, #0x480] */
98783: L_10032adc:
98784:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
98785: L_10032ae0:
98786:     c->r[12] = 0x00000000u; /* mov r12, #0 */
98787: L_10032ae4:
98788:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
98789: L_10032ae8:
98790:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[12]); /* str r12, [sp, #0x8] */
98791: L_10032aec:
98792:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
98793: L_10032af0:
98794:     c->r[0] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r0, [lr, #0x1] */
98795: L_10032af4:
98796:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
98797: L_10032af8:
98798:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
98799: L_10032afc:
98800:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r2, [lr, #0x2] */
98801: L_10032b00:
98802:     c->r[0] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r0, [lr, #0x3] */
98803: L_10032b04:
98804:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
98805: L_10032b08:
98806:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
98807: L_10032b0c:
98808:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
98809: L_10032b10:
98810:     c->r[2] = c->r[4] + 0x00000078u; /* add r2, r4, #120 */
98811: L_10032b14:
98812:     { uint32_t _b = c->r[2]; c->r[2] = ngage_r32(c, _b); c->r[3] = ngage_r32(c, _b + 4u); } /* ldm r2, {r2, r3} */
98813: L_10032b18:
98814:     c->r[0] = c->r[5]; /* mov r0, r5 */
98815: L_10032b1c:
98816:     c->r[2] = c->r[2] + 0x0000002du; /* add r2, r2, #45 */
98817: L_10032b20:
98818:     c->r[3] = c->r[3] + 0x00000019u; /* add r3, r3, #25 */
98819: L_10032b24:
98820:     c->r[14] = 0x10032b28u; ngage_call(c, 0x1006a488u); goto L_10032b28; /* bl 0x6a488 <shadowkey_code+0x6a488> */
98821: L_10032b28:
98822:     c->r[2] = ngage_r32(c, (c->r[4] + 164u)); /* ldr r2, [r4, #0xa4] */
98823: L_10032b2c:
98824:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
98825: L_10032b30:
98826:     if ((ngage_zf(c) || ngage_nf(c) != ngage_vf(c))) { goto L_10032c2c; } /* ble 0x32c2c <shadowkey_code+0x32c2c> */
98827: L_10032b34:
98828:     c->r[3] = ngage_r32(c, (c->r[4] + 168u)); /* ldr r3, [r4, #0xa8] */
98829: L_10032b38:
98830:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
98831: L_10032b3c:
98832:     if ((ngage_zf(c) || ngage_nf(c) != ngage_vf(c))) { goto L_10032c2c; } /* ble 0x32c2c <shadowkey_code+0x32c2c> */
98833: L_10032b40:
98834:     c->r[0] = ngage_r32(c, (c->r[4] + 112u)); /* ldr r0, [r4, #0x70] */
98835: L_10032b44:
98836:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
98837: L_10032b48:
98838:     ngage_w32(c, c->r[13], (uint32_t)c->r[2]); /* str r2, [sp] */
98839: L_10032b4c:
98840:     c->r[12] = ngage_r32(c, (c->r[0] + 40u)); /* ldr r12, [r0, #0x28] */
98841: L_10032b50:
98842:     c->r[3] = ngage_r8(c, (c->r[12] + 12u)); /* ldrb r3, [r12, #0xc] */
98843: L_10032b54:
98844:     c->r[2] = ngage_r8(c, (c->r[12] + 13u)); /* ldrb r2, [r12, #0xd] */
98845: L_10032b58:
98846:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr r3, r3, r2, lsl #8 */
98847: L_10032b5c:
98848:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[3]); /* str r3, [sp, #0x4] */
98849: L_10032b60:
98850:     c->r[2] = c->r[4] + 0x00000078u; /* add r2, r4, #120 */
98851: L_10032b64:
98852:     { uint32_t _b = c->r[2]; c->r[2] = ngage_r32(c, _b); c->r[3] = ngage_r32(c, _b + 4u); } /* ldm r2, {r2, r3} */
98853: L_10032b68:
98854:     c->r[2] = c->r[2] - 0x00000005u; /* sub r2, r2, #5 */

## Call 15: caller=sub_10068e0c, lifted_line=201943
201873:     if (!ngage_zf(c)) { goto L_10068ec8; } /* bne 0x68ec8 <shadowkey_code+0x68ec8> */
201874: L_10068f54:
201875:     c->r[4] = c->r[4] + 0x00000001u; /* add r4, r4, #1 */
201876: L_10068f58:
201877:     ngage_sub_flags(c, c->r[4], 0x00000014u); /* cmp r4, #20 */
201878: L_10068f5c:
201879:     if ((ngage_zf(c) || ngage_nf(c) != ngage_vf(c))) { goto L_10068f38; } /* ble 0x68f38 <shadowkey_code+0x68f38> */
201880: L_10068f60:
201881:     goto L_100693a4; /* b 0x693a4 <shadowkey_code+0x693a4> */
201882: L_10068f64:
201883:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
201884: L_10068f68:
201885:     c->r[14] = 0x10068f6cu; ngage_call(c, 0x1001afa4u); goto L_10068f6c; /* bl 0x1afa4 <shadowkey_code+0x1afa4> */
201886: L_10068f6c:
201887:     c->r[3] = ngage_r32(c, (c->r[9] + 232u)); /* ldr r3, [r9, #0xe8] */
201888: L_10068f70:
201889:     ngage_sub_flags(c, c->r[0], c->r[3]); /* cmp r0, r3 */
201890: L_10068f74:
201891:     if ((ngage_cf(c) && !ngage_zf(c))) { c->r[3] = 0x00000000u; } /* movhi r3, #0 */
201892: L_10068f78:
201893:     if ((!ngage_cf(c) || ngage_zf(c))) { c->r[3] = c->r[3] - c->r[0]; } /* rsbls r3, r0, r3 */
201894: L_10068f7c:
201895:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
201896: L_10068f80:
201897:     c->r[3] = ngage_r32(c, (c->r[9] + 232u)); /* ldr r3, [r9, #0xe8] */
201898: L_10068f84:
201899:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
201900: L_10068f88:
201901:     if ((ngage_zf(c) || ngage_nf(c) != ngage_vf(c))) { goto L_10069984; } /* ble 0x69984 <shadowkey_code+0x69984> */
201902: L_10068f8c:
201903:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
201904: L_10068f90:
201905:     c->r[3] = 0x00004700u; /* mov r3, #18176 */
201906: L_10068f94:
201907:     c->r[3] = c->r[3] + 0x000000c4u; /* add r3, r3, #196 */
201908: L_10068f98:
201909:     c->r[14] = ngage_r32(c, (c->r[0] + c->r[3])); /* ldr lr, [r0, r3] */
201910: L_10068f9c:
201911:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
201912: L_10068fa0:
201913:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
201914: L_10068fa4:
201915:     c->r[4] = 0x00000000u; /* mov r4, #0 */
201916: L_10068fa8:
201917:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[4]); /* str r4, [sp, #0x4] */
201918: L_10068fac:
201919:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[4]); /* str r4, [sp, #0x8] */
201920: L_10068fb0:
201921:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
201922: L_10068fb4:
201923:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
201924: L_10068fb8:
201925:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
201926: L_10068fbc:
201927:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
201928: L_10068fc0:
201929:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r2, [lr, #0x2] */
201930: L_10068fc4:
201931:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
201932: L_10068fc8:
201933:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r2, r2, r12, lsl #8 */
201934: L_10068fcc:
201935:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
201936: L_10068fd0:
201937:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[4]); /* str r4, [sp, #0x14] */
201938: L_10068fd4:
201939:     c->r[3] = c->r[4]; /* mov r3, r4 */
201940: L_10068fd8:
201941:     c->r[2] = c->r[4]; /* mov r2, r4 */
201942: L_10068fdc:
201943:     c->r[14] = 0x10068fe0u; ngage_call(c, 0x1006a488u); goto L_10068fe0; /* bl 0x6a488 <shadowkey_code+0x6a488> */
201944: L_10068fe0:
201945:     c->r[12] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r12, [r9, #0x14] */
201946: L_10068fe4:
201947:     c->r[0] = ngage_r32(c, (c->r[12] + 1468u)); /* ldr r0, [r12, #0x5bc] */
201948: L_10068fe8:
201949:     c->r[7] = 0x00014800u; /* mov r7, #83968 */
201950: L_10068fec:
201951:     c->r[7] = c->r[7] + 0x0000023cu; /* add r7, r7, #572 */
201952: L_10068ff0:
201953:     c->r[2] = ngage_r32(c, (c->r[12] + c->r[7])); /* ldr r2, [r12, r7] */
201954: L_10068ff4:
201955:     c->r[6] = 0x00003440u; /* mov r6, #13376 */
201956: L_10068ff8:
201957:     c->r[3] = c->r[6] + 0x00000024u; /* add r3, r6, #36 */
201958: L_10068ffc:
201959:     c->r[1] = ngage_r32(c, (c->r[2] + c->r[3])); /* ldr r1, [r2, r3] */
201960: L_10069000:
201961:     ngage_w32(c, c->r[13], (uint32_t)c->r[4]); /* str r4, [sp] */
201962: L_10069004:
201963:     c->r[8] = 0x00000001u; /* mov r8, #1 */
201964: L_10069008:
201965:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[8]); /* str r8, [sp, #0x4] */
201966: L_1006900c:
201967:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[4]); /* str r4, [sp, #0x8] */
201968: L_10069010:
201969:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[4]); /* str r4, [sp, #0xc] */
201970: L_10069014:
201971:     c->r[5] = 0x00000880u; /* mov r5, #2176 */
201972: L_10069018:
201973:     c->r[5] = c->r[5] + 0x00000008u; /* add r5, r5, #8 */
201974: L_1006901c:
201975:     c->r[2] = 0x0000006eu; /* mov r2, #110 */
201976: L_10069020:
201977:     c->r[3] = c->r[5]; /* mov r3, r5 */

## Call 16: caller=sub_10068e0c, lifted_line=202281
202211:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[3]); /* str r3, [sp, #0x18] */
202212: L_100691f8:
202213:     c->r[2] = 0x000000aau; /* mov r2, #170 */
202214: L_100691fc:
202215:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
202216: L_10069200:
202217:     c->r[4] = 0x00000000u; /* mov r4, #0 */
202218: L_10069204:
202219:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[4]); /* str r4, [sp, #0x14] */
202220: L_10069208:
202221:     ngage_w32(c, (c->r[13] + 28u), (uint32_t)c->r[4]); /* str r4, [sp, #0x1c] */
202222: L_1006920c:
202223:     c->r[3] = 0x00000019u; /* mov r3, #25 */
202224: L_10069210:
202225:     ngage_w32(c, (c->r[13] + 36u), (uint32_t)c->r[3]); /* str r3, [sp, #0x24] */
202226: L_10069214:
202227:     ngage_w32(c, (c->r[13] + 32u), (uint32_t)c->r[4]); /* str r4, [sp, #0x20] */
202228: L_10069218:
202229:     c->r[2] = 0x0000000eu; /* mov r2, #14 */
202230: L_1006921c:
202231:     c->r[3] = 0x00000073u; /* mov r3, #115 */
202232: L_10069220:
202233:     c->r[14] = 0x10069224u; ngage_call(c, 0x100231b4u); goto L_10069224; /* bl 0x231b4 <shadowkey_code+0x231b4> */
202234: L_10069224:
202235:     c->r[14] = ngage_r32(c, (c->r[9] + 20u)); /* ldr lr, [r9, #0x14] */
202236: L_10069228:
202237:     c->r[2] = c->r[5] + 0x000000c9u; /* add r2, r5, #201 */
202238: L_1006922c:
202239:     c->r[3] = c->r[14] + 0x00004400u; /* add r3, lr, #17408 */
202240: L_10069230:
202241:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
202242: L_10069234:
202243:     c->r[12] = ngage_r32(c, (c->r[3] + (c->r[2] << 2))); /* ldr r12, [r3, r2, lsl #2] */
202244: L_10069238:
202245:     ngage_sub_flags(c, c->r[12], c->r[4]); /* cmp r12, r4 */
202246: L_1006923c:
202247:     if (ngage_zf(c)) { goto L_10069b00; } /* beq 0x69b00 <shadowkey_code+0x69b00> */
202248: L_10069240:
202249:     c->r[1] = ngage_r32(c, (c->r[14] + 1152u)); /* ldr r1, [lr, #0x480] */
202250: L_10069244:
202251:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
202252: L_10069248:
202253:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[4]); /* str r4, [sp, #0x4] */
202254: L_1006924c:
202255:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[4]); /* str r4, [sp, #0x8] */
202256: L_10069250:
202257:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
202258: L_10069254:
202259:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
202260: L_10069258:
202261:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
202262: L_1006925c:
202263:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
202264: L_10069260:
202265:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
202266: L_10069264:
202267:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
202268: L_10069268:
202269:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
202270: L_1006926c:
202271:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
202272: L_10069270:
202273:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[4]); /* str r4, [sp, #0x14] */
202274: L_10069274:
202275:     c->r[3] = 0x00000005u; /* mov r3, #5 */
202276: L_10069278:
202277:     c->r[0] = c->r[14]; /* mov r0, lr */
202278: L_1006927c:
202279:     c->r[2] = 0x0000000eu; /* mov r2, #14 */
202280: L_10069280:
202281:     c->r[14] = 0x10069284u; ngage_call(c, 0x1006a488u); goto L_10069284; /* bl 0x6a488 <shadowkey_code+0x6a488> */
202282: L_10069284:
202283:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */
202284: L_10069288:
202285:     c->r[4] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r4, [r9, #0x14] */
202286: L_1006928c:
202287:     c->r[3] = 0x00004700u; /* mov r3, #18176 */
202288: L_10069290:
202289:     c->r[3] = c->r[3] + 0x00000018u; /* add r3, r3, #24 */
202290: L_10069294:
202291:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
202292: L_10069298:
202293:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
202294: L_1006929c:
202295:     if (ngage_zf(c)) { goto L_100692e4; } /* beq 0x692e4 <shadowkey_code+0x692e4> */
202296: L_100692a0:
202297:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
202298: L_100692a4:
202299:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
202300: L_100692a8:
202301:     c->r[2] = 0x00000000u; /* mov r2, #0 */
202302: L_100692ac:
202303:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
202304: L_100692b0:
202305:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
202306: L_100692b4:
202307:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
202308: L_100692b8:
202309:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
202310: L_100692bc:
202311:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
202312: L_100692c0:
202313:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
202314: L_100692c4:
202315:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */

## Call 17: caller=sub_10068e0c, lifted_line=202329
202259:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
202260: L_10069258:
202261:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
202262: L_1006925c:
202263:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
202264: L_10069260:
202265:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
202266: L_10069264:
202267:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
202268: L_10069268:
202269:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
202270: L_1006926c:
202271:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
202272: L_10069270:
202273:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[4]); /* str r4, [sp, #0x14] */
202274: L_10069274:
202275:     c->r[3] = 0x00000005u; /* mov r3, #5 */
202276: L_10069278:
202277:     c->r[0] = c->r[14]; /* mov r0, lr */
202278: L_1006927c:
202279:     c->r[2] = 0x0000000eu; /* mov r2, #14 */
202280: L_10069280:
202281:     c->r[14] = 0x10069284u; ngage_call(c, 0x1006a488u); goto L_10069284; /* bl 0x6a488 <shadowkey_code+0x6a488> */
202282: L_10069284:
202283:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */
202284: L_10069288:
202285:     c->r[4] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r4, [r9, #0x14] */
202286: L_1006928c:
202287:     c->r[3] = 0x00004700u; /* mov r3, #18176 */
202288: L_10069290:
202289:     c->r[3] = c->r[3] + 0x00000018u; /* add r3, r3, #24 */
202290: L_10069294:
202291:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
202292: L_10069298:
202293:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
202294: L_1006929c:
202295:     if (ngage_zf(c)) { goto L_100692e4; } /* beq 0x692e4 <shadowkey_code+0x692e4> */
202296: L_100692a0:
202297:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
202298: L_100692a4:
202299:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
202300: L_100692a8:
202301:     c->r[2] = 0x00000000u; /* mov r2, #0 */
202302: L_100692ac:
202303:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
202304: L_100692b0:
202305:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
202306: L_100692b4:
202307:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
202308: L_100692b8:
202309:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
202310: L_100692bc:
202311:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
202312: L_100692c0:
202313:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
202314: L_100692c4:
202315:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
202316: L_100692c8:
202317:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
202318: L_100692cc:
202319:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
202320: L_100692d0:
202321:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
202322: L_100692d4:
202323:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
202324: L_100692d8:
202325:     c->r[3] = c->r[2]; /* mov r3, r2 */
202326: L_100692dc:
202327:     c->r[0] = c->r[4]; /* mov r0, r4 */
202328: L_100692e0:
202329:     c->r[14] = 0x100692e4u; ngage_call(c, 0x1006a488u); goto L_100692e4; /* bl 0x6a488 <shadowkey_code+0x6a488> */
202330: L_100692e4:
202331:     c->r[1] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r1, [r9, #0x14] */
202332: L_100692e8:
202333:     c->r[0] = ngage_r32(c, (c->r[1] + 8u)); /* ldr r0, [r1, #0x8] */
202334: L_100692ec:
202335:     c->r[3] = 0x00014800u; /* mov r3, #83968 */
202336: L_100692f0:
202337:     c->r[3] = c->r[3] + 0x0000023cu; /* add r3, r3, #572 */
202338: L_100692f4:
202339:     c->r[12] = ngage_r32(c, (c->r[1] + c->r[3])); /* ldr r12, [r1, r3] */
202340: L_100692f8:
202341:     c->r[2] = 0x00003f80u; /* mov r2, #16256 */
202342: L_100692fc:
202343:     c->r[2] = c->r[2] + 0x00000028u; /* add r2, r2, #40 */
202344: L_10069300:
202345:     c->r[1] = ngage_r32(c, (c->r[12] + c->r[2])); /* ldr r1, [r12, r2] */
202346: L_10069304:
202347:     c->r[3] = 0x000000b0u; /* mov r3, #176 */
202348: L_10069308:
202349:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
202350: L_1006930c:
202351:     c->r[2] = 0x000000d0u; /* mov r2, #208 */
202352: L_10069310:
202353:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
202354: L_10069314:
202355:     c->r[3] = 0x000000ffu; /* mov r3, #255 */
202356: L_10069318:
202357:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[3]); /* str r3, [sp, #0x8] */
202358: L_1006931c:
202359:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
202360: L_10069320:
202361:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[3]); /* str r3, [sp, #0x10] */
202362: L_10069324:
202363:     c->r[12] = 0x00000019u; /* mov r12, #25 */

## Call 18: caller=sub_10068e0c, lifted_line=202471
202401:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
202402: L_10069374:
202403:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { goto L_100693a4; } /* bgt 0x693a4 <shadowkey_code+0x693a4> */
202404: L_10069378:
202405:     c->r[1] = ngage_r32(c, (c->r[9] + 120u)); /* ldr r1, [r9, #0x78] */
202406: L_1006937c:
202407:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
202408: L_10069380:
202409:     c->r[1] = c->r[1] + 0x00000001u; /* add r1, r1, #1 */
202410: L_10069384:
202411:     ngage_sub_flags(c, c->r[1], 0x0000001du); /* cmp r1, #29 */
202412: L_10069388:
202413:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { c->r[1] = 0x0000000bu; } /* movgt r1, #11 */
202414: L_1006938c:
202415:     ngage_sub_flags(c, c->r[1], 0x00000001u); /* cmp r1, #1 */
202416: L_10069390:
202417:     if (!ngage_zf(c)) { c->r[2] = 0x00000000u; } /* movne r2, #0 */
202418: L_10069394:
202419:     if (ngage_zf(c)) { c->r[2] = 0x00000001u; } /* moveq r2, #1 */
202420: L_10069398:
202421:     c->r[14] = 0x1006939cu; ngage_call(c, 0x1001b788u); goto L_1006939c; /* bl 0x1b788 <shadowkey_code+0x1b788> */
202422: L_1006939c:
202423:     c->r[3] = 0x00000500u; /* mov r3, #1280 */
202424: L_100693a0:
202425:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
202426: L_100693a4:
202427:     c->r[2] = ngage_r32(c, (c->r[9] + 120u)); /* ldr r2, [r9, #0x78] */
202428: L_100693a8:
202429:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
202430: L_100693ac:
202431:     c->r[2] = c->r[2] + 0x00000100u; /* add r2, r2, #256 */
202432: L_100693b0:
202433:     c->r[2] = c->r[2] + 0x00000001u; /* add r2, r2, #1 */
202434: L_100693b4:
202435:     c->r[3] = c->r[0] + 0x00004400u; /* add r3, r0, #17408 */
202436: L_100693b8:
202437:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
202438: L_100693bc:
202439:     c->r[4] = ngage_r32(c, (c->r[3] + (c->r[2] << 2))); /* ldr r4, [r3, r2, lsl #2] */
202440: L_100693c0:
202441:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
202442: L_100693c4:
202443:     ngage_w32(c, c->r[13], (uint32_t)c->r[4]); /* str r4, [sp] */
202444: L_100693c8:
202445:     c->r[2] = 0x00000000u; /* mov r2, #0 */
202446: L_100693cc:
202447:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
202448: L_100693d0:
202449:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
202450: L_100693d4:
202451:     c->r[3] = ngage_r8(c, c->r[4]); /* ldrb r3, [r4] */
202452: L_100693d8:
202453:     c->r[14] = ngage_r8(c, (c->r[4] + 1u)); /* ldrb lr, [r4, #0x1] */
202454: L_100693dc:
202455:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[14], 0u, 8u, 1u, 0u); /* orr r3, r3, lr, lsl #8 */
202456: L_100693e0:
202457:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
202458: L_100693e4:
202459:     c->r[12] = ngage_r8(c, (c->r[4] + 2u)); /* ldrb r12, [r4, #0x2] */
202460: L_100693e8:
202461:     c->r[14] = ngage_r8(c, (c->r[4] + 3u)); /* ldrb lr, [r4, #0x3] */
202462: L_100693ec:
202463:     c->r[12] = c->r[12] | shadowkey_arm_shift_operand(c, c->r[14], 0u, 8u, 1u, 0u); /* orr r12, r12, lr, lsl #8 */
202464: L_100693f0:
202465:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[12]); /* str r12, [sp, #0x10] */
202466: L_100693f4:
202467:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
202468: L_100693f8:
202469:     c->r[3] = c->r[2]; /* mov r3, r2 */
202470: L_100693fc:
202471:     c->r[14] = 0x10069400u; ngage_call(c, 0x1006a488u); goto L_10069400; /* bl 0x6a488 <shadowkey_code+0x6a488> */
202472: L_10069400:
202473:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */
202474: L_10069404:
202475:     c->r[3] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r3, [r9, #0x14] */
202476: L_10069408:
202477:     c->r[0] = ngage_r32(c, (c->r[3] + 8u)); /* ldr r0, [r3, #0x8] */
202478: L_1006940c:
202479:     c->r[2] = 0x0000014cu; /* mov r2, #332 */
202480: L_10069410:
202481:     c->r[1] = ngage_r8(c, (c->r[0] + c->r[2])); /* ldrb r1, [r0, r2] */
202482: L_10069414:
202483:     ngage_sub_flags(c, c->r[1], 0x00000000u); /* cmp r1, #0 */
202484: L_10069418:
202485:     if (!ngage_zf(c)) { goto L_10069b00; } /* bne 0x69b00 <shadowkey_code+0x69b00> */
202486: L_1006941c:
202487:     c->r[0] = c->r[9]; /* mov r0, r9 */
202488: L_10069420:
202489:     c->r[14] = 0x10069424u; ngage_call(c, 0x1006b3fcu); goto L_10069424; /* bl 0x6b3fc <shadowkey_code+0x6b3fc> */
202490: L_10069424:
202491:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */
202492: L_10069428:
202493:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
202494: L_1006942c:
202495:     c->r[14] = 0x10069430u; ngage_call(c, 0x1001afa4u); goto L_10069430; /* bl 0x1afa4 <shadowkey_code+0x1afa4> */
202496: L_10069430:
202497:     c->r[3] = ngage_r32(c, (c->r[9] + 232u)); /* ldr r3, [r9, #0xe8] */
202498: L_10069434:
202499:     c->r[3] = c->r[3] - c->r[0]; /* rsb r3, r0, r3 */
202500: L_10069438:
202501:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
202502: L_1006943c:
202503:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
202504: L_10069440:
202505:     if ((ngage_zf(c) || ngage_nf(c) != ngage_vf(c))) { goto L_10069460; } /* ble 0x69460 <shadowkey_code+0x69460> */

## Call 19: caller=sub_10068e0c, lifted_line=202579
202509:     c->r[1] = 0x0000000fu; /* mov r1, #15 */
202510: L_1006944c:
202511:     c->r[0] = c->r[0] + 0x00000480u; /* add r0, r0, #1152 */
202512: L_10069450:
202513:     c->r[0] = c->r[0] + 0x00000008u; /* add r0, r0, #8 */
202514: L_10069454:
202515:     c->r[14] = 0x10069458u; ngage_call(c, 0x1001a724u); goto L_10069458; /* bl 0x1a724 <shadowkey_code+0x1a724> */
202516: L_10069458:
202517:     c->r[5] = c->r[0] & 0x000000ffu; ngage_set_nz(c, c->r[5]); /* ands r5, r0, #255 */
202518: L_1006945c:
202519:     if (ngage_zf(c)) { goto L_1006947c; } /* beq 0x6947c <shadowkey_code+0x6947c> */
202520: L_10069460:
202521:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
202522: L_10069464:
202523:     c->r[1] = 0x0000000cu; /* mov r1, #12 */
202524: L_10069468:
202525:     c->r[2] = 0x00000000u; /* mov r2, #0 */
202526: L_1006946c:
202527:     c->r[14] = 0x10069470u; ngage_call(c, 0x1001b788u); goto L_10069470; /* bl 0x1b788 <shadowkey_code+0x1b788> */
202528: L_10069470:
202529:     c->r[3] = 0x00000500u; /* mov r3, #1280 */
202530: L_10069474:
202531:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
202532: L_10069478:
202533:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */
202534: L_1006947c:
202535:     c->r[14] = ngage_r32(c, (c->r[9] + 20u)); /* ldr lr, [r9, #0x14] */
202536: L_10069480:
202537:     c->r[3] = 0x00004400u; /* mov r3, #17408 */
202538: L_10069484:
202539:     c->r[3] = c->r[3] + 0x000000b0u; /* add r3, r3, #176 */
202540: L_10069488:
202541:     c->r[12] = ngage_r32(c, (c->r[14] + c->r[3])); /* ldr r12, [lr, r3] */
202542: L_1006948c:
202543:     ngage_sub_flags(c, c->r[12], 0x00000000u); /* cmp r12, #0 */
202544: L_10069490:
202545:     if (ngage_zf(c)) { goto L_100694d8; } /* beq 0x694d8 <shadowkey_code+0x694d8> */
202546: L_10069494:
202547:     c->r[1] = ngage_r32(c, (c->r[14] + 1152u)); /* ldr r1, [lr, #0x480] */
202548: L_10069498:
202549:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
202550: L_1006949c:
202551:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[5]); /* str r5, [sp, #0x4] */
202552: L_100694a0:
202553:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
202554: L_100694a4:
202555:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
202556: L_100694a8:
202557:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
202558: L_100694ac:
202559:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
202560: L_100694b0:
202561:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
202562: L_100694b4:
202563:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
202564: L_100694b8:
202565:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
202566: L_100694bc:
202567:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
202568: L_100694c0:
202569:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
202570: L_100694c4:
202571:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[5]); /* str r5, [sp, #0x14] */
202572: L_100694c8:
202573:     c->r[3] = c->r[5]; /* mov r3, r5 */
202574: L_100694cc:
202575:     c->r[0] = c->r[14]; /* mov r0, lr */
202576: L_100694d0:
202577:     c->r[2] = c->r[5]; /* mov r2, r5 */
202578: L_100694d4:
202579:     c->r[14] = 0x100694d8u; ngage_call(c, 0x1006a488u); goto L_100694d8; /* bl 0x6a488 <shadowkey_code+0x6a488> */
202580: L_100694d8:
202581:     c->r[2] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r2, [r9, #0x14] */
202582: L_100694dc:
202583:     c->r[4] = 0x00014800u; /* mov r4, #83968 */
202584: L_100694e0:
202585:     c->r[10] = c->r[4]; /* mov r10, r4 */
202586: L_100694e4:
202587:     c->r[10] = c->r[10] + 0x0000023cu; /* add r10, r10, #572 */
202588: L_100694e8:
202589:     c->r[3] = ngage_r32(c, (c->r[2] + c->r[10])); /* ldr r3, [r2, r10] */
202590: L_100694ec:
202591:     c->r[0] = ngage_r32(c, (c->r[2] + 1468u)); /* ldr r0, [r2, #0x5bc] */
202592: L_100694f0:
202593:     c->r[1] = ngage_r32(c, (c->r[3] + 232u)); /* ldr r1, [r3, #0xe8] */
202594: L_100694f4:
202595:     c->r[8] = 0x00000001u; /* mov r8, #1 */
202596: L_100694f8:
202597:     ngage_w32(c, c->r[13], (uint32_t)c->r[8]); /* str r8, [sp] */
202598: L_100694fc:
202599:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[5]); /* str r5, [sp, #0x4] */
202600: L_10069500:
202601:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
202602: L_10069504:
202603:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[5]); /* str r5, [sp, #0xc] */
202604: L_10069508:
202605:     c->r[12] = ngage_r8(c, (c->r[9] + 8u)); /* ldrb r12, [r9, #0x8] */
202606: L_1006950c:
202607:     c->r[7] = c->r[9] + 0x00000008u; /* add r7, r9, #8 */
202608: L_10069510:
202609:     c->r[3] = ngage_r8(c, (c->r[7] + 1u)); /* ldrb r3, [r7, #0x1] */
202610: L_10069514:
202611:     c->r[6] = 0x00000032u; /* mov r6, #50 */
202612: L_10069518:
202613:     c->r[2] = c->r[6]; /* mov r2, r6 */

## Call 20: caller=sub_10068e0c, lifted_line=203031
202961:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
202962: L_100697dc:
202963:     c->r[14] = 0x100697e0u; ngage_call(c, 0x1001afa4u); goto L_100697e0; /* bl 0x1afa4 <shadowkey_code+0x1afa4> */
202964: L_100697e0:
202965:     c->r[3] = ngage_r32(c, (c->r[9] + 232u)); /* ldr r3, [r9, #0xe8] */
202966: L_100697e4:
202967:     c->r[3] = c->r[3] - c->r[0]; /* rsb r3, r0, r3 */
202968: L_100697e8:
202969:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
202970: L_100697ec:
202971:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
202972: L_100697f0:
202973:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { goto L_1006980c; } /* bgt 0x6980c <shadowkey_code+0x6980c> */
202974: L_100697f4:
202975:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
202976: L_100697f8:
202977:     c->r[2] = ngage_r32(c, (c->r[0] + 1448u)); /* ldr r2, [r0, #0x5a8] */
202978: L_100697fc:
202979:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
202980: L_10069800:
202981:     if (!ngage_zf(c)) { goto L_10069b00; } /* bne 0x69b00 <shadowkey_code+0x69b00> */
202982: L_10069804:
202983:     c->r[1] = 0x00000025u; /* mov r1, #37 */
202984: L_10069808:
202985:     goto L_10069998; /* b 0x69998 <shadowkey_code+0x69998> */
202986: L_1006980c:
202987:     c->r[4] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r4, [r9, #0x14] */
202988: L_10069810:
202989:     c->r[3] = 0x00004800u; /* mov r3, #18432 */
202990: L_10069814:
202991:     c->r[3] = c->r[3] + 0x00000038u; /* add r3, r3, #56 */
202992: L_10069818:
202993:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
202994: L_1006981c:
202995:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
202996: L_10069820:
202997:     if (ngage_zf(c)) { goto L_10069868; } /* beq 0x69868 <shadowkey_code+0x69868> */
202998: L_10069824:
202999:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
203000: L_10069828:
203001:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
203002: L_1006982c:
203003:     c->r[2] = 0x00000000u; /* mov r2, #0 */
203004: L_10069830:
203005:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
203006: L_10069834:
203007:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
203008: L_10069838:
203009:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
203010: L_1006983c:
203011:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
203012: L_10069840:
203013:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
203014: L_10069844:
203015:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
203016: L_10069848:
203017:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
203018: L_1006984c:
203019:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
203020: L_10069850:
203021:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
203022: L_10069854:
203023:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
203024: L_10069858:
203025:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
203026: L_1006985c:
203027:     c->r[3] = c->r[2]; /* mov r3, r2 */
203028: L_10069860:
203029:     c->r[0] = c->r[4]; /* mov r0, r4 */
203030: L_10069864:
203031:     c->r[14] = 0x10069868u; ngage_call(c, 0x1006a488u); goto L_10069868; /* bl 0x6a488 <shadowkey_code+0x6a488> */
203032: L_10069868:
203033:     c->r[1] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r1, [r9, #0x14] */
203034: L_1006986c:
203035:     c->r[0] = ngage_r32(c, (c->r[1] + 8u)); /* ldr r0, [r1, #0x8] */
203036: L_10069870:
203037:     c->r[3] = 0x00014800u; /* mov r3, #83968 */
203038: L_10069874:
203039:     c->r[3] = c->r[3] + 0x0000023cu; /* add r3, r3, #572 */
203040: L_10069878:
203041:     c->r[12] = ngage_r32(c, (c->r[1] + c->r[3])); /* ldr r12, [r1, r3] */
203042: L_1006987c:
203043:     c->r[2] = 0x00003f80u; /* mov r2, #16256 */
203044: L_10069880:
203045:     c->r[2] = c->r[2] + 0x00000020u; /* add r2, r2, #32 */
203046: L_10069884:
203047:     c->r[1] = ngage_r32(c, (c->r[12] + c->r[2])); /* ldr r1, [r12, r2] */
203048: L_10069888:
203049:     c->r[3] = 0x000000b0u; /* mov r3, #176 */
203050: L_1006988c:
203051:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
203052: L_10069890:
203053:     c->r[2] = 0x0000004eu; /* mov r2, #78 */
203054: L_10069894:
203055:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
203056: L_10069898:
203057:     c->r[3] = 0x000000ffu; /* mov r3, #255 */
203058: L_1006989c:
203059:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[3]); /* str r3, [sp, #0x8] */
203060: L_100698a0:
203061:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
203062: L_100698a4:
203063:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[3]); /* str r3, [sp, #0x10] */
203064: L_100698a8:
203065:     c->r[12] = 0x00000019u; /* mov r12, #25 */

## Call 21: caller=sub_10068e0c, lifted_line=203157
203087:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
203088: L_100698d8:
203089:     c->r[14] = 0x100698dcu; ngage_call(c, 0x1001afa4u); goto L_100698dc; /* bl 0x1afa4 <shadowkey_code+0x1afa4> */
203090: L_100698dc:
203091:     c->r[3] = ngage_r32(c, (c->r[9] + 232u)); /* ldr r3, [r9, #0xe8] */
203092: L_100698e0:
203093:     c->r[3] = c->r[3] - c->r[0]; /* rsb r3, r0, r3 */
203094: L_100698e4:
203095:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
203096: L_100698e8:
203097:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
203098: L_100698ec:
203099:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { goto L_10069908; } /* bgt 0x69908 <shadowkey_code+0x69908> */
203100: L_100698f0:
203101:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
203102: L_100698f4:
203103:     c->r[2] = ngage_r32(c, (c->r[0] + 1448u)); /* ldr r2, [r0, #0x5a8] */
203104: L_100698f8:
203105:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
203106: L_100698fc:
203107:     if (!ngage_zf(c)) { goto L_10069b00; } /* bne 0x69b00 <shadowkey_code+0x69b00> */
203108: L_10069900:
203109:     c->r[1] = 0x00000027u; /* mov r1, #39 */
203110: L_10069904:
203111:     goto L_10069998; /* b 0x69998 <shadowkey_code+0x69998> */
203112: L_10069908:
203113:     c->r[4] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r4, [r9, #0x14] */
203114: L_1006990c:
203115:     c->r[3] = 0x00004800u; /* mov r3, #18432 */
203116: L_10069910:
203117:     c->r[3] = c->r[3] + 0x00000034u; /* add r3, r3, #52 */
203118: L_10069914:
203119:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
203120: L_10069918:
203121:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
203122: L_1006991c:
203123:     if (ngage_zf(c)) { goto L_10069b00; } /* beq 0x69b00 <shadowkey_code+0x69b00> */
203124: L_10069920:
203125:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
203126: L_10069924:
203127:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
203128: L_10069928:
203129:     c->r[2] = 0x00000000u; /* mov r2, #0 */
203130: L_1006992c:
203131:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
203132: L_10069930:
203133:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
203134: L_10069934:
203135:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
203136: L_10069938:
203137:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
203138: L_1006993c:
203139:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
203140: L_10069940:
203141:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
203142: L_10069944:
203143:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
203144: L_10069948:
203145:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
203146: L_1006994c:
203147:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
203148: L_10069950:
203149:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
203150: L_10069954:
203151:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
203152: L_10069958:
203153:     c->r[3] = c->r[2]; /* mov r3, r2 */
203154: L_1006995c:
203155:     c->r[0] = c->r[4]; /* mov r0, r4 */
203156: L_10069960:
203157:     c->r[14] = 0x10069964u; ngage_call(c, 0x1006a488u); goto L_10069964; /* bl 0x6a488 <shadowkey_code+0x6a488> */
203158: L_10069964:
203159:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */
203160: L_10069968:
203161:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
203162: L_1006996c:
203163:     c->r[14] = 0x10069970u; ngage_call(c, 0x1001afa4u); goto L_10069970; /* bl 0x1afa4 <shadowkey_code+0x1afa4> */
203164: L_10069970:
203165:     c->r[3] = ngage_r32(c, (c->r[9] + 232u)); /* ldr r3, [r9, #0xe8] */
203166: L_10069974:
203167:     c->r[3] = c->r[3] - c->r[0]; /* rsb r3, r0, r3 */
203168: L_10069978:
203169:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
203170: L_1006997c:
203171:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
203172: L_10069980:
203173:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { goto L_100699a8; } /* bgt 0x699a8 <shadowkey_code+0x699a8> */
203174: L_10069984:
203175:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
203176: L_10069988:
203177:     c->r[2] = ngage_r32(c, (c->r[0] + 1448u)); /* ldr r2, [r0, #0x5a8] */
203178: L_1006998c:
203179:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
203180: L_10069990:
203181:     if (!ngage_zf(c)) { goto L_10069b00; } /* bne 0x69b00 <shadowkey_code+0x69b00> */
203182: L_10069994:
203183:     c->r[1] = 0x00000006u; /* mov r1, #6 */
203184: L_10069998:
203185:     c->r[14] = 0x1006999cu; ngage_call(c, 0x1001b788u); goto L_1006999c; /* bl 0x1b788 <shadowkey_code+0x1b788> */
203186: L_1006999c:
203187:     c->r[3] = 0x00000300u; /* mov r3, #768 */
203188: L_100699a0:
203189:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
203190: L_100699a4:
203191:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */

## Call 22: caller=sub_10068e0c, lifted_line=203237
203167:     c->r[3] = c->r[3] - c->r[0]; /* rsb r3, r0, r3 */
203168: L_10069978:
203169:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
203170: L_1006997c:
203171:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
203172: L_10069980:
203173:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { goto L_100699a8; } /* bgt 0x699a8 <shadowkey_code+0x699a8> */
203174: L_10069984:
203175:     c->r[0] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r0, [r9, #0x14] */
203176: L_10069988:
203177:     c->r[2] = ngage_r32(c, (c->r[0] + 1448u)); /* ldr r2, [r0, #0x5a8] */
203178: L_1006998c:
203179:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
203180: L_10069990:
203181:     if (!ngage_zf(c)) { goto L_10069b00; } /* bne 0x69b00 <shadowkey_code+0x69b00> */
203182: L_10069994:
203183:     c->r[1] = 0x00000006u; /* mov r1, #6 */
203184: L_10069998:
203185:     c->r[14] = 0x1006999cu; ngage_call(c, 0x1001b788u); goto L_1006999c; /* bl 0x1b788 <shadowkey_code+0x1b788> */
203186: L_1006999c:
203187:     c->r[3] = 0x00000300u; /* mov r3, #768 */
203188: L_100699a0:
203189:     ngage_w32(c, (c->r[9] + 232u), (uint32_t)c->r[3]); /* str r3, [r9, #0xe8] */
203190: L_100699a4:
203191:     goto L_10069b00; /* b 0x69b00 <shadowkey_code+0x69b00> */
203192: L_100699a8:
203193:     c->r[4] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r4, [r9, #0x14] */
203194: L_100699ac:
203195:     c->r[3] = 0x00004800u; /* mov r3, #18432 */
203196: L_100699b0:
203197:     c->r[3] = c->r[3] + 0x0000003cu; /* add r3, r3, #60 */
203198: L_100699b4:
203199:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
203200: L_100699b8:
203201:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
203202: L_100699bc:
203203:     if (ngage_zf(c)) { goto L_10069a04; } /* beq 0x69a04 <shadowkey_code+0x69a04> */
203204: L_100699c0:
203205:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
203206: L_100699c4:
203207:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
203208: L_100699c8:
203209:     c->r[2] = 0x00000000u; /* mov r2, #0 */
203210: L_100699cc:
203211:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
203212: L_100699d0:
203213:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
203214: L_100699d4:
203215:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
203216: L_100699d8:
203217:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
203218: L_100699dc:
203219:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
203220: L_100699e0:
203221:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
203222: L_100699e4:
203223:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
203224: L_100699e8:
203225:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
203226: L_100699ec:
203227:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
203228: L_100699f0:
203229:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
203230: L_100699f4:
203231:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
203232: L_100699f8:
203233:     c->r[3] = c->r[2]; /* mov r3, r2 */
203234: L_100699fc:
203235:     c->r[0] = c->r[4]; /* mov r0, r4 */
203236: L_10069a00:
203237:     c->r[14] = 0x10069a04u; ngage_call(c, 0x1006a488u); goto L_10069a04; /* bl 0x6a488 <shadowkey_code+0x6a488> */
203238: L_10069a04:
203239:     c->r[2] = ngage_r32(c, (c->r[9] + 20u)); /* ldr r2, [r9, #0x14] */
203240: L_10069a08:
203241:     c->r[0] = ngage_r32(c, (c->r[2] + 8u)); /* ldr r0, [r2, #0x8] */
203242: L_10069a0c:
203243:     c->r[7] = 0x00014800u; /* mov r7, #83968 */
203244: L_10069a10:
203245:     c->r[7] = c->r[7] + 0x0000023cu; /* add r7, r7, #572 */
203246: L_10069a14:
203247:     c->r[12] = ngage_r32(c, (c->r[2] + c->r[7])); /* ldr r12, [r2, r7] */
203248: L_10069a18:
203249:     c->r[6] = 0x00003f80u; /* mov r6, #16256 */
203250: L_10069a1c:
203251:     c->r[3] = c->r[6] + 0x00000024u; /* add r3, r6, #36 */
203252: L_10069a20:
203253:     c->r[1] = ngage_r32(c, (c->r[12] + c->r[3])); /* ldr r1, [r12, r3] */
203254: L_10069a24:
203255:     c->r[10] = 0x000000b0u; /* mov r10, #176 */
203256: L_10069a28:
203257:     ngage_w32(c, c->r[13], (uint32_t)c->r[10]); /* str r10, [sp] */
203258: L_10069a2c:
203259:     c->r[3] = 0x0000004eu; /* mov r3, #78 */
203260: L_10069a30:
203261:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[3]); /* str r3, [sp, #0x4] */
203262: L_10069a34:
203263:     c->r[5] = 0x000000ffu; /* mov r5, #255 */
203264: L_10069a38:
203265:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
203266: L_10069a3c:
203267:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[5]); /* str r5, [sp, #0xc] */
203268: L_10069a40:
203269:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[5]); /* str r5, [sp, #0x10] */
203270: L_10069a44:
203271:     c->r[4] = 0x00000000u; /* mov r4, #0 */

## Call 23: caller=sub_1006ad18, lifted_line=205809
205739:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
205740: L_1006ae18:
205741:     if (ngage_zf(c)) { goto L_1006ae64; } /* beq 0x6ae64 <shadowkey_code+0x6ae64> */
205742: L_1006ae1c:
205743:     { uint32_t _b = c->r[13]; ngage_w32(c, _b, c->r[12]); ngage_w32(c, _b + 4u, c->r[14]); } /* stm sp, {r12, lr} */
205744: L_1006ae20:
205745:     c->r[2] = 0x00000000u; /* mov r2, #0 */
205746: L_1006ae24:
205747:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
205748: L_1006ae28:
205749:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[2]); /* str r2, [sp, #0xc] */
205750: L_1006ae2c:
205751:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
205752: L_1006ae30:
205753:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
205754: L_1006ae34:
205755:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
205756: L_1006ae38:
205757:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[3]); /* str r3, [sp, #0x10] */
205758: L_1006ae3c:
205759:     c->r[1] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r1, [r12, #0x2] */
205760: L_1006ae40:
205761:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
205762: L_1006ae44:
205763:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[2]); /* str r2, [sp, #0x18] */
205764: L_1006ae48:
205765:     c->r[1] = c->r[1] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r1, r1, r0, lsl #8 */
205766: L_1006ae4c:
205767:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[1]); /* str r1, [sp, #0x14] */
205768: L_1006ae50:
205769:     c->r[1] = ngage_r32(c, (c->r[7] + 1152u)); /* ldr r1, [r7, #0x480] */
205770: L_1006ae54:
205771:     c->r[3] = c->r[2]; /* mov r3, r2 */
205772: L_1006ae58:
205773:     c->r[0] = c->r[7]; /* mov r0, r7 */
205774: L_1006ae5c:
205775:     c->r[14] = 0x1006ae60u; ngage_call(c, 0x1006aae4u); goto L_1006ae60; /* bl 0x6aae4 <shadowkey_code+0x6aae4> */
205776: L_1006ae60:
205777:     goto L_1006aea4; /* b 0x6aea4 <shadowkey_code+0x6aea4> */
205778: L_1006ae64:
205779:     { uint32_t _b = c->r[13]; ngage_w32(c, _b, c->r[12]); ngage_w32(c, _b + 4u, c->r[14]); } /* stm sp, {r12, lr} */
205780: L_1006ae68:
205781:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[14]); /* str lr, [sp, #0x8] */
205782: L_1006ae6c:
205783:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
205784: L_1006ae70:
205785:     c->r[1] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r1, [r12, #0x1] */
205786: L_1006ae74:
205787:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r3, r3, r1, lsl #8 */
205788: L_1006ae78:
205789:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
205790: L_1006ae7c:
205791:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
205792: L_1006ae80:
205793:     c->r[1] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r1, [r12, #0x3] */
205794: L_1006ae84:
205795:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r2, r2, r1, lsl #8 */
205796: L_1006ae88:
205797:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
205798: L_1006ae8c:
205799:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[14]); /* str lr, [sp, #0x14] */
205800: L_1006ae90:
205801:     c->r[1] = ngage_r32(c, (c->r[7] + 1152u)); /* ldr r1, [r7, #0x480] */
205802: L_1006ae94:
205803:     c->r[0] = c->r[7]; /* mov r0, r7 */
205804: L_1006ae98:
205805:     c->r[2] = c->r[14]; /* mov r2, lr */
205806: L_1006ae9c:
205807:     c->r[3] = c->r[2]; /* mov r3, r2 */
205808: L_1006aea0:
205809:     c->r[14] = 0x1006aea4u; ngage_call(c, 0x1006a488u); goto L_1006aea4; /* bl 0x6a488 <shadowkey_code+0x6a488> */
205810: L_1006aea4:
205811:     c->r[13] = c->r[13] + 0x0000001cu; /* add sp, sp, #28 */
205812: L_1006aea8:
205813:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[14] = ngage_r32(c, c->r[13] + 16u); c->r[13] += 20u; /* pop {r4, r5, r6, r7, lr} */
205814: L_1006aeac:
205815:     return; /* bx lr */
205816: }
205817: 
205818: void sub_1006aeb0(ngage_cpu_t *c) {
205819:     (void)c;
205820:     if (0) { goto L_1006aeb0; goto L_1006aeb4; goto L_1006aeb8; goto L_1006aebc; goto L_1006aec0; goto L_1006aec4; goto L_1006aec8; goto L_1006aecc; goto L_1006aed0; goto L_1006aed4; goto L_1006aed8; goto L_1006aedc; goto L_1006aee0; goto L_1006aee4; goto L_1006aee8; goto L_1006aeec; goto L_1006aef0; goto L_1006aef4; goto L_1006aef8; goto L_1006aefc; goto L_1006af00; goto L_1006af04; goto L_1006af08; goto L_1006af0c; goto L_1006af10; goto L_1006af14; goto L_1006af18; goto L_1006af1c; goto L_1006af20; goto L_1006af24; goto L_1006af28; goto L_1006af2c; goto L_1006af30; goto L_1006af34; goto L_1006af38; goto L_1006af3c; goto L_1006af40; goto L_1006af44; goto L_1006af48; goto L_1006af4c; goto L_1006af50; goto L_1006af54; goto L_1006af58; goto L_1006af5c; goto L_1006af60; goto L_1006af64; goto L_1006af68; goto L_1006af6c; goto L_1006af70; goto L_1006af74; goto L_1006af78; goto L_1006af7c; goto L_1006af80; goto L_1006af84; goto L_1006af88; goto L_1006af8c; goto L_1006af90; goto L_1006af94; goto L_1006af98; goto L_1006af9c; goto L_1006afa0; goto L_1006afa4; goto L_1006afa8; goto L_1006afac; goto L_1006afb0; goto L_1006afb4; goto L_1006afb8; goto L_1006afbc; goto L_1006afc0; goto L_1006afc4; goto L_1006afc8; goto L_1006afcc; goto L_1006afd0; goto L_1006afd4; goto L_1006afd8; goto L_1006afdc; goto L_1006afe0; goto L_1006afe4; goto L_1006afe8; goto L_1006afec; goto L_1006aff0; goto L_1006aff4; goto L_1006aff8; goto L_1006affc; goto L_1006b000; goto L_1006b004; goto L_1006b008; goto L_1006b00c; goto L_1006b010; goto L_1006b014; goto L_1006b018; goto L_1006b01c; goto L_1006b020; goto L_1006b024; goto L_1006b028; goto L_1006b02c; goto L_1006b030; goto L_1006b034; goto L_1006b038; goto L_1006b03c; goto L_1006b040; goto L_1006b044; goto L_1006b048; goto L_1006b04c; goto L_1006b050; goto L_1006b054; goto L_1006b058; goto L_1006b05c; goto L_1006b060; goto L_1006b064; goto L_1006b068; goto L_1006b06c; goto L_1006b070; goto L_1006b074; goto L_1006b078; goto L_1006b07c; goto L_1006b080; goto L_1006b084; goto L_1006b088; goto L_1006b08c; goto L_1006b090; goto L_1006b094; goto L_1006b098; goto L_1006b09c; goto L_1006b0a0; goto L_1006b0a4; goto L_1006b0a8; goto L_1006b0ac; goto L_1006b0b0; goto L_1006b0b4; goto L_1006b0b8; goto L_1006b0bc; goto L_1006b0c0; goto L_1006b0c4; goto L_1006b0c8; goto L_1006b0cc; goto L_1006b0d0; goto L_1006b0d4; goto L_1006b0d8; goto L_1006b0dc; goto L_1006b0e0; goto L_1006b0e4; goto L_1006b0e8; goto L_1006b0ec; goto L_1006b0f0; goto L_1006b0f4; goto L_1006b0f8; goto L_1006b0fc; goto L_1006b100; goto L_1006b104; goto L_1006b108; goto L_1006b10c; goto L_1006b110; goto L_1006b114; goto L_1006b118; goto L_1006b11c; goto L_1006b120; goto L_1006b124; goto L_1006b128; goto L_1006b12c; goto L_1006b130; goto L_1006b134; goto L_1006b138; goto L_1006b13c; goto L_1006b140; goto L_1006b144; goto L_1006b148; goto L_1006b14c; goto L_1006b154; goto L_1006b158; goto L_1006b15c; goto L_1006b160; goto L_1006b164; }
205821: L_1006aeb0:
205822:     c->r[13] -= 32u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[9]); ngage_w32(c, c->r[13] + 24u, c->r[10]); ngage_w32(c, c->r[13] + 28u, c->r[14]); /* push {r4, r5, r6, r7, r8, r9, r10, lr} */
205823: L_1006aeb4:
205824:     c->r[13] = c->r[13] - 0x00000430u; /* sub sp, sp, #1072 */
205825: L_1006aeb8:
205826:     c->r[13] = c->r[13] - 0x00000004u; /* sub sp, sp, #4 */
205827: L_1006aebc:
205828:     c->r[12] = ngage_r32(c, (c->r[13] + 1112u)); /* ldr r12, [sp, #0x458] */
205829: L_1006aec0:
205830:     c->r[6] = ngage_r8(c, c->r[12]); /* ldrb r6, [r12] */
205831: L_1006aec4:
205832:     c->r[4] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r4, [r12, #0x1] */
205833: L_1006aec8:
205834:     c->r[5] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r5, [r12, #0x2] */
205835: L_1006aecc:
205836:     c->r[14] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb lr, [r12, #0x3] */
205837: L_1006aed0:
205838:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
205839: L_1006aed4:
205840:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
205841: L_1006aed8:
205842:     c->r[8] = c->r[13] + 0x00000034u; /* add r8, sp, #52 */
205843: L_1006aedc:

## Call 24: caller=sub_1006b3fc, lifted_line=206549
206479: L_1006b3e0:
206480:     ngage_w32(c, (c->r[7] + 256u), (uint32_t)c->r[2]); /* str r2, [r7, #0x100] */
206481: L_1006b3e4:
206482:     c->r[0] = c->r[13] + 0x00000200u; /* add r0, sp, #512 */
206483: L_1006b3e8:
206484:     c->r[1] = 0x00000002u; /* mov r1, #2 */
206485: L_1006b3ec:
206486:     c->r[14] = 0x1006b3f0u; ngage_call(c, 0x1008fcccu); goto L_1006b3f0; /* bl 0x8fccc <shadowkey_code+0x8fccc> */
206487: L_1006b3f0:
206488:     c->r[13] = c->r[13] + 0x00000334u; /* add sp, sp, #820 */
206489: L_1006b3f4:
206490:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[10] = ngage_r32(c, c->r[13] + 20u); c->r[14] = ngage_r32(c, c->r[13] + 24u); c->r[13] += 28u; /* pop {r4, r5, r6, r7, r8, r10, lr} */
206491: L_1006b3f8:
206492:     return; /* bx lr */
206493: }
206494: 
206495: void sub_1006b3fc(ngage_cpu_t *c) {
206496:     (void)c;
206497:     if (0) { goto L_1006b3fc; goto L_1006b400; goto L_1006b404; goto L_1006b408; goto L_1006b40c; goto L_1006b410; goto L_1006b414; goto L_1006b418; goto L_1006b41c; goto L_1006b420; goto L_1006b424; goto L_1006b428; goto L_1006b42c; goto L_1006b430; goto L_1006b434; goto L_1006b438; goto L_1006b43c; goto L_1006b440; goto L_1006b444; goto L_1006b448; goto L_1006b44c; goto L_1006b450; goto L_1006b454; goto L_1006b458; goto L_1006b45c; goto L_1006b460; goto L_1006b464; goto L_1006b468; goto L_1006b46c; goto L_1006b470; goto L_1006b474; goto L_1006b478; goto L_1006b47c; goto L_1006b480; goto L_1006b484; goto L_1006b488; goto L_1006b48c; goto L_1006b490; goto L_1006b494; goto L_1006b498; goto L_1006b49c; goto L_1006b4a0; goto L_1006b4a4; goto L_1006b4a8; goto L_1006b4ac; goto L_1006b4b0; goto L_1006b4b4; goto L_1006b4b8; goto L_1006b4bc; goto L_1006b4c0; goto L_1006b4c4; goto L_1006b4c8; goto L_1006b4cc; goto L_1006b4d0; goto L_1006b4d4; goto L_1006b4d8; goto L_1006b4dc; goto L_1006b4e0; goto L_1006b4e4; goto L_1006b4e8; goto L_1006b4ec; goto L_1006b4f0; goto L_1006b4f4; goto L_1006b4f8; goto L_1006b4fc; goto L_1006b500; goto L_1006b504; goto L_1006b508; goto L_1006b50c; goto L_1006b510; goto L_1006b514; goto L_1006b518; goto L_1006b51c; goto L_1006b520; goto L_1006b524; goto L_1006b528; goto L_1006b52c; goto L_1006b530; goto L_1006b534; goto L_1006b538; goto L_1006b53c; goto L_1006b540; goto L_1006b544; goto L_1006b548; goto L_1006b54c; goto L_1006b550; goto L_1006b554; goto L_1006b558; goto L_1006b55c; goto L_1006b560; goto L_1006b564; goto L_1006b568; goto L_1006b56c; goto L_1006b570; goto L_1006b574; goto L_1006b578; goto L_1006b57c; goto L_1006b580; goto L_1006b584; goto L_1006b588; goto L_1006b58c; goto L_1006b590; goto L_1006b594; goto L_1006b598; goto L_1006b59c; goto L_1006b5a0; goto L_1006b5a4; goto L_1006b5a8; goto L_1006b5ac; goto L_1006b5b0; goto L_1006b5b4; goto L_1006b5b8; goto L_1006b5bc; goto L_1006b5c0; goto L_1006b5c4; }
206498: L_1006b3fc:
206499:     c->r[13] -= 24u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[14]); /* push {r4, r5, r6, r7, r8, lr} */
206500: L_1006b400:
206501:     c->r[13] = c->r[13] - 0x00000018u; /* sub sp, sp, #24 */
206502: L_1006b404:
206503:     c->r[6] = c->r[0]; /* mov r6, r0 */
206504: L_1006b408:
206505:     c->r[4] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r4, [r6, #0x14] */
206506: L_1006b40c:
206507:     c->r[3] = 0x00004400u; /* mov r3, #17408 */
206508: L_1006b410:
206509:     c->r[3] = c->r[3] + 0x000000b0u; /* add r3, r3, #176 */
206510: L_1006b414:
206511:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
206512: L_1006b418:
206513:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
206514: L_1006b41c:
206515:     if (ngage_zf(c)) { goto L_1006b464; } /* beq 0x6b464 <shadowkey_code+0x6b464> */
206516: L_1006b420:
206517:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
206518: L_1006b424:
206519:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
206520: L_1006b428:
206521:     c->r[2] = 0x00000000u; /* mov r2, #0 */
206522: L_1006b42c:
206523:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
206524: L_1006b430:
206525:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
206526: L_1006b434:
206527:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
206528: L_1006b438:
206529:     c->r[12] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r12, [lr, #0x1] */
206530: L_1006b43c:
206531:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r3, r3, r12, lsl #8 */
206532: L_1006b440:
206533:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
206534: L_1006b444:
206535:     c->r[0] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r0, [lr, #0x2] */
206536: L_1006b448:
206537:     c->r[12] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r12, [lr, #0x3] */
206538: L_1006b44c:
206539:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[12], 0u, 8u, 1u, 0u); /* orr r0, r0, r12, lsl #8 */
206540: L_1006b450:
206541:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
206542: L_1006b454:
206543:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
206544: L_1006b458:
206545:     c->r[3] = c->r[2]; /* mov r3, r2 */
206546: L_1006b45c:
206547:     c->r[0] = c->r[4]; /* mov r0, r4 */
206548: L_1006b460:
206549:     c->r[14] = 0x1006b464u; ngage_call(c, 0x1006a488u); goto L_1006b464; /* bl 0x6a488 <shadowkey_code+0x6a488> */
206550: L_1006b464:
206551:     c->r[0] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r0, [r6, #0x14] */
206552: L_1006b468:
206553:     c->r[14] = 0x1006b46cu; ngage_call(c, 0x1001afa4u); goto L_1006b46c; /* bl 0x1afa4 <shadowkey_code+0x1afa4> */
206554: L_1006b46c:
206555:     c->r[2] = ngage_r32(c, (c->r[6] + 236u)); /* ldr r2, [r6, #0xec] */
206556: L_1006b470:
206557:     c->r[2] = c->r[2] + shadowkey_arm_shift_operand(c, c->r[0], 2u, 2u, 1u, 0u); /* add r2, r2, r0, asr #2 */
206558: L_1006b474:
206559:     ngage_w32(c, (c->r[6] + 236u), (uint32_t)c->r[2]); /* str r2, [r6, #0xec] */
206560: L_1006b478:
206561:     c->r[5] = ngage_r32(c, (c->r[6] + 256u)); /* ldr r5, [r6, #0x100] */
206562: L_1006b47c:
206563:     c->r[7] = 0x00000000u; /* mov r7, #0 */
206564: L_1006b480:
206565:     c->r[3] = 0x00000001u; /* mov r3, #1 */
206566: L_1006b484:
206567:     ngage_sub_flags(c, c->r[3], c->r[7]); /* cmp r3, r7 */
206568: L_1006b488:
206569:     c->r[8] = c->r[6] + 0x000000f4u; /* add r8, r6, #244 */
206570: L_1006b48c:
206571:     c->r[4] = 0x00000000u - c->r[2]; /* rsb r4, r2, #0 */
206572: L_1006b490:
206573:     if (ngage_zf(c)) { goto L_1006b4fc; } /* beq 0x6b4fc <shadowkey_code+0x6b4fc> */
206574: L_1006b494:
206575:     c->r[3] = c->r[4] - 0x00000001u; /* sub r3, r4, #1 */
206576: L_1006b498:
206577:     ngage_sub_flags(c, c->r[3], 0x000000a3u); /* cmp r3, #163 */
206578: L_1006b49c:
206579:     if ((ngage_cf(c) && !ngage_zf(c))) { goto L_1006b4d8; } /* bhi 0x6b4d8 <shadowkey_code+0x6b4d8> */
206580: L_1006b4a0:
206581:     c->r[2] = ngage_r32(c, c->r[5]); /* ldr r2, [r5] */
206582: L_1006b4a4:
206583:     c->r[12] = ngage_r32(c, (c->r[6] + 20u)); /* ldr r12, [r6, #0x14] */

## Call 25: caller=sub_10076b64, lifted_line=228700
228630:     c->r[7] = c->r[0]; /* mov r7, r0 */
228631: L_10076b70:
228632:     c->r[3] = ngage_r32(c, (c->r[7] + 80u)); /* ldr r3, [r7, #0x50] */
228633: L_10076b74:
228634:     ngage_w32(c, (c->r[13] + 36u), (uint32_t)c->r[1]); /* str r1, [sp, #0x24] */
228635: L_10076b78:
228636:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
228637: L_10076b7c:
228638:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_10076c14; } /* blt 0x76c14 <shadowkey_code+0x76c14> */
228639: L_10076b80:
228640:     c->r[4] = 0x000005c0u; /* mov r4, #1472 */
228641: L_10076b84:
228642:     c->r[4] = c->r[4] + 0x00000002u; /* add r4, r4, #2 */
228643: L_10076b88:
228644:     c->r[3] = ngage_r8(c, (c->r[1] + c->r[4])); /* ldrb r3, [r1, r4] */
228645: L_10076b8c:
228646:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
228647: L_10076b90:
228648:     if (!ngage_zf(c)) { c->r[0] = 0x00002700u; } /* movne r0, #9984 */
228649: L_10076b94:
228650:     if (!ngage_zf(c)) { c->r[0] = c->r[0] + 0x00000010u; } /* addne r0, r0, #16 */
228651: L_10076b98:
228652:     if (!ngage_zf(c)) { c->r[14] = 0x10076b9cu; ngage_call(c, 0x1009ee20u); goto L_10076b9c; } /* blne 0x9ee20 <shadowkey_code+0x9ee20> */
228653: L_10076b9c:
228654:     c->r[10] = ngage_r32(c, (c->r[13] + 36u)); /* ldr r10, [sp, #0x24] */
228655: L_10076ba0:
228656:     c->r[2] = ngage_r32(c, (c->r[7] + 80u)); /* ldr r2, [r7, #0x50] */
228657: L_10076ba4:
228658:     c->r[3] = c->r[10] + 0x00004400u; /* add r3, r10, #17408 */
228659: L_10076ba8:
228660:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
228661: L_10076bac:
228662:     c->r[12] = ngage_r32(c, (c->r[3] + (c->r[2] << 2))); /* ldr r12, [r3, r2, lsl #2] */
228663: L_10076bb0:
228664:     ngage_sub_flags(c, c->r[12], 0x00000000u); /* cmp r12, #0 */
228665: L_10076bb4:
228666:     if (ngage_zf(c)) { goto L_10076bfc; } /* beq 0x76bfc <shadowkey_code+0x76bfc> */
228667: L_10076bb8:
228668:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
228669: L_10076bbc:
228670:     c->r[2] = 0x00000000u; /* mov r2, #0 */
228671: L_10076bc0:
228672:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
228673: L_10076bc4:
228674:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
228675: L_10076bc8:
228676:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
228677: L_10076bcc:
228678:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
228679: L_10076bd0:
228680:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
228681: L_10076bd4:
228682:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
228683: L_10076bd8:
228684:     c->r[1] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r1, [r12, #0x2] */
228685: L_10076bdc:
228686:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
228687: L_10076be0:
228688:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[2]); /* str r2, [sp, #0x14] */
228689: L_10076be4:
228690:     c->r[1] = c->r[1] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r1, r1, r0, lsl #8 */
228691: L_10076be8:
228692:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[1]); /* str r1, [sp, #0x10] */
228693: L_10076bec:
228694:     c->r[1] = ngage_r32(c, (c->r[10] + 1152u)); /* ldr r1, [r10, #0x480] */
228695: L_10076bf0:
228696:     c->r[3] = c->r[2]; /* mov r3, r2 */
228697: L_10076bf4:
228698:     c->r[0] = c->r[10]; /* mov r0, r10 */
228699: L_10076bf8:
228700:     c->r[14] = 0x10076bfcu; ngage_call(c, 0x1006a488u); goto L_10076bfc; /* bl 0x6a488 <shadowkey_code+0x6a488> */
228701: L_10076bfc:
228702:     c->r[10] = ngage_r32(c, (c->r[13] + 36u)); /* ldr r10, [sp, #0x24] */
228703: L_10076c00:
228704:     c->r[3] = ngage_r8(c, (c->r[10] + c->r[4])); /* ldrb r3, [r10, r4] */
228705: L_10076c04:
228706:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
228707: L_10076c08:
228708:     if (!ngage_zf(c)) { c->r[0] = 0x00002700u; } /* movne r0, #9984 */
228709: L_10076c0c:
228710:     if (!ngage_zf(c)) { c->r[0] = c->r[0] + 0x00000010u; } /* addne r0, r0, #16 */
228711: L_10076c10:
228712:     if (!ngage_zf(c)) { c->r[14] = 0x10076c14u; ngage_call(c, 0x1009ee20u); goto L_10076c14; } /* blne 0x9ee20 <shadowkey_code+0x9ee20> */
228713: L_10076c14:
228714:     c->r[0] = ngage_r8(c, (c->r[7] + 150u)); /* ldrb r0, [r7, #0x96] */
228715: L_10076c18:
228716:     c->r[1] = ngage_r8(c, (c->r[7] + 151u)); /* ldrb r1, [r7, #0x97] */
228717: L_10076c1c:
228718:     c->r[10] = ngage_r32(c, (c->r[13] + 36u)); /* ldr r10, [sp, #0x24] */
228719: L_10076c20:
228720:     c->r[3] = 0x000005c0u; /* mov r3, #1472 */
228721: L_10076c24:
228722:     c->r[3] = c->r[3] + 0x00000002u; /* add r3, r3, #2 */
228723: L_10076c28:
228724:     c->r[2] = ngage_r8(c, (c->r[10] + c->r[3])); /* ldrb r2, [r10, r3] */
228725: L_10076c2c:
228726:     c->r[8] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r8, r0, r1, lsl #8 */
228727: L_10076c30:
228728:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
228729: L_10076c34:
228730:     if (!ngage_zf(c)) { c->r[0] = 0x00002700u; } /* movne r0, #9984 */
228731: L_10076c38:
228732:     if (!ngage_zf(c)) { c->r[0] = c->r[0] + 0x00000010u; } /* addne r0, r0, #16 */
228733: L_10076c3c:
228734:     if (!ngage_zf(c)) { c->r[14] = 0x10076c40u; ngage_call(c, 0x1009ee20u); goto L_10076c40; } /* blne 0x9ee20 <shadowkey_code+0x9ee20> */

## Call 26: caller=sub_1007ec80, lifted_line=242686
242616: L_1007ec7c:
242617:     return; /* bx lr */
242618: }
242619: 
242620: void sub_1007ec80(ngage_cpu_t *c) {
242621:     (void)c;
242622:     if (0) { goto L_1007ec80; goto L_1007ec84; goto L_1007ec88; goto L_1007ec8c; goto L_1007ec90; goto L_1007ec94; goto L_1007ec98; goto L_1007ec9c; goto L_1007eca0; goto L_1007eca4; goto L_1007eca8; goto L_1007ecac; goto L_1007ecb0; goto L_1007ecb4; goto L_1007ecb8; goto L_1007ecbc; goto L_1007ecc0; goto L_1007ecc4; goto L_1007ecc8; goto L_1007eccc; goto L_1007ecd0; goto L_1007ecd4; goto L_1007ecd8; goto L_1007ecdc; goto L_1007ece0; goto L_1007ece4; goto L_1007ece8; goto L_1007ecec; goto L_1007ecf0; goto L_1007ecf4; goto L_1007ecf8; goto L_1007ecfc; goto L_1007ed00; goto L_1007ed04; goto L_1007ed08; goto L_1007ed0c; goto L_1007ed10; goto L_1007ed14; goto L_1007ed18; goto L_1007ed1c; goto L_1007ed20; goto L_1007ed24; goto L_1007ed28; goto L_1007ed2c; goto L_1007ed30; goto L_1007ed34; goto L_1007ed38; goto L_1007ed3c; goto L_1007ed40; goto L_1007ed44; goto L_1007ed48; goto L_1007ed4c; goto L_1007ed50; goto L_1007ed54; goto L_1007ed58; goto L_1007ed5c; goto L_1007ed60; goto L_1007ed64; goto L_1007ed68; goto L_1007ed6c; goto L_1007ed70; goto L_1007ed74; goto L_1007ed78; goto L_1007ed7c; goto L_1007ed80; goto L_1007ed84; goto L_1007ed88; goto L_1007ed8c; goto L_1007ed90; goto L_1007ed94; goto L_1007ed98; goto L_1007ed9c; goto L_1007eda0; goto L_1007eda4; goto L_1007eda8; goto L_1007edac; goto L_1007edb0; goto L_1007edb4; goto L_1007edb8; goto L_1007edbc; goto L_1007edc0; goto L_1007edc4; goto L_1007edc8; goto L_1007edcc; goto L_1007edd0; goto L_1007edd4; goto L_1007edd8; goto L_1007eddc; goto L_1007ede0; goto L_1007ede4; goto L_1007ede8; goto L_1007edec; goto L_1007edf0; goto L_1007edf4; goto L_1007edf8; goto L_1007edfc; goto L_1007ee00; goto L_1007ee04; goto L_1007ee08; goto L_1007ee0c; goto L_1007ee10; goto L_1007ee14; goto L_1007ee18; goto L_1007ee1c; goto L_1007ee20; goto L_1007ee24; goto L_1007ee28; goto L_1007ee2c; goto L_1007ee30; goto L_1007ee34; goto L_1007ee38; goto L_1007ee3c; goto L_1007ee40; goto L_1007ee44; goto L_1007ee48; goto L_1007ee4c; goto L_1007ee50; goto L_1007ee54; goto L_1007ee58; goto L_1007ee5c; goto L_1007ee60; goto L_1007ee64; goto L_1007ee68; goto L_1007ee6c; goto L_1007ee70; goto L_1007ee74; goto L_1007ee78; goto L_1007ee7c; goto L_1007ee80; goto L_1007ee84; goto L_1007ee88; goto L_1007ee8c; goto L_1007ee90; goto L_1007ee94; goto L_1007ee98; goto L_1007ee9c; goto L_1007eea0; goto L_1007eea4; goto L_1007eea8; goto L_1007eeac; goto L_1007eeb0; goto L_1007eeb4; goto L_1007eeb8; goto L_1007eebc; goto L_1007eec0; goto L_1007eec4; goto L_1007eec8; goto L_1007eecc; goto L_1007eed0; goto L_1007eed4; goto L_1007eed8; goto L_1007eedc; goto L_1007eee0; goto L_1007eee4; goto L_1007eee8; goto L_1007eeec; goto L_1007eef0; goto L_1007eef4; goto L_1007eef8; goto L_1007eefc; goto L_1007ef00; goto L_1007ef04; goto L_1007ef08; goto L_1007ef0c; goto L_1007ef10; goto L_1007ef14; goto L_1007ef18; goto L_1007ef1c; goto L_1007ef20; }
242623: L_1007ec80:
242624:     c->r[13] -= 20u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[14]); /* push {r4, r5, r6, r7, lr} */
242625: L_1007ec84:
242626:     c->r[13] = c->r[13] - 0x00000018u; /* sub sp, sp, #24 */
242627: L_1007ec88:
242628:     c->r[5] = c->r[0]; /* mov r5, r0 */
242629: L_1007ec8c:
242630:     c->r[2] = ngage_r32(c, (c->r[5] + 152u)); /* ldr r2, [r5, #0x98] */
242631: L_1007ec90:
242632:     c->r[4] = c->r[1]; /* mov r4, r1 */
242633: L_1007ec94:
242634:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
242635: L_1007ec98:
242636:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_1007ef18; } /* blt 0x7ef18 <shadowkey_code+0x7ef18> */
242637: L_1007ec9c:
242638:     c->r[14] = ngage_r32(c, (c->r[5] + 112u)); /* ldr lr, [r5, #0x70] */
242639: L_1007eca0:
242640:     c->r[3] = c->r[14] + 0x00004400u; /* add r3, lr, #17408 */
242641: L_1007eca4:
242642:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
242643: L_1007eca8:
242644:     c->r[6] = ngage_r32(c, (c->r[3] + (c->r[2] << 2))); /* ldr r6, [r3, r2, lsl #2] */
242645: L_1007ecac:
242646:     ngage_sub_flags(c, c->r[6], 0x00000000u); /* cmp r6, #0 */
242647: L_1007ecb0:
242648:     if (ngage_zf(c)) { goto L_1007ef18; } /* beq 0x7ef18 <shadowkey_code+0x7ef18> */
242649: L_1007ecb4:
242650:     c->r[1] = ngage_r32(c, (c->r[14] + 1152u)); /* ldr r1, [lr, #0x480] */
242651: L_1007ecb8:
242652:     ngage_w32(c, c->r[13], (uint32_t)c->r[6]); /* str r6, [sp] */
242653: L_1007ecbc:
242654:     c->r[12] = 0x00000000u; /* mov r12, #0 */
242655: L_1007ecc0:
242656:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
242657: L_1007ecc4:
242658:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[12]); /* str r12, [sp, #0x8] */
242659: L_1007ecc8:
242660:     c->r[3] = ngage_r8(c, c->r[6]); /* ldrb r3, [r6] */
242661: L_1007eccc:
242662:     c->r[2] = ngage_r8(c, (c->r[6] + 1u)); /* ldrb r2, [r6, #0x1] */
242663: L_1007ecd0:
242664:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr r3, r3, r2, lsl #8 */
242665: L_1007ecd4:
242666:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
242667: L_1007ecd8:
242668:     c->r[0] = ngage_r8(c, (c->r[6] + 2u)); /* ldrb r0, [r6, #0x2] */
242669: L_1007ecdc:
242670:     c->r[7] = c->r[6] + 0x00000002u; /* add r7, r6, #2 */
242671: L_1007ece0:
242672:     c->r[3] = ngage_r8(c, (c->r[7] + 1u)); /* ldrb r3, [r7, #0x1] */
242673: L_1007ece4:
242674:     c->r[0] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[3], 0u, 8u, 1u, 0u); /* orr r0, r0, r3, lsl #8 */
242675: L_1007ece8:
242676:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[0]); /* str r0, [sp, #0x10] */
242677: L_1007ecec:
242678:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
242679: L_1007ecf0:
242680:     c->r[2] = c->r[5] + 0x00000078u; /* add r2, r5, #120 */
242681: L_1007ecf4:
242682:     { uint32_t _b = c->r[2]; c->r[2] = ngage_r32(c, _b); c->r[3] = ngage_r32(c, _b + 4u); } /* ldm r2, {r2, r3} */
242683: L_1007ecf8:
242684:     c->r[0] = c->r[14]; /* mov r0, lr */
242685: L_1007ecfc:
242686:     c->r[14] = 0x1007ed00u; ngage_call(c, 0x1006a488u); goto L_1007ed00; /* bl 0x6a488 <shadowkey_code+0x6a488> */
242687: L_1007ed00:
242688:     ngage_sub_flags(c, c->r[4], 0x00000000u); /* cmp r4, #0 */
242689: L_1007ed04:
242690:     if (ngage_zf(c)) { goto L_1007ef18; } /* beq 0x7ef18 <shadowkey_code+0x7ef18> */
242691: L_1007ed08:
242692:     c->r[0] = ngage_r32(c, (c->r[5] + 112u)); /* ldr r0, [r5, #0x70] */
242693: L_1007ed0c:
242694:     c->r[2] = ngage_r8(c, c->r[6]); /* ldrb r2, [r6] */
242695: L_1007ed10:
242696:     c->r[3] = ngage_r8(c, (c->r[6] + 1u)); /* ldrb r3, [r6, #0x1] */
242697: L_1007ed14:
242698:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
242699: L_1007ed18:
242700:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[3], 0u, 8u, 1u, 0u); /* orr r2, r2, r3, lsl #8 */
242701: L_1007ed1c:
242702:     ngage_w32(c, c->r[13], (uint32_t)c->r[2]); /* str r2, [sp] */
242703: L_1007ed20:
242704:     c->r[12] = ngage_r32(c, (c->r[0] + 40u)); /* ldr r12, [r0, #0x28] */
242705: L_1007ed24:
242706:     c->r[3] = ngage_r8(c, (c->r[12] + 10u)); /* ldrb r3, [r12, #0xa] */
242707: L_1007ed28:
242708:     c->r[2] = ngage_r8(c, (c->r[12] + 11u)); /* ldrb r2, [r12, #0xb] */
242709: L_1007ed2c:
242710:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr r3, r3, r2, lsl #8 */
242711: L_1007ed30:
242712:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[3]); /* str r3, [sp, #0x4] */
242713: L_1007ed34:
242714:     c->r[2] = c->r[5] + 0x00000078u; /* add r2, r5, #120 */
242715: L_1007ed38:
242716:     { uint32_t _b = c->r[2]; c->r[2] = ngage_r32(c, _b); c->r[3] = ngage_r32(c, _b + 4u); } /* ldm r2, {r2, r3} */
242717: L_1007ed3c:
242718:     c->r[3] = c->r[3] - 0x00000001u; /* sub r3, r3, #1 */
242719: L_1007ed40:
242720:     c->r[14] = 0x1007ed44u; ngage_call(c, 0x1006bee8u); goto L_1007ed44; /* bl 0x6bee8 <shadowkey_code+0x6bee8> */

## Call 27: caller=sub_1008e31c, lifted_line=273160
273090:     if (ngage_zf(c)) { c->r[3] = 0x00000001u; } /* moveq r3, #1 */
273091: L_1008e340:
273092:     if (ngage_zf(c)) { ngage_w8(c, (c->r[6] + 230u), (uint8_t)c->r[3]); } /* strbeq r3, [r6, #0xe6] */
273093: L_1008e344:
273094:     c->r[7] = ngage_r32(c, (c->r[6] + 124u)); /* ldr r7, [r6, #0x7c] */
273095: L_1008e348:
273096:     c->r[4] = ngage_r32(c, (c->r[6] + 112u)); /* ldr r4, [r6, #0x70] */
273097: L_1008e34c:
273098:     c->r[14] = ngage_r32(c, (c->r[6] + 156u)); /* ldr lr, [r6, #0x9c] */
273099: L_1008e350:
273100:     c->r[3] = c->r[4] + 0x00004400u; /* add r3, r4, #17408 */
273101: L_1008e354:
273102:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
273103: L_1008e358:
273104:     c->r[5] = ngage_r32(c, (c->r[3] + (c->r[1] << 2))); /* ldr r5, [r3, r1, lsl #2] */
273105: L_1008e35c:
273106:     c->r[12] = ngage_r8(c, (c->r[5] + 2u)); /* ldrb r12, [r5, #0x2] */
273107: L_1008e360:
273108:     c->r[1] = ngage_r8(c, (c->r[5] + 3u)); /* ldrb r1, [r5, #0x3] */
273109: L_1008e364:
273110:     c->r[0] = ngage_r8(c, c->r[5]); /* ldrb r0, [r5] */
273111: L_1008e368:
273112:     c->r[2] = ngage_r8(c, (c->r[5] + 1u)); /* ldrb r2, [r5, #0x1] */
273113: L_1008e36c:
273114:     ngage_sub_flags(c, c->r[8], 0x00000000u); /* cmp r8, #0 */
273115: L_1008e370:
273116:     c->r[12] = c->r[12] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r12, r12, r1, lsl #8 */
273117: L_1008e374:
273118:     c->r[2] = c->r[0] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr r2, r0, r2, lsl #8 */
273119: L_1008e378:
273120:     c->r[3] = ((uint32_t)((int32_t)c->r[2] >> 1)); /* asr r3, r2, #1 */
273121: L_1008e37c:
273122:     c->r[14] = shadowkey_arm_shift_operand(c, c->r[14], 2u, 1u, 1u, 0u) - c->r[3]; /* rsb lr, r3, lr, asr #1 */
273123: L_1008e380:
273124:     c->r[0] = c->r[4]; /* mov r0, r4 */
273125: L_1008e384:
273126:     if (ngage_zf(c)) { c->r[3] = ngage_r32(c, (c->r[6] + 152u)); } /* ldreq r3, [r6, #0x98] */
273127: L_1008e388:
273128:     if (ngage_zf(c)) { c->r[3] = c->r[7] + c->r[3]; } /* addeq r3, r7, r3 */
273129: L_1008e38c:
273130:     if (ngage_zf(c)) { c->r[7] = c->r[3] + shadowkey_arm_shift_operand(c, c->r[12], 1u, 1u, 1u, 0u); } /* addeq r7, r3, r12, lsr #1 */
273131: L_1008e390:
273132:     if (!ngage_zf(c)) { c->r[7] = c->r[7] - c->r[12]; } /* rsbne r7, r12, r7 */
273133: L_1008e394:
273134:     ngage_sub_flags(c, c->r[5], 0x00000000u); /* cmp r5, #0 */
273135: L_1008e398:
273136:     if (ngage_zf(c)) { goto L_1008e3cc; } /* beq 0x8e3cc <shadowkey_code+0x8e3cc> */
273137: L_1008e39c:
273138:     c->r[1] = ngage_r32(c, (c->r[0] + 1152u)); /* ldr r1, [r0, #0x480] */
273139: L_1008e3a0:
273140:     ngage_w32(c, c->r[13], (uint32_t)c->r[5]); /* str r5, [sp] */
273141: L_1008e3a4:
273142:     c->r[3] = 0x00000000u; /* mov r3, #0 */
273143: L_1008e3a8:
273144:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[3]); /* str r3, [sp, #0x4] */
273145: L_1008e3ac:
273146:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[3]); /* str r3, [sp, #0x8] */
273147: L_1008e3b0:
273148:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[12]); /* str r12, [sp, #0x10] */
273149: L_1008e3b4:
273150:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[3]); /* str r3, [sp, #0x14] */
273151: L_1008e3b8:
273152:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[2]); /* str r2, [sp, #0xc] */
273153: L_1008e3bc:
273154:     c->r[2] = ngage_r32(c, (c->r[6] + 120u)); /* ldr r2, [r6, #0x78] */
273155: L_1008e3c0:
273156:     c->r[3] = c->r[7]; /* mov r3, r7 */
273157: L_1008e3c4:
273158:     c->r[2] = c->r[14] + c->r[2]; /* add r2, lr, r2 */
273159: L_1008e3c8:
273160:     c->r[14] = 0x1008e3ccu; ngage_call(c, 0x1006a488u); goto L_1008e3cc; /* bl 0x6a488 <shadowkey_code+0x6a488> */
273161: L_1008e3cc:
273162:     c->r[13] = c->r[13] + 0x00000018u; /* add sp, sp, #24 */
273163: L_1008e3d0:
273164:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[14] = ngage_r32(c, c->r[13] + 20u); c->r[13] += 24u; /* pop {r4, r5, r6, r7, r8, lr} */
273165: L_1008e3d4:
273166:     return; /* bx lr */
273167: }
273168: 
273169: void sub_1008e3d8(ngage_cpu_t *c) {
273170:     (void)c;
273171:     if (0) { goto L_1008e3d8; goto L_1008e3dc; goto L_1008e3e0; goto L_1008e3e4; goto L_1008e3e8; goto L_1008e3ec; goto L_1008e3f0; goto L_1008e3f4; goto L_1008e3f8; goto L_1008e3fc; goto L_1008e400; goto L_1008e404; goto L_1008e408; goto L_1008e40c; goto L_1008e410; goto L_1008e414; goto L_1008e418; goto L_1008e41c; goto L_1008e420; goto L_1008e424; goto L_1008e428; goto L_1008e42c; goto L_1008e430; goto L_1008e434; goto L_1008e438; }
273172: L_1008e3d8:
273173:     c->r[13] -= 16u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[14]); /* push {r4, r5, r6, lr} */
273174: L_1008e3dc:
273175:     c->r[6] = c->r[0]; /* mov r6, r0 */
273176: L_1008e3e0:
273177:     c->r[5] = ngage_r32(c, (c->r[6] + 192u)); /* ldr r5, [r6, #0xc0] */
273178: L_1008e3e4:
273179:     ngage_sub_flags(c, c->r[5], 0x00000000u); /* cmp r5, #0 */
273180: L_1008e3e8:
273181:     if (ngage_zf(c)) { goto L_1008e428; } /* beq 0x8e428 <shadowkey_code+0x8e428> */
273182: L_1008e3ec:
273183:     c->r[3] = ngage_r32(c, c->r[5]); /* ldr r3, [r5] */
273184: L_1008e3f0:
273185:     c->r[4] = ngage_r32(c, c->r[3]); /* ldr r4, [r3] */
273186: L_1008e3f4:
273187:     ngage_sub_flags(c, c->r[4], 0x00000000u); /* cmp r4, #0 */
273188: L_1008e3f8:
273189:     if (ngage_zf(c)) { goto L_1008e41c; } /* beq 0x8e41c <shadowkey_code+0x8e41c> */
273190: L_1008e3fc:
273191:     c->r[0] = ngage_r32(c, c->r[4]); /* ldr r0, [r4] */
273192: L_1008e400:
273193:     c->r[3] = ngage_r32(c, c->r[0]); /* ldr r3, [r0] */
273194: L_1008e404:

## Call 28: caller=sub_1008e974, lifted_line=274031
273961:     c->r[3] = c->r[3] + 0x00000001u; /* add r3, r3, #1 */
273962: L_1008ea00:
273963:     ngage_sub_flags(c, c->r[3], c->r[1]); /* cmp r3, r1 */
273964: L_1008ea04:
273965:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_1008e9f0; } /* blt 0x8e9f0 <shadowkey_code+0x8e9f0> */
273966: L_1008ea08:
273967:     c->r[3] = c->r[2]; /* mov r3, r2 */
273968: L_1008ea0c:
273969:     c->r[1] = ngage_r8(c, c->r[3]); /* ldrb r1, [r3] */
273970: L_1008ea10:
273971:     c->r[2] = ngage_r8(c, (c->r[3] + 1u)); /* ldrb r2, [r3, #0x1] */
273972: L_1008ea14:
273973:     c->r[5] = ngage_r32(c, (c->r[6] + 120u)); /* ldr r5, [r6, #0x78] */
273974: L_1008ea18:
273975:     c->r[3] = ngage_r16(c, (c->r[6] + 152u)); /* ldrh r3, [r6, #152] */
273976: L_1008ea1c:
273977:     c->r[2] = c->r[1] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr r2, r1, r2, lsl #8 */
273978: L_1008ea20:
273979:     ngage_w32(c, (c->r[13] + 36u), (uint32_t)c->r[2]); /* str r2, [sp, #0x24] */
273980: L_1008ea24:
273981:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
273982: L_1008ea28:
273983:     if (ngage_zf(c)) { goto L_1008ea8c; } /* beq 0x8ea8c <shadowkey_code+0x8ea8c> */
273984: L_1008ea2c:
273985:     c->r[4] = ngage_r32(c, (c->r[6] + 112u)); /* ldr r4, [r6, #0x70] */
273986: L_1008ea30:
273987:     c->r[3] = 0x00004700u; /* mov r3, #18176 */
273988: L_1008ea34:
273989:     c->r[3] = c->r[3] + 0x0000009cu; /* add r3, r3, #156 */
273990: L_1008ea38:
273991:     c->r[14] = ngage_r32(c, (c->r[4] + c->r[3])); /* ldr lr, [r4, r3] */
273992: L_1008ea3c:
273993:     ngage_sub_flags(c, c->r[14], 0x00000000u); /* cmp lr, #0 */
273994: L_1008ea40:
273995:     if (ngage_zf(c)) { goto L_1008ea8c; } /* beq 0x8ea8c <shadowkey_code+0x8ea8c> */
273996: L_1008ea44:
273997:     c->r[1] = ngage_r32(c, (c->r[4] + 1152u)); /* ldr r1, [r4, #0x480] */
273998: L_1008ea48:
273999:     ngage_w32(c, c->r[13], (uint32_t)c->r[14]); /* str lr, [sp] */
274000: L_1008ea4c:
274001:     c->r[12] = 0x00000000u; /* mov r12, #0 */
274002: L_1008ea50:
274003:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[12]); /* str r12, [sp, #0x4] */
274004: L_1008ea54:
274005:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[12]); /* str r12, [sp, #0x8] */
274006: L_1008ea58:
274007:     c->r[3] = ngage_r8(c, c->r[14]); /* ldrb r3, [lr] */
274008: L_1008ea5c:
274009:     c->r[0] = ngage_r8(c, (c->r[14] + 1u)); /* ldrb r0, [lr, #0x1] */
274010: L_1008ea60:
274011:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
274012: L_1008ea64:
274013:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
274014: L_1008ea68:
274015:     c->r[2] = ngage_r8(c, (c->r[14] + 2u)); /* ldrb r2, [lr, #0x2] */
274016: L_1008ea6c:
274017:     c->r[0] = ngage_r8(c, (c->r[14] + 3u)); /* ldrb r0, [lr, #0x3] */
274018: L_1008ea70:
274019:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
274020: L_1008ea74:
274021:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
274022: L_1008ea78:
274023:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[12]); /* str r12, [sp, #0x14] */
274024: L_1008ea7c:
274025:     c->r[3] = ngage_r32(c, (c->r[6] + 124u)); /* ldr r3, [r6, #0x7c] */
274026: L_1008ea80:
274027:     c->r[0] = c->r[4]; /* mov r0, r4 */
274028: L_1008ea84:
274029:     c->r[2] = c->r[5]; /* mov r2, r5 */
274030: L_1008ea88:
274031:     c->r[14] = 0x1008ea8cu; ngage_call(c, 0x1006a488u); goto L_1008ea8c; /* bl 0x6a488 <shadowkey_code+0x6a488> */
274032: L_1008ea8c:
274033:     c->r[7] = c->r[13] + 0x00000078u; /* add r7, sp, #120 */
274034: L_1008ea90:
274035:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[7]); /* str r7, [sp, #0x18] */
274036: L_1008ea94:
274037:     ngage_w32(c, (c->r[7] + 4u), (uint32_t)c->r[10]); /* str r10, [r7, #0x4] */
274038: L_1008ea98:
274039:     c->r[8] = 0x00000000u; /* mov r8, #0 */
274040: L_1008ea9c:
274041:     ngage_w32(c, (c->r[7] + 8u), (uint32_t)c->r[8]); /* str r8, [r7, #0x8] */
274042: L_1008eaa0:
274043:     c->r[3] = ngage_r8(c, (c->r[6] + 178u)); /* ldrb r3, [r6, #0xb2] */
274044: L_1008eaa4:
274045:     ngage_sub_flags(c, c->r[3], c->r[8]); /* cmp r3, r8 */
274046: L_1008eaa8:
274047:     if (ngage_zf(c)) { goto L_1008eb00; } /* beq 0x8eb00 <shadowkey_code+0x8eb00> */
274048: L_1008eaac:
274049:     c->r[1] = 0x100f78d4u; /* literal 0x1008eafc */ /* ldr r1, [pc, #0x48] */
274050: L_1008eab0:
274051:     c->r[2] = ngage_r32(c, (c->r[13] + 36u)); /* ldr r2, [sp, #0x24] */
274052: L_1008eab4:
274053:     c->r[5] = c->r[13] + 0x00000038u; /* add r5, sp, #56 */
274054: L_1008eab8:
274055:     c->r[0] = c->r[5]; /* mov r0, r5 */
274056: L_1008eabc:
274057:     c->r[14] = 0x1008eac0u; ngage_call(c, 0x100a0510u); goto L_1008eac0; /* bl 0xa0510 <shadowkey_code+0xa0510> */
274058: L_1008eac0:
274059:     c->r[4] = c->r[13] + 0x0000002cu; /* add r4, sp, #44 */
274060: L_1008eac4:
274061:     ngage_w32(c, (c->r[4] + 4u), (uint32_t)c->r[10]); /* str r10, [r4, #0x4] */
274062: L_1008eac8:
274063:     ngage_w32(c, (c->r[4] + 8u), (uint32_t)c->r[8]); /* str r8, [r4, #0x8] */
274064: L_1008eacc:
274065:     c->r[0] = c->r[4]; /* mov r0, r4 */

## Call 29: caller=sub_1008e974, lifted_line=274225
274155:     c->r[2] = ngage_r8(c, (c->r[7] + 1u)); /* ldrb r2, [r7, #0x1] */
274156: L_1008eb8c:
274157:     c->r[7] = ngage_r32(c, (c->r[13] + 28u)); /* ldr r7, [sp, #0x1c] */
274158: L_1008eb90:
274159:     c->r[3] = ngage_r32(c, (c->r[7] + 8u)); /* ldr r3, [r7, #0x8] */
274160: L_1008eb94:
274161:     c->r[12] = c->r[12] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr r12, r12, r2, lsl #8 */
274162: L_1008eb98:
274163:     c->r[3] = c->r[3] - 0x00000001u; /* sub r3, r3, #1 */
274164: L_1008eb9c:
274165:     ngage_sub_flags(c, c->r[12], c->r[3]); /* cmp r12, r3 */
274166: L_1008eba0:
274167:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_1008ec18; } /* bge 0x8ec18 <shadowkey_code+0x8ec18> */
274168: L_1008eba4:
274169:     c->r[1] = ngage_r8(c, (c->r[6] + 176u)); /* ldrb r1, [r6, #0xb0] */
274170: L_1008eba8:
274171:     c->r[0] = ngage_r8(c, (c->r[9] + 1u)); /* ldrb r0, [r9, #0x1] */
274172: L_1008ebac:
274173:     c->r[14] = ngage_r32(c, (c->r[6] + 112u)); /* ldr lr, [r6, #0x70] */
274174: L_1008ebb0:
274175:     c->r[2] = ngage_r32(c, (c->r[6] + 120u)); /* ldr r2, [r6, #0x78] */
274176: L_1008ebb4:
274177:     c->r[3] = 0x00004700u; /* mov r3, #18176 */
274178: L_1008ebb8:
274179:     c->r[3] = c->r[3] + 0x000000a0u; /* add r3, r3, #160 */
274180: L_1008ebbc:
274181:     c->r[12] = ngage_r32(c, (c->r[14] + c->r[3])); /* ldr r12, [lr, r3] */
274182: L_1008ebc0:
274183:     c->r[1] = c->r[1] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r1, r1, r0, lsl #8 */
274184: L_1008ebc4:
274185:     c->r[2] = c->r[2] + c->r[1]; /* add r2, r2, r1 */
274186: L_1008ebc8:
274187:     c->r[4] = c->r[2] - 0x00000005u; /* sub r4, r2, #5 */
274188: L_1008ebcc:
274189:     ngage_sub_flags(c, c->r[12], c->r[5]); /* cmp r12, r5 */
274190: L_1008ebd0:
274191:     if (ngage_zf(c)) { goto L_1008ec18; } /* beq 0x8ec18 <shadowkey_code+0x8ec18> */
274192: L_1008ebd4:
274193:     c->r[1] = ngage_r32(c, (c->r[14] + 1152u)); /* ldr r1, [lr, #0x480] */
274194: L_1008ebd8:
274195:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
274196: L_1008ebdc:
274197:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[5]); /* str r5, [sp, #0x4] */
274198: L_1008ebe0:
274199:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[5]); /* str r5, [sp, #0x8] */
274200: L_1008ebe4:
274201:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
274202: L_1008ebe8:
274203:     c->r[0] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r0, [r12, #0x1] */
274204: L_1008ebec:
274205:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r3, r3, r0, lsl #8 */
274206: L_1008ebf0:
274207:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
274208: L_1008ebf4:
274209:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
274210: L_1008ebf8:
274211:     c->r[0] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r0, [r12, #0x3] */
274212: L_1008ebfc:
274213:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[0], 0u, 8u, 1u, 0u); /* orr r2, r2, r0, lsl #8 */
274214: L_1008ec00:
274215:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
274216: L_1008ec04:
274217:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[5]); /* str r5, [sp, #0x14] */
274218: L_1008ec08:
274219:     c->r[3] = ngage_r32(c, (c->r[6] + 124u)); /* ldr r3, [r6, #0x7c] */
274220: L_1008ec0c:
274221:     c->r[0] = c->r[14]; /* mov r0, lr */
274222: L_1008ec10:
274223:     c->r[2] = c->r[4]; /* mov r2, r4 */
274224: L_1008ec14:
274225:     c->r[14] = 0x1008ec18u; ngage_call(c, 0x1006a488u); goto L_1008ec18; /* bl 0x6a488 <shadowkey_code+0x6a488> */
274226: L_1008ec18:
274227:     c->r[0] = c->r[13] + 0x00000078u; /* add r0, sp, #120 */
274228: L_1008ec1c:
274229:     c->r[1] = 0x00000002u; /* mov r1, #2 */
274230: L_1008ec20:
274231:     c->r[14] = 0x1008ec24u; ngage_call(c, 0x1008fcccu); goto L_1008ec24; /* bl 0x8fccc <shadowkey_code+0x8fccc> */
274232: L_1008ec24:
274233:     c->r[13] = c->r[13] + 0x00000084u; /* add sp, sp, #132 */
274234: L_1008ec28:
274235:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[9] = ngage_r32(c, c->r[13] + 20u); c->r[10] = ngage_r32(c, c->r[13] + 24u); c->r[14] = ngage_r32(c, c->r[13] + 28u); c->r[13] += 32u; /* pop {r4, r5, r6, r7, r8, r9, r10, lr} */
274236: L_1008ec2c:
274237:     return; /* bx lr */
274238: }
274239: 
274240: void sub_1008ec30(ngage_cpu_t *c) {
274241:     (void)c;
274242:     if (0) { goto L_1008ec30; goto L_1008ec34; goto L_1008ec38; goto L_1008ec3c; goto L_1008ec40; goto L_1008ec44; goto L_1008ec48; goto L_1008ec4c; goto L_1008ec50; goto L_1008ec54; goto L_1008ec58; goto L_1008ec5c; goto L_1008ec60; goto L_1008ec64; goto L_1008ec68; goto L_1008ec6c; goto L_1008ec70; goto L_1008ec74; goto L_1008ec78; goto L_1008ec7c; goto L_1008ec80; goto L_1008ec84; goto L_1008ec88; goto L_1008ec8c; goto L_1008ec90; goto L_1008ecb0; goto L_1008ecb4; goto L_1008ecb8; goto L_1008ecbc; goto L_1008ecc0; goto L_1008ecc4; goto L_1008ecc8; goto L_1008eccc; goto L_1008ecd0; goto L_1008ecd4; goto L_1008ecd8; goto L_1008ecdc; goto L_1008ece0; goto L_1008ece4; goto L_1008ece8; goto L_1008ecec; goto L_1008ecf0; goto L_1008ecf4; goto L_1008ecf8; goto L_1008ecfc; goto L_1008ed00; goto L_1008ed04; goto L_1008ed08; goto L_1008ed0c; goto L_1008ed10; goto L_1008ed14; goto L_1008ed18; goto L_1008ed1c; goto L_1008ed20; goto L_1008ed24; goto L_1008ed28; goto L_1008ed2c; goto L_1008ed30; goto L_1008ed34; goto L_1008ed38; goto L_1008ed3c; goto L_1008ed40; goto L_1008ed44; goto L_1008ed48; goto L_1008ed4c; goto L_1008ed50; goto L_1008ed54; goto L_1008ed58; goto L_1008ed5c; goto L_1008ed60; goto L_1008ed64; goto L_1008ed68; goto L_1008ed6c; goto L_1008ed70; goto L_1008ed74; goto L_1008ed78; goto L_1008ed7c; goto L_1008ed80; goto L_1008ed84; goto L_1008ed88; goto L_1008ed8c; goto L_1008ed90; goto L_1008ed94; goto L_1008ed98; goto L_1008ed9c; goto L_1008eda0; goto L_1008eda4; goto L_1008eda8; goto L_1008edac; goto L_1008edb0; goto L_1008edb4; goto L_1008edb8; goto L_1008edbc; goto L_1008edc0; goto L_1008edc4; goto L_1008edc8; goto L_1008edcc; goto L_1008edd0; goto L_1008edd4; goto L_1008edd8; goto L_1008eddc; goto L_1008ede4; goto L_1008ede8; goto L_1008edec; goto L_1008edf0; goto L_1008edf4; goto L_1008edf8; goto L_1008edfc; goto L_1008ee00; goto L_1008ee04; goto L_1008ee08; goto L_1008ee0c; goto L_1008ee10; goto L_1008ee14; goto L_1008ee18; goto L_1008ee1c; goto L_1008ee20; goto L_1008ee24; goto L_1008ee28; goto L_1008ee2c; goto L_1008ee30; goto L_1008ee34; goto L_1008ee38; goto L_1008ee3c; goto L_1008ee40; goto L_1008ee44; goto L_1008ee48; goto L_1008ee4c; goto L_1008ee50; goto L_1008ee54; goto L_1008ee58; goto L_1008ee5c; goto L_1008ee60; goto L_1008ee64; goto L_1008ee68; goto L_1008ee6c; goto L_1008ee70; goto L_1008ee74; goto L_1008ee78; goto L_1008ee7c; goto L_1008ee80; goto L_1008ee84; goto L_1008ee88; goto L_1008ee90; goto L_1008ee94; goto L_1008ee98; goto L_1008ee9c; goto L_1008eea0; goto L_1008eea4; goto L_1008eea8; goto L_1008eeac; goto L_1008eeb0; }
274243: L_1008ec30:
274244:     c->r[13] -= 28u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[10]); ngage_w32(c, c->r[13] + 24u, c->r[14]); /* push {r4, r5, r6, r7, r8, r10, lr} */
274245: L_1008ec34:
274246:     c->r[12] = 0x100f7760u; /* literal 0x1008ecac */ /* ldr r12, [pc, #0x70] */
274247: L_1008ec38:
274248:     c->r[13] = c->r[13] - 0x00000010u; /* sub sp, sp, #16 */
274249: L_1008ec3c:
274250:     c->r[6] = c->r[1]; /* mov r6, r1 */
274251: L_1008ec40:
274252:     c->r[1] = ngage_r32(c, (c->r[6] + 4u)); /* ldr r1, [r6, #0x4] */
274253: L_1008ec44:
274254:     c->r[8] = ngage_r32(c, (c->r[13] + 44u)); /* ldr r8, [sp, #0x2c] */
274255: L_1008ec48:
274256:     c->r[5] = c->r[0]; /* mov r5, r0 */
274257: L_1008ec4c:
274258:     c->r[4] = c->r[2]; /* mov r4, r2 */
274259: L_1008ec50:

## Call 30: caller=sub_100a0cec, lifted_line=313275
313205:     c->r[14] = 0x100a132cu; ngage_call(c, 0x1007f49cu); goto L_100a132c; /* bl 0x7f49c <shadowkey_code+0x7f49c> */
313206: L_100a132c:
313207:     goto L_100a1358; /* b 0xa1358 <shadowkey_code+0xa1358> */
313208: L_100a1334:
313209:     c->r[0] = c->r[4]; /* mov r0, r4 */
313210: L_100a1338:
313211:     c->r[14] = 0x100a133cu; ngage_call(c, 0x1002ed94u); goto L_100a133c; /* bl 0x2ed94 <shadowkey_code+0x2ed94> */
313212: L_100a133c:
313213:     c->r[3] = ngage_r32(c, (c->r[9] + 56u)); /* ldr r3, [r9, #0x38] */
313214: L_100a1340:
313215:     c->r[2] = ngage_r8(c, (c->r[3] + 12u)); /* ldrb r2, [r3, #0xc] */
313216: L_100a1344:
313217:     c->r[1] = ngage_r8(c, (c->r[3] + 13u)); /* ldrb r1, [r3, #0xd] */
313218: L_100a1348:
313219:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r2, r2, r1, lsl #8 */
313220: L_100a134c:
313221:     ngage_sub_flags(c, c->r[0], c->r[2]); /* cmp r0, r2 */
313222: L_100a1350:
313223:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { c->r[5] = 0x00000018u; } /* movgt r5, #24 */
313224: L_100a1354:
313225:     if ((ngage_zf(c) || ngage_nf(c) != ngage_vf(c))) { c->r[5] = 0x00000019u; } /* movle r5, #25 */
313226: L_100a1358:
313227:     ngage_add_flags(c, c->r[5], 0x00000001u, 0); /* cmn r5, #1 */
313228: L_100a135c:
313229:     if (ngage_zf(c)) { goto L_100a14dc; } /* beq 0xa14dc <shadowkey_code+0xa14dc> */
313230: L_100a1360:
313231:     c->r[3] = c->r[10] + 0x00004400u; /* add r3, r10, #17408 */
313232: L_100a1364:
313233:     c->r[3] = c->r[3] + 0x00000060u; /* add r3, r3, #96 */
313234: L_100a1368:
313235:     c->r[12] = ngage_r32(c, (c->r[3] + (c->r[5] << 2))); /* ldr r12, [r3, r5, lsl #2] */
313236: L_100a136c:
313237:     ngage_sub_flags(c, c->r[12], 0x00000000u); /* cmp r12, #0 */
313238: L_100a1370:
313239:     if (ngage_zf(c)) { goto L_100a14dc; } /* beq 0xa14dc <shadowkey_code+0xa14dc> */
313240: L_100a1374:
313241:     ngage_w32(c, c->r[13], (uint32_t)c->r[12]); /* str r12, [sp] */
313242: L_100a1378:
313243:     c->r[0] = 0x00000000u; /* mov r0, #0 */
313244: L_100a137c:
313245:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[0]); /* str r0, [sp, #0x4] */
313246: L_100a1380:
313247:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[0]); /* str r0, [sp, #0x8] */
313248: L_100a1384:
313249:     c->r[3] = ngage_r8(c, c->r[12]); /* ldrb r3, [r12] */
313250: L_100a1388:
313251:     c->r[1] = ngage_r8(c, (c->r[12] + 1u)); /* ldrb r1, [r12, #0x1] */
313252: L_100a138c:
313253:     c->r[3] = c->r[3] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r3, r3, r1, lsl #8 */
313254: L_100a1390:
313255:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[3]); /* str r3, [sp, #0xc] */
313256: L_100a1394:
313257:     c->r[2] = ngage_r8(c, (c->r[12] + 2u)); /* ldrb r2, [r12, #0x2] */
313258: L_100a1398:
313259:     c->r[1] = ngage_r8(c, (c->r[12] + 3u)); /* ldrb r1, [r12, #0x3] */
313260: L_100a139c:
313261:     c->r[2] = c->r[2] | shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u); /* orr r2, r2, r1, lsl #8 */
313262: L_100a13a0:
313263:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[2]); /* str r2, [sp, #0x10] */
313264: L_100a13a4:
313265:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[0]); /* str r0, [sp, #0x14] */
313266: L_100a13a8:
313267:     c->r[3] = ngage_r32(c, (c->r[13] + 1624u)); /* ldr r3, [sp, #0x658] */
313268: L_100a13ac:
313269:     c->r[2] = ngage_r32(c, (c->r[13] + 1620u)); /* ldr r2, [sp, #0x654] */
313270: L_100a13b0:
313271:     c->r[1] = ngage_r32(c, (c->r[10] + 1152u)); /* ldr r1, [r10, #0x480] */
313272: L_100a13b4:
313273:     c->r[0] = c->r[10]; /* mov r0, r10 */
313274: L_100a13b8:
313275:     c->r[14] = 0x100a13bcu; ngage_call(c, 0x1006a488u); goto L_100a13bc; /* bl 0x6a488 <shadowkey_code+0x6a488> */
313276: L_100a13bc:
313277:     goto L_100a14dc; /* b 0xa14dc <shadowkey_code+0xa14dc> */
313278: L_100a13c0:
313279:     c->r[3] = ngage_r32(c, (c->r[9] + 60u)); /* ldr r3, [r9, #0x3c] */
313280: L_100a13c4:
313281:     c->r[4] = ngage_r32(c, (c->r[10] + 1560u)); /* ldr r4, [r10, #0x618] */
313282: L_100a13c8:
313283:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
313284: L_100a13cc:
313285:     c->r[1] = c->r[3]; /* mov r1, r3 */
313286: L_100a13d0:
313287:     if (ngage_zf(c)) { goto L_100a13e8; } /* beq 0xa13e8 <shadowkey_code+0xa13e8> */
313288: L_100a13d4:
313289:     c->r[0] = c->r[4]; /* mov r0, r4 */
313290: L_100a13d8:
313291:     c->r[14] = 0x100a13dcu; ngage_call(c, 0x100453e0u); goto L_100a13dc; /* bl 0x453e0 <shadowkey_code+0x453e0> */
313292: L_100a13dc:
313293:     ngage_set_nz(c, c->r[0] & 0x000000ffu); /* tst r0, #255 */
313294: L_100a13e0:
313295:     if (!ngage_zf(c)) { goto L_100a142c; } /* bne 0xa142c <shadowkey_code+0xa142c> */
313296: L_100a13e4:
313297:     c->r[1] = ngage_r32(c, (c->r[9] + 60u)); /* ldr r1, [r9, #0x3c] */
313298: L_100a13e8:
313299:     ngage_sub_flags(c, c->r[1], 0x00000000u); /* cmp r1, #0 */
313300: L_100a13ec:
313301:     if (!ngage_zf(c)) { goto L_100a1414; } /* bne 0xa1414 <shadowkey_code+0xa1414> */
313302: L_100a13f0:
313303:     c->r[3] = ngage_r32(c, (c->r[9] + 56u)); /* ldr r3, [r9, #0x38] */
313304: L_100a13f4:
313305:     c->r[2] = ngage_r8(c, c->r[3]); /* ldrb r2, [r3] */
313306: L_100a13f8:
313307:     c->r[1] = ngage_r8(c, (c->r[3] + 1u)); /* ldrb r1, [r3, #0x1] */
313308: L_100a13fc:
313309:     c->r[0] = c->r[4]; /* mov r0, r4 */
---

## global.spr resource identity check

---
global.spr size=1646707 bytes
resource[0xF8] candidate offset=0x9444
candidate dimensions=45189x34222
candidate header/palette prefix=85 b0 ae 85 b2 b0 b2 ae b2 b2 b0 b0 b0 b0 6e b5 b0 b0 b0 b0 99 b0 b0 b0 b0 88 b0 b0 b0 b0 b0 6e b0 b0 b0 b0 b0 b0 b0 6e b5 b0 6e b0 b0 b4 6e 99 b4 99 99 4c 9c 9c c4 9e 81 69 84 6d 98 70 70 9b
candidate payload prefix=b0 b0 96 b0 b0 b0 b0 b0 ae b0 ae b2 b0 85 b2 b2 b0 ae 85 b2 b2 b0 b2 b0 b2 b2 ae b2 ae b2 ae 85 b0 b2 b0 b0 b0 b0 b0 6e b0 b0 b0 b0 b0 b0 b0 b0 b0 b0 b0 b0 85 b0 b0 b0 b0 85 b0 b0 b0 b0 85 b0
runtime header expected=b0 00 d0 00 01 0c 01 0b 11 0f 01 0b ...
header_match_176x208=False
offset-table candidates containing entry[0xF8]=0x9444: 5
table_entry_filepos=0x3e0 table_base=0x0 prev=0x9444 this=0x9444 next=0x9444 resource_bytes=0
table_entry_filepos=0x3e4 table_base=0x4 prev=0x9444 this=0x9444 next=0x9444 resource_bytes=0
table_entry_filepos=0x3e8 table_base=0x8 prev=0x9444 this=0x9444 next=0x9444 resource_bytes=0
table_entry_filepos=0x3ec table_base=0xc prev=0x9444 this=0x9444 next=0x9444 resource_bytes=0
table_entry_filepos=0x3f0 table_base=0x10 prev=0x9444 this=0x9444 next=0x0 resource_bytes=-1
---

## Raw framebuffer capture

---
PNG .build/live_run_bitmap.png: 176x233, RGB565 mode=10, stride=352, nonzero_pixels=3491/41008, bitmap=0x10110718, pixels=0x10311000
---

## Guest pixel writer source at PC 0x100677d0 (stale interpreter PC; active guest function 0x1006a488)

---
Function sub_1006a488: 267 source lines
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
181: L_1006a5e8:
182:     c->r[3] = (c->r[3] << 1); /* lsl r3, r3, #1 */
183: L_1006a5ec:
184:     c->r[1] = ngage_r8(c, (c->r[3] + c->r[9])); /* ldrb r1, [r3, r9] */
185: L_1006a5f0:
186:     c->r[7] = ngage_r32(c, c->r[13]); /* ldr r7, [sp] */
187: L_1006a5f4:
188:     c->r[3] = c->r[3] + c->r[9]; /* add r3, r3, r9 */
189: L_1006a5f8:
190:     c->r[2] = ngage_r8(c, (c->r[3] + 1u)); /* ldrb r2, [r3, #0x1] */
191: L_1006a5fc:
192:     c->r[9] = ngage_r32(c, (c->r[13] + 28u)); /* ldr r9, [sp, #0x1c] */
193: L_1006a600:
194:     c->r[14] = c->r[1] | shadowkey_arm_shift_operand(c, c->r[2], 0u, 8u, 1u, 0u); /* orr lr, r1, r2, lsl #8 */
195: L_1006a604:
196:     ngage_sub_flags(c, c->r[14], c->r[7]); /* cmp lr, r7 */
197: L_1006a608:
198:     c->r[1] = c->r[9] + c->r[0]; /* add r1, r9, r0 */
199: L_1006a60c:
200:     if (ngage_zf(c)) { goto L_1006a650; } /* beq 0x6a650 <shadowkey_code+0x6a650> */
201: L_1006a610:
202:     c->r[7] = ngage_r32(c, (c->r[13] + 88u)); /* ldr r7, [sp, #0x58] */
203: L_1006a614:
204:     ngage_sub_flags(c, c->r[7], 0x00000000u); /* cmp r7, #0 */
205: L_1006a618:
206:     if (ngage_zf(c)) { goto L_1006a628; } /* beq 0x6a628 <shadowkey_code+0x6a628> */
207: L_1006a61c:
208:     ngage_sub_flags(c, c->r[7], 0x00000001u); /* cmp r7, #1 */
209: L_1006a620:
210:     if (ngage_zf(c)) { goto L_1006a634; } /* beq 0x6a634 <shadowkey_code+0x6a634> */
211: L_1006a624:
212:     goto L_1006a650; /* b 0x6a650 <shadowkey_code+0x6a650> */
213: L_1006a628:
214:     c->r[3] = (c->r[1] << 1); /* lsl r3, r1, #1 */
215: L_1006a62c:
216:     ngage_w16(c, (c->r[3] + c->r[6]), (uint16_t)c->r[14]); /* strh lr, [r3, r6] */
217: L_1006a630:
218:     goto L_1006a650; /* b 0x6a650 <shadowkey_code+0x6a650> */
219: L_1006a634:
220:     c->r[1] = (c->r[1] << 1); /* lsl r1, r1, #1 */
221: L_1006a638:
222:     c->r[2] = ngage_r16(c, (c->r[1] + c->r[6])); /* ldrh r2, [r1, r6] */
223: L_1006a63c:
224:     c->r[3] = c->r[14] & c->r[12]; /* and r3, lr, r12 */
225: L_1006a640:
226:     c->r[2] = c->r[2] & c->r[12]; /* and r2, r2, r12 */
227: L_1006a644:
228:     c->r[3] = c->r[3] + c->r[2]; /* add r3, r3, r2 */
229: L_1006a648:
230:     c->r[3] = ((uint32_t)((int32_t)c->r[3] >> 1)); /* asr r3, r3, #1 */
231: L_1006a64c:
232:     ngage_w16(c, (c->r[1] + c->r[6]), (uint16_t)c->r[3]); /* strh r3, [r1, r6] */
233: L_1006a650:
234:     c->r[4] = c->r[4] + 0x00000001u; /* add r4, r4, #1 */
235: L_1006a654:
236:     ngage_sub_flags(c, c->r[4], c->r[8]); /* cmp r4, r8 */
237: L_1006a658:
238:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_1006a5d8; } /* blt 0x6a5d8 <shadowkey_code+0x6a5d8> */
239: L_1006a65c:
240:     c->r[9] = ngage_r32(c, (c->r[13] + 12u)); /* ldr r9, [sp, #0xc] */
241: L_1006a660:
242:     c->r[3] = c->r[9] + 0x00000001u; /* add r3, r9, #1 */
243: L_1006a664:
244:     ngage_sub_flags(c, c->r[3], 0x000000cfu); /* cmp r3, #207 */
245: L_1006a668:
246:     if ((!ngage_zf(c) && ngage_nf(c) == ngage_vf(c))) { goto L_1006a684; } /* bgt 0x6a684 <shadowkey_code+0x6a684> */
247: L_1006a66c:
248:     { uint32_t _b = c->r[13]; c->r[7] = ngage_r32(c, _b + 4u); c->r[9] = ngage_r32(c, _b + 8u); } /* ldmib sp, {r7, r9} */
249: L_1006a670:
250:     c->r[4] = c->r[7] + c->r[9]; /* add r4, r7, r9 */
251: L_1006a674:
252:     c->r[7] = ngage_r32(c, (c->r[13] + 84u)); /* ldr r7, [sp, #0x54] */
253: L_1006a678:
254:     c->r[10] = c->r[10] + 0x00000001u; /* add r10, r10, #1 */
255: L_1006a67c:
256:     ngage_sub_flags(c, c->r[10], c->r[7]); /* cmp r10, r7 */
257: L_1006a680:
258:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_1006a534; } /* blt 0x6a534 <shadowkey_code+0x6a534> */
259: L_1006a684:
260:     c->r[13] = c->r[13] + 0x00000024u; /* add sp, sp, #36 */
261: L_1006a688:
262:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[9] = ngage_r32(c, c->r[13] + 20u); c->r[10] = ngage_r32(c, c->r[13] + 24u); c->r[14] = ngage_r32(c, c->r[13] + 28u); c->r[13] += 32u; /* pop {r4, r5, r6, r7, r8, r9, r10, lr} */
263: L_1006a68c:
264:     { uint32_t nz=0; uint8_t *dp=(imgdec_dest>=0x10000000u && imgdec_dest+82016u<=0x10400000u)?c->mem+(imgdec_dest-0x10000000u):NULL; if(dp)for(uint32_t i=0;i<82016u;i++)if(dp[i])nz++; fprintf(stderr,"IMGDEC RESULT dest=%08x nonzero_bytes=%u buffer_bytes=82016\n",imgdec_dest,nz); }
265:     return; /* bx lr */
266: }
267: 
---

## Runtime evidence

---
  CONE160 FORENSIC hidden-result=102fed24 this=101102c8 sp=102fed18 lr=10021404\n  TRACE CONE160 hidden-result PRE @102fed24: 53 70 61 63 65 20 69 6e
  TRACE CONE160 control object prefix @101102c8: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 80 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102fed24 r1=101102c8 r2=0000039c r3=000003ad)
BITMAP CPU WRITE WATCH armed 10311000..10325060 (82016 bytes)
TRACE resource index=000000f8 table=1026c358 offset=00009444
TRACE loaded resource r0=1026c958 engine=101102c8
IMGDEC ENTER fn=1006a488 r0=10111288 r1(dest)=10311000 r2=00000000 r3=00000000 sp=102febec lr=10024c78\nIMGDEC stack[00]=1026c958\nIMGDEC stack[04]=00000000\nIMGDEC stack[08]=00000000\nIMGDEC stack[0c]=000000b0\nIMGDEC stack[10]=000000d0\nIMGDEC stack[14]=00000000\nIMGDEC stack[18]=00000000\nIMGDEC stack[1c]=00000000\nIMGDEC stack[20]=00000000\nIMGDEC stack[24]=00000000\nIMGDEC stack[28]=00000000\nIMGDEC stack[2c]=00000000\nIMGDEC source_base=1026c958 payload=1026cb5c\nIMGDEC header[000]=00d000b0\nIMGDEC header[004]=0b010c01\nIMGDEC header[008]=0f110b01\nIMGDEC header[00c]=0e110e11\nIMGDEC header[010]=0d110d11\nIMGDEC header[014]=07000800\nIMGDEC header[018]=0a010700\nIMGDEC header[01c]=09010901\nIMGDEC header[020]=06000c11\nIMGDEC header[024]=03000600\nIMGDEC header[028]=01000200\nIMGDEC header[02c]=00000100\nIMGDEC header[030]=05000000\nIMGDEC header[034]=04000500\nIMGDEC header[038]=04000800\nIMGDEC header[03c]=0eee0fff\nIMGDEC payload[000]=00b00000\nIMGDEC payload[004]=3b3b3b3b\nIMGDEC payload[008]=3b3b3b3b\nIMGDEC payload[00c]=3b3b3b3b\nIMGDEC payload[010]=3b3b3b3b\nIMGDEC payload[014]=3b3b3b3b\nIMGDEC payload[018]=3b3b3b3b\nIMGDEC payload[01c]=3b3b3b3b\nIMGDEC payload[020]=3b3b3b3b\nIMGDEC payload[024]=3b3b3b3b\nIMGDEC payload[028]=3b3b3b3b\nIMGDEC payload[02c]=3b3b3b3b\nIMGDEC payload[030]=3b3b3b3b\nIMGDEC payload[034]=3b3b3b3b\nIMGDEC payload[038]=3b3b3b3b\nIMGDEC payload[03c]=3b3b3b3b\nIMGDEC RESULT dest=10311000 nonzero_bytes=6909 buffer_bytes=82016
IMGDEC EXIT fn=1006a488 r0=000000af r1=000000af r2=00000000 r3=000000d0 sp=102febec lr=10024c78\nIMPORT dll=CONE[10003a41].DLL ord=226 r0=101102c8 r1=000000af r2=00000000 r3=000000d0 sp=102feaac lr=100228a8 cpsr=20000000
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
