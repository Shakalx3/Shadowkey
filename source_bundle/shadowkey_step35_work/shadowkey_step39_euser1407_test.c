#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_cone_gc_hle.h"

extern void shadowkey_hle_import(ngage_cpu_t *,const char *,uint16_t);

uint32_t ngage_r32(ngage_cpu_t*c,uint32_t a){
    uint8_t*p=c->mem+(a-0x10000000u);
    return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
}
void ngage_w32(ngage_cpu_t*c,uint32_t a,uint32_t v){
    uint8_t*p=c->mem+(a-0x10000000u);
    p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);
}
static void w16(ngage_cpu_t*c,uint32_t a,uint16_t v){
    uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);
}
static uint16_t r16(ngage_cpu_t*c,uint32_t a){
    uint8_t*p=c->mem+(a-0x10000000u);return (uint16_t)(p[0]|((uint16_t)p[1]<<8));
}
static void put_utf16(ngage_cpu_t*c,uint32_t a,const char*s){
    size_t n=strlen(s);for(size_t i=0;i<n;i++)w16(c,a+(uint32_t)i*2u,(uint8_t)s[i]);w16(c,a+(uint32_t)n*2u,0);
}
static int verify_descriptor(ngage_cpu_t*c,uint32_t dst){
    if(ngage_r32(c,dst)!=0x30000005u||ngage_r32(c,dst+4u)!=6u)return 0;
    const char *s="Swiss";
    for(unsigned i=0;i<5;i++)if(r16(c,dst+8u+i*2u)!=(uint8_t)s[i])return 0;
    for(unsigned i=5;i<6;i++)if(r16(c,dst+8u+i*2u)!=0)return 0;
    return 1;
}
int main(void){
    ngage_cpu_t c={0};c.mem=calloc(1,0x400000u);if(!c.mem)return 2;
    const uint32_t src=0x100ac718u,dst=0x10100000u;
    const uint32_t sites[]={0x10022b80u,0x10022dacu,0x10022fe8u,0x10023230u,0x1002366cu};
    put_utf16(&c,src,"Swiss");
    for(unsigned i=0;i<sizeof(sites)/sizeof(sites[0]);i++){
        memset(c.mem+(dst-0x10000000u),0xa5,20u);
        c.r[0]=dst;c.r[1]=src;c.r[14]=sites[i];
        shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1407u);
        if(c.r[0]!=dst||!verify_descriptor(&c,dst)){
            fprintf(stderr,"FAIL: font callsite %08x did not produce TBuf16<6> Swiss\n",sites[i]);return 3;
        }
    }
    /* A non-font Format caller must not be rewritten by the Swiss-only path. */
    memset(c.mem+(dst-0x10000000u),0x5a,20u);
    c.r[0]=dst;c.r[1]=0x100b1068u;c.r[14]=0x1006093cu;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1407u);
    for(unsigned i=0;i<20;i++)if(c.mem[(dst-0x10000000u)+i]!=0x5a)return 4;

    /* A font-site call with a different source must also fail closed. */
    put_utf16(&c,src,"Swisx");
    memset(c.mem+(dst-0x10000000u),0x3c,20u);
    c.r[0]=dst;c.r[1]=src;c.r[14]=sites[0];
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1407u);
    for(unsigned i=0;i<20;i++)if(c.mem[(dst-0x10000000u)+i]!=0x3c)return 5;

    puts("PASS: EUSER1407 Swiss literal-only subset at all five font callsites; non-font/unknown inputs fail closed");
    free(c.mem);return 0;
}
