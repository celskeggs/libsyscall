MAIN: core

libsyscall.h syscall.c: syscallgen.py syscalls.tab libsyscall.h.base syscall.c.base
	python syscallgen.py
core.o: core.c auxv.h libsyscall.h
	gcc -O3 -m32 -nostdlib -nostdinc -fno-asynchronous-unwind-tables -ffreestanding core.c -c -o core.o
syscall.o: syscall.c libsyscall.h
	gcc -O3 -m32 -nostdlib -nostdinc -fno-asynchronous-unwind-tables -ffreestanding syscall.c -c -o syscall.o
entry.o: entry.S
	as --32 entry.S -o entry.o
core: core.o entry.o syscall.o
	ld -melf_i386 core.o entry.o syscall.o -o core
	strip -s -R .comment core
clean:
	rm -f syscall.o core.o entry.o core syscall.c libsyscall.h
