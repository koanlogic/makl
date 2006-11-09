#
# $Id: dist.mk,v 1.10 2006/11/09 15:19:12 tho Exp $
#
# User Variables:
# - PKG_NAME        Name of the package
# - PKG_VERSION     Versione number
# - ZIP             Compression utility
# - DISTFILES       List of files to be added to distribution
# - DISTREMAP       Ordered couplets of file name in cvs-src and its alias in
#                   distribution
#
# Available targets: 
#   dist,distclean and user defined dist-hook-(pre,post)

# TODO check that user has set PKG_* and DISTFILES variables
# TODO remap directories/files

ZIP ?= bzip2
ZIPEXT ?= bz2

MD5SUM = md5sum

DISTDIR=$(PKG_NAME)-$(PKG_VERSION)

dist: dist-hook-pre realdist afterdist dist-hook-post

# targets available to users
dist-hook-pre:
dist-hook-post:

realdist: normaldist remapdist

normaldist:
	@for f in $(DISTFILES); do \
		dir=`dirname $$f` && \
		file=`basename $$f` && \
		$(MKINSTALLDIRS) $(DISTDIR)/$$dir && \
		cp $$dir/$$file $(DISTDIR)/$$dir/$$file ; \
	done

ifneq ($(DISTREMAP),)
remapdist:
	@set $(DISTREMAP); \
	while test $$# -ge 2 ; do \
		in=$$1 ; shift ; \
		out=$$1 ; shift ; \
		$(MKINSTALLDIRS) $(DISTDIR)/`dirname $$out` && \
		cp -f $$in $(DISTDIR)/$$out ; \
	done
else
remapdist:
endif

afterdist:
	@tar cf $(DISTDIR).tar $(DISTDIR) && \
	rm -f $(DISTDIR).tar.$(ZIPEXT) && \
	$(ZIP) $(DISTDIR).tar && \
	$(MD5SUM) $(DISTDIR).tar.$(ZIPEXT) > $(DISTDIR).tar.$(ZIPEXT).md5 && \
	rm -rf $(DISTDIR).tar $(DISTDIR)

distclean:
	rm -rf $(DISTDIR).tar* $(DISTDIR)

# Make sure all of the standard targets are defined, even if they do nothing.
all install uninstall clean depend cleandepend:
