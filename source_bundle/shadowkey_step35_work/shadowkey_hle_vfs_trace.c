/* Observed-call-site HLE bootstrap for Shadowkey; unresolved imports remain explicit diagnostic stubs. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <errno.h>
#include <dirent.h>
#include <strings.h>
#include <sys/stat.h>
#include "shadowkey_cone_gc_hle.h"
#include "shadowkey_symbian61_hle.h"
#include "shadowkey_fbs_hle.h"
#include "shadowkey_bitgdi_hle.h"
typedef struct { uint32_t object; FILE *fp; char path[1024]; } vfile_t;
typedef struct { uint32_t object; uint32_t fs_object; } vfileman_t;
static vfileman_t vfilemans[16];
static vfile_t vfiles[32];
static uint32_t next_rfs_handle=1u;
static vfileman_t *vfileman_for(uint32_t object,int create){
    for(size_t i=0;i<sizeof(vfilemans)/sizeof(vfilemans[0]);i++)if(vfilemans[i].object==object&&object)return &vfilemans[i];
    if(create)for(size_t i=0;i<sizeof(vfilemans)/sizeof(vfilemans[0]);i++)if(!vfilemans[i].object){vfilemans[i].object=object;return &vfilemans[i];}
    return NULL;
}
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
static uint32_t guest_wstr_len(ngage_cpu_t*c,uint32_t a,uint32_t max){
    uint32_t n=0;for(;n<max;n++){uint8_t*p=guest_ptr(c,a+n*2u,2u);if(!p||(!p[0]&&!p[1]))break;}return n;
}
static int vfs_host_path_cstr(ngage_cpu_t*c,uint32_t name,char*out,size_t cap,char*display,size_t display_cap){
    if(!guest_cstr(c,name,display,display_cap))return 0;
    const char*tail=strrchr(display,'\\');const char*slash=strrchr(display,'/');
    if(slash&&(!tail||slash>tail))tail=slash;
    tail=tail?tail+1:display;
    const char*root=getenv("SHADOWKEY_ASSET_ROOT");if(!root||!*root)return 0;
    int n=snprintf(out,cap,"%s/%s",root,tail);return n>0&&(size_t)n<cap;
}
static uint32_t guest_vararg(ngage_cpu_t*c,unsigned index){
    if(index==0u)return c->r[2];if(index==1u)return c->r[3];
    return rd32(c,c->r[13]+(index-2u)*4u);
}

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
/* ARM UREL GDI 151: TFontSpec::TFontSpec(const TDesC16&,TInt).
   SDK layout: TTypeface is 56 bytes (TBufC<24> name + flags), height at
   +56, TFontStyle's single flags word at +60; total object size is 64. */
static int gdi151_tfont_spec_construct(ngage_cpu_t*c,uint32_t self,uint32_t desc,uint32_t height){
    uint32_t len=0,max=0,data=0;
    if(!descriptor_info(c,desc,&len,&max,&data)||len>max)return 0;
    if(len>24u)len=24u;
    uint8_t*dst=guest_ptr(c,self,64u);
    uint8_t*src=guest_ptr(c,data,len*2u);
    if(!dst||(len&&!src))return 0;
    wr32(c,self,0x40000000u|len);
    if(len)memcpy(dst+4u,src,len*2u);
    wr32(c,self+52u,0u);
    wr32(c,self+56u,height);
    wr32(c,self+60u,0u);
    return 1;
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

static int vfs_host_dir_path(ngage_cpu_t*c,uint32_t desc,char*out,size_t cap,char*display,size_t display_cap){
    uint32_t chars=0;if(!guest_utf16_desc_to_ascii(c,desc,display,display_cap,&chars)||chars<3u||display[1]!=':')return 0;
    char drive=(char)((display[0]>='a'&&display[0]<='z')?display[0]-'a'+'A':display[0]);
    if(drive=='Z')return -1; /* ROM drive is read-only. */
    const char*root=getenv("SHADOWKEY_VFS_ROOT");if(!root||!*root)root=".build/vfs";
    char rel[768];size_t n=0;for(size_t i=2;display[i]&&n+1<sizeof(rel);i++){char ch=display[i];if(ch=='\\')ch='/';if(ch==':'||ch=='*'||ch=='?'||ch=='<'||ch=='>'||ch=='|'||ch=='"')return 0;rel[n++]=ch;}rel[n]=0;
    while(rel[0]=='/')memmove(rel,rel+1,strlen(rel));
    if(strstr(rel,"../")||!strcmp(rel,"..")||strstr(rel,"/.."))return 0;
    int m=snprintf(out,cap,"%s/%c/%s",root,drive,rel);return m>0&&(size_t)m<cap;
}
static int vfs_mkdir_p(const char*path){
    char tmp[1024];size_t n=strlen(path);if(!n||n>=sizeof(tmp))return -1;memcpy(tmp,path,n+1u);
    for(char*p=tmp+1;*p;p++){if(*p=='/'){*p=0;if(mkdir(tmp,0777)!=0&&errno!=EEXIST){*p='/';return -1;}*p='/';}}
    if(mkdir(tmp,0777)==0)return 0;if(errno==EEXIST){struct stat st;if(stat(tmp,&st)==0&&S_ISDIR(st.st_mode))return 1;}return -1;
}
static int vfs_case_resolve(const char*root,const char*rel,char*out,size_t cap){
    if(!root||!rel||!out||!cap)return 0;
    int n=snprintf(out,cap,"%s",root);if(n<=0||(size_t)n>=cap)return 0;
    char copy[768];size_t rn=strlen(rel);if(rn>=sizeof(copy))return 0;memcpy(copy,rel,rn+1u);
    char*save=NULL;for(char*part=strtok_r(copy,"/",&save);part;part=strtok_r(NULL,"/",&save)){
        DIR*d=opendir(out);if(!d)return 0;const char*found=NULL;struct dirent*de;
        while((de=readdir(d)))if(!strcasecmp(de->d_name,part)){found=de->d_name;break;}
        char name[256];if(found){size_t z=strlen(found);if(z>=sizeof(name)){closedir(d);return 0;}memcpy(name,found,z+1u);}else{closedir(d);return 0;}
        closedir(d);size_t used=strlen(out);n=snprintf(out+used,cap-used,"/%s",name);if(n<=0||(size_t)n>=cap-used)return 0;
    }
    return 1;
}
static int vfs_host_full_path(ngage_cpu_t*c,uint32_t desc,char*out,size_t cap,char*display,size_t display_cap){
    uint32_t chars=0;if(!guest_utf16_desc_to_ascii(c,desc,display,display_cap,&chars)||chars<3u||display[1]!=':')return 0;
    char drive=(char)((display[0]>='a'&&display[0]<='z')?display[0]-'a'+'A':display[0]);
    char rel[768];size_t n=0;for(size_t i=2;display[i]&&n+1<sizeof(rel);i++){char ch=display[i];if(ch=='\\')ch='/';if(ch==':'||ch=='*'||ch=='?'||ch=='<'||ch=='>'||ch=='|'||ch=='"')return 0;rel[n++]=ch;}rel[n]=0;
    while(rel[0]=='/')memmove(rel,rel+1,strlen(rel));
    if(strstr(rel,"../")||!strcmp(rel,"..")||strstr(rel,"/.."))return 0;
    const char*asset=getenv("SHADOWKEY_ASSET_ROOT");
    const char*prefix="system/apps/6R51";size_t plen=strlen(prefix);
    if((drive=='Z'||drive=='E')&&asset&&*asset&& !strncmp(rel,prefix,plen)&&(rel[plen]==0||rel[plen]=='/')){
        char assetRel[768];const char*tail=rel+plen+(rel[plen]=='/');snprintf(assetRel,sizeof(assetRel),"%s",tail);
        if(vfs_case_resolve(asset,assetRel,out,cap))return 1;
        if(drive=='Z')return 0;
    }else if(drive=='Z'){
        if(!asset||!*asset)return 0;
        if(vfs_case_resolve(asset,rel,out,cap))return 1;
        return 0;
    }
    const char*root=getenv("SHADOWKEY_VFS_ROOT");if(!root||!*root)root=".build/vfs";
    int m=snprintf(out,cap,"%s/%c/%s",root,drive,rel);return m>0&&(size_t)m<cap;
}
static int vfs_copy_file(const char*src,const char*dst,int overwrite){
    struct stat st;if(stat(dst,&st)==0&&!overwrite)return -11;
    FILE*in=fopen(src,"rb");if(!in)return errno==ENOENT?-1:-21;
    char parent[1024];size_t n=strlen(dst);if(n>=sizeof(parent)){fclose(in);return -2;}memcpy(parent,dst,n+1u);char*slash=strrchr(parent,'/');if(slash){*slash=0;int mk=vfs_mkdir_p(parent);if(mk<0){fclose(in);return -21;}}
    FILE*out=fopen(dst,"wb");if(!out){fclose(in);return errno==ENOENT?-12:-21;}
    uint8_t buf[8192];size_t got;int rc=0;while((got=fread(buf,1,sizeof(buf),in))>0){if(fwrite(buf,1,got,out)!=got){rc=-2;break;}}
    if(ferror(in))rc=-2;if(fclose(in)!=0)rc=-2;if(fclose(out)!=0)rc=-2;return rc;
}
void shadowkey_hle_import(ngage_cpu_t*c,const char*dll,uint16_t ordinal){
    fprintf(stderr,"IMPORT dll=%s ord=%u r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x cpsr=%08x\n",dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14],c->cpsr);
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1407u){
        if(!shadowkey_hle_euser1407_tptrc16(c)){
            fprintf(stderr,"  HALT invalid EUSER1407 TPtrC16 this=%08x source=%08x\n",c->r[0],c->r[1]);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EUSER1407 TPtrC16 this=%08x source=%08x length=%u\n",
                c->r[0],c->r[1],rd32(c,c->r[0])&0x0fffffffu);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1575u){
        uint32_t a=c->r[0],b=c->r[1];
        if(!shadowkey_hle_euser1575_int64_ne(c)){
            fprintf(stderr,"  HALT invalid EUSER1575 TInt64::operator!= lhs=%08x rhs=%08x\n",a,b);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EUSER1575 TInt64::operator!= lhs=%08x rhs=%08x -> %u\n",a,b,c->r[0]);
        return;
    }
    if(!strcmp(dll,"CONE[10003a41].DLL") && ordinal==160u){
        uint32_t result=c->r[0],self=c->r[1];
        if(!shadowkey_hle_cone160_rect(c)){
            fprintf(stderr,"  HALT invalid CONE160 CCoeControl::Rect result=%08x this=%08x\n",result,self);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM CONE160 CCoeControl::Rect this=%08x -> (%d,%d)-(%d,%d)\n",
                self,(int32_t)rd32(c,result),(int32_t)rd32(c,result+4u),
                (int32_t)rd32(c,result+8u),(int32_t)rd32(c,result+12u));
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==711u){
        uint32_t self=c->r[0],dx=c->r[1],dy=c->r[2];
        if(!shadowkey_hle_euser711_trect_move(c)){
            fprintf(stderr,"  HALT invalid EUSER711 TRect::Move this=%08x dx=%d dy=%d\n",self,(int32_t)dx,(int32_t)dy);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EUSER711 TRect::Move this=%08x dx=%d dy=%d\n",self,(int32_t)dx,(int32_t)dy);
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
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1283u){
        /* ARM UREL EUSER1283 is TBufBase16::TBufBase16(TInt). */
        uint32_t self=c->r[0],max=c->r[1];if(max>0x100000u||!guest_ptr(c,self,8u+max*2u)){c->r[0]=(uint32_t)-6;return;}
        wr32(c,self,0x30000000u);wr32(c,self+4u,max);c->r[0]=self;
        fprintf(stderr,"  HLE EUSER1283 TBufBase16 ctor this=%08x max=%u data=%08x\\n",self,max,self+8u);return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1431u){
        /* ARM UREL EUSER1431 is TBufBase8::TBufBase8(TInt), not Mem::FillZ. */
        uint32_t self=c->r[0],max=c->r[1];
        if(max>0x100000u || !guest_ptr(c,self,8u+max)){
            fprintf(stderr,"  HALT EUSER1431 invalid TBufBase8 this=%08x max=%u\\n",self,max);
            c->r[0]=(uint32_t)-6;return;
        }
        wr32(c,self,0x30000000u); /* EBuf descriptor, zero length. */
        wr32(c,self+4u,max);       /* Inline buffer begins at this+8. */
        c->r[0]=self;
        fprintf(stderr,"  HLE EUSER1431 TBufBase8 ctor this=%08x max=%u data=%08x\\n",self,max,self+8u);
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
        fprintf(stderr,"  HLE SDK EFSRV185 TParse::Set this=%08x name=%08x related=%08x default=%08x rc=%d\n",self,name,related,def,rc);
        return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==121u){
        uint32_t self=c->r[0];uint8_t*p=guest_ptr(c,self+18u,1u);
        c->r[0]=(p&&*p)?1u:0u;
        fprintf(stderr,"  HLE SDK EFSRV121 TParseBase::NamePresent this=%08x -> %u\n",self,c->r[0]);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==146u){
        uint32_t self=c->r[0];uint8_t*p=guest_ptr(c,self+14u,1u);
        c->r[0]=(p&&*p)?1u:0u;
        fprintf(stderr,"  HLE SDK EFSRV146 TParseBase::PathPresent this=%08x -> %u\n",self,c->r[0]);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==86u){
        /* ARM UREL EFSRV86 is RFs::MkDir(const TDesC16&), not WINS IsExtWild. */
        uint32_t self=c->r[0],desc=c->r[1];char display[520]={0},host[1024]={0};
        if(!rd32(c,self)){c->r[0]=(uint32_t)-8;fprintf(stderr,"  HALT EFSRV86 MkDir on disconnected RFs this=%08x\\n",self);return;}
        int mapped=vfs_host_dir_path(c,desc,host,sizeof(host),display,sizeof(display));
        if(mapped<=0){c->r[0]=(uint32_t)(mapped<0?-21:-6);fprintf(stderr,"  HLE EFSRV86 RFs::MkDir path='%s' mapped=%d rc=%d\\n",display,mapped,(int32_t)c->r[0]);return;}
        int rc=vfs_mkdir_p(host);c->r[0]=(uint32_t)(rc==0?0:(rc==1?-11:-21));
        fprintf(stderr,"  HLE EFSRV86 RFs::MkDir path='%s' host='%s' rc=%d\\n",display,host,(int32_t)c->r[0]);return;
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
            fprintf(stderr,"  HALT SDK EFSRV162 RFs::ReadFileSection invalid args pathDesc=%08x offset=%08x outDesc=%08x len=%u\n",path_desc,offset,out_desc,requested);return;
        }
        if(requested>out_max){c->r[0]=(uint32_t)-9;fprintf(stderr,"  EFSRV162 overflow requested=%u max=%u path=%s\n",requested,out_max,display);return;}
        uint8_t*dest=guest_ptr(c,out_data,requested);
        if(!dest){c->r[0]=(uint32_t)-6;return;}
        FILE*fp=fopen(host_path,"rb");
        if(!fp){c->r[0]=(uint32_t)-1;fprintf(stderr,"  EFSRV162 missing file path='%s' host='%s'\n",display,host_path);return;}
        if(fseek(fp,(long)offset,SEEK_SET)!=0){fclose(fp);c->r[0]=(uint32_t)-6;return;}
        size_t got=requested?fread(dest,1u,requested,fp):0u;fclose(fp);
        wr32(c,out_desc,(rd32(c,out_desc)&0xf0000000u)|(uint32_t)got);
        c->r[0]=0;
        fprintf(stderr,"  HLE SDK EFSRV162 RFs::ReadFileSection path='%s' offset=%u requested=%u got=%zu out=%08x data=%08x max=%u\n",display,offset,requested,got,out_desc,out_data,out_max);
        return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==106u){
        /* ARM UREL EFSRV106 is CFileMan::NewL(RFs&). */
        uint32_t fs=c->r[0];if(!rd32(c,fs)){c->r[0]=(uint32_t)-8;return;}
        uint32_t obj=shadowkey_heap_alloc(c,0x400u);if(!obj){c->r[0]=(uint32_t)-4;return;}
        uint8_t*p=guest_ptr(c,obj,0x400u);if(!p){c->r[0]=(uint32_t)-4;return;}memset(p,0,0x400u);wr32(c,obj,0x10000000u);wr32(c,obj+4u,fs);
        vfileman_t*fm=vfileman_for(obj,1);if(!fm){c->r[0]=(uint32_t)-4;return;}fm->fs_object=fs;c->r[0]=obj;
        fprintf(stderr,"  HLE EFSRV106 CFileMan::NewL fs=%08x -> this=%08x\\n",fs,obj);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==21u){
        /* ARM UREL EFSRV21 is CFileMan::Copy(old,new,switches). */
        uint32_t self=c->r[0],srcDesc=c->r[1],dstDesc=c->r[2],flags=c->r[3];
        vfileman_t*fm=vfileman_for(self,0);char srcDisplay[520]={0},dstDisplay[520]={0},src[1024]={0},dst[1024]={0};
        if(!fm){c->r[0]=(uint32_t)-8;fprintf(stderr,"  HALT EFSRV21 CFileMan::Copy invalid this=%08x\\n",self);return;}
        int sm=vfs_host_full_path(c,srcDesc,src,sizeof(src),srcDisplay,sizeof(srcDisplay));
        int dm=vfs_host_full_path(c,dstDesc,dst,sizeof(dst),dstDisplay,sizeof(dstDisplay));
        int rc=(sm&&dm)?vfs_copy_file(src,dst,(flags&1u)!=0u):-6;
        c->r[0]=(uint32_t)rc;fprintf(stderr,"  HLE EFSRV21 CFileMan::Copy src='%s' dst='%s' flags=%08x rc=%d\\n",srcDisplay,dstDisplay,flags,rc);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==18u){
        /* ARM UREL EFSRV18 is RFs::Connect(TInt). */
        uint32_t self=c->r[0],slots=c->r[1];uint8_t*p=guest_ptr(c,self,4u);
        if(!p){c->r[0]=(uint32_t)-6;return;}
        uint32_t handle=rd32(c,self);if(!handle){handle=0x70000000u|(next_rfs_handle++&0x0fffffffu);wr32(c,self,handle);}
        c->r[0]=0;fprintf(stderr,"  HLE EFSRV18 RFs::Connect this=%08x slots=%u handle=%08x\\n",self,slots,handle);return;
    }
    if(!strcmp(dll,"EFSRV[100039e4].DLL") && ordinal==15u){
        /* ARM UREL EFSRV15 is RFsBase::Close. */
        uint32_t self=c->r[0],handle=rd32(c,self);wr32(c,self,0u);c->r[0]=0;
        fprintf(stderr,"  HLE EFSRV15 RFsBase::Close this=%08x handle=%08x\\n",self,handle);return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==89u){
        /* ARM UREL EUSER89 is TDes16::Append(TChar). */
        uint32_t self=c->r[0],ch=c->r[1],len=0,max=0,data=0;
        if(!descriptor_info(c,self,&len,&max,&data)||(rd32(c,self)>>28)==1u||(rd32(c,self)>>28)==4u||len>=max||ch>0xffffu){fprintf(stderr,"  HALT EUSER89 invalid/overflow TDes16 append this=%08x ch=%08x len=%u max=%u\\n",self,ch,len,max);c->r[0]=(uint32_t)-6;return;}
        uint8_t*d=guest_ptr(c,data+len*2u,2u);if(!d){c->r[0]=(uint32_t)-6;return;}d[0]=(uint8_t)ch;d[1]=(uint8_t)(ch>>8);
        uint32_t h=rd32(c,self);wr32(c,self,(h&0xf0000000u)|(len+1u));if(len<64u)fprintf(stderr,"  HLE EUSER89 TDes16::Append this=%08x char=%04x newLen=%u\\n",self,ch,len+1u);return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==172u){
        uint32_t self=c->r[0],handle=rd32(c,self);wr32(c,self,0u);c->r[0]=0;
        fprintf(stderr,"  HLE EUSER172 RHandleBase::Close this=%08x handle=%08x\\n",self,handle);return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==85u){
        /* ARM UREL EUSER85: TDes8::Append(TChar). */
        uint32_t self=c->r[0],ch=c->r[1],len=0,max=0,data=0;
        if(!descriptor_info(c,self,&len,&max,&data) || (rd32(c,self)>>28)==1u || (rd32(c,self)>>28)==4u || len>=max || ch>0xffu){
            fprintf(stderr,"  HALT EUSER85 invalid/overflow TDes8 append this=%08x ch=%08x len=%u max=%u\\n",self,ch,len,max);
            c->r[0]=(uint32_t)-6;return;
        }
        uint8_t*d=guest_ptr(c,data+len,1u);if(!d){c->r[0]=(uint32_t)-6;return;}*d=(uint8_t)ch;
        uint32_t h=rd32(c,self);wr32(c,self,(h&0xf0000000u)|(len+1u));
        if(len<64u)fprintf(stderr,"  HLE EUSER85 TDes8::Append this=%08x char=%02x newLen=%u data=%08x\\n",self,ch,len+1u,data);
        return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==315u){
        /* ARM UREL ordinal 315 is wcscat (do not use the WINS UDEB name). */
        uint32_t dst=c->r[0],src=c->r[1],dl=guest_wstr_len(c,dst,0x10000u),sl=guest_wstr_len(c,src,0x10000u);
        if(dl+sl+1u>0x10000u){c->r[0]=0;return;}
        for(uint32_t k=0;k<=sl;k++){uint8_t*s=guest_ptr(c,src+k*2u,2u),*d=guest_ptr(c,dst+(dl+k)*2u,2u);if(!s||!d){c->r[0]=0;return;}d[0]=s[0];d[1]=s[1];}
        c->r[0]=dst;fprintf(stderr,"  HLE ESTLIB315 wcscat dst=%08x src=%08x oldLen=%u addLen=%u\\n",dst,src,dl,sl);return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==316u){
        /* ARM UREL ordinal 316 is wcscmp. */
        uint32_t a=c->r[0],b=c->r[1];int32_t result=0;
        for(uint32_t k=0;k<0x10000u;k++){uint8_t*x=guest_ptr(c,a+k*2u,2u),*y=guest_ptr(c,b+k*2u,2u);if(!x||!y){result=x?1:(y?-1:0);break;}uint16_t xv=(uint16_t)x[0]|((uint16_t)x[1]<<8),yv=(uint16_t)y[0]|((uint16_t)y[1]<<8);if(xv!=yv){result=(int32_t)xv-(int32_t)yv;break;}if(!xv)break;}
        c->r[0]=(uint32_t)result;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==317u){
        /* ARM UREL ordinal 317 is wcscpy. */
        uint32_t dst=c->r[0],src=c->r[1];
        for(uint32_t k=0;k<0x10000u;k++){uint8_t*s=guest_ptr(c,src+k*2u,2u),*d=guest_ptr(c,dst+k*2u,2u);if(!s||!d){c->r[0]=0;return;}d[0]=s[0];d[1]=s[1];if(!s[0]&&!s[1]){c->r[0]=dst;fprintf(stderr,"  HLE ESTLIB317 wcscpy dst=%08x src=%08x len=%u\\n",dst,src,k);return;}}
        c->r[0]=0;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==58u){
        char display[1024]={0},host[2048]={0},mode[16]="rb";
        if(!vfs_host_path_cstr(c,c->r[0],host,sizeof(host),display,sizeof(display))){c->r[0]=0;return;}
        guest_cstr(c,c->r[1],mode,sizeof(mode));
        if(mode[0]!='r'){fprintf(stderr,"  HALT ESTLIB58 _fopen write mode rejected path='%s' mode='%s'\n",display,mode);c->r[0]=0;return;}
        FILE*fp=fopen(host,"rb");if(!fp){fprintf(stderr,"  ESTLIB58 _fopen missing path='%s' host='%s'\n",display,host);c->r[0]=0;return;}
        uint32_t handle=shadowkey_heap_alloc(c,16u);vfile_t*vf=handle?vfile_for(handle,1):NULL;
        if(!vf){fclose(fp);c->r[0]=0;return;}
        vf->fp=fp;snprintf(vf->path,sizeof(vf->path),"%s",host);c->r[0]=handle;
        fprintf(stderr,"  HLE ESTLIB58 _fopen path='%s' -> handle=%08x\n",display,handle);return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==49u){
        vfile_t*vf=vfile_for(c->r[0],0);int rc=-1;if(vf&&vf->fp){rc=fclose(vf->fp);vf->fp=NULL;vf->object=0;}c->r[0]=(uint32_t)rc;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==51u){
        vfile_t*vf=vfile_for(c->r[0],0);c->r[0]=(vf&&vf->fp&&feof(vf->fp))?1u:0u;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==56u){
        uint32_t dst=c->r[0],limit=c->r[1],handle=c->r[2];vfile_t*vf=vfile_for(handle,0);
        if(!vf||!vf->fp||!limit){c->r[0]=0;return;}
        char tmp[8192];size_t n=limit<sizeof(tmp)?limit:sizeof(tmp);
        if(!fgets(tmp,(int)n,vf->fp)){c->r[0]=0;return;}
        guest_put_cstr(c,dst,tmp);c->r[0]=dst;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==65u){
        vfile_t*vf=vfile_for(c->r[0],0);c->r[0]=(vf&&vf->fp)?(uint32_t)fseek(vf->fp,(long)(int32_t)c->r[1],(int)c->r[2]):(uint32_t)-1;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==64u){
        vfile_t*vf=vfile_for(c->r[0],0);char fmt[1024];
        if(!vf||!vf->fp||!guest_cstr(c,c->r[1],fmt,sizeof(fmt))){c->r[0]=(uint32_t)-1;return;}
        unsigned ai=0;int assigned=0;
        for(size_t i=0;fmt[i];i++){
            if(fmt[i]==' '||fmt[i]=='\t'||fmt[i]=='\n'){while(fmt[i+1]==' '||fmt[i+1]=='\t'||fmt[i+1]=='\n')i++;fscanf(vf->fp," ");continue;}
            if(fmt[i]!='%'){int ch=fgetc(vf->fp);if(ch!=fmt[i]){if(ch!=EOF)ungetc(ch,vf->fp);break;}continue;}
            i++;if(fmt[i]=='%'){int ch=fgetc(vf->fp);if(ch!='%')break;continue;}
            while(fmt[i]=='*'||(fmt[i]>='0'&&fmt[i]<='9')||fmt[i]=='h'||fmt[i]=='l'||fmt[i]=='L')i++;
            char spec=fmt[i];uint32_t arg=guest_vararg(c,ai++);int ok=0;
            if(spec=='d'||spec=='i'){int v=0;ok=fscanf(vf->fp,"%d",&v)==1;if(ok)wr32(c,arg,(uint32_t)v);}
            else if(spec=='u'){unsigned v=0;ok=fscanf(vf->fp,"%u",&v)==1;if(ok)wr32(c,arg,v);}
            else if(spec=='x'||spec=='X'){unsigned v=0;ok=fscanf(vf->fp,"%x",&v)==1;if(ok)wr32(c,arg,v);}
            else if(spec=='c'){int v=fgetc(vf->fp);ok=v!=EOF;if(ok){uint8_t*p=guest_ptr(c,arg,1u);if(p)*p=(uint8_t)v;}}
            else if(spec=='s'){char tmp[1024];ok=fscanf(vf->fp,"%1023s",tmp)==1;if(ok)guest_put_cstr(c,arg,tmp);}
            else if(spec=='f'){float v=0;ok=fscanf(vf->fp,"%f",&v)==1;if(ok){uint32_t bits=0;memcpy(&bits,&v,4);wr32(c,arg,bits);}}
            else {fprintf(stderr,"  HALT ESTLIB64 unsupported fscanf format %%%c\n",spec);exit(95);}
            if(!ok)break;assigned++;
        }
        c->r[0]=(uint32_t)assigned;return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==180u){
        char a[4096],b[4096];guest_cstr(c,c->r[0],a,sizeof(a));guest_cstr(c,c->r[1],b,sizeof(b));int v=strcmp(a,b);c->r[0]=(uint32_t)(v<0?-1:(v>0?1:0));return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==82u){uint32_t dst=c->r[0],fmtp=c->r[1];char fmt[2048],out[4096];guest_cstr(c,fmtp,fmt,sizeof(fmt));size_t oi=0;unsigned ai=2;for(size_t i=0;fmt[i]&&oi+2<sizeof(out);i++){if(fmt[i]!='%'){out[oi++]=fmt[i];continue;}char spec=fmt[++i];if(!spec)break;if(spec=='%'){out[oi++]='%';continue;}uint32_t arg=0;if(ai<=12)arg=c->r[ai++];else{arg=ngage_r32(c,c->r[13]+(ai-13)*4u);ai++;}char t[512];t[0]=0;if(spec=='s')guest_cstr(c,arg,t,sizeof(t));else if(spec=='d'||spec=='i')snprintf(t,sizeof(t),"%d",(int32_t)arg);else if(spec=='u')snprintf(t,sizeof(t),"%u",arg);else if(spec=='x'||spec=='X')snprintf(t,sizeof(t),spec=='x'?"%x":"%X",arg);else if(spec=='c'){t[0]=(char)arg;t[1]=0;}else{t[0]='%';t[1]=spec;t[2]=0;}size_t n=strlen(t);if(n>sizeof(out)-oi-2)n=sizeof(out)-oi-2;memcpy(out+oi,t,n);oi+=n;}out[oi]=0;guest_put_cstr(c,dst,out);c->r[0]=(uint32_t)oi;return;}
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==90u){
        /* TInt64::TInt64(TInt): sign-extend the 32-bit constructor argument. */
        uint32_t self=c->r[0],value=c->r[1];
        if(!guest_ptr(c,self,8u)){fprintf(stderr,"HALT invalid EUSER90 TInt64 constructor this=%08x\\n",self);exit(95);}
        wr32(c,self,value);wr32(c,self+4u,(value&0x80000000u)?0xffffffffu:0u);return;
    }
    if(!strcmp(dll,"ESTLIB[10003b0b].DLL") && ordinal==342u){
        /* ARM UREL ordinal 342 is wcslen; return UTF-16 code-unit count. */
        uint32_t src=c->r[0],n=guest_wstr_len(c,src,0x10000u);
        c->r[0]=n;fprintf(stderr,"  HLE ESTLIB342 wcslen src=%08x -> %u\\n",src,n);return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1373u){
        uint32_t self=c->r[0],sp=c->r[13];
        if(!shadowkey_hle_euser1373_trect_ctor(c)){
            fprintf(stderr,"  HALT invalid EUSER1373 TRect ctor this=%08x sp=%08x\n",self,sp);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EUSER1373 TRect ctor this=%08x (%d,%d)-(%d,%d)\n",
                self,(int32_t)rd32(c,self),(int32_t)rd32(c,self+4u),
                (int32_t)rd32(c,self+8u),(int32_t)rd32(c,self+12u));
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==530u){
        uint32_t self=c->r[0];
        if(!shadowkey_hle_euser530_trect_height(c)){
            fprintf(stderr,"  HALT invalid EUSER530 TRect::Height this=%08x\n",self);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EUSER530 TRect::Height this=%08x -> %d\n",self,(int32_t)c->r[0]);
        return;
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && ordinal==151u){
        uint32_t self=c->r[0],desc=c->r[1],height=c->r[2];
        if(!gdi151_tfont_spec_construct(c,self,desc,height)){
            fprintf(stderr,"  HALT invalid GDI151 TFontSpec this=%08x name=%08x height=%u\n",self,desc,height);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM GDI151 TFontSpec this=%08x nameDesc=%08x heightTwips=%u size=64\n",self,desc,height);
        return;
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && ordinal==108u){
        uint32_t self=c->r[0],weight=c->r[1];
        if(!shadowkey_hle_gdi108_set_stroke_weight(c)){
            fprintf(stderr,"  HALT invalid GDI108 TFontStyle::SetStrokeWeight this=%08x value=%u\n",self,weight);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM GDI108 TFontStyle::SetStrokeWeight this=%08x value=%u flags=%08x\n",self,weight,rd32(c,self));
        return;
    }
    if(!strcmp(dll,"GDI[10003b15].DLL") && ordinal==101u){
        uint32_t self=c->r[0],posture=c->r[1];
        if(!shadowkey_hle_gdi101_set_posture(c)){
            fprintf(stderr,"  HALT invalid GDI101 TFontStyle::SetPosture this=%08x value=%u\n",self,posture);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM GDI101 TFontStyle::SetPosture this=%08x value=%u flags=%08x\n",self,posture,rd32(c,self));
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==858u){
        uint32_t ptr=c->r[0];
        if(!shadowkey_hle_euser858_cleanup_pushl(c)){
            fprintf(stderr,"  HALT EUSER858 CleanupStack::PushL invalid/overflow ptr=%08x\n",ptr);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EUSER858 CleanupStack::PushL ptr=%08x depth=%u\n",
                ptr,shadowkey_symbian61_cleanup_depth);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==828u){
        if(!shadowkey_hle_euser828_cleanup_pop(c)){
            fprintf(stderr,"  HALT EUSER828 CleanupStack::Pop underflow\n");
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EUSER828 CleanupStack::Pop depth=%u\n",
                shadowkey_symbian61_cleanup_depth);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==3u){
        uint32_t size=c->r[0],ptr=shadowkey_heap_alloc(c,size);
        if(!ptr){
            fprintf(stderr,"  HALT EUSER3 CBase::newL allocation failed size=%u\n",size);
            exit(95);
        }
        c->r[0]=ptr;
        fprintf(stderr,"  HLE ARM EUSER3 CBase::newL size=%u -> %08x\n",size,ptr);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && ordinal==1582u){
        uint32_t size=c->r[0],ptr=shadowkey_heap_alloc(c,size);
        c->r[0]=ptr;
        fprintf(stderr,"  HLE ARM EUSER1582 CBase::operator new size=%u -> %08x\n",size,ptr);
        return;
    }
    if(!strcmp(dll,"EUSER[100039e5].DLL") && (ordinal==1505u || ordinal==35u)){
        uint32_t size=c->r[0],ptr=shadowkey_heap_alloc(c,size);
        c->r[0]=ptr;
        fprintf(stderr,"  HLE ARM EUSER%u operator new size=%u -> %08x\n",ordinal,size,ptr);
        return;
    }
    if(!strcmp(dll,"EIKCORE[10004892].DLL") && ordinal==219u){
        uint32_t self=c->r[0],app=c->r[1];
        if(!shadowkey_hle_eikcore219_ceikdocument(c)){
            fprintf(stderr,"  HALT invalid EIKCORE219 CEikDocument this=%08x app=%08x\n",self,app);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EIKCORE219 CEikDocument this=%08x app=%08x process=%08x\n",
                self,app,rd32(c,self+12u));
        return;
    }
    if(!strcmp(dll,"EIKCORE[10004892].DLL") && ordinal==222u){
        uint32_t self=c->r[0];
        if(!shadowkey_hle_eikcore222_ceikapplication(c)){
            fprintf(stderr,"  HALT invalid EIKCORE222 CEikApplication this=%08x\n",self);
            exit(95);
        }
        fprintf(stderr,"  HLE ARM EIKCORE222 CEikApplication this=%08x caption=TBuf<256> size=556\n",self);
        return;
    }
    if(!strcmp(dll,"EIKCORE[10004892].DLL") && ordinal==224u){
        /* Trace-only bypass: base fields/side effects are deliberately not initialized. */
        fprintf(stderr,"DIAGNOSTIC NO-OP EIKCORE224 CEikAppUi constructor (not full initialization)\\n");
        return;
    }
    if(shadowkey_bitgdi_import(c,dll,ordinal)) return;
    if(!strcmp(dll,"FBSCLI[10003a15].DLL") && shadowkey_fbs_import(c->r,c->mem,ordinal)) return;
    fprintf(stderr,"HALT UNIMPLEMENTED Shadowkey import: %s ordinal=%u r0=%08x r1=%08x r2=%08x r3=%08x sp=%08x lr=%08x\n",
            dll,ordinal,c->r[0],c->r[1],c->r[2],c->r[3],c->r[13],c->r[14]);
    if(getenv("SHADOWKEY_DIAGNOSTIC_CONTINUE_UNIMPLEMENTED")) return;
    exit(95);
}
