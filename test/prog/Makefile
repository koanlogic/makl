include common.mk
include ../Makefile.conf

PROG = prog
SRCS = prog.c
CFLAGS += -I../include

LDFLAGS += -L../lib -lx
DPADD += ../lib/libx.a

include prog.mk

# define test procedure
test: 
	@env DYLD_LIBRARY_PATH=../lib LD_LIBRARY_PATH=../lib ./$(PROG)
