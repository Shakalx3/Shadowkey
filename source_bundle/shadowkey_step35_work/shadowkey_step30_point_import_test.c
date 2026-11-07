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
    const uint32_t p=0x10100000u;
    w32(&c,p,0xdeadbeefu);w32(&c,p+4u,0xfeedfaceu);w32(&c,p+8u,0x12345678u);w32(&c,p+12u,0x87654321u);
    c.r[0]=p;c.r[1]=0;c.r[2]=160;c.r[14]=0x10023314u;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1373u);
    if(ngage_r32(&c,p)!=0u || ngage_r32(&c,p+4u)!=160u || ngage_r32(&c,p+8u)!=0x12345678u || ngage_r32(&c,p+12u)!=0x87654321u){fprintf(stderr,"FAIL EUSER1373 point set\n");return 3;}
    c.r[0]=p;c.r[14]=0x1002331cu;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",530u);
    if(c.r[0]!=160u){fprintf(stderr,"FAIL EUSER530 TPoint::Y got=%u\n",c.r[0]);return 4;}
    c.r[0]=p;c.r[1]=0;c.r[2]=13;c.r[3]=(uint32_t)-8;c.r[13]=0x10101000u;c.r[14]=0x1002350cu;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",711u);
    if(ngage_r32(&c,p)!=0u || ngage_r32(&c,p+4u)!=13u || ngage_r32(&c,p+8u)!=0x12345678u || ngage_r32(&c,p+12u)!=0x87654321u){fprintf(stderr,"FAIL EUSER711 point set/preserve tail\n");return 5;}
    puts("PASS: EUSER1373 TPoint set, EUSER530 Y getter, EUSER711 TPoint constructor; callsite ABI and 8-byte writes verified");
    free(c.mem);return 0;
}
