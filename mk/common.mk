#
# $Id: common.mk,v 1.2 2006/11/10 09:24:07 tho Exp $
#
# Common include, to be placed on top of your Makefile, so that the following
# includes and variables' settings can override toolchain and map values.

.DEFAULT_GOAL := all

include ../etc/toolchain.mk
include ../etc/map.mk
