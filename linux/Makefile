ifndef BITS
ARCH=$(shell uname -m)
ifeq ($(ARCH),x86_64)
BITS=64
endif
ifeq ($(ARCH),i686)
BITS=32
endif
endif

ifdef BITS

CFLAGS=-O3 -m$(BITS) -nostdlib -nostdinc -fno-asynchronous-unwind-tables -ffreestanding -Wall

../libsyscall.tar.gz: libsyscall.a libsyscall.h
	tar -czf ../libsyscall.tar.gz libsyscall.a libsyscall.h

libsyscall.a: core.o entry.o syscall.o
	ar rcs libsyscall.a core.o entry.o syscall.o

libsyscall.h syscall.c: syscallgen.py syscalls.tab.$(BITS) libsyscall.h.base.$(BITS) syscall.c.base
	python syscallgen.py libsyscall.h.base.$(BITS) syscalls.tab.$(BITS)
core.o: core.c auxv.h libsyscall.h
	gcc $(CFLAGS) core.c -c -o core.o
syscall.o: syscall.c libsyscall.h
	gcc $(CFLAGS) syscall.c -c -o syscall.o
entry.o: entry.$(BITS).S
	as --$(BITS) entry.$(BITS).S -o entry.o
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
