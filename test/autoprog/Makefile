include ../Makefile.conf
include common.mk

PARTY_URL = http://www.monkey.org/~provos/
PARTY_NAME = libevent-1.1b
PARTY_ARGS = --prefix=`pwd`/inst/

PARTY_CONF = ./configure
PARTY_NO_INSTALL = true

ifdef MAKL_PLATFORM
# cross-compiling
# autotools configure --host param must be the prefix of the filename the GNU 
# tools: for example m68k-linux-{gcc,ld,ar,...} --host must be m68k-linux
PARTY_ARGS = --host=$(subst -gcc,,$(word 1,$(CC)))
endif

include party.mk

test: all
