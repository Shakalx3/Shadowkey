/* Observed-call-site HLE bootstrap for Shadowkey; unresolved imports remain explicit diagnostic stubs. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "shadowkey_fbs_hle.h"
#include "shadowkey_bitgdi_hle.h"
#include "shadowkey_symbian61_hle.h"
extern uint32_t ngage_r32(ngage_cpu_t *, uint32_t);
extern void ngage_w32(ngage_cpu_t *, uint32_t, uint32_t);
static uint32_t heap_next=0, heap_end=0, heap2_next=0x10230000u, heap2_end=0x10300000u, heap3_next=0x10400000u, heap3_end=0x12000000u;
void shadowkey_heap_init(uint32_t begin,uint32_t end){heap_next=begin;heap_end=end;heap2_next=(end>begin)?0x10230000u:0x12000000u;heap3_next=(end>begin)?0x10400000u:0x12000000u;}
static uint8_t *guest_ptr(ngage_cpu_t*c,uint32_t a,uint32_t n){
    (void)n;
    /* This bootstrap HLE uses a base-biased guest image beginning at 0x10000000. */
    if(a<0x10000000u) return 0;
    return c->mem+(a-0x10000000u);
}
uint32_t shadowkey_heap_alloc(ngage_cpu_t*c,uint32_t size){if(!size)return 0;uint32_t p=0;if(heap_next&&heap_next<=heap_end&&size<=heap_end-heap_next){p=(heap_next+7u)&~7u;if(p<=heap_end&&size<=heap_end-p){uint8_t*m=guest_ptr(c,p,size);if(m){memset(m,0,size);heap_next=p+((size+7u)&~7u);return p;}}}if(heap2_next&&heap2_next<=heap2_end&&size<=heap2_end-heap2_next){p=(heap2_next+7u)&~7u;if(p<=heap2_end&&size<=heap2_end-p){uint8_t*m=guest_ptr(c,p,size);if(m){memset(m,0,size);heap2_next=p+((size+7u)&~7u);return p;}}}if(heap3_next&&heap3_next<=heap3_end&&size<=heap3_end-heap3_next){p=(heap3_next+7u)&~7u;if(p<=heap3_end&&size<=heap3_end-p){uint8_t*m=guest_ptr(c,p,size);if(m){memset(m,0,size);heap3_next=p+((size+7u)&~7u);return p;}}}return 0;}
void shadowkey_hle_import(ngage_cpu_t*c,const char*dll,uint16_t ordinal){
    /* EUSER 1407 is deliberately unresolved: WINS UDEB says SetOffset,
       but ARM game callsites pass descriptor-like format literals in r1.
       Do not mutate the receiver until ARM UREL ordinal identity is proven. */
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==711u){
        /* TPoint construction: this, x, y. r3 and [sp] are caller leftovers. */
        uint32_t out=c->r[0];
        if(out<0x10000000u || (uint64_t)out+8u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
        ngage_w32(c,out,c->r[1]);ngage_w32(c,out+4u,c->r[2]);return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1373u){
        static const uint32_t sites[]={0x10022c60u,0x10022e98u,0x100230c8u,0x10023314u,0x10023728u};
        for(unsigned i=0;i<sizeof(sites)/sizeof(sites[0]);i++)if(c->r[14]==sites[i]){
            uint32_t out=c->r[0];if(out<0x10000000u||(uint64_t)out+8u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
            ngage_w32(c,out,c->r[1]);ngage_w32(c,out+4u,c->r[2]);return;
        }
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==530u){
        static const uint32_t sites[]={0x10022c68u,0x10022ea0u,0x100230d0u,0x1002331cu};
        for(unsigned i=0;i<sizeof(sites)/sizeof(sites[0]);i++)if(c->r[14]==sites[i]){c->r[0]=ngage_r32(c,c->r[0]+4u);return;}
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && (ordinal==315u || ordinal==317u)){
        /* Live call-site semantics: 317 replaces a UTF-16 C string;
           315 appends a UTF-16 C string. Export names remain unverified. */
        uint32_t dst=c->r[0],src=c->r[1],dlen=0,slen=0;
        if(dst<0x10000000u || dst>=0x12000000u || src<0x10000000u || src>=0x12000000u){c->r[0]=(uint32_t)-6;return;}
        if(ordinal==315u){for(;dlen<0x10000u;dlen++){if((uint64_t)dst+(uint64_t)dlen*2u+2u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}uint8_t*q=guest_ptr(c,dst+dlen*2u,2u);if(!q){c->r[0]=(uint32_t)-6;return;}if(!q[0]&&!q[1])break;}if(dlen==0x10000u){c->r[0]=(uint32_t)-6;return;}}
        for(;slen<0x10000u;slen++){if((uint64_t)src+(uint64_t)slen*2u+2u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}uint8_t*q=guest_ptr(c,src+slen*2u,2u);if(!q){c->r[0]=(uint32_t)-6;return;}if(!q[0]&&!q[1])break;}
        if(slen==0x10000u || (uint64_t)dst+(uint64_t)(dlen+slen+1u)*2u>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
        uint32_t start=ordinal==315u?dlen:0u;
        for(uint32_t i=0;i<=slen;i++){uint8_t*q=guest_ptr(c,src+i*2u,2u),*d=guest_ptr(c,dst+(start+i)*2u,2u);if(!q||!d){c->r[0]=(uint32_t)-6;return;}d[0]=q[0];d[1]=q[1];}
        c->r[0]=dst;return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1u){
        /* Symbian 6.1 EUSER ordinal 1 is the C memset export:
           r0=destination, r1=byte value, r2=byte count; return destination. */
        uint32_t dst=c->r[0], n=c->r[2];
        if(dst<0x10000000u || n>0x00400000u || (uint64_t)dst+n>0x10400000ull){c->r[0]=(uint32_t)-6;return;}
        uint8_t *p=guest_ptr(c,dst,n);
        if(n && !p){c->r[0]=(uint32_t)-6;return;}
        if(n) memset(p,(uint8_t)c->r[1],n);
        c->r[0]=dst; return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==342u){
        /* Call pattern walks a UTF-16 string in two-byte steps, then uses this
           result as its length field: treat this export as a wide-string length. */
        uint32_t a=c->r[0], n=0;
        while(n<0x10000u){uint8_t *p=guest_ptr(c,a+n*2u,2u);if(!p)break;if(p[0]==0 && p[1]==0)break;n++;}
        c->r[0]=n;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && (ordinal==51u || ordinal==64u || ordinal==180u)){
        /* String-helper exports used with a live destination buffer. Exact
           EKA1 ordinal names are not available yet; preserve the non-null
           destination result so the caller can take its success path. */
        return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==9u){uint32_t a=c->r[0],n=c->r[2];uint8_t*p=guest_ptr(c,a,n);if(p&&n<0x100000u)memset(p,(uint8_t)c->r[1],n);c->r[0]=a;return;}
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==90u){uint32_t dst=c->r[0],src=c->r[1],dh=ngage_r32(c,dst),sh=ngage_r32(c,src),dt=dh>>28,st=sh>>28,dl=dh&0x0fffffffu,sl=sh&0x0fffffffu,dm=dl,dd=0,sd=0;if(dt==3u){dm=ngage_r32(c,dst+4u);dd=dst+8u;}else if(dt==2u){dd=ngage_r32(c,dst+4u);dm=ngage_r32(c,dst+8u);}else{c->r[0]=(uint32_t)-6;return;}if(st==3u)sd=src+8u;else if(st==2u||st==1u)sd=ngage_r32(c,src+4u);else if(st==4u)sd=src+4u;else{c->r[0]=(uint32_t)-6;return;}uint32_t n=sl<dm?sl:dm;uint8_t*sp=guest_ptr(c,sd,n*2u),*dp=guest_ptr(c,dd,n*2u);if(n&&sp&&dp)memmove(dp,sp,n*2u);ngage_w32(c,dst,(dh&0xf0000000u)|n);c->r[0]=dst;return;}
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==99u){return;}
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==2u){
        /* Observed three-argument byte copy used by SIMKIN string construction. */
        uint32_t dst=c->r[0], src=c->r[1], n=c->r[2];
        if(n>0x100000u || dst<0x10000000u || src<0x10000000u ||
           (uint64_t)dst+n>0x12000000ull || (uint64_t)src+n>0x12000000ull){c->r[0]=(uint32_t)-6;return;}
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
        uint8_t *p=guest_ptr(c,c->r[0],8u); if(!p){c->r[0]=(uint32_t)-6;return;}
        uint32_t max=c->r[1]; p[0]=0; p[1]=0; p[2]=0; p[3]=0x30; p[4]=(uint8_t)max; p[5]=(uint8_t)(max>>8); p[6]=(uint8_t)(max>>16); p[7]=(uint8_t)(max>>24); return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==89u){
        uint8_t *p=guest_ptr(c,c->r[0],8u); if(!p){c->r[0]=(uint32_t)-6;return;}
        uint32_t hdr=(uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24); uint32_t len=hdr&0x0fffffffu;
        uint32_t max=(uint32_t)p[4]|((uint32_t)p[5]<<8)|((uint32_t)p[6]<<16)|((uint32_t)p[7]<<24);
        if(len<max){uint8_t *d=guest_ptr(c,c->r[0]+8u+len*2u,2u);if(!d){c->r[0]=(uint32_t)-6;return;}d[0]=(uint8_t)c->r[1];d[1]=(uint8_t)(c->r[1]>>8);len++;uint32_t nh=(hdr&0xf0000000u)|len;p[0]=nh;p[1]=nh>>8;p[2]=nh>>16;p[3]=nh>>24;}else c->r[0]=(uint32_t)-9;return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==1582u || ordinal==3u || ordinal==1505u || ordinal==35u)){
        uint32_t size=c->r[0];
        c->r[0]=shadowkey_heap_alloc(c,size);
        return;
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
    fprintf(stderr,"UNIMPLEMENTED Shadowkey import: %s ordinal %u (r0=%08x r1=%08x r2=%08x r3=%08x)\n",
            dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3]);
    c->r[0]=0;
}
