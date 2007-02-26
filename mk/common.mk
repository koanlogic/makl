#
# $Id: common.mk,v 1.4 2007/02/26 20:27:14 tat Exp $
#
# Common include, to be placed on top of your Makefile, so that the following
# includes and variables' settings can override toolchain and map values.

include ../etc/toolchain.mk
-include $(MAKL_TC_DIR)/toolchain.mk
include ../etc/map.mk
