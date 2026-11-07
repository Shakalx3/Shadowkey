/* Minimal observed-call-site HLE bootstrap for Shadowkey.
   Only two imports have behavior here; every other import is a named diagnostic stub. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;
extern uint32_t ngage_r32(ngage_cpu_t *, uint32_t);
static uint32_t heap_next=0, heap_end=0;
void shadowkey_heap_init(uint32_t begin,uint32_t end){heap_next=begin;heap_end=end;}
static uint8_t *guest_ptr(ngage_cpu_t*c,uint32_t a,uint32_t n){
    (void)n;
    /* This bootstrap HLE uses a base-biased guest image beginning at 0x10000000. */
    if(a<0x10000000u) return 0;
    return c->mem+(a-0x10000000u);
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
    fprintf(stderr,"IMPORT dll=%s ord=%u r0=%08x r1=%08x r2=%08x r3=%08x lr=%08x cpsr=%08x\n",dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3],c->r[14],c->cpsr);
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==121u){
        uint32_t a=c->r[2]; if(a>=0x10000000u && a<0x12000000u){uint8_t *p=c->mem+(a-0x10000000u); uint32_t h=(uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24); uint32_t n=h&0x0fffffffu, max=(uint32_t)p[4]|((uint32_t)p[5]<<8)|((uint32_t)p[6]<<16)|((uint32_t)p[7]<<24); if(n>250)n=250; uint32_t clean=0;for(;clean<n;clean++){uint16_t ch=(uint16_t)p[8+clean*2]|((uint16_t)p[9+clean*2]<<8);if(ch<32u||ch>126u)break;}if(clean<n){n=clean;h=(h&0xf0000000u)|n;p[0]=h;p[1]=h>>8;p[2]=h>>16;p[3]=h>>24;} char path[260];for(uint32_t i=0;i<n;i++){uint16_t ch=(uint16_t)p[8+i*2]|((uint16_t)p[9+i*2]<<8);path[i]=(char)ch;}path[n]=0;fprintf(stderr,"  RFile::Open candidate path='%s' descriptor_header=%08x max=%u\n",path,h,max);}
        c->r[0]=(uint32_t)-1; return;
    }
    if (!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==89u || ordinal==1359u || ordinal==35u || ordinal==90u)) { uint32_t a=c->r[0]; if(a>=0x10000000u && a<0x12000000u){uint8_t *p=c->mem+(a-0x10000000u); fprintf(stderr,"  MEM r0: %08x %08x %08x %08x %08x %08x\n",*(uint32_t*)(p),*(uint32_t*)(p+4),*(uint32_t*)(p+8),*(uint32_t*)(p+12),*(uint32_t*)(p+16),*(uint32_t*)(p+20));}}
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
    if(!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==1582u || ordinal==3u || ordinal==1505u || ordinal==35u)){
        uint32_t size=c->r[0];
        if(!size || !heap_next || heap_next>heap_end || size>heap_end-heap_next){c->r[0]=0;return;}
        uint32_t p=(heap_next+7u)&~7u;
        if(p>heap_end || size>heap_end-p){c->r[0]=0;return;}
        uint8_t *mem=guest_ptr(c,p,size);
        if(!mem){c->r[0]=0;return;}
        memset(mem,0,size);
        heap_next=p+((size+7u)&~7u);
        c->r[0]=p;
        return;
    }
    if(!strcmp(dll,"FBSCLI[10003a15].DLL") && ordinal==135u){
        /* Observed at 0x1000b9ec: caller passes a freshly allocated 24-byte object,
           then stores returned r0 as the object pointer. Preserve r0 until the exact
           FBSCLI export is mapped to its SDK name. This is a call-site-derived shim. */
        return;
    }
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
