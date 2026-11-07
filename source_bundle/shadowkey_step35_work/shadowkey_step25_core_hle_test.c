#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_cone_gc_hle.h"
extern void shadowkey_hle_import(ngage_cpu_t *,const char *,uint16_t);
uint32_t ngage_r32(ngage_cpu_t*c,uint32_t a){uint8_t*p=c->mem+(a-0x10000000u);return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
void ngage_w32(ngage_cpu_t*c,uint32_t a,uint32_t v){uint8_t*p=c->mem+(a-0x10000000u);p[0]=v;p[1]=v>>8;p[2]=v>>16;p[3]=v>>24;}
static void w16(ngage_cpu_t*c,uint32_t a,uint16_t v){uint8_t*p=c->mem+(a-0x10000000u);p[0]=v;p[1]=v>>8;}
static uint16_t r16(ngage_cpu_t*c,uint32_t a){uint8_t*p=c->mem+(a-0x10000000u);return (uint16_t)(p[0]|((uint16_t)p[1]<<8));}
static void u16s(ngage_cpu_t*c,uint32_t a,const char*s){for(size_t i=0;i<strlen(s);i++)w16(c,a+(uint32_t)i*2u,(uint8_t)s[i]);w16(c,a+(uint32_t)strlen(s)*2u,0);}
int main(void){
 ngage_cpu_t c={0};c.mem=calloc(1,0x400000u);if(!c.mem)return 2;
 const uint32_t d=0x10100000u,src=0x10101000u,sp=0x10102000u;
 /* EUSER 248: raw UTF-16 source to inline TBuf16. */
 ngage_w32(&c,d,0x30000000u);ngage_w32(&c,d+4u,32u);u16s(&c,src,"paused");c.r[0]=d;c.r[1]=src;shadowkey_hle_import(&c,"EUSER[100039e5].DLL",248u);
 if((ngage_r32(&c,d)&0xffffu)!=6u||r16(&c,d+8u)!='p'||r16(&c,d+18u)!='d')return 3;
 /* ESTLIB 317 replace then 315 append. */
 u16s(&c,src,"old");u16s(&c,src+0x100u,"has ");c.r[0]=src;c.r[1]=src+0x100u;shadowkey_hle_import(&c,"ESTLIB[10003b0b].DLL",317u);
 u16s(&c,src+0x200u,"paused");c.r[0]=src;c.r[1]=src+0x200u;shadowkey_hle_import(&c,"ESTLIB[10003b0b].DLL",315u);
 if(r16(&c,src+0u)!='h'||r16(&c,src+8u)!='p'||r16(&c,src+18u)!='d')return 4;
 /* EUSER 711: this + four TInt args; fourth on stack. */
 ngage_w32(&c,sp,0);c.r[0]=d+0x1000u;c.r[1]=0;c.r[2]=13;c.r[3]=(uint32_t)-15;c.r[13]=sp;shadowkey_hle_import(&c,"EUSER[100039e5].DLL",711u);
 if((int32_t)ngage_r32(&c,d+0x1000u)!=0||(int32_t)ngage_r32(&c,d+0x1004u)!=13||(int32_t)ngage_r32(&c,d+0x1008u)!=-15||(int32_t)ngage_r32(&c,d+0x100cu)!=0)return 5;
 puts("PASS: ARM-core HLE implements EUSER248, EUSER711 and ESTLIB315/317 observed text-path ABIs");free(c.mem);return 0;
}
