# $Id: target-options.mk,v 1.3 2007/02/27 13:54:07 tat Exp $
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
 	    $(MAKE) HOOK_TG=$${target} $${target}-make; \
        [ $$? = 0 ] || exit $$? ; \
 	done;

ifdef HOOK_TG
.PHONY: $(HOOK_TG)-pre $(HOOK_TG)-post $(HOOK_TG)-make
FLAG=.real-$(HOOK_TG)

$(HOOK_TG)-pre:
$(HOOK_TG)-post:
 
# options bool flags
OPT_ONCE = $(filter once, $($(HOOK_TG)-options))

# run once
$(HOOK_TG)-make: $(FLAG)

$(FLAG):
	@$(MAKE) HOOK_TG=$(HOOK_TG) $(HOOK_TG)-pre $(HOOK_TG) $(HOOK_TG)-post
	@if [ "$(OPT_ONCE)" ]; then \
		touch $(FLAG) ; \
	 fi

endif

clean-flags:
	@rm -f .real*

clean: clean-flags

purge: clean


