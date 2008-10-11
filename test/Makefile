export MAKL_DIR=$(shell pwd)/../
MAKEFLAGS := -I ${MAKL_DIR}/mk
MAKLRC = .maklrc

PREFIX=$(shell pwd)/test-inst
CONF_ARGS= -v --prefix=$(PREFIX)

all: toolchain conf build test

conf: Makefile.conf

build: conf
	${MAKE} -f Makefile.subdir 

test: build
	${MAKE} -f Makefile.subdir test

clean: 
	${MAKE} -f Makefile.subdir clean

clean cleandepend: 
	${MAKE} -f Makefile.subdir $(MAKECMDGOALS)

purge: 
	make clean
	rm -f Makefile.conf conf.h
	rm -rf $(PREFIX)

env:
	-@cp .maklrc .maklrc.old 
	@echo export MAKL_DIR=\"${MAKL_DIR}\"        >  ${MAKLRC}
	@echo export MAKEFLAGS=\"-I ${MAKL_DIR}/mk\" >> ${MAKLRC}

Makefile.conf: 
	./configure $(CONF_ARGS)
    
toolchain: ${MAKL_DIR}/etc/toolchain.mk
	
${MAKL_DIR}/etc/toolchain.mk:
	${MAKE} -C ${MAKL_DIR} toolchain

