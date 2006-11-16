include common.mk
include ../Makefile.conf

PROG = maklsh
INSTALL_STRIP =

all depend cleandepend:

install-hook-post:
	ln -s $(BINDIR)/$(PROG) $(BINDIR)/makl
	ln -s $(BINDIR)/$(PROG) $(BINDIR)/maklconf

uninstall-hook-pre:
	rm -f $(BINDIR)/makl
	rm -f $(BINDIR)/maklconf

include prog.mk
