include common.mk
include ../Makefile.conf

LIB = x
SRCS = a.c b.c
CFLAGS += -I../include
SHLIB = true
BUNDLE = true

LIBOWN = pippo
LIBGRP = pluto

include lib.mk

# define test procedure
test: all

# hook targets 
all-hook-pre:
	@$(ECHO) "all-hook-pre action"

all-hook-post:
	@$(ECHO) "all-hook-post action"
