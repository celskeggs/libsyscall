// 32-bit x86 only

#include "libsyscall.h"

#define NULL ((void*) 0)

#include "auxv.h"

unsigned int *_lsc_init_ptr;
void *_lsc_vdso_ptr = NULL;
unsigned int _lsc_argc;
char **_lsc_argv;
char **_lsc_env;

void _lsc_start(void) __attribute__((noreturn));

void _lsc_start(void) {
	_lsc_argc = *_lsc_init_ptr;
	_lsc_argv = (char **) (_lsc_init_ptr + 1);
	unsigned int *cur = (_lsc_init_ptr + 2 + _lsc_argc);
	_lsc_env = (char **) cur;
	while (*(cur++) != 0);
	// _lsc_auxv not currently exported, but would be cur at this point.
	while (*(cur) != AT_NULL) {
		if (*(cur++) == AT_SYSINFO) {
			_lsc_vdso_ptr = (void*) *(cur++);
			break;
		}
	}
	lsc_exit(17);
}
