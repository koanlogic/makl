# $Id: Makefile,v 1.11 2008/10/11 15:15:48 tho Exp $

include common.mk
include ../Makefile.conf

BINDIR = /tmp/bin

MAKLSH = maklsh

FILES = $(MAKLSH)
FILES += maklsh_funcs
FILES += maklsh_catalog
FILES += maklsh_conf
FILES += maklsh_funcs
FILES += maklsh_help
FILES += maklsh_new
FILES += maklsh_run
FILES += maklsh_tc
FILES_DIR = $(BINDIR)
FILES_MODE = 0755

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
	    ln -s $(BINDIR)/$(call frame-it, $(MAKLSH)) $(BINDIR)/$$f ; \
	done

uninstall-hook-pre:
	for f in $(LINKS) ; do      \
	    rm -f $(BINDIR)/$$f ;   \
	done

include files.mk
