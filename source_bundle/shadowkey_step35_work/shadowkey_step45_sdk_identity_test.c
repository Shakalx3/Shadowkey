#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_symbian61_hle.h"

uint32_t ngage_r32(ngage_cpu_t*c,uint32_t a){
    uint8_t*p=c->mem+(a-0x10000000u);
    return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
}
void ngage_w32(ngage_cpu_t*c,uint32_t a,uint32_t v){
    uint8_t*p=c->mem+(a-0x10000000u);
    p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);
}
int main(void){
    ngage_cpu_t c={0};c.mem=calloc(1,0x400000u);if(!c.mem)return 2;
    const uint32_t q=0x10001000u;
    memset(c.mem+(q-0x10000000u),0xa5,24u);
    c.r[0]=q;c.r[1]=0x100ac718u;
    if(!shadowkey_hle_euser1407_setoffset(&c))return 3;
    if(ngage_r32(&c,q+8u)!=0x100ac718u)return 4;
    for(unsigned i=0;i<8;i++)if(c.mem[(q-0x10000000u)+i]!=0xa5)return 5;
    for(unsigned i=12;i<24;i++)if(c.mem[(q-0x10000000u)+i]!=0xa5)return 6;

    const uint32_t control=0x10002000u,result=0x10003000u;
    ngage_w32(&c,control+0x0cu,17u);
    ngage_w32(&c,control+0x10u,(uint32_t)-23);
    memset(c.mem+(result-0x10000000u),0,8u);
    c.r[0]=result;c.r[1]=control;
    if(!shadowkey_hle_cone160_position(&c))return 7;
    if(ngage_r32(&c,result)!=17u||ngage_r32(&c,result+4u)!=(uint32_t)-23)return 8;
    if(c.r[0]!=result)return 9;

    puts("PASS: isolated WINS-UDEB reference helpers only; not active ARM game dispatch");
    free(c.mem);return 0;
}
