/*
 * Conservative ARMv4T/ARMv5 fallback interpreter for recovered Shadowkey code.
 * It is used only when the static function map has no entry for a guest PC.
 * Imported calls are still routed through the existing HLE dispatcher.
 */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;
extern uint32_t ngage_r32(ngage_cpu_t *, uint32_t);
extern uint32_t ngage_r16(ngage_cpu_t *, uint32_t);
extern uint32_t ngage_r8(ngage_cpu_t *, uint32_t);
extern void ngage_w32(ngage_cpu_t *, uint32_t, uint32_t);
extern void ngage_w16(ngage_cpu_t *, uint32_t, uint16_t);
extern void ngage_w8(ngage_cpu_t *, uint32_t, uint8_t);
extern void ngage_call(ngage_cpu_t *, uint32_t);
extern int shadowkey_find_import_thunk(uint32_t, const char **, uint16_t *, uint32_t *);
extern int shadowkey_find_import_slot(uint32_t, const char **, uint16_t *);
extern void shadowkey_hle_import(ngage_cpu_t *, const char *, uint16_t);
extern void simkin_call_export(ngage_cpu_t *, uint16_t);
extern void simkin_call(ngage_cpu_t *, uint32_t);
extern int simkin_find_import_thunk(uint32_t, const char **, uint16_t *);
extern int simkin_find_import_slot(uint32_t, const char **, uint16_t *);
extern void arm_fallback_call(ngage_cpu_t *, uint32_t);

#define N (1u<<31)
#define Z (1u<<30)
#define C (1u<<29)
#define V (1u<<28)
static unsigned fallback_depth;

static uint32_t ror32(uint32_t v, unsigned n) { n &= 31u; return n ? ((v >> n) | (v << (32u-n))) : v; }
static uint32_t signext(uint32_t v, unsigned bits) { uint32_t m=1u<<(bits-1); return (v^m)-m; }
static void set_nz(ngage_cpu_t *c, uint32_t v) { c->cpsr &= ~(N|Z); if (!v)c->cpsr|=Z; if(v&N)c->cpsr|=N; }
static uint32_t add_c(ngage_cpu_t*c,uint32_t a,uint32_t b,uint32_t carry,int setflags) {
    uint64_t wide=(uint64_t)a+(uint64_t)b+carry; uint32_t r=(uint32_t)wide;
    if(setflags){c->cpsr&=~(N|Z|C|V); if(!r)c->cpsr|=Z;if(r&N)c->cpsr|=N;if(wide>>32)c->cpsr|=C;if((~(a^b)&(a^r)&N)!=0)c->cpsr|=V;} return r;
}
static uint32_t sub_c(ngage_cpu_t*c,uint32_t a,uint32_t b,uint32_t carry,int setflags) {
    uint64_t rhs=(uint64_t)b+(carry?0u:1u); uint32_t r=a-(uint32_t)rhs;
    if(setflags){c->cpsr&=~(N|Z|C|V);if(!r)c->cpsr|=Z;if(r&N)c->cpsr|=N;if((uint64_t)a>=rhs)c->cpsr|=C;if(((a^b)&(a^r)&N)!=0)c->cpsr|=V;} return r;
}
static int cond_pass(ngage_cpu_t*c,unsigned cond){
    int n=!!(c->cpsr&N),z=!!(c->cpsr&Z),cy=!!(c->cpsr&C),v=!!(c->cpsr&V);
    switch(cond){case 0:return z;case 1:return !z;case 2:return cy;case 3:return !cy;case 4:return n;case 5:return !n;case 6:return v;case 7:return !v;case 8:return cy&&!z;case 9:return !cy||z;case 10:return n==v;case 11:return n!=v;case 12:return !z&&(n==v);case 13:return z||(n!=v);case 14:return 1;default:return 0;}
}
static uint32_t regval(ngage_cpu_t*c,unsigned r,uint32_t pc){return r==15?pc+8u:c->r[r];}
static uint32_t shift_imm(ngage_cpu_t*c,uint32_t val,unsigned type,unsigned amount,uint32_t *carry){
    uint32_t oldc=!!(c->cpsr&C); if(amount==0){if(type==0){*carry=oldc;return val;} if(type==1){amount=32;} else if(type==2){amount=32;} else { *carry=val&1u; return (oldc<<31)|(val>>1); }}
    switch(type){case 0: if(amount<32){*carry=(val>>(32-amount))&1u;return val<<amount;} if(amount==32){*carry=val&1u;return 0;} *carry=0;return 0;
      case 1: if(amount<32){*carry=(val>>(amount-1))&1u;return val>>amount;} if(amount==32){*carry=(val>>31)&1u;return 0;} *carry=0;return 0;
      case 2: if(amount<32){*carry=(val>>(amount-1))&1u;return (uint32_t)((int32_t)val>>amount);} *carry=(val>>31)&1u;return (val&N)?0xffffffffu:0;
      default: amount&=31u; if(!amount){*carry=(val>>31)&1u;return val;} *carry=(val>>(amount-1))&1u;return ror32(val,amount);}
}
static uint32_t operand2(ngage_cpu_t*c,uint32_t ins,uint32_t pc,uint32_t *carry){
    if(ins&(1u<<25)){unsigned rot=((ins>>8)&15u)*2u;uint32_t v=ins&255u;uint32_t out=ror32(v,rot);*carry=rot?((out>>31)&1u):!!(c->cpsr&C);return out;}
    unsigned rm=ins&15u,type=(ins>>5)&3u;uint32_t v=regval(c,rm,pc),amt;
    if(ins&(1u<<4)){amt=c->r[(ins>>8)&15u]&255u;if(amt==0){*carry=!!(c->cpsr&C);return v;} if(type==0){if(amt<32){*carry=(v>>(32-amt))&1u;return v<<amt;}*carry=amt==32?(v&1u):0;return 0;} if(type==1){if(amt<32){*carry=(v>>(amt-1))&1u;return v>>amt;}*carry=amt==32?(v>>31):0;return 0;} if(type==2){if(amt<32){*carry=(v>>(amt-1))&1u;return (uint32_t)((int32_t)v>>amt);}*carry=(v>>31)&1u;return (v&N)?0xffffffffu:0;} amt&=31u;if(!amt){*carry=(v>>31)&1u;return v;}*carry=(v>>(amt-1))&1u;return ror32(v,amt);}
    amt=(ins>>7)&31u;return shift_imm(c,v,type,amt,carry);
}
static int is_import(uint32_t a,const char **dll,uint16_t *ord){uint32_t slot=0;return shadowkey_find_import_thunk(a,dll,ord,&slot)||shadowkey_find_import_slot(a,dll,ord)||simkin_find_import_thunk(a,dll,ord)||simkin_find_import_slot(a,dll,ord);}
static void call_import(ngage_cpu_t*c,uint32_t a,const char*dll,uint16_t ord){
    const char *sd=0; uint16_t so=0;
    if(simkin_find_import_thunk(a,&sd,&so)||simkin_find_import_slot(a,&sd,&so)){simkin_call(c,a);return;}
    if(dll&&strncmp(dll,"SIMKIN[",7)==0)simkin_call_export(c,ord);else shadowkey_hle_import(c,dll,ord);
}
static void call_guest(ngage_cpu_t*c,uint32_t target){
    const char *d=0;uint16_t o=0;uint32_t slot=0;
    if(simkin_find_import_thunk(target,&d,&o)||simkin_find_import_slot(target,&d,&o)){simkin_call(c,target);return;}
    if(shadowkey_find_import_thunk(target,&d,&o,&slot)||shadowkey_find_import_slot(target,&d,&o)){ngage_call(c,target);return;}
    ngage_call(c,target);
}

static void run_arm(ngage_cpu_t*c,uint32_t start){
    uint32_t pc=start&~1u, return_addr=c->r[14], return_pc=return_addr&~1u; int thumb=(start&1u)!=0; uint64_t steps=0;
    if(++fallback_depth>32){fallback_depth--;fprintf(stderr,"ARM fallback recursion limit at %08x\n",start);return;}
    while(++steps<2000000u){
        if(pc==return_pc){c->r[15]=pc;c->r[14]=return_addr;fallback_depth--;return;}
        const char*dll=0;uint16_t ord=0;
        if(is_import(pc,&dll,&ord)){call_import(c,pc,dll,ord);pc=return_pc;fallback_depth--;return;}
        if(pc<0x10000000u || pc>=0x10300000u){fprintf(stderr,"ARM fallback left mapped code pc=%08x from=%08x; restore return=%08x\n",pc,start,return_addr);c->r[14]=return_addr;c->r[15]=return_pc;fallback_depth--;return;}
        if(thumb){
            uint16_t x=(uint16_t)ngage_r16(c,pc); uint32_t next=pc+2u; c->r[15]=pc+4u;
            /* Thumb conditional branch, unconditional branch, and SWI */
            if((x&0xf000u)==0xd000u){unsigned cond=(x>>8)&15u;if(cond==15){fprintf(stderr,"Thumb SWI %04x at %08x\n",x,pc);fallback_depth--;return;}if(cond_pass(c,cond))pc=pc+4u+(uint32_t)signext((x&255u)<<1,9);else pc=next;continue;}
            if((x&0xf800u)==0xe000u){pc=pc+4u+(uint32_t)signext((x&0x7ffu)<<1,12);continue;}
            if((x&0xf800u)==0xf000u){uint32_t hi=(uint32_t)signext(x&0x7ffu,11)<<12;c->r[14]=pc+4u+hi;pc=next;continue;}
            if((x&0xf800u)==0xf800u){uint32_t target=c->r[14]+((uint32_t)(x&0x7ffu)<<1);c->r[14]=(next|1u);pc=target&~1u;thumb=(target&1u)!=0;continue;}
            if((x&0xff87u)==0x4700u){unsigned rm=(x>>3)&15u;uint32_t target=c->r[rm];if((target&~1u)==return_pc){fallback_depth--;return;}pc=target&~1u;thumb=(target&1u)!=0;continue;}
            if((x&0xfe00u)==0xb400u || (x&0xfe00u)==0xbc00u){int pop=(x&0x0800u)!=0;uint32_t list=x&255u;int extra=(x>>8)&1u;unsigned count=0;for(unsigned i=0;i<8;i++)if(list&(1u<<i))count++;if(extra)count++;if(!pop){uint32_t sp=c->r[13]-4u*count,cur=sp;for(unsigned i=0;i<8;i++)if(list&(1u<<i)){ngage_w32(c,cur,c->r[i]);cur+=4;}if(extra){ngage_w32(c,cur,c->r[14]);}c->r[13]=sp;}else{uint32_t cur=c->r[13];for(unsigned i=0;i<8;i++)if(list&(1u<<i)){c->r[i]=ngage_r32(c,cur);cur+=4;}uint32_t target=0;if(extra){target=ngage_r32(c,cur);cur+=4;}c->r[13]=cur;if(extra){if((target&~1u)==return_pc){fallback_depth--;return;}pc=target&~1u;thumb=(target&1u)!=0;continue;}}pc=next;continue;}
            if((x&0xf800u)==0x2000u){unsigned rd=(x>>8)&7u;c->r[rd]=x&255u;set_nz(c,c->r[rd]);pc=next;continue;}
            if((x&0xf800u)==0x2800u){uint32_t a=c->r[(x>>8)&7u],b=x&255u;sub_c(c,a,b,1,1);pc=next;continue;}
            if((x&0xf800u)==0x3000u){unsigned rd=(x>>8)&7u;c->r[rd]=add_c(c,c->r[rd],x&255u,0,1);pc=next;continue;}
            if((x&0xf800u)==0x3800u){unsigned rd=(x>>8)&7u;c->r[rd]=sub_c(c,c->r[rd],x&255u,1,1);pc=next;continue;}
            if((x&0xf800u)==0x4800u){unsigned rd=(x>>8)&7u;uint32_t a=((pc+4u)&~3u)+((x&255u)<<2);c->r[rd]=ngage_r32(c,a);pc=next;continue;}
            if((x&0xf000u)==0x6000u || (x&0xf000u)==0x7000u || (x&0xf000u)==0x8000u){unsigned op=(x>>11)&3u,rb=(x>>3)&7u,rd=x&7u;uint32_t imm,addr=c->r[rb];if((x&0xf000u)==0x8000u){imm=((x>>6)&31u)*2u;addr+=imm;if(x&0x0800u)c->r[rd]=ngage_r16(c,addr);else ngage_w16(c,addr,(uint16_t)c->r[rd]);}else{int byte=(x&0x1000u)!=0;imm=((x>>6)&31u)*(byte?1u:4u);addr+=imm;if(x&0x0800u)c->r[rd]=byte?ngage_r8(c,addr):ngage_r32(c,addr);else if(byte)ngage_w8(c,addr,(uint8_t)c->r[rd]);else ngage_w32(c,addr,c->r[rd]);}pc=next;continue;}
            if((x&0xf000u)==0x5000u){unsigned op=(x>>9)&7u,ro=(x>>6)&7u,rb=(x>>3)&7u,rd=x&7u;uint32_t a=c->r[rb]+c->r[ro];switch(op){case 0:ngage_w32(c,a,c->r[rd]);break;case 1:ngage_w16(c,a,(uint16_t)c->r[rd]);break;case 2:ngage_w8(c,a,(uint8_t)c->r[rd]);break;case 3:c->r[rd]=(uint32_t)(int32_t)(int8_t)ngage_r8(c,a);break;case 4:c->r[rd]=ngage_r32(c,a);break;case 5:c->r[rd]=ngage_r16(c,a);break;case 6:c->r[rd]=ngage_r8(c,a);break;case 7:c->r[rd]=(uint32_t)(int32_t)(int16_t)ngage_r16(c,a);break;}pc=next;continue;}
            if((x&0xf000u)==0xc000u){int load=(x&0x0800u)!=0;unsigned rb=(x>>8)&7u;uint32_t list=x&255u,addr=c->r[rb];for(unsigned i=0;i<8;i++)if(list&(1u<<i)){if(load)c->r[i]=ngage_r32(c,addr);else ngage_w32(c,addr,c->r[i]);addr+=4;}c->r[rb]=addr;pc=next;continue;}
            if((x&0xfc00u)==0x4400u){unsigned op=(x>>8)&3u,rd=(x&7u)|((x>>4)&8u),rm=(x>>3)&15u;uint32_t b=(rm==15)?pc+4u:c->r[rm];if(op==0){uint32_t v=(rd==15?pc+4u:c->r[rd])+b;if(rd==15){if((v&~1u)==return_pc){fallback_depth--;return;}pc=v&~1u;thumb=(v&1u)!=0;continue;}c->r[rd]=v;}else if(op==1){sub_c(c,(rd==15?pc+4u:c->r[rd]),b,1,1);}else if(op==2){if(rd==15){if((b&~1u)==return_pc){fallback_depth--;return;}pc=b&~1u;thumb=(b&1u)!=0;continue;}c->r[rd]=b;}else{pc=b&~1u;thumb=(b&1u)!=0;continue;}pc=next;continue;}
            if((x&0xf800u)==0xa000u){unsigned rd=(x>>8)&7u;uint32_t base=(x&0x0800u)?c->r[13]:((pc+4u)&~3u);c->r[rd]=base+((x&255u)<<2);pc=next;continue;}
            if((x&0xff00u)==0xb000u){uint32_t amt=(x&0x7fu)<<2;if(x&0x80u)c->r[13]-=amt;else c->r[13]+=amt;pc=next;continue;}
            if((x&0xf800u)==0x1800u){unsigned op=(x>>9)&1u,imm=(x>>10)&1u,rs=(x>>3)&7u,rd=(x&7u),rn=(x>>6)&7u;uint32_t b=imm?rn:c->r[rn];c->r[rd]=op?sub_c(c,c->r[rs],b,1,1):add_c(c,c->r[rs],b,0,1);pc=next;continue;}
            if((x&0xfc00u)==0x4000u){unsigned op=(x>>6)&15u,rs=(x>>3)&7u,rd=x&7u;uint32_t a=c->r[rd],b=c->r[rs],v=0;switch(op){case 0:v=a&b;c->r[rd]=v;set_nz(c,v);break;case 1:v=a^b;c->r[rd]=v;set_nz(c,v);break;case 2:v=a<<(b&255u);c->r[rd]=v;set_nz(c,v);break;case 3:v=(uint32_t)((int32_t)a>>(b&255u));c->r[rd]=v;set_nz(c,v);break;case 4:v=a>>(b&255u);c->r[rd]=v;set_nz(c,v);break;case 5:c->r[rd]=add_c(c,a,b,!!(c->cpsr&C),1);break;case 6:c->r[rd]=sub_c(c,a,b,!!(c->cpsr&C),1);break;case 8:set_nz(c,a&b);break;case 10:sub_c(c,a,b,1,1);break;case 12:v=a|b;c->r[rd]=v;set_nz(c,v);break;case 13:v=a*b;c->r[rd]=v;set_nz(c,v);break;case 14:v=a&~b;c->r[rd]=v;set_nz(c,v);break;case 15:v=~b;c->r[rd]=v;set_nz(c,v);break;default:break;}pc=next;continue;}
            fprintf(stderr,"ARM fallback unsupported Thumb %04x at %08x (start %08x)\n",x,pc,start);fallback_depth--;return;
        }
        uint32_t ins=ngage_r32(c,pc); c->r[15]=pc+8u; unsigned cond=ins>>28; uint32_t next=pc+4u;
        if(!cond_pass(c,cond)){pc=next;continue;}
        /* BX / BLX register */
        if((ins&0x0ffffff0u)==0x012fff10u || (ins&0x0ffffff0u)==0x012fff30u){int link=(ins&0x20u)!=0;uint32_t target=c->r[ins&15u];if(link)c->r[14]=pc+4u;if((target&~1u)==return_pc){fallback_depth--;return;}if((target&~1u)<0x10000000u || (target&~1u)>=0x10300000u){fprintf(stderr,"ARM fallback INVALID BX pc=%08x ins=%08x rm=r%u target=%08x link=%u start=%08x entry_lr=%08x current_lr=%08x sp=%08x r0=%08x r1=%08x r2=%08x r3=%08x r4=%08x r5=%08x r6=%08x r7=%08x r8=%08x r9=%08x r10=%08x r11=%08x r12=%08x\n",pc,ins,ins&15u,target,(unsigned)link,start,return_addr,c->r[14],c->r[13],c->r[0],c->r[1],c->r[2],c->r[3],c->r[4],c->r[5],c->r[6],c->r[7],c->r[8],c->r[9],c->r[10],c->r[11],c->r[12]); c->r[15]=pc; fallback_depth--; return;}if(link){call_guest(c,target);pc=next;}else{pc=target&~1u;thumb=(target&1u)!=0;}continue;}
        /* B / BL */
        if((ins&0x0e000000u)==0x0a000000u){int link=(ins>>24)&1u;uint32_t target=pc+8u+(uint32_t)(signext(ins&0x00ffffffu,24)<<2);if(link){c->r[14]=next;call_guest(c,target);pc=next;}else pc=target;continue;}
        /* Single data transfer */
        if((ins&0x0c000000u)==0x04000000u){int regoff=(ins>>25)&1u,pre=(ins>>24)&1u,up=(ins>>23)&1u,byte=(ins>>22)&1u,wb=(ins>>21)&1u,load=(ins>>20)&1u;unsigned rn=(ins>>16)&15u,rd=(ins>>12)&15u;uint32_t base=regval(c,rn,pc),off;if(regoff){uint32_t carry=0;off=shift_imm(c,c->r[ins&15u],(ins>>5)&3u,(ins>>7)&31u,&carry);}else off=ins&0xfffu;uint32_t indexed=up?base+off:base-off,addr=pre?indexed:base;if(load){uint32_t v=byte?ngage_r8(c,addr):ngage_r32(c,addr);if(rd==15){if((v&~1u)==return_pc){fallback_depth--;return;}pc=v&~1u;thumb=(v&1u)!=0;}else{c->r[rd]=v;pc=next;}}else{uint32_t v=(rd==15)?pc+12u:c->r[rd];if(byte)ngage_w8(c,addr,(uint8_t)v);else ngage_w32(c,addr,v);pc=next;}if(!pre||wb)c->r[rn]=indexed;continue;}
        /* Halfword and signed transfers */
        if((ins&0x0e000090u)==0x00000090u && ((ins>>5)&3u)!=0u){int pre=(ins>>24)&1u,up=(ins>>23)&1u,imm=(ins>>22)&1u,wb=(ins>>21)&1u,load=(ins>>20)&1u;unsigned rn=(ins>>16)&15u,rd=(ins>>12)&15u,op=(ins>>5)&3u;uint32_t base=regval(c,rn,pc),off=imm?(((ins>>4)&0xf0u)|(ins&15u)):c->r[ins&15u],idx=up?base+off:base-off,addr=pre?idx:base;if(load){uint32_t v=0;if(op==1)v=ngage_r16(c,addr);else if(op==2)v=(uint32_t)(int32_t)(int8_t)ngage_r8(c,addr);else if(op==3)v=(uint32_t)(int32_t)(int16_t)ngage_r16(c,addr);if(rd==15){if((v&~1u)==return_pc){fallback_depth--;return;}pc=v&~1u;thumb=(v&1u)!=0;}else{c->r[rd]=v;pc=next;}}else{ngage_w16(c,addr,(uint16_t)c->r[rd]);pc=next;}if(!pre||wb)c->r[rn]=idx;continue;}
        /* Block data transfer */
        if((ins&0x0e000000u)==0x08000000u){int pre=(ins>>24)&1u,up=(ins>>23)&1u,wb=(ins>>21)&1u,load=(ins>>20)&1u;unsigned rn=(ins>>16)&15u;uint32_t list=ins&0xffffu;unsigned count=0;for(unsigned i=0;i<16;i++)if(list&(1u<<i))count++;uint32_t base=regval(c,rn,pc),addr;if(up)addr=base+(pre?4u:0u);else addr=base-4u*count+(pre?0u:4u);uint32_t loaded_pc=0;for(unsigned i=0;i<16;i++)if(list&(1u<<i)){if(load){uint32_t v=ngage_r32(c,addr);if(i==15)loaded_pc=v;else c->r[i]=v;}else ngage_w32(c,addr,i==15?pc+12u:c->r[i]);addr+=4u;}if(wb)c->r[rn]=up?base+4u*count:base-4u*count;if(load&&(list&0x8000u)){if((loaded_pc&~1u)==return_pc){fallback_depth--;return;}pc=loaded_pc&~1u;thumb=(loaded_pc&1u)!=0;}else pc=next;continue;}
        /* Data-processing instructions */
        if((ins&0x0c000000u)==0x00000000u && !(!(ins&(1u<<25)) && (ins&0x90u)==0x90u)){
            unsigned op=(ins>>21)&15u,rn=(ins>>16)&15u,rd=(ins>>12)&15u;int s=(ins>>20)&1u;uint32_t carry=0,op2=operand2(c,ins,pc,&carry),a=regval(c,rn,pc),v=0;int write=1;
            switch(op){case 0:v=a&op2;break;case 1:v=a^op2;break;case 2:v=sub_c(c,a,op2,1,s);break;case 3:v=sub_c(c,op2,a,1,s);break;case 4:v=add_c(c,a,op2,0,s);break;case 5:v=add_c(c,a,op2,!!(c->cpsr&C),s);break;case 6:v=sub_c(c,a,op2,!!(c->cpsr&C),s);break;case 7:v=sub_c(c,op2,a,!!(c->cpsr&C),s);break;case 8:v=a&op2;write=0;s=1;break;case 9:v=a^op2;write=0;s=1;break;case 10:v=sub_c(c,a,op2,1,1);write=0;break;case 11:v=add_c(c,a,op2,0,1);write=0;break;case 12:v=a|op2;break;case 13:v=op2;break;case 14:v=a&~op2;break;case 15:v=~op2;break;}
            if(s && op!=2 && op!=3 && op!=4 && op!=5 && op!=6 && op!=7 && op!=10 && op!=11){ c->cpsr&=~(N|Z|C);if(!v)c->cpsr|=Z;if(v&N)c->cpsr|=N;if(carry)c->cpsr|=C;}
            if(write){if(rd==15){if((v&~1u)==return_pc){fallback_depth--;return;}pc=v&~1u;thumb=(v&1u)!=0;}else{c->r[rd]=v;pc=next;}}else pc=next;continue;
        }
        /* MRS/MSR flags, common in interworking code */
        if((ins&0x0fbf0fffu)==0x010f0000u){unsigned rd=(ins>>12)&15u;c->r[rd]=c->cpsr;pc=next;continue;}
        if((ins&0x0db0f000u)==0x0120f000u){uint32_t v;if(ins&(1u<<25)){unsigned rot=((ins>>8)&15u)*2u;v=ror32(ins&255u,rot);}else v=c->r[ins&15u];c->cpsr=(c->cpsr&~0xf0000000u)|(v&0xf0000000u);pc=next;continue;}
        /* MUL / MLA */
        if((ins&0x0fc000f0u)==0x00000090u){unsigned rd=(ins>>16)&15u,rn=(ins>>12)&15u,rs=(ins>>8)&15u,rm=ins&15u;uint64_t v=(uint64_t)c->r[rm]*c->r[rs];if(ins&(1u<<21))v+=c->r[rn];c->r[rd]=(uint32_t)v;if(ins&(1u<<20))set_nz(c,c->r[rd]);pc=next;continue;}
        fprintf(stderr,"ARM fallback unsupported ARM %08x at %08x (start %08x)\n",ins,pc,start);fallback_depth--;return;
    }
    fprintf(stderr,"ARM fallback step limit at %08x (start %08x)\n",pc,start);fallback_depth--;
}

void arm_fallback_call(ngage_cpu_t*c,uint32_t address){run_arm(c,address);}
