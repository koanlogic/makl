#
# $Id: common.mk,v 1.5 2007/06/25 18:28:17 tho Exp $
#
# Common include, to be placed on top of your Makefile, so that the following
# includes and variables' settings can override toolchain and map values.

include ../etc/toolchain.mk
-include $(MAKL_ETC)/toolchain.mk
include ../etc/map.mk
