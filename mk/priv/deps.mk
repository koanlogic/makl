#
# $Id: deps.mk,v 1.8 2008/10/10 08:55:35 tho Exp $
#
# User variables:
# SRCS      C sources to be included in the dependency list.
# DPADD     Add generic files to the dependency list.
# LDADD     Add archive files to the dependency list.
# 
# Available targets:
# - depend
# - cleandepend

DEPENDFILE ?= .depend

##
## depend target
##
ifndef NO_DEPEND
depend: depend-hook-pre realdepend afterdepend depend-hook-post

depend-hook-pre depend-hook-post:

ifdef __SRCDIR
__SRCS = $(foreach s, $(SRCS), $(__SRCDIR)/$(s))
else
__SRCS = $(SRCS)
endif

realdepend:
	touch $(DEPENDFILE)
	$(MKDEP) -f $(DEPENDFILE) $(CFLAGS) -a $(__SRCS)

afterdepend: realdepend
ifdef __PROG
ifdef DPADD
	echo $(__PROG): $(DPADD) >> $(DEPENDFILE)
endif
ifdef LDADD
	echo $(__PROG): $(LDADD) >> $(DEPENDFILE)
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

else
depend:
endif

##
## cleandepend target
##
ifndef NO_CLEANDEPEND
cleandepend: cleandepend-hook-pre realcleandepend cleandepend-hook-post

cleandepend-hook-pre cleandepend-hook-post:

realcleandepend:
	rm -f $(DEPENDFILE)

else
cleandepend:
endif

-include $(DEPENDFILE)

# Lex/YACC deps work this way (does this belongs here ?):
# the grammar 'grammar-file.y' is translated into 'grammar-file.c' and its
# header 'y.tab.h' is also produced, while the lexical analyzer 'lexical-file.l'
# which must #include 'y.tab.h') is translated into 'lexical-file.c'.
# The grammar file MUST precede the lexical file in SRCS definition:
# SRCS = ... grammar-file.c lexical-file.c ...
#
# NOTE that basename of grammar and lexical files must differ from that of any 
# other source file which otherwise would be overwritten/lost.
ifndef NO_LY_AUTODEP
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
endif   # NO_LY_AUTODEP
