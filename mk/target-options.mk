# $Id: target-options.mk,v 1.2 2007/02/23 10:38:36 tat Exp $
#
# Variables:
# - ALL			A list of targets. Each target can be hooked with -pre or -post
#               suffixes. 
# - RUNONCE		A list of targets in $ALL to be executed just once.
#
# Applicable Targets:
# - any target in $ALL and their -pre/-post helper targets

ifndef ALL
$(error ALL variable must be defined)
endif

target-options-default:
	@for target in $(ALL); do \
 	    $(MAKE) HOOK_T=$${target} $${target}-make; \
        [ $$? = 0 ] || exit $$? ; \
 	done;

ifdef HOOK_T
.PHONY: $(HOOK_T)-pre $(HOOK_T)-post $(HOOK_T)-make
FLAG=.real-$(HOOK_T)

$(HOOK_T)-pre:
$(HOOK_T)-post:
 
# options bool flags
OPT_ONCE = $(filter once, $($(HOOK_T)-options))

# run once
$(HOOK_T)-make: $(FLAG)

$(FLAG):
	@$(MAKE) HOOK_T=$(HOOK_T) $(HOOK_T)-pre $(HOOK_T) $(HOOK_T)-post
	@if [ "$(OPT_ONCE)" ]; then \
		touch $(FLAG) ; \
	 fi

endif

clean-flags:
	@rm -f .real*

clean: clean-flags

purge: clean


