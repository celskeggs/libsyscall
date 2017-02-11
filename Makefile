include config.mk

.PHONY: main install test clean

main:
	cd $(PSRCDIR) && make

install:
	cd $(PSRCDIR) && make install

test:
	cd $(PSRCDIR) && make test

clean:
	cd $(PSRCDIR) && make clean

distclean: clean
	rm -f $(PSRCDIR)/config.mk config.mk config.status
