/*
 * Diagnostic-only minimal CONE graphics-context shim.
 *
 * This is NOT a native Symbian CWindowGc implementation. It creates a stable
 * guest-side object with only the virtual entries observed in the recovered
 * Shadowkey call sites. Each entry is dispatched by ngage_call() to a host
 * diagnostic handler. The purpose is to test whether the original game code
 * can pass the first framework boundary and reveal the next dependency.
 */
#include "shadowkey_cone_gc_hle.h"
#include <stdio.h>

static void wr32(ngage_cpu_t *c, uint32_t a, uint32_t v) {
    if (!c || !c->mem || a < 0x10000000u || a > 0x102FFFFCu) return;
    uint8_t *p = c->mem + (a - 0x10000000u);
    p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16); p[3] = (uint8_t)(v >> 24);
}

void shadowkey_cone_gc_init(ngage_cpu_t *c) {
    /* Keep the table sparse: only slots evidenced by this game's call sites. */
    wr32(c, SHADOWKEY_GC_VTABLE + 0x48u, SHADOWKEY_GC_SLOT48);
    wr32(c, SHADOWKEY_GC_VTABLE + 0xB8u, SHADOWKEY_GC_SLOTB8);
    wr32(c, SHADOWKEY_GC_VTABLE + 0xC0u, SHADOWKEY_GC_SLOT_C0);
    wr32(c, SHADOWKEY_GC_VTABLE + 0xD8u, SHADOWKEY_GC_ACTIVATE);
    wr32(c, SHADOWKEY_GC_VTABLE + 0xDCu, SHADOWKEY_GC_DEACTIVATE);
    wr32(c, SHADOWKEY_GC_OBJECT, SHADOWKEY_GC_VTABLE);
    /* A minimal drawable-window identity. Activate only passes this pointer. */
    wr32(c, SHADOWKEY_DRAWABLE_WINDOW, 0u);
}

uint32_t shadowkey_cone_system_gc(ngage_cpu_t *c) {
    shadowkey_cone_gc_init(c);
    fprintf(stderr, "CONE HLE SystemGc -> synthetic CWindowGc=%08x (diagnostic backend)\n",
            SHADOWKEY_GC_OBJECT);
    return SHADOWKEY_GC_OBJECT;
}
uint32_t shadowkey_cone_drawable_window(ngage_cpu_t *c) {
    shadowkey_cone_gc_init(c);
    fprintf(stderr, "CONE HLE DrawableWindow -> synthetic window=%08x (diagnostic backend)\n",
            SHADOWKEY_DRAWABLE_WINDOW);
    return SHADOWKEY_DRAWABLE_WINDOW;
}

int shadowkey_cone_gc_dispatch(ngage_cpu_t *c, uint32_t address) {
    switch (address) {
    case SHADOWKEY_GC_ACTIVATE:
        fprintf(stderr, "CONE GC Activate(this=%08x, window=%08x)\n", c->r[0], c->r[1]);
        c->r[0] = 0;
        return 1;
    case SHADOWKEY_GC_SLOT48:
        fprintf(stderr, "CONE GC vslot+48(this=%08x, arg1=%08x, arg2=%08x)\n",
                c->r[0], c->r[1], c->r[2]);
        c->r[0] = 0;
        return 1;
    case SHADOWKEY_GC_SLOTB8:
        fprintf(stderr, "CONE GC vslot+B8(this=%08x, arg1=%08x, arg2=%08x)\n",
                c->r[0], c->r[1], c->r[2]);
        c->r[0] = 0;
        return 1;
    case SHADOWKEY_GC_SLOT_C0:
        fprintf(stderr, "CONE GC vslot+C0(this=%08x, r1=%08x, r2=%08x, r3=%08x)\n", c->r[0], c->r[1], c->r[2], c->r[3]);
        c->r[0] = 0;
        return 1;
    case SHADOWKEY_GC_DEACTIVATE:
        fprintf(stderr, "CONE GC Deactivate(this=%08x)\n", c->r[0]);
        c->r[0] = 0;
        return 1;
    default:
        return 0;
    }
}
