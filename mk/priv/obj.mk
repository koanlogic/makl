# $Id: obj.mk,v 1.1 2008/10/09 20:58:01 tho Exp $

.SUFFIXES:

MAKEOBJ = $(MAKE) -C $@ -f $(CURDIR)/Makefile SRCDIR=$(CURDIR) $(MAKECMDGOALS)

.PHONY: $(OBJDIR) 

$(OBJDIR): 
	+@[ -d $@ ] || mkdir -p $@ 
	+@$(MAKEOBJ) 

Makefile : ; 
%.mk :: ; 

% :: $(OBJDIR) ;

.PHONY: clean
clean:
	-echo rm $(OBJDIR)/*
