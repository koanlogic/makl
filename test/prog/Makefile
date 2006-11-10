include common.mk
include ../Makefile.conf

PROG = prog
SRCS = prog.c
CFLAGS += -I../include

LDFLAGS += -L../lib -lx
DPADD += ../lib/libx.a

BINOWN = pippo
BINGRP = pluto 

CLEANFILES += .before

include prog.mk

# define test procedure
test: 

.before:
	@touch .before

all-hook-pre: .before
	@$(ECHO) "==> before build action (depends on .before)"

all-hook-post:
	@$(ECHO) "==> after build action"

clean-hook-pre:
	@$(ECHO) "==> pre clean action"

uninstall-hook-pre:
	@$(ECHO) "==> pre uninstall action"
