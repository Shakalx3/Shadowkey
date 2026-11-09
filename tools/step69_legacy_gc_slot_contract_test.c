#include <assert.h>
#include <stdint.h>
#include "shadowkey_legacy_cwindowgc_slots.h"

int main(void)
{
    static const uint16_t legacy[] = {
        0x48u, 0xB8u, 0xC0u, 0xD8u, 0xDCu
    };
    static const uint16_t target[] = {
        0x48u, 0xC0u, 0xC8u, 0xE0u, 0xE4u
    };
    unsigned int i;
    uint16_t out = 0;

    assert(SHADOWKEY_CWINDOWGC_VTABLE_PREFIX_BYTES == 8u);
    for (i = 0; i < 5u; ++i) {
        assert(shadowkey_cwindowgc_slot_remaps[i].legacy_byte_offset == legacy[i]);
        assert(shadowkey_cwindowgc_slot_remaps[i].target_byte_offset == target[i]);
        assert(shadowkey_cwindowgc_target_offset(legacy[i], &out) == 1);
        assert(out == target[i]);
    }
    assert(shadowkey_cwindowgc_target_offset(0x48u, 0) == 0);
    assert(shadowkey_cwindowgc_target_offset(0x50u, &out) == 0);
    return 0;
}
