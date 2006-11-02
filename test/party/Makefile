# $Id: Makefile,v 1.2 2006/11/02 16:32:28 stewy Exp $
# 
# Makefile for 3rd-party package dependencies

include common.mk
include ../Makefile.conf

PARTY_NAME = party

PARTY_NO_DOWN = true
PARTY_NO_CHK = true
PARTY_NO_INSTALL = true

include party.mk

# define test procedure

TEST_PARTY = $(PARTY_NAME)/src/libparty.a
TEST_PROG = test

$(TEST_PROG): $(TEST_PARTY)
	$(CC) -o $(TEST_PROG) main.c $(TEST_PARTY)

afterclean:
	rm -f $(TEST_PROG)
