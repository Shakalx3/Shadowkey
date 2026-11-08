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
    /* EUSER 711 is retained as a TPoint constructor based on the callsite
       register shape and the WINS symbol. Keep the write bounded to 8 bytes. */
    c.r[0]=p;c.r[1]=0;c.r[2]=13;c.r[3]=(uint32_t)-8;c.r[13]=0x10101000u;c.r[14]=0x1002350cu;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",711u);
    if(ngage_r32(&c,p)!=0u || ngage_r32(&c,p+4u)!=13u ||
       ngage_r32(&c,p+8u)!=0x12345678u || ngage_r32(&c,p+12u)!=0x87654321u){
        fprintf(stderr,"FAIL EUSER711 TPoint constructor write/preserve tail\n");return 3;
    }
    puts("PASS: EUSER711 TPoint constructor writes x/y only; EUSER1373 and EUSER530 remain unresolved pending ARM UREL identity");
    free(c.mem);return 0;
}
