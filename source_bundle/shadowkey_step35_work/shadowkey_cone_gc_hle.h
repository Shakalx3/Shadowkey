#ifndef SHADOWKEY_CONE_GC_HLE_H
#define SHADOWKEY_CONE_GC_HLE_H
#include <stdint.h>
typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;

/* Diagnostic-only synthetic CONE objects, deliberately outside both images. */
#define SHADOWKEY_GC_VTABLE       0x102FE000u
#define SHADOWKEY_GC_OBJECT       0x102FE100u
#define SHADOWKEY_DRAWABLE_WINDOW 0x102FE200u
#define SHADOWKEY_GC_ACTIVATE     0x102FD000u
#define SHADOWKEY_GC_SLOT48       0x102FD010u
#define SHADOWKEY_GC_SLOTB8       0x102FD020u
#define SHADOWKEY_GC_SLOT_C0      0x102FD040u
#define SHADOWKEY_GC_DEACTIVATE   0x102FD030u

void shadowkey_cone_gc_init(ngage_cpu_t *c);
uint32_t shadowkey_cone_system_gc(ngage_cpu_t *c);
uint32_t shadowkey_cone_drawable_window(ngage_cpu_t *c);
int shadowkey_cone_gc_dispatch(ngage_cpu_t *c, uint32_t address);
#endif
