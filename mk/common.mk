#
# $Id: common.mk,v 1.6 2007/06/26 10:19:56 tho Exp $
#
# Common include, to be placed on top of your Makefile, so that the following
# includes and variables' settings can override toolchain and map values.

MAKL_ETC ?= ../etc

include ../etc/toolchain.mk
-include $(MAKL_ETC)/toolchain.mk
include ../etc/map.mk
