include common.mk
include ../Makefile.conf

LIB = x
SRCS = a.c b.c x.cc
CFLAGS += -I../include

USE_CXX = true
# '+=' => in order to inherit CFLAGS settings
CXXFLAGS += -fdollars-in-identifiers 

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

clean-hook-pre:
	@$(ECHO) "==> pre clean action [NONE]"

uninstall-hook-post: uninstall-hook-post-pre
	@$(ECHO) "==> post uninstall action [NONE]"

uninstall-hook-post-pre:
	@$(ECHO) "==> DESTDIR now is: $(DESTDIR)"
