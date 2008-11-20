# $Id: Makefile,v 1.4 2008/11/20 10:40:39 stewy Exp $

include common.mk
include ../../Makefile.conf

MANFILES = $(XML_SRCS:.xml=)

XML_SRCS = $(wildcard *.1.xml)

%.1 : %.1.xml ; rm -f $@ && "$(PATH_XML2MAN)" $< $@

install-hook-pre: $(MANFILES)

clean: ; rm -f $(MANFILES)

hint: ; @echo "groff -Wall -mtty-char -Tascii -mandoc -c <page>"

include man.mk
