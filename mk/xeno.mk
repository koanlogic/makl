#
# $Id: xeno.mk,v 1.9 2007/02/12 15:59:04 tho Exp $
# 
# User Variables:
#
#   - XENO_NAME             Package name
#
#   - XENO_FETCH            Tool to use to retrieve the package srcs or other
#   - XENO_FETCH_FLAGS      Arguments to $XENO_FETCH
#   - XENO_FETCH_URI        Remote resource name
#   - XENO_FETCH_LOCAL      Local resource name
#   - XENO_FETCH_TREE       True if package is fetched as src tree (e.g. cvs)
#   - XENO_NO_FETCH         If set the fetch: target is skipped
#
#   - XENO_UNZIP            Tarball decompression command
#   - XENO_UNZIP_FLAGS      Arguments to be passed to $XENO_UNZIP
#   - XENO_NO_UNZIP         If set the unzip: target is skipped
#
#   - XENO_PATCH            Patch command
#   - XENO_PATCH_FLAGS      Arguments to be passed to $XENO_PATCH
#   - XENO_PATCH_FILE       Patch file(s) 
#   - XENO_NO_PATCH         If set the patch: target is skipped
#
#   - XENO_CONF             Configure script to be used
#   - XENO_CONF_FLAGS       Arguments to be passed to $XENO_CONF
#   - XENO_NO_CONF          If set the conf: target is skipped
#
#   - XENO_BUILD            Build command
#   - XENO_BUILD_FLAGS      Arguments to be passed to $XENO_BUILD
#   - XENO_UNBUILD          Unbuild command
#   - XENO_UNBUILD_FLAGS    Arguments to be passed to $XENO_UNBUILD
#   - XENO_BUILD_DIR        Where the package top-level build driver resides
#   - XENO_NO_BUILD         If set the build: target is skipped
#
#   - XENO_INSTALL          Install command
#   - XENO_INSTALL_FLAGS    Arguments to be passed to $XENO_INSTALL
#   - XENO_UNINSTALL        Uninstall command
#   - XENO_UNINSTALL_FLAGS  Arguments to be passed to $XENO_UNINSTALL
#   - XENO_NO_INSTALL       If set the install: target is skipped
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
XENO_FETCH_LOCAL ?= $(XENO_TARBALL)

XENO_UNZIP ?= tar
XENO_UNZIP_FLAGS ?= zxvf
XENO_UNZIP_EXTS ?= .tar.bz2 .tbz .tar.gz .tgz .tbz2

XENO_CONF ?= ./configure

XENO_PATCH ?= patch
XENO_PATCH_FLAGS ?= -p1 <

XENO_BUILD ?= $(MAKE)
XENO_UNBUILD ?= $(XENO_BUILD)
XENO_INSTALL ?= $(XENO_BUILD)
XENO_UNBUILD_FLAGS ?= clean
XENO_INSTALL_FLAGS ?= install
XENO_BUILD_DIR ?= $(XENO_NAME)

#
# Test preconditions
#
ifndef XENO_FETCH_URI
    ifndef XENO_TARBALL
        $(error XENO_FETCH_URI or XENO_TARBALL must be set when including the \
                xeno.mk template !)
    endif   # !XENO_TARBALL
endif   # !XENO_FETCH_URI

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
## preconditions (in the forward and backward directions)
##
fetch-pre:
unzip-pre: .realfetch
patch-pre: unzip-pre .realunzip
conf-pre: patch-pre .realpatch
build-pre: conf-pre .realconf
install-pre:  build-pre .realbuild

fetch-clean-pre: unzip-clean unzip-clean-pre
unzip-clean-pre: patch-clean patch-clean-pre
patch-clean-pre: conf-clean conf-clean-pre
conf-clean-pre: build-clean build-clean-pre
build-clean-pre: install-clean install-clean-pre
install-clean-pre:

##
## fetch{,-clean,-purge} targets
##
ifndef XENO_NO_FETCH
fetch: fetch-pre fetch-hook-pre .realfetch fetch-hook-post

.realfetch:
	@echo "==> fetching $(XENO_NAME) from $(XENO_FETCH_URI)"
ifndef XENO_FETCH_TREE
	@if [ ! -d dist ]; then \
	    mkdir dist ;\
	fi;
	@if [ ! -f dist/$(XENO_FETCH_LOCAL) ]; then \
	    (cd dist && $(XENO_FETCH) $(XENO_FETCH_FLAGS) $(XENO_FETCH_URI)) ;\
	fi;
else    # XENO_FETCH_TREE
	$(XENO_FETCH) $(XENO_FETCH_FLAGS) $(XENO_FETCH_URI)
endif   # !XENO_FETCH_TREE
	@touch .realfetch

fetch-hook-pre fetch-hook-post:

fetch-clean: fetch-clean-pre
	@rm -f .realfetch

fetch-purge: fetch-realpurge fetch-clean

fetch-realpurge:
ifndef XENO_FETCH_TREE
	@rm -rf dist/
else    # XENO_FETCH_TREE
	@rm -rf $(XENO_BUILD_DIR)
endif   # !XENO_FETCH_TREE

else    # XENO_NO_FETCH
fetch: fetch-pre
	@touch .realfetch

fetch-clean fetch-purge: fetch-clean-pre
	@rm -f .realfetch

endif   # !XENO_NO_FETCH

##
## unzip{,-clean,-purge} targets
##
ifndef XENO_NO_UNZIP
unzip: unzip-pre unzip-hook-pre .realunzip unzip-hook-post

.realunzip:
	@echo "==> unzipping $(XENO_TARBALL)"
	@$(XENO_UNZIP) $(XENO_UNZIP_FLAGS) dist/$(XENO_TARBALL)
	@touch .realunzip

unzip-hook-pre unzip-hook-post:

unzip-clean: unzip-clean-pre
	@rm -f .realunzip

unzip-purge: unzip-realpurge unzip-clean

unzip-realpurge:
	@rm -rf $(XENO_NAME)

else    # XENO_NO_UNZIP
unzip: unzip-pre
	@touch .realunzip

unzip-clean unzip-purge: unzip-clean-pre
	@rm -f .realunzip

endif   # !XENO_NO_UNZIP

##
## patch{,-clean,-purge} targets
##
ifdef XENO_PATCH_FILE
patch: patch-pre patch-hook-pre .realpatch patch-hook-post

.realpatch:
	@echo "==> patching $(XENO_NAME) with $(XENO_PATCH_FILE)"
	@(cd $(XENO_NAME) && \
            $(XENO_PATCH) $(XENO_PATCH_FLAGS) ../$(XENO_PATCH_FILE))
	@touch .realpatch

patch-hook-pre patch-hook-post:

patch-clean: patch-clean-pre
	@rm -f .realpatch

# can't undo anything here ...
patch-purge: patch-clean

else    # XENO_PATCH_FILE
patch: patch-pre
	@touch .realpatch

patch-clean patch-purge: patch-clean-pre
	@rm -f .realpatch

endif   # !XENO_PATCH_FILE

##
## conf{,-clean,-purge} targets
##
ifndef XENO_NO_CONF
conf: conf-pre conf-hook-pre .realconf conf-hook-post

.realconf:
	@echo "==> configuring in $(XENO_BUILD_DIR)/"
	@(cd $(XENO_BUILD_DIR) && $(XENO_CONF) $(XENO_CONF_FLAGS))
	@touch .realconf

conf-hook-pre conf-hook-post:

conf-clean: conf-clean-pre
	@rm -f .realconf

conf-purge: conf-clean

else    # XENO_NO_CONF

conf: conf-pre
	@touch .realconf

conf-clean conf-purge: conf-clean-pre
	@rm -f .realconf

endif   # !XENO_NO_CONF

##
## build{,-clean,-purge} targets
##
ifndef XENO_NO_BUILD
build: build-pre build-hook-pre .realbuild build-hook-post

.realbuild:
	@echo "==> building in $(XENO_BUILD_DIR)/"
	@(cd $(XENO_BUILD_DIR) && $(XENO_BUILD) $(XENO_BUILD_FLAGS))
	@touch .realbuild

build-hook-pre build-hook-post:

build-clean: build-clean-pre
	@echo "==> cleaning up in $(XENO_BUILD_DIR)/"
	@if [ -d $(XENO_BUILD_DIR) ]; then \
	    (cd $(XENO_BUILD_DIR) && $(XENO_UNBUILD) $(XENO_UNBUILD_FLAGS)) \
	fi;
	@rm -f .realbuild

build-purge: build-clean

else    # XENO_NO_BUILD

build: build-pre
	@touch .realbuild

build-clean build-purge: build-clean-pre
	@rm -f .realbuild

endif   # !XENO_NO_BUILD

##
## install{,-clean,-purge} targets
##
ifndef XENO_NO_INSTALL
install: install-pre install-hook-pre .realinstall install-hook-post

.realinstall:
	@echo "==> installing $(XENO_NAME)"
	@(cd $(XENO_BUILD_DIR) && $(XENO_INSTALL) $(XENO_INSTALL_FLAGS))
	@touch .realinstall

install-hook-pre install-hook-post:

install-clean: install-clean-pre
ifdef XENO_UNINSTALL
	@(cd $(XENO_BUILD_DIR) && $(XENO_UNINSTALL) $(XENO_UNINSTALL_FLAGS))
endif
	@rm -f .realinstall

install-purge: install-clean

else    # XENO_NO_INSTALL
install: install-pre
	@touch .realinstall

install-clean install-purge: install-clean-pre
	@rm -f .realinstall

endif   # !XENO_NO_INSTALL
