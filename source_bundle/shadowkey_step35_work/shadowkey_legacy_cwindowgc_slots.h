#ifndef SHADOWKEY_LEGACY_CWINDOWGC_SLOTS_H
#define SHADOWKEY_LEGACY_CWINDOWGC_SLOTS_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Mapping contract for the five CWindowGc virtual calls observed in the
 * original N-Gage game. The stored Symbian ARM vptr points to a two-word
 * prefix, so byte_offset = 8 + 4 * declaration_slot.
 *
 * This is metadata for the future native adapter, not a graphics HLE.
 */
#define SHADOWKEY_CWINDOWGC_VTABLE_PREFIX_BYTES 8u

typedef struct shadowkey_cwindowgc_slot_remap {
    uint16_t legacy_byte_offset;
    uint16_t target_byte_offset;
    const char *method;
} shadowkey_cwindowgc_slot_remap;

extern const shadowkey_cwindowgc_slot_remap
    shadowkey_cwindowgc_slot_remaps[5];

int shadowkey_cwindowgc_target_offset(
    uint16_t legacy_byte_offset,
    uint16_t *target_byte_offset);

#ifdef __cplusplus
}
#endif

#endif
