/* Observed-call-site HLE bootstrap for Shadowkey; unresolved imports remain explicit diagnostic stubs. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <sys/stat.h>
#include "shadowkey_cone_gc_hle.h"
#include "shadowkey_fbs_hle.h"
#include "shadowkey_bitgdi_hle.h"
typedef struct { uint32_t object; FILE *fp; char path[1024]; } vfile_t;
static vfile_t vfiles[32];
static vfile_t *vfile_for(uint32_t object, int create){
    vfile_t *empty=NULL;
    for(size_t i=0;i<sizeof(vfiles)/sizeof(vfiles[0]);i++){
        if(vfiles[i].object==object && object) return &vfiles[i];
        if(!vfiles[i].object && !empty) empty=&vfiles[i];
    }
    if(create && empty){empty->object=object;return empty;} return NULL;
}
extern uint32_t ngage_r32(ngage_cpu_t *, uint32_t);
extern void ngage_runtime_watch_range(uint32_t,uint32_t) __attribute__((weak));
static uint32_t heap_next=0, heap_end=0, heap2_next=0x10230000u, heap2_end=0x10300000u, heap3_next=0x10400000u, heap3_end=0x12000000u;
void shadowkey_heap_init(uint32_t begin,uint32_t end){heap_next=begin;heap_end=end;heap2_next=(end>begin)?0x10230000u:0x12000000u;heap3_next=(end>begin)?0x10400000u:0x12000000u;}
void shadowkey_heap_extend(uint32_t end){heap_end=end;}
static uint8_t *guest_ptr(ngage_cpu_t*c,uint32_t a,uint32_t n){
    (void)n;
    if(a<0x10000000u) return 0;
    return c->mem+(a-0x10000000u);
}
uint32_t shadowkey_heap_alloc(ngage_cpu_t*c,uint32_t size){
    if(!size)return 0;
    uint32_t p=0;
    if(heap_next && heap_next<=heap_end && size<=heap_end-heap_next){p=(heap_next+7u)&~7u;if(p<=heap_end && size<=heap_end-p){uint8_t*m=guest_ptr(c,p,size);if(m){memset(m,0,size);heap_next=p+((size+7u)&~7u);return p;}}}
    if(heap2_next && heap2_next<=heap2_end && size<=heap2_end-heap2_next){p=(heap2_next+7u)&~7u;if(p<=heap2_end && size<=heap2_end-p){uint8_t*m=guest_ptr(c,p,size);if(m){memset(m,0,size);heap2_next=p+((size+7u)&~7u);fprintf(stderr,"  HLE secondary heap alloc size=%u -> %08x next=%08x end=%08x\n",size,p,heap2_next,heap2_end);return p;}}}
    if(heap3_next && heap3_next<=heap3_end && size<=heap3_end-heap3_next){p=(heap3_next+7u)&~7u;if(p<=heap3_end && size<=heap3_end-p){uint8_t*m=guest_ptr(c,p,size);if(m){memset(m,0,size);heap3_next=p+((size+7u)&~7u);fprintf(stderr,"  HLE extended heap alloc size=%u -> %08x next=%08x end=%08x\n",size,p,heap3_next,heap3_end);return p;}}}
    return 0;
}
static void trace_guest_bytes(ngage_cpu_t*c,const char*label,uint32_t a,uint32_t n){
    uint8_t*p=guest_ptr(c,a,n); if(!p){fprintf(stderr,"  TRACE %s @%08x <unmapped>\n",label,a);return;}
    fprintf(stderr,"  TRACE %s @%08x:",label,a);
    for(uint32_t i=0;i<n;i++) fprintf(stderr," %02x",p[i]);
    fputc('\n',stderr);
}
static uint32_t rd32(ngage_cpu_t*c,uint32_t a){uint8_t*p=guest_ptr(c,a,4);if(!p)return 0;return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
static void wr32(ngage_cpu_t*c,uint32_t a,uint32_t v){uint8_t*p=guest_ptr(c,a,4);if(!p)return;p[0]=v;p[1]=v>>8;p[2]=v>>16;p[3]=v>>24;}
static size_t guest_cstr(ngage_cpu_t*c,uint32_t a,char*out,size_t cap){if(!out||!cap||a<0x10000000u||a>=0x12000000u){if(cap)out[0]=0;return 0;}size_t n=0;while(n+1<cap&&a+n<0x12000000u){char ch=(char)c->mem[(a-0x10000000u)+n];out[n++]=ch;if(!ch)break;}out[cap-1]=0;return n?n-1:0;}
static void guest_put_cstr(ngage_cpu_t*c,uint32_t a,const char*s){if(a<0x10000000u||a>=0x12000000u)return;size_t n=strlen(s);if(n>0x1000)n=0x1000;uint8_t*p=guest_ptr(c,a,(uint32_t)n+1);if(p){memcpy(p,s,n);p[n]=0;}}
static int descriptor_info(ngage_cpu_t*c,uint32_t a,uint32_t*len,uint32_t*max,uint32_t*data){
    if(a<0x10000000u || a>=0x12000000u)return 0;
    uint32_t h=rd32(c,a),type=h>>28;*len=h&0x0fffffffu;*max=*len;*data=0;
    if(type==1u){*data=rd32(c,a+4u);return *data>=0x10000000u && *data<0x12000000u;}
    if(type==2u){*data=rd32(c,a+4u);*max=rd32(c,a+8u);return *data>=0x10000000u && *data<0x12000000u;}
    if(type==3u){*max=rd32(c,a+4u);*data=a+8u;return 1;}
    if(type==4u){*data=a+4u;return 1;}
    return 0;
}
static uint32_t pathish_utf16_len(ngage_cpu_t*c,uint32_t data,uint32_t limit){
    uint8_t*p=guest_ptr(c,data,6u);if(!p)return limit;
    uint16_t a=(uint16_t)p[0]|((uint16_t)p[1]<<8),b=(uint16_t)p[2]|((uint16_t)p[3]<<8),d=(uint16_t)p[4]|((uint16_t)p[5]<<8);
    if(!((a>='A'&&a<='Z')||(a>='a'&&a<='z'))||b!=':'||d!='\\')return limit;
    uint32_t n=0;while(n<limit){uint8_t*q=guest_ptr(c,data+n*2u,2u);if(!q)break;uint16_t ch=(uint16_t)q[0]|((uint16_t)q[1]<<8);if(!ch||ch<32u||ch>126u)break;n++;}return n;
}
void shadowkey_hle_import(ngage_cpu_t*c,const char*dll,uint16_t ordinal){
    fprintf(stderr,"IMPORT dll=%s ord=%u r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x cpsr=%08x\n",dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14],c->cpsr);
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1407u) {
        /* Optional watch: record writes to the 24-byte GDI108 receiver from
           the font-name producer onward. This determines whether its leading
           word is actually initialized in this call path or merely inherited
           from reused stack memory. */
        const char *watch=getenv("SHADOWKEY_WATCH_GDI108_RECEIVER");
        if(watch && *watch && strcmp(watch,"0") && ngage_runtime_watch_range) {
            uint32_t off=0;
            switch(c->r[14]) {
                case 0x10022b80u: case 0x10022dacu: case 0x10022fe8u: off=0x268u; break;
                case 0x10023230u: off=0x680u; break;
                case 0x1002366cu: off=0x678u; break;
                default: break;
            }
            if(off) { uint32_t base=c->r[13]+off; ngage_runtime_watch_range(base,24u); fprintf(stderr,"  WATCH GDI108 receiver armed base=%08x size=24 lr=%08x\n",base,c->r[14]); }
        }
        fprintf(stderr,"  EUSER1407 FORENSIC r0=%08x r1=%08x r2=%08x r3=%08x\n",c->r[0],c->r[1],c->r[2],c->r[3]);
        trace_guest_bytes(c,"EUSER1407 destination pre8",c->r[0]-8u,8u);
        trace_guest_bytes(c,"EUSER1407 destination before",c->r[0],24u);
        if(c->r[1]>=0x10000000u && c->r[1]<0x12000000u) trace_guest_bytes(c,"EUSER1407 source candidate",c->r[1],40u);
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1407u) {
        static const uint32_t sites[]={0x10022b80u,0x10022dacu,0x10022fe8u,0x10023230u,0x1002366cu};
        int matched=0;
        for(unsigned i=0;i<sizeof(sites)/sizeof(sites[0]);i++) if(c->r[14]==sites[i]) matched=1;
        if(matched && c->r[1]==0x100ac718u) {
            uint32_t dst=c->r[0],src=c->r[1];
            uint8_t *p=guest_ptr(c,dst,20u),*q=guest_ptr(c,src,12u);
            static const uint16_t expected[6]={'S','w','i','s','s',0};
            int valid=p&&q&&dst>=0x10000000u&&(uint64_t)dst+20u<=0x12000000ull;
            for(unsigned i=0;i<6&&valid;i++){
                uint16_t ch=(uint16_t)(q[i*2u]|((uint16_t)q[i*2u+1u]<<8));
                if(ch!=expected[i]) valid=0;
            }
            if(!valid){fprintf(stderr,"  HLE EUSER1407 rejected Swiss literal callsite lr=%08x dst=%08x src=%08x\n",c->r[14],dst,src);return;}
            /* Five callsites copy exactly 20 bytes immediately afterwards.
               Implement only the no-directive Swiss Format case, not the
               generic variadic formatter used by other EUSER1407 callers. */
            wr32(c,dst,0x30000005u); wr32(c,dst+4u,6u);
            memset(p+8u,0,12u);
            for(unsigned i=0;i<5;i++){p[8u+i*2u]=(uint8_t)expected[i];p[9u+i*2u]=(uint8_t)(expected[i]>>8);}
            fprintf(stderr,"  HLE EUSER1407 Format literal-only: TBuf16<6> length=5 text=Swiss lr=%08x\n",c->r[14]);
            trace_guest_bytes(c,"EUSER1407 formatted descriptor",dst,20u);
            return;
        }
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==1373u || ordinal==530u)) {
        fprintf(stderr,"  EUSER%u object forensic @%08x\n",ordinal,c->r[0]);
        trace_guest_bytes(c,"EUSER font/spec object",c->r[0],60u);
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1282u) {
        fprintf(stderr,"  EUSER1282 FORENSIC r0=%08x r1=%08x bytes=%u\n",c->r[0],c->r[1],c->r[2]);
        trace_guest_bytes(c,"EUSER1282 destination before",c->r[0],c->r[2]);
        trace_guest_bytes(c,"EUSER1282 source before",c->r[1],c->r[2]);
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && (ordinal==151u || ordinal==108u || ordinal==101u)) {
        fprintf(stderr,"  GDI FORENSIC ordinal=%u args=(%08x,%08x,%08x,%08x) stack=%08x\n",ordinal,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13]);
        if(ordinal==151u){
            trace_guest_bytes(c,"GDI151 TFontSpec before",c->r[0],60u);
            trace_guest_bytes(c,"GDI151 descriptor",c->r[1],20u);
            uint32_t dh=rd32(c,c->r[1]),dtype=dh>>28,dlen=dh&0x0fffffffu;
            if(dtype==3u){
                uint32_t dmax=rd32(c,c->r[1]+4u);
                fprintf(stderr,"  GDI151 TBuf16 decode: type=%u length=%u max=%u\n",dtype,dlen,dmax);
                trace_guest_bytes(c,"GDI151 TBuf16 inline data",c->r[1]+8u,dlen*2u);
            } else {
                fprintf(stderr,"  GDI151 descriptor decode: type=%u length=%u (not inline TBuf)\n",dtype,dlen);
                trace_guest_bytes(c,"GDI151 descriptor data candidate",rd32(c,c->r[1]+4u),48u);
            }
        } else {
            if(ordinal==108u) trace_guest_bytes(c,"GDI108 TFontStyle candidate PRE-CALL",c->r[0],12u);
            trace_guest_bytes(c,ordinal==108u?"GDI108 receiver context PRE-CALL":"GDI101 receiver PRE-CALL",c->r[0],24u);
            if(c->r[1]>=0x10000000u && c->r[1]<0x12000000u)
                trace_guest_bytes(c,"GDI helper arg1",c->r[1],20u);
        }
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && ordinal==108u) {
        const char *probe=getenv("SHADOWKEY_EXPERIMENTAL_GDI108_TFONTSTYLE");
        if(probe && *probe && strcmp(probe,"0") &&
           c->r[14]==0x10023290u && c->r[1]==0u) {
            uint8_t *dst=guest_ptr(c,c->r[0],12u);
            if(!dst) { c->r[0]=(uint32_t)-6; return; }
            /* Candidate TFontSpec layout: iFontStyle is the 12-byte member
               at +0x3C. The observed call has r0 exactly at TFontSpec+0x3C
               and r1=0, so test only the documented default style values:
               upright / normal weight / normal print position. The exact
               ordinal identity remains unverified; nonzero r1 stays unhandled. */
            memset(dst,0,12u);
            fprintf(stderr,"  EXPERIMENT GDI108 TFontStyle default: dst=%08x spec=%08x+0x3c fields={0,0,0} size=12\n",c->r[0],c->r[0]-0x3cu);
            trace_guest_bytes(c,"GDI108 experimental TFontStyle AFTER",c->r[0],12u);
            c->r[0]=0;
            return;
        }
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && ordinal==151u) {
        const char *probe=getenv("SHADOWKEY_EXPERIMENTAL_GDI151_TFONTSPEC");
        if(probe && *probe && strcmp(probe,"0") && c->r[14]==0x1002325cu) {
            uint32_t len=0,max=0,data=0;
            if(!descriptor_info(c,c->r[1],&len,&max,&data) || len>24u || max<len || !guest_ptr(c,c->r[0],60u)) {
                c->r[0]=(uint32_t)-6;
                fprintf(stderr,"  EXPERIMENT GDI151 rejected descriptor/spec bounds\n");
                return;
            }
            uint8_t *dst=guest_ptr(c,c->r[0],60u);
            uint8_t *src=guest_ptr(c,data,len*2u);
            if(!src){c->r[0]=(uint32_t)-6;return;}
            memset(dst,0,60u);
            /* Candidate 72-byte TFontSpec: 56-byte iTypeface, 4-byte iHeight
               at +0x38, and 12-byte iFontStyle at +0x3C. The typeface name
               is modelled as inline TBufC<24> (type 4); the trailing style
               is deliberately left for the separate GDI108 call. */
            wr32(c,c->r[0],0x40000000u|len); /* TBufC<24>: inline const */
            wr32(c,c->r[0]+4u,24u);          /* maximum UTF-16 characters */
            if(len)memcpy(dst+8u,src,len*2u);
            wr32(c,c->r[0]+56u,c->r[2]);     /* iHeight in twips */
            fprintf(stderr,"  EXPERIMENT GDI151 TFontSpec prefix: name-length=%u height=%u twips prefix=60 total=72; TBufC<24> candidate\n",len,c->r[2]);
            trace_guest_bytes(c,"GDI151 experimental TFontSpec prefix",c->r[0],60u);
            if(getenv("SHADOWKEY_WATCH_TFONTSPEC") && ngage_runtime_watch_range) ngage_runtime_watch_range(c->r[0],60u);
            c->r[0]=0;
            return;
        }
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1373u) {
        static const uint32_t sites[]={0x10022c60u,0x10022e98u,0x100230c8u,0x10023314u,0x10023728u};
        for(unsigned i=0;i<sizeof(sites)/sizeof(sites[0]);i++) if(c->r[14]==sites[i]) {
            uint32_t out=c->r[0];
            if(out<0x10000000u || (uint64_t)out+8u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
            wr32(c,out,c->r[1]); wr32(c,out+4u,c->r[2]);
            fprintf(stderr,"  HLE EUSER1373 TPoint set site=%08x point=%08x (%d,%d)\n",c->r[14],out,(int32_t)c->r[1],(int32_t)c->r[2]);
            return;
        }
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==530u) {
        static const uint32_t sites[]={0x10022c68u,0x10022ea0u,0x100230d0u,0x1002331cu};
        for(unsigned i=0;i<sizeof(sites)/sizeof(sites[0]);i++) if(c->r[14]==sites[i]) {
            uint32_t out=c->r[0];
            if(out<0x10000000u || (uint64_t)out+8u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
            c->r[0]=rd32(c,out+4u);
            fprintf(stderr,"  HLE EUSER530 TPoint::Y site=%08x point=%08x -> %d\n",sites[i],out,(int32_t)c->r[0]);
            return;
        }
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1282u){
        /* Observed three-argument byte-copy ABI (20/32/256-byte sites); export name unverified. */
        uint32_t dst=c->r[0],src=c->r[1],n=c->r[2];
        if(dst<0x10000000u || src<0x10000000u || n>0x00400000u ||
           (uint64_t)dst+n>0x10400000ull || (uint64_t)src+n>0x10400000ull){c->r[0]=(uint32_t)-6;fprintf(stderr,"  HLE EUSER1282 Mem::Copy rejected dst=%08x src=%08x size=%u\n",dst,src,n);return;}
        uint8_t *d=guest_ptr(c,dst,n),*q=guest_ptr(c,src,n);
        if(n && (!d||!q)){c->r[0]=(uint32_t)-6;return;}
        if(n)memmove(d,q,n);
        c->r[0]=dst;
        fprintf(stderr,"  HLE EUSER1282 Mem::Copy dst=%08x src=%08x size=%u\n",dst,src,n);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==248u){
        /* The recovered callers pass a writable TBuf16 in r0 and a raw
           zero-terminated UTF-16 pointer in r1 (not a descriptor pointer).
           This matches TDes16::Copy(const TUint16*) call shape. */
        uint32_t dst=c->r[0], src=c->r[1];
        uint32_t hdr=rd32(c,dst), type=hdr>>28, max=rd32(c,dst+4u);
        if(type!=3u || dst<0x10000000u || dst>=0x12000000u ||
           src<0x10000000u || src>=0x12000000u || max>0x10000u ||
           (uint64_t)dst+8u+(uint64_t)max*2u>0x12000000ull ||
           (uint64_t)src+((uint64_t)max+1u)*2u>0x12000000ull){
            c->r[0]=(uint32_t)-6;
            fprintf(stderr,"  HLE EUSER248 rejected TBuf16=%08x source=%08x type=%u max=%u\n",dst,src,type,max);
            return;
        }
        uint32_t n=0;
        for(;n<max;n++){
            uint8_t *q=guest_ptr(c,src+n*2u,2u);
            if(!q){c->r[0]=(uint32_t)-6;return;}
            uint16_t ch=(uint16_t)q[0]|((uint16_t)q[1]<<8);
            if(!ch) break;
            uint8_t *d=guest_ptr(c,dst+8u+n*2u,2u);
            if(!d){c->r[0]=(uint32_t)-6;return;}
            d[0]=q[0]; d[1]=q[1];
        }
        if(n==max){
            uint8_t *q=guest_ptr(c,src+n*2u,2u);
            if(q && (q[0]||q[1])){c->r[0]=(uint32_t)-9;fprintf(stderr,"  HLE EUSER248 overflow max=%u\n",max);return;}
        }
        wr32(c,dst,(hdr&0xf0000000u)|n);
        c->r[0]=dst;
        char preview[128]; uint32_t pn=n<sizeof(preview)-1u?n:(uint32_t)sizeof(preview)-1u;
        for(uint32_t i=0;i<pn;i++){uint8_t*q=guest_ptr(c,dst+8u+i*2u,2u);uint16_t ch=q?(uint16_t)(q[0]|((uint16_t)q[1]<<8)):0;preview[i]=(ch>=32u&&ch<127u)?(char)ch:'?';} preview[pn]=0;
        fprintf(stderr,"  HLE EUSER248 TDes16::Copy(TUint16*) dst=%08x src=%08x length=%u/max=%u text=\"%s\"\n",dst,src,n,max,preview);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==711u){
        /* Four call sites establish this as a two-coordinate constructor:
           r0=this, r1=x, r2=y. r3 and [sp] are live leftovers from callers,
           not arguments. The resulting 8-byte TPoint is passed to the
           CGraphicsContext::DrawText point overload at vslot +0xA8. */
        uint32_t out=c->r[0];
        int32_t x=(int32_t)c->r[1], y=(int32_t)c->r[2];
        if(out<0x10000000u || (uint64_t)out+8u>0x12000000ull){
            c->r[0]=(uint32_t)-6;
            fprintf(stderr,"  HLE EUSER711 rejected TPoint=%08x\n",out);
            return;
        }
        wr32(c,out,(uint32_t)x); wr32(c,out+4u,(uint32_t)y);
        fprintf(stderr,"  HLE EUSER711 TPoint init point=%08x (%d,%d)\n",out,x,y);
        return;
    }
    if(!strcmp(dll,"HAL[100039e8].DLL") && ordinal==1u){
        /* HAL::Get(TAttribute, TInt&). The recovered call requests attribute
           16 (HALData::EMemoryRAMFree) and passes a writable TInt* in r1.
           This host diagnostic models the platform value explicitly; it is
           configurable so tests can cover both sides of the game's threshold. */
        uint32_t attr=c->r[0], out=c->r[1];
        if(attr!=16u || out<0x10000000u || (uint64_t)out+4u>0x10400000ull){
            c->r[0]=(uint32_t)-6;
            fprintf(stderr,"  HLE HAL::Get rejected attr=%u out=%08x\n",attr,out);
            return;
        }
        const char *env=getenv("SHADOWKEY_HLE_FREE_RAM_BYTES");
        uint32_t free_ram=32u*1024u*1024u;
        if(env && *env){char *end=0;unsigned long v=strtoul(env,&end,0);if(end && !*end && v<=0xfffffffful)free_ram=(uint32_t)v;}
        wr32(c,out,free_ram); c->r[0]=0;
        fprintf(stderr,"  HLE HAL::Get EMemoryRAMFree=%u bytes (diagnostic model) -> %08x\n",free_ram,out);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1431u){
        /* Call-site contract: r0 is a writable stack buffer, r1 is its byte
           length (256 and 50 at the observed sites). The caller consumes the
           cleared buffer as a descriptor/string workspace. This is the
           Mem::FillZ-shaped two-argument operation; reject invalid ranges. */
        uint32_t dst=c->r[0], n=c->r[1];
        if(dst<0x10000000u || n>0x100000u ||
           (uint64_t)dst+n>0x12000000ull){
            fprintf(stderr,"  HLE EUSER1431 rejected dst=%08x length=%u\n",dst,n);
            c->r[0]=(uint32_t)-6; return;
        }
        uint8_t *p=guest_ptr(c,dst,n);
        if(n && !p){c->r[0]=(uint32_t)-6;return;}
        if(n) memset(p,0,n);
        c->r[0]=dst;
        fprintf(stderr,"  HLE EUSER1431 zero-fill dst=%08x length=%u\n",dst,n);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1u){
        /* Symbian 6.1 EUSER ordinal 1 is the C memset export:
           r0=destination, r1=byte value, r2=byte count; return destination. */
        uint32_t dst=c->r[0], n=c->r[2];
        if(dst<0x10000000u || n>0x00400000u || (uint64_t)dst+n>0x10400000ull){
            fprintf(stderr,"  HLE memset rejected range dst=%08x length=%u\n",dst,n);
            c->r[0]=(uint32_t)-6; return;
        }
        uint8_t *p=guest_ptr(c,dst,n);
        if(n && !p){c->r[0]=(uint32_t)-6;return;}
        if(n && dst<=0x10125c44u && (uint64_t)dst+n>0x10125c44u) fprintf(stderr,"WATCH source+14a3c bulk memset dst=%08x length=%u value=%02x\n",dst,n,(uint8_t)c->r[1]);
        if(n) memset(p,(uint8_t)c->r[1],n);
        c->r[0]=dst;
        fprintf(stderr,"  HLE memset dst=%08x value=%02x length=%u\n",dst,(uint8_t)c->r[1],n);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1366u){
        /* TPtr8-style descriptor constructor: (descriptor, data pointer, max length). */
        uint32_t d=c->r[0], data=c->r[1], max=c->r[2];
        
        if(d>=0x10000000u && d<0x12000000u && data>=0x10000000u && data<0x12000000u && max<0x200000u){
            uint8_t *p=c->mem+(d-0x10000000u);
            uint32_t h=0x20000000u; p[0]=h;p[1]=h>>8;p[2]=h>>16;p[3]=h>>24;
            p[4]=data;p[5]=data>>8;p[6]=data>>16;p[7]=data>>24;
            p[8]=max;p[9]=max>>8;p[10]=max>>16;p[11]=max>>24;
            c->r[0]=d; fprintf(stderr,"  HLE TPtr8 ctor desc=%08x data=%08x max=%u\n",d,data,max); return;
        }
        c->r[0]=(uint32_t)-6; return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && (ordinal==162u || ordinal==136u || ordinal==15u)){
        fprintf(stderr,"  EFSRV probe ord=%u args:",ordinal);
        for(unsigned ai=0;ai<4;ai++){
            uint32_t a=c->r[ai]; fprintf(stderr," r%u=%08x",ai,a);
            if(a>=0x10000000u && a<0x12000000u){uint8_t *q=c->mem+(a-0x10000000u);fprintf(stderr,"[%08x %08x %08x %08x]",(uint32_t)q[0]|((uint32_t)q[1]<<8)|((uint32_t)q[2]<<16)|((uint32_t)q[3]<<24),(uint32_t)q[4]|((uint32_t)q[5]<<8)|((uint32_t)q[6]<<16)|((uint32_t)q[7]<<24),(uint32_t)q[8]|((uint32_t)q[9]<<8)|((uint32_t)q[10]<<16)|((uint32_t)q[11]<<24),(uint32_t)q[12]|((uint32_t)q[13]<<8)|((uint32_t)q[14]<<16)|((uint32_t)q[15]<<24));}
        }
        fprintf(stderr,"\n");
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==121u){
        uint32_t a=c->r[2];
        char symbian_path[260]={0}, host_path[1024]={0};
        uint32_t h=0,max=0,n=0;
        if(a>=0x10000000u && a<0x12000000u){
            uint8_t *p=c->mem+(a-0x10000000u);
            h=(uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
            n=h&0x0fffffffu; max=(uint32_t)p[4]|((uint32_t)p[5]<<8)|((uint32_t)p[6]<<16)|((uint32_t)p[7]<<24);
            if(n>250)n=250;
            uint32_t clean=0;
            for(;clean<n;clean++){uint16_t ch=(uint16_t)p[8+clean*2]|((uint16_t)p[9+clean*2]<<8);if(ch<32u||ch>126u)break;}
            n=clean;
            for(uint32_t i=0;i<n;i++){uint16_t ch=(uint16_t)p[8+i*2]|((uint16_t)p[9+i*2]<<8);symbian_path[i]=(char)ch;}
            symbian_path[n]=0;
        }
        const char *root=getenv("SHADOWKEY_ASSET_ROOT");
        const char *tail=strrchr(symbian_path,'\\');
        if(!tail)tail=symbian_path;else tail++;
        if(root && *root) snprintf(host_path,sizeof(host_path),"%s/%s",root,tail);
        struct stat st; int exists=(host_path[0] && stat(host_path,&st)==0 && S_ISREG(st.st_mode));
        vfile_t *vf=vfile_for(c->r[0],1);
        if(vf && vf->fp){fclose(vf->fp);vf->fp=NULL;}
        if(exists && vf){vf->fp=fopen(host_path,"rb");snprintf(vf->path,sizeof(vf->path),"%s",host_path);}
        int ok=(exists && vf && vf->fp);
        fprintf(stderr,"  VFS RFile::Open path='%s' -> '%s' %s size=%lld mode=%08x obj=%08x\n",symbian_path,host_path,ok?"OPENED":"MISSING/FAILED",ok?(long long)st.st_size:0LL,c->r[3],c->r[0]);
        c->r[0]=ok?0u:(uint32_t)-1; return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==185u){
        /* Call-site ABI identifies RFile::Size(TInt&): r0=file handle,
           r1=output TInt*. SDK docs define the output as file size; the
           FP1 ordinal/name pairing is still awaiting an export-table check. */
        vfile_t *vf=vfile_for(c->r[0],0);
        uint32_t out=c->r[1];
        if(!vf || !vf->fp || out<0x10000000u || out>=0x12000000u){
            c->r[0]=(uint32_t)-1;
            fprintf(stderr,"  VFS RFile::Size failed handle=%08x out=%08x\n",c->r[0],out);
            return;
        }
        long current=ftell(vf->fp);
        if(current<0 || fseek(vf->fp,0,SEEK_END)!=0){
            c->r[0]=(uint32_t)-6; return;
        }
        long size=ftell(vf->fp);
        int restore=(current<0)?-1:fseek(vf->fp,current,SEEK_SET);
        if(size<0 || restore!=0 || size>0x7fffffffL){c->r[0]=(uint32_t)-6;return;}
        wr32(c,out,(uint32_t)size);
        c->r[0]=0;
        fprintf(stderr,"  VFS RFile::Size wrote %ld to %08x for %s\n",size,out,vf->path);
        return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==162u){
        vfile_t *vf=vfile_for(c->r[0],0);
        if(vf && vf->fp){ long off=0; if(c->r[2]>=0x10000000u && c->r[2]<0x12000000u) off=(long)ngage_r32(c,c->r[2]); int whence=(c->r[1]==1u)?SEEK_SET:(c->r[1]==2u)?SEEK_CUR:SEEK_END; int rc=fseek(vf->fp,off,whence); long now=ftell(vf->fp); if(c->r[2]>=0x10000000u && c->r[2]<0x12000000u && now>=0){uint32_t a=c->r[2];uint8_t*p=c->mem+(a-0x10000000u);uint32_t v=(uint32_t)now;p[0]=v;p[1]=v>>8;p[2]=v>>16;p[3]=v>>24;} c->r[0]=rc?((uint32_t)-6):0u; }
        else c->r[0]=(uint32_t)-1;
        fprintf(stderr,"  VFS EFSRV ordinal 162 seek mode=%u offset=%ld result=%d\n",c->r[1],(long)(c->r[2]>=0x10000000u&&c->r[2]<0x12000000u?ngage_r32(c,c->r[2]):0),(int32_t)c->r[0]); return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==136u){
        vfile_t *vf=vfile_for(c->r[0],0); uint32_t desc=c->r[1],len=c->r[2],data=0,max=0,cur=0; uint8_t *dp=NULL;
        uint32_t dtype=0;
        if(desc>=0x10000000u && desc<0x12000000u){uint8_t*p=c->mem+(desc-0x10000000u);uint32_t h=(uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);dtype=h>>28;cur=h&0x0fffffffu;data=(uint32_t)p[4]|((uint32_t)p[5]<<8)|((uint32_t)p[6]<<16)|((uint32_t)p[7]<<24);max=(uint32_t)p[8]|((uint32_t)p[9]<<8)|((uint32_t)p[10]<<16)|((uint32_t)p[11]<<24);if(dtype==2u && data>=0x10000000u && data<0x12000000u && max<0x200000u)dp=c->mem+(data-0x10000000u);}
        /* A zero-length request on the inline TBuf path is a metadata call, not a data read. */
        if(vf && vf->fp && len==0u){c->r[0]=0;fprintf(stderr,"  VFS EFSRV ordinal 136 zero-length metadata call desc=%08x type=%u\n",desc,dtype);return;}
        if(vf && vf->fp && dp){if(len>max)len=max;size_t got=fread(dp,1,len,vf->fp);uint32_t h=0x20000000u|(uint32_t)got;uint8_t*p=c->mem+(desc-0x10000000u);p[0]=h;p[1]=h>>8;p[2]=h>>16;p[3]=h>>24;c->r[0]=0;fprintf(stderr,"  VFS EFSRV ordinal 136 read %zu/%u bytes from %s into data=%08x descriptor=%08x max=%u\n",got,len,vf->path,data,desc,max);}
        else {c->r[0]=(uint32_t)-1;fprintf(stderr,"  VFS EFSRV ordinal 136 read failed file=%08x desc=%08x type/ptr/max invalid len=%u\n",c->r[0],desc,len);}
        return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==15u){
        vfile_t *vf=vfile_for(c->r[0],0);
        if(vf && vf->fp){fprintf(stderr,"  VFS EFSRV ordinal 15 close %s (preserve r0=%08x; Close is void)\n",vf->path,c->r[0]);fclose(vf->fp);vf->fp=NULL;vf->object=0;}
        return;
    }
    if (!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==89u || ordinal==1359u || ordinal==35u || ordinal==90u)) { uint32_t a=c->r[0]; if(a>=0x10000000u && a<0x12000000u){uint8_t *p=c->mem+(a-0x10000000u); fprintf(stderr,"  MEM r0: %08x %08x %08x %08x %08x %08x\n",*(uint32_t*)(p),*(uint32_t*)(p+4),*(uint32_t*)(p+8),*(uint32_t*)(p+12),*(uint32_t*)(p+16),*(uint32_t*)(p+20));}}
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && (ordinal==315u || ordinal==317u)){
        /* Call-site evidence: these are UTF-16 C-string operations. Ordinal
           317 initializes/replaces the destination; ordinal 315 appends to
           an existing UTF-16 string. The exact export names are not yet
           checked against the FP1 ESTLIB export table. */
        uint32_t dst=c->r[0],src=c->r[1],dlen=0,slen=0;
        if(dst<0x10000000u || dst>=0x12000000u || src<0x10000000u || src>=0x12000000u){c->r[0]=(uint32_t)-6;return;}
        if(ordinal==315u){
            for(;dlen<0x10000u;dlen++){uint8_t*q=guest_ptr(c,dst+dlen*2u,2u);if(!q){c->r[0]=(uint32_t)-6;return;}if(!q[0]&&!q[1])break;}
            if(dlen==0x10000u){c->r[0]=(uint32_t)-6;return;}
        }
        for(;slen<0x10000u;slen++){uint8_t*q=guest_ptr(c,src+slen*2u,2u);if(!q){c->r[0]=(uint32_t)-6;return;}if(!q[0]&&!q[1])break;}
        if(slen==0x10000u || (uint64_t)dst+(uint64_t)(dlen+slen+1u)*2u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
        uint32_t start=(ordinal==315u)?dlen:0u;
        for(uint32_t i=0;i<=slen;i++){uint8_t*q=guest_ptr(c,src+i*2u,2u),*d=guest_ptr(c,dst+(start+i)*2u,2u);if(!q||!d){c->r[0]=(uint32_t)-6;return;}d[0]=q[0];d[1]=q[1];}
        c->r[0]=dst;
        fprintf(stderr,"  HLE ESTLIB ordinal %u UTF16 %s dst=%08x src=%08x old=%u appended=%u\n",ordinal,ordinal==315u?"append":"copy",dst,src,dlen,slen);
        return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==58u){uint32_t dst=c->r[0],src=c->r[1];char tmp[4096];guest_cstr(c,src,tmp,sizeof(tmp));guest_put_cstr(c,dst,tmp);c->r[0]=dst;return;}
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==82u){uint32_t dst=c->r[0],fmtp=c->r[1];char fmt[2048],out[4096];guest_cstr(c,fmtp,fmt,sizeof(fmt));size_t oi=0;unsigned ai=2;for(size_t i=0;fmt[i]&&oi+2<sizeof(out);i++){if(fmt[i]!='%'){out[oi++]=fmt[i];continue;}char spec=fmt[++i];if(!spec)break;if(spec=='%'){out[oi++]='%';continue;}uint32_t arg=0;if(ai<=12)arg=c->r[ai++];else{arg=ngage_r32(c,c->r[13]+(ai-13)*4u);ai++;}char t[512];t[0]=0;if(spec=='s')guest_cstr(c,arg,t,sizeof(t));else if(spec=='d'||spec=='i')snprintf(t,sizeof(t),"%d",(int32_t)arg);else if(spec=='u')snprintf(t,sizeof(t),"%u",arg);else if(spec=='x'||spec=='X')snprintf(t,sizeof(t),spec=='x'?"%x":"%X",arg);else if(spec=='c'){t[0]=(char)arg;t[1]=0;}else{t[0]='%';t[1]=spec;t[2]=0;}size_t n=strlen(t);if(n>sizeof(out)-oi-2)n=sizeof(out)-oi-2;memcpy(out+oi,t,n);oi+=n;}out[oi]=0;guest_put_cstr(c,dst,out);c->r[0]=(uint32_t)oi;return;}
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && (ordinal==51u || ordinal==64u || ordinal==180u)){
        /* String-helper exports used with a live destination buffer. Exact
           EKA1 ordinal names are not available yet; preserve the non-null
           destination result so the caller can take its success path. */
        return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==9u){
        uint32_t a=c->r[0], n=c->r[2]; uint8_t *p=guest_ptr(c,a,n); if(p && n<0x100000u)memset(p,(uint8_t)c->r[1],n); c->r[0]=a; return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==90u){
        uint32_t dst=c->r[0],src=c->r[1],dl=0,dm=0,dd=0,sl=0,sm=0,sd=0;
        if(src>=0x10000000u&&src<0x12000000u){fprintf(stderr,"  EUSER90 src=%08x words=%08x %08x %08x %08x %08x %08x\n",src,rd32(c,src),rd32(c,src+4u),rd32(c,src+8u),rd32(c,src+12u),rd32(c,src+16u),rd32(c,src+20u));}
        if(!descriptor_info(c,dst,&dl,&dm,&dd)){c->r[0]=(uint32_t)-6;return;}
        if(descriptor_info(c,src,&sl,&sm,&sd)){sl=pathish_utf16_len(c,sd,sl);uint32_t n=sl<dm?sl:dm;uint8_t*sp=guest_ptr(c,sd,n*2u),*dp=guest_ptr(c,dd,n*2u);if(n&&sp&&dp)memmove(dp,sp,n*2u);wr32(c,dst,(rd32(c,dst)&0xf0000000u)|n);c->r[0]=dst;return;}
        /* The source may point directly at the inline data of a TBuf (this-8). */
        uint32_t sl2=0,sm2=0,sd2=0;
        if(src>=0x10000008u && descriptor_info(c,src-8u,&sl2,&sm2,&sd2) && sd2==src){sl2=pathish_utf16_len(c,sd2,sl2);uint32_t n=sl2<dm?sl2:dm;uint8_t*q=guest_ptr(c,sd2,n*2u),*d=guest_ptr(c,dd,n*2u);if(n&&q&&d)memmove(d,q,n*2u);wr32(c,dst,(rd32(c,dst)&0xf0000000u)|n);c->r[0]=dst;return;}
        uint32_t n=0;while(n<dm){uint8_t*q=guest_ptr(c,src+n*2u,2u);if(!q||(!q[0]&&!q[1]))break;uint16_t ch=(uint16_t)q[0]|((uint16_t)q[1]<<8);if(ch<32u||ch>126u)break;uint8_t*d=guest_ptr(c,dd+n*2u,2u);if(!d)break;d[0]=q[0];d[1]=q[1];n++;}wr32(c,dst,(rd32(c,dst)&0xf0000000u)|n);c->r[0]=dst;return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==99u){ c->r[0]=c->r[0]; return; }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==172u){ return; }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==342u){
        /* Call pattern walks a UTF-16 string in two-byte steps, then uses this
           result as its length field: treat this export as a wide-string length. */
        uint32_t a=c->r[0], n=0;
        while(n<0x10000u){uint8_t *p=guest_ptr(c,a+n*2u,2u);if(!p)break;if(p[0]==0 && p[1]==0)break;n++;}
        c->r[0]=n;return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==2u){
        /* Observed three-argument byte copy used by SIMKIN string construction. */
        uint32_t dst=c->r[0], src=c->r[1], n=c->r[2];
        if(n>0x100000u || dst<0x10000000u || src<0x10000000u ||
           (uint64_t)dst+n>0x12000000ull || (uint64_t)src+n>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
        if(n && dst<=0x10125c44u && (uint64_t)dst+n>0x10125c44u) fprintf(stderr,"WATCH source+14a3c bulk memcpy dst=%08x src=%08x length=%u\n",dst,src,n);
        memmove(c->mem+(dst-0x10000000u),c->mem+(src-0x10000000u),n);
        c->r[0]=dst; return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==828u || ordinal==1359u || ordinal==1262u || ordinal==856u || ordinal==857u)){
        /* These call sites pass a live object in r0 and continue to use that
           object after the call. Until their exact EUSER bodies are mapped,
           preserve the receiver rather than fabricating a null pointer. */
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1283u){
        /* Observed TBuf-style constructor: r0 points at a stack descriptor,
           r1 is its maximum character count. Symbian descriptor header is
           length at +0, maximum length at +4, UTF-16 data at +8. */
        uint8_t *p=c->mem+(c->r[0]-0x10000000u);
        uint32_t max=c->r[1];
        p[0]=0; p[1]=0; p[2]=0; p[3]=0x30;
        p[4]=(uint8_t)max; p[5]=(uint8_t)(max>>8); p[6]=(uint8_t)(max>>16); p[7]=(uint8_t)(max>>24);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==89u){
        /* Append one character to a TBuf/TDes using the descriptor header. */
        uint8_t *p=c->mem+(c->r[0]-0x10000000u);
        uint32_t hdr=(uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24); uint32_t len=hdr&0x0fffffffu;
        uint32_t max=(uint32_t)p[4]|((uint32_t)p[5]<<8)|((uint32_t)p[6]<<16)|((uint32_t)p[7]<<24);
        if(len<max){ uint32_t at=8u+len*2u; p[at]=(uint8_t)c->r[1]; p[at+1]=(uint8_t)(c->r[1]>>8); len++; uint32_t nh=(hdr&0xf0000000u)|len; p[0]=nh; p[1]=nh>>8; p[2]=nh>>16; p[3]=nh>>24; }
        else { c->r[0]=(uint32_t)-9; }
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==1582u || ordinal==3u || ordinal==1505u || ordinal==35u || ordinal==1507u)){
        uint32_t size=c->r[0];
        uint32_t p=shadowkey_heap_alloc(c,size);
        c->r[0]=p;
        if(!p) fprintf(stderr,"  HLE Alloc FAILED size=%u primary_next=%08x primary_end=%08x secondary_next=%08x\n",size,heap_next,heap_end,heap2_next);
        else fprintf(stderr,"  HLE Alloc size=%u -> %08x\n",size,p);
        return;
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && ordinal==151u) {
        /* A previous generic experiment encoded a conflicting 60-byte
           TBufC<20> layout. Keep it quarantined behind a distinct opt-in;
           the active step32 experiment is the call-site-gated 72-byte
           candidate above. Unknown GDI151 sites must remain unresolved. */
        const char *probe=getenv("SHADOWKEY_EXPERIMENTAL_GDI151_LEGACY_LAYOUT");
        if(probe && *probe && strcmp(probe,"0")) {
            uint32_t dst=c->r[0], src=c->r[1], len=0, max=0, data=0;
            if(!descriptor_info(c,src,&len,&max,&data) || len>20u || !guest_ptr(c,dst,60u)) {
                fprintf(stderr,"  EXPERIMENT GDI151 rejected descriptor src=%08x len=%u max=%u\n",src,len,max);
                c->r[0]=(uint32_t)-6; return;
            }
            uint8_t *out=guest_ptr(c,dst,60u);
            memset(out,0,60u);
            /* TFontSpec = TTypeface(TBufC<20>) + TInt iHeight + TFontStyle(12 bytes).
               TBufC is immutable inline descriptor type 0: length at +0, data at +4. */
            wr32(c,dst,len);
            uint8_t *q=guest_ptr(c,data,len*2u);
            if(len && !q){c->r[0]=(uint32_t)-6;return;}
            if(len) memcpy(out+4u,q,len*2u);
            wr32(c,dst+44u,c->r[2]);
            /* Default TFontStyle: normal weight, normal posture, normal print position. */
            wr32(c,dst+48u,0u); wr32(c,dst+52u,0u); wr32(c,dst+56u,0u);
            fprintf(stderr,"  EXPERIMENT GDI151 TFontSpec: name length=%u height=%u twips style=(0,0,0)\n",len,c->r[2]);
            trace_guest_bytes(c,"GDI151 experimental TFontSpec",dst,60u);
            c->r[0]=dst; return;
        }
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && (ordinal==108u || ordinal==151u)) {
        /* Never let an unobserved font-construction path fall through to the
           generic zero-return shim: that would turn an unknown ABI into a
           false successful font. The one measured GDI151/GDI108 pair has
           already returned above; all other sites stop the diagnostic run. */
        fprintf(stderr,"HALT unresolved GDI import dll=%s ordinal=%u lr=%08x r0=%08x r1=%08x r2=%08x r3=%08x\n",
                dll,ordinal,c->r[14],c->r[0],c->r[1],c->r[2],c->r[3]);
        exit(95);
    }
    if(shadowkey_bitgdi_import(c,dll,ordinal)) return;
    if(!strcmp(dll,"FBSCLI[10003a15].DLL") && shadowkey_fbs_import(c->r,c->mem,ordinal)) return;
    if(!strcmp(dll,"CONE[10003a41].DLL") && ordinal==3u){
        /* Observed at 0x10021480: the caller uses the object pointer after this call. */
        return;
    }
    if(!strcmp(dll,"EIKCORE[10004892].DLL") && (ordinal==222u || ordinal==219u || ordinal==224u)){
        /* These call sites use the import as a void object/base initializer. */
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==828u || ordinal==858u)){
        /* Call-site bootstrap no-ops: their broader Symbian semantics are not resolved yet. */
        return;
    }
    if(!strcmp(dll,"CONE[10003a41].DLL") && ordinal==55u){
        c->r[0]=shadowkey_cone_drawable_window(c); return;
    }
    if(!strcmp(dll,"CONE[10003a41].DLL") && ordinal==226u){
        c->r[0]=shadowkey_cone_system_gc(c); return;
    }
    fprintf(stderr,"UNIMPLEMENTED Shadowkey import: %s ordinal %u (r0=%08x r1=%08x r2=%08x r3=%08x)\n",
            dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3]);
    c->r[0]=0;
}
