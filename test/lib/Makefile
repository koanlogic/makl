include common.mk
include ../Makefile.conf

LIB = x
SRCS = a.c b.c
CFLAGS += -I../include

SHLIB = true
SHLIB_MAJOR = 1
SHLIB_MINOR = 4
SHLIB_TEENY = 2

#BUNDLE = true
#BUNDLE_EXT = kext

#LIBOWN = pippo
#LIBGRP = pluto

include lib.mk

# define test procedure
test: all

# hook targets 
all-hook-pre:
	@$(ECHO) "==> all-hook-pre action [NONE]"

all-hook-post:
	@$(ECHO) "==> all-hook-post action [NONE]"
