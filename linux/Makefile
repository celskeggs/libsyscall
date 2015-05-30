# we assume that we start in $(PSRCDIR), which is correct if invoked manually or via the master Makefile.
include config.mk

CFLAGS=-O3 -m$(BITS) -Wall
ALL_CFLAGS=-nostdlib -nostdinc -fno-asynchronous-unwind-tables -ffreestanding -I$(BUILDDIR) $(CFLAGS)

OBJS_RAW=core.o entry.o syscall.o
OBJS=$(addprefix $(BUILDDIR)/, $(OBJS_RAW))

$(BUILDDIR)/libsyscall.a: $(OBJS)
	ar rcs $@ $^

# the order of these arguments MATTER!
$(BUILDDIR)/libsyscall.h $(BUILDDIR)/syscall.c: syscallgen.py libsyscall.h.base.$(BITS) syscalls.tab.$(BITS) syscall.c.base
	python3 $^ $(BUILDDIR)/libsyscall.h $(BUILDDIR)/syscall.c
$(BUILDDIR)/core.o: core.c auxv.h $(BUILDDIR)/libsyscall.h
	$(CC) $(ALL_CFLAGS) $< -c -o $@
$(BUILDDIR)/syscall.o: $(BUILDDIR)/syscall.c $(BUILDDIR)/libsyscall.h
	$(CC) $(ALL_CFLAGS) $< -c -o $@
$(BUILDDIR)/entry.o: entry.$(BITS).S
	as --$(BITS) $^ -o $@

$(BUILDDIR)/test-prog: test.c $(BUILDDIR)/libsyscall.a
	$(CC) $(ALL_CFLAGS) $^ -o $@
	strip -s -R .comment $@

.PHONY: clean test

test: $(BUILDDIR)/test-prog
	($<; echo $$?) 2>&1 | tee $(BUILDDIR)/test-results
	cmp $(BUILDDIR)/test-results expected-test-results
	@echo "Passed minimal tests!"

clean:
	rm -f $(OBJS) $(BUILDDIR)/test-prog $(BUILDDIR)/syscall.c $(BUILDDIR)/libsyscall.h $(BUILDDIR)/libsyscall.a $(BUILDDIR)/test-results
