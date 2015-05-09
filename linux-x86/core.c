// 32-bit x86 only

_Static_assert(sizeof(int) == 4, "int must be 32 bits");
_Static_assert(sizeof(void*) == 4, "pointer must be 32 bits");

#define NULL ((void*) 0)

#define AT_NULL         0               /* End of vector */
#define AT_IGNORE       1               /* Entry should be ignored */
#define AT_EXECFD       2               /* File descriptor of program */
#define AT_PHDR         3               /* Program headers for program */
#define AT_PHENT        4               /* Size of program header entry */
#define AT_PHNUM        5               /* Number of program headers */
#define AT_PAGESZ       6               /* System page size */
#define AT_BASE         7               /* Base address of interpreter */
#define AT_FLAGS        8               /* Flags */
#define AT_ENTRY        9               /* Entry point of program */
#define AT_NOTELF       10              /* Program is not ELF */
#define AT_UID          11              /* Real uid */
#define AT_EUID         12              /* Effective uid */
#define AT_GID          13              /* Real gid */
#define AT_EGID         14              /* Effective gid */
#define AT_CLKTCK       17              /* Frequency of times() */
/* Pointer to the global system page used for system calls and other nice things.  */
#define AT_SYSINFO      32
#define AT_SYSINFO_EHDR 33

typedef unsigned int uint32_t;

extern uint32_t *_lsc_init_ptr;
void *_lsc_vdso_ptr = NULL;
static uint32_t _lsc_argc;
static char **_lsc_argv;
static uint32_t *_lsc_env;
static uint32_t *_lsc_auxv;
static char *should_be_null;

// must not return
void _lsc_start() {
	_lsc_argc = *_lsc_init_ptr;
	_lsc_argv = (char **) (_lsc_init_ptr + 1);
	should_be_null = _lsc_argv[_lsc_argc];
	_lsc_env = _lsc_init_ptr + 2 + _lsc_argc;
	uint32_t *cur = _lsc_env;
	while (*(cur++) != 0);
	_lsc_auxv = cur;
	while (*(cur) != AT_NULL) {
		if (*(cur++) == AT_SYSINFO) {
			_lsc_vdso_ptr = (void*) *(cur++);
			break;
		}
	}
	_lsc_syscall1(_lsc_vdso_ptr, 1, 37);
}
