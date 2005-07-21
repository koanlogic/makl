#
# $Id: toolchain.mk,v 1.1.1.1 2005/07/21 18:00:01 tat Exp $
#
# system pathnames for the needed tools
#

CC      ?= cc
CFLAGS  ?= -O -pipe

AR      ?= ar
ARFLAGS ?= rl

RANLIB  ?= ranlib

LD      ?= ld 
LDFLAGS ?=

MKDEP = mkdep

STRIP         ?= strip
STRIP_FLAGS   ?= -X
#STRIP_FLAGS   ?= -x

INSTALL       ?= install
INSTALL_COPY  ?= -c
INSTALL_STRIP ?= -s

