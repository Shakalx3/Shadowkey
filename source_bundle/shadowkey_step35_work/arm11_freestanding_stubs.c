/* Link-validation stubs only. These functions are not a playable runtime. */
#include <stddef.h>
typedef struct __shadowkey_FILE FILE;
FILE *stderr = (FILE *)0;
void *memcpy(void *d, const void *s, size_t n) { unsigned char *a=d; const unsigned char *b=s; for(size_t i=0;i<n;i++) a[i]=b[i]; return d; }
void *memmove(void *d, const void *s, size_t n) { unsigned char *a=d; const unsigned char *b=s; if(a<b){for(size_t i=0;i<n;i++)a[i]=b[i];}else if(a>b){while(n){n--;a[n]=b[n];}} return d; }
void *memset(void *d, int v, size_t n) { unsigned char *a=d; for(size_t i=0;i<n;i++)a[i]=(unsigned char)v; return d; }
int strcmp(const char *a,const char *b){while(*a && *a==*b){a++;b++;}return (unsigned char)*a-(unsigned char)*b;}
int strncmp(const char *a,const char *b,size_t n){for(size_t i=0;i<n;i++){unsigned char x=(unsigned char)a[i],y=(unsigned char)b[i];if(x!=y)return x-y;if(!x)return 0;}return 0;}
void __aeabi_memclr(void *d, size_t n){memset(d,0,n);}
void __aeabi_memmove(void *d,const void *s,size_t n){memmove(d,s,n);}
void __aeabi_memset(void *d,size_t n,int v){memset(d,v,n);}
int fprintf(FILE *f,const char *fmt,...){(void)f;(void)fmt;return 0;}
void exit(int status){(void)status;for(;;){} }
int E32Main(void){return 0;}
void __aeabi_memclr4(void *d,size_t n){memset(d,0,n);}
