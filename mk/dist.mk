#
# $Id: dist.mk,v 1.19 2008/02/29 11:16:14 tho Exp $
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
#
# Available targets: 
#   dist, distclean and user defined dist{,clean}-hook-(pre,post)

# check preconditions
ifndef PKG_NAME
$(error PKG_NAME must be set !)
endif
ifndef PKG_VERSION
$(error PKG_VERSION must be set !)
endif
ifndef DISTFILES
ifndef DISTREMAP
$(error at least one of DISTFILES or DISTREMAP must be set !)
endif   # !DISTREMAP
endif   # !DISTFILES

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

realdist: normaldist remapdist

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
	@/bin/echo
	@/bin/echo "-------------------                                            "
	@/bin/echo " Available targets                                             "
	@/bin/echo "-------------------                                            "
	@/bin/echo "dist      create the distribution tarball and checksum file    "
	@/bin/echo "distclean remove the output produced by the dist target        "
	@/bin/echo
	@/bin/echo "Each target T given above (and also all other standard MaKL    "
	@/bin/echo "targets, unless explicitly inhibited) has T-hook-pre and       "
	@/bin/echo "T-hook-post companion targets.  These (void) targets are at    "
	@/bin/echo "client's disposal and will always be called before and after   "
	@/bin/echo "the associated target"
	@/bin/echo
	@/bin/echo "---------------------                                          "
	@/bin/echo " Available variables                                           "
	@/bin/echo "---------------------                                          "
	@/bin/echo "PKG_NAME      base name of the package                         "
	@/bin/echo "PKG_VERSION   package version number                           "
	@/bin/echo "DISTFILES     list of all files that shall be included in the  "
	@/bin/echo "              tarball"
	@/bin/echo "DISTREMAP     ordered couplets of the original file and remap'd"
	@/bin/echo "              location                                         "
	@/bin/echo "ZIP           compression utility to use                       "
	@/bin/echo "ZIPEXT        compressed file extension                        "
	@/bin/echo "TAR           tar(1) compatible command to use                 "
	@/bin/echo "TAR_ARGS      arguments to TAR                                 "
	@/bin/echo
