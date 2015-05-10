// 32-bit x86 only

#include "libsyscall.h"

#define NULL ((void*) 0)

#include "auxv.h"

unsigned int *_lsc_init_ptr;
void *_lsc_vdso_ptr = NULL;

void _lsc_start(void) __attribute__((noreturn));

void _lsc_start(void) {
	unsigned int argc = *_lsc_init_ptr;
	char **argv = (char **) (_lsc_init_ptr + 1);
	unsigned int *cur = (_lsc_init_ptr + 2 + argc);
	char **env = (char **) cur;
	while (*(cur++) != 0);
	// _lsc_auxv not currently exported, but would be cur at this point.
	while (1) {
		if (*(cur++) == AT_SYSINFO) {
			_lsc_vdso_ptr = (void*) *cur;
			break;
		}
		if (*(++cur) == AT_NULL) {
			__builtin_trap(); // failed to find AT_SYSINFO... can't do syscalls!
			__builtin_unreachable();
		}
	}
	lsc_exit(_lsc_client_main(argc, argv, env));
}
