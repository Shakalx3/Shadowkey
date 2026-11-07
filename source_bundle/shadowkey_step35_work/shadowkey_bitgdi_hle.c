#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "shadowkey_bitgdi_hle.h"
#include "shadowkey_fbs_hle.h"

/* Reserved guest addresses for HLE vtables and virtual-call trampolines.
   The actual EKA1 DLL code is not present in this host-side trace runner. */
#define GFX_VT_DEVICE   0x10226000u
#define GFX_VT_CONTEXT  0x10226100u
#define GFX_VT_FONT     0x10226200u
#define GFX_VCALL_FONT_HEIGHT 0x10227000u
#define GFX_VCALL_FONT_ASCENT 0x10227004u
#define GFX_VCALL_USE_FONT    0x10227008u
#define GFX_VCALL_CONTEXT_3C  0x1022700cu
#define GFX_VCALL_GET_FONT    0x10227010u
#define GFX_VCALL_CONTEXT_A8  0x10227014u
#define GFX_VCALL_CONTEXT_DISCARD_FONT 0x10227018u
#define GFX_VCALL_BITMAP_OP   0x1022701cu

typedef struct {
    uint32_t object;
    uint32_t bitmap;
    uint32_t pixels;
    uint32_t width, height, stride, mode;
} device_record_t;
typedef struct { uint32_t object, device, font; } context_record_t;
typedef struct { uint32_t object, height, ascent; } font_record_t;
static device_record_t devices[16];
static context_record_t contexts[16];
static font_record_t fonts[16];
static uint8_t *vtable_mem;

extern uint32_t shadowkey_heap_alloc(ngage_cpu_t *c, uint32_t size);

static uint8_t *gptr(ngage_cpu_t *c, uint32_t a, uint32_t n) {
    if(a<0x10000000u || (uint64_t)a+n>0x12000000ull) return NULL;
    return c->mem+(a-0x10000000u);
}
static void wr(ngage_cpu_t *c,uint32_t a,uint32_t v){uint8_t*p=gptr(c,a,4u);if(!p)return;p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);p[2]=(uint8_t)(v>>16);p[3]=(uint8_t)(v>>24);}
static uint32_t rd(ngage_cpu_t *c,uint32_t a){uint8_t*p=gptr(c,a,4u);if(!p)return 0;return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
static void dump_bytes(ngage_cpu_t *c,const char *label,uint32_t a,uint32_t n) {
    uint8_t *p=gptr(c,a,n);
    fprintf(stderr,"  GFX RAW %s @%08x:",label,a);
    if(!p){fprintf(stderr," <out-of-range>\n");return;}
    for(uint32_t i=0;i<n;i++) fprintf(stderr," %02x",p[i]);
    fprintf(stderr,"\n");
}
static device_record_t *find_device(uint32_t p){for(unsigned i=0;i<16;i++)if(devices[i].object==p&&p)return &devices[i];return NULL;}
static context_record_t *find_context(uint32_t p){for(unsigned i=0;i<16;i++)if(contexts[i].object==p&&p)return &contexts[i];return NULL;}
static font_record_t *find_font(uint32_t p){for(unsigned i=0;i<16;i++)if(fonts[i].object==p&&p)return &fonts[i];return NULL;}

static void init_vtables(ngage_cpu_t *c) {
    if(vtable_mem==c->mem) return;
    vtable_mem=c->mem;
    memset(devices,0,sizeof(devices)); memset(contexts,0,sizeof(contexts)); memset(fonts,0,sizeof(fonts));
    uint8_t *p=gptr(c,GFX_VT_DEVICE,0x300u); if(!p)return; memset(p,0,0x300u);
    wr(c,GFX_VT_DEVICE+0x44u,GFX_VCALL_GET_FONT);
    wr(c,GFX_VT_CONTEXT+0x24u,GFX_VCALL_USE_FONT);
    wr(c,GFX_VT_CONTEXT+0x28u,GFX_VCALL_CONTEXT_DISCARD_FONT);
    wr(c,GFX_VT_CONTEXT+0x3cu,GFX_VCALL_CONTEXT_3C);
    wr(c,GFX_VT_CONTEXT+0xa8u,GFX_VCALL_CONTEXT_A8);
    wr(c,GFX_VT_FONT+0x10u,GFX_VCALL_FONT_HEIGHT);
    wr(c,GFX_VT_FONT+0x14u,GFX_VCALL_FONT_ASCENT);
}

static uint32_t make_font(ngage_cpu_t *c,uint32_t height) {
    init_vtables(c); if(!height)height=12u; if(height>128u)height=128u;
    for(unsigned i=0;i<16;i++) if(fonts[i].object && fonts[i].height==height) return fonts[i].object;
    unsigned slot=0; while(slot<16 && fonts[slot].object)slot++; if(slot==16)return 0;
    uint32_t p=shadowkey_heap_alloc(c,0x20u); if(!p)return 0;
    fonts[slot]=(font_record_t){p,height,(height*3u)/4u};
    wr(c,p,GFX_VT_FONT); wr(c,p+4u,height); wr(c,p+8u,(height*3u)/4u);
    fprintf(stderr,"  GFX HLE: CFont model=%08x height=%u ascent=%u\n",p,height,(height*3u)/4u);
    return p;
}

int shadowkey_bitgdi_import(ngage_cpu_t *c,const char *dll,uint16_t ordinal) {
    if(!strcmp(dll,"BITGDI[10003b18].DLL") && ordinal==86u) {
        uint32_t bitmap=c->r[0],pixels=0,w=0,h=0,stride=0,mode=0;
        init_vtables(c);
        if(!shadowkey_fbs_bitmap_info(bitmap,&pixels,&w,&h,&stride,&mode)) { c->r[0]=0; fprintf(stderr,"  GFX HLE: CFbsBitmapDevice::NewL rejected bitmap=%08x (no created FBS bitmap)\n",bitmap); return 1; }
        unsigned slot=0; while(slot<16 && devices[slot].object)slot++; if(slot==16){c->r[0]=0;return 1;}
        uint32_t p=shadowkey_heap_alloc(c,0x40u); if(!p){c->r[0]=0;return 1;}
        devices[slot]=(device_record_t){p,bitmap,pixels,w,h,stride,mode};
        wr(c,p,GFX_VT_DEVICE); wr(c,p+4u,bitmap); wr(c,p+8u,GFX_VCALL_BITMAP_OP); wr(c,p+12u,pixels); wr(c,p+16u,h); wr(c,p+20u,stride); wr(c,p+24u,mode);
        c->r[0]=p;
        fprintf(stderr,"  GFX HLE: CFbsBitmapDevice::NewL bitmap=%08x -> device=%08x pixels=%08x size=%ux%u stride=%u mode=%u\n",bitmap,p,pixels,w,h,stride,mode);
        return 1;
    }
    if(!strcmp(dll,"BITGDI[10003b18].DLL") && ordinal==23u) {
        uint32_t device=c->r[0],out=c->r[1];
        init_vtables(c);
        if(!find_device(device) || out<0x10000000u || !gptr(c,out,4u)){c->r[0]=(uint32_t)-6;fprintf(stderr,"  GFX HLE: CFbsDevice::CreateContext rejected device=%08x out=%08x\n",device,out);return 1;}
        unsigned slot=0; while(slot<16 && contexts[slot].object)slot++; if(slot==16){c->r[0]=(uint32_t)-4;return 1;}
        uint32_t p=shadowkey_heap_alloc(c,0x40u); if(!p){c->r[0]=(uint32_t)-4;return 1;}
        contexts[slot]=(context_record_t){p,device,0};
        wr(c,p,GFX_VT_CONTEXT); wr(c,p+4u,device); wr(c,p+8u,0);
        wr(c,out,p); c->r[0]=0;
        fprintf(stderr,"  GFX HLE: CFbsDevice::CreateContext device=%08x -> gc=%08x out=%08x\n",device,p,out);
        return 1;
    }
    if(!strcmp(dll,"EIKCORE[10004892].DLL") && ordinal==243u) {
        /* Call-site ABI: result is passed to CGraphicsContext::UseFont and
           then consumed through CFont vtable slots +0x10/+0x14. The exact
           EIKCORE export name remains unresolved; model only that CFont role. */
        uint32_t arg0=c->r[0], height=c->r[3];
        uint32_t font=make_font(c,height);
        c->r[0]=font;
        fprintf(stderr,"  GFX HLE: EIKCORE ordinal243 CFont-provider model arg0=%08x height_arg=%u -> %08x\n",arg0,height,font);
        return 1;
    }
    return 0;
}

int shadowkey_bitgdi_decode_drawtext(ngage_cpu_t *c, shadowkey_drawtext_args_t *out) {
    if(!c || !out) return 0;
    /* The live vslot +0xA8 call uses the TPoint overload, not TRect:
       EUSER711 sets only r0=this, r1=x, r2=y; r3 is the baseline. */
    uint8_t *pp=gptr(c,c->r[2],8u);
    uint8_t *ap=gptr(c,c->r[13],8u);
    if(!pp || !ap) return 0;
    uint32_t w[4];
    for(unsigned i=0;i<2;i++) w[i]=(uint32_t)pp[i*4u]|((uint32_t)pp[i*4u+1u]<<8)|((uint32_t)pp[i*4u+2u]<<16)|((uint32_t)pp[i*4u+3u]<<24);
    for(unsigned i=0;i<2;i++) w[2u+i]=(uint32_t)ap[i*4u]|((uint32_t)ap[i*4u+1u]<<8)|((uint32_t)ap[i*4u+2u]<<16)|((uint32_t)ap[i*4u+3u]<<24);
    out->gc=c->r[0]; out->descriptor=c->r[1]; out->rect=c->r[2];
    out->baseline=(int32_t)c->r[3]; out->alignment=w[2]; out->margin=w[3];
    out->left=(int32_t)w[0]; out->top=(int32_t)w[1]; out->right=0; out->bottom=0; out->geometry_kind=1u;
    return 1;
}

int shadowkey_bitgdi_virtual(ngage_cpu_t *c,uint32_t address) {
    if(address==GFX_VCALL_FONT_HEIGHT) {
        font_record_t *f=find_font(c->r[0]); c->r[0]=f?f->height:12u; return 1;
    }
    if(address==GFX_VCALL_FONT_ASCENT) {
        font_record_t *f=find_font(c->r[0]); c->r[0]=f?f->ascent:9u; return 1;
    }
    if(address==GFX_VCALL_USE_FONT) {
        context_record_t *g=find_context(c->r[0]); if(g){g->font=c->r[1];wr(c,g->object+8u,c->r[1]);}
        c->r[0]=0; return 1;
    }
    if(address==GFX_VCALL_CONTEXT_3C) {
        /* This observed call is part of the text/bitmap draw path. Its exact
           virtual name is unresolved; preserve the GC object and continue. */
        c->r[0]=0; return 1;
    }
    if(address==GFX_VCALL_CONTEXT_A8) {
        /* Caller ABI matches CGraphicsContext::DrawText(
           const TDesC&, const TRect&, TInt baseline, TTextAlign, TInt margin).
           r1=descriptor, r2=TRect*, r3=baseline; align and margin are
           the two stack arguments. This HLE records them but does not
           pretend to rasterize glyphs. */
        shadowkey_drawtext_args_t a;
        if(!shadowkey_bitgdi_decode_drawtext(c,&a)) {
            fprintf(stderr,"  GFX HLE: DrawText invalid guest arguments gc=%08x desc=%08x rect=%08x sp=%08x\n",c->r[0],c->r[1],c->r[2],c->r[13]);
            return 1;
        }
        fprintf(stderr,"  GFX HLE: DrawText(gc=%08x desc=%08x point=%08x (%d,%d) baseline=%d align=%u margin=%u) [diagnostic only; no glyph rasterization]\n",
                a.gc,a.descriptor,a.rect,a.left,a.top,a.baseline,a.alignment,a.margin);
        dump_bytes(c,"descriptor",c->r[1],32u);
        dump_bytes(c,"point",c->r[2],8u);
        dump_bytes(c,"stack-args",c->r[13],8u);
        return 1;
    }
    if(address==GFX_VCALL_CONTEXT_DISCARD_FONT) {
        /* Call immediately follows DrawText at the four verified sites;
           clear the selected font as CGraphicsContext::DiscardFont does. */
        context_record_t *g=find_context(c->r[0]);
        if(g){g->font=0;wr(c,g->object+8u,0);}
        fprintf(stderr,"  GFX HLE: DiscardFont(gc=%08x)\n",c->r[0]);
        return 1;
    }
    if(address==GFX_VCALL_BITMAP_OP) {
        /* The lifted path loads [bitmap+0x20] and calls it with
           r0=&device->bitmap, r1=CFont*, r2=character, r3=CFbsBitmap*.
           In this HLE layout bitmap+0x20 aliases device+8, so that slot
           must be a callable bridge, not the pixel-buffer address. The
           actual raster operation is intentionally not fabricated here. */
        fprintf(stderr,"  GFX HLE: bitmap/font callback diagnostic receiver=%08x font=%08x char=%u bitmap=%08x\n",
                c->r[0],c->r[1],c->r[2],c->r[3]);
        return 1;
    }
    if(address==GFX_VCALL_GET_FONT) {
        device_record_t *d=find_device(c->r[0]);
        if(d && c->r[1]>=0x10000000u) {
            uint32_t font_px=12u, spec=c->r[2];
            uint32_t h=rd(c,spec), type=h>>28, name_len=h&0x0fffffffu;
            uint32_t max=rd(c,spec+4u), twips=rd(c,spec+56u);
            if(type==4u && max==24u && name_len<=max && twips>0u && twips<4096u && gptr(c,spec,72u)) {
                char name[40]; unsigned n=0;
                for(;n<name_len && n<24u;n++){uint8_t *q=gptr(c,spec+8u+n*2u,2u);if(!q)break;name[n]=(char)q[0];}
                name[n]=0;
                /* Host-only fallback conversion until the N95 device's
                   SizeInTwips/SizeInPixels ratio is recovered. */
                font_px=(twips*96u+720u)/1440u; if(!font_px)font_px=1u;
                fprintf(stderr,"  GFX HLE GetNearestFontInTwips: TFontSpec72 name='%s' height=%u twips style=(%u,%u,%u) -> provisional %u px (96 dpi model)\n",name,twips,rd(c,spec+60u),rd(c,spec+64u),rd(c,spec+68u),font_px);
            } else {
                fprintf(stderr,"  GFX HLE GetNearestFontInTwips: TFontSpec72 not validated at %08x (header=%08x max=%u height=%u); fallback 12px\n",spec,h,max,twips);
            }
            uint32_t font=make_font(c,font_px); wr(c,c->r[1],font); c->r[0]=0;
        } else c->r[0]=(uint32_t)-6;
        return 1;
    }
    return 0;
}

void shadowkey_bitgdi_reset(void) {
    memset(devices,0,sizeof(devices)); memset(contexts,0,sizeof(contexts)); memset(fonts,0,sizeof(fonts)); vtable_mem=NULL;
}
