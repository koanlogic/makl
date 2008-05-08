# $Id: funcs.mk,v 1.4 2008/05/08 08:39:36 tho Exp $
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

# retrieve object files from a set of source files, given a set of extensions
# $1 = sources
# $2 = file extensions' set
define calc-objs
$(strip $(foreach e,$(2),$(patsubst %$(e),%.o,$(filter %$(e),$(1)))))
endef
