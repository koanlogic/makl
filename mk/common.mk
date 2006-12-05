#
# $Id: common.mk,v 1.3 2006/12/05 09:39:02 tho Exp $
#
# Common include, to be placed on top of your Makefile, so that the following
# includes and variables' settings can override toolchain and map values.

.DEFAULT_GOAL := all

include ../etc/toolchain.mk
-include $(MAKL_TC_DIR)/toolchain.mk
include ../etc/map.mk
