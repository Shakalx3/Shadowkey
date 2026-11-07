/* Portable guest-memory/ARM-flag runtime for the lifted Shadowkey and SIMKIN code.
   This is shared by the host test harness and the experimental ARM11 target. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;
static const uint32_t GUEST_BASE = 0x10000000u;
static const uint32_t GUEST_SIZE = 0x00400000u;
static ngage_cpu_t *active_cpu;
static uint32_t mem_fault_address;
static uint32_t watch_lo, watch_hi;
static uint32_t watch_enabled;
void ngage_runtime_watch_range(uint32_t lo,uint32_t size) { watch_lo=lo; watch_hi=lo+size; watch_enabled=(size!=0); }

void ngage_runtime_set_active_cpu(ngage_cpu_t *c) { active_cpu = c; }
uint32_t ngage_runtime_fault_address(void) { return mem_fault_address; }

static uint8_t *guest_ptr(ngage_cpu_t *c, uint32_t a, uint32_t n) {
    if (!c || !c->mem || a < GUEST_BASE || (uint64_t)a + n > (uint64_t)GUEST_BASE + GUEST_SIZE) {
        mem_fault_address = a;
        fprintf(stderr, "GUEST MEMORY FAULT addr=%08x size=%u\n", a, n);
        exit(90);
    }
    return c->mem + (a - GUEST_BASE);
}
uint32_t ngage_r32(ngage_cpu_t *c, uint32_t a) {
    uint8_t *p=guest_ptr(c,a,4); uint32_t v=(uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
    if(watch_enabled && a<watch_hi && (uint64_t)a+4u>watch_lo) fprintf(stderr,"WATCH FONT-SPEC READ32 addr=%08x value=%08x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);
    return v;
}
void ngage_w32(ngage_cpu_t *c, uint32_t a, uint32_t v) {
    uint8_t *p=guest_ptr(c,a,4);
    if(watch_enabled && a<watch_hi && (uint64_t)a+4u>watch_lo) fprintf(stderr,"WATCH FONT-SPEC WRITE32 addr=%08x value=%08x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);
    p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);
}
uint32_t ngage_r16(ngage_cpu_t *c, uint32_t a) { uint8_t*p=guest_ptr(c,a,2);uint32_t v=(uint32_t)p[0]|((uint32_t)p[1]<<8);if(watch_enabled&&a<watch_hi&&(uint64_t)a+2u>watch_lo)fprintf(stderr,"WATCH FONT-SPEC READ16 addr=%08x value=%04x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);return v; }
void ngage_w16(ngage_cpu_t *c, uint32_t a, uint16_t v) { uint8_t*p=guest_ptr(c,a,2);if(watch_enabled&&a<watch_hi&&(uint64_t)a+2u>watch_lo)fprintf(stderr,"WATCH FONT-SPEC WRITE16 addr=%08x value=%04x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8); }
uint32_t ngage_r8(ngage_cpu_t *c, uint32_t a) { return *guest_ptr(c,a,1); }
void ngage_w8(ngage_cpu_t *c, uint32_t a, uint8_t v) { *guest_ptr(c,a,1)=v; }
void ngage_set_nz(ngage_cpu_t*c,uint32_t v) { c->cpsr&=~0xC0000000u;if(!v)c->cpsr|=1u<<30;if(v&0x80000000u)c->cpsr|=1u<<31; }
uint32_t ngage_sub_flags(ngage_cpu_t*c,uint32_t a,uint32_t b) { uint32_t r=a-b;c->cpsr&=~0xF0000000u;if(!r)c->cpsr|=1u<<30;if(r&0x80000000u)c->cpsr|=1u<<31;if(a>=b)c->cpsr|=1u<<29;if(((a^b)&(a^r)&0x80000000u)!=0)c->cpsr|=1u<<28;return r; }
uint32_t ngage_add_flags(ngage_cpu_t*c,uint32_t a,uint32_t b,uint32_t cy) { uint64_t z=(uint64_t)a+b+cy;uint32_t r=(uint32_t)z;c->cpsr&=~0xF0000000u;if(!r)c->cpsr|=1u<<30;if(r&0x80000000u)c->cpsr|=1u<<31;if(z>>32)c->cpsr|=1u<<29;if(((~(a^b))&(a^r)&0x80000000u)!=0)c->cpsr|=1u<<28;return r; }
int ngage_zf(ngage_cpu_t*c) { return (int)((c->cpsr>>30)&1u); }
int ngage_cf(ngage_cpu_t*c) { return (int)((c->cpsr>>29)&1u); }
int ngage_nf(ngage_cpu_t*c) { return (int)((c->cpsr>>31)&1u); }
int ngage_vf(ngage_cpu_t*c) { return (int)((c->cpsr>>28)&1u); }
void ngage_unimplemented(ngage_cpu_t*c,uint32_t a,const char*m) { (void)c;fprintf(stderr,"UNIMPLEMENTED GUEST ADDRESS %08x: %s\n",a,m?m:"(no description)"); }
