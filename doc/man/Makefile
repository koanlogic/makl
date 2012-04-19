# $Id: Makefile,v 1.5 2008/11/20 12:00:08 tho Exp $

include common.mk
include ../../Makefile.conf

ifndef NO_MAN

MANFILES = $(XML_SRCS:.xml=)

XML_SRCS = $(wildcard *.1.xml)

%.1 : %.1.xml
ifndef HAVE_XML2MAN
	$(error xml2man required to build man pages!)
else
	rm -f $@ && "$(PATH_XML2MAN)" $< $@
endif

install-hook-pre: $(MANFILES)

clean: ; rm -f $(MANFILES)

hint: ; @echo "groff -Wall -mtty-char -Tascii -mandoc -c <page>"

include man.mk

else    # NO_MAN
%: ;
endif   # !NO_MAN
