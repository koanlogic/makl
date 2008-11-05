include common.mk
include Makefile.conf

PROG = test-c
SRCS = main.c

CFLAGS += -I$(SRCDIR)/include

ifdef SHLIB
LDFLAGS += -L$(SRCDIR)/lib/libmyc/$(PAD) -lmyc
else
LDADD += $(SRCDIR)/lib/libmyc/$(PAD)/libmyc.a
endif

include prog.mk
include objdir-resolve.mk
