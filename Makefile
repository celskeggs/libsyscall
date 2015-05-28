include config.mk

.PHONY: main test clean

main:
	cd $(PSRCDIR) && make

test:
	cd $(PSRCDIR) && make test

clean:
	cd $(PSRCDIR) && make clean

distclean: clean
	rm -f $(PSRCDIR)/config.mk config.mk config.status
