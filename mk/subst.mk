#
# $Id: subst.mk,v 1.10 2008/05/08 15:53:35 tho Exp $
#
# User variables:    
# - SUBST_RULE      substitution rule (see further on)
# - SUBST_SUFFIX    if a substitution is requested to have output file X the 
#                   input file is read from X.$(SUBST_SUFFIX)
#
# Available targets: 
#   subst
#
# We have two different kind of SUBST_RULE: shortcut and full.  If SUBST_SUFFIX 
# is defined, then SUBST_RULE = <output_file> <"sed(1) command">, otherwise
# SUBST_RULE = <input_file> <output_file> <"sed(1) command">.
#
# NOTE: a '$' sign in the sed(1) command must be escaped (i.e. '$$') if you
# want it to survive the GNU make variable expansion, e.g.:
#   => SUBST_RULE = A.in A.out "s/\!$$/\?/g" 
# results into:
#   => sed 's/\!$/\?/g' A.in > A.out

include priv/funcs.mk

# check preconditions (when target != .help)
ifneq ($(MAKECMDGOALS), .help)
    $(call assert-var, SUBST_RULE)
endif

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

##
## interface description
##
.help:
	@echo
	@echo "-------------------                                              "
	@echo " Available targets                                               "
	@echo "-------------------                                              "
	@echo "subst         do the requested substitutions                     "
	@echo
	@echo "---------------------                                            "
	@echo " Available variables                                             "
	@echo "---------------------                                            "
	@echo "SUBST_RULE    substitution rule (see further on)                 "
	@echo "SUBST_SUFFIX  if a substitution is requested to have output file "
	@echo "              X the input file is read from X.\$$SUBST_SUFFIX"
	@echo
	@echo "We have two different kind of SUBST_RULE: shortcut and full.     "
	@echo "If SUBST_SUFFIX is defined, then                                 "
	@echo "      SUBST_RULE = <output_file> <sed(1) command>                "
	@echo "otherwise                                                        "
	@echo "      SUBST_RULE = <input_file> <output_file> <sed(1) command>.  "
	@echo
	@echo "NOTE: a \$$ sign in the sed(1) command must be escaped           "
	@echo "(i.e. '\$$\$$') if you want it to survive the GNU make variable  "
	@echo "expansion, e.g.:                                                 "
	@echo "      SUBST_RULE = A.in A.out "s/\\!\$$\$$/\\?/g"                "
	@echo "results into:                                                    "
	@echo "      => sed 's/\!\$$/\?/g' A.in > A.out                         "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/subst.mk    "
	@echo
