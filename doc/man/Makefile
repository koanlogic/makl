# $Id: Makefile,v 1.3 2008/10/21 19:10:33 tho Exp $

include common.mk
include ../../Makefile.conf

MANFILES = $(XML_SRCS:.xml=)

XML_SRCS = $(wildcard *.1.xml)

%.1 : %.1.xml ; rm -f $@ && xml2man $< $@

install-hook-pre: $(MANFILES)

clean: ; rm -f $(MANFILES)

hint: ; @echo "groff -Wall -mtty-char -Tascii -mandoc -c <page>"

include man.mk
