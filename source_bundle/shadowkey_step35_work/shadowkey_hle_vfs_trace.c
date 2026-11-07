/* Observed-call-site HLE bootstrap for Shadowkey; unresolved imports remain explicit diagnostic stubs. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <sys/stat.h>
#include "shadowkey_cone_gc_hle.h"
#include "shadowkey_symbian61_hle.h"
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
extern void ngage_runtime_note_bitmap_host_write(ngage_cpu_t*,uint32_t,uint32_t,uint32_t,uint32_t,uint32_t) __attribute__((weak));
extern void ngage_runtime_watch_range(uint32_t,uint32_t) __attribute__((weak));
static uint32_t heap_next=0, heap_end=0, heap2_next=0x10230000u, heap2_end=0x10300000u, heap3_next=0x10400000u, heap3_end=0x12000000u;
void shadowkey_heap_init(uint32_t begin,uint32_t end){heap_next=begin;heap_end=end;heap2_next=(end>begin)?0x10230000u:0x12000000u;heap3_next=(end>begin)?0x10400000u:0x12000000u;}
void shadowkey_heap_extend(uint32_t end){heap_end=end;}
static uint8_t *guest_ptr(ngage_cpu_t*c,uint32_t a,uint32_t n){
    if(!c || a<0x10000000u || (uint64_t)a+n>0x12000000ull) return 0;
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

static int guest_utf16_desc_to_ascii(ngage_cpu_t*c,uint32_t desc,char*out,size_t cap,uint32_t*chars){
    uint32_t len=0,max=0,data=0;
    if(!out||cap<2u||!descriptor_info(c,desc,&len,&max,&data)){if(chars)*chars=0;return 0;}
    if(len>max)len=max;
    if(len>cap-1u)len=(uint32_t)(cap-1u);
    uint32_t clean=pathish_utf16_len(c,data,len);
    for(uint32_t i=0;i<clean;i++){
        uint8_t*p=guest_ptr(c,data+i*2u,2u);if(!p){clean=i;break;}
        uint16_t ch=(uint16_t)p[0]|((uint16_t)p[1]<<8);
        if(ch<32u||ch>126u){clean=i;break;}
        out[i]=(char)ch;
    }
    out[clean]=0;if(chars)*chars=clean;return 1;
}
static void tparse_write_field(ngage_cpu_t*c,uint32_t self,unsigned field,uint8_t pos,uint8_t len,uint8_t present){
    uint32_t a=self+8u+field*4u;uint8_t*p=guest_ptr(c,a,4u);if(!p)return;
    p[0]=pos;p[1]=len;p[2]=present;p[3]=0;
}
static int tparse_set(ngage_cpu_t*c,uint32_t self,uint32_t name_desc,uint32_t related_desc,uint32_t default_desc){
    char name[260]={0},related[260]={0},def[260]={0},full[260]={0};
    uint32_t n=0,rn=0,dn=0;
    if(!guest_utf16_desc_to_ascii(c,name_desc,name,sizeof(name),&n))return -6;
    if(related_desc && !guest_utf16_desc_to_ascii(c,related_desc,related,sizeof(related),&rn))rn=0;
    if(default_desc && !guest_utf16_desc_to_ascii(c,default_desc,def,sizeof(def),&dn))dn=0;
    if(n && ((n>=2u&&name[1]==':') || name[0]=='\\')) snprintf(full,sizeof(full),"%s",name);
    else {
        const char*base=rn?related:(dn?def:"");
        const char*slash1=strrchr(base,'\\'),*slash2=strrchr(base,'/');
        const char*slash=slash1;
        if(!slash || (slash2 && slash2>slash))slash=slash2;
        size_t prefix=base[0]?(slash?(size_t)(slash-base+1u):0u):0u;
        if(prefix+n>=sizeof(full))return -9;
        if(prefix)memcpy(full,base,prefix);
        memcpy(full+prefix,name,n+1u);
    }
    size_t length=strlen(full);if(length>256u)return -9;
    uint8_t*obj=guest_ptr(c,self,32u+512u);if(!obj)return -6;
    wr32(c,self+4u,0u);
    memset(obj+8u,0,16u);
    uint32_t wild=0;size_t drive=0,path_start=0,path_end=0,name_start=0,name_end=0,ext_start=length;
    if(length>=2u && full[1]==':'){drive=2u; tparse_write_field(c,self,0,0,2,1);}
    path_start=drive;
    for(size_t i=drive;i<length;i++)if(full[i]=='\\'||full[i]=='/')path_end=i+1u;
    if(path_end>path_start)tparse_write_field(c,self,1,(uint8_t)path_start,(uint8_t)(path_end-path_start),1);
    name_start=path_end;
    for(size_t i=name_start;i<length;i++)if(full[i]=='.'){ext_start=i;break;}
    name_end=ext_start;
    if(name_end>name_start)tparse_write_field(c,self,2,(uint8_t)name_start,(uint8_t)(name_end-name_start),1);
    if(ext_start<length)tparse_write_field(c,self,3,(uint8_t)ext_start,(uint8_t)(length-ext_start),1);
    for(size_t i=name_start;i<name_end;i++){if(full[i]=='*')wild|=0x01u|0x04u|0x20u;else if(full[i]=='?')wild|=0x01u|0x04u|0x10u;}
    for(size_t i=ext_start;i<length;i++){if(full[i]=='*')wild|=0x02u|0x04u|0x20u;else if(full[i]=='?')wild|=0x02u|0x04u|0x10u;}
    if(path_end==length && length && (full[length-1]=='\\'||full[length-1]=='/'))wild|=0x08u;
    wr32(c,self+4u,wild);
    uint32_t buf=self+24u;wr32(c,buf,0x30000000u|(uint32_t)length);wr32(c,buf+4u,256u);
    for(size_t i=0;i<length;i++){uint8_t*p=guest_ptr(c,buf+8u+(uint32_t)i*2u,2u);if(!p)return -6;p[0]=(uint8_t)full[i];p[1]=0;}
    uint8_t*z=guest_ptr(c,buf+8u+(uint32_t)length*2u,2u);if(z){z[0]=0;z[1]=0;}
    return 0;
}
static int vfs_host_path(ngage_cpu_t*c,uint32_t path_desc,char*out,size_t cap,char*display,size_t display_cap){
    uint32_t chars=0;
    if(!guest_utf16_desc_to_ascii(c,path_desc,display,display_cap,&chars))return 0;
    const char*tail=strrchr(display,'\\');const char*slash=strrchr(display,'/');
    if(slash && (!tail||slash>tail))tail=slash;
    tail=tail?tail+1:display;
    const char*root=getenv("SHADOWKEY_ASSET_ROOT");
    if(!root||!*root)return 0;
    int n=snprintf(out,cap,"%s/%s",root,tail);
    return n>0 && (size_t)n<cap;
}

void shadowkey_hle_import(ngage_cpu_t*c,const char*dll,uint16_t ordinal){
    fprintf(stderr,"IMPORT dll=%s ord=%u r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x cpsr=%08x\n",dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14],c->cpsr);
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1407u) {
        uint32_t self=c->r[0],offset=c->r[1];
        if(!shadowkey_hle_euser1407_setoffset(c)){
            fprintf(stderr,"HALT invalid TDblQueBase::SetOffset this=%08x offset=%08x\\n",self,offset);
            exit(95);
        }
        fprintf(stderr,"  HLE SDK EUSER1407 TDblQueBase::SetOffset this=%08x iOffset=%08x\\n",self,offset);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1575u) {
        fprintf(stderr,"  EUSER1575 FORENSIC r0(out)=%08x r1(obj+310)=%08x r2=%08x r3=%08x sp=%08x lr=%08x\\n",
                c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
        trace_guest_bytes(c,"EUSER1575 arg0/out-candidate PRE",c->r[0],16u);
        if(c->r[1]>=0x10000010u && c->r[1]<0x12000000u) {
            trace_guest_bytes(c,"EUSER1575 arg1 object fields around +310",c->r[1]-16u,0x70u);
            uint32_t p=ngage_r32(c,c->r[1]-16u);
            if(p>=0x10000000u && p<0x12000000u)
                trace_guest_bytes(c,"EUSER1575 object[-0x10] buffer pointer",p,0x80u);
        }
        if(c->r[2]>=0x10000000u && c->r[2]<0x12000000u)
            trace_guest_bytes(c,"EUSER1575 arg2 pointee",c->r[2],0x30u);
        if(c->r[3]>=0x10000000u && c->r[3]<0x12000000u)
            trace_guest_bytes(c,"EUSER1575 arg3 object",c->r[3],0x30u);
        if(c->r[13]>=0x10000000u && c->r[13]<0x12000000u)
            trace_guest_bytes(c,"EUSER1575 caller stack args",c->r[13],0x30u);
    }
    if(!strcmp(dll,"CONE[10003a41].DLL") && ordinal==160u) {
        uint32_t result=c->r[0],self=c->r[1];
        if(!shadowkey_hle_cone160_position(c)){
            fprintf(stderr,"HALT invalid CCoeControl::Position result=%08x this=%08x\\n",result,self);
            exit(95);
        }
        fprintf(stderr,"  HLE SDK CONE160 CCoeControl::Position this=%08x -> (%d,%d)\\n",
                self,(int32_t)ngage_r32(c,result),(int32_t)ngage_r32(c,result+4u));
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
        if(n && ngage_runtime_note_bitmap_host_write) ngage_runtime_note_bitmap_host_write(c,dst,0,n,1u,0u);
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
        if(n && ngage_runtime_note_bitmap_host_write) ngage_runtime_note_bitmap_host_write(c,dst,0,n,1u,c->r[1]&0xffu);
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
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==230u){
        uint32_t self=c->r[0];uint8_t*p=guest_ptr(c,self,544u);
        if(!p){c->r[0]=(uint32_t)-6;return;}
        wr32(c,self+4u,0u);memset(p+8u,0,16u);
        wr32(c,self+24u,0x30000000u);wr32(c,self+28u,256u);
        memset(p+32u,0,512u);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==185u){
        uint32_t self=c->r[0],name=c->r[1],related=c->r[2],def=c->r[3];
        int rc=tparse_set(c,self,name,related,def);
        c->r[0]=(uint32_t)rc;
        fprintf(stderr,"  HLE SDK EFSRV185 TParse::Set this=%08x name=%08x related=%08x default=%08x rc=%d\\n",self,name,related,def,rc);
        return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==121u){
        uint32_t self=c->r[0];uint8_t*p=guest_ptr(c,self+18u,1u);
        c->r[0]=(p&&*p)?1u:0u;
        fprintf(stderr,"  HLE SDK EFSRV121 TParseBase::NamePresent this=%08x -> %u\\n",self,c->r[0]);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==146u){
        uint32_t self=c->r[0];uint8_t*p=guest_ptr(c,self+14u,1u);
        c->r[0]=(p&&*p)?1u:0u;
        fprintf(stderr,"  HLE SDK EFSRV146 TParseBase::PathPresent this=%08x -> %u\\n",self,c->r[0]);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==86u){
        uint32_t self=c->r[0];c->r[0]=(rd32(c,self+4u)&0x02u)?1u:0u;
        fprintf(stderr,"  HLE SDK EFSRV86 TParseBase::IsExtWild this=%08x -> %u\\n",self,c->r[0]);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==162u){
        uint32_t path_desc=c->r[1],offset=c->r[2],out_desc=c->r[3];
        uint32_t out_len=0,out_max=0,out_data=0;
        char display[520]={0},host_path[1024]={0};
        uint32_t requested=rd32(c,c->r[13]);
        if(!descriptor_info(c,out_desc,&out_len,&out_max,&out_data) ||
           ((rd32(c,out_desc)>>28)!=2u && (rd32(c,out_desc)>>28)!=3u) ||
           !vfs_host_path(c,path_desc,host_path,sizeof(host_path),display,sizeof(display))){
            c->r[0]=(uint32_t)-6;
            fprintf(stderr,"  HALT SDK EFSRV162 RFs::ReadFileSection invalid args pathDesc=%08x offset=%08x outDesc=%08x len=%u\\n",path_desc,offset,out_desc,requested);return;
        }
        if(requested>out_max){c->r[0]=(uint32_t)-9;fprintf(stderr,"  EFSRV162 overflow requested=%u max=%u path=%s\\n",requested,out_max,display);return;}
        uint8_t*dest=guest_ptr(c,out_data,requested);
        if(!dest){c->r[0]=(uint32_t)-6;return;}
        FILE*fp=fopen(host_path,"rb");
        if(!fp){c->r[0]=(uint32_t)-1;fprintf(stderr,"  EFSRV162 missing file path='%s' host='%s'\\n",display,host_path);return;}
        if(fseek(fp,(long)offset,SEEK_SET)!=0){fclose(fp);c->r[0]=(uint32_t)-6;return;}
        size_t got=requested?fread(dest,1u,requested,fp):0u;fclose(fp);
        wr32(c,out_desc,(rd32(c,out_desc)&0xf0000000u)|(uint32_t)got);
        c->r[0]=0;
        fprintf(stderr,"  HLE SDK EFSRV162 RFs::ReadFileSection path='%s' offset=%u requested=%u got=%zu out=%08x data=%08x max=%u\\n",display,offset,requested,got,out_desc,out_data,out_max);
        return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==18u){
        uint32_t self=c->r[0],index=c->r[1],array=rd32(c,self+4u);
        fprintf(stderr,"  HALT SDK EFSRV18 CDir::operator[] this=%08x index=%u iArray=%08x",self,index,array);
        if(array>=0x10000000u && array<0x12000000u)
            fprintf(stderr," count=%u gran=%u rep=%08x base=%08x cacheIndex=%u cacheOffset=%u",
                    rd32(c,array+4u),rd32(c,array+8u),rd32(c,array+12u),rd32(c,array+16u),rd32(c,array+20u),rd32(c,array+24u));
        fputc('\\n',stderr);exit(95);
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==15u){
        vfile_t *vf=vfile_for(c->r[0],0);
        if(vf && vf->fp){fclose(vf->fp);vf->fp=NULL;vf->object=0;}
        fprintf(stderr,"  HLE SDK EFSRV15 CFileBase destructor this=%08x\\n",c->r[0]);return;
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
        if(ngage_runtime_note_bitmap_host_write) ngage_runtime_note_bitmap_host_write(c,dst,src,n,2u,0u);
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
    if(shadowkey_bitgdi_import(c,dll,ordinal)) return;
    if(!strcmp(dll,"FBSCLI[10003a15].DLL") && shadowkey_fbs_import(c->r,c->mem,ordinal)) return;
    fprintf(stderr,"HALT UNIMPLEMENTED Shadowkey import: %s ordinal=%u r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x\\n",
            dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
    if(getenv("SHADOWKEY_DIAGNOSTIC_CONTINUE_UNIMPLEMENTED")) return;
    exit(95);
}
