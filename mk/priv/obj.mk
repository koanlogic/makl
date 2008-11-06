# $Id: obj.mk,v 1.4 2008/11/06 12:40:47 tho Exp $

# sanitize OBJDIR
ifeq ($(OBJDIR),)
    $(error OBJDIR must be non-empty)
endif

# reset all rules as we rely on prog.mk and lib.mk to tell us how to do things
.SUFFIXES:

# try to get the file name for the source Makefile that lead us here
MAKEFN = $(firstword $(basename $(MAKEFILE_LIST)))

# assemble the make command that will reinvoke the build in OBJDIR
MAKEOBJ = $(MAKE) -C $@ -f $(CURDIR)/$(MAKEFN) __SRCDIR=$(CURDIR) \
          $(MAKECMDGOALS)

# relocate into OBJDIR (creating it if it doesn't exist) and re-invoke make 
# there.  the '+' is for performing subdir creation even when the -n option 
# is given
.PHONY: $(OBJDIR)
$(OBJDIR): 
	+@[ -d $@ ] || $(MKINSTALLDIRS) $@
	+@$(MAKEOBJ) 

# tell GNU make to rebuild neither the calling Makefile nor any included MaKL 
# template in the OBJDIR
$(MAKEFN) : ;
%.mk :: ;

# since we've reset all the rules we need to tell GNU make what to do, so
# the following match-any (%) terminating (::) rule - which in turn depends 
# on the OBJDIR rule - is added.  that's in fact the trampoline to jump into
# OBJDIR and do the job.
% :: $(OBJDIR) ;

# put a specific (more simple) 'clean' target here which overrides the 
# prog/lib settings
.PHONY: clean
clean:
ifneq ($(OBJDIR),/)
	-rm -f $(OBJDIR)/* && rmdir $(OBJDIR)
endif
