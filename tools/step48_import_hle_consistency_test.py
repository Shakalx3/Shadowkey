#!/usr/bin/env python3
"""Static consistency checks for Step 47/48 import identity and HLE routing."""
from pathlib import Path
import re

ROOT = Path("source_bundle/shadowkey_step35_work")
dispatch = (ROOT / "shadowkey_import_dispatch.c").read_text(errors="replace")
hle = (ROOT / "shadowkey_symbian61_hle.h").read_text(errors="replace")
bootstrap = (ROOT / "shadowkey_hle_bootstrap_v2.c").read_text(errors="replace")
sdk = Path("docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md").read_text(errors="replace")

def import_row(dll_uid, ordinal):
    pattern = re.compile(
        r'\{\s*(0x[0-9a-fA-F]+)u,\s*(0x[0-9a-fA-F]+)u,\s*"'
        + re.escape(dll_uid)
        + r'\.DLL",\s*' + str(ordinal) + r'u\s*\}'
    )
    rows = pattern.findall(dispatch)
    assert len(rows) == 1, (dll_uid, ordinal, rows)
    return tuple(int(x, 16) for x in rows[0])

expected = {
    ("EUSER[100039e5]", 1407): (0x1009F0F0, 0x101007A4),
    ("EUSER[100039e5]", 1575): (0x1009F240, 0x101007E8),
    ("CONE[10003a41]", 160): (0x1009F510, 0x1010040C),
}
for key, value in expected.items():
    assert import_row(*key) == value, (key, import_row(*key))

def sdk_symbol(dll, ordinal):
    section = re.search(
        r"^### " + re.escape(dll.upper()) + r"\.LIB\s*$([\s\S]*?)(?=^### |\Z)",
        sdk, re.M
    )
    assert section, dll
    rows = re.findall(
        r"^- Ordinal " + str(ordinal) + r": (.*?); NameType=\[0\]",
        section.group(1), re.M
    )
    assert len(rows) == 1, (dll, ordinal, rows)
    return rows[0]

symbols = {
    ("EUSER", 1407): "?SetOffset@TDblQueBase@@QAEXH@Z",
    ("EUSER", 1575): "?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z",
    ("CONE", 160): "?Position@CCoeControl@@QBE?AVTPoint@@XZ",
    ("GDI", 101): "?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z",
    ("GDI", 108): "?NewL@CPalette@@SAPAV1@H@Z",
    ("GDI", 151): "?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z",
}
for key, expected_symbol in symbols.items():
    actual = sdk_symbol(*key)
    assert actual == expected_symbol, (key, actual, expected_symbol)

assert "ordinal==1407u && shadowkey_hle_euser1407_setoffset(c)" in bootstrap
assert "TDblQueBase::SetOffset(TInt)" in hle
assert "shadowkey_symbian61_w32(c,self+8u,c->r[1])" in hle
assert "CCoeControl::Position() const" in hle
assert "shadowkey_symbian61_w32(c,result+4u,y)" in hle

print("PASS: game thunk/IAT/ordinal associations for EUSER 1407/1575 and CONE 160")
print("PASS: six Step 44 WINS UDEB SDK symbol names")
print("PASS: EUSER 1407 dispatch reaches SetOffset HLE, not a descriptor/font handler")
print("PASS: CONE 160 HLE is explicitly a TPoint hidden-result implementation")
print("LIMIT: WINS UDEB identity does not prove ARM UREL or N95 OS 9.2 export equivalence")
