#include "shadowkey_legacy_cwindowgc_slots.h"

const shadowkey_cwindowgc_slot_remap
shadowkey_cwindowgc_slot_remaps[5] = {
    { 0x0048u, 0x0048u, "SetPenColor" },
    { 0x00B8u, 0x00C0u, "Clear" },
    { 0x00C0u, 0x00C8u, "CopyRect" },
    { 0x00D8u, 0x00E0u, "BitBltMasked(CWsBitmap)" },
    { 0x00DCu, 0x00E4u, "MapColors" }
};

int shadowkey_cwindowgc_target_offset(
    uint16_t legacy_byte_offset,
    uint16_t *target_byte_offset)
{
    unsigned int i;
    if (target_byte_offset == 0) {
        return 0;
    }
    for (i = 0; i < 5u; ++i) {
        if (shadowkey_cwindowgc_slot_remaps[i].legacy_byte_offset ==
            legacy_byte_offset) {
            *target_byte_offset =
                shadowkey_cwindowgc_slot_remaps[i].target_byte_offset;
            return 1;
        }
    }
    return 0;
}
