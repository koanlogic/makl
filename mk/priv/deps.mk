#
# $Id: deps.mk,v 1.3 2006/11/10 20:56:15 tho Exp $
#
# User variables:
# SRCS      C sources to be included in the dependency list.
# DPADD     Add generic files to the dependency list.
# LDADD     Add archive files to the dependency list.
# 
# Available targets:
# - depend, broken up into (before,real,after)depend
# - cleandepend

DEPENDFILE ?= .depend

# Lex/YACC deps work this way:
# the grammar 'grammar-file.y' is translated into 'grammar-file.c' and its
# header 'y.tab.h' is also produced, while the lexical analyzer 'lexical-file.l'
# which must #include 'y.tab.h') is translated into 'lexical-file.c'.
# The grammar file MUST precede the lexical file in SRCS definition:
# SRCS = ... grammar-file.c lexical-file.c ...
#
# NOTE that basename of grammar and lexical files must differ from that of any 
# other source file which otherwise would be overwritten/lost.

ifdef SRCS
__YSRCS = $(wildcard *.y)
ifneq ($(__YSRCS),)
    YFLAGS = -d
    CLEANFILES += y.tab.h
    LDADD += -ly
endif
__LSRCS = $(wildcard *.l)
ifneq ($(__LSRCS),)
    LDADD += -ll
endif
endif

depend: beforedepend realdepend afterdepend

beforedepend:

realdepend:
	touch $(DEPENDFILE)
	$(MKDEP) -f $(DEPENDFILE) $(CFLAGS) -a $(SRCS)

afterdepend: realdepend
ifdef PROG
ifdef DPADD
	echo $(PROG): $(DPADD) >> $(DEPENDFILE)
endif
ifdef LDADD
	echo $(PROG): $(LDADD) >> $(DEPENDFILE)
endif
endif
ifdef SHLIB
	@(tmpfile=`mktemp /tmp/__depend.XXXXXX`; \
	if [ $$? -ne 0 ]; then \
	    echo "$$0: cannot create temp file, exiting ..."; \
	    exit 1; \
	fi; \
	sed -e 's/^\([^\.]*\).o[ ]*:/\1.o \1.so:/' < .depend > $$tmpfile; \
	mv $$tmpfile .depend)
endif

cleandepend:
	rm -f $(DEPENDFILE)

-include $(DEPENDFILE)
