# Superseded step-7 note

This intermediate report was superseded by `V8_4_STEP8_BITMAP_BUFFER_AND_HEAP_MAP.md` after the heap/stack overlap was found.

Do not rely on the earlier statement that `source+0x14A3C` remained zero in the current path. Step 8 proves that `sub_10015878` writes a real allocated buffer to that field once the test memory map is corrected and `RFile::Size` is implemented.

The current blocker is different: unresolved FBSCLI ordinal 17 leaves the bitmap output buffer null, and `sub_1006A488` stops at `OOB 00000000/2`.
