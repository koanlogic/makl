#
# $Id: dist.mk,v 1.26 2010/04/26 08:42:49 tho Exp $
#
# User Variables:
# - PKG_NAME        Name of the package
# - PKG_VERSION     Version number
# - PKG_NODIR		No base directory in package
# - ZIP             Compression utility
# - ZIPEXT          Compressed file extension
# - TAR             tar command
# - TAR_ARGS        Arguments to tar(1)
# - DISTFILES       List of files to be added to distribution
# - DISTREMAP       Ordered couplets of file name in cvs-src and its alias in
#                   distribution
# - DISTRECIPE      Name of the file containing the list of files to be 
#                   included
#
# Available targets: 
#   dist, distclean and user defined dist{,clean}-hook-(pre,post)

include priv/funcs.mk

# check preconditions (when target != .help)
ifneq ($(MAKECMDGOALS), .help)
    $(call assert-var, PKG_NAME)
    $(call assert-var, PKG_VERSION)

    ifndef DISTFILES
    ifndef DISTREMAP
    ifndef DISTRECIPE
        $(error at least one of DISTFILES, DISTREMAP or DISTRECIPE must be set)
    endif   # !DISTRECIPE
    endif   # !DISTREMAP
    endif   # !DISTFILES
endif   # !.help

TAR ?= tar
TAR_ARGS ?= cf

ZIP ?= bzip2
ZIPEXT ?= bz2

MD5SUM ?= md5sum

DISTDIR ?= $(PKG_NAME)-$(PKG_VERSION)
DISTNAME ?= $(DISTDIR)

##
## dist target
##
dist: dist-hook-pre realdist tarball dist-hook-post

# targets available to users
dist-hook-pre dist-hook-post:

realdist: normaldist distrecipe remapdist

ifdef DISTFILES
normaldist:
	@for f in $(DISTFILES); do \
		dir=`dirname $$f` && \
		file=`basename $$f` && \
		$(MKINSTALLDIRS) $(DISTDIR)/$$dir && \
		cp -fpR $$dir/$$file $(DISTDIR)/$$dir/$$file ; \
	done
else    # !DISTFILES
normaldist:
endif   # DISTFILES

ifdef DISTRECIPE
distrecipe:
	@cat $(DISTRECIPE) | while read f; do \
		dir=`dirname "$$f"` && \
		file=`basename "$$f"` && \
		$(MKINSTALLDIRS) "$(DISTDIR)/$$dir" && \
		cp -fpR "$$dir/$$file" "$(DISTDIR)/$$dir/$$file" ; \
	done
else    # !DISTFILES
distrecipe:
endif   # DISTFILES


ifdef DISTREMAP
remapdist:
	@set $(DISTREMAP); \
	while test $$# -ge 2 ; do \
		in=$$1 ; shift ; \
		out=$$1 ; shift ; \
		$(MKINSTALLDIRS) $(DISTDIR)/`dirname $$out` && \
		cp -fPR $$in $(DISTDIR)/$$out ; \
	done
else    # !DISTREMAP
remapdist:
endif   # DISTREMAP

olddir=$(shell pwd)
ifdef PKG_NODIR 
tarball:
	@cd $(DISTDIR) && \
	$(TAR) $(TAR_ARGS) $(olddir)/$(DISTNAME).tar . && \
	rm -f $(olddir)/$(DISTNAME).tar.$(ZIPEXT) && \
	$(ZIP) $(olddir)/$(DISTNAME).tar && \
	cd - && \
	$(MD5SUM) $(DISTNAME).tar.$(ZIPEXT) > $(DISTNAME).tar.$(ZIPEXT).md5 && \
	rm -rf $(DISTNAME).tar $(DISTDIR)
else
tarball:
	@$(TAR) $(TAR_ARGS) $(DISTNAME).tar $(DISTDIR) && \
	rm -f $(DISTNAME).tar.$(ZIPEXT) && \
	$(ZIP) $(DISTNAME).tar && \
	$(MD5SUM) $(DISTNAME).tar.$(ZIPEXT) > $(DISTNAME).tar.$(ZIPEXT).md5 && \
	rm -rf $(DISTNAME).tar $(DISTDIR)
endif

##
## distclean target
##
distclean: distclean-hook-pre realdistclean distclean-hook-post

distclean-hook-pre distclean-hook-post:

realdistclean:
	rm -rf $(DISTNAME)*

# Make sure all of the standard targets are defined, even if they do nothing.
all install uninstall clean depend cleandepend:

##
## interface description
##
.help:
	@echo
	@echo "-------------------                                            "
	@echo " Available targets                                             "
	@echo "-------------------                                            "
	@echo "dist      create the distribution tarball and checksum file    "
	@echo "distclean remove the output produced by the dist target        "
	@echo
	@echo "Each target T given above (and also all other standard MaKL    "
	@echo "targets, unless explicitly inhibited) has T-hook-pre and       "
	@echo "T-hook-post companion targets.  These (void) targets are at    "
	@echo "client's disposal and will always be called before and after   "
	@echo "the associated target"
	@echo
	@echo "---------------------                                          "
	@echo " Available variables                                           "
	@echo "---------------------                                          "
	@echo "PKG_NAME      base name of the package                         "
	@echo "PKG_VERSION   package version number                           "
	@echo "DISTFILES     list of all files that shall be included in the  "
	@echo "              tarball"
	@echo "DISTREMAP     ordered couplets of the original file and remap'd"
	@echo "              location                                         "
	@echo "DISTRECIPE    Name of the file containing the list of files    "
	@echo "              to be included                                   "
	@echo "ZIP           compression utility to use                       "
	@echo "ZIPEXT        compressed file extension                        "
	@echo "TAR           tar(1) compatible command to use                 "
	@echo "TAR_ARGS      arguments to TAR                                 "
	@echo "MD5SUM        tool used to compute the tarball checksum        "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/dist.mk   "
	@echo
