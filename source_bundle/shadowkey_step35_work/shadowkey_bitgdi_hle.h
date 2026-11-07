#ifndef SHADOWKEY_BITGDI_HLE_H
#define SHADOWKEY_BITGDI_HLE_H
#include <stdint.h>
#include "shadowkey_cone_gc_hle.h"

/* Call-site-inferred BitGdi/FBS graphics bridge. The exact FP1 ordinal/name
   pairs remain subject to SDK export-table verification. */
int shadowkey_bitgdi_import(ngage_cpu_t *c, const char *dll, uint16_t ordinal);
int shadowkey_bitgdi_virtual(ngage_cpu_t *c, uint32_t address);
void shadowkey_bitgdi_reset(void);

typedef struct {
    uint32_t gc, descriptor, rect;
    int32_t baseline;
    uint32_t alignment, margin;
    int32_t left, top, right, bottom;
    uint32_t geometry_kind; /* 1 = TPoint overload */
} shadowkey_drawtext_args_t;
int shadowkey_bitgdi_decode_drawtext(ngage_cpu_t *c, shadowkey_drawtext_args_t *out);

#endif
