# $Id: funcs.mk,v 1.2 2008/05/05 15:25:31 tho Exp $
#
# common functions

# create __CHOWN_ARGS for 'beforeinstall' target, i.e.:
#   __CHOWN_ARGS = $(call calc-chown-args, $(XXXOWN), $(XXXGRP))
# $1 = owner
# $2 = group
define calc-chown-args
$(if $(strip $(2)),             \
        $(1):$(strip $(2)),     \
        $(if $(1),              \
            $(1)                \
        )                       \
)
endef

# create __INSTALL_ARGS for 'realinstall' target, i.e.:
#   __INSTALL_ARGS = $(call calc-install-args, $(XXXOWN), $(XXXGRP))
# $1 = owner
# $2 = group
define calc-install-args
$(if $(strip $(1)),             \
        $(if $(strip $(2)),     \
            -o$(1) -g$(2),      \
            -o$(1)              \
        ),                      \
        $(if $(strip $(2)),     \
            -g$(2)              \
        )                       \
)
endef

# subdir makefile template (used by subdir.mk)
# $1 = goal 
# $2 = subdir list
define subdir_mk
    $(1)_SUBGOAL = $(addsuffix .$(1),$(2))
    $(1): $(1)-pre $$($(1)_SUBGOAL) $(1)-post
    $(1)-pre $(1)-post:
    $$($(1)_SUBGOAL) : %.$(1): ; @$(MAKE) -C $$* $(1)
    .PHONY: $(1) $$($(1)_SUBGOAL) $(1)-pre $(1)-post
endef
