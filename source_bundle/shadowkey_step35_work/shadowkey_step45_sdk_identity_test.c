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
static void w16(ngage_cpu_t*c,uint32_t a,uint16_t v){
    uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);
}
int main(void){
    ngage_cpu_t c={0};c.mem=calloc(1,0x400000u);if(!c.mem)return 2;

    /* ARM UREL EUSER1407: TPtrC16(const TUint16*) is an 8-byte pointer descriptor. */
    const uint32_t desc=0x10001000u,src=0x10002000u;
    const char16_t_placeholder=0; (void)char16_t_placeholder;
    const uint16_t swiss[]={ 'S','w','i','s','s',0 };
    for(unsigned i=0;i<6;i++)w16(&c,src+i*2u,swiss[i]);
    memset(c.mem+(desc-0x10000000u),0xa5,16u);
    c.r[0]=desc;c.r[1]=src;
    if(!shadowkey_hle_euser1407_tptrc16(&c))return 3;
    if(ngage_r32(&c,desc)!=0x10000005u||ngage_r32(&c,desc+4u)!=src)return 4;
    for(unsigned i=8;i<16;i++)if(c.mem[(desc-0x10000000u)+i]!=0xa5)return 5;

    /* ARM UREL CONE160: CCoeControl::Rect returns a 16-byte TRect. */
    const uint32_t control=0x10003000u,result=0x10004000u;
    ngage_w32(&c,control+0x10u,17u);ngage_w32(&c,control+0x14u,(uint32_t)-23);
    ngage_w32(&c,control+0x18u,80u);ngage_w32(&c,control+0x1cu,45u);
    c.r[0]=result;c.r[1]=control;
    if(!shadowkey_hle_cone160_rect(&c))return 6;
    if(ngage_r32(&c,result)!=17u||ngage_r32(&c,result+4u)!=(uint32_t)-23||
       ngage_r32(&c,result+8u)!=97u||ngage_r32(&c,result+12u)!=22u)return 7;
    if(c.r[0]!=result)return 8;

    /* ARM UREL EUSER1575: 64-bit inequality, not a lexer conversion. */
    const uint32_t lhs=0x10005000u,rhs=0x10005010u;
    ngage_w32(&c,lhs,0x89abcdefu);ngage_w32(&c,lhs+4u,0x01234567u);
    ngage_w32(&c,rhs,0x89abcdefu);ngage_w32(&c,rhs+4u,0x01234567u);
    c.r[0]=lhs;c.r[1]=rhs;
    if(!shadowkey_hle_euser1575_int64_ne(&c)||c.r[0]!=0u)return 9;
    ngage_w32(&c,rhs+4u,0x01234568u);
    c.r[0]=lhs;c.r[1]=rhs;
    if(!shadowkey_hle_euser1575_int64_ne(&c)||c.r[0]!=1u)return 10;

    /* TRect constructor: bottom is the first stack argument. */
    const uint32_t rect=0x10006000u,sp=0x10007000u;
    ngage_w32(&c,sp,160u);c.r[0]=rect;c.r[1]=(uint32_t)-5;c.r[2]=7u;c.r[3]=100u;c.r[13]=sp;
    if(!shadowkey_hle_euser1373_trect_ctor(&c))return 11;
    if(ngage_r32(&c,rect)!=(uint32_t)-5||ngage_r32(&c,rect+4u)!=7u||
       ngage_r32(&c,rect+8u)!=100u||ngage_r32(&c,rect+12u)!=160u)return 12;
    c.r[0]=rect;
    if(!shadowkey_hle_euser530_trect_height(&c)||c.r[0]!=153u)return 13;
    c.r[0]=rect;c.r[1]=23u;c.r[2]=(uint32_t)-8;
    if(!shadowkey_hle_euser711_trect_move(&c))return 14;
    if(ngage_r32(&c,rect)!=18u||ngage_r32(&c,rect+4u)!=(uint32_t)-1||
       ngage_r32(&c,rect+8u)!=123u||ngage_r32(&c,rect+12u)!=152u)return 15;

    /* TFontStyle has one flags word: posture bit 0, bold bit 1. */
    const uint32_t style=0x10008000u;
    ngage_w32(&c,style,0xcu);c.r[0]=style;c.r[1]=1u;
    if(!shadowkey_hle_gdi101_set_posture(&c)||ngage_r32(&c,style)!=0xdu)return 16;
    c.r[0]=style;c.r[1]=1u;
    if(!shadowkey_hle_gdi108_set_stroke_weight(&c)||ngage_r32(&c,style)!=0xfu)return 17;
    c.r[0]=style;c.r[1]=0u;
    if(!shadowkey_hle_gdi108_set_stroke_weight(&c)||ngage_r32(&c,style)!=0xdu)return 18;

    puts("PASS: ARM UREL TPtrC16, TInt64, TRect, CCoeControl::Rect and TFontStyle helpers");
    free(c.mem);return 0;
}
