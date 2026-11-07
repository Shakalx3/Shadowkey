#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;
typedef void (*ngage_guest_fn)(ngage_cpu_t *);
extern ngage_guest_fn shadowkey_find_function(uint32_t);
extern void shadowkey_init_import_slots(ngage_cpu_t *);
extern const uint32_t shadowkey_function_registry_count;
extern const uint32_t shadowkey_import_registry_count;
extern void ngage_call(ngage_cpu_t *,uint32_t);
extern void shadowkey_heap_init(uint32_t,uint32_t);
extern void shadowkey_hle_import(ngage_cpu_t *,const char *,uint16_t);
extern uint32_t ngage_r32(ngage_cpu_t *,uint32_t);
extern void ngage_w32(ngage_cpu_t *,uint32_t,uint32_t);
static uint32_t guest_base=0x10000000u;
static size_t guest_size=0x02000000u;
static int memory_writes=0; static const char *app_path=0; static const char *simkin_path=0;
static uint8_t *ptr(ngage_cpu_t*c,uint32_t a,size_t n){
 if(a<guest_base||(uint64_t)a+n>(uint64_t)guest_base+guest_size){fprintf(stderr,"OOB %08x/%zu\n",a,n);exit(90);}
 return c->mem+(a-guest_base);
}
uint32_t ngage_r32(ngage_cpu_t*c,uint32_t a){uint8_t*p=ptr(c,a,4);return p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
void ngage_w32(ngage_cpu_t*c,uint32_t a,uint32_t v){uint8_t*p=ptr(c,a,4);p[0]=v;p[1]=v>>8;p[2]=v>>16;p[3]=v>>24;memory_writes++;}
uint32_t ngage_r16(ngage_cpu_t*c,uint32_t a){uint8_t*p=ptr(c,a,2);return p[0]|((uint32_t)p[1]<<8);}
void ngage_w16(ngage_cpu_t*c,uint32_t a,uint16_t v){uint8_t*p=ptr(c,a,2);p[0]=v;p[1]=v>>8;}
uint32_t ngage_r8(ngage_cpu_t*c,uint32_t a){return *ptr(c,a,1);}
void ngage_w8(ngage_cpu_t*c,uint32_t a,uint8_t v){*ptr(c,a,1)=v;}
void ngage_set_nz(ngage_cpu_t*c,uint32_t v){c->cpsr&=~0xC0000000u;if(!v)c->cpsr|=1u<<30;if(v&0x80000000u)c->cpsr|=1u<<31;}
uint32_t ngage_sub_flags(ngage_cpu_t*c,uint32_t a,uint32_t b){uint32_t r=a-b;c->cpsr&=~0xF0000000u;if(!r)c->cpsr|=1u<<30;if(r&0x80000000u)c->cpsr|=1u<<31;if(a>=b)c->cpsr|=1u<<29;if(((a^b)&(a^r)&0x80000000u)!=0)c->cpsr|=1u<<28;return r;}
uint32_t ngage_add_flags(ngage_cpu_t*c,uint32_t a,uint32_t b,uint32_t cy){uint64_t z=(uint64_t)a+b+cy;uint32_t r=(uint32_t)z;c->cpsr&=~0xF0000000u;if(!r)c->cpsr|=1u<<30;if(r&0x80000000u)c->cpsr|=1u<<31;if(z>>32)c->cpsr|=1u<<29;if((~(a^b)&(a^r)&0x80000000u)!=0)c->cpsr|=1u<<28;return r;}
int ngage_zf(ngage_cpu_t*c){return(c->cpsr>>30)&1;} int ngage_cf(ngage_cpu_t*c){return(c->cpsr>>29)&1;} int ngage_nf(ngage_cpu_t*c){return(c->cpsr>>31)&1;} int ngage_vf(ngage_cpu_t*c){return(c->cpsr>>28)&1;}
void ngage_unimplemented(ngage_cpu_t*c,uint32_t a,const char*m){(void)c;fprintf(stderr,"unimplemented %08x: %s\n",a,m);}
static int run_case(int fail){
 uint8_t *mem=calloc(1,guest_size);if(!mem)return 80;
 FILE*f=fopen(app_path,"rb");if(!f){free(mem);return 81;}
 if(fseek(f,0x7c,SEEK_SET)||fread(mem,1,0x1009c4,f)!=0x1009c4){fclose(f);free(mem);return 82;}fclose(f);
 f=fopen(simkin_path,"rb");if(!f){free(mem);return 83;}
 if(fseek(f,0x7c,SEEK_SET)||fread(mem+0x200000u,1,0x24db0u,f)!=0x24db0u){fclose(f);free(mem);return 84;}fclose(f);
 ngage_cpu_t c={0};c.mem=mem;c.r[13]=0x102ff000u;c.r[4]=0xdeadbeefu;c.r[14]=0xcafebabeu;
 /* Verify the recovered EUSER ordinal 1 ABI independently of the zero-filled
    bootstrap heap: only n bytes are written and r0 returns the destination. */
 { uint32_t dst=0x102ff000u; memset(mem+(dst-guest_base),0xcc,32u);
   c.r[0]=dst; c.r[1]=0xa5u; c.r[2]=13u;
   shadowkey_hle_import(&c,"EUSER[100039e5].DLL",1u);
   if(c.r[0]!=dst){fprintf(stderr,"EUSER ordinal 1 memset return mismatch: %08x\n",c.r[0]);free(mem);return 18;}
   for(unsigned i=0;i<32u;i++){uint8_t want=i<13u?0xa5u:0xccu;if(mem[(dst-guest_base)+i]!=want){fprintf(stderr,"EUSER ordinal 1 memset byte %u mismatch\n",i);free(mem);return 19;}}
 }
 memory_writes=0; shadowkey_heap_init(0x10110000u,fail?0x10110000u:0x10170000u);
 shadowkey_init_import_slots(&c);
 if(memory_writes!=414){fprintf(stderr,"expected 414 IAT self-pointer writes, got %d\n",memory_writes);free(mem);return 4;}
 ngage_guest_fn entry=shadowkey_find_function(0x1002841cu);if(!entry){free(mem);return 5;}
 entry(&c);
 if(c.r[13]!=0x102ff000u||c.r[4]!=0xdeadbeefu||c.r[14]!=0xcafebabeu){fprintf(stderr,"register/stack restore failure\n");free(mem);return 6;}
 if(fail){if(c.r[0]!=0){fprintf(stderr,"null allocation path failure\n");free(mem);return 7;}}
 else {
   if(c.r[0]!=0x10110000u||ngage_r32(&c,0x10110000u)!=0x100fd9bcu){fprintf(stderr,"NewApplication object construction failed\n");free(mem);return 8;}
   uint32_t app=c.r[0], vtable=ngage_r32(&c,app), method=ngage_r32(&c,vtable+0x38u);
   if(method!=0x100209c4u){fprintf(stderr,"expected recovered vtable target at +0x38, got %08x\n",method);free(mem);return 11;}
   ngage_call(&c,method);
   uint32_t doc=c.r[0];
   if(doc!=0x10110230u||ngage_r32(&c,doc)!=0x100fd828u){fprintf(stderr,"vtable-dispatched object factory failed: ptr=%08x vptr=%08x\n",doc,ngage_r32(&c,doc));free(mem);return 12;}
   uint32_t doc_method=ngage_r32(&c,ngage_r32(&c,doc)+0x4cu);
   if(doc_method!=0x1002835cu){fprintf(stderr,"expected recovered document vtable target +0x4c, got %08x\n",doc_method);free(mem);return 13;}
   c.r[0]=doc; ngage_call(&c,doc_method);
   uint32_t appui=ngage_r32(&c,doc+0x24u);
   if(!appui||ngage_r32(&c,appui)!=0x100fc4d8u){fprintf(stderr,"second vtable factory failed: appui=%08x vptr=%08x\n",appui,appui?ngage_r32(&c,appui):0);free(mem);return 14;}
   /* Run the recovered AppUi construction method through the guest dispatcher. */
   c.r[13]=0x102ff000u;
   c.r[0]=appui;
   ngage_call(&c,ngage_r32(&c,ngage_r32(&c,appui)+0x3cu));
   uint32_t engine=ngage_r32(&c,appui+0x60u);
   if(!engine || ngage_r32(&c,engine)!=0x100fcf68u){fprintf(stderr,"AppUi ConstructL did not create the engine object: %08x / %08x\n",engine,engine?ngage_r32(&c,engine):0);free(mem);return 15;}
   if(ngage_r32(&c,engine+0x25cu)!=appui){fprintf(stderr,"engine back-pointer was not initialized\n");free(mem);return 16;}
   if(ngage_r8(&c,appui+0x68u)!=0){fprintf(stderr,"AppUi flag was not reset\n");free(mem);return 17;}
   /* Verify that the import-slot indirection still works after the init path. */
   shadowkey_heap_init(0x10110000u,0x10170000u);
   c.r[0]=556u; ngage_call(&c,0x101007ecu);
   if(c.r[0]!=0x10110000u){fprintf(stderr,"IAT slot dispatch failed\n");free(mem);return 10;}
 }
 free(mem);return 0;
}
int main(int argc,char **argv){
 if(argc!=3){fprintf(stderr,"usage: %s 6R51.APP SIMKIN_relocated.DLL\n",argv[0]);return 64;} app_path=argv[1];simkin_path=argv[2];
 if(shadowkey_function_registry_count!=2364u||shadowkey_import_registry_count!=414u){fprintf(stderr,"registry counts wrong\n");return 1;}
 if(run_case(0)||run_case(1))return 2;
 puts("PASS: EUSER ordinal 1 memset ABI; app factory, document vtable dispatch, AppUi construction (51 import calls), engine object/back-pointer, allocation failure and IAT-slot dispatch pass");
 return 0;
}
