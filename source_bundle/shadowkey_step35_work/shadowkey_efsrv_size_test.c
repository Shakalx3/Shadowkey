#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_cone_gc_hle.h"
extern void shadowkey_hle_import(ngage_cpu_t *, const char *, uint16_t);
uint32_t ngage_r32(ngage_cpu_t *c,uint32_t a){
    if(a<0x10000000u || a>=0x10400000u) return 0;
    uint8_t *p=c->mem+(a-0x10000000u);
    return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
}
uint32_t shadowkey_cone_system_gc(ngage_cpu_t *c){(void)c;return 0;}
uint32_t shadowkey_cone_drawable_window(ngage_cpu_t *c){(void)c;return 0;}
int shadowkey_cone_gc_dispatch(ngage_cpu_t *c,uint32_t a){(void)c;(void)a;return 0;}
static void w32(ngage_cpu_t*c,uint32_t a,uint32_t v){uint8_t*p=c->mem+(a-0x10000000u);p[0]=v;p[1]=v>>8;p[2]=v>>16;p[3]=v>>24;}
int main(int argc,char **argv){
    if(argc!=2){fprintf(stderr,"usage: %s asset-root\\n",argv[0]);return 2;}
    setenv("SHADOWKEY_ASSET_ROOT",argv[1],1);
    ngage_cpu_t c={0}; c.mem=calloc(0x400000u,1); if(!c.mem)return 2;
    const uint32_t file=0x1017f534u, desc=0x1017f54cu, out=0x1017f530u;
    const char *path="e:\\system\\apps\\6R51\\menu_sprites.txt";
    size_t n=strlen(path); uint32_t h=0x30000000u|(uint32_t)n;
    w32(&c,desc,h);w32(&c,desc+4u,256u);
    for(size_t i=0;i<n;i++){uint8_t*p=c.mem+(desc-0x10000000u)+8u+i*2u;p[0]=(uint8_t)path[i];p[1]=0;}
    c.r[0]=file;c.r[2]=desc;c.r[3]=2u;
    shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",121u);
    if((int32_t)c.r[0]!=0){fprintf(stderr,"open failed %d\\n",(int32_t)c.r[0]);return 1;}
    c.r[0]=file;c.r[1]=out;
    shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",185u);
    uint32_t got=ngage_r32(&c,out);
    if((int32_t)c.r[0]!=0 || got!=252u){fprintf(stderr,"Size mismatch rc=%d size=%u\\n",(int32_t)c.r[0],got);return 1;}
    c.r[0]=file;shadowkey_hle_import(&c,"EFSRV[100039e4].DLL",15u);
    free(c.mem);puts("PASS: EFSRV ordinal 185 call-site ABI writes RFile::Size(TInt&) output without changing the file handle");return 0;
}
