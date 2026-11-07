#include "shadowkey_fbs_hle.h"
#include <string.h>
#include <stdio.h>

/* The game call sites establish this contract:
   ord 135: construct a 24-byte bitmap handle object;
   ord 16:  (this, TSize*, displayMode), returning KErrNone;
   ord 17:  this-only accessor whose result is consumed as pixel-data address.
   The names are high-confidence API inferences, not an export-table proof.

   Model the two FBS chunks as separate guest mappings. A small CBitwiseBitmap-
   like header lives in FbsSharedChunk and carries a byte offset into
   FbsLargeChunk. DataAddress resolves Base()+offset; it never returns a host
   pointer or a synthetic EUSER-heap allocation. */

enum { FBS_BITMAPS = 16, FBS_HEADER_BYTES = 0x40 };
enum { FBS_MODE_OBSERVED_10 = 10, FBS_BYTES_PER_PIXEL = 2 };
/* The two-byte storage is inferred from Shadowkey clearing 176*208*2 bytes;
   do not interpret mode value 10 as a proven SDK enum name. */
#define FBS_HEADER_MAGIC 0x53424653u /* internal HLE marker: "SFBS" */
#define FBS_HEADER_START 0x100u
#define FBS_DATA_START   0x1000u

typedef struct {
    uint32_t object;
    uint32_t header_offset;
    uint32_t data_offset;
    uint32_t width, height, mode, stride, bytes;
    int constructed;
    int created;
    uint32_t data_calls;
} fbs_bitmap_t;

static fbs_bitmap_t bitmaps[FBS_BITMAPS];
static uint32_t shared_next = FBS_HEADER_START;
static uint32_t large_next = FBS_DATA_START;

static uint8_t *guest_ptr(uint8_t *mem, uint32_t address, uint32_t size) {
    if (!mem || address < 0x10000000u ||
        (uint64_t)address + size > SHADOWKEY_FBS_GUEST_END) return NULL;
    return mem + (address - 0x10000000u);
}
static uint32_t rd32(uint8_t *mem, uint32_t address) {
    uint8_t *p=guest_ptr(mem,address,4u);
    if(!p)return 0;
    return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);
}
static void wr32(uint8_t *mem, uint32_t address, uint32_t value) {
    uint8_t *p=guest_ptr(mem,address,4u);
    if(!p)return;
    p[0]=(uint8_t)value;p[1]=(uint8_t)(value>>8);p[2]=(uint8_t)(value>>16);p[3]=(uint8_t)(value>>24);
}
static fbs_bitmap_t *find_bitmap(uint32_t object, int create) {
    fbs_bitmap_t *free_slot=NULL;
    for(unsigned i=0;i<FBS_BITMAPS;i++) {
        if(bitmaps[i].object==object && object) return &bitmaps[i];
        if(!bitmaps[i].object && !free_slot) free_slot=&bitmaps[i];
    }
    if(create && free_slot) { memset(free_slot,0,sizeof(*free_slot));free_slot->object=object;return free_slot; }
    return NULL;
}
void shadowkey_fbs_reset(void) {
    memset(bitmaps,0,sizeof(bitmaps));
    shared_next=FBS_HEADER_START;
    large_next=FBS_DATA_START;
}

int shadowkey_fbs_import(uint32_t regs[16], uint8_t *mem, uint16_t ordinal) {
    if(ordinal!=135u && ordinal!=16u && ordinal!=17u) return 0;
    uint32_t object=regs[0];
    if(ordinal==135u) {
        fbs_bitmap_t *b=find_bitmap(object,1);
        if(!b) { regs[0]=0;fprintf(stderr,"FBS HLE: bitmap handle table full for %08x\n",object);return 1; }
        b->constructed=1;
        /* CFbsBitmap's client handle is opaque to the game; leave its 24-byte
           guest object untouched, just as the platform constructor does. */
        regs[0]=object;
        fprintf(stderr,"FBS HLE: CFbsBitmap handle constructed object=%08x\n",object);
        return 1;
    }
    fbs_bitmap_t *b=find_bitmap(object,0);
    if(ordinal==16u) {
        uint32_t size_addr=regs[1], mode=regs[2];
        uint32_t width=rd32(mem,size_addr), height=rd32(mem,size_addr+4u);
        if(!b || !b->constructed || !width || !height || width>1024u || height>1024u || mode!=FBS_MODE_OBSERVED_10) {
            regs[0]=(uint32_t)-6;
            fprintf(stderr,"FBS HLE: Create rejected object=%08x size=%ux%u mode=%u\n",object,width,height,mode);
            return 1;
        }
        uint32_t stride=(width*FBS_BYTES_PER_PIXEL+3u)&~3u;
        uint64_t bytes64=(uint64_t)stride*height;
        uint32_t h=(shared_next+7u)&~7u;
        uint32_t d=(large_next+0xffu)&~0xffu;
        if(bytes64>0xffffffffu || h>SHADOWKEY_FBS_SHARED_SIZE || FBS_HEADER_BYTES>SHADOWKEY_FBS_SHARED_SIZE-h ||
           d>SHADOWKEY_FBS_GUEST_END-SHADOWKEY_FBS_LARGE_BASE || bytes64>SHADOWKEY_FBS_GUEST_END-SHADOWKEY_FBS_LARGE_BASE-d) {
            regs[0]=(uint32_t)-4;
            fprintf(stderr,"FBS HLE: chunk allocation exhausted bytes=%llu\n",(unsigned long long)bytes64);
            return 1;
        }
        b->header_offset=h;b->data_offset=d;b->width=width;b->height=height;b->mode=mode;b->stride=stride;b->bytes=(uint32_t)bytes64;b->created=1;
        uint32_t hp=SHADOWKEY_FBS_SHARED_BASE+h;
        wr32(mem,hp+0u,FBS_HEADER_MAGIC);wr32(mem,hp+4u,width);wr32(mem,hp+8u,height);
        wr32(mem,hp+12u,mode);wr32(mem,hp+16u,stride);wr32(mem,hp+20u,d);
        wr32(mem,hp+24u,(uint32_t)bytes64);wr32(mem,hp+28u,1u); /* large-chunk flag */
        uint8_t *pixels=guest_ptr(mem,SHADOWKEY_FBS_LARGE_BASE+d,(uint32_t)bytes64);
        if(!pixels){regs[0]=(uint32_t)-4;b->created=0;return 1;}
        memset(pixels,0,(size_t)bytes64);
        shared_next=h+FBS_HEADER_BYTES;large_next=d+(uint32_t)bytes64;
        regs[0]=0; /* KErrNone */
        fprintf(stderr,"FBS HLE: Create %ux%u mode=%u stride=%u bytes=%u header=%08x pixels=%08x\n",
                width,height,mode,stride,b->bytes,hp,SHADOWKEY_FBS_LARGE_BASE+d);
        return 1;
    }
    /* Ordinal 17 is called with r0 only deliberately set at all three sites.
       Resolve the CBitwiseBitmap chunk-relative data offset to a guest VA. */
    if(!b || !b->created) {
        regs[0]=0;
        fprintf(stderr,"FBS HLE: DataAddress before successful Create object=%08x\n",object);
        return 1;
    }
    uint32_t hp=SHADOWKEY_FBS_SHARED_BASE+b->header_offset;
    uint32_t magic=rd32(mem,hp), offset=rd32(mem,hp+20u), bytes=rd32(mem,hp+24u), large=rd32(mem,hp+28u);
    if(magic!=FBS_HEADER_MAGIC || large!=1u || offset!=b->data_offset || bytes!=b->bytes ||
       !guest_ptr(mem,SHADOWKEY_FBS_LARGE_BASE+offset,bytes)) {
        regs[0]=0;
        fprintf(stderr,"FBS HLE: invalid shared-chunk bitmap header object=%08x header=%08x\n",object,hp);
        return 1;
    }
    regs[0]=SHADOWKEY_FBS_LARGE_BASE+offset;
    b->data_calls++;
    if(b->data_calls>1u) {
        uint8_t *p=guest_ptr(mem,regs[0],bytes);
        uint32_t nonzero=0;
        for(uint32_t i=0;i<bytes;i++) if(p[i]) nonzero++;
        fprintf(stderr,"FBS HLE: DataAddress re-fetch #%u after guest use: nonzero=%u/%u first16=",
                b->data_calls,nonzero,bytes);
        for(unsigned i=0;i<16;i++) fprintf(stderr,"%02x",p[i]);
        fprintf(stderr,"\n");
    }
    fprintf(stderr,"FBS HLE: DataAddress object=%08x shared=%08x offset=%08x -> %08x (%u bytes)\n",
            object,hp,offset,regs[0],bytes);
    return 1;
}

int shadowkey_fbs_bitmap_info(uint32_t object, uint32_t *pixels, uint32_t *width,
                              uint32_t *height, uint32_t *stride, uint32_t *mode) {
    fbs_bitmap_t *b=find_bitmap(object,0);
    if(!b || !b->created) return 0;
    if(pixels) *pixels=SHADOWKEY_FBS_LARGE_BASE+b->data_offset;
    if(width) *width=b->width;
    if(height) *height=b->height;
    if(stride) *stride=b->stride;
    if(mode) *mode=b->mode;
    return 1;
}
