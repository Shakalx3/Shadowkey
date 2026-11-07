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
static void w16(ngage_cpu_t*c,uint32_t a,uint16_t v){uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);}
static uint16_t r16(ngage_cpu_t*c,uint32_t a){uint8_t*p=c->mem+(a-0x10000000u);return (uint16_t)(p[0]|((uint16_t)p[1]<<8));}
static void w32(ngage_cpu_t*c,uint32_t a,uint32_t v){uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);}
int main(void){
    ngage_cpu_t c={0}; c.mem=calloc(1,0x400000u); if(!c.mem)return 2;
    const uint32_t dst=0x10100000u, src=0x10101000u;
    w32(&c,dst,0x30000003u); w32(&c,dst+4u,16u);
    w16(&c,dst+8u,'o');w16(&c,dst+10u,'l');w16(&c,dst+12u,'d');
    const char *s="Shadowkey"; for(unsigned i=0;i<strlen(s);i++)w16(&c,src+i*2u,(uint8_t)s[i]); w16(&c,src+strlen(s)*2u,0);
    c.r[0]=dst;c.r[1]=src; shadowkey_hle_import(&c,"EUSER[100039e5].DLL",248u);
    if((ngage_r32(&c,dst)&0x0fffffffu)!=9u)return 3;
    for(unsigned i=0;i<9;i++)if(r16(&c,dst+8u+i*2u)!=(uint8_t)s[i])return 4;
    if(r16(&c,dst+26u)!=0)return 5;
    /* Empty source must clear descriptor length, without reading stale data. */
    w32(&c,dst,0x30000009u); w16(&c,src,0);
    c.r[0]=dst;c.r[1]=src; shadowkey_hle_import(&c,"EUSER[100039e5].DLL",248u);
    if((ngage_r32(&c,dst)&0x0fffffffu)!=0u)return 6;
    /* Guard the final data slot and verify no writes outside the descriptor. */
    w32(&c,dst,0x30000000u);w32(&c,dst+4u,2u);w16(&c,src,'A');w16(&c,src+2u,'B');w16(&c,src+4u,'C');
    c.r[0]=dst;c.r[1]=src;shadowkey_hle_import(&c,"EUSER[100039e5].DLL",248u);
    if(c.r[0]!=(uint32_t)-9 || (ngage_r32(&c,dst)&0x0fffffffu)!=0u)return 7;
    puts("PASS: EUSER 248 UTF-16 pointer copy, empty-string length reset, and overflow guard");
    free(c.mem);return 0;
}
