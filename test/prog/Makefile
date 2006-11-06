include common.mk
include ../Makefile.conf

PROG = prog
SRCS = prog.c
CFLAGS += -I../include

LDFLAGS += -L../lib -lx
DPADD += ../lib/libx.a

#BINOWN = pippo
#BINGRP = pluto 

include prog.mk

# define test procedure
test: 
