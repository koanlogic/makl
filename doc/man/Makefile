# $Id: Makefile,v 1.2 2008/10/21 15:58:51 tho Exp $

XML_SRCS = $(wildcard *.1.xml)

MAN_PAGES = $(XML_SRCS:.xml=)

%.1 : %.1.xml ; rm -f $@ && xml2man $< $@

all: $(MAN_PAGES)

clean: ; rm -f $(MAN_PAGES)

install: ; @echo "TODO"

hint: ; @echo "groff -Wall -mtty-char -Tascii -mandoc -c <page>"
