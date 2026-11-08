#ifndef SHADOWKEY_SYMBIAN61_HLE_H
#define SHADOWKEY_SYMBIAN61_HLE_H
#include <stdint.h>
#include "shadowkey_cone_gc_hle.h"

extern uint32_t ngage_r32(ngage_cpu_t *,uint32_t);
static inline void shadowkey_symbian61_w32(ngage_cpu_t*c,uint32_t a,uint32_t v){
    if(!c||a<0x10000000u||(uint64_t)a+4u>0x12000000ull)return;
    uint8_t*p=c->mem+(a-0x10000000u);p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);
}

/* WINS UDEB reference only: EUSER ordinal 1407 is named
   TDblQueBase::SetOffset(TInt) in that import library. ARM game callsites
   conflict with this identity; keep this helper un-dispatched until ARM UREL
   member ds01407.o is inspected. Object layout is not target-verified. */
static inline int shadowkey_hle_euser1407_setoffset(ngage_cpu_t *c){
    uint32_t self=c->r[0];
    if(!c || self<0x10000000u || (uint64_t)self+12u>0x12000000ull) return 0;
    shadowkey_symbian61_w32(c,self+8u,c->r[1]);
    return 1;
}

/* WINS UDEB reference only: CONE ordinal 160 is named
   CCoeControl::Position() const there. The hidden-result call shape is
   observed in the game, but the target ARM ordinal and object offsets remain
   unverified. This helper is intentionally not dispatched. */
static inline int shadowkey_hle_cone160_position(ngage_cpu_t *c){
    uint32_t result=c->r[0],self=c->r[1];
    if(!c || result<0x10000000u || (uint64_t)result+8u>0x12000000ull ||
       self<0x10000000u || (uint64_t)self+0x14u>0x12000000ull) return 0;
    uint32_t x=ngage_r32(c,self+0x0cu);
    uint32_t y=ngage_r32(c,self+0x10u);
    shadowkey_symbian61_w32(c,result,x);
    shadowkey_symbian61_w32(c,result+4u,y);
    c->r[0]=result;
    return 1;
}
#endif
