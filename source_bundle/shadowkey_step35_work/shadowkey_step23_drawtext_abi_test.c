#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_bitgdi_hle.h"

uint32_t shadowkey_heap_alloc(ngage_cpu_t *c, uint32_t n) { (void)c; (void)n; return 0; }
int shadowkey_fbs_bitmap_info(uint32_t bitmap, uint32_t *pixels, uint32_t *w,
                              uint32_t *h, uint32_t *stride, uint32_t *mode) {
    (void)bitmap; (void)pixels; (void)w; (void)h; (void)stride; (void)mode; return 0;
}
static void put32(uint8_t *m, uint32_t a, uint32_t v) {
    uint8_t *p=m+(a-0x10000000u); p[0]=(uint8_t)v; p[1]=(uint8_t)(v>>8); p[2]=(uint8_t)(v>>16); p[3]=(uint8_t)(v>>24);
}
static uint32_t get16(uint8_t *m, uint32_t a) {
    uint8_t *p=m+(a-0x10000000u); return p[0]|((uint32_t)p[1]<<8);
}
int main(void) {
    const uint32_t base=0x10000000u, size=0x400000u;
    uint8_t *mem=calloc(1,size); if(!mem) return 2;
    ngage_cpu_t c={0}; c.mem=mem;
    c.r[0]=0x10100000u; c.r[1]=0x10100100u; c.r[2]=0x10100200u; c.r[3]=(uint32_t)-15; c.r[13]=0x10100300u;
    /* TBuf<256>: descriptor type 3, length 5, max length 256, UTF-16 data. */
    put32(mem, c.r[1], 0x30000005u); put32(mem,c.r[1]+4u,256u);
    uint8_t *d=mem+(c.r[1]+8u-base); const uint16_t txt[5]={'H','E','L','L','O'};
    for(unsigned i=0;i<5;i++){d[i*2]=(uint8_t)txt[i];d[i*2+1]=(uint8_t)(txt[i]>>8);}
    put32(mem,c.r[2],(uint32_t)-2); put32(mem,c.r[2]+4u,3u); put32(mem,c.r[2]+8u,0x12345678u); put32(mem,c.r[2]+12u,0x87654321u);
    put32(mem,c.r[13],2u); put32(mem,c.r[13]+4u,7u);
    uint32_t pixel=0x10311000u; mem[pixel-base]=0x5a; mem[pixel-base+1u]=0xa5;
    shadowkey_drawtext_args_t a;
    if(!shadowkey_bitgdi_decode_drawtext(&c,&a)) return 3;
    if(a.gc!=0x10100000u || a.descriptor!=0x10100100u || a.rect!=0x10100200u) return 4;
    if(a.baseline!=-15 || a.alignment!=2u || a.margin!=7u) return 5;
    if(a.left!=-2 || a.top!=3 || a.right!=0 || a.bottom!=0 || a.geometry_kind!=1u) return 6;
    if(shadowkey_bitgdi_virtual(&c,0x10227014u)!=1) return 7;
    if(get16(mem,pixel)!=0xa55au) return 8; /* DrawText diagnostic must not fake pixel writes. */
    if(get16(mem,c.r[2]+8u)!=0x5678u) return 9; /* point decode must not consume a fake TRect tail */
    puts("PASS: DrawText ABI register/stack decode; TPoint coordinates; no unintended pixel writes");
    free(mem); (void)base; return 0;
}
