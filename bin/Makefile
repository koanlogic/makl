# $Id: Makefile,v 1.12 2008/10/11 19:24:57 tho Exp $

include common.mk
include ../Makefile.conf

SCRIPT = maklsh

# $1 name is framed with prefix and suffix
frame-it = $(strip $(SCRIPT_PREFIX))$(strip $(1))$(strip $(SCRIPT_SUFFIX))

LINKS =  $(call frame-it, makl)

# recommended cmd format
LINKS += $(call frame-it, makl-conf)
LINKS += $(call frame-it, makl-help)
LINKS += $(call frame-it, makl-tc)
LINKS += $(call frame-it, makl-new)

# compat cmd format (pre 1.6.0)
LINKS += $(call frame-it, maklconf)
LINKS += $(call frame-it, maklhelp)
LINKS += $(call frame-it, makltc)
LINKS += $(call frame-it, maklnew)

# dependency on 'all' goal is needed to do script aliasing
install-hook-pre: all

install-hook-post:
	for f in $(LINKS) ; do                      \
	    rm -f $(BINDIR)/$$f ;                   \
	    ln -s $(BINDIR)/$(call frame-it, $(SCRIPT)) $(BINDIR)/$$f ; \
	done

uninstall-hook-pre:
	for f in $(LINKS) ; do      \
	    rm -f $(BINDIR)/$$f ;   \
	done

include script.mk

SUBDIR = lib

include subdir.mk
