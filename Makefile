#
# $Id: Makefile,v 1.29 2006/12/10 19:50:53 tho Exp $
#
# User Variables:
# - MAKLRC          file name for hosting MaKL env variables
# - LOGIN_SHELL     user shell
# - MAKL_SHLIB      shared library file
# - MAKL_TC         toolchain file
# - MAKL_PLATFORM   forces MAKL_SHLIB and MAKL_TC
#
# Available targets:
#   all help hints toolchain env install uninstall clean

# this one needs to be exported in the 'toolchain' target
export MAKL_DIR := $(shell pwd)

# these are available after 'toolchain' actions
-include etc/toolchain.mk
-include etc/map.mk

# this will be available after the 'configure' stage
-include Makefile.conf

MAKL_VERSION = $(shell cat $(MAKL_DIR)/VERSION)

# set sensible defaults if not already set by the user
LOGIN_SHELL ?= sh
MAKLRC ?= $(MAKL_DIR)/makl.env

# catchall and 'help' targets display a menu of available options
all help:
	@echo
	@echo "# MaKL version $(MAKL_VERSION) - (c) 2005-2006 - KoanLogic srl"
	@echo "Available targets:"
	@echo
	@echo "   * help        print this menu"
	@echo "   * hints       output environment variables"
	@echo "   * toolchain   install platform toolchain files"
	@echo "   * rc          generate a file containing runtime MaKL variables"
	@echo "   * env         same as 'rc' but interactively"
	@echo "   * clean       remove autogenerated toolchain files"
	@echo "   * install     install a system wide MaKL (needs configure step)"
	@echo "   * uninstall   delete MaKL installed objects from host"
	@echo

# 'toolchain' target does shared libs and toolchain installation for the 
# host platform
toolchain:
	@[ ! -z $(MAKL_PLATFORM) ] && \
        tc_env="MAKL_TC=${MAKL_PLATFORM} MAKL_SHLIB=${MAKL_PLATFORM}" ; \
	env $$tc_env setup/tc_setup.sh

# 'env' (interactively) and 'rc' (unattendedly) targets create a suitable 
# (i.e. user login shell specific) $MAKLRC file
env rc:
	@interactive=0 ; \
	[ "$(MAKECMDGOALS)" = env ] && interactive=1 ; \
	setup/env_setup.sh $(MAKL_DIR) $(MAKL_VERSION) $(LOGIN_SHELL) \
        $(MAKLRC) $$interactive

# hints displays suggested env variables settings 
hints:
	@setup/shell_setup.sh $(MAKL_DIR)

# 'uninstall' and 'install' targets need the configure step and 'toolchain' 
# target as dependencies
install uninstall: $(MAKL_DIR)/Makefile.conf toolchain
	@for d in misc bin cf mk tc etc shlib helpers setup ; do \
	    $(MAKE) -I$(MAKL_DIR)/mk -C $$d $(MAKECMDGOALS) ; \
	done ; \
	if [ "$(MAKECMDGOALS)" = uninstall ] ; then \
	    rm -rf $(MAKL_ROOT) ; \
	fi

# warn if the configure step has not been already performed
$(MAKL_DIR)/Makefile.conf:
	@echo "first you have to run ./configure --gnu_make=..." && exit 1

# remove files possibly created by other targets (env, rc, toolchain) and
# by the configure step
clean:
	rm -f $(MAKLRC)
	rm -f $(MAKL_DIR)/etc/toolchain.mk
	rm -f $(MAKL_DIR)/etc/toolchain.cf
	rm -f $(MAKL_DIR)/mk/priv/shlib.mk
	rm -f Makefile.conf
