# $Id: funcs.mk,v 1.1 2006/11/06 09:37:01 tho Exp $
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
