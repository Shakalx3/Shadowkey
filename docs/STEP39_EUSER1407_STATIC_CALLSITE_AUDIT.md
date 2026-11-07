# Step 39 — EUSER1407 static callsite audit

Generated from the extracted archive committed under source_bundle/.

- Import thunk mapping: { 0x1009f0f0u, 0x101007a4u, "EUSER[100039e5].DLL", 1407u },
- Lifted source size: 16397565 bytes; 323977 lines
- Static references found: **10**

## Callsite context

Each excerpt includes the enclosing function label where detectable and 28 lines before / 10 lines after the import call.
### Reference 1 — line 26222, function function boundary not yet resolved

SOURCE BEGIN
26194: }
26195: 
26196: void sub_1000d3ec(ngage_cpu_t *c) {
26197:     (void)c;
26198:     if (0) { goto L_1000d3ec; goto L_1000d3f0; goto L_1000d3f4; goto L_1000d3f8; goto L_1000d3fc; goto L_1000d400; goto L_1000d404; goto L_1000d408; goto L_1000d40c; goto L_1000d410; goto L_1000d414; goto L_1000d418; goto L_1000d41c; goto L_1000d420; goto L_1000d424; goto L_1000d428; goto L_1000d42c; goto L_1000d430; goto L_1000d434; goto L_1000d438; goto L_1000d43c; goto L_1000d440; goto L_1000d444; goto L_1000d448; goto L_1000d44c; goto L_1000d450; goto L_1000d454; goto L_1000d458; goto L_1000d45c; goto L_1000d460; goto L_1000d464; goto L_1000d468; goto L_1000d46c; goto L_1000d470; goto L_1000d474; goto L_1000d478; goto L_1000d47c; goto L_1000d480; goto L_1000d484; goto L_1000d488; goto L_1000d48c; goto L_1000d490; goto L_1000d494; goto L_1000d498; goto L_1000d49c; goto L_1000d4a0; goto L_1000d4a4; goto L_1000d4a8; goto L_1000d4ac; goto L_1000d4b0; goto L_1000d4b4; goto L_1000d4b8; goto L_1000d4bc; goto L_1000d4c0; goto L_1000d4c4; goto L_1000d4c8; goto L_1000d4cc; goto L_1000d4d0; goto L_1000d4d4; goto L_1000d4d8; goto L_1000d4dc; goto L_1000d4e0; goto L_1000d4e4; goto L_1000d4e8; goto L_1000d4ec; goto L_1000d4f0; goto L_1000d4f4; goto L_1000d4f8; goto L_1000d4fc; goto L_1000d500; goto L_1000d504; goto L_1000d508; goto L_1000d50c; goto L_1000d510; goto L_1000d514; goto L_1000d51c; goto L_1000d520; goto L_1000d524; goto L_1000d528; goto L_1000d52c; goto L_1000d530; }
26199: L_1000d3ec:
26200:     c->r[13] -= 20u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[14]); /* push {r4, r5, r6, r7, lr} */
26201: L_1000d3f0:
26202:     c->r[1] = 0x00000100u; /* mov r1, #256 */
26203: L_1000d3f4:
26204:     c->r[13] = c->r[13] - 0x00000460u; /* sub sp, sp, #1120 */
26205: L_1000d3f8:
26206:     c->r[7] = c->r[0]; /* mov r7, r0 */
26207: L_1000d3fc:
26208:     c->r[0] = c->r[13] + 0x00000258u; /* add r0, sp, #600 */
26209: L_1000d400:
26210:     c->r[14] = 0x1000d404u; ngage_call(c, 0x1009edc0u); goto L_1000d404; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
26211: L_1000d404:
26212:     c->r[1] = 0x100a6470u; /* literal 0x1000d518 */ /* ldr r1, [pc, #0x10c] */
26213: L_1000d408:
26214:     c->r[4] = c->r[13] + 0x00000010u; /* add r4, sp, #16 */
26215: L_1000d40c:
26216:     c->r[4] = c->r[4] - 0x00000008u; /* sub r4, r4, #8 */
26217: L_1000d410:
26218:     c->r[0] = c->r[4]; /* mov r0, r4 */
26219: L_1000d414:
26220:     c->r[5] = c->r[13] + 0x00000258u; /* add r5, sp, #600 */
26221: L_1000d418:
26222:     c->r[14] = 0x1000d41cu; ngage_call(c, 0x1009f0f0u); goto L_1000d41c; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
26223: L_1000d41c:
26224:     c->r[0] = c->r[5]; /* mov r0, r5 */
26225: L_1000d420:
26226:     c->r[1] = c->r[4]; /* mov r1, r4 */
26227: L_1000d424:
26228:     c->r[2] = ~(0xe0000009u); /* mvn r2, #-536870903 */
26229: L_1000d428:
26230:     c->r[2] = c->r[2] - 0x0fe00000u; /* sub r2, r2, #266338304 */
26231: L_1000d42c:
26232:     c->r[2] = c->r[2] - 0x00002c00u; /* sub r2, r2, #11264 */
SOURCE END

### Reference 2 — line 26401, function function boundary not yet resolved

SOURCE BEGIN
26373:     c->r[13] = c->r[13] - 0x00000008u; /* sub sp, sp, #8 */
26374: L_1000d544:
26375:     c->r[7] = c->r[0]; /* mov r7, r0 */
26376: L_1000d548:
26377:     c->r[6] = c->r[13] + 0x00000260u; /* add r6, sp, #608 */
26378: L_1000d54c:
26379:     c->r[0] = c->r[6]; /* mov r0, r6 */
26380: L_1000d550:
26381:     c->r[1] = c->r[7] + 0x00000278u; /* add r1, r7, #632 */
26382: L_1000d554:
26383:     c->r[14] = 0x1000d558u; ngage_call(c, 0x1009f0e0u); goto L_1000d558; /* bl 0x9f0e0 <shadowkey_code+0x9f0e0> */
26384: L_1000d558:
26385:     c->r[0] = c->r[13] + 0x00000058u; /* add r0, sp, #88 */
26386: L_1000d55c:
26387:     c->r[1] = 0x00000100u; /* mov r1, #256 */
26388: L_1000d560:
26389:     c->r[14] = 0x1000d564u; ngage_call(c, 0x1009edc0u); goto L_1000d564; /* bl 0x9edc0 <shadowkey_code+0x9edc0> */
26390: L_1000d564:
26391:     c->r[1] = 0x100a6470u; /* literal 0x1000d67c */ /* ldr r1, [pc, #0x110] */
26392: L_1000d568:
26393:     c->r[4] = c->r[13] + 0x00000018u; /* add r4, sp, #24 */
26394: L_1000d56c:
26395:     c->r[4] = c->r[4] - 0x00000008u; /* sub r4, r4, #8 */
26396: L_1000d570:
26397:     c->r[0] = c->r[4]; /* mov r0, r4 */
26398: L_1000d574:
26399:     c->r[5] = c->r[13] + 0x00000058u; /* add r5, sp, #88 */
26400: L_1000d578:
26401:     c->r[14] = 0x1000d57cu; ngage_call(c, 0x1009f0f0u); goto L_1000d57c; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
26402: L_1000d57c:
26403:     c->r[0] = c->r[5]; /* mov r0, r5 */
26404: L_1000d580:
26405:     c->r[1] = c->r[4]; /* mov r1, r4 */
26406: L_1000d584:
26407:     c->r[2] = ~(0xe0000009u); /* mvn r2, #-536870903 */
26408: L_1000d588:
26409:     c->r[2] = c->r[2] - 0x0fe00000u; /* sub r2, r2, #266338304 */
26410: L_1000d58c:
26411:     c->r[2] = c->r[2] - 0x00002c00u; /* sub r2, r2, #11264 */
SOURCE END

### Reference 3 — line 63115, function function boundary not yet resolved

SOURCE BEGIN
63087:     c->r[0] = c->r[4]; /* mov r0, r4 */
63088: L_10020aac:
63089:     c->r[14] = 0x10020ab0u; ngage_call(c, 0x1009ee20u); goto L_10020ab0; /* bl 0x9ee20 <shadowkey_code+0x9ee20> */
63090: L_10020ab0:
63091:     c->r[4] = 0x00002700u; /* mov r4, #9984 */
63092: L_10020ab4:
63093:     c->r[4] = c->r[4] + 0x00000010u; /* add r4, r4, #16 */
63094: L_10020ab8:
63095:     c->r[0] = c->r[4]; /* mov r0, r4 */
63096: L_10020abc:
63097:     c->r[14] = 0x10020ac0u; ngage_call(c, 0x1009ee20u); goto L_10020ac0; /* bl 0x9ee20 <shadowkey_code+0x9ee20> */
63098: L_10020ac0:
63099:     c->r[0] = c->r[5]; /* mov r0, r5 */
63100: L_10020ac4:
63101:     c->r[14] = 0x10020ac8u; ngage_call(c, 0x1009f6f0u); goto L_10020ac8; /* bl 0x9f6f0 <shadowkey_code+0x9f6f0> */
63102: L_10020ac8:
63103:     c->r[0] = c->r[4]; /* mov r0, r4 */
63104: L_10020acc:
63105:     c->r[14] = 0x10020ad0u; ngage_call(c, 0x1009ee20u); goto L_10020ad0; /* bl 0x9ee20 <shadowkey_code+0x9ee20> */
63106: L_10020ad0:
63107:     goto L_10020af8; /* b 0x20af8 <shadowkey_code+0x20af8> */
63108: L_10020ad4:
63109:     c->r[1] = 0x100abf28u; /* literal 0x10020af4 */ /* ldr r1, [pc, #0x18] */
63110: L_10020ad8:
63111:     c->r[4] = c->r[13]; /* mov r4, sp */
63112: L_10020adc:
63113:     c->r[0] = c->r[4]; /* mov r0, r4 */
63114: L_10020ae0:
63115:     c->r[14] = 0x10020ae4u; ngage_call(c, 0x1009f0f0u); goto L_10020ae4; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
63116: L_10020ae4:
63117:     c->r[0] = c->r[4]; /* mov r0, r4 */
63118: L_10020ae8:
63119:     c->r[1] = 0x00000001u; /* mov r1, #1 */
63120: L_10020aec:
63121:     c->r[14] = 0x10020af0u; ngage_call(c, 0x1009f1d0u); goto L_10020af0; /* bl 0x9f1d0 <shadowkey_code+0x9f1d0> */
63122: L_10020af0:
63123:     goto L_10020af8; /* b 0x20af8 <shadowkey_code+0x20af8> */
63124: L_10020af8:
63125:     c->r[13] = c->r[13] + 0x00000008u; /* add sp, sp, #8 */
SOURCE END

### Reference 4 — line 67198, function function boundary not yet resolved

SOURCE BEGIN
67170:     c->r[5] = ngage_r32(c, (c->r[13] + 720u)); /* ldr r5, [sp, #0x2d0] */
67171: L_10022b48:
67172:     c->r[10] = 0x00000000u; /* mov r10, #0 */
67173: L_10022b4c:
67174:     c->r[8] = c->r[0]; /* mov r8, r0 */
67175: L_10022b50:
67176:     ngage_sub_flags(c, c->r[5], c->r[10]); /* cmp r5, r10 */
67177: L_10022b54:
67178:     if (ngage_zf(c)) { goto L_10022b60; } /* beq 0x22b60 <shadowkey_code+0x22b60> */
67179: L_10022b58:
67180:     ngage_sub_flags(c, c->r[5], 0x00000001u); /* cmp r5, #1 */
67181: L_10022b5c:
67182:     if (ngage_zf(c)) { goto L_10022b70; } /* beq 0x22b70 <shadowkey_code+0x22b70> */
67183: L_10022b60:
67184:     c->r[0] = ngage_r32(c, (c->r[8] + 8u)); /* ldr r0, [r8, #0x8] */
67185: L_10022b64:
67186:     c->r[14] = 0x10022b68u; ngage_call(c, 0x1009f8e0u); goto L_10022b68; /* bl 0x9f8e0 <shadowkey_code+0x9f8e0> */
67187: L_10022b68:
67188:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[0]); /* str r0, [sp, #0x18] */
67189: L_10022b6c:
67190:     goto L_10022bf4; /* b 0x22bf4 <shadowkey_code+0x22bf4> */
67191: L_10022b70:
67192:     c->r[1] = 0x100ac718u; /* literal 0x10022bc4 */ /* ldr r1, [pc, #0x4c] */
67193: L_10022b74:
67194:     c->r[4] = c->r[13] + 0x0000001cu; /* add r4, sp, #28 */
67195: L_10022b78:
67196:     c->r[0] = c->r[4]; /* mov r0, r4 */
67197: L_10022b7c:
67198:     c->r[14] = 0x10022b80u; ngage_call(c, 0x1009f0f0u); goto L_10022b80; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
67199: L_10022b80:
67200:     c->r[0] = c->r[13] + 0x0000026cu; /* add r0, sp, #620 */
67201: L_10022b84:
67202:     c->r[1] = c->r[4]; /* mov r1, r4 */
67203: L_10022b88:
67204:     c->r[2] = 0x00000014u; /* mov r2, #20 */
67205: L_10022b8c:
67206:     c->r[14] = 0x10022b90u; ngage_call(c, 0x1009f090u); goto L_10022b90; /* bl 0x9f090 <shadowkey_code+0x9f090> */
67207: L_10022b90:
67208:     c->r[0] = c->r[13] + 0x0000022cu; /* add r0, sp, #556 */
SOURCE END

### Reference 5 — line 67479, function function boundary not yet resolved

SOURCE BEGIN
67451:     c->r[5] = ngage_r32(c, (c->r[13] + 720u)); /* ldr r5, [sp, #0x2d0] */
67452: L_10022d74:
67453:     c->r[10] = c->r[2]; /* mov r10, r2 */
67454: L_10022d78:
67455:     c->r[8] = c->r[0]; /* mov r8, r0 */
67456: L_10022d7c:
67457:     ngage_sub_flags(c, c->r[5], c->r[9]); /* cmp r5, r9 */
67458: L_10022d80:
67459:     if (ngage_zf(c)) { goto L_10022d8c; } /* beq 0x22d8c <shadowkey_code+0x22d8c> */
67460: L_10022d84:
67461:     ngage_sub_flags(c, c->r[5], 0x00000001u); /* cmp r5, #1 */
67462: L_10022d88:
67463:     if (ngage_zf(c)) { goto L_10022d9c; } /* beq 0x22d9c <shadowkey_code+0x22d9c> */
67464: L_10022d8c:
67465:     c->r[0] = ngage_r32(c, (c->r[8] + 8u)); /* ldr r0, [r8, #0x8] */
67466: L_10022d90:
67467:     c->r[14] = 0x10022d94u; ngage_call(c, 0x1009f8e0u); goto L_10022d94; /* bl 0x9f8e0 <shadowkey_code+0x9f8e0> */
67468: L_10022d94:
67469:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[0]); /* str r0, [sp, #0x18] */
67470: L_10022d98:
67471:     goto L_10022e24; /* b 0x22e24 <shadowkey_code+0x22e24> */
67472: L_10022d9c:
67473:     c->r[1] = 0x100ac718u; /* literal 0x10022df0 */ /* ldr r1, [pc, #0x4c] */
67474: L_10022da0:
67475:     c->r[4] = c->r[13] + 0x0000001cu; /* add r4, sp, #28 */
67476: L_10022da4:
67477:     c->r[0] = c->r[4]; /* mov r0, r4 */
67478: L_10022da8:
67479:     c->r[14] = 0x10022dacu; ngage_call(c, 0x1009f0f0u); goto L_10022dac; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
67480: L_10022dac:
67481:     c->r[0] = c->r[13] + 0x0000026cu; /* add r0, sp, #620 */
67482: L_10022db0:
67483:     c->r[1] = c->r[4]; /* mov r1, r4 */
67484: L_10022db4:
67485:     c->r[2] = 0x00000014u; /* mov r2, #20 */
67486: L_10022db8:
67487:     c->r[14] = 0x10022dbcu; ngage_call(c, 0x1009f090u); goto L_10022dbc; /* bl 0x9f090 <shadowkey_code+0x9f090> */
67488: L_10022dbc:
67489:     c->r[0] = c->r[13] + 0x0000022cu; /* add r0, sp, #556 */
SOURCE END

### Reference 6 — line 67768, function function boundary not yet resolved

SOURCE BEGIN
67740:     c->r[5] = ngage_r32(c, (c->r[13] + 720u)); /* ldr r5, [sp, #0x2d0] */
67741: L_10022fb0:
67742:     c->r[10] = 0x00000000u; /* mov r10, #0 */
67743: L_10022fb4:
67744:     c->r[8] = c->r[0]; /* mov r8, r0 */
67745: L_10022fb8:
67746:     ngage_sub_flags(c, c->r[5], c->r[10]); /* cmp r5, r10 */
67747: L_10022fbc:
67748:     if (ngage_zf(c)) { goto L_10022fc8; } /* beq 0x22fc8 <shadowkey_code+0x22fc8> */
67749: L_10022fc0:
67750:     ngage_sub_flags(c, c->r[5], 0x00000001u); /* cmp r5, #1 */
67751: L_10022fc4:
67752:     if (ngage_zf(c)) { goto L_10022fd8; } /* beq 0x22fd8 <shadowkey_code+0x22fd8> */
67753: L_10022fc8:
67754:     c->r[0] = ngage_r32(c, (c->r[8] + 8u)); /* ldr r0, [r8, #0x8] */
67755: L_10022fcc:
67756:     c->r[14] = 0x10022fd0u; ngage_call(c, 0x1009f8e0u); goto L_10022fd0; /* bl 0x9f8e0 <shadowkey_code+0x9f8e0> */
67757: L_10022fd0:
67758:     ngage_w32(c, (c->r[13] + 24u), (uint32_t)c->r[0]); /* str r0, [sp, #0x18] */
67759: L_10022fd4:
67760:     goto L_1002305c; /* b 0x2305c <shadowkey_code+0x2305c> */
67761: L_10022fd8:
67762:     c->r[1] = 0x100ac718u; /* literal 0x1002302c */ /* ldr r1, [pc, #0x4c] */
67763: L_10022fdc:
67764:     c->r[4] = c->r[13] + 0x0000001cu; /* add r4, sp, #28 */
67765: L_10022fe0:
67766:     c->r[0] = c->r[4]; /* mov r0, r4 */
67767: L_10022fe4:
67768:     c->r[14] = 0x10022fe8u; ngage_call(c, 0x1009f0f0u); goto L_10022fe8; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
67769: L_10022fe8:
67770:     c->r[0] = c->r[13] + 0x0000026cu; /* add r0, sp, #620 */
67771: L_10022fec:
67772:     c->r[1] = c->r[4]; /* mov r1, r4 */
67773: L_10022ff0:
67774:     c->r[2] = 0x00000014u; /* mov r2, #20 */
67775: L_10022ff4:
67776:     c->r[14] = 0x10022ff8u; ngage_call(c, 0x1009f090u); goto L_10022ff8; /* bl 0x9f090 <shadowkey_code+0x9f090> */
67777: L_10022ff8:
67778:     c->r[0] = c->r[13] + 0x0000022cu; /* add r0, sp, #556 */
SOURCE END

### Reference 7 — line 68064, function function boundary not yet resolved

SOURCE BEGIN
68036:     ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[2]); /* str r2, [sp, #0x8] */
68037: L_100231f8:
68038:     c->r[12] = ngage_r32(c, (c->r[13] + 1776u)); /* ldr r12, [sp, #0x6f0] */
68039: L_100231fc:
68040:     c->r[8] = c->r[0]; /* mov r8, r0 */
68041: L_10023200:
68042:     c->r[7] = c->r[3]; /* mov r7, r3 */
68043: L_10023204:
68044:     ngage_sub_flags(c, c->r[12], c->r[10]); /* cmp r12, r10 */
68045: L_10023208:
68046:     if (ngage_zf(c)) { goto L_1002321c; } /* beq 0x2321c <shadowkey_code+0x2321c> */
68047: L_1002320c:
68048:     c->r[0] = ngage_r32(c, (c->r[8] + 8u)); /* ldr r0, [r8, #0x8] */
68049: L_10023210:
68050:     c->r[14] = 0x10023214u; ngage_call(c, 0x1009f8e0u); goto L_10023214; /* bl 0x9f8e0 <shadowkey_code+0x9f8e0> */
68051: L_10023214:
68052:     ngage_w32(c, (c->r[13] + 40u), (uint32_t)c->r[0]); /* str r0, [sp, #0x28] */
68053: L_10023218:
68054:     goto L_100232bc; /* b 0x232bc <shadowkey_code+0x232bc> */
68055: L_1002321c:
68056:     c->r[1] = 0x100ac718u; /* literal 0x10023280 */ /* ldr r1, [pc, #0x5c] */
68057: L_10023220:
68058:     c->r[4] = c->r[13] + 0x00000034u; /* add r4, sp, #52 */
68059: L_10023224:
68060:     c->r[4] = c->r[4] - 0x00000008u; /* sub r4, r4, #8 */
68061: L_10023228:
68062:     c->r[0] = c->r[4]; /* mov r0, r4 */
68063: L_1002322c:
68064:     c->r[14] = 0x10023230u; ngage_call(c, 0x1009f0f0u); goto L_10023230; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
68065: L_10023230:
68066:     c->r[0] = c->r[13] + 0x00000680u; /* add r0, sp, #1664 */
68067: L_10023234:
68068:     c->r[0] = c->r[0] + 0x00000004u; /* add r0, r0, #4 */
68069: L_10023238:
68070:     c->r[1] = c->r[4]; /* mov r1, r4 */
68071: L_1002323c:
68072:     c->r[2] = 0x00000014u; /* mov r2, #20 */
68073: L_10023240:
68074:     c->r[14] = 0x10023244u; ngage_call(c, 0x1009f090u); goto L_10023244; /* bl 0x9f090 <shadowkey_code+0x9f090> */
SOURCE END

### Reference 8 — line 68615, function function boundary not yet resolved

SOURCE BEGIN
68587:     ngage_w32(c, (c->r[13] + 28u), (uint32_t)c->r[0]); /* str r0, [sp, #0x1c] */
68588: L_10023634:
68589:     { uint32_t _b = c->r[13]; ngage_w32(c, _b + 4u, c->r[1]); ngage_w32(c, _b + 8u, c->r[2]); } /* stmib sp, {r1, r2} */
68590: L_10023638:
68591:     c->r[12] = ngage_r32(c, (c->r[13] + 1768u)); /* ldr r12, [sp, #0x6e8] */
68592: L_1002363c:
68593:     c->r[7] = c->r[3]; /* mov r7, r3 */
68594: L_10023640:
68595:     ngage_sub_flags(c, c->r[12], c->r[10]); /* cmp r12, r10 */
68596: L_10023644:
68597:     if (ngage_zf(c)) { goto L_10023658; } /* beq 0x23658 <shadowkey_code+0x23658> */
68598: L_10023648:
68599:     c->r[0] = ngage_r32(c, (c->r[0] + 8u)); /* ldr r0, [r0, #0x8] */
68600: L_1002364c:
68601:     c->r[14] = 0x10023650u; ngage_call(c, 0x1009f8e0u); goto L_10023650; /* bl 0x9f8e0 <shadowkey_code+0x9f8e0> */
68602: L_10023650:
68603:     ngage_w32(c, (c->r[13] + 32u), (uint32_t)c->r[0]); /* str r0, [sp, #0x20] */
68604: L_10023654:
68605:     goto L_10023708; /* b 0x23708 <shadowkey_code+0x23708> */
68606: L_10023658:
68607:     c->r[1] = 0x100ac718u; /* literal 0x100236c4 */ /* ldr r1, [pc, #0x64] */
68608: L_1002365c:
68609:     c->r[4] = c->r[13] + 0x0000002cu; /* add r4, sp, #44 */
68610: L_10023660:
68611:     c->r[4] = c->r[4] - 0x00000008u; /* sub r4, r4, #8 */
68612: L_10023664:
68613:     c->r[0] = c->r[4]; /* mov r0, r4 */
68614: L_10023668:
68615:     c->r[14] = 0x1002366cu; ngage_call(c, 0x1009f0f0u); goto L_1002366c; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
68616: L_1002366c:
68617:     c->r[0] = c->r[13] + 0x00000670u; /* add r0, sp, #1648 */
68618: L_10023670:
68619:     c->r[0] = c->r[0] + 0x0000000cu; /* add r0, r0, #12 */
68620: L_10023674:
68621:     c->r[1] = c->r[4]; /* mov r1, r4 */
68622: L_10023678:
68623:     c->r[2] = 0x00000014u; /* mov r2, #20 */
68624: L_1002367c:
68625:     c->r[14] = 0x10023680u; ngage_call(c, 0x1009f090u); goto L_10023680; /* bl 0x9f090 <shadowkey_code+0x9f090> */
SOURCE END

### Reference 9 — line 186065, function function boundary not yet resolved

SOURCE BEGIN
186037:     if (!ngage_zf(c)) { goto L_10060920; } /* bne 0x60920 <shadowkey_code+0x60920> */
186038: L_10060904:
186039:     c->r[0] = 0x00000090u; /* mov r0, #144 */
186040: L_10060908:
186041:     c->r[14] = 0x1006090cu; ngage_call(c, 0x1009f020u); goto L_1006090c; /* bl 0x9f020 <shadowkey_code+0x9f020> */
186042: L_1006090c:
186043:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
186044: L_10060910:
186045:     if (!ngage_zf(c)) { c->r[14] = 0x10060914u; ngage_call(c, 0x1009fbd0u); goto L_10060914; } /* blne 0x9fbd0 <shadowkey_code+0x9fbd0> */
186046: L_10060914:
186047:     c->r[1] = c->r[4]; /* mov r1, r4 */
186048: L_10060918:
186049:     c->r[14] = 0x1006091cu; ngage_call(c, 0x1009fbe0u); goto L_1006091c; /* bl 0x9fbe0 <shadowkey_code+0x9fbe0> */
186050: L_1006091c:
186051:     c->r[14] = 0x10060920u; ngage_call(c, 0x1009ef40u); goto L_10060920; /* bl 0x9ef40 <shadowkey_code+0x9ef40> */
186052: L_10060920:
186053:     c->r[3] = ngage_r32(c, (c->r[13] + 8u)); /* ldr r3, [sp, #0x8] */
186054: L_10060924:
186055:     ngage_sub_flags(c, c->r[3], 0x00000000u); /* cmp r3, #0 */
186056: L_10060928:
186057:     if (ngage_zf(c)) { goto L_10060950; } /* beq 0x60950 <shadowkey_code+0x60950> */
186058: L_1006092c:
186059:     c->r[1] = 0x100b1068u; /* literal 0x1006094c */ /* ldr r1, [pc, #0x18] */
186060: L_10060930:
186061:     c->r[4] = c->r[13]; /* mov r4, sp */
186062: L_10060934:
186063:     c->r[0] = c->r[4]; /* mov r0, r4 */
186064: L_10060938:
186065:     c->r[14] = 0x1006093cu; ngage_call(c, 0x1009f0f0u); goto L_1006093c; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
186066: L_1006093c:
186067:     c->r[0] = c->r[4]; /* mov r0, r4 */
186068: L_10060940:
186069:     c->r[1] = 0x00000001u; /* mov r1, #1 */
186070: L_10060944:
186071:     c->r[14] = 0x10060948u; ngage_call(c, 0x1009f1d0u); goto L_10060948; /* bl 0x9f1d0 <shadowkey_code+0x9f1d0> */
186072: L_10060948:
186073:     goto L_10060950; /* b 0x60950 <shadowkey_code+0x60950> */
186074: L_10060950:
186075:     c->r[13] = c->r[13] + 0x00000058u; /* add sp, sp, #88 */
SOURCE END

### Reference 10 — line 247389, function function boundary not yet resolved

SOURCE BEGIN
247361:     if (0) { goto L_10081184; goto L_10081188; goto L_1008118c; goto L_10081190; goto L_10081194; goto L_10081198; goto L_1008119c; goto L_100811a0; goto L_100811a4; goto L_100811a8; goto L_100811ac; goto L_100811b0; goto L_100811b4; goto L_100811b8; goto L_100811bc; goto L_100811c0; goto L_100811c4; goto L_100811c8; goto L_100811cc; goto L_100811d0; goto L_100811d4; goto L_100811dc; goto L_100811e0; goto L_100811e4; goto L_100811e8; goto L_100811ec; goto L_100811f0; goto L_100811f4; goto L_100811f8; goto L_100811fc; goto L_10081200; goto L_10081204; goto L_10081208; goto L_1008120c; goto L_10081210; goto L_10081214; goto L_10081218; goto L_1008121c; goto L_10081220; goto L_10081224; goto L_10081228; goto L_1008122c; goto L_10081230; goto L_10081234; goto L_10081238; goto L_1008123c; goto L_10081240; goto L_10081244; goto L_10081248; goto L_1008124c; goto L_10081250; goto L_10081254; goto L_10081258; goto L_1008125c; goto L_10081260; goto L_10081264; goto L_10081268; goto L_1008126c; goto L_10081270; goto L_10081274; goto L_10081278; goto L_1008127c; goto L_10081280; goto L_10081284; goto L_10081288; goto L_1008128c; goto L_10081290; goto L_10081294; goto L_10081298; goto L_1008129c; goto L_100812a0; goto L_100812a4; goto L_100812a8; goto L_100812ac; goto L_100812b0; goto L_100812b4; goto L_100812b8; goto L_100812bc; goto L_100812c0; goto L_100812c4; goto L_100812c8; goto L_100812cc; goto L_100812d0; goto L_100812d4; goto L_100812d8; goto L_100812dc; goto L_100812e0; goto L_100812e4; goto L_100812e8; goto L_100812ec; goto L_100812f0; goto L_100812f4; goto L_100812f8; goto L_100812fc; goto L_10081300; goto L_10081304; goto L_10081308; goto L_1008130c; goto L_10081310; goto L_10081314; goto L_10081318; goto L_1008131c; }
247362: L_10081184:
247363:     c->r[13] -= 24u; ngage_w32(c, c->r[13] + 0u, c->r[4]); ngage_w32(c, c->r[13] + 4u, c->r[5]); ngage_w32(c, c->r[13] + 8u, c->r[6]); ngage_w32(c, c->r[13] + 12u, c->r[7]); ngage_w32(c, c->r[13] + 16u, c->r[8]); ngage_w32(c, c->r[13] + 20u, c->r[14]); /* push {r4, r5, r6, r7, r8, lr} */
247364: L_10081188:
247365:     c->r[13] = c->r[13] - 0x00000234u; /* sub sp, sp, #564 */
247366: L_1008118c:
247367:     c->r[7] = c->r[0]; /* mov r7, r0 */
247368: L_10081190:
247369:     ngage_w32(c, (c->r[7] + 72u), (uint32_t)c->r[1]); /* str r1, [r7, #0x48] */
247370: L_10081194:
247371:     c->r[6] = c->r[7] + 0x00000018u; /* add r6, r7, #24 */
247372: L_10081198:
247373:     c->r[0] = c->r[6]; /* mov r0, r6 */
247374: L_1008119c:
247375:     c->r[1] = 0x00000020u; /* mov r1, #32 */
247376: L_100811a0:
247377:     c->r[14] = 0x100811a4u; ngage_call(c, 0x1009fbf0u); goto L_100811a4; /* bl 0x9fbf0 <shadowkey_code+0x9fbf0> */
247378: L_100811a4:
247379:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
247380: L_100811a8:
247381:     if (!ngage_zf(c)) { goto L_100811d0; } /* bne 0x811d0 <shadowkey_code+0x811d0> */
247382: L_100811ac:
247383:     c->r[1] = 0x100b3c8cu; /* literal 0x100811d8 */ /* ldr r1, [pc, #0x24] */
247384: L_100811b0:
247385:     c->r[4] = c->r[13] + 0x00000008u; /* add r4, sp, #8 */
247386: L_100811b4:
247387:     c->r[0] = c->r[4]; /* mov r0, r4 */
247388: L_100811b8:
247389:     c->r[14] = 0x100811bcu; ngage_call(c, 0x1009f0f0u); goto L_100811bc; /* bl 0x9f0f0 <shadowkey_code+0x9f0f0> */
247390: L_100811bc:
247391:     c->r[0] = c->r[6]; /* mov r0, r6 */
247392: L_100811c0:
247393:     c->r[1] = c->r[4]; /* mov r1, r4 */
247394: L_100811c4:
247395:     c->r[14] = 0x100811c8u; ngage_call(c, 0x1009fc00u); goto L_100811c8; /* bl 0x9fc00 <shadowkey_code+0x9fc00> */
247396: L_100811c8:
247397:     ngage_sub_flags(c, c->r[0], 0x00000000u); /* cmp r0, #0 */
247398: L_100811cc:
247399:     if (ngage_zf(c)) { goto L_100811dc; } /* beq 0x811dc <shadowkey_code+0x811dc> */
SOURCE END

## Historical diagnostic log: diagnostics/step26/live_font_name_descriptor_trace.log

Matching lines: 15

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1283 r0=102fe588 r1=00000100 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d564 cpsr=80000000
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d57c cpsr=80000000
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d57c cpsr=80000000
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 467 (r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0)
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 467 (r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=632 r0=102fe790 r1=00000008 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d5a0 cpsr=80000000
LOG END

LOG BEGIN
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 29 (r0=10110690 r1=00000020 r2=1011d0dc r3=00000006)
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006 sp=102feac8 lr=100811bc cpsr=60000000
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006 sp=102feac8 lr=100811bc cpsr=60000000
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 102 (r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006)
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 102 (r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=56 r0=10110690 r1=102feacc r2=1011d0dc r3=00000006 sp=102feac8 lr=100811e8 cpsr=60000000
LOG END

LOG BEGIN
TRACE sub_100231b4 entry obj=101102c8 +2e4=10110718 +2e8=10110730 +2ec=10110770 lr=10029ef8
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0 sp=102fe6ac lr=10023230 cpsr=60000000
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0 sp=102fe6ac lr=10023230 cpsr=60000000
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0)
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0)
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0)
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
  EUSER1282 FORENSIC r0=102fed30 r1=102fe6d8 bytes=20
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0)
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
  EUSER1282 FORENSIC r0=102fed30 r1=102fe6d8 bytes=20
  TRACE EUSER1282 destination before @102fed30: 00 00 00 00 10 6c 27 10 70 fe 0f 10 00 00 00 00 64 fe 0f 10
LOG END

## Historical diagnostic log: diagnostics/step31/live_font_descriptor_trace.log

Matching lines: 16

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1283 r0=102fe588 r1=00000100 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d564 cpsr=80000000
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d57c cpsr=80000000
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d57c cpsr=80000000
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 467 (r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0)
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 467 (r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=632 r0=102fe790 r1=00000008 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d5a0 cpsr=80000000
LOG END

LOG BEGIN
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 29 (r0=10110690 r1=00000020 r2=1011d0dc r3=00000006)
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006 sp=102feac8 lr=100811bc cpsr=60000000
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006 sp=102feac8 lr=100811bc cpsr=60000000
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 102 (r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006)
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 102 (r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=56 r0=10110690 r1=102feacc r2=1011d0dc r3=00000006 sp=102feac8 lr=100811e8 cpsr=60000000
LOG END

LOG BEGIN
TRACE sub_100231b4 entry obj=101102c8 +2e4=10110718 +2e8=10110730 +2ec=10110770 lr=10029ef8
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0 sp=102fe6ac lr=10023230 cpsr=60000000
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0 sp=102fe6ac lr=10023230 cpsr=60000000
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
  EUSER1282 FORENSIC r0=102fed30 r1=102fe6d8 bytes=20
LOG END

LOG BEGIN
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
  EUSER1282 FORENSIC r0=102fed30 r1=102fe6d8 bytes=20
  TRACE EUSER1282 destination before @102fed30: 00 00 00 00 10 6c 27 10 70 fe 0f 10 00 00 00 00 64 fe 0f 10
LOG END

## Historical diagnostic log: diagnostics/step32/live_font_spec_trace.log

Matching lines: 16

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1283 r0=102fe588 r1=00000100 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d564 cpsr=80000000
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d57c cpsr=80000000
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0 sp=102fe530 lr=1000d57c cpsr=80000000
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102fe538: 00 00 00 00 00 00 00 00
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 467 (r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0)
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fe540: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100a6470: 25 00 78 00 00 00 00 00 42 6c 75 65 74 6f 6f 74 68 20 72 65 6a 65 63 74 20 25 64 20 28 25 64 29 00 00 00 00 6e 75 6d 43
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fe540 r1=100a6470 r2=00000208 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=467 r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d594 cpsr=80000000
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 467 (r0=102fe588 r1=102fe540 r2=101fd3f6 r3=102fe9b0)
IMPORT dll=EUSER[100039e5].DLL ord=632 r0=102fe790 r1=00000008 r2=101fd3f6 r3=102fe9b0 sp=102fe530 lr=1000d5a0 cpsr=80000000
LOG END

LOG BEGIN
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 29 (r0=10110690 r1=00000020 r2=1011d0dc r3=00000006)
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006 sp=102feac8 lr=100811bc cpsr=60000000
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
LOG END

LOG BEGIN
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006 sp=102feac8 lr=100811bc cpsr=60000000
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102feac8: 14 ed 2f 10 1c ed 2f 10
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 102 (r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006)
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fead0: bc d0 11 10 24 ed 2f 10 70 fe 0f 10 6c 88 06 10 00 00 00 00 00 00 00 00
  TRACE EUSER1407 source candidate @100b3c8c: 70 00 68 00 6f 00 6e 00 65 00 74 00 73 00 79 00 00 00 00 00 00 00 00 00 74 6b 6f 53 74 72 69 6e 67 20 63 6c 61 73 73 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=102fead0 r1=100b3c8c r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=102 r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006 sp=102feac8 lr=100811c8 cpsr=60000000
UNIMPLEMENTED Shadowkey import: ETEL[10003d46].DLL ordinal 102 (r0=10110690 r1=102fead0 r2=1011d0dc r3=00000006)
IMPORT dll=ETEL[10003d46].DLL ord=56 r0=10110690 r1=102feacc r2=1011d0dc r3=00000006 sp=102feac8 lr=100811e8 cpsr=60000000
LOG END

LOG BEGIN
WATCH RANGE armed 102fed2c..102fed44
  WATCH GDI108 receiver armed base=102fed2c size=24 lr=10023230
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
LOG END

LOG BEGIN
  WATCH GDI108 receiver armed base=102fed2c size=24 lr=10023230
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
LOG END

LOG BEGIN
  EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718 r2=00000000 r3=000000a0
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
LOG END

LOG BEGIN
  TRACE EUSER1407 destination pre8 @102fe6d0: 74 00 65 00 6d 00 5c 00
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
LOG END

LOG BEGIN
  TRACE EUSER1407 destination before @102fe6d8: 61 00 70 00 70 00 73 00 5c 00 36 00 52 00 35 00 31 00 5c 00 08 00 00 00
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
  EUSER1282 FORENSIC r0=102fed30 r1=102fe6d8 bytes=20
LOG END

LOG BEGIN
  TRACE EUSER1407 source candidate @100ac718: 53 00 77 00 69 00 73 00 73 00 00 00 25 64 00 00 49 6e 69 74 45 6e 67 69 6e 65 20 53 74 61 72 74 00 00 00 00 63 3a 5c 73
  EXPERIMENT EUSER1407 TBuf16<6> candidate: length=5 text=Swiss; exact export identity NOT asserted
  TRACE EUSER1407 experimental descriptor @102fe6d8: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
IMPORT dll=EUSER[100039e5].DLL ord=1282 r0=102fed30 r1=102fe6d8 r2=00000014 r3=000000a0 sp=102fe6ac lr=10023244 cpsr=60000000
  EUSER1282 FORENSIC r0=102fed30 r1=102fe6d8 bytes=20
  TRACE EUSER1282 destination before @102fed30: 00 00 00 00 10 6c 27 10 70 fe 0f 10 00 00 00 00 64 fe 0f 10
LOG END

## Format-string literal provenance

- 6R51.APP code offset: 0x7c
- VA-to-file mapping: code_offset + (VA - 0x10000000)

- VA 0x100a6470, file offset 0xa64ec: '%x'
- VA 0x100abf28, file offset 0xabfa4: 'Graphics'
- VA 0x100ac718, file offset 0xac794: 'Swiss'
- VA 0x100b1068, file offset 0xb10e4: 'Helper'
- VA 0x100b3c8c, file offset 0xb3d08: 'phonetsy'

## Interpretation boundary

Five font-name callsites use the Swiss literal at 0x100ac718 and copy 20 bytes from their temporary object immediately after the call. The other five references use separate format literals and are not safe to handle with a Swiss-specific shortcut.
The generic API shape is consistent with TDes16::Format(TRefByValue<const TDesC16>, ...), but the exact EUSER ordinal-to-export-name mapping and all variadic argument semantics still require target FP1 export/callsite verification.

