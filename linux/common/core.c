#include "libsyscall.h"

#define NULL ((void*) 0)

#include "auxv.h"

lsc_uint_t *_lsc_init_ptr;
void *_lsc_vdso_ptr = NULL;

void _lsc_start(void) __attribute__((noreturn));

void _lsc_start(void) {
	lsc_uint_t argc = *_lsc_init_ptr;
	char **argv = (char **) (_lsc_init_ptr + 1);
	char **env = argv + 1 + argc;
#ifdef LSC_32BIT
	// parse out the __kernel_vsyscall pointer from the ELF auxilary vectors.
	lsc_int_t *cur = (lsc_int_t*) env;
	while (*(cur++) != 0);
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
#endif
	lsc_exit(_lsc_client_main(argc, argv, env));
}
