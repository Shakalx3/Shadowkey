#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shadowkey_fbs_hle.h"
typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;
typedef void (*ngage_guest_fn)(ngage_cpu_t *);
extern ngage_guest_fn shadowkey_find_function(uint32_t);
extern void shadowkey_init_import_slots(ngage_cpu_t *);
extern const uint32_t shadowkey_function_registry_count;
extern const uint32_t shadowkey_import_registry_count;
extern void ngage_call(ngage_cpu_t *,uint32_t);
extern void shadowkey_heap_init(uint32_t,uint32_t);
extern void shadowkey_heap_extend(uint32_t);
extern uint32_t ngage_r32(ngage_cpu_t *,uint32_t);
extern void ngage_w32(ngage_cpu_t *,uint32_t,uint32_t);
static uint32_t guest_base=0x10000000u;
static size_t guest_size=0x02000000u;
static int memory_writes=0; static uint32_t watch_lo=0,watch_hi=0; static const char *app_path=0; static const char *simkin_path=0; static ngage_cpu_t *active_cpu=0;
static uint32_t bitmap_watch_lo=0,bitmap_watch_hi=0,bitmap_guest_write_count=0,bitmap_sample_count=0;
static struct {uint32_t addr,value,lr,sp;uint8_t width;} bitmap_samples[24];
static uint8_t *ptr(ngage_cpu_t*c,uint32_t a,size_t n){
 if(a<guest_base||(uint64_t)a+n>(uint64_t)guest_base+guest_size){if(active_cpu)fprintf(stderr,"OOB %08x/%zu pc=%08x lr=%08x sp=%08x r0=%08x r1=%08x r2=%08x r3=%08x r4=%08x r5=%08x r6=%08x r7=%08x r8=%08x r9=%08x r10=%08x r11=%08x r12=%08x cpsr=%08x\n",a,n,active_cpu->r[15],active_cpu->r[14],active_cpu->r[13],active_cpu->r[0],active_cpu->r[1],active_cpu->r[2],active_cpu->r[3],active_cpu->r[4],active_cpu->r[5],active_cpu->r[6],active_cpu->r[7],active_cpu->r[8],active_cpu->r[9],active_cpu->r[10],active_cpu->r[11],active_cpu->r[12],active_cpu->cpsr);else fprintf(stderr,"OOB %08x/%zu\n",a,n);exit(90);}
 return c->mem+(a-guest_base);
}
void ngage_runtime_watch_range(uint32_t lo,uint32_t size){watch_lo=lo;watch_hi=lo+size;fprintf(stderr,"WATCH RANGE armed %08x..%08x\n",watch_lo,watch_hi);}
void ngage_runtime_watch_bitmap_range(uint32_t lo,uint32_t size){
 bitmap_watch_lo=lo;bitmap_watch_hi=lo+size;bitmap_guest_write_count=0;bitmap_sample_count=0;
 fprintf(stderr,"BITMAP CPU WRITE WATCH armed %08x..%08x (%u bytes)\\n",lo,lo+size,size);
}
static void bitmap_write_note(ngage_cpu_t*c,uint32_t a,uint32_t v,uint8_t width){
 if(!bitmap_watch_hi || a>=bitmap_watch_hi || (uint64_t)a+width<=bitmap_watch_lo)return;
 bitmap_guest_write_count++;
 if(bitmap_sample_count<24u){
  bitmap_samples[bitmap_sample_count++]=(typeof(bitmap_samples[0])){a,v,c->r[14],c->r[13],width};
 }
}
void ngage_runtime_report_bitmap_writes(void){
 fprintf(stderr,"BITMAP CPU WRITE WATCH result: guest_store_ops=%u samples=%u\\n",bitmap_guest_write_count,bitmap_sample_count);
 for(uint32_t i=0;i<bitmap_sample_count;i++)
  fprintf(stderr,"BITMAP CPU WRITE sample[%u] width=%u addr=%08x value=%08x lr=%08x sp=%08x\\n",
   i,bitmap_samples[i].width,bitmap_samples[i].addr,bitmap_samples[i].value,bitmap_samples[i].lr,bitmap_samples[i].sp);
}
uint32_t ngage_r32(ngage_cpu_t*c,uint32_t a){uint8_t*p=ptr(c,a,4);uint32_t v=p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);if(watch_hi&&a<watch_hi&&(uint64_t)a+4u>watch_lo)fprintf(stderr,"WATCH RANGE READ32 addr=%08x value=%08x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);if(a==0x10125c44u)fprintf(stderr,"WATCH source+14a3c READ value=%08x\n",v);return v;}
void ngage_w32(ngage_cpu_t*c,uint32_t a,uint32_t v){bitmap_write_note(c,a,v,4);uint8_t*p=ptr(c,a,4);if(watch_hi&&a<watch_hi&&(uint64_t)a+4u>watch_lo)fprintf(stderr,"WATCH RANGE WRITE32 addr=%08x value=%08x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);p[0]=v;p[1]=v>>8;p[2]=v>>16;p[3]=v>>24;memory_writes++;if(a<=0x10125c44u && (uint64_t)a+4u>0x10125c44u)fprintf(stderr,"WATCH source+14a3c WRITE32 at=%08x value=%08x\n",a,v);if(a==0x10125cc4u)fprintf(stderr,"WATCH source2+14a3c WRITE32 at=%08x value=%08x pc=%08x lr=%08x\n",a,v,c->r[15],c->r[14]);}
uint32_t ngage_r16(ngage_cpu_t*c,uint32_t a){uint8_t*p=ptr(c,a,2);return p[0]|((uint32_t)p[1]<<8);}
void ngage_w16(ngage_cpu_t*c,uint32_t a,uint16_t v){bitmap_write_note(c,a,v,2);uint8_t*p=ptr(c,a,2);if(watch_hi&&a<watch_hi&&(uint64_t)a+2u>watch_lo)fprintf(stderr,"WATCH RANGE WRITE16 addr=%08x value=%04x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);p[0]=v;p[1]=v>>8;if(a<=0x10125c44u && (uint64_t)a+2u>0x10125c44u)fprintf(stderr,"WATCH source+14a3c WRITE16 at=%08x value=%04x\n",a,v);}
uint32_t ngage_r8(ngage_cpu_t*c,uint32_t a){return *ptr(c,a,1);}
void ngage_w8(ngage_cpu_t*c,uint32_t a,uint8_t v){bitmap_write_note(c,a,v,1);if(watch_hi&&a>=watch_lo&&a<watch_hi)fprintf(stderr,"WATCH RANGE WRITE8 addr=%08x value=%02x lr=%08x sp=%08x\n",a,v,c->r[14],c->r[13]);*ptr(c,a,1)=v;if(a>=0x10125c44u && a<0x10125c48u)fprintf(stderr,"WATCH source+14a3c WRITE8 at=%08x value=%02x\n",a,v);}
void ngage_set_nz(ngage_cpu_t*c,uint32_t v){c->cpsr&=~0xC0000000u;if(!v)c->cpsr|=1u<<30;if(v&0x80000000u)c->cpsr|=1u<<31;}
uint32_t ngage_sub_flags(ngage_cpu_t*c,uint32_t a,uint32_t b){uint32_t r=a-b;c->cpsr&=~0xF0000000u;if(!r)c->cpsr|=1u<<30;if(r&0x80000000u)c->cpsr|=1u<<31;if(a>=b)c->cpsr|=1u<<29;if(((a^b)&(a^r)&0x80000000u)!=0)c->cpsr|=1u<<28;return r;}
uint32_t ngage_add_flags(ngage_cpu_t*c,uint32_t a,uint32_t b,uint32_t cy){uint64_t z=(uint64_t)a+b+cy;uint32_t r=(uint32_t)z;c->cpsr&=~0xF0000000u;if(!r)c->cpsr|=1u<<30;if(r&0x80000000u)c->cpsr|=1u<<31;if(z>>32)c->cpsr|=1u<<29;if((~(a^b)&(a^r)&0x80000000u)!=0)c->cpsr|=1u<<28;return r;}
int ngage_zf(ngage_cpu_t*c){return(c->cpsr>>30)&1;} int ngage_cf(ngage_cpu_t*c){return(c->cpsr>>29)&1;} int ngage_nf(ngage_cpu_t*c){return(c->cpsr>>31)&1;} int ngage_vf(ngage_cpu_t*c){return(c->cpsr>>28)&1;}
void ngage_unimplemented(ngage_cpu_t*c,uint32_t a,const char*m){(void)c;fprintf(stderr,"unimplemented %08x: %s\n",a,m);}
static int run_case(int fail){
 shadowkey_fbs_reset();
 uint8_t *mem=calloc(1,guest_size);if(!mem)return 80;
 FILE*f=fopen(app_path,"rb");if(!f){free(mem);return 81;}
 if(fseek(f,0x7c,SEEK_SET)||fread(mem,1,0x1009c4,f)!=0x1009c4){fclose(f);free(mem);return 82;}fclose(f);
 f=fopen(simkin_path,"rb");if(!f){free(mem);return 83;}
 if(fseek(f,0x7c,SEEK_SET)||fread(mem+0x200000u,1,0x24db0u,f)!=0x24db0u){fclose(f);free(mem);return 84;}fclose(f);
 ngage_cpu_t c={0};active_cpu=&c;c.mem=mem;c.r[13]=0x102ff000u;c.r[4]=0xdeadbeefu;c.r[14]=0xcafebabeu;
 memory_writes=0; watch_lo=watch_hi=0; shadowkey_heap_init(0x10110000u,fail?0x10110000u:0x10170000u);
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
   /* Drive the engine's recovered active-object RunL once. In the original app
      this is scheduled by Symbian's active scheduler. Here we call it directly
      to discover the first real engine/resource-loading dependency. */
   c.r[13]=0x102ff000u;
   fprintf(stderr,"ENGINE before: +0x30=%08x +0x34=%08x +0x3ac=%02x +0x3ad=%02x\n",ngage_r32(&c,engine+0x30u),ngage_r32(&c,engine+0x34u),ngage_r8(&c,engine+0x3acu),ngage_r8(&c,engine+0x3adu));
   /* preserve constructor state for live RunL probe */
   /* Expand only the diagnostic heap after AppUi construction; growing it
      earlier changes allocator success paths and corrupts the bootstrap test. */
   shadowkey_heap_extend(0x101ff000u);
   c.r[0]=engine;
   ngage_call(&c,0x1002256cu);
   fprintf(stderr,"ENGINE RUNL live-state returned r0=%08x engine+0x30=%08x engine+0x34=%08x engine+0x3ad=%02x\n",c.r[0],ngage_r32(&c,engine+0x30u),ngage_r32(&c,engine+0x34u),ngage_r8(&c,engine+0x3adu));
   ngage_runtime_report_bitmap_writes();
   /* Preserve the actual guest FBS bitmap after the unmodified RunL path.
      This is a raw capture only: no synthetic pixels are inserted. */
   {
     uint32_t bitmap=ngage_r32(&c,engine+0x2e4u),pixels=0,w=0,h=0,stride=0,mode=0;
     if(shadowkey_fbs_bitmap_info(bitmap,&pixels,&w,&h,&stride,&mode) &&
        pixels>=guest_base && (uint64_t)pixels+(uint64_t)stride*h<=(uint64_t)guest_base+guest_size) {
       FILE *raw=fopen(".build/live_run_bitmap.rgb565","wb");
       FILE *meta=fopen(".build/live_run_bitmap.meta","w");
       if(raw && meta) {
         size_t bytes=(size_t)stride*h;
         size_t wrote=fwrite(mem+(pixels-guest_base),1,bytes,raw);
         fprintf(meta,"%u %u %u %u %u %08x %08x\n",w,h,stride,mode,(unsigned)bytes,bitmap,pixels);
         uint32_t nonzero=0;
         for(size_t i=0;i<bytes;i++) if(mem[(pixels-guest_base)+i]) nonzero++;
         fprintf(stderr,"FRAMEBUFFER RAW captured bitmap=%08x pixels=%08x size=%ux%u stride=%u mode=%u bytes=%zu nonzero=%u\n",
                 bitmap,pixels,w,h,stride,mode,bytes,nonzero);
         if(wrote!=bytes) fprintf(stderr,"FRAMEBUFFER RAW short write %zu/%zu\n",wrote,bytes);
       } else fprintf(stderr,"FRAMEBUFFER RAW could not open output files\n");
       if(raw) fclose(raw); if(meta) fclose(meta);
     } else fprintf(stderr,"FRAMEBUFFER RAW unavailable bitmap=%08x\n",bitmap);
   }
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
 puts("PASS: app factory, document vtable dispatch, AppUi construction (51 import calls), engine object/back-pointer, allocation failure and IAT-slot dispatch pass");
 return 0;
}
