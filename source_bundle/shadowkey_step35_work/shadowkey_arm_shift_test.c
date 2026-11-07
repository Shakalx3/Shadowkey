#include <stdint.h>
#include <stdio.h>
typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;
#include "shadowkey_arm_shift.h"

static int check(const char *name,uint32_t got,uint32_t want){
    if(got!=want){fprintf(stderr,"FAIL %s got=%08x want=%08x\n",name,got,want);return 0;}return 1;
}
static void setc(ngage_cpu_t *c,uint32_t cbit){c->cpsr=(c->cpsr&~0x20000000u)|(cbit<<29);}
int main(void){
    ngage_cpu_t c={0}; int ok=1; uint32_t v;
    v=shadowkey_arm_shift_operand(&c,0x12345678u,0u,8u,1u,1u);ok&=check("LSL #8",v,0x34567800u);ok&=check("LSL carry",(c.cpsr>>29)&1u,0u);
    v=shadowkey_arm_shift_operand(&c,0x12345678u,1u,8u,1u,1u);ok&=check("LSR #8",v,0x00123456u);
    v=shadowkey_arm_shift_operand(&c,0x80000001u,2u,8u,1u,1u);ok&=check("ASR #8",v,0xff800000u);
    v=shadowkey_arm_shift_operand(&c,0x12345678u,3u,8u,1u,1u);ok&=check("ROR #8",v,0x78123456u);
    setc(&c,1u);v=shadowkey_arm_shift_operand(&c,3u,3u,0u,1u,1u);ok&=check("RRX",v,0x80000001u);ok&=check("RRX carry",(c.cpsr>>29)&1u,1u);
    v=shadowkey_arm_shift_operand(&c,0x80000001u,1u,0u,1u,1u);ok&=check("LSR #0 means #32",v,0u);ok&=check("LSR #32 carry",(c.cpsr>>29)&1u,1u);
    v=shadowkey_arm_shift_operand(&c,0x80000001u,2u,0u,1u,1u);ok&=check("ASR #0 means #32",v,0xffffffffu);ok&=check("ASR #32 carry",(c.cpsr>>29)&1u,1u);
    v=shadowkey_arm_shift_operand(&c,0x80000001u,0u,32u,0u,1u);ok&=check("LSL register #32",v,0u);ok&=check("LSL register #32 carry",(c.cpsr>>29)&1u,1u);
    setc(&c,0u);v=shadowkey_arm_shift_operand(&c,0x87654321u,1u,0u,0u,1u);ok&=check("LSR register #0",v,0x87654321u);ok&=check("register #0 preserves C",(c.cpsr>>29)&1u,0u);
    v=shadowkey_arm_shift_operand(&c,0x87654321u,3u,32u,0u,1u);ok&=check("ROR register #32",v,0x87654321u);ok&=check("ROR register #32 carry",(c.cpsr>>29)&1u,1u);
    if(!ok)return 1;
    puts("PASS: ARM Operand2 LSL/LSR/ASR/ROR/RRX immediate and register semantics, including shifter carry");return 0;
}
