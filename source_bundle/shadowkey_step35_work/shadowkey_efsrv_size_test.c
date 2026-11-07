#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_cone_gc_hle.h"

extern void shadowkey_hle_import(ngage_cpu_t *,const char *,uint16_t);
uint32_t ngage_r32(ngage_cpu_t*c,uint32_t a){
    if(a<0x10000000u||(uint64_t)a+4u>0x10400000ull)return 0;
    uint8_t*p=c->mem+(a-0x10000000u);
    return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
}
static void w32(ngage_cpu_t*c,uint32_t a,uint32_t v){
    uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);
}
static void put16(ngage_cpu_t*c,uint32_t a,uint16_t v){
    uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);
}
static void put_tbuf16(ngage_cpu_t*c,uint32_t a,const char*s,uint32_t max){
    uint32_t n=(uint32_t)strlen(s);w32(c,a,0x30000000u|n);w32(c,a+4u,max);
    for(uint32_t i=0;i<n;i++)put16(c,a+8u+i*2u,(uint8_t)s[i]);put16(c,a+8u+n*2u,0);
}
int main(int argc,char**argv){
    if(argc!=2){fprintf(stderr,"usage: %s asset-root\n",argv[0]);return 2;}
    setenv("SHADOWKEY_ASSET_ROOT",argv[1],1);
    ngage_cpu_t c={0};c.mem=calloc(0x400000u,1);if(!c.mem)return 2;
    const uint32_t parse=0x1017f534u,input=0x1017f530u,out=0x10100000u,sp=0x10101000u;
    const char*path="e:\\system\\apps\\6R51\\menu_sprites.txt";
    put_tbuf16(&c,input,path,256u);
    c.r[0]=parse;shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",230u);
    c.r[0]=parse;c.r[1]=input;c.r[2]=0;c.r[3]=0;
    shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",185u);
    if((int32_t)c.r[0]!=0){fprintf(stderr,"TParse::Set failed %d\n",(int32_t)c.r[0]);return 1;}
    if(ngage_r32(&c,parse+24u)!= (0x30000000u|(uint32_t)strlen(path)) ||
       ngage_r32(&c,parse+28u)!=256u){fprintf(stderr,"TParse FullName descriptor invalid\n");return 1;}
    c.r[0]=parse;shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",121u);
    if(c.r[0]!=1u){fprintf(stderr,"NamePresent false\n");return 1;}
    c.r[0]=parse;shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",146u);
    if(c.r[0]!=1u){fprintf(stderr,"PathPresent false\n");return 1;}

    w32(&c,out,0x30000000u);w32(&c,out+4u,512u);
    w32(&c,sp,252u);
    c.r[0]=0x10102000u;c.r[1]=parse+24u;c.r[2]=0;c.r[3]=out;c.r[13]=sp;
    shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",162u);
    uint32_t got=ngage_r32(&c,out)&0x0fffffffu;
    if((int32_t)c.r[0]!=0||got!=252u){fprintf(stderr,"ReadFileSection mismatch rc=%d length=%u\n",(int32_t)c.r[0],got);return 1;}
    const char expected[]="";(void)expected;
    char first[33]={0};memcpy(first,c.mem+(out-0x10000000u)+8u,32u);
    printf("PASS: SDK EFSRV230/185 TParse, EFSRV121/146 fields, EFSRV162 ReadFileSection; bytes=%u prefix='%s'\n",got,first);
    free(c.mem);return 0;
}
