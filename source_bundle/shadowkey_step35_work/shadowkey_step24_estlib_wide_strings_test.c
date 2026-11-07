#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_cone_gc_hle.h"
extern void shadowkey_hle_import(ngage_cpu_t *, const char *, uint16_t);
uint32_t ngage_r32(ngage_cpu_t*c,uint32_t a){uint8_t*p=c->mem+(a-0x10000000u);return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
static void w16(ngage_cpu_t*c,uint32_t a,uint16_t v){uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);}
static uint16_t r16(ngage_cpu_t*c,uint32_t a){uint8_t*p=c->mem+(a-0x10000000u);return (uint16_t)(p[0]|((uint16_t)p[1]<<8));}
int main(void){ngage_cpu_t c={0};c.mem=calloc(1,0x400000u);if(!c.mem)return 2;uint32_t d=0x10100000u,s=0x10101000u;
 const char*a="base";for(unsigned i=0;i<4;i++)w16(&c,d+i*2u,(uint8_t)a[i]);w16(&c,d+8u,0);
 const char*b=" text";for(unsigned i=0;i<5;i++)w16(&c,s+i*2u,(uint8_t)b[i]);w16(&c,s+10u,0);
 c.r[0]=d;c.r[1]=s;shadowkey_hle_import(&c,"ESTLIB[10003b0b].DLL",317u);for(unsigned i=0;i<5;i++)if(r16(&c,d+i*2u)!=(uint8_t)b[i])return 3;if(r16(&c,d+10u)!=0)return 6;
 /* Replace with a deterministic base, then append a second UTF-16 string. */
 for(unsigned i=0;i<4;i++)w16(&c,d+i*2u,(uint8_t)a[i]);w16(&c,d+8u,0);
 c.r[0]=d;c.r[1]=s;shadowkey_hle_import(&c,"ESTLIB[10003b0b].DLL",315u);
 const char*want="base text";for(unsigned i=0;i<9;i++)if(r16(&c,d+i*2u)!=(uint8_t)want[i])return 4;if(r16(&c,d+18u)!=0)return 5;
 puts("PASS: ESTLIB 317 UTF-16 replace and ESTLIB 315 UTF-16 append");free(c.mem);return 0;}
