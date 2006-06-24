#
# $Id: deps.mk,v 1.7 2006/06/24 01:00:26 tho Exp $
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
_YSRCS = $(wildcard *.y)
ifneq ($(_YSRCS),)
    YFLAGS = -d
    CLEANFILES += y.tab.h
    LDADD += -ly
endif
_LSRCS = $(wildcard *.l)
ifneq ($(_YSRCS),)
    LDADD += -ll
endif
endif

depend: beforedepend realdepend afterdepend

beforedepend:

realdepend:
	touch $(DEPENDFILE)
	$(MKDEP) -f $(DEPENDFILE) $(CFLAGS) -a $(SRCS)

afterdepend:
ifdef PROG
ifdef DPADD
	echo $(PROG): $(DPADD) >> $(DEPENDFILE)
endif
ifdef LDADD
	echo $(PROG): $(LDADD) >> $(DEPENDFILE)
endif
endif

cleandepend:
	rm -f $(DEPENDFILE)

-include $(DEPENDFILE)
