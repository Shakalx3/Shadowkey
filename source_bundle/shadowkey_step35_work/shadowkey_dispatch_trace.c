/* Shadowkey dispatch with the recovered SIMKIN.DLL implementation. */
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include "shadowkey_cone_gc_hle.h"
#include "shadowkey_bitgdi_hle.h"
typedef void (*ngage_guest_fn)(ngage_cpu_t *);
extern ngage_guest_fn shadowkey_find_function(uint32_t);
extern int shadowkey_find_import_thunk(uint32_t,const char **,uint16_t *,uint32_t *);
extern int shadowkey_find_import_slot(uint32_t,const char **,uint16_t *);
extern void shadowkey_hle_import(ngage_cpu_t *,const char *,uint16_t);
extern void ngage_unimplemented(ngage_cpu_t *,uint32_t,const char *);
extern uint32_t ngage_r32(ngage_cpu_t *,uint32_t);
extern ngage_guest_fn simkin_find_function(uint32_t);
extern ngage_guest_fn simkin_find_export(uint16_t);
extern void arm_fallback_call(ngage_cpu_t *,uint32_t);
extern int simkin_find_import_thunk(uint32_t,const char **,uint16_t *);
extern int simkin_find_import_slot(uint32_t,const char **,uint16_t *);
uint32_t simkin_export_calls=0, simkin_system_import_calls=0;
extern void ngage_runtime_guest_function_enter(uint32_t) __attribute__((weak));
extern void ngage_runtime_guest_function_exit(void) __attribute__((weak));
static void tracked_guest_call(uint32_t address,ngage_guest_fn fn,ngage_cpu_t*c){
    if(address==0x100275e4u){
        fprintf(stderr,"RESLOAD ENTER fn=%08x r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x\\n",
                address,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
        for(uint32_t off=0;off<0x20u;off+=4u)
            fprintf(stderr,"RESLOAD stack[%02x]=%08x\\n",off,ngage_r32(c,c->r[13]+off));
        fprintf(stderr,"RESLOAD caller-state r4(table)=%08x r12(index)=%08x\\n",c->r[4],c->r[12]);
        if(c->r[4]>=0x10000000u && c->r[4]<0x12000000u && c->r[12]<0x10000u){
            for(int32_t d=-2;d<=3;d++){
                uint32_t ix=(uint32_t)((int32_t)c->r[12]+d);
                uint32_t a=c->r[4]+ix*4u;
                if(a>=0x10000000u && (uint64_t)a+4u<=0x12000000ull)
                    fprintf(stderr,"RESLOAD table[%08x]=%08x\\n",ix,ngage_r32(c,a));
            }
        }
    }
    if(address==0x1006a488u){
        fprintf(stderr,"IMGDEC ENTER fn=%08x r0=%08x r1(dest)=%08x r2=%08x r3=%08x sp=%08x lr=%08x\\n",
                address,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
        for(uint32_t off=0;off<0x30u;off+=4u)
            fprintf(stderr,"IMGDEC stack[%02x]=%08x\\n",off,ngage_r32(c,c->r[13]+off));
        {
            uint32_t src=ngage_r32(c,c->r[13]);
            fprintf(stderr,"IMGDEC source_base=%08x payload=%08x\\n",src,src+0x204u);
            if(src>=0x10000000u && (uint64_t)src+0x244u<=0x12000000ull){
                for(uint32_t off=0;off<0x40u;off+=4u)
                    fprintf(stderr,"IMGDEC header[%03x]=%08x\\n",off,ngage_r32(c,src+off));
                for(uint32_t off=0;off<0x40u;off+=4u)
                    fprintf(stderr,"IMGDEC payload[%03x]=%08x\\n",off,ngage_r32(c,src+0x204u+off));
            }
        }
    }
    if(ngage_runtime_guest_function_enter)ngage_runtime_guest_function_enter(address);
    fn(c);
    if(address==0x1006a488u)
        fprintf(stderr,"IMGDEC EXIT fn=%08x r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x\\n",
                address,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
    if(address==0x100275e4u)
        fprintf(stderr,"RESLOAD EXIT fn=%08x r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x\\n",
                address,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
    if(ngage_runtime_guest_function_exit)ngage_runtime_guest_function_exit();
}

void simkin_call_export(ngage_cpu_t *c,uint16_t ordinal) {
    ngage_guest_fn fn=simkin_find_export(ordinal);
    if(fn){
        if(ordinal==59u) fprintf(stderr,"SIMKIN EXPORT 59 enter r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x\n",c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
        simkin_export_calls++;fn(c);
        if(ordinal==59u) fprintf(stderr,"SIMKIN EXPORT 59 exit  r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x\n",c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
        return;
    }
    ngage_unimplemented(c,ordinal,"missing SIMKIN export ordinal");c->r[0]=0;
}

void simkin_call(ngage_cpu_t *c,uint32_t address) {
    const char *dll=0;uint16_t ordinal=0;
    if(simkin_find_import_thunk(address,&dll,&ordinal)||simkin_find_import_slot(address,&dll,&ordinal)){
        simkin_system_import_calls++;shadowkey_hle_import(c,dll,ordinal);return;
    }
    ngage_guest_fn fn=simkin_find_function(address);
    if(fn){
        if(address==0x102132b8u || address==0x10211e14u || address==0x10221060u || address==0x102047d0u) fprintf(stderr,"SIMKIN before %08x r0=%08x r1=%08x r2=%08x r3=%08x r4=%08x r5=%08x sp=%08x lr=%08x\n",address,c->r[0],c->r[1],c->r[2],c->r[3],c->r[4],c->r[5],c->r[13],c->r[14]);
        tracked_guest_call(address,fn,c);
        if(address==0x102132b8u || address==0x10211e14u || address==0x10221060u || address==0x102047d0u) fprintf(stderr,"SIMKIN after  %08x r0=%08x r1=%08x r2=%08x r3=%08x r4=%08x r5=%08x sp=%08x lr=%08x\n",address,c->r[0],c->r[1],c->r[2],c->r[3],c->r[4],c->r[5],c->r[13],c->r[14]);
        return;
    }
    /* A DLL callback may point back into the main executable. The two images
       occupy disjoint guest VA ranges after relocating SIMKIN to 0x10200000. */
    fn=shadowkey_find_function(address);
    if(fn){fn(c);return;}
    if(address>=0x10000000u && address<0x10300000u){arm_fallback_call(c,address);return;}
    ngage_unimplemented(c,address,"unresolved SIMKIN guest address");c->r[0]=0;
}

void ngage_call(ngage_cpu_t *c,uint32_t address) {
    if(shadowkey_bitgdi_virtual(c,address)) return;
    if((address&~1u)==0x100298a4u) { uint32_t p=c->r[0],vt=ngage_r32(c,p+4u); fprintf(stderr,"TRACE ENTER sub_100298a4 caller_lr=%08x parent=%08x hdr=%08x vtable=%08x vtable+10=%08x parent+14=%08x\n",c->r[14],p,ngage_r32(c,p),vt,vt?ngage_r32(c,vt+0x10u):0u,ngage_r32(c,p+0x14u)); }
    if (shadowkey_cone_gc_dispatch(c,address)) return;
    if (address==0x10023ad0u || address==0x10027aecu || address==0x1002256cu) fprintf(stderr,"CALL target=%08x r0=%08x r1=%08x r2=%08x r3=%08x lr=%08x sp=%08x cpsr=%08x\n",address,c->r[0],c->r[1],c->r[2],c->r[3],c->r[14],c->r[13],c->cpsr);
    const char *dll=0;uint16_t ordinal=0;
    if(shadowkey_find_import_thunk(address,&dll,&ordinal,0)){
        if(dll && strncmp(dll,"SIMKIN[",7)==0){simkin_call_export(c,ordinal);return;}
        shadowkey_hle_import(c,dll,ordinal);return;
    }
    if(shadowkey_find_import_slot(address,&dll,&ordinal)){
        if(dll && strncmp(dll,"SIMKIN[",7)==0){simkin_call_export(c,ordinal);return;}
        shadowkey_hle_import(c,dll,ordinal);return;
    }
    ngage_guest_fn fn=shadowkey_find_function(address);
    if(fn){
        tracked_guest_call(address,fn,c);
        return;
    }
    if(address>=0x10000000u && address<0x10300000u){
        if(ngage_runtime_guest_function_enter)ngage_runtime_guest_function_enter(address);
        arm_fallback_call(c,address);
        if(ngage_runtime_guest_function_exit)ngage_runtime_guest_function_exit();
        return;
    }
    ngage_unimplemented(c,address,"unresolved guest address");c->r[0]=0;
}
