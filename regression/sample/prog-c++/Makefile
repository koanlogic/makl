include common.mk
include Makefile.conf

USE_CXX = true

PROG = test-c++
SRCS = main.cc

CFLAGS += -I$(SRCDIR)/include

ifdef SHLIB
LDFLAGS += -L$(SRCDIR)/lib/libmyc/$(PAD) -lmyc
LDFLAGS += -L$(SRCDIR)/lib/libmyc++/$(PAD) -lmyc++
else
LDADD += $(SRCDIR)/lib/libmyc/$(PAD)/libmyc.a
LDADD += $(SRCDIR)/lib/libmyc++/$(PAD)/libmyc++.a
endif

include prog.mk
include objdir-resolve.mk
