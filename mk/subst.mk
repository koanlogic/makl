#
# $Id: subst.mk,v 1.6 2008/02/29 11:16:14 tho Exp $
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

# check preconditions
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

##
## interface description
##
.help:
	@$(ECHO)
	@$(ECHO) "-------------------                                              "
	@$(ECHO) " Available targets                                               "
	@$(ECHO) "-------------------                                              "
	@$(ECHO) "subst         do the requested substitutions                     "
	@$(ECHO)
	@$(ECHO) "---------------------                                            "
	@$(ECHO) " Available variables                                             "
	@$(ECHO) "---------------------                                            "
	@$(ECHO) "SUBST_RULE    substitution rule (see further on)                 "
	@$(ECHO) "SUBST_SUFFIX  if a substitution is requested to have output file "
	@$(ECHO) "              X the input file is read from X.\$$SUBST_SUFFIX"
	@$(ECHO)
	@$(ECHO) "We have two different kind of SUBST_RULE: shortcut and full.     "
	@$(ECHO) "If SUBST_SUFFIX is defined, then                                 "
	@$(ECHO) "      SUBST_RULE = <output_file> <sed(1) command>                "
	@$(ECHO) "otherwise                                                        "
	@$(ECHO) "      SUBST_RULE = <input_file> <output_file> <sed(1) command>.  "
	@$(ECHO)
	@$(ECHO) "NOTE: a \$$ sign in the sed(1) command must be escaped           "
	@$(ECHO) "(i.e. '\$$\$$') if you want it to survive the GNU make variable  "
	@$(ECHO) "expansion, e.g.:                                                 "
	@$(ECHO) "      SUBST_RULE = A.in A.out "s/\\!\$$\$$/\\?/g"                "
	@$(ECHO) "results into:                                                    "
	@$(ECHO) "      => sed 's/\!\$$/\?/g' A.in > A.out                         "
	@$(ECHO)
