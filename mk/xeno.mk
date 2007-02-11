#
# $Id: xeno.mk,v 1.2 2007/02/11 10:06:54 tho Exp $
# 
# User Variables:
#
#   - XENO_NAME             Package name
#
#   - XENO_FETCH            Tool to use to retrieve the package srcs or other
#   - XENO_FETCH_FLAGS      Arguments to $XENO_FETCH
#   - XENO_FETCH_URI        Remote resource name
#   - XENO_NO_FETCH         If set the xeno_fetch: target is skipped
#
#   - XENO_UNZIP            Tarball decompression command
#   - XENO_UNZIP_FLAGS      Arguments to be passed to $XENO_UNZIP
#
#   - XENO_PATCH            Patch command
#   - XENO_PATCH_FLAGS      Arguments to be passed to $XENO_PATCH
#   - XENO_PATCH_FILE       Patch file(s) 
#   - XENO_NO_PATCH         If set the xeno_patch: target is skipped
#
#   - XENO_CONF             Configure script to be used
#   - XENO_CONF_FLAGS       Arguments to be passed to $XENO_CONF
#   - XENO_NO_CONF          If set the xeno_conf: target is skipped
#
#   - XENO_BUILD            Build command
#   - XENO_BUILD_FLAGS      Arguments to be passed to $XENO_BUILD
#   - XENO_UNBUILD          Unbuild command
#   - XENO_UNBUILD_FLAGS    Arguments to be passed to $XENO_UNBUILD
#   - XENO_BUILD_DIR        Where the package top-level build driver resides
#   - XENO_NO_BUILD         If set the xeno_build: target is skipped
#
#   - XENO_INSTALL          Install command
#   - XENO_INSTALL_FLAGS    Arguments to be passed to $XENO_INSTALL
#   - XENO_NO_INSTALL       If set the xeno_install: target is skipped
#
# Applicable Targets:
# - all, clean, purge, fetch{,-clean,-purge}, unzip{,-clean,-purge}, 
#   patch{,-clean,-purge}, conf{,-clean,-purge}, build{,-clean,-purge}, 
#   install{,-clean,-purge}

#
# Set sensible defaults
#
XENO_TARBALL ?= $(notdir $(XENO_FETCH_URI))
XENO_NAME ?= $(firstword                        \
        $(sort                                  \
            $(foreach ext, $(XENO_UNZIP_EXTS),  \
                $(patsubst %$(ext), %, $(XENO_TARBALL)))))

XENO_FETCH ?= wget
XENO_FETCH_FLAGS ?= --passive-ftp

XENO_UNZIP ?= tar
XENO_UNZIP_FLAGS ?= zxvf
XENO_UNZIP_EXTS ?= .tar.bz2 .tbz .tar.gz .tgz .tbz2

XENO_CONF ?= ./configure

XENO_PATCH ?= patch
XENO_PATCH_FLAGS ?= -p1 <

XENO_BUILD = $(MAKE)
XENO_UNBUILD = $(XENO_BUILD)
XENO_INSTALL = $(XENO_BUILD)
XENO_UNBUILD_FLAGS = clean
XENO_INSTALL_FLAGS = install
XENO_BUILD_DIR = $(XENO_NAME)

#
# Test preconditions
#
ifndef XENO_FETCH_URI
$(error XENO_FETCH_URI must be set when including the xeno.mk template !)
endif

##
## all target (with hooks)
##
all: all-hook-pre fetch unzip patch conf build install all-hook-post
all-hook-pre all-hook-post:

##
## clean target (actions are called in the reverse order)
##
clean: clean-hook-pre install-clean build-clean conf-clean patch-clean \
       unzip-clean fetch-clean clean-hook-post
clean-hook-pre clean-hook-post:

##
## purge target (actions are called in the reverse order)
##
purge: purge-hook-pre install-purge build-purge conf-purge patch-purge \
       unzip-purge fetch-purge purge-hook-post
purge-hook-pre purge-hook-post:

##
## fetch{,-clean,-purge} targets
##
ifndef XENO_NO_FETCH
fetch: fetch-hook-pre .realfetch fetch-hook-post

.realfetch:
	@echo FETCH
	@if [ ! -d dist ]; then \
	    mkdir dist ;\
	fi;
	@if [ ! -f dist/$(XENO_TARBALL) ]; then \
	    (cd dist && $(XENO_FETCH) $(XENO_FETCH_FLAGS) $(XENO_FETCH_URI)) ;\
	fi;
	@touch .realfetch

fetch-hook-pre fetch-hook-post:

fetch-clean:
	@echo FETCH-CLEAN
	@rm -f .realfetch

fetch-purge: fetch-realpurge fetch-clean

fetch-realpurge:
	@rm -rf dist/

else
fetch fetch-clean fetch-purge:
endif   # !XENO_NO_FETCH

##
## unzip{,-clean,-purge} targets
##
ifndef XENO_NO_UNZIP
unzip: unzip-hook-pre .realunzip unzip-hook-post

.realunzip:
	@echo UNZIP
	@$(XENO_UNZIP) $(XENO_UNZIP_FLAGS) dist/$(XENO_TARBALL)
	@touch .realunzip

unzip-hook-pre unzip-hook-post:

unzip-clean:
	@echo UNZIP-CLEAN
	@rm -f .realunzip

unzip-purge: unzip-realpurge unzip-clean

unzip-realpurge:
	@rm -rf $(XENO_NAME)

else
unzip unzip-clean unzip-purge:
endif   # !XENO_NO_UNZIP

##
## patch{,-clean,-purge} targets
##
ifndef XENO_NO_PATCH
patch: patch-hook-pre .realpatch patch-hook-post

.realpatch:
	@(cd $(XENO_NAME) && \
            $(XENO_PATCH) $(XENO_PATCH_FLAGS) ../$(XENO_PATCH_FILE))
	@touch .realpatch

patch-hook-pre patch-hook-post:

patch-clean:
	@echo PATCH-CLEAN
	@rm -f .realpatch

# can't undo anything here ...
patch-purge: patch-clean

else
patch patch-clean patch-purge:
endif   # !XENO_NO_PATCH

##
## conf{,-clean,-purge} targets
##
ifndef XENO_NO_CONF
conf: conf-hook-pre .realconf conf-hook-post

.realconf:
	@echo CONF
	@(cd $(XENO_NAME) && $(XENO_CONF) $(XENO_CONF_FLAGS))
	@touch .realconf

conf-hook-pre conf-hook-post:

conf-clean:
	@echo CONF-CLEAN
	@rm -f .realconf

conf-purge: conf-clean

else
conf conf-clean conf-purge:
endif   # !XENO_NO_CONF

##
## build{,-clean,-purge} targets
##
ifndef XENO_NO_BUILD
build: build-hook-pre .realbuild build-hook-post

.realbuild:
	@echo BUILD
	@(cd $(XENO_BUILD_DIR) && $(XENO_BUILD) $(XENO_BUILD_FLAGS))
	@touch .realbuild

build-hook-pre build-hook-post:

build-clean:
	@echo BUILD-CLEAN
	@if [ -d $(XENO_BUILD_DIR) ]; then \
	    (cd $(XENO_BUILD_DIR) && $(XENO_UNBUILD) $(XENO_UNBUILD_FLAGS)) \
	fi;
	@rm -f .realbuild

build-purge: build-clean

else
build build-clean build-purge:
endif   # !XENO_NO_BUILD

##
## install{,-clean,-purge} targets
##
ifndef XENO_NO_INSTALL
install: install-hook-pre .realinstall install-hook-post

.realinstall:
	@echo INSTALL
	@(cd $(XENO_BUILD_DIR) && $(XENO_INSTALL) $(XENO_INSTALL_FLAGS))
	@touch .realinstall

install-hook-pre install-hook-post:

install-clean:
	@echo INSTALL-CLEAN
	@rm -f .realinstall

install-purge: install-clean

else
install install-clean install-purge:
endif   # !XENO_NO_INSTALL


