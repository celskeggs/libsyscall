MAIN: test

CFLAGS=-O3 -m64 -nostdlib -nostdinc -fno-asynchronous-unwind-tables -ffreestanding -ggdb

libsyscall.h syscall.c: syscallgen.py syscalls.tab libsyscall.h.base syscall.c.base
	python syscallgen.py
core.o: core.c libsyscall.h
	gcc $(CFLAGS) core.c -c -o core.o
syscall.o: syscall.c libsyscall.h
	gcc $(CFLAGS) syscall.c -c -o syscall.o
entry.o: entry.S
	as --64 entry.S -o entry.o
libsyscall.a: core.o entry.o syscall.o
	ar rcs libsyscall.a core.o entry.o syscall.o
test: libsyscall.a test.c
	gcc $(CFLAGS) test.c libsyscall.a -o test
	strip -s -R .comment test
clean:
	rm -f syscall.o core.o entry.o test syscall.c libsyscall.h libsyscall.a
