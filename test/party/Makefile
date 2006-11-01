# $Id: Makefile,v 1.1 2006/11/01 20:33:17 stewy Exp $
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
	gcc -o $(TEST_PROG) main.c $(TEST_PARTY)
	./$(TEST_PROG) 
	@$(ECHO) "[[ TEST OK! ]]"

afterclean:
	rm -f $(TEST_PROG)
