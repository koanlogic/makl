# $Id: obj.mk,v 1.2 2008/10/09 21:42:47 tho Exp $

.SUFFIXES:

MAKEFN = $(firstword $(basename $(MAKEFILE_LIST)))
MAKEOBJ = $(MAKE) -C $@ -f $(CURDIR)/$(MAKEFN) SRCDIR=$(CURDIR) $(MAKECMDGOALS)

.PHONY: $(OBJDIR) 

# + is for performing subdir creation even when the -n option is given
#   +@[ -d $@ ] || mkdir -p $@ 
$(OBJDIR): 
	+@[ -d $@ ] || $(MKINSTALLDIRS) $@
	+@$(MAKEOBJ) 

Makefile : ; 
%.mk :: ; 

% :: $(OBJDIR) ;

.PHONY: clean
clean:
	-rm $(OBJDIR)/*
