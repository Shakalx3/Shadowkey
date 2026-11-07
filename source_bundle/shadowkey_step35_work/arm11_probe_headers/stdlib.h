#ifndef SHADOWKEY_PROBE_STDLIB_H
#define SHADOWKEY_PROBE_STDLIB_H
#include <stddef.h>
void *malloc(size_t);
void *calloc(size_t, size_t);
void free(void *);
void exit(int);
#endif
