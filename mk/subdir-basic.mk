# $Id: subdir-basic.mk,v 1.2 2008/05/21 12:02:06 tho Exp $

.PHONY: subdirs $(SUBDIR)

%: subdirs ;

subdirs: $(SUBDIR)

$(SUBDIR):
	@$(MAKE) -C $@ $(MAKECMDGOALS)
