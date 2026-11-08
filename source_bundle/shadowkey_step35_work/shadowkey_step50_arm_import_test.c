#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_cone_gc_hle.h"

extern void shadowkey_hle_import(ngage_cpu_t *, const char *, uint16_t);
extern void shadowkey_heap_init(uint32_t,uint32_t);
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
int main(void){
    ngage_cpu_t c={0};c.mem=calloc(1,0x2000000u);if(!c.mem)return 2;
    shadowkey_heap_init(0x10120000u,0x10220000u);

    /* EUSER1407: TPtrC16 wraps the source pointer; it does not copy/format. */
    const uint32_t desc=0x10001000u,src=0x10002000u;
    const uint16_t name[]={ 'S','w','i','s','s',0 };
    for(unsigned i=0;i<6;i++)w16(&c,src+i*2u,name[i]);
    c.r[0]=desc;c.r[1]=src;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1407u);
    if(ngage_r32(&c,desc)!=0x10000005u||ngage_r32(&c,desc+4u)!=src)return 3;

    /* GDI151: TFontSpec is 64 bytes; TTypeface::iName is TBufC<24>. */
    const uint32_t font=0x10003000u;
    c.r[0]=font;c.r[1]=desc;c.r[2]=213u;
    shadowkey_hle_import(&c,"GDI[10003b15].DLL",151u);
    if(ngage_r32(&c,font)!=0x40000005u||ngage_r32(&c,font+52u)!=0u||
       ngage_r32(&c,font+56u)!=213u||ngage_r32(&c,font+60u)!=0u)return 4;
    const uint16_t expect[]={ 'S','w','i','s','s' };
    for(unsigned i=0;i<5;i++){
        uint8_t*p=c.mem+(font-0x10000000u)+4u+i*2u;
        if(p[0]!=(uint8_t)expect[i]||p[1]!=0)return 5;
    }

    /* GDI108/GDI101 operate on the single 32-bit TFontStyle flags word. */
    c.r[0]=font+60u;c.r[1]=1u;
    shadowkey_hle_import(&c,"GDI[10003b15].DLL",108u);
    if(ngage_r32(&c,font+60u)!=2u)return 6;
    c.r[0]=font+60u;c.r[1]=1u;
    shadowkey_hle_import(&c,"GDI[10003b15].DLL",101u);
    if(ngage_r32(&c,font+60u)!=3u)return 7;

    /* CONE160 returns a complete TRect using position + size. */
    const uint32_t control=0x10004000u,result=0x10005000u;
    ngage_w32(&c,control+0x10u,17u);ngage_w32(&c,control+0x14u,(uint32_t)-23);
    ngage_w32(&c,control+0x18u,80u);ngage_w32(&c,control+0x1cu,45u);
    c.r[0]=result;c.r[1]=control;
    shadowkey_hle_import(&c,"CONE[10003a41].DLL",160u);
    if(ngage_r32(&c,result)!=17u||ngage_r32(&c,result+4u)!=(uint32_t)-23||
       ngage_r32(&c,result+8u)!=97u||ngage_r32(&c,result+12u)!=22u)return 8;

    /* EUSER1575: TInt64 inequality returns TInt in r0. */
    const uint32_t lhs=0x10006000u,rhs=0x10006010u;
    ngage_w32(&c,lhs,0x89abcdefu);ngage_w32(&c,lhs+4u,0x01234567u);
    ngage_w32(&c,rhs,0x89abcdefu);ngage_w32(&c,rhs+4u,0x01234568u);
    c.r[0]=lhs;c.r[1]=rhs;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1575u);
    if(c.r[0]!=1u)return 9;

    /* EUSER1582: CBase::operator new receives size in r0 and returns guest ptr. */
    c.r[0]=0x22cu;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1582u);
    if(c.r[0]!=0x10120000u)return 10;
    c.r[0]=0x28u;
    shadowkey_hle_import(&c,"EUSER[100039e5].DLL",3u);
    if(c.r[0]!=0x10120230u)return 11;

    /* EIKCORE222: CEikApplication layout is 556 bytes; caption is TBuf<256>.
       The caller writes the derived vtable immediately after this constructor. */
    const uint32_t app=0x10008000u;
    memset(c.mem+(app-0x10000000u),0xa5,556u);
    c.r[0]=app;
    shadowkey_hle_import(&c,"EIKCORE[10004892].DLL",222u);
    if(ngage_r32(&c,app)!=0xa5a5a5a5u||
       ngage_r32(&c,app+4u)!=0u||ngage_r32(&c,app+8u)!=0u||
       ngage_r32(&c,app+12u)!=0u||ngage_r32(&c,app+16u)!=0u||
       ngage_r32(&c,app+20u)!=0u||ngage_r32(&c,app+24u)!=0x30000000u||
       ngage_r32(&c,app+28u)!=256u||ngage_r32(&c,app+544u)!=0u||
       ngage_r32(&c,app+548u)!=0u||ngage_r32(&c,app+552u)!=0u)return 12;
    if(c.mem[(app-0x10000000u)+32u]!=0xa5)return 13;

    /* EIKCORE219: CEikDocument stores its CEikApplication and Process refs. */
    const uint32_t doc=0x10009000u,process=0x1000b000u;
    ngage_w32(&c,app+20u,process);
    memset(c.mem+(doc-0x10000000u),0xa5,36u);
    c.r[0]=doc;c.r[1]=app;
    shadowkey_hle_import(&c,"EIKCORE[10004892].DLL",219u);
    if(ngage_r32(&c,doc)!=0xa5a5a5a5u||ngage_r32(&c,doc+4u)!=0u||
       ngage_r32(&c,doc+8u)!=app||ngage_r32(&c,doc+12u)!=process||
       ngage_r32(&c,doc+16u)!=0u||ngage_r32(&c,doc+20u)!=0u||
       ngage_r32(&c,doc+24u)!=0u||c.mem[(doc-0x10000000u)+28u]!=0u||
       ngage_r32(&c,doc+32u)!=0u)return 14;

    puts("PASS: ARM UREL TPtrC16, TFontSpec64, TFontStyle, CCoeControl::Rect, TInt64, CBase allocation, CEikApplication and CEikDocument constructors");
    free(c.mem);return 0;
}
