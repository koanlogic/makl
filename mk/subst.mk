# $Id: subst.mk,v 1.1 2006/11/28 14:33:00 tho Exp $
#
# targets:      subst
# variables:    SUBST_RULE
# with syntax:  SUBST_RULE = <input_file> <output_file> <"sed(1) command">

ifndef SUBST_RULE
subst:
	$(warning SUBST_RULE must be defined when including subst.mk template !)
else
subst:
	@set $(SUBST_RULE) ; \
	while [ $$# -ge 3 ]; \
	do \
	    fin=$$1 ; shift ; \
	    fout=$$1 ; shift ; \
	    rule=$$1 ; shift ; \
	    echo "sed '"$$rule"' $$fin > $$fout" ; \
	    sed -e "$$rule" $$fin > $$fout ; \
	done
endif
