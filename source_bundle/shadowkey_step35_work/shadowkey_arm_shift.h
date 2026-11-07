#ifndef SHADOWKEY_ARM_SHIFT_H
#define SHADOWKEY_ARM_SHIFT_H
#include <stdint.h>

/* ARM data-processing Operand2 shifter semantics (ARM state). `type` is
   0=LSL, 1=LSR, 2=ASR, 3=ROR; `immediate` selects immediate vs register
   shift rules. If setcarry is nonzero, update CPSR.C with shifter carry-out. */
static inline uint32_t shadowkey_arm_shift_operand(ngage_cpu_t *c,
        uint32_t value, uint32_t type, uint32_t amount,
        uint32_t immediate, uint32_t setcarry) {
    uint32_t oldc=(c->cpsr>>29)&1u, carry=oldc, result=value;
    if (!immediate) amount &= 0xffu;
    if (type==0u) { /* LSL */
        if (amount==0u) result=value;
        else if (amount<32u) { carry=(value>>(32u-amount))&1u; result=value<<amount; }
        else if (amount==32u) { carry=value&1u; result=0u; }
        else { carry=0u; result=0u; }
    } else if (type==1u) { /* LSR */
        if (immediate && amount==0u) amount=32u;
        if (!immediate && amount==0u) result=value;
        else if (amount<32u) { carry=(value>>(amount-1u))&1u; result=value>>amount; }
        else if (amount==32u) { carry=(value>>31)&1u; result=0u; }
        else { carry=0u; result=0u; }
    } else if (type==2u) { /* ASR */
        if (immediate && amount==0u) amount=32u;
        if (!immediate && amount==0u) result=value;
        else if (amount<32u) { carry=(value>>(amount-1u))&1u; result=(uint32_t)((int32_t)value>>amount); }
        else { carry=(value>>31)&1u; result=(value&0x80000000u)?0xffffffffu:0u; }
    } else { /* ROR; immediate #0 is RRX */
        if (immediate && amount==0u) { carry=value&1u; result=(oldc<<31)|(value>>1); }
        else if (!immediate && amount==0u) result=value;
        else {
            uint32_t rot=amount&31u;
            if (rot==0u) { carry=(value>>31)&1u; result=value; }
            else { carry=(value>>(rot-1u))&1u; result=(value>>rot)|(value<<(32u-rot)); }
        }
    }
    if (setcarry) c->cpsr=(c->cpsr&~0x20000000u)|(carry<<29);
    return result;
}
#endif
