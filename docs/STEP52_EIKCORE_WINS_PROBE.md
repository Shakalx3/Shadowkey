# Step 52 — WINS UDEB EIKCORE probe

WINS UDEB is used only as a semantic reference. It is not ARM UREL
code and cannot supply ARM vtable addresses or prove exact ARM behavior.

- DLL: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/udeb/eikcore.dll
- Size: 110648 bytes
- SHA-256: 70b7fdd5c2aa4e4262ee18a589146d7471db0d219e8938fdcc5daa815553f665

## File identification

~~~text
/tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/udeb/eikcore.dll: PE32 executable for MS Windows 4.00 (DLL), Intel i386, 7 sections
~~~

## PE export table

- llvm-readobj exit code: 0
- Export entries parsed: 290
- Image base: 0x75300000

## WINS import-library constructor symbol search

- Library: /tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/udeb/eikcore.lib
- Archive members: 293

- No matching class/constructor symbol strings found in archive members.

## Interpretation boundary

WINS ordinal values and virtual addresses are not ARM UREL values.
Even if a WINS constructor is identified, use it only to corroborate
field initialization and high-level control flow. The current game trace
stops at ARM UREL EIKCORE ordinal 224 (CEikAppUi constructor); its
secondary-base vtable state still requires matching ARM evidence.
