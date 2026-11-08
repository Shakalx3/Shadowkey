#ifndef SHADOWKEY_SYMBIAN61_HLE_H
#define SHADOWKEY_SYMBIAN61_HLE_H
#include <stdint.h>
#include "shadowkey_cone_gc_hle.h"

extern uint32_t ngage_r32(ngage_cpu_t *,uint32_t);

static inline void shadowkey_symbian61_w32(ngage_cpu_t*c,uint32_t a,uint32_t v){
    if(!c||!c->mem||a<0x10000000u||(uint64_t)a+4u>0x12000000ull)return;
    uint8_t*p=c->mem+(a-0x10000000u);
    p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);
}

/* ARM UREL EUSER 1407: TPtrC16::TPtrC16(const TUint16*).
   r0=this, r1=zero-terminated UTF-16 source. TPtrC16 is an 8-byte
   non-owning descriptor: type 1/length in word 0, source pointer in word 1. */
static inline int shadowkey_hle_euser1407_tptrc16(ngage_cpu_t*c){
    if(!c||!c->mem)return 0;
    uint32_t self=c->r[0],src=c->r[1];
    if(self<0x10000000u||(uint64_t)self+8u>0x12000000ull||
       src<0x10000000u||src>=0x12000000u)return 0;
    uint32_t len=0;
    for(;len<0x10000u;len++){
        uint64_t at=(uint64_t)src+(uint64_t)len*2u;
        if(at+2u>0x12000000ull)return 0;
        const uint8_t*p=c->mem+((uint32_t)at-0x10000000u);
        if(!p[0]&&!p[1])break;
    }
    if(len==0x10000u)return 0;
    shadowkey_symbian61_w32(c,self,0x10000000u|len);
    shadowkey_symbian61_w32(c,self+4u,src);
    return 1;
}

/* ARM UREL EUSER 1575: TInt64::operator!=(const TInt64&) const.
   r0 and r1 point to the two 64-bit operands; TInt result is returned in r0. */
static inline int shadowkey_hle_euser1575_int64_ne(ngage_cpu_t*c){
    if(!c||!c->mem)return 0;
    uint32_t a=c->r[0],b=c->r[1];
    if(a<0x10000000u||(uint64_t)a+8u>0x12000000ull||
       b<0x10000000u||(uint64_t)b+8u>0x12000000ull)return 0;
    uint32_t alo=ngage_r32(c,a),ahi=ngage_r32(c,a+4u);
    uint32_t blo=ngage_r32(c,b),bhi=ngage_r32(c,b+4u);
    c->r[0]=(alo!=blo||ahi!=bhi)?1u:0u;
    return 1;
}

/* ARM UREL EUSER 1373: TRect::TRect(TInt,TInt,TInt,TInt).
   r0=this; r1/r2/r3 are left/top/right; bottom is the first stack word. */
static inline int shadowkey_hle_euser1373_trect_ctor(ngage_cpu_t*c){
    if(!c||!c->mem)return 0;
    uint32_t self=c->r[0],sp=c->r[13];
    if(self<0x10000000u||(uint64_t)self+16u>0x12000000ull||
       sp<0x10000000u||(uint64_t)sp+4u>0x12000000ull)return 0;
    uint32_t bottom=ngage_r32(c,sp);
    shadowkey_symbian61_w32(c,self,(uint32_t)c->r[1]);
    shadowkey_symbian61_w32(c,self+4u,(uint32_t)c->r[2]);
    shadowkey_symbian61_w32(c,self+8u,(uint32_t)c->r[3]);
    shadowkey_symbian61_w32(c,self+12u,bottom);
    return 1;
}

/* ARM UREL EUSER 530: TRect::Height() const. */
static inline int shadowkey_hle_euser530_trect_height(ngage_cpu_t*c){
    if(!c||!c->mem)return 0;
    uint32_t self=c->r[0];
    if(self<0x10000000u||(uint64_t)self+16u>0x12000000ull)return 0;
    c->r[0]=ngage_r32(c,self+12u)-ngage_r32(c,self+4u);
    return 1;
}

/* ARM UREL EUSER 711: TRect::Move(TInt,TInt). */
static inline int shadowkey_hle_euser711_trect_move(ngage_cpu_t*c){
    if(!c||!c->mem)return 0;
    uint32_t self=c->r[0],dx=c->r[1],dy=c->r[2];
    if(self<0x10000000u||(uint64_t)self+16u>0x12000000ull)return 0;
    shadowkey_symbian61_w32(c,self,ngage_r32(c,self)+dx);
    shadowkey_symbian61_w32(c,self+4u,ngage_r32(c,self+4u)+dy);
    shadowkey_symbian61_w32(c,self+8u,ngage_r32(c,self+8u)+dx);
    shadowkey_symbian61_w32(c,self+12u,ngage_r32(c,self+12u)+dy);
    return 1;
}

/* ARM UREL CONE 160: CCoeControl::Rect() const -> TRect.
   Hidden result in r0, this in r1. CCoeControl has two base vptrs, then
   iCoeEnv(+8), iContext(+12), iPosition(+16), iSize(+24). */
static inline int shadowkey_hle_cone160_rect(ngage_cpu_t*c){
    if(!c||!c->mem)return 0;
    uint32_t result=c->r[0],self=c->r[1];
    if(result<0x10000000u||(uint64_t)result+16u>0x12000000ull||
       self<0x10000000u||(uint64_t)self+0x20u>0x12000000ull)return 0;
    uint32_t x=ngage_r32(c,self+0x10u),y=ngage_r32(c,self+0x14u);
    uint32_t w=ngage_r32(c,self+0x18u),h=ngage_r32(c,self+0x1cu);
    shadowkey_symbian61_w32(c,result,x);
    shadowkey_symbian61_w32(c,result+4u,y);
    shadowkey_symbian61_w32(c,result+8u,x+w);
    shadowkey_symbian61_w32(c,result+12u,y+h);
    c->r[0]=result;
    return 1;
}

/* ARM UREL GDI 101: TFontStyle::SetPosture(TFontPosture).
   TFontStyle is one 32-bit iFlags word; EItalic is bit 0. */
static inline int shadowkey_hle_gdi101_set_posture(ngage_cpu_t*c){
    if(!c||!c->mem||c->r[1]>1u)return 0;
    uint32_t self=c->r[0];
    if(self<0x10000000u||(uint64_t)self+4u>0x12000000ull)return 0;
    uint32_t flags=ngage_r32(c,self);
    flags=(c->r[1]==1u)?(flags|1u):(flags&~1u);
    shadowkey_symbian61_w32(c,self,flags);
    return 1;
}

/* ARM UREL GDI 108: TFontStyle::SetStrokeWeight(TFontStrokeWeight).
   EBold is bit 1; preserve posture and print-position bits. */
static inline int shadowkey_hle_gdi108_set_stroke_weight(ngage_cpu_t*c){
    if(!c||!c->mem||c->r[1]>1u)return 0;
    uint32_t self=c->r[0];
    if(self<0x10000000u||(uint64_t)self+4u>0x12000000ull)return 0;
    uint32_t flags=ngage_r32(c,self);
    flags=(c->r[1]==1u)?(flags|2u):(flags&~2u);
    shadowkey_symbian61_w32(c,self,flags);
    return 1;
}

#endif
