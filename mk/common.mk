#
# $Id: common.mk,v 1.9 2007/07/03 14:09:54 tho Exp $
#
# Common include, to be placed on top of your Makefile, so that the following
# includes and variables' settings can override toolchain and map values.

MAKL_ETC ?= ../etc

include $(MAKL_ETC)/toolchain.mk
include ../etc/map.mk
