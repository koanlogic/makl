include common.mk
include ../Makefile.conf

PROG = prog
SRCS = prog.c
CFLAGS += -I../include
CFLAGS += -I/Users/tho/tmp/LIBU/include

LDFLAGS += -L../lib -lx
LDFLAGS += -L/Users/tho/tmp/LIBU/lib -lu.0.4.1

DPADD += ../lib/libx.a
DPADD += /Users/tho/tmp/LIBU/lib/libu.a

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
