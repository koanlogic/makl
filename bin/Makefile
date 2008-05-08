# $Id: Makefile,v 1.9 2008/05/08 16:20:28 tho Exp $

include common.mk
include ../Makefile.conf

SCRIPT = maklsh
LINKS = makl maklconf maklhelp makltc maklnew
LINKS += makl-conf makl-help makl-tc makl-new

install-hook-post:
	for f in $(LINKS) ; do                      \
	    rm -f $(BINDIR)/$$f ;                   \
	    ln -s $(BINDIR)/$(PROG) $(BINDIR)/$$f ; \
	done

uninstall-hook-pre:
	for f in $(LINKS) ; do      \
	    rm -f $(BINDIR)/$$f ;   \
	done

include script.mk
