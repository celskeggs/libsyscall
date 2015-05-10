
ifdef BITS

main: test
CFLAGS=-O3 -m$(BITS) -nostdlib -nostdinc -fno-asynchronous-unwind-tables -ffreestanding

libsyscall.h syscall.c: syscallgen.py syscalls.tab.$(BITS) libsyscall.h.base.$(BITS) syscall.c.base
	python syscallgen.py libsyscall.h.base.$(BITS) syscalls.tab.$(BITS)
core.o: core.c auxv.h libsyscall.h
	gcc $(CFLAGS) core.c -c -o core.o
syscall.o: syscall.c libsyscall.h
	gcc $(CFLAGS) syscall.c -c -o syscall.o
entry.o: entry.$(BITS).S
	as --$(BITS) entry.$(BITS).S -o entry.o
libsyscall.a: core.o entry.o syscall.o
	ar rcs libsyscall.a core.o entry.o syscall.o
test: libsyscall.a test.c
	gcc $(CFLAGS) test.c libsyscall.a -o test
	strip -s -R .comment test

else

main:
	@echo 'BITS must be set!'
	@exit 1

endif
clean:
	rm -f syscall.o core.o entry.o test syscall.c libsyscall.h libsyscall.a
