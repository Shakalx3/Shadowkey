#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_fbs_hle.h"

static uint32_t rd32(uint8_t *mem,uint32_t a){uint8_t*p=mem+(a-0x10000000u);return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}

int main(void) {
    uint8_t *mem=calloc(0x400000u,1u);
    if(!mem) return 2;
    uint32_t r[16]={0};
    const uint32_t object=0x10110718u, size=0x102fed00u;
    /* TSize(176,233), then the game's EKA1 display mode value 10. */
    uint32_t off=size-0x10000000u;
    mem[off+0]=176;mem[off+1]=0;mem[off+2]=0;mem[off+3]=0;
    mem[off+4]=233;mem[off+5]=0;mem[off+6]=0;mem[off+7]=0;
    shadowkey_fbs_reset();
    r[0]=object;
    if(!shadowkey_fbs_import(r,mem,135u) || r[0]!=object) return 3;
    r[0]=object;r[1]=size;r[2]=10u;
    if(!shadowkey_fbs_import(r,mem,16u) || r[0]!=0u) return 4;
    r[0]=object;r[1]=0x10200000u;r[2]=1u;
    if(!shadowkey_fbs_import(r,mem,17u)) return 5;
    const uint32_t expected=SHADOWKEY_FBS_LARGE_BASE+0x1000u;
    if(r[0]!=expected) {fprintf(stderr,"DataAddress mismatch %08x != %08x\n",r[0],expected);return 6;}
    if(expected<SHADOWKEY_FBS_LARGE_BASE || expected>=SHADOWKEY_FBS_GUEST_END) return 7;
    uint32_t header=SHADOWKEY_FBS_SHARED_BASE+0x100u;
    if(mem[header-0x10000000u]!=0x53u || mem[header-0x10000000u+1]!=0x46u ||
       mem[header-0x10000000u+2]!=0x42u || mem[header-0x10000000u+3]!=0x53u) return 8;
    uint32_t bytes=176u*233u*2u;
    if(bytes<0x11e00u || bytes!=rd32(mem,header+24u)) return 9;
    uint8_t *pixels=mem+(expected-0x10000000u);
    for(uint32_t i=0;i<0x11e00u;i++) if(pixels[i]!=0) return 10;
    pixels[0]=0x34;pixels[1]=0x12;
    if(pixels[0]!=0x34 || pixels[1]!=0x12) return 11;
    free(mem);
    puts("PASS: HLE shared-chunk metadata + large-chunk pixels; DataAddress resolves Base()+offset; mode-10 buffer covers the 176x208 two-byte clear");
    return 0;
}
