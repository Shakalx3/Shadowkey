#ifndef SHADOWKEY_PROBE_STDIO_H
#define SHADOWKEY_PROBE_STDIO_H
#include <stddef.h>
typedef struct __shadowkey_FILE FILE;
extern FILE *stdin, *stdout, *stderr;
int fprintf(FILE *, const char *, ...);
int printf(const char *, ...);
int snprintf(char *, size_t, const char *, ...);
int puts(const char *);
FILE *fopen(const char *, const char *);
int fseek(FILE *, long, int);
size_t fread(void *, size_t, size_t, FILE *);
int fclose(FILE *);
#define SEEK_SET 0
#endif
