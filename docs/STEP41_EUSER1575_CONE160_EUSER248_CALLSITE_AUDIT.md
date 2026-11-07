# Step 41 — EUSER1575 / CONE160 / EUSER248 callsite audit

Generated from the extracted 6R51.APP lifted source and import dispatch table.

- Lifted source: 16397565 bytes; 323977 lines

## Import-thunk mapping

{ 0x1009f240u, 0x101007e8u, "EUSER[100039e5].DLL", 1575u },
{ 0x1009f510u, 0x1010040cu, "CONE[10003a41].DLL", 160u },
{ 0x1009f220u, 0x101006b8u, "EUSER[100039e5].DLL", 248u },

## Recovered callsites

### EUSER ordinal 1575

Static references: 1

#### Call 1 — lifted line 66887

SOURCE BEGIN
66837:     c->r[9] = c->r[0]; /* mov r9, r0 */
66838: L_100228ac:
66839:     c->r[4] = ngage_r32(c, c->r[9]); /* ldr r4, [r9] */
66840: L_100228b0:
66841:     c->r[0] = c->r[8]; /* mov r0, r8 */
66842: L_100228b4:
66843:     c->r[14] = 0x100228b8u; ngage_call(c, 0x1009f560u); goto L_100228b8; /* bl 0x9f560 <shadowkey_code+0x9f560> */
66844: L_100228b8:
66845:     c->r[1] = c->r[0]; /* mov r1, r0 */
66846: L_100228bc:
66847:     c->r[0] = c->r[9]; /* mov r0, r9 */
66848: L_100228c0:
66849:     c->r[12] = ngage_r32(c, (c->r[4] + 216u)); /* ldr r12, [r4, #0xd8] */
66850: L_100228c4:
66851:     c->r[14] = 0x100228ccu; /* mov lr, pc (ARM PC semantics) */
66852: L_100228c8:
66853:     ngage_call(c, c->r[12]); goto L_100228cc; /* bx r12 */
66854: L_100228cc:
66855:     c->r[3] = c->r[8] + 0x00000320u; /* add r3, r8, #800 */
66856: L_100228d0:
66857:     { uint32_t _b = c->r[3]; c->r[6] = ngage_r32(c, _b); c->r[7] = ngage_r32(c, _b + 4u); } /* ldm r3, {r6, r7} */
66858: L_100228d4:
66859:     c->r[10] = c->r[13] + 0x00000034u; /* add r10, sp, #52 */
66860: L_100228d8:
66861:     { uint32_t _b = c->r[10]; ngage_w32(c, _b, c->r[6]); ngage_w32(c, _b + 4u, c->r[7]); } /* stm r10, {r6, r7} */
66862: L_100228dc:
66863:     c->r[0] = c->r[13] + 0x000000d0u; /* add r0, sp, #208 */
66864: L_100228e0:
66865:     c->r[1] = 0x00000032u; /* mov r1, #50 */
66866: L_100228e4:
66867:     c->r[14] = 0x100228e8u; ngage_call(c, 0x1009f1e0u); goto L_100228e8; /* bl 0x9f1e0 <shadowkey_code+0x9f1e0> */
66868: L_100228e8:
66869:     c->r[0] = c->r[13] + 0x00000094u; /* add r0, sp, #148 */
66870: L_100228ec:
66871:     c->r[1] = 0x00000032u; /* mov r1, #50 */
66872: L_100228f0:
66873:     c->r[14] = 0x100228f4u; ngage_call(c, 0x1009f1e0u); goto L_100228f4; /* bl 0x9f1e0 <shadowkey_code+0x9f1e0> */
66874: L_100228f4:
66875:     c->r[0] = c->r[13] + 0x00000058u; /* add r0, sp, #88 */
66876: L_100228f8:
66877:     c->r[1] = 0x00000032u; /* mov r1, #50 */
66878: L_100228fc:
66879:     c->r[14] = 0x10022900u; ngage_call(c, 0x1009f1e0u); goto L_10022900; /* bl 0x9f1e0 <shadowkey_code+0x9f1e0> */
66880: L_10022900:
66881:     c->r[0] = c->r[10]; /* mov r0, r10 */
66882: L_10022904:
66883:     c->r[5] = c->r[8] + 0x00000310u; /* add r5, r8, #784 */
66884: L_10022908:
66885:     c->r[1] = c->r[5]; /* mov r1, r5 */
66886: L_1002290c:
66887:     c->r[14] = 0x10022910u; ngage_call(c, 0x1009f240u); goto L_10022910; /* bl 0x9f240 <shadowkey_code+0x9f240> */
66888: L_10022910:
66889:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
66890: L_10022914:
66891:     if (ngage_zf(c)) { goto L_10022a4c; } /* beq 0x22a4c <shadowkey_code+0x22a4c> */
66892: L_10022918:
66893:     c->r[7] = c->r[8] + 0x00000318u; /* add r7, r8, #792 */
66894: L_1002291c:
66895:     { uint32_t _b = c->r[7]; c->r[4] = ngage_r32(c, _b); c->r[7] = ngage_r32(c, _b + 4u); } /* ldm r7, {r4, r7} */
66896: L_10022920:
66897:     c->r[4] = c->r[4] - c->r[7]; /* sub r4, r4, r7 */
66898: L_10022924:
66899:     c->r[6] = c->r[13] + 0x0000002cu; /* add r6, sp, #44 */
66900: L_10022928:
66901:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[6]); /* str r6, [sp, #0x14] */
66902: L_1002292c:
66903:     c->r[0] = c->r[6]; /* mov r0, r6 */
66904: L_10022930:
66905:     c->r[1] = c->r[10]; /* mov r1, r10 */
66906: L_10022934:
66907:     c->r[2] = c->r[5]; /* mov r2, r5 */
66908: L_10022938:
66909:     c->r[14] = 0x1002293cu; ngage_call(c, 0x1009f250u); goto L_1002293c; /* bl 0x9f250 <shadowkey_code+0x9f250> */
66910: L_1002293c:
66911:     c->r[7] = c->r[13] + 0x00000024u; /* add r7, sp, #36 */
66912: L_10022940:
66913:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[7]); /* str r7, [sp, #0x18] */
66914: L_10022944:
66915:     c->r[0] = c->r[7]; /* mov r0, r7 */
66916: L_10022948:
66917:     c->r[1] = 0x000003e8u; /* mov r1, #1000 */
66918: L_1002294c:
66919:     c->r[14] = 0x10022950u; ngage_call(c, 0x1009f260u); goto L_10022950; /* bl 0x9f260 <shadowkey_code+0x9f260> */
66920: L_10022950:
66921:     c->r[1] = c->r[13] + 0x00000014u; /* add r1, sp, #20 */
66922: L_10022954:
66923:     { uint32_t _b = c->r[1]; c->r[1] = ngage_r32(c, _b); c->r[2] = ngage_r32(c, _b + 4u); } /* ldm r1, {r1, r2} */
66924: L_10022958:
66925:     c->r[5] = c->r[13] + 0x0000001cu; /* add r5, sp, #28 */
66926: L_1002295c:
66927:     c->r[0] = c->r[5]; /* mov r0, r5 */
SOURCE END

### CONE ordinal 160

Static references: 4

#### Call 1 — lifted line 64261

SOURCE BEGIN
64211:     c->r[14] = 0x100213a0u; ngage_call(c, 0x100a0510u); goto L_100213a0; /* bl 0xa0510 <shadowkey_code+0xa0510> */
64212: L_100213a0:
64213:     c->r[0] = 0x00002700u; /* mov r0, #9984 */
64214: L_100213a4:
64215:     c->r[0] = c->r[0] + 0x00000010u; /* add r0, r0, #16 */
64216: L_100213a8:
64217:     c->r[14] = 0x100213acu; ngage_call(c, 0x1009ee20u); goto L_100213ac; /* bl 0x9ee20 <shadowkey_code+0x9ee20> */
64218: L_100213ac:
64219:     ngage_w32(c, (c->r[7] + 52u), (uint32_t)c->r[5]); /* str r5, [r7, #0x34] */
64220: L_100213b0:
64221:     c->r[3] = ~(0x00000000u); /* mvn r3, #0 */
64222: L_100213b4:
64223:     ngage_w32(c, (c->r[7] + 920u), (uint32_t)c->r[3]); /* str r3, [r7, #0x398] */
64224: L_100213b8:
64225:     c->r[2] = 0x0000039cu; /* mov r2, #924 */
64226: L_100213bc:
64227:     c->r[4] = 0x00000000u; /* mov r4, #0 */
64228: L_100213c0:
64229:     ngage_w8(c, (c->r[7] + c->r[2]), (uint8_t)c->r[4]); /* strb r4, [r7, r2] */
64230: L_100213c4:
64231:     c->r[3] = 0x000003acu; /* mov r3, #940 */
64232: L_100213c8:
64233:     ngage_w8(c, (c->r[7] + c->r[3]), (uint8_t)c->r[4]); /* strb r4, [r7, r3] */
64234: L_100213cc:
64235:     c->r[3] = c->r[3] + 0x00000001u; /* add r3, r3, #1 */
64236: L_100213d0:
64237:     ngage_w8(c, (c->r[7] + c->r[3]), (uint8_t)c->r[4]); /* strb r4, [r7, r3] */
64238: L_100213d4:
64239:     ngage_w32(c, (c->r[7] + 904u), (uint32_t)c->r[4]); /* str r4, [r7, #0x388] */
64240: L_100213d8:
64241:     ngage_w32(c, (c->r[7] + 808u), (uint32_t)c->r[4]); /* str r4, [r7, #0x328] */
64242: L_100213dc:
64243:     ngage_w32(c, (c->r[7] + 812u), (uint32_t)c->r[4]); /* str r4, [r7, #0x32c] */
64244: L_100213e0:
64245:     c->r[0] = c->r[7]; /* mov r0, r7 */
64246: L_100213e4:
64247:     c->r[14] = 0x100213e8u; ngage_call(c, 0x1009f4f0u); goto L_100213e8; /* bl 0x9f4f0 <shadowkey_code+0x9f4f0> */
64248: L_100213e8:
64249:     c->r[0] = c->r[7]; /* mov r0, r7 */
64250: L_100213ec:
64251:     c->r[1] = c->r[8]; /* mov r1, r8 */
64252: L_100213f0:
64253:     c->r[14] = 0x100213f4u; ngage_call(c, 0x1009f500u); goto L_100213f4; /* bl 0x9f500 <shadowkey_code+0x9f500> */
64254: L_100213f4:
64255:     c->r[5] = c->r[13] + 0x0000000cu; /* add r5, sp, #12 */
64256: L_100213f8:
64257:     c->r[0] = c->r[5]; /* mov r0, r5 */
64258: L_100213fc:
64259:     c->r[1] = c->r[7]; /* mov r1, r7 */
64260: L_10021400:
64261:     c->r[14] = 0x10021404u; ngage_call(c, 0x1009f510u); goto L_10021404; /* bl 0x9f510 <shadowkey_code+0x9f510> */
64262: L_10021404:
64263:     c->r[6] = c->r[13]; /* mov r6, sp */
64264: L_10021408:
64265:     c->r[0] = c->r[6]; /* mov r0, r6 */
64266: L_1002140c:
64267:     c->r[1] = c->r[5]; /* mov r1, r5 */
64268: L_10021410:
64269:     c->r[14] = 0x10021414u; ngage_call(c, 0x1009f200u); goto L_10021414; /* bl 0x9f200 <shadowkey_code+0x9f200> */
64270: L_10021414:
64271:     c->r[3] = 0x000000b0u; /* mov r3, #176 */
64272: L_10021418:
64273:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
64274: L_1002141c:
64275:     c->r[2] = 0x000000e9u; /* mov r2, #233 */
64276: L_10021420:
64277:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
64278: L_10021424:
64279:     { uint32_t _b = c->r[6]; c->r[0] = ngage_r32(c, _b); c->r[1] = ngage_r32(c, _b + 4u); } /* ldm r6, {r0, r1} */
64280: L_10021428:
64281:     c->r[2] = 0x0000000au; /* mov r2, #10 */
64282: L_1002142c:
64283:     c->r[14] = 0x10021430u; ngage_call(c, 0x1000b9c8u); goto L_10021430; /* bl 0xb9c8 <shadowkey_code+0xb9c8> */
64284: L_10021430:
64285:     ngage_w32(c, (c->r[7] + 740u), (uint32_t)c->r[0]); /* str r0, [r7, #0x2e4] */
64286: L_10021434:
64287:     c->r[14] = 0x10021438u; ngage_call(c, 0x1000ba7cu); goto L_10021438; /* bl 0xba7c <shadowkey_code+0xba7c> */
64288: L_10021438:
64289:     ngage_w32(c, (c->r[7] + 744u), (uint32_t)c->r[0]); /* str r0, [r7, #0x2e8] */
64290: L_1002143c:
64291:     c->r[14] = 0x10021440u; ngage_call(c, 0x1000bab8u); goto L_10021440; /* bl 0xbab8 <shadowkey_code+0xbab8> */
64292: L_10021440:
64293:     ngage_w32(c, (c->r[7] + 748u), (uint32_t)c->r[0]); /* str r0, [r7, #0x2ec] */
64294: L_10021444:
64295:     ngage_w32(c, (c->r[7] + 868u), (uint32_t)c->r[4]); /* str r4, [r7, #0x364] */
64296: L_10021448:
64297:     ngage_w32(c, (c->r[7] + 872u), (uint32_t)c->r[4]); /* str r4, [r7, #0x368] */
64298: L_1002144c:
64299:     ngage_w32(c, (c->r[7] + 876u), (uint32_t)c->r[4]); /* str r4, [r7, #0x36c] */
64300: L_10021450:
64301:     ngage_w32(c, (c->r[7] + 880u), (uint32_t)c->r[4]); /* str r4, [r7, #0x370] */
SOURCE END

#### Call 2 — lifted line 65410

SOURCE BEGIN
65360:     c->r[1] = 0x100ac6d4u; /* literal 0x10021fa0 */ /* ldr r1, [pc, #0x270] */
65361: L_10021d2c:
65362:     c->r[0] = c->r[13] + 0x00000460u; /* add r0, sp, #1120 */
65363: L_10021d30:
65364:     c->r[0] = c->r[0] + 0x00000004u; /* add r0, r0, #4 */
65365: L_10021d34:
65366:     c->r[14] = 0x10021d38u; ngage_call(c, 0x1008fc04u); goto L_10021d38; /* bl 0x8fc04 <shadowkey_code+0x8fc04> */
65367: L_10021d38:
65368:     c->r[1] = 0x100ac6e4u; /* literal 0x10021fa4 */ /* ldr r1, [pc, #0x264] */
65369: L_10021d3c:
65370:     c->r[0] = c->r[13] + 0x00000450u; /* add r0, sp, #1104 */
65371: L_10021d40:
65372:     c->r[0] = c->r[0] + 0x00000008u; /* add r0, r0, #8 */
65373: L_10021d44:
65374:     c->r[14] = 0x10021d48u; ngage_call(c, 0x1008fc04u); goto L_10021d48; /* bl 0x8fc04 <shadowkey_code+0x8fc04> */
65375: L_10021d48:
65376:     c->r[1] = 0x100ac6f4u; /* literal 0x10021fa8 */ /* ldr r1, [pc, #0x258] */
65377: L_10021d4c:
65378:     c->r[0] = c->r[13] + 0x00000440u; /* add r0, sp, #1088 */
65379: L_10021d50:
65380:     c->r[0] = c->r[0] + 0x0000000cu; /* add r0, r0, #12 */
65381: L_10021d54:
65382:     c->r[14] = 0x10021d58u; ngage_call(c, 0x1008fc04u); goto L_10021d58; /* bl 0x8fc04 <shadowkey_code+0x8fc04> */
65383: L_10021d58:
65384:     c->r[5] = 0x00000000u; /* mov r5, #0 */
65385: L_10021d5c:
65386:     ngage_w32(c, (c->r[13] + 1088u), (uint32_t)c->r[5]); /* str r5, [sp, #0x440] */
65387: L_10021d60:
65388:     c->r[0] = c->r[13] + 0x00000440u; /* add r0, sp, #1088 */
65389: L_10021d64:
65390:     ngage_w32(c, (c->r[0] + 4u), (uint32_t)c->r[5]); /* str r5, [r0, #0x4] */
65391: L_10021d68:
65392:     ngage_w32(c, (c->r[0] + 8u), (uint32_t)c->r[5]); /* str r5, [r0, #0x8] */
65393: L_10021d6c:
65394:     c->r[1] = 0x100ac700u; /* literal 0x10021fac */ /* ldr r1, [pc, #0x238] */
65395: L_10021d70:
65396:     c->r[14] = 0x10021d74u; ngage_call(c, 0x10080e28u); goto L_10021d74; /* bl 0x80e28 <shadowkey_code+0x80e28> */
65397: L_10021d74:
65398:     c->r[0] = c->r[7]; /* mov r0, r7 */
65399: L_10021d78:
65400:     c->r[14] = 0x10021d7cu; ngage_call(c, 0x1009f540u); goto L_10021d7c; /* bl 0x9f540 <shadowkey_code+0x9f540> */
65401: L_10021d7c:
65402:     c->r[4] = c->r[0]; /* mov r4, r0 */
65403: L_10021d80:
65404:     c->r[6] = c->r[13] + 0x00000430u; /* add r6, sp, #1072 */
65405: L_10021d84:
65406:     c->r[0] = c->r[6]; /* mov r0, r6 */
65407: L_10021d88:
65408:     c->r[1] = c->r[7]; /* mov r1, r7 */
65409: L_10021d8c:
65410:     c->r[14] = 0x10021d90u; ngage_call(c, 0x1009f510u); goto L_10021d90; /* bl 0x9f510 <shadowkey_code+0x9f510> */
65411: L_10021d90:
65412:     ngage_w32(c, (c->r[13] + 36u), (uint32_t)c->r[5]); /* str r5, [sp, #0x24] */
65413: L_10021d94:
65414:     c->r[2] = ngage_r32(c, c->r[4]); /* ldr r2, [r4] */
65415: L_10021d98:
65416:     c->r[0] = c->r[4]; /* mov r0, r4 */
65417: L_10021d9c:
65418:     c->r[1] = c->r[13] + 0x0000002cu; /* add r1, sp, #44 */
65419: L_10021da0:
65420:     c->r[1] = c->r[1] - 0x00000008u; /* sub r1, r1, #8 */
65421: L_10021da4:
65422:     c->r[12] = ngage_r32(c, (c->r[2] + 72u)); /* ldr r12, [r2, #0x48] */
65423: L_10021da8:
65424:     c->r[14] = 0x10021db0u; /* mov lr, pc (ARM PC semantics) */
65425: L_10021dac:
65426:     ngage_call(c, c->r[12]); goto L_10021db0; /* bx r12 */
65427: L_10021db0:
65428:     c->r[3] = ngage_r32(c, c->r[4]); /* ldr r3, [r4] */
65429: L_10021db4:
65430:     c->r[0] = c->r[4]; /* mov r0, r4 */
65431: L_10021db8:
65432:     c->r[1] = c->r[6]; /* mov r1, r6 */
65433: L_10021dbc:
65434:     c->r[12] = ngage_r32(c, (c->r[3] + 184u)); /* ldr r12, [r3, #0xb8] */
65435: L_10021dc0:
65436:     c->r[14] = 0x10021dc8u; /* mov lr, pc (ARM PC semantics) */
65437: L_10021dc4:
65438:     ngage_call(c, c->r[12]); goto L_10021dc8; /* bx r12 */
65439: L_10021dc8:
65440:     c->r[1] = ngage_r32(c, (c->r[13] + 1144u)); /* ldr r1, [sp, #0x478] */
65441: L_10021dcc:
65442:     c->r[5] = c->r[13] + 0x00000230u; /* add r5, sp, #560 */
65443: L_10021dd0:
65444:     c->r[0] = c->r[5]; /* mov r0, r5 */
65445: L_10021dd4:
65446:     c->r[14] = 0x10021dd8u; ngage_call(c, 0x100a0540u); goto L_10021dd8; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65447: L_10021dd8:
65448:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65449: L_10021ddc:
65450:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
SOURCE END

#### Call 3 — lifted line 67115

SOURCE BEGIN
67065:     c->r[5] = c->r[13] + 0x0000004cu; /* add r5, sp, #76 */
67066: L_10022a74:
67067:     ngage_w32(c, (c->r[5] + 4u), (uint32_t)c->r[0]); /* str r0, [r5, #0x4] */
67068: L_10022a78:
67069:     c->r[4] = 0x00000000u; /* mov r4, #0 */
67070: L_10022a7c:
67071:     ngage_w32(c, (c->r[5] + 8u), (uint32_t)c->r[4]); /* str r4, [r5, #0x8] */
67072: L_10022a80:
67073:     c->r[0] = c->r[5]; /* mov r0, r5 */
67074: L_10022a84:
67075:     c->r[14] = 0x10022a88u; ngage_call(c, 0x100a2188u); goto L_10022a88; /* bl 0xa2188 <shadowkey_code+0xa2188> */
67076: L_10022a88:
67077:     c->r[3] = ngage_r32(c, (c->r[8] + 48u)); /* ldr r3, [r8, #0x30] */
67078: L_10022a8c:
67079:     c->r[0] = ngage_r32(c, (c->r[3] + 1468u)); /* ldr r0, [r3, #0x5bc] */
67080: L_10022a90:
67081:     c->r[2] = 0x00000f00u; /* mov r2, #3840 */
67082: L_10022a94:
67083:     { uint32_t _b = c->r[13]; ngage_w32(c, _b, c->r[2]); ngage_w32(c, _b + 4u, c->r[4]); } /* stm sp, {r2, r4} */
67084: L_10022a98:
67085:     c->r[3] = 0x00000001u; /* mov r3, #1 */
67086: L_10022a9c:
67087:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[3]); /* str r3, [sp, #0x8] */
67088: L_10022aa0:
67089:     ngage_w32(c, (c->r[13] + 12u), (uint32_t)c->r[4]); /* str r4, [sp, #0xc] */
67090: L_10022aa4:
67091:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[4]); /* str r4, [sp, #0x10] */
67092: L_10022aa8:
67093:     c->r[1] = ngage_r32(c, (c->r[13] + 84u)); /* ldr r1, [sp, #0x54] */
67094: L_10022aac:
67095:     c->r[2] = 0x0000000au; /* mov r2, #10 */
67096: L_10022ab0:
67097:     c->r[3] = 0x00000014u; /* mov r3, #20 */
67098: L_10022ab4:
67099:     c->r[14] = 0x10022ab8u; ngage_call(c, 0x1008f8a4u); goto L_10022ab8; /* bl 0x8f8a4 <shadowkey_code+0x8f8a4> */
67100: L_10022ab8:
67101:     c->r[0] = c->r[5]; /* mov r0, r5 */
67102: L_10022abc:
67103:     c->r[1] = 0x00000002u; /* mov r1, #2 */
67104: L_10022ac0:
67105:     c->r[14] = 0x10022ac4u; ngage_call(c, 0x1008fcccu); goto L_10022ac4; /* bl 0x8fccc <shadowkey_code+0x8fccc> */
67106: L_10022ac4:
67107:     c->r[5] = ngage_r32(c, c->r[9]); /* ldr r5, [r9] */
67108: L_10022ac8:
67109:     c->r[4] = c->r[13] + 0x0000003cu; /* add r4, sp, #60 */
67110: L_10022acc:
67111:     c->r[0] = c->r[4]; /* mov r0, r4 */
67112: L_10022ad0:
67113:     c->r[1] = c->r[8]; /* mov r1, r8 */
67114: L_10022ad4:
67115:     c->r[14] = 0x10022ad8u; ngage_call(c, 0x1009f510u); goto L_10022ad8; /* bl 0x9f510 <shadowkey_code+0x9f510> */
67116: L_10022ad8:
67117:     c->r[2] = ngage_r32(c, (c->r[8] + 740u)); /* ldr r2, [r8, #0x2e4] */
67118: L_10022adc:
67119:     c->r[0] = c->r[9]; /* mov r0, r9 */
67120: L_10022ae0:
67121:     c->r[1] = c->r[4]; /* mov r1, r4 */
67122: L_10022ae4:
67123:     c->r[12] = ngage_r32(c, (c->r[5] + 192u)); /* ldr r12, [r5, #0xc0] */
67124: L_10022ae8:
67125:     c->r[14] = 0x10022af0u; /* mov lr, pc (ARM PC semantics) */
67126: L_10022aec:
67127:     ngage_call(c, c->r[12]); goto L_10022af0; /* bx r12 */
67128: L_10022af0:
67129:     c->r[3] = ngage_r32(c, c->r[9]); /* ldr r3, [r9] */
67130: L_10022af4:
67131:     c->r[0] = c->r[9]; /* mov r0, r9 */
67132: L_10022af8:
67133:     c->r[12] = ngage_r32(c, (c->r[3] + 220u)); /* ldr r12, [r3, #0xdc] */
67134: L_10022afc:
67135:     c->r[14] = 0x10022b04u; /* mov lr, pc (ARM PC semantics) */
67136: L_10022b00:
67137:     ngage_call(c, c->r[12]); goto L_10022b04; /* bx r12 */
67138: L_10022b04:
67139:     goto L_10022b14; /* b 0x22b14 <shadowkey_code+0x22b14> */
67140: L_10022b14:
67141:     c->r[13] = c->r[13] + 0x0000010cu; /* add sp, sp, #268 */
67142: L_10022b18:
67143:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[8] = ngage_r32(c, c->r[13] + 16u); c->r[9] = ngage_r32(c, c->r[13] + 20u); c->r[10] = ngage_r32(c, c->r[13] + 24u); c->r[14] = ngage_r32(c, c->r[13] + 28u); c->r[13] += 32u; /* pop {r4, r5, r6, r7, r8, r9, r10, lr} */
67144: L_10022b1c:
67145:     return; /* bx lr */
67146: }
67147: 
67148: void sub_10022b20(ngage_cpu_t *c) {
67149:     (void)c;
67150:     if (0) { goto L_10022b20; goto L_10022b24; goto L_10022b28; goto L_10022b2c; goto L_10022b30; goto L_10022b34; goto L_10022b38; goto L_10022b3c; goto L_10022b40; goto L_10022b44; goto L_10022b48; goto L_10022b4c; goto L_10022b50; goto L_10022b54; goto L_10022b58; goto L_10022b5c; goto L_10022b60; goto L_10022b64; goto L_10022b68; goto L_10022b6c; goto L_10022b70; goto L_10022b74; goto L_10022b78; goto L_10022b7c; goto L_10022b80; goto L_10022b84; goto L_10022b88; goto L_10022b8c; goto L_10022b90; goto L_10022b94; goto L_10022b98; goto L_10022b9c; goto L_10022ba0; goto L_10022ba4; goto L_10022ba8; goto L_10022bac; goto L_10022bb0; goto L_10022bb4; goto L_10022bb8; goto L_10022bbc; goto L_10022bc0; goto L_10022bc8; goto L_10022bcc; goto L_10022bd0; goto L_10022bd4; goto L_10022bd8; goto L_10022bdc; goto L_10022be0; goto L_10022be4; goto L_10022be8; goto L_10022bec; goto L_10022bf0; goto L_10022bf4; goto L_10022bf8; goto L_10022bfc; goto L_10022c00; goto L_10022c04; goto L_10022c08; goto L_10022c0c; goto L_10022c10; goto L_10022c14; goto L_10022c18; goto L_10022c1c; goto L_10022c20; goto L_10022c24; goto L_10022c28; goto L_10022c2c; goto L_10022c30; goto L_10022c34; goto L_10022c38; goto L_10022c3c; goto L_10022c40; goto L_10022c44; goto L_10022c48; goto L_10022c4c; goto L_10022c50; goto L_10022c54; goto L_10022c58; goto L_10022c5c; goto L_10022c60; goto L_10022c64; goto L_10022c68; goto L_10022c6c; goto L_10022c70; goto L_10022c74; goto L_10022c78; goto L_10022c7c; goto L_10022c80; goto L_10022c84; goto L_10022c88; goto L_10022c8c; goto L_10022c90; goto L_10022c94; goto L_10022c98; goto L_10022c9c; goto L_10022ca0; goto L_10022ca4; goto L_10022ca8; goto L_10022cac; goto L_10022cb0; goto L_10022cb4; goto L_10022cb8; goto L_10022cbc; goto L_10022cc0; goto L_10022cc4; goto L_10022cc8; goto L_10022ccc; goto L_10022cd0; goto L_10022cd4; goto L_10022cd8; goto L_10022cdc; goto L_10022ce0; goto L_10022ce4; goto L_10022ce8; goto L_10022cec; goto L_10022cf0; goto L_10022cf4; goto L_10022cf8; goto L_10022cfc; goto L_10022d00; goto L_10022d04; goto L_10022d08; goto L_10022d0c; goto L_10022d10; goto L_10022d14; goto L_10022d18; goto L_10022d1c; goto L_10022d20; goto L_10022d24; goto L_10022d28; goto L_10022d2c; goto L_10022d30; goto L_10022d34; goto L_10022d38; goto L_10022d3c; goto L_10022d40; goto L_10022d44; }
67151: L_10022b20:
67152:     c->r[13] -= 32u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[9]); ngage_w32(c, c->r[13] + 24u, c->r[10]); ngage_w32(c, c->r[13] + 28u, c->r[14]); /* push {r4, r5, r6, r7, r8, r9, r10, lr} */
67153: L_10022b24:
67154:     c->r[13] = c->r[13] - 0x0000029cu; /* sub sp, sp, #668 */
67155: L_10022b28:
SOURCE END

#### Call 4 — lifted line 77780

SOURCE BEGIN
77730: L_1002824c:
77731:     goto L_10028254; /* b 0x28254 <shadowkey_code+0x28254> */
77732: L_10028254:
77733:     c->r[13] = c->r[13] + 0x0000000cu; /* add sp, sp, #12 */
77734: L_10028258:
77735:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[14] = ngage_r32(c, c->r[13] + 4u); c->r[13] += 8u; /* pop {r4, lr} */
77736: L_1002825c:
77737:     return; /* bx lr */
77738: }
77739: 
77740: void sub_10028260(ngage_cpu_t *c) {
77741:     (void)c;
77742:     if (0) { goto L_10028260; goto L_10028264; goto L_10028268; goto L_1002826c; goto L_10028270; goto L_10028274; goto L_10028278; goto L_1002827c; goto L_10028280; goto L_10028284; goto L_10028288; goto L_1002828c; goto L_10028290; goto L_10028294; goto L_10028298; goto L_1002829c; goto L_100282a0; goto L_100282a4; goto L_100282a8; goto L_100282ac; goto L_100282b0; goto L_100282b4; goto L_100282b8; goto L_100282bc; goto L_100282c0; goto L_100282c4; goto L_100282c8; goto L_100282cc; goto L_100282d0; goto L_100282d4; goto L_100282d8; goto L_100282dc; goto L_100282e0; goto L_100282e4; goto L_100282e8; }
77743: L_10028260:
77744:     c->r[13] -= 20u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[14]); /* push {r4, r5, r6, r7, lr} */
77745: L_10028264:
77746:     c->r[3] = 0x000003acu; /* mov r3, #940 */
77747: L_10028268:
77748:     c->r[13] = c->r[13] - 0x00000214u; /* sub sp, sp, #532 */
77749: L_1002826c:
77750:     c->r[6] = c->r[0]; /* mov r6, r0 */
77751: L_10028270:
77752:     c->r[2] = ngage_r8(c, (c->r[6] + c->r[3])); /* ldrb r2, [r6, r3] */
77753: L_10028274:
77754:     ngage_sub_flags(c, c->r[2], 0x00000000u); /* cmp r2, #0 */
77755: L_10028278:
77756:     if (!ngage_zf(c)) { goto L_100282e0; } /* bne 0x282e0 <shadowkey_code+0x282e0> */
77757: L_1002827c:
77758:     c->r[7] = ngage_r32(c, (c->r[6] + 52u)); /* ldr r7, [r6, #0x34] */
77759: L_10028280:
77760:     ngage_sub_flags(c, c->r[7], 0x00000000u); /* cmp r7, #0 */
77761: L_10028284:
77762:     if (ngage_zf(c)) { goto L_10028290; } /* beq 0x28290 <shadowkey_code+0x28290> */
77763: L_10028288:
77764:     c->r[14] = 0x1002828cu; ngage_call(c, 0x10021b98u); goto L_1002828c; /* bl 0x21b98 <shadowkey_code+0x21b98> */
77765: L_1002828c:
77766:     goto L_100282e0; /* b 0x282e0 <shadowkey_code+0x282e0> */
77767: L_10028290:
77768:     c->r[0] = c->r[6]; /* mov r0, r6 */
77769: L_10028294:
77770:     c->r[14] = 0x10028298u; ngage_call(c, 0x1009f540u); goto L_10028298; /* bl 0x9f540 <shadowkey_code+0x9f540> */
77771: L_10028298:
77772:     c->r[4] = c->r[0]; /* mov r4, r0 */
77773: L_1002829c:
77774:     c->r[5] = c->r[13] + 0x00000204u; /* add r5, sp, #516 */
77775: L_100282a0:
77776:     c->r[0] = c->r[5]; /* mov r0, r5 */
77777: L_100282a4:
77778:     c->r[1] = c->r[6]; /* mov r1, r6 */
77779: L_100282a8:
77780:     c->r[14] = 0x100282acu; ngage_call(c, 0x1009f510u); goto L_100282ac; /* bl 0x9f510 <shadowkey_code+0x9f510> */
77781: L_100282ac:
77782:     ngage_w32(c, c->r[13], (uint32_t)c->r[7]); /* str r7, [sp] */
77783: L_100282b0:
77784:     c->r[3] = ngage_r32(c, c->r[4]); /* ldr r3, [r4] */
77785: L_100282b4:
77786:     c->r[0] = c->r[4]; /* mov r0, r4 */
77787: L_100282b8:
77788:     c->r[1] = c->r[13]; /* mov r1, sp */
77789: L_100282bc:
77790:     c->r[12] = ngage_r32(c, (c->r[3] + 72u)); /* ldr r12, [r3, #0x48] */
77791: L_100282c0:
77792:     c->r[14] = 0x100282c8u; /* mov lr, pc (ARM PC semantics) */
77793: L_100282c4:
77794:     ngage_call(c, c->r[12]); goto L_100282c8; /* bx r12 */
77795: L_100282c8:
77796:     c->r[2] = ngage_r32(c, c->r[4]); /* ldr r2, [r4] */
77797: L_100282cc:
77798:     c->r[0] = c->r[4]; /* mov r0, r4 */
77799: L_100282d0:
77800:     c->r[1] = c->r[5]; /* mov r1, r5 */
77801: L_100282d4:
77802:     c->r[12] = ngage_r32(c, (c->r[2] + 184u)); /* ldr r12, [r2, #0xb8] */
77803: L_100282d8:
77804:     c->r[14] = 0x100282e0u; /* mov lr, pc (ARM PC semantics) */
77805: L_100282dc:
77806:     ngage_call(c, c->r[12]); goto L_100282e0; /* bx r12 */
77807: L_100282e0:
77808:     c->r[13] = c->r[13] + 0x00000214u; /* add sp, sp, #532 */
77809: L_100282e4:
77810:     c->r[4] = ngage_r32(c, c->r[13] + 0u); c->r[5] = ngage_r32(c, c->r[13] + 4u); c->r[6] = ngage_r32(c, c->r[13] + 8u); c->r[7] = ngage_r32(c, c->r[13] + 12u); c->r[14] = ngage_r32(c, c->r[13] + 16u); c->r[13] += 20u; /* pop {r4, r5, r6, r7, lr} */
77811: L_100282e8:
77812:     return; /* bx lr */
77813: }
77814: 
77815: void sub_100282f0(ngage_cpu_t *c) {
77816:     (void)c;
77817:     if (0) { goto L_100282f0; }
77818: L_100282f0:
77819:     return; /* bx lr */
77820: }
SOURCE END

### EUSER ordinal 248

Static references: 12

#### Call 1 — lifted line 65462

SOURCE BEGIN
65412:     ngage_w32(c, (c->r[13] + 36u), (uint32_t)c->r[5]); /* str r5, [sp, #0x24] */
65413: L_10021d94:
65414:     c->r[2] = ngage_r32(c, c->r[4]); /* ldr r2, [r4] */
65415: L_10021d98:
65416:     c->r[0] = c->r[4]; /* mov r0, r4 */
65417: L_10021d9c:
65418:     c->r[1] = c->r[13] + 0x0000002cu; /* add r1, sp, #44 */
65419: L_10021da0:
65420:     c->r[1] = c->r[1] - 0x00000008u; /* sub r1, r1, #8 */
65421: L_10021da4:
65422:     c->r[12] = ngage_r32(c, (c->r[2] + 72u)); /* ldr r12, [r2, #0x48] */
65423: L_10021da8:
65424:     c->r[14] = 0x10021db0u; /* mov lr, pc (ARM PC semantics) */
65425: L_10021dac:
65426:     ngage_call(c, c->r[12]); goto L_10021db0; /* bx r12 */
65427: L_10021db0:
65428:     c->r[3] = ngage_r32(c, c->r[4]); /* ldr r3, [r4] */
65429: L_10021db4:
65430:     c->r[0] = c->r[4]; /* mov r0, r4 */
65431: L_10021db8:
65432:     c->r[1] = c->r[6]; /* mov r1, r6 */
65433: L_10021dbc:
65434:     c->r[12] = ngage_r32(c, (c->r[3] + 184u)); /* ldr r12, [r3, #0xb8] */
65435: L_10021dc0:
65436:     c->r[14] = 0x10021dc8u; /* mov lr, pc (ARM PC semantics) */
65437: L_10021dc4:
65438:     ngage_call(c, c->r[12]); goto L_10021dc8; /* bx r12 */
65439: L_10021dc8:
65440:     c->r[1] = ngage_r32(c, (c->r[13] + 1144u)); /* ldr r1, [sp, #0x478] */
65441: L_10021dcc:
65442:     c->r[5] = c->r[13] + 0x00000230u; /* add r5, sp, #560 */
65443: L_10021dd0:
65444:     c->r[0] = c->r[5]; /* mov r0, r5 */
65445: L_10021dd4:
65446:     c->r[14] = 0x10021dd8u; ngage_call(c, 0x100a0540u); goto L_10021dd8; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65447: L_10021dd8:
65448:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65449: L_10021ddc:
65450:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65451: L_10021de0:
65452:     c->r[1] = 0x00000100u; /* mov r1, #256 */
65453: L_10021de4:
65454:     c->r[14] = 0x10021de8u; ngage_call(c, 0x1009edc0u); goto L_10021de8; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
65455: L_10021de8:
65456:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65457: L_10021dec:
65458:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65459: L_10021df0:
65460:     c->r[1] = c->r[5]; /* mov r1, r5 */
65461: L_10021df4:
65462:     c->r[14] = 0x10021df8u; ngage_call(c, 0x1009f220u); goto L_10021df8; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65463: L_10021df8:
65464:     c->r[3] = ~(0xff000000u); /* mvn r3, #-16777216 */
65465: L_10021dfc:
65466:     ngage_w32(c, (c->r[13] + 32u), (uint32_t)c->r[3]); /* str r3, [sp, #0x20] */
65467: L_10021e00:
65468:     c->r[2] = ngage_r32(c, c->r[4]); /* ldr r2, [r4] */
65469: L_10021e04:
65470:     c->r[0] = c->r[4]; /* mov r0, r4 */
65471: L_10021e08:
65472:     c->r[1] = c->r[13] + 0x0000002cu; /* add r1, sp, #44 */
65473: L_10021e0c:
65474:     c->r[1] = c->r[1] - 0x0000000cu; /* sub r1, r1, #12 */
65475: L_10021e10:
65476:     c->r[12] = ngage_r32(c, (c->r[2] + 60u)); /* ldr r12, [r2, #0x3c] */
65477: L_10021e14:
65478:     c->r[14] = 0x10021e1cu; /* mov lr, pc (ARM PC semantics) */
65479: L_10021e18:
65480:     ngage_call(c, c->r[12]); goto L_10021e1c; /* bx r12 */
65481: L_10021e1c:
65482:     c->r[3] = ngage_r32(c, (c->r[7] + 8u)); /* ldr r3, [r7, #0x8] */
65483: L_10021e20:
65484:     c->r[2] = ngage_r32(c, c->r[4]); /* ldr r2, [r4] */
65485: L_10021e24:
65486:     c->r[1] = ngage_r32(c, (c->r[3] + 56u)); /* ldr r1, [r3, #0x38] */
65487: L_10021e28:
65488:     c->r[0] = c->r[4]; /* mov r0, r4 */
65489: L_10021e2c:
65490:     c->r[12] = ngage_r32(c, (c->r[2] + 36u)); /* ldr r12, [r2, #0x24] */
65491: L_10021e30:
65492:     c->r[14] = 0x10021e38u; /* mov lr, pc (ARM PC semantics) */
65493: L_10021e34:
65494:     ngage_call(c, c->r[12]); goto L_10021e38; /* bx r12 */
65495: L_10021e38:
65496:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65497: L_10021e3c:
65498:     c->r[7] = 0x00000028u; /* mov r7, #40 */
65499: L_10021e40:
65500:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[7]); /* str r7, [sp, #0x18] */
65501: L_10021e44:
65502:     c->r[2] = c->r[13] + 0x0000001cu; /* add r2, sp, #28 */
SOURCE END

#### Call 2 — lifted line 65536

SOURCE BEGIN
65486:     c->r[1] = ngage_r32(c, (c->r[3] + 56u)); /* ldr r1, [r3, #0x38] */
65487: L_10021e28:
65488:     c->r[0] = c->r[4]; /* mov r0, r4 */
65489: L_10021e2c:
65490:     c->r[12] = ngage_r32(c, (c->r[2] + 36u)); /* ldr r12, [r2, #0x24] */
65491: L_10021e30:
65492:     c->r[14] = 0x10021e38u; /* mov lr, pc (ARM PC semantics) */
65493: L_10021e34:
65494:     ngage_call(c, c->r[12]); goto L_10021e38; /* bx r12 */
65495: L_10021e38:
65496:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65497: L_10021e3c:
65498:     c->r[7] = 0x00000028u; /* mov r7, #40 */
65499: L_10021e40:
65500:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[7]); /* str r7, [sp, #0x18] */
65501: L_10021e44:
65502:     c->r[2] = c->r[13] + 0x0000001cu; /* add r2, sp, #28 */
65503: L_10021e48:
65504:     c->r[2] = c->r[2] - 0x00000004u; /* sub r2, r2, #4 */
65505: L_10021e4c:
65506:     c->r[3] = 0x00000055u; /* mov r3, #85 */
65507: L_10021e50:
65508:     ngage_w32(c, (c->r[2] + 4u), (uint32_t)c->r[3]); /* str r3, [r2, #0x4] */
65509: L_10021e54:
65510:     c->r[6] = c->r[13] + 0x0000002cu; /* add r6, sp, #44 */
65511: L_10021e58:
65512:     c->r[6] = c->r[6] - 0x00000004u; /* sub r6, r6, #4 */
65513: L_10021e5c:
65514:     c->r[0] = c->r[4]; /* mov r0, r4 */
65515: L_10021e60:
65516:     c->r[1] = c->r[6]; /* mov r1, r6 */
65517: L_10021e64:
65518:     c->r[12] = ngage_r32(c, (c->r[12] + 164u)); /* ldr r12, [r12, #0xa4] */
65519: L_10021e68:
65520:     c->r[14] = 0x10021e70u; /* mov lr, pc (ARM PC semantics) */
65521: L_10021e6c:
65522:     ngage_call(c, c->r[12]); goto L_10021e70; /* bx r12 */
65523: L_10021e70:
65524:     c->r[1] = ngage_r32(c, (c->r[13] + 1132u)); /* ldr r1, [sp, #0x46c] */
65525: L_10021e74:
65526:     c->r[0] = c->r[5]; /* mov r0, r5 */
65527: L_10021e78:
65528:     c->r[14] = 0x10021e7cu; ngage_call(c, 0x100a0540u); goto L_10021e7c; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65529: L_10021e7c:
65530:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65531: L_10021e80:
65532:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65533: L_10021e84:
65534:     c->r[1] = c->r[5]; /* mov r1, r5 */
65535: L_10021e88:
65536:     c->r[14] = 0x10021e8cu; ngage_call(c, 0x1009f220u); goto L_10021e8c; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65537: L_10021e8c:
65538:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65539: L_10021e90:
65540:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[7]); /* str r7, [sp, #0x10] */
65541: L_10021e94:
65542:     c->r[3] = 0x00000064u; /* mov r3, #100 */
65543: L_10021e98:
65544:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[3]); /* str r3, [sp, #0x14] */
65545: L_10021e9c:
65546:     c->r[0] = c->r[4]; /* mov r0, r4 */
65547: L_10021ea0:
65548:     c->r[1] = c->r[6]; /* mov r1, r6 */
65549: L_10021ea4:
65550:     c->r[2] = c->r[13] + 0x0000001cu; /* add r2, sp, #28 */
65551: L_10021ea8:
65552:     c->r[2] = c->r[2] - 0x0000000cu; /* sub r2, r2, #12 */
65553: L_10021eac:
65554:     c->r[12] = ngage_r32(c, (c->r[12] + 164u)); /* ldr r12, [r12, #0xa4] */
65555: L_10021eb0:
65556:     c->r[14] = 0x10021eb8u; /* mov lr, pc (ARM PC semantics) */
65557: L_10021eb4:
65558:     ngage_call(c, c->r[12]); goto L_10021eb8; /* bx r12 */
65559: L_10021eb8:
65560:     c->r[1] = ngage_r32(c, (c->r[13] + 1120u)); /* ldr r1, [sp, #0x460] */
65561: L_10021ebc:
65562:     c->r[0] = c->r[5]; /* mov r0, r5 */
65563: L_10021ec0:
65564:     c->r[14] = 0x10021ec4u; ngage_call(c, 0x100a0540u); goto L_10021ec4; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65565: L_10021ec4:
65566:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65567: L_10021ec8:
65568:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65569: L_10021ecc:
65570:     c->r[1] = c->r[5]; /* mov r1, r5 */
65571: L_10021ed0:
65572:     c->r[14] = 0x10021ed4u; ngage_call(c, 0x1009f220u); goto L_10021ed4; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65573: L_10021ed4:
65574:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65575: L_10021ed8:
65576:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[7]); /* str r7, [sp, #0x8] */
SOURCE END

#### Call 3 — lifted line 65572

SOURCE BEGIN
65522:     ngage_call(c, c->r[12]); goto L_10021e70; /* bx r12 */
65523: L_10021e70:
65524:     c->r[1] = ngage_r32(c, (c->r[13] + 1132u)); /* ldr r1, [sp, #0x46c] */
65525: L_10021e74:
65526:     c->r[0] = c->r[5]; /* mov r0, r5 */
65527: L_10021e78:
65528:     c->r[14] = 0x10021e7cu; ngage_call(c, 0x100a0540u); goto L_10021e7c; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65529: L_10021e7c:
65530:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65531: L_10021e80:
65532:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65533: L_10021e84:
65534:     c->r[1] = c->r[5]; /* mov r1, r5 */
65535: L_10021e88:
65536:     c->r[14] = 0x10021e8cu; ngage_call(c, 0x1009f220u); goto L_10021e8c; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65537: L_10021e8c:
65538:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65539: L_10021e90:
65540:     ngage_w32(c, (c->r[13] + 16u), (uint32_t)c->r[7]); /* str r7, [sp, #0x10] */
65541: L_10021e94:
65542:     c->r[3] = 0x00000064u; /* mov r3, #100 */
65543: L_10021e98:
65544:     ngage_w32(c, (c->r[13] + 20u), (uint32_t)c->r[3]); /* str r3, [sp, #0x14] */
65545: L_10021e9c:
65546:     c->r[0] = c->r[4]; /* mov r0, r4 */
65547: L_10021ea0:
65548:     c->r[1] = c->r[6]; /* mov r1, r6 */
65549: L_10021ea4:
65550:     c->r[2] = c->r[13] + 0x0000001cu; /* add r2, sp, #28 */
65551: L_10021ea8:
65552:     c->r[2] = c->r[2] - 0x0000000cu; /* sub r2, r2, #12 */
65553: L_10021eac:
65554:     c->r[12] = ngage_r32(c, (c->r[12] + 164u)); /* ldr r12, [r12, #0xa4] */
65555: L_10021eb0:
65556:     c->r[14] = 0x10021eb8u; /* mov lr, pc (ARM PC semantics) */
65557: L_10021eb4:
65558:     ngage_call(c, c->r[12]); goto L_10021eb8; /* bx r12 */
65559: L_10021eb8:
65560:     c->r[1] = ngage_r32(c, (c->r[13] + 1120u)); /* ldr r1, [sp, #0x460] */
65561: L_10021ebc:
65562:     c->r[0] = c->r[5]; /* mov r0, r5 */
65563: L_10021ec0:
65564:     c->r[14] = 0x10021ec4u; ngage_call(c, 0x100a0540u); goto L_10021ec4; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65565: L_10021ec4:
65566:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65567: L_10021ec8:
65568:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65569: L_10021ecc:
65570:     c->r[1] = c->r[5]; /* mov r1, r5 */
65571: L_10021ed0:
65572:     c->r[14] = 0x10021ed4u; ngage_call(c, 0x1009f220u); goto L_10021ed4; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65573: L_10021ed4:
65574:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65575: L_10021ed8:
65576:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[7]); /* str r7, [sp, #0x8] */
65577: L_10021edc:
65578:     c->r[2] = c->r[13] + 0x0000000cu; /* add r2, sp, #12 */
65579: L_10021ee0:
65580:     c->r[2] = c->r[2] - 0x00000004u; /* sub r2, r2, #4 */
65581: L_10021ee4:
65582:     c->r[3] = 0x00000073u; /* mov r3, #115 */
65583: L_10021ee8:
65584:     ngage_w32(c, (c->r[2] + 4u), (uint32_t)c->r[3]); /* str r3, [r2, #0x4] */
65585: L_10021eec:
65586:     c->r[0] = c->r[4]; /* mov r0, r4 */
65587: L_10021ef0:
65588:     c->r[1] = c->r[6]; /* mov r1, r6 */
65589: L_10021ef4:
65590:     c->r[12] = ngage_r32(c, (c->r[12] + 164u)); /* ldr r12, [r12, #0xa4] */
65591: L_10021ef8:
65592:     c->r[14] = 0x10021f00u; /* mov lr, pc (ARM PC semantics) */
65593: L_10021efc:
65594:     ngage_call(c, c->r[12]); goto L_10021f00; /* bx r12 */
65595: L_10021f00:
65596:     c->r[1] = ngage_r32(c, (c->r[13] + 1108u)); /* ldr r1, [sp, #0x454] */
65597: L_10021f04:
65598:     c->r[0] = c->r[5]; /* mov r0, r5 */
65599: L_10021f08:
65600:     c->r[14] = 0x10021f0cu; ngage_call(c, 0x100a0540u); goto L_10021f0c; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65601: L_10021f0c:
65602:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65603: L_10021f10:
65604:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65605: L_10021f14:
65606:     c->r[1] = c->r[5]; /* mov r1, r5 */
65607: L_10021f18:
65608:     c->r[14] = 0x10021f1cu; ngage_call(c, 0x1009f220u); goto L_10021f1c; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65609: L_10021f1c:
65610:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65611: L_10021f20:
65612:     ngage_w32(c, c->r[13], (uint32_t)c->r[7]); /* str r7, [sp] */
SOURCE END

#### Call 4 — lifted line 65608

SOURCE BEGIN
65558:     ngage_call(c, c->r[12]); goto L_10021eb8; /* bx r12 */
65559: L_10021eb8:
65560:     c->r[1] = ngage_r32(c, (c->r[13] + 1120u)); /* ldr r1, [sp, #0x460] */
65561: L_10021ebc:
65562:     c->r[0] = c->r[5]; /* mov r0, r5 */
65563: L_10021ec0:
65564:     c->r[14] = 0x10021ec4u; ngage_call(c, 0x100a0540u); goto L_10021ec4; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65565: L_10021ec4:
65566:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65567: L_10021ec8:
65568:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65569: L_10021ecc:
65570:     c->r[1] = c->r[5]; /* mov r1, r5 */
65571: L_10021ed0:
65572:     c->r[14] = 0x10021ed4u; ngage_call(c, 0x1009f220u); goto L_10021ed4; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65573: L_10021ed4:
65574:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65575: L_10021ed8:
65576:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[7]); /* str r7, [sp, #0x8] */
65577: L_10021edc:
65578:     c->r[2] = c->r[13] + 0x0000000cu; /* add r2, sp, #12 */
65579: L_10021ee0:
65580:     c->r[2] = c->r[2] - 0x00000004u; /* sub r2, r2, #4 */
65581: L_10021ee4:
65582:     c->r[3] = 0x00000073u; /* mov r3, #115 */
65583: L_10021ee8:
65584:     ngage_w32(c, (c->r[2] + 4u), (uint32_t)c->r[3]); /* str r3, [r2, #0x4] */
65585: L_10021eec:
65586:     c->r[0] = c->r[4]; /* mov r0, r4 */
65587: L_10021ef0:
65588:     c->r[1] = c->r[6]; /* mov r1, r6 */
65589: L_10021ef4:
65590:     c->r[12] = ngage_r32(c, (c->r[12] + 164u)); /* ldr r12, [r12, #0xa4] */
65591: L_10021ef8:
65592:     c->r[14] = 0x10021f00u; /* mov lr, pc (ARM PC semantics) */
65593: L_10021efc:
65594:     ngage_call(c, c->r[12]); goto L_10021f00; /* bx r12 */
65595: L_10021f00:
65596:     c->r[1] = ngage_r32(c, (c->r[13] + 1108u)); /* ldr r1, [sp, #0x454] */
65597: L_10021f04:
65598:     c->r[0] = c->r[5]; /* mov r0, r5 */
65599: L_10021f08:
65600:     c->r[14] = 0x10021f0cu; ngage_call(c, 0x100a0540u); goto L_10021f0c; /* bl 0xa0540 <shadowkey_code+0xa0540> */
65601: L_10021f0c:
65602:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
65603: L_10021f10:
65604:     c->r[0] = c->r[0] - 0x00000004u; /* sub r0, r0, #4 */
65605: L_10021f14:
65606:     c->r[1] = c->r[5]; /* mov r1, r5 */
65607: L_10021f18:
65608:     c->r[14] = 0x10021f1cu; ngage_call(c, 0x1009f220u); goto L_10021f1c; /* bl 0x9f220 <shadowkey_code+0x9f220> */
65609: L_10021f1c:
65610:     c->r[12] = ngage_r32(c, c->r[4]); /* ldr r12, [r4] */
65611: L_10021f20:
65612:     ngage_w32(c, c->r[13], (uint32_t)c->r[7]); /* str r7, [sp] */
65613: L_10021f24:
65614:     c->r[3] = 0x00000082u; /* mov r3, #130 */
65615: L_10021f28:
65616:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[3]); /* str r3, [sp, #0x4] */
65617: L_10021f2c:
65618:     c->r[0] = c->r[4]; /* mov r0, r4 */
65619: L_10021f30:
65620:     c->r[1] = c->r[6]; /* mov r1, r6 */
65621: L_10021f34:
65622:     c->r[2] = c->r[13] + 0x0000000cu; /* add r2, sp, #12 */
65623: L_10021f38:
65624:     c->r[2] = c->r[2] - 0x0000000cu; /* sub r2, r2, #12 */
65625: L_10021f3c:
65626:     c->r[12] = ngage_r32(c, (c->r[12] + 164u)); /* ldr r12, [r12, #0xa4] */
65627: L_10021f40:
65628:     c->r[14] = 0x10021f48u; /* mov lr, pc (ARM PC semantics) */
65629: L_10021f44:
65630:     ngage_call(c, c->r[12]); goto L_10021f48; /* bx r12 */
65631: L_10021f48:
65632:     c->r[3] = ngage_r32(c, c->r[4]); /* ldr r3, [r4] */
65633: L_10021f4c:
65634:     c->r[0] = c->r[4]; /* mov r0, r4 */
65635: L_10021f50:
65636:     c->r[12] = ngage_r32(c, (c->r[3] + 40u)); /* ldr r12, [r3, #0x28] */
65637: L_10021f54:
65638:     c->r[14] = 0x10021f5cu; /* mov lr, pc (ARM PC semantics) */
65639: L_10021f58:
65640:     ngage_call(c, c->r[12]); goto L_10021f5c; /* bx r12 */
65641: L_10021f5c:
65642:     c->r[0] = c->r[13] + 0x00000440u; /* add r0, sp, #1088 */
65643: L_10021f60:
65644:     c->r[0] = c->r[0] + 0x0000000cu; /* add r0, r0, #12 */
65645: L_10021f64:
65646:     c->r[1] = 0x00000002u; /* mov r1, #2 */
65647: L_10021f68:
65648:     c->r[14] = 0x10021f6cu; ngage_call(c, 0x1008fcccu); goto L_10021f6c; /* bl 0x8fccc <shadowkey_code+0x8fccc> */
SOURCE END

#### Call 5 — lifted line 67372

SOURCE BEGIN
67322:     c->r[12] = ngage_r32(c, (c->r[1] + 16u)); /* ldr r12, [r1, #0x10] */
67323: L_10022c7c:
67324:     c->r[14] = 0x10022c84u; /* mov lr, pc (ARM PC semantics) */
67325: L_10022c80:
67326:     ngage_call(c, c->r[12]); goto L_10022c84; /* bx r12 */
67327: L_10022c84:
67328:     c->r[2] = ngage_r32(c, (c->r[13] + 24u)); /* ldr r2, [sp, #0x18] */
67329: L_10022c88:
67330:     c->r[3] = ngage_r32(c, c->r[2]); /* ldr r3, [r2] */
67331: L_10022c8c:
67332:     c->r[5] = c->r[0]; /* mov r5, r0 */
67333: L_10022c90:
67334:     c->r[0] = c->r[2]; /* mov r0, r2 */
67335: L_10022c94:
67336:     c->r[12] = ngage_r32(c, (c->r[3] + 20u)); /* ldr r12, [r3, #0x14] */
67337: L_10022c98:
67338:     c->r[14] = 0x10022ca0u; /* mov lr, pc (ARM PC semantics) */
67339: L_10022c9c:
67340:     ngage_call(c, c->r[12]); goto L_10022ca0; /* bx r12 */
67341: L_10022ca0:
67342:     c->r[12] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r12, [r8, #0x2ec] */
67343: L_10022ca4:
67344:     c->r[2] = ngage_r32(c, c->r[12]); /* ldr r2, [r12] */
67345: L_10022ca8:
67346:     c->r[1] = c->r[7]; /* mov r1, r7 */
67347: L_10022cac:
67348:     c->r[4] = c->r[4] - c->r[5]; /* rsb r4, r5, r4 */
67349: L_10022cb0:
67350:     c->r[4] = c->r[4] + shadowkey_arm_shift_operand(c, c->r[4], 1u, 31u, 1u, 0u); /* add r4, r4, r4, lsr #31 */
67351: L_10022cb4:
67352:     c->r[7] = c->r[0] + shadowkey_arm_shift_operand(c, c->r[4], 2u, 1u, 1u, 0u); /* add r7, r0, r4, asr #1 */
67353: L_10022cb8:
67354:     c->r[0] = c->r[12]; /* mov r0, r12 */
67355: L_10022cbc:
67356:     c->r[12] = ngage_r32(c, (c->r[2] + 60u)); /* ldr r12, [r2, #0x3c] */
67357: L_10022cc0:
67358:     c->r[14] = 0x10022cc8u; /* mov lr, pc (ARM PC semantics) */
67359: L_10022cc4:
67360:     ngage_call(c, c->r[12]); goto L_10022cc8; /* bx r12 */
67361: L_10022cc8:
67362:     c->r[0] = c->r[13] + 0x00000024u; /* add r0, sp, #36 */
67363: L_10022ccc:
67364:     c->r[1] = 0x00000100u; /* mov r1, #256 */
67365: L_10022cd0:
67366:     c->r[14] = 0x10022cd4u; ngage_call(c, 0x1009edc0u); goto L_10022cd4; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
67367: L_10022cd4:
67368:     c->r[1] = ngage_r32(c, (c->r[13] + 16u)); /* ldr r1, [sp, #0x10] */
67369: L_10022cd8:
67370:     c->r[0] = c->r[13] + 0x00000024u; /* add r0, sp, #36 */
67371: L_10022cdc:
67372:     c->r[14] = 0x10022ce0u; ngage_call(c, 0x1009f220u); goto L_10022ce0; /* bl 0x9f220 <shadowkey_code+0x9f220> */
67373: L_10022ce0:
67374:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
67375: L_10022ce4:
67376:     c->r[12] = ngage_r32(c, c->r[0]); /* ldr r12, [r0] */
67377: L_10022ce8:
67378:     c->r[3] = 0x00000000u; /* mov r3, #0 */
67379: L_10022cec:
67380:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
67381: L_10022cf0:
67382:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[3]); /* str r3, [sp, #0x4] */
67383: L_10022cf4:
67384:     c->r[1] = c->r[13] + 0x00000024u; /* add r1, sp, #36 */
67385: L_10022cf8:
67386:     c->r[2] = c->r[6]; /* mov r2, r6 */
67387: L_10022cfc:
67388:     c->r[3] = c->r[7]; /* mov r3, r7 */
67389: L_10022d00:
67390:     c->r[12] = ngage_r32(c, (c->r[12] + 168u)); /* ldr r12, [r12, #0xa8] */
67391: L_10022d04:
67392:     c->r[14] = 0x10022d0cu; /* mov lr, pc (ARM PC semantics) */
67393: L_10022d08:
67394:     ngage_call(c, c->r[12]); goto L_10022d0c; /* bx r12 */
67395: L_10022d0c:
67396:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
67397: L_10022d10:
67398:     c->r[3] = ngage_r32(c, c->r[0]); /* ldr r3, [r0] */
67399: L_10022d14:
67400:     c->r[12] = ngage_r32(c, (c->r[3] + 40u)); /* ldr r12, [r3, #0x28] */
67401: L_10022d18:
67402:     c->r[14] = 0x10022d20u; /* mov lr, pc (ARM PC semantics) */
67403: L_10022d1c:
67404:     ngage_call(c, c->r[12]); goto L_10022d20; /* bx r12 */
67405: L_10022d20:
67406:     ngage_sub_flags(c, c->r[10], 0x00000000u); /* cmp r10, #0 */
67407: L_10022d24:
67408:     if (!ngage_zf(c)) { c->r[0] = ngage_r32(c, (c->r[8] + 744u)); } /* ldrne r0, [r8, #0x2e8] */
67409: L_10022d28:
67410:     if (!ngage_zf(c)) { c->r[1] = ngage_r32(c, (c->r[13] + 24u)); } /* ldrne r1, [sp, #0x18] */
67411: L_10022d2c:
67412:     if (!ngage_zf(c)) { c->r[3] = ngage_r32(c, (c->r[0] + 4u)); c->r[0] = (c->r[0] + 4u); } /* ldrne r3, [r0, #0x4]! */
SOURCE END

#### Call 6 — lifted line 67659

SOURCE BEGIN
67609:     c->r[12] = ngage_r32(c, (c->r[1] + 16u)); /* ldr r12, [r1, #0x10] */
67610: L_10022eb4:
67611:     c->r[14] = 0x10022ebcu; /* mov lr, pc (ARM PC semantics) */
67612: L_10022eb8:
67613:     ngage_call(c, c->r[12]); goto L_10022ebc; /* bx r12 */
67614: L_10022ebc:
67615:     c->r[2] = ngage_r32(c, (c->r[13] + 24u)); /* ldr r2, [sp, #0x18] */
67616: L_10022ec0:
67617:     c->r[3] = ngage_r32(c, c->r[2]); /* ldr r3, [r2] */
67618: L_10022ec4:
67619:     c->r[5] = c->r[0]; /* mov r5, r0 */
67620: L_10022ec8:
67621:     c->r[0] = c->r[2]; /* mov r0, r2 */
67622: L_10022ecc:
67623:     c->r[12] = ngage_r32(c, (c->r[3] + 20u)); /* ldr r12, [r3, #0x14] */
67624: L_10022ed0:
67625:     c->r[14] = 0x10022ed8u; /* mov lr, pc (ARM PC semantics) */
67626: L_10022ed4:
67627:     ngage_call(c, c->r[12]); goto L_10022ed8; /* bx r12 */
67628: L_10022ed8:
67629:     c->r[12] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r12, [r8, #0x2ec] */
67630: L_10022edc:
67631:     c->r[2] = ngage_r32(c, c->r[12]); /* ldr r2, [r12] */
67632: L_10022ee0:
67633:     c->r[1] = c->r[7]; /* mov r1, r7 */
67634: L_10022ee4:
67635:     c->r[4] = c->r[4] - c->r[5]; /* rsb r4, r5, r4 */
67636: L_10022ee8:
67637:     c->r[4] = c->r[4] + shadowkey_arm_shift_operand(c, c->r[4], 1u, 31u, 1u, 0u); /* add r4, r4, r4, lsr #31 */
67638: L_10022eec:
67639:     c->r[7] = c->r[0] + shadowkey_arm_shift_operand(c, c->r[4], 2u, 1u, 1u, 0u); /* add r7, r0, r4, asr #1 */
67640: L_10022ef0:
67641:     c->r[0] = c->r[12]; /* mov r0, r12 */
67642: L_10022ef4:
67643:     c->r[12] = ngage_r32(c, (c->r[2] + 60u)); /* ldr r12, [r2, #0x3c] */
67644: L_10022ef8:
67645:     c->r[14] = 0x10022f00u; /* mov lr, pc (ARM PC semantics) */
67646: L_10022efc:
67647:     ngage_call(c, c->r[12]); goto L_10022f00; /* bx r12 */
67648: L_10022f00:
67649:     c->r[0] = c->r[13] + 0x00000024u; /* add r0, sp, #36 */
67650: L_10022f04:
67651:     c->r[1] = 0x00000100u; /* mov r1, #256 */
67652: L_10022f08:
67653:     c->r[14] = 0x10022f0cu; ngage_call(c, 0x1009edc0u); goto L_10022f0c; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
67654: L_10022f0c:
67655:     c->r[1] = ngage_r32(c, (c->r[13] + 16u)); /* ldr r1, [sp, #0x10] */
67656: L_10022f10:
67657:     c->r[0] = c->r[13] + 0x00000024u; /* add r0, sp, #36 */
67658: L_10022f14:
67659:     c->r[14] = 0x10022f18u; ngage_call(c, 0x1009f220u); goto L_10022f18; /* bl 0x9f220 <shadowkey_code+0x9f220> */
67660: L_10022f18:
67661:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
67662: L_10022f1c:
67663:     c->r[12] = ngage_r32(c, c->r[0]); /* ldr r12, [r0] */
67664: L_10022f20:
67665:     c->r[2] = 0x00000000u; /* mov r2, #0 */
67666: L_10022f24:
67667:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
67668: L_10022f28:
67669:     c->r[3] = 0x00000001u; /* mov r3, #1 */
67670: L_10022f2c:
67671:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
67672: L_10022f30:
67673:     c->r[1] = c->r[13] + 0x00000024u; /* add r1, sp, #36 */
67674: L_10022f34:
67675:     c->r[2] = c->r[6]; /* mov r2, r6 */
67676: L_10022f38:
67677:     c->r[3] = c->r[7]; /* mov r3, r7 */
67678: L_10022f3c:
67679:     c->r[12] = ngage_r32(c, (c->r[12] + 168u)); /* ldr r12, [r12, #0xa8] */
67680: L_10022f40:
67681:     c->r[14] = 0x10022f48u; /* mov lr, pc (ARM PC semantics) */
67682: L_10022f44:
67683:     ngage_call(c, c->r[12]); goto L_10022f48; /* bx r12 */
67684: L_10022f48:
67685:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
67686: L_10022f4c:
67687:     c->r[3] = ngage_r32(c, c->r[0]); /* ldr r3, [r0] */
67688: L_10022f50:
67689:     c->r[12] = ngage_r32(c, (c->r[3] + 40u)); /* ldr r12, [r3, #0x28] */
67690: L_10022f54:
67691:     c->r[14] = 0x10022f5cu; /* mov lr, pc (ARM PC semantics) */
67692: L_10022f58:
67693:     ngage_call(c, c->r[12]); goto L_10022f5c; /* bx r12 */
67694: L_10022f5c:
67695:     c->r[9] = ngage_r32(c, (c->r[13] + 8u)); /* ldr r9, [sp, #0x8] */
67696: L_10022f60:
67697:     ngage_sub_flags(c, c->r[9], 0x00000000u); /* cmp r9, #0 */
67698: L_10022f64:
67699:     if (!ngage_zf(c)) { c->r[0] = ngage_r32(c, (c->r[8] + 744u)); } /* ldrne r0, [r8, #0x2e8] */
SOURCE END

#### Call 7 — lifted line 67942

SOURCE BEGIN
67892:     c->r[12] = ngage_r32(c, (c->r[1] + 16u)); /* ldr r12, [r1, #0x10] */
67893: L_100230e4:
67894:     c->r[14] = 0x100230ecu; /* mov lr, pc (ARM PC semantics) */
67895: L_100230e8:
67896:     ngage_call(c, c->r[12]); goto L_100230ec; /* bx r12 */
67897: L_100230ec:
67898:     c->r[2] = ngage_r32(c, (c->r[13] + 24u)); /* ldr r2, [sp, #0x18] */
67899: L_100230f0:
67900:     c->r[3] = ngage_r32(c, c->r[2]); /* ldr r3, [r2] */
67901: L_100230f4:
67902:     c->r[5] = c->r[0]; /* mov r5, r0 */
67903: L_100230f8:
67904:     c->r[0] = c->r[2]; /* mov r0, r2 */
67905: L_100230fc:
67906:     c->r[12] = ngage_r32(c, (c->r[3] + 20u)); /* ldr r12, [r3, #0x14] */
67907: L_10023100:
67908:     c->r[14] = 0x10023108u; /* mov lr, pc (ARM PC semantics) */
67909: L_10023104:
67910:     ngage_call(c, c->r[12]); goto L_10023108; /* bx r12 */
67911: L_10023108:
67912:     c->r[12] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r12, [r8, #0x2ec] */
67913: L_1002310c:
67914:     c->r[2] = ngage_r32(c, c->r[12]); /* ldr r2, [r12] */
67915: L_10023110:
67916:     c->r[1] = c->r[7]; /* mov r1, r7 */
67917: L_10023114:
67918:     c->r[4] = c->r[4] - c->r[5]; /* rsb r4, r5, r4 */
67919: L_10023118:
67920:     c->r[4] = c->r[4] + shadowkey_arm_shift_operand(c, c->r[4], 1u, 31u, 1u, 0u); /* add r4, r4, r4, lsr #31 */
67921: L_1002311c:
67922:     c->r[7] = c->r[0] + shadowkey_arm_shift_operand(c, c->r[4], 2u, 1u, 1u, 0u); /* add r7, r0, r4, asr #1 */
67923: L_10023120:
67924:     c->r[0] = c->r[12]; /* mov r0, r12 */
67925: L_10023124:
67926:     c->r[12] = ngage_r32(c, (c->r[2] + 60u)); /* ldr r12, [r2, #0x3c] */
67927: L_10023128:
67928:     c->r[14] = 0x10023130u; /* mov lr, pc (ARM PC semantics) */
67929: L_1002312c:
67930:     ngage_call(c, c->r[12]); goto L_10023130; /* bx r12 */
67931: L_10023130:
67932:     c->r[0] = c->r[13] + 0x00000024u; /* add r0, sp, #36 */
67933: L_10023134:
67934:     c->r[1] = 0x00000100u; /* mov r1, #256 */
67935: L_10023138:
67936:     c->r[14] = 0x1002313cu; ngage_call(c, 0x1009edc0u); goto L_1002313c; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
67937: L_1002313c:
67938:     c->r[1] = ngage_r32(c, (c->r[13] + 16u)); /* ldr r1, [sp, #0x10] */
67939: L_10023140:
67940:     c->r[0] = c->r[13] + 0x00000024u; /* add r0, sp, #36 */
67941: L_10023144:
67942:     c->r[14] = 0x10023148u; ngage_call(c, 0x1009f220u); goto L_10023148; /* bl 0x9f220 <shadowkey_code+0x9f220> */
67943: L_10023148:
67944:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
67945: L_1002314c:
67946:     c->r[12] = ngage_r32(c, c->r[0]); /* ldr r12, [r0] */
67947: L_10023150:
67948:     c->r[2] = 0x00000000u; /* mov r2, #0 */
67949: L_10023154:
67950:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
67951: L_10023158:
67952:     c->r[3] = 0x00000002u; /* mov r3, #2 */
67953: L_1002315c:
67954:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
67955: L_10023160:
67956:     c->r[1] = c->r[13] + 0x00000024u; /* add r1, sp, #36 */
67957: L_10023164:
67958:     c->r[2] = c->r[6]; /* mov r2, r6 */
67959: L_10023168:
67960:     c->r[3] = c->r[7]; /* mov r3, r7 */
67961: L_1002316c:
67962:     c->r[12] = ngage_r32(c, (c->r[12] + 168u)); /* ldr r12, [r12, #0xa8] */
67963: L_10023170:
67964:     c->r[14] = 0x10023178u; /* mov lr, pc (ARM PC semantics) */
67965: L_10023174:
67966:     ngage_call(c, c->r[12]); goto L_10023178; /* bx r12 */
67967: L_10023178:
67968:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
67969: L_1002317c:
67970:     c->r[3] = ngage_r32(c, c->r[0]); /* ldr r3, [r0] */
67971: L_10023180:
67972:     c->r[12] = ngage_r32(c, (c->r[3] + 40u)); /* ldr r12, [r3, #0x28] */
67973: L_10023184:
67974:     c->r[14] = 0x1002318cu; /* mov lr, pc (ARM PC semantics) */
67975: L_10023188:
67976:     ngage_call(c, c->r[12]); goto L_1002318c; /* bx r12 */
67977: L_1002318c:
67978:     ngage_sub_flags(c, c->r[10], 0x00000000u); /* cmp r10, #0 */
67979: L_10023190:
67980:     if (!ngage_zf(c)) { c->r[0] = ngage_r32(c, (c->r[8] + 744u)); } /* ldrne r0, [r8, #0x2e8] */
67981: L_10023194:
67982:     if (!ngage_zf(c)) { c->r[1] = ngage_r32(c, (c->r[13] + 24u)); } /* ldrne r1, [sp, #0x18] */
SOURCE END

#### Call 8 — lifted line 68368

SOURCE BEGIN
68318:     c->r[0] = ngage_r32(c, (c->r[13] + 24u)); /* ldr r0, [sp, #0x18] */
68319: L_10023428:
68320:     c->r[10] = ngage_r32(c, (c->r[13] + 32u)); /* ldr r10, [sp, #0x20] */
68321: L_1002342c:
68322:     c->r[1] = 0x00000000u; /* mov r1, #0 */
68323: L_10023430:
68324:     ngage_sub_flags(c, c->r[2], 0x00000020u); /* cmp r2, #32 */
68325: L_10023434:
68326:     if (ngage_zf(c)) { c->r[5] = c->r[5] + 0x00000001u; } /* addeq r5, r5, #1 */
68327: L_10023438:
68328:     c->r[3] = c->r[4] - c->r[5]; /* rsb r3, r5, r4 */
68329:     fprintf(stderr,"TRACE text-convert loop dst=%08x src=%08x count=%u index=%u remaining=%d source16=%04x,%04x,%04x,%04x\n",c->r[0],c->r[10],c->r[1],c->r[5],(int32_t)c->r[3],ngage_r16(c,c->r[10]),ngage_r16(c,c->r[10]+2u),ngage_r16(c,c->r[10]+4u),ngage_r16(c,c->r[10]+6u));
68330: L_1002343c:
68331:     ngage_sub_flags(c, c->r[1], c->r[3]); /* cmp r1, r3 */
68332: L_10023440:
68333:     c->r[2] = c->r[10] + shadowkey_arm_shift_operand(c, c->r[5], 0u, 1u, 1u, 0u); /* add r2, r10, r5, lsl #1 */
68334: L_10023444:
68335:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_10023464; } /* bge 0x23464 <shadowkey_code+0x23464> */
68336: L_10023448:
68337:     c->r[9] = ngage_r8(c, c->r[2]); c->r[2] += 1u; /* ldrb r9, [r2], #1 */
68338: L_1002344c:
68339:     c->r[10] = ngage_r8(c, c->r[2]); c->r[2] += 1u; /* ldrb r10, [r2], #1 */
68340: L_10023450:
68341:     c->r[10] = c->r[9] | shadowkey_arm_shift_operand(c, c->r[10], 0u, 8u, 1u, 0u); /* orr r10, r9, r10, lsl #8 */
68342: L_10023454:
68343:     ngage_w16(c, c->r[0], (uint16_t)c->r[10]); c->r[0] += 2u; /* strh r10, [r0], #2 */
68344: L_10023458:
68345:     c->r[1] = c->r[1] + 0x00000001u; /* add r1, r1, #1 */
68346: L_1002345c:
68347:     ngage_sub_flags(c, c->r[1], c->r[3]); /* cmp r1, r3 */
68348: L_10023460:
68349:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_10023448; } /* blt 0x23448 <shadowkey_code+0x23448> */
68350: L_10023464:
68351:     fprintf(stderr,"TRACE text-convert result dst-end=%08x chars=%u capacity=%u source=%08x\n",c->r[0],c->r[1],c->r[3],c->r[10]);
68352:     c->r[0] = c->r[13] + 0x00000244u; /* add r0, sp, #580 */
68353: L_10023468:
68354:     c->r[0] = c->r[0] - 0x00000008u; /* sub r0, r0, #8 */
68355: L_1002346c:
68356:     c->r[1] = 0x00000100u; /* mov r1, #256 */
68357: L_10023470:
68358:     c->r[14] = 0x10023474u; ngage_call(c, 0x1009edc0u); goto L_10023474; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
68359: L_10023474:
68360:     c->r[0] = c->r[13] + 0x00000244u; /* add r0, sp, #580 */
68361: L_10023478:
68362:     c->r[0] = c->r[0] - 0x00000008u; /* sub r0, r0, #8 */
68363: L_1002347c:
68364:     c->r[1] = c->r[13] + 0x00000440u; /* add r1, sp, #1088 */
68365: L_10023480:
68366:     c->r[1] = c->r[1] + 0x00000004u; /* add r1, r1, #4 */
68367: L_10023484:
68368:     c->r[14] = 0x10023488u; ngage_call(c, 0x1009f220u); goto L_10023488; /* bl 0x9f220 <shadowkey_code+0x9f220> */
68369: L_10023488:
68370:     c->r[9] = ngage_r32(c, (c->r[13] + 12u)); /* ldr r9, [sp, #0xc] */
68371: L_1002348c:
68372:     c->r[5] = c->r[4]; /* mov r5, r4 */
68373: L_10023490:
68374:     c->r[4] = ~(0x00000470u); /* mvn r4, #1136 */
68375: L_10023494:
68376:     c->r[4] = c->r[4] - 0x00000007u; /* sub r4, r4, #7 */
68377: L_10023498:
68378:     ngage_sub_flags(c, c->r[9], 0x00000000u); /* cmp r9, #0 */
68379: L_1002349c:
68380:     if (ngage_zf(c)) { goto L_100234bc; } /* beq 0x234bc <shadowkey_code+0x234bc> */
68381: L_100234a0:
68382:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
68383: L_100234a4:
68384:     c->r[12] = ngage_r32(c, c->r[0]); /* ldr r12, [r0] */
68385: L_100234a8:
68386:     c->r[2] = 0x00000000u; /* mov r2, #0 */
68387: L_100234ac:
68388:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]); /* str r2, [sp, #0x4] */
68389: L_100234b0:
68390:     c->r[3] = 0x00000001u; /* mov r3, #1 */
68391: L_100234b4:
68392:     ngage_w32(c, c->r[13], (uint32_t)c->r[3]); /* str r3, [sp] */
68393: L_100234b8:
68394:     goto L_100234d0; /* b 0x234d0 <shadowkey_code+0x234d0> */
68395: L_100234bc:
68396:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
68397: L_100234c0:
68398:     c->r[10] = ngage_r32(c, (c->r[13] + 12u)); /* ldr r10, [sp, #0xc] */
68399: L_100234c4:
68400:     c->r[12] = ngage_r32(c, c->r[0]); /* ldr r12, [r0] */
68401: L_100234c8:
68402:     ngage_w32(c, c->r[13], (uint32_t)c->r[10]); /* str r10, [sp] */
68403: L_100234cc:
68404:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[10]); /* str r10, [sp, #0x4] */
68405: L_100234d0:
68406:     c->r[3] = ngage_r32(c, (c->r[13] + 8u)); /* ldr r3, [sp, #0x8] */
68407: L_100234d4:
68408:     c->r[4] = c->r[4] + c->r[13]; /* add r4, r4, sp */
SOURCE END

#### Call 9 — lifted line 68462

SOURCE BEGIN
68412:     c->r[1] = c->r[1] + 0x00000004u; /* add r1, r1, #4 */
68413: L_100234e0:
68414:     c->r[2] = c->r[13] + 0x00000640u; /* add r2, sp, #1600 */
68415: L_100234e4:
68416:     c->r[2] = c->r[2] + 0x00000004u; /* add r2, r2, #4 */
68417: L_100234e8:
68418:     c->r[12] = ngage_r32(c, (c->r[12] + 168u)); /* ldr r12, [r12, #0xa8] */
68419: L_100234ec:
68420:     c->r[14] = 0x100234f4u; /* mov lr, pc (ARM PC semantics) */
68421: L_100234f0:
68422:     ngage_call(c, c->r[12]); goto L_100234f4; /* bx r12 */
68423: L_100234f4:
68424:     c->r[4] = c->r[13] + 0x00000640u; /* add r4, sp, #1600 */
68425: L_100234f8:
68426:     c->r[4] = c->r[4] + 0x00000004u; /* add r4, r4, #4 */
68427: L_100234fc:
68428:     c->r[0] = c->r[4]; /* mov r0, r4 */
68429: L_10023500:
68430:     c->r[1] = 0x00000000u; /* mov r1, #0 */
68431: L_10023504:
68432:     c->r[2] = 0x0000000du; /* mov r2, #13 */
68433: L_10023508:
68434:     c->r[14] = 0x1002350cu; ngage_call(c, 0x1009f2a0u); goto L_1002350c; /* bl 0x9f2a0 <shadowkey_code+0x9f2a0> */
68435: L_1002350c:
68436:     c->r[6] = ngage_r16(c, c->r[6]); /* ldrh r6, [r6] */
68437: L_10023510:
68438:     ngage_sub_flags(c, c->r[6], 0x00000000u); /* cmp r6, #0 */
68439: L_10023514:
68440:     if (!ngage_zf(c)) { goto L_100235a4; } /* bne 0x235a4 <shadowkey_code+0x235a4> */
68441: L_10023518:
68442:     c->r[0] = c->r[13] + 0x00000034u; /* add r0, sp, #52 */
68443: L_1002351c:
68444:     c->r[1] = 0x00000100u; /* mov r1, #256 */
68445: L_10023520:
68446:     c->r[14] = 0x10023524u; ngage_call(c, 0x1009edc0u); goto L_10023524; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
68447: L_10023524:
68448:     c->r[9] = ngage_r32(c, (c->r[13] + 32u)); /* ldr r9, [sp, #0x20] */
68449: L_10023528:
68450:     c->r[3] = (c->r[5] << 1); /* lsl r3, r5, #1 */
68451: L_1002352c:
68452:     c->r[2] = ngage_r16(c, (c->r[3] + c->r[9])); /* ldrh r2, [r3, r9] */
68453: L_10023530:
68454:     c->r[0] = c->r[13] + 0x00000034u; /* add r0, sp, #52 */
68455: L_10023534:
68456:     ngage_sub_flags(c, c->r[2], 0x00000020u); /* cmp r2, #32 */
68457: L_10023538:
68458:     if (ngage_zf(c)) { c->r[5] = c->r[5] + 0x00000001u; } /* addeq r5, r5, #1 */
68459: L_1002353c:
68460:     c->r[1] = c->r[9] + shadowkey_arm_shift_operand(c, c->r[5], 0u, 1u, 1u, 0u); /* add r1, r9, r5, lsl #1 */
68461: L_10023540:
68462:     c->r[14] = 0x10023544u; ngage_call(c, 0x1009f220u); goto L_10023544; /* bl 0x9f220 <shadowkey_code+0x9f220> */
68463: L_10023544:
68464:     c->r[10] = ngage_r32(c, (c->r[13] + 12u)); /* ldr r10, [sp, #0xc] */
68465: L_10023548:
68466:     ngage_sub_flags(c, c->r[10], 0x00000000u); /* cmp r10, #0 */
68467: L_1002354c:
68468:     if (ngage_zf(c)) { goto L_10023564; } /* beq 0x23564 <shadowkey_code+0x23564> */
68469: L_10023550:
68470:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
68471: L_10023554:
68472:     c->r[12] = ngage_r32(c, c->r[0]); /* ldr r12, [r0] */
68473: L_10023558:
68474:     c->r[3] = 0x00000001u; /* mov r3, #1 */
68475: L_1002355c:
68476:     { uint32_t _b = c->r[13]; ngage_w32(c, _b, c->r[3]); ngage_w32(c, _b + 4u, c->r[6]); } /* stm sp, {r3, r6} */
68477: L_10023560:
68478:     goto L_10023578; /* b 0x23578 <shadowkey_code+0x23578> */
68479: L_10023564:
68480:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
68481: L_10023568:
68482:     c->r[9] = ngage_r32(c, (c->r[13] + 12u)); /* ldr r9, [sp, #0xc] */
68483: L_1002356c:
68484:     c->r[12] = ngage_r32(c, c->r[0]); /* ldr r12, [r0] */
68485: L_10023570:
68486:     ngage_w32(c, c->r[13], (uint32_t)c->r[9]); /* str r9, [sp] */
68487: L_10023574:
68488:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[9]); /* str r9, [sp, #0x4] */
68489: L_10023578:
68490:     c->r[3] = ngage_r32(c, (c->r[13] + 8u)); /* ldr r3, [sp, #0x8] */
68491: L_1002357c:
68492:     c->r[1] = c->r[13] + 0x00000034u; /* add r1, sp, #52 */
68493: L_10023580:
68494:     c->r[2] = c->r[4]; /* mov r2, r4 */
68495: L_10023584:
68496:     c->r[12] = ngage_r32(c, (c->r[12] + 168u)); /* ldr r12, [r12, #0xa8] */
68497: L_10023588:
68498:     c->r[14] = 0x10023590u; /* mov lr, pc (ARM PC semantics) */
68499: L_1002358c:
68500:     ngage_call(c, c->r[12]); goto L_10023590; /* bx r12 */
68501: L_10023590:
68502:     c->r[0] = c->r[13] + 0x00000640u; /* add r0, sp, #1600 */
SOURCE END

#### Call 10 — lifted line 68841

SOURCE BEGIN
68791:     c->r[0] = ngage_r32(c, (c->r[13] + 20u)); /* ldr r0, [sp, #0x14] */
68792: L_100237d0:
68793:     c->r[8] = ngage_r32(c, (c->r[13] + 4u)); /* ldr r8, [sp, #0x4] */
68794: L_100237d4:
68795:     c->r[1] = 0x00000000u; /* mov r1, #0 */
68796: L_100237d8:
68797:     c->r[10] = c->r[10] + 0x0000000du; /* add r10, r10, #13 */
68798: L_100237dc:
68799:     ngage_sub_flags(c, c->r[2], 0x00000020u); /* cmp r2, #32 */
68800: L_100237e0:
68801:     if (ngage_zf(c)) { c->r[4] = c->r[4] + 0x00000001u; } /* addeq r4, r4, #1 */
68802: L_100237e4:
68803:     c->r[3] = c->r[7] - c->r[4]; /* rsb r3, r4, r7 */
68804: L_100237e8:
68805:     ngage_sub_flags(c, c->r[1], c->r[3]); /* cmp r1, r3 */
68806: L_100237ec:
68807:     c->r[2] = c->r[8] + shadowkey_arm_shift_operand(c, c->r[4], 0u, 1u, 1u, 0u); /* add r2, r8, r4, lsl #1 */
68808: L_100237f0:
68809:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_10023810; } /* bge 0x23810 <shadowkey_code+0x23810> */
68810: L_100237f4:
68811:     c->r[8] = ngage_r8(c, c->r[2]); c->r[2] += 1u; /* ldrb r8, [r2], #1 */
68812: L_100237f8:
68813:     c->r[9] = ngage_r8(c, c->r[2]); c->r[2] += 1u; /* ldrb r9, [r2], #1 */
68814: L_100237fc:
68815:     c->r[9] = c->r[8] | shadowkey_arm_shift_operand(c, c->r[9], 0u, 8u, 1u, 0u); /* orr r9, r8, r9, lsl #8 */
68816: L_10023800:
68817:     ngage_w16(c, c->r[0], (uint16_t)c->r[9]); c->r[0] += 2u; /* strh r9, [r0], #2 */
68818: L_10023804:
68819:     c->r[1] = c->r[1] + 0x00000001u; /* add r1, r1, #1 */
68820: L_10023808:
68821:     ngage_sub_flags(c, c->r[1], c->r[3]); /* cmp r1, r3 */
68822: L_1002380c:
68823:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_100237f4; } /* blt 0x237f4 <shadowkey_code+0x237f4> */
68824: L_10023810:
68825:     c->r[0] = c->r[13] + 0x0000023cu; /* add r0, sp, #572 */
68826: L_10023814:
68827:     c->r[0] = c->r[0] - 0x00000008u; /* sub r0, r0, #8 */
68828: L_10023818:
68829:     c->r[1] = 0x00000100u; /* mov r1, #256 */
68830: L_1002381c:
68831:     c->r[14] = 0x10023820u; ngage_call(c, 0x1009edc0u); goto L_10023820; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
68832: L_10023820:
68833:     c->r[0] = c->r[13] + 0x0000023cu; /* add r0, sp, #572 */
68834: L_10023824:
68835:     c->r[0] = c->r[0] - 0x00000008u; /* sub r0, r0, #8 */
68836: L_10023828:
68837:     c->r[1] = c->r[13] + 0x00000430u; /* add r1, sp, #1072 */
68838: L_1002382c:
68839:     c->r[1] = c->r[1] + 0x0000000cu; /* add r1, r1, #12 */
68840: L_10023830:
68841:     c->r[14] = 0x10023834u; ngage_call(c, 0x1009f220u); goto L_10023834; /* bl 0x9f220 <shadowkey_code+0x9f220> */
68842: L_10023834:
68843:     c->r[8] = c->r[13] + 0x00000630u; /* add r8, sp, #1584 */
68844: L_10023838:
68845:     c->r[8] = c->r[8] + 0x0000000cu; /* add r8, r8, #12 */
68846: L_1002383c:
68847:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[8]); /* str r8, [sp, #0x8] */
68848: L_10023840:
68849:     c->r[0] = c->r[8]; /* mov r0, r8 */
68850: L_10023844:
68851:     c->r[1] = 0x00000000u; /* mov r1, #0 */
68852: L_10023848:
68853:     c->r[2] = 0x0000000du; /* mov r2, #13 */
68854: L_1002384c:
68855:     c->r[14] = 0x10023850u; ngage_call(c, 0x1009f2a0u); goto L_10023850; /* bl 0x9f2a0 <shadowkey_code+0x9f2a0> */
68856: L_10023850:
68857:     c->r[6] = ngage_r16(c, c->r[6]); /* ldrh r6, [r6] */
68858: L_10023854:
68859:     c->r[4] = c->r[7]; /* mov r4, r7 */
68860: L_10023858:
68861:     ngage_sub_flags(c, c->r[6], 0x00000000u); /* cmp r6, #0 */
68862: L_1002385c:
68863:     if (!ngage_zf(c)) { goto L_100238a4; } /* bne 0x238a4 <shadowkey_code+0x238a4> */
68864: L_10023860:
68865:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
68866: L_10023864:
68867:     c->r[1] = 0x00000100u; /* mov r1, #256 */
68868: L_10023868:
68869:     c->r[14] = 0x1002386cu; ngage_call(c, 0x1009edc0u); goto L_1002386c; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
68870: L_1002386c:
68871:     c->r[9] = ngage_r32(c, (c->r[13] + 4u)); /* ldr r9, [sp, #0x4] */
68872: L_10023870:
68873:     c->r[3] = (c->r[7] << 1); /* lsl r3, r7, #1 */
68874: L_10023874:
68875:     c->r[2] = ngage_r16(c, (c->r[3] + c->r[9])); /* ldrh r2, [r3, r9] */
68876: L_10023878:
68877:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
68878: L_1002387c:
68879:     ngage_sub_flags(c, c->r[2], 0x00000020u); /* cmp r2, #32 */
68880: L_10023880:
68881:     if (!ngage_zf(c)) { c->r[4] = c->r[7]; } /* movne r4, r7 */
SOURCE END

#### Call 11 — lifted line 68887

SOURCE BEGIN
68837:     c->r[1] = c->r[13] + 0x00000430u; /* add r1, sp, #1072 */
68838: L_1002382c:
68839:     c->r[1] = c->r[1] + 0x0000000cu; /* add r1, r1, #12 */
68840: L_10023830:
68841:     c->r[14] = 0x10023834u; ngage_call(c, 0x1009f220u); goto L_10023834; /* bl 0x9f220 <shadowkey_code+0x9f220> */
68842: L_10023834:
68843:     c->r[8] = c->r[13] + 0x00000630u; /* add r8, sp, #1584 */
68844: L_10023838:
68845:     c->r[8] = c->r[8] + 0x0000000cu; /* add r8, r8, #12 */
68846: L_1002383c:
68847:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[8]); /* str r8, [sp, #0x8] */
68848: L_10023840:
68849:     c->r[0] = c->r[8]; /* mov r0, r8 */
68850: L_10023844:
68851:     c->r[1] = 0x00000000u; /* mov r1, #0 */
68852: L_10023848:
68853:     c->r[2] = 0x0000000du; /* mov r2, #13 */
68854: L_1002384c:
68855:     c->r[14] = 0x10023850u; ngage_call(c, 0x1009f2a0u); goto L_10023850; /* bl 0x9f2a0 <shadowkey_code+0x9f2a0> */
68856: L_10023850:
68857:     c->r[6] = ngage_r16(c, c->r[6]); /* ldrh r6, [r6] */
68858: L_10023854:
68859:     c->r[4] = c->r[7]; /* mov r4, r7 */
68860: L_10023858:
68861:     ngage_sub_flags(c, c->r[6], 0x00000000u); /* cmp r6, #0 */
68862: L_1002385c:
68863:     if (!ngage_zf(c)) { goto L_100238a4; } /* bne 0x238a4 <shadowkey_code+0x238a4> */
68864: L_10023860:
68865:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
68866: L_10023864:
68867:     c->r[1] = 0x00000100u; /* mov r1, #256 */
68868: L_10023868:
68869:     c->r[14] = 0x1002386cu; ngage_call(c, 0x1009edc0u); goto L_1002386c; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
68870: L_1002386c:
68871:     c->r[9] = ngage_r32(c, (c->r[13] + 4u)); /* ldr r9, [sp, #0x4] */
68872: L_10023870:
68873:     c->r[3] = (c->r[7] << 1); /* lsl r3, r7, #1 */
68874: L_10023874:
68875:     c->r[2] = ngage_r16(c, (c->r[3] + c->r[9])); /* ldrh r2, [r3, r9] */
68876: L_10023878:
68877:     c->r[0] = c->r[13] + 0x0000002cu; /* add r0, sp, #44 */
68878: L_1002387c:
68879:     ngage_sub_flags(c, c->r[2], 0x00000020u); /* cmp r2, #32 */
68880: L_10023880:
68881:     if (!ngage_zf(c)) { c->r[4] = c->r[7]; } /* movne r4, r7 */
68882: L_10023884:
68883:     if (ngage_zf(c)) { c->r[4] = c->r[7] + 0x00000001u; } /* addeq r4, r7, #1 */
68884: L_10023888:
68885:     c->r[1] = c->r[9] + shadowkey_arm_shift_operand(c, c->r[4], 0u, 1u, 1u, 0u); /* add r1, r9, r4, lsl #1 */
68886: L_1002388c:
68887:     c->r[14] = 0x10023890u; ngage_call(c, 0x1009f220u); goto L_10023890; /* bl 0x9f220 <shadowkey_code+0x9f220> */
68888: L_10023890:
68889:     c->r[0] = ngage_r32(c, (c->r[13] + 8u)); /* ldr r0, [sp, #0x8] */
68890: L_10023894:
68891:     c->r[10] = c->r[10] + 0x0000000du; /* add r10, r10, #13 */
68892: L_10023898:
68893:     c->r[1] = c->r[6]; /* mov r1, r6 */
68894: L_1002389c:
68895:     c->r[2] = 0x0000000du; /* mov r2, #13 */
68896: L_100238a0:
68897:     c->r[14] = 0x100238a4u; ngage_call(c, 0x1009f2a0u); goto L_100238a4; /* bl 0x9f2a0 <shadowkey_code+0x9f2a0> */
68898: L_100238a4:
68899:     c->r[7] = c->r[5]; /* mov r7, r5 */
68900: L_100238a8:
68901:     c->r[5] = c->r[13] + 0x0000000cu; /* add r5, sp, #12 */
68902: L_100238ac:
68903:     { uint32_t _b = c->r[5]; c->r[5] = ngage_r32(c, _b); c->r[6] = ngage_r32(c, _b + 4u); } /* ldm r5, {r5, r6} */
68904: L_100238b0:
68905:     c->r[0] = ngage_r32(c, (c->r[13] + 4u)); /* ldr r0, [sp, #0x4] */
68906: L_100238b4:
68907:     c->r[14] = 0x100238b8u; ngage_call(c, 0x100a0530u); goto L_100238b8; /* bl 0xa0530 <shadowkey_code+0xa0530> */
68908: L_100238b8:
68909:     c->r[0] = c->r[0] + 0x00000001u; /* add r0, r0, #1 */
68910: L_100238bc:
68911:     ngage_sub_flags(c, c->r[5], c->r[0]); /* cmp r5, r0 */
68912: L_100238c0:
68913:     if (!ngage_cf(c)) { goto L_10023748; } /* blo 0x23748 <shadowkey_code+0x23748> */
68914: L_100238c4:
68915:     c->r[8] = ngage_r32(c, (c->r[13] + 28u)); /* ldr r8, [sp, #0x1c] */
68916: L_100238c8:
68917:     c->r[0] = ngage_r32(c, (c->r[8] + 748u)); /* ldr r0, [r8, #0x2ec] */
68918: L_100238cc:
68919:     c->r[3] = ngage_r32(c, c->r[0]); /* ldr r3, [r0] */
68920: L_100238d0:
68921:     c->r[12] = ngage_r32(c, (c->r[3] + 40u)); /* ldr r12, [r3, #0x28] */
68922: L_100238d4:
68923:     c->r[14] = 0x100238dcu; /* mov lr, pc (ARM PC semantics) */
68924: L_100238d8:
68925:     ngage_call(c, c->r[12]); goto L_100238dc; /* bx r12 */
68926: L_100238dc:
68927:     c->r[9] = ngage_r32(c, (c->r[13] + 24u)); /* ldr r9, [sp, #0x18] */
SOURCE END

#### Call 12 — lifted line 109337

SOURCE BEGIN
109287:     c->r[14] = 0x1003804cu; ngage_call(c, 0x1009ee20u); goto L_1003804c; /* bl 0x9ee20 <shadowkey_code+0x9ee20> */
109288: L_1003804c:
109289:     goto L_1003826c; /* b 0x3826c <shadowkey_code+0x3826c> */
109290: L_10038050:
109291:     c->r[9] = 0x100af410u; /* literal 0x10038208 */ /* ldr r9, [pc, #0x1b0] */
109292: L_10038054:
109293:     ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[9]); /* str r9, [sp, #0x4] */
109294: L_10038058:
109295:     c->r[10] = 0x100af3f0u; /* literal 0x1003820c */ /* ldr r10, [pc, #0x1ac] */
109296: L_1003805c:
109297:     c->r[3] = ngage_r8(c, (c->r[8] + 5u)); /* ldrb r3, [r8, #0x5] */
109298: L_10038060:
109299:     c->r[6] = c->r[0]; /* mov r6, r0 */
109300: L_10038064:
109301:     c->r[3] = c->r[3] + 0x00000001u; /* add r3, r3, #1 */
109302: L_10038068:
109303:     ngage_sub_flags(c, c->r[6], c->r[3]); /* cmp r6, r3 */
109304: L_1003806c:
109305:     if ((ngage_nf(c) == ngage_vf(c))) { goto L_100380d4; } /* bge 0x380d4 <shadowkey_code+0x380d4> */
109306: L_10038070:
109307:     c->r[5] = c->r[13] + 0x00000108u; /* add r5, sp, #264 */
109308: L_10038074:
109309:     c->r[4] = 0x000004a0u; /* mov r4, #1184 */
109310: L_10038078:
109311:     c->r[4] = c->r[4] + 0x00000008u; /* add r4, r4, #8 */
109312: L_1003807c:
109313:     c->r[3] = 0x00000000u; /* mov r3, #0 */
109314: L_10038080:
109315:     ngage_w32(c, (c->r[5] + 8u), (uint32_t)c->r[3]); /* str r3, [r5, #0x8] */
109316: L_10038084:
109317:     c->r[9] = 0x101002ecu; /* literal 0x10038210 */ /* ldr r9, [pc, #0x184] */
109318: L_10038088:
109319:     ngage_w32(c, (c->r[5] + 4u), (uint32_t)c->r[9]); /* str r9, [r5, #0x4] */
109320: L_1003808c:
109321:     c->r[1] = c->r[8] + shadowkey_arm_shift_operand(c, c->r[6], 0u, 6u, 1u, 0u); /* add r1, r8, r6, lsl #6 */
109322: L_10038090:
109323:     c->r[0] = c->r[5]; /* mov r0, r5 */
109324: L_10038094:
109325:     c->r[1] = c->r[1] + 0x00000006u; /* add r1, r1, #6 */
109326: L_10038098:
109327:     c->r[14] = 0x1003809cu; ngage_call(c, 0x1008fc04u); goto L_1003809c; /* bl 0x8fc04 <shadowkey_code+0x8fc04> */
109328: L_1003809c:
109329:     c->r[3] = ngage_r32(c, (c->r[7] + 8u)); /* ldr r3, [r7, #0x8] */
109330: L_100380a0:
109331:     c->r[1] = ngage_r32(c, (c->r[13] + 272u)); /* ldr r1, [sp, #0x110] */
109332: L_100380a4:
109333:     c->r[0] = ngage_r32(c, (c->r[3] + 1484u)); /* ldr r0, [r3, #0x5cc] */
109334: L_100380a8:
109335:     c->r[0] = c->r[0] + c->r[4]; /* add r0, r0, r4 */
109336: L_100380ac:
109337:     c->r[14] = 0x100380b0u; ngage_call(c, 0x1009f220u); goto L_100380b0; /* bl 0x9f220 <shadowkey_code+0x9f220> */
109338: L_100380b0:
109339:     c->r[0] = c->r[5]; /* mov r0, r5 */
109340: L_100380b4:
109341:     c->r[1] = 0x00000002u; /* mov r1, #2 */
109342: L_100380b8:
109343:     c->r[14] = 0x100380bcu; ngage_call(c, 0x1008fcccu); goto L_100380bc; /* bl 0x8fccc <shadowkey_code+0x8fccc> */
109344: L_100380bc:
109345:     c->r[3] = ngage_r8(c, (c->r[8] + 5u)); /* ldrb r3, [r8, #0x5] */
109346: L_100380c0:
109347:     c->r[6] = c->r[6] + 0x00000001u; /* add r6, r6, #1 */
109348: L_100380c4:
109349:     c->r[4] = c->r[4] + 0x00000208u; /* add r4, r4, #520 */
109350: L_100380c8:
109351:     c->r[3] = c->r[3] + 0x00000001u; /* add r3, r3, #1 */
109352: L_100380cc:
109353:     ngage_sub_flags(c, c->r[6], c->r[3]); /* cmp r6, r3 */
109354: L_100380d0:
109355:     if ((ngage_nf(c) != ngage_vf(c))) { goto L_1003807c; } /* blt 0x3807c <shadowkey_code+0x3807c> */
109356: L_100380d4:
109357:     c->r[3] = ngage_r32(c, (c->r[7] + 8u)); /* ldr r3, [r7, #0x8] */
109358: L_100380d8:
109359:     c->r[1] = ngage_r32(c, (c->r[3] + 1560u)); /* ldr r1, [r3, #0x618] */
109360: L_100380dc:
109361:     c->r[2] = 0x000001e4u; /* mov r2, #484 */
109362: L_100380e0:
109363:     c->r[6] = 0x00000000u; /* mov r6, #0 */
109364: L_100380e4:
109365:     ngage_w8(c, (c->r[1] + c->r[2]), (uint8_t)c->r[6]); /* strb r6, [r1, r2] */
109366: L_100380e8:
109367:     c->r[3] = ngage_r32(c, (c->r[7] + 8u)); /* ldr r3, [r7, #0x8] */
109368: L_100380ec:
109369:     c->r[0] = ngage_r32(c, (c->r[3] + 40u)); /* ldr r0, [r3, #0x28] */
109370: L_100380f0:
109371:     c->r[1] = c->r[6]; /* mov r1, r6 */
109372: L_100380f4:
109373:     c->r[14] = 0x100380f8u; ngage_call(c, 0x1002c274u); goto L_100380f8; /* bl 0x2c274 <shadowkey_code+0x2c274> */
109374: L_100380f8:
109375:     c->r[2] = ngage_r8(c, (c->r[8] + 5u)); /* ldrb r2, [r8, #0x5] */
109376: L_100380fc:
109377:     ngage_w32(c, c->r[13], (uint32_t)c->r[2]); /* str r2, [sp] */
SOURCE END

## Audit constraints

- Register and stack arguments must be reconstructed from the callsite, not inferred from ordinal number alone.
- Return values must be followed into caller-side status checks and subsequent reads/writes.
- Do not implement either import until object type, ownership, and failure behavior are established.
- EUSER248's previous text-path hypothesis is not treated as proven by this audit.
