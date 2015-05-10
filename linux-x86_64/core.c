// 64-bit x86 only

#include "libsyscall.h"

#define NULL ((void*) 0)

unsigned long *_lsc_init_ptr;
void *_lsc_vdso_ptr = NULL;

void _lsc_start(void) __attribute__((noreturn));

void _lsc_start(void) {
	unsigned long argc = *_lsc_init_ptr;
	char **argv = (char **) (_lsc_init_ptr + 1);
	char **env = (char **) (_lsc_init_ptr + 2 + argc);
	lsc_exit(_lsc_client_main(argc, argv, env));
}
