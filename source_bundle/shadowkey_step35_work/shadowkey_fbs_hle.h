#ifndef SHADOWKEY_FBS_HLE_H
#define SHADOWKEY_FBS_HLE_H
#include <stdint.h>

/* EKA1 FBS client-side model. The guest-visible chunk addresses are reserved
   immediately above the original 3 MiB image map. */
#define SHADOWKEY_FBS_SHARED_BASE 0x10300000u
#define SHADOWKEY_FBS_SHARED_SIZE 0x00010000u
#define SHADOWKEY_FBS_LARGE_BASE  0x10310000u
#define SHADOWKEY_FBS_GUEST_END   0x10400000u

void shadowkey_fbs_reset(void);
/* Returns 1 when the FBSCLI import was handled, otherwise 0. */
int shadowkey_fbs_import(uint32_t regs[16], uint8_t *guest_mem, uint16_t ordinal);
int shadowkey_fbs_bitmap_info(uint32_t object, uint32_t *pixels, uint32_t *width,
                              uint32_t *height, uint32_t *stride, uint32_t *mode);

#endif
