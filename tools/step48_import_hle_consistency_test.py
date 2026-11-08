#!/usr/bin/env python3
"""Fail-closed audit of game imports against WINS evidence and ARM callsites."""
from pathlib import Path
import re

ROOT = Path("source_bundle/shadowkey_step35_work")
dispatch = (ROOT / "shadowkey_import_dispatch.c").read_text(errors="replace")
hle = (ROOT / "shadowkey_symbian61_hle.h").read_text(errors="replace")
bootstrap = (ROOT / "shadowkey_hle_bootstrap_v2.c").read_text(errors="replace")
vfs_trace = (ROOT / "shadowkey_hle_vfs_trace.c").read_text(errors="replace")
sdk = Path("docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md").read_text(errors="replace")
arm_map = Path("docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md").read_text(errors="replace")
callsite = Path("docs/STEP39_EUSER1407_STATIC_CALLSITE_AUDIT.md").read_text(errors="replace")
runtime = Path("docs/STEP42_EUSER1575_CONE160_RUNTIME_FORENSICS.md").read_text(errors="replace")

def import_row(dll_uid, ordinal):
    pattern = re.compile(
        r'\{\s*(0x[0-9a-fA-F]+)u?,\s*(0x[0-9a-fA-F]+)u?,\s*"'
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

def wins_symbol(dll, ordinal):
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

# These are explicitly WINS UDEB identities, not ARM game identities.
wins_expected = {
    ("EUSER", 1407): "?SetOffset@TDblQueBase@@QAEXH@Z",
    ("EUSER", 1575): "?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z",
    ("CONE", 160): "?Position@CCoeControl@@QBE?AVTPoint@@XZ",
    ("GDI", 101): "?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z",
    ("GDI", 108): "?NewL@CPalette@@SAPAV1@H@Z",
    ("GDI", 151): "?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z",
}
for key, expected_symbol in wins_expected.items():
    actual = wins_symbol(*key)
    assert actual == expected_symbol, (key, actual, expected_symbol)

def arm_symbol(dll, ordinal):
    section = re.search(
        r"^## " + re.escape(dll.upper()) + r"\.LIB\s*$([\s\S]*?)(?=^## |\Z)",
        arm_map, re.M
    )
    assert section, dll
    row = next((x for x in section.group(1).splitlines()
                if x.startswith(f"| {ordinal} |")), None)
    assert row, (dll, ordinal)
    fields = [x.strip() for x in row.strip("|").split("|")]
    assert len(fields) >= 3, row
    return fields[1]

arm_expected = {
    ("EUSER", 1407): "__7TPtrC16PCUs",
    ("EUSER", 1575): "__ne__C6TInt64RC6TInt64",
    ("EUSER", 1582): "__nw__5CBaseUi",
    ("EUSER", 1373): "__5TRectiiii",
    ("EUSER", 530): "Height__C5TRect",
    ("EUSER", 711): "Move__5TRectii",
    ("CONE", 160): "Rect__C11CCoeControl",
    ("GDI", 101): "SetPosture__10TFontStyle12TFontPosture",
    ("GDI", 108): "SetStrokeWeight__10TFontStyle17TFontStrokeWeight",
    ("GDI", 151): "__9TFontSpecRC7TDesC16i",
}
for key, expected_symbol in arm_expected.items():
    actual = arm_symbol(*key)
    assert actual == expected_symbol, (key, actual, expected_symbol)

# The ARM game has callsites where r1 is loaded with a format-string literal
# before the same EUSER 1407 thunk. This contradicts blindly applying the
# WINS-only SetOffset identity to the game's ARM import.
assert re.search(
    r"L_10022b70:.*?c->r\[1\] = 0x100ac718u.*?"
    r"L_10022b78:.*?c->r\[0\] = c->r\[4\].*?"
    r"L_10022b7c:.*?ngage_call\(c, 0x1009f0f0u\)",
    callsite, re.S
), "Expected Swiss-format literal callsite for EUSER 1407 not found"
assert "HLE EUSER1407 Format literal-only" in runtime
assert "Swiss literal-only subset" in runtime

# The WINS SetOffset helper is retained only as reference. It must not mutate
# live game objects until the ARM UREL ds01407.o member has been resolved.
assert "TDblQueBase::SetOffset(TInt)" in hle
assert "shadowkey_symbian61_w32(c,self+8u,c->r[1])" in hle
assert "ordinal==1407u && shadowkey_hle_euser1407_setoffset(c)" not in bootstrap
assert "ordinal==1407u)" not in vfs_trace

# Likewise, the CONE helper is not active dispatch; no claim of complete
# target implementation is made from the helper's existence alone.
assert "CCoeControl::Position() const" in hle
assert "shadowkey_hle_cone160_position(c)" not in bootstrap
assert "shadowkey_hle_cone160_position(c)" not in vfs_trace
assert "ordinal==160u)" not in vfs_trace

print("PASS: game thunk/IAT/ordinal associations for EUSER 1407/1575 and CONE 160")
print("PASS: six WINS UDEB names reproduced as WINS-only reference evidence")
print("PASS: ten ARM UREL archive-index identities verified against Step46")
print("PASS: ARM game callsite passes Swiss format literal through EUSER 1407 thunk")
print("PASS: historical diagnostic log records the separate format-specific experiment")
print("PASS: unverified EUSER 1407 SetOffset helper is not dispatched by either HLE path")
print("PASS: unverified CONE 160 helper is not dispatched by either HLE path")
print("LIMIT: ARM UREL ordinal/member identity is unresolved; do not assign WINS names to ARM imports")
