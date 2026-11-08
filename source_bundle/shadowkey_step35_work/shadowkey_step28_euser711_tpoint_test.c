#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_cone_gc_hle.h"
extern void shadowkey_hle_import(ngage_cpu_t *, const char *, uint16_t);
uint32_t ngage_r32(ngage_cpu_t *c, uint32_t a) {
    uint8_t *p=c->mem+(a-0x10000000u);
    return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
}
static void w32(ngage_cpu_t*c,uint32_t a,uint32_t v){uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);}
int main(void){
    ngage_cpu_t c={0}; c.mem=calloc(1,0x400000u); if(!c.mem)return 2;
    const uint32_t rect=0x10100000u;
    w32(&c,rect,(uint32_t)-5);w32(&c,rect+4u,7u);
    w32(&c,rect+8u,100u);w32(&c,rect+12u,160u);
    c.r[0]=rect;c.r[1]=23u;c.r[2]=(uint32_t)-8;c.r[3]=0xdeadbeefu;c.r[13]=0x10101000u;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",711u);
    if((int32_t)ngage_r32(&c,rect)!=18 || (int32_t)ngage_r32(&c,rect+4u)!=-1 ||
       (int32_t)ngage_r32(&c,rect+8u)!=123 || (int32_t)ngage_r32(&c,rect+12u)!=152){
        fprintf(stderr,"FAIL: TRect::Move must translate all four coordinates\n");return 3;
    }
    puts("PASS: ARM UREL EUSER711 TRect::Move translates top-left and bottom-right");
    free(c.mem);return 0;
}
