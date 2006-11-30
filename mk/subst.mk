# $Id: subst.mk,v 1.3 2006/11/30 00:31:52 tho Exp $
#
# targets: subst
#
# variables:    
#   SUBST_RULE      substitution rule (see further on)
#   SUBST_SUFFIX    if a substitution is requested to have output file X the 
#                   input file is read from X.$(SUBST_SUFFIX)
#
# we have two different kind of SUBST_RULE, shortcut and full: if SUBST_SUFFIX 
# is defined, then SUBST_RULE = <output_file> <"sed(1) command">, otherwise
# SUBST_RULE = <input_file> <output_file> <"sed(1) command">.
#
# NOTE: a '$' sign in the sed(1) command must be escaped (i.e. '$$') if it 
# wants to survive the GNU make variable expansion:
#   => SUBST_RULE = A.in A.out "s/\!$$/\?/g" 
# results into:
#   => sed 's/\!$/\?/g' A.in > A.out

ifndef SUBST_RULE
subst:
	$(warning SUBST_RULE must be defined when including subst.mk template !)
else    # SUBST_RULE
subst:
ifndef SUBST_SUFFIX
	@set $(SUBST_RULE) ; \
	while [ $$# -ge 3 ]; \
	do \
	    fin=$$1 ; shift ; \
	    fout=$$1 ; shift ; \
	    rule=$$1 ; shift ; \
	    echo "sed '"$$rule"' $$fin > $$fout" ; \
	    sed -e "$$rule" $$fin > $$fout ; \
	done
else    # SUBST_SUFFIX
	@set $(SUBST_RULE) ; \
	while [ $$# -ge 2 ]; \
	do \
	    fout=$$1 ; fin=$$fout.$(SUBST_SUFFIX) ; shift ; \
	    rule=$$1 ; shift ; \
	    echo "sed '"$$rule"' $$fin > $$fout" ; \
	    sed -e "$$rule" $$fin > $$fout ; \
	done
endif   # !SUBST_SUFFIX
endif   # !SUBST_RULE
