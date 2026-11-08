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
    const uint32_t rect=0x10100000u,sp=0x10101000u;
    w32(&c,sp,160u);
    c.r[0]=rect;c.r[1]=(uint32_t)-5;c.r[2]=7u;c.r[3]=100u;c.r[13]=sp;c.r[14]=0x10022c60u;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1373u);
    if(ngage_r32(&c,rect)!=(uint32_t)-5||ngage_r32(&c,rect+4u)!=7u||
       ngage_r32(&c,rect+8u)!=100u||ngage_r32(&c,rect+12u)!=160u){
        fprintf(stderr,"FAIL EUSER1373 TRect constructor fields\n");return 3;
    }
    c.r[0]=rect;c.r[14]=0x10022c68u;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",530u);
    if(c.r[0]!=153u){fprintf(stderr,"FAIL EUSER530 TRect::Height result=%u\n",c.r[0]);return 4;}
    c.r[0]=rect;c.r[1]=23u;c.r[2]=(uint32_t)-8;c.r[14]=0x1002350cu;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",711u);
    if(ngage_r32(&c,rect)!=18u||ngage_r32(&c,rect+4u)!=(uint32_t)-1||
       ngage_r32(&c,rect+8u)!=123u||ngage_r32(&c,rect+12u)!=152u){
        fprintf(stderr,"FAIL EUSER711 TRect::Move fields\n");return 5;
    }
    puts("PASS: ARM UREL EUSER1373 TRect ctor, EUSER530 Height, EUSER711 Move");
    free(c.mem);return 0;
}
