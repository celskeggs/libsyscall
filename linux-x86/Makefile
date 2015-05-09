MAIN: core

core.o: core.c
	gcc -m32 -nostdlib -nostdinc -ffreestanding core.c -c -o core.o
entry.o: entry.S
	as --32 entry.S -o entry.o
core: core.o entry.o
	ld -melf_i386 core.o entry.o -o core
