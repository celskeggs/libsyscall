include config.mk

.PHONY: main clean

main:
	cd $(PSRCDIR) && make

clean:
	cd $(PSRCDIR) && make clean

distclean: clean
	rm -f $(PSRCDIR)/config.mk config.mk config.status
