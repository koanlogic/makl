# $Id: distclean.mk,v 1.1 2008/06/13 21:10:26 tho Exp $

ifdef DISTCLEANFILES
distclean: clean
	$(RM) $(DISTCLEANFILES)
else
distclean: clean
endif
