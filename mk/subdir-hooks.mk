# $Id: subdir-hooks.mk,v 1.2 2008/05/21 12:02:06 tho Exp $

.PHONY: subdirs $(SUBDIR)

# the following implies each generated template
subdirs: $(MAKECMDGOALS)

# subdir_mk template generator
# $1 = goal 
# $2 = subdir list
define subdir_mk
    $(1)_SUBGOAL = $(addsuffix .$(1),$(2))
    $(1): $(1)-pre $$($(1)_SUBGOAL) $(1)-post
    $(1)-pre $(1)-post:
    $$($(1)_SUBGOAL) : %.$(1): ; @$(MAKE) -C $$* $(1)
    .PHONY: $(1) $$($(1)_SUBGOAL) $(1)-pre $(1)-post
endef

# create rules using the subdir_mk template for each supplied target 
$(foreach T,$(MAKECMDGOALS),$(eval $(call subdir_mk,$(T),$(SUBDIR))))
