#include "libsyscall.h"

LSC_MAIN(argc, argv, env) {
	const char str[] = "Hello, World!\n";
	lsc_write(1, str, sizeof(str) - 1);
	return 42;
}
