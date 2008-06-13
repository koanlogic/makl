#
# $Id: xeno.mk,v 1.38 2008/06/13 21:09:31 tho Exp $
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
#   - XENO_UNZIP_FLAGS_POST Arguments to be passed to $XENO_UNZIP after the 
#                           tarball argument (e.g '-C' argument to tar)
#   - XENO_NO_UNZIP         If set the unzip: target is skipped
#
#   - XENO_PATCH            Patch command
#   - XENO_PATCH_FLAGS      Arguments to be passed to $XENO_PATCH
#   - XENO_PATCH_DIR        Where the patch command shall be invoked
#   - XENO_PATCH_URI	    Remote patch URI (if you need to download it)
#   - XENO_NO_PATCH         If set the patch: target is skipped
#   - XENO_PATCH_FILE       Local patch file: absolute path or simple patch 
#                           file name if in the same directory as the xeno 
#                           Makefile
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

# make filename used (Makefile, makefile, Makefile.subdir, mymakefile, etc.)
MAKEFILENAME = $(firstword $(MAKEFILE_LIST))

# additional flags
ifneq ($(strip $(MAKEFILENAME)),)
MAKE_ADD_FLAGS = -f $(MAKEFILENAME)
endif

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
XENO_PATCH_DIR ?= $(XENO_NAME)

XENO_BUILD ?= $(MAKE)
XENO_UNBUILD ?= echo "set XENO_UNBUILD and XENO_UNBUILD_FLAGS if you need special clean actions"
XENO_INSTALL ?= $(XENO_BUILD)
XENO_INSTALL_FLAGS ?= install
XENO_BUILD_DIR ?= $(XENO_NAME)

XENO_DIST_DIR ?= dist


#
# Test preconditions (if target != .help)
#
ifneq ($(MAKECMDGOALS), .help)
ifndef XENO_FETCH_URI
    ifndef XENO_TARBALL
        $(error XENO_FETCH_URI or XENO_TARBALL must be set when including the \
                xeno.mk template !)
    endif   # !XENO_TARBALL
endif   # !XENO_FETCH_URI
endif	# target != .help

##
## all target (with hooks)
##
all: all-hook-pre fetch unzip patch conf build install all-hook-post
all-hook-pre all-hook-post:

# dependencies
fetch: all-hook-pre
unzip: fetch
patch: unzip
conf: patch
build: conf
install: build
all-hook-post: install


##
## clean target (actions are called in the reverse order)
##
clean: clean-hook-pre install-clean build-clean conf-clean patch-clean \
       unzip-clean fetch-clean clean-hook-post
clean-hook-pre clean-hook-post:

##
## distclean target
##
include distclean.mk

##
## purge target (actions are called in the reverse order)
##
purge: purge-hook-pre install-purge build-purge conf-purge patch-purge \
       unzip-purge fetch-purge purge-hook-post
purge-hook-pre purge-hook-post:

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
fetch: .realfetch

.realfetch:
	@$(MAKE) $(MAKE_ADD_FLAGS) fetch-hook-pre fetch-make fetch-hook-post
	@touch $@

fetch-make: 
	@echo "==> fetching $(XENO_NAME) from $(XENO_FETCH_URI)"
ifndef XENO_FETCH_TREE
	@if [ ! -d "$(XENO_DIST_DIR)" ]; then \
	    mkdir $(XENO_DIST_DIR); \
	fi ; \
	if [ ! -f "$(XENO_DIST_DIR)/$(XENO_FETCH_LOCAL)" ]; then \
	    (cd $(XENO_DIST_DIR) && \
            set $(XENO_FETCH_URI) ; \
            while [ $$# -gt 0 ] ; \
            do \
                $(XENO_FETCH) $(XENO_FETCH_FLAGS) $$1 ; \
                ret=$$? ; \
                [ $$ret -eq 0 ] && break ; \
                shift ; \
            done ; \
            [ $$ret -eq 0 ] || exit $$ret) ; \
	fi;
else    # XENO_FETCH_TREE
	@set $(XENO_FETCH_URI) ; \
	while [ $$# -gt 0 ] ; \
	do \
	    $(XENO_FETCH) $(XENO_FETCH_FLAGS) $$1 ; \
	    ret=$$? ; \
	    [ $$ret -eq 0 ] && break ; \
	    shift ; \
	done ; \
    [ $$ret -eq 0 ] || exit $$ret ;
endif   # !XENO_FETCH_TREE

fetch-hook-pre fetch-hook-post:

fetch-hook-pre:
fetch-make: fetch-hook-pre
fetch-hook-post: fetch-make

fetch-clean: fetch-clean-pre
	@rm -f .realfetch

fetch-purge: fetch-realpurge fetch-clean

fetch-realpurge:
ifndef XENO_FETCH_TREE
	@rm -f $(XENO_DIST_DIR)/$(XENO_FETCH_LOCAL)
	@rmdir $(XENO_DIST_DIR) 2>/dev/null || true
else    # XENO_FETCH_TREE
	@rm -rf $(XENO_BUILD_DIR)
endif   # !XENO_FETCH_TREE

else    # XENO_NO_FETCH

fetch: .realfetch

.realfetch:
	@touch .realfetch

fetch-clean fetch-purge: fetch-clean-pre
	@rm -f .realfetch

endif   # !XENO_NO_FETCH

##
## unzip{,-clean,-purge} targets
##
ifndef XENO_NO_UNZIP
unzip: .realunzip

.realunzip: .realfetch
	@$(MAKE) $(MAKE_ADD_FLAGS) unzip-hook-pre unzip-make unzip-hook-post
	@touch $@

unzip-make:
	@echo "==> unzipping $(XENO_TARBALL)"
	@$(XENO_UNZIP) $(XENO_UNZIP_FLAGS) $(XENO_DIST_DIR)/$(XENO_TARBALL) \
        $(XENO_UNZIP_FLAGS_POST)

unzip-hook-pre unzip-hook-post:

unzip-hook-pre: 
unzip-make: unzip-hook-pre
unzip-hook-post: unzip-make

unzip-clean: unzip-clean-pre
	@rm -rf $(XENO_NAME)
	@rm -f .realunzip

unzip-purge: unzip-clean

else    # XENO_NO_UNZIP
unzip: .realunzip

.realunzip:
	@touch .realunzip

unzip-clean unzip-purge: unzip-clean-pre
	@rm -f .realunzip

endif   # !XENO_NO_UNZIP

##
## patch{,-clean,-purge} targets
##
ifndef XENO_NO_PATCH

# we need to set XENO_PATCH_LOCALFILE from one of XENO_PATCH_URI or
# XENO_PATCH_FILE

ifndef XENO_PATCH_URI
ifdef XENO_PATCH_FILE

# we need an absolute pathname for XENO_PATCH_LOCALFILE, since the patch 
# command is executed inside the XENO_PATCH_DIR.  So we check for absolute 
# vs local file name (i.e. a file in the same dir as xeno Makefile) in order 
# to set the XENO_PATCH_LOCALFILE variable correctly.
# The test is quite suboptimal :) we should have used the abspath function 
# here, but unfortunately it is not available under GNU make 3.79 (very old 
# but default install on MacOS 10.3).
XENO_PATCH_LOCALFILE = $(foreach pf, $(XENO_PATCH_FILE), \
	$(if $(findstring $(pf), $(notdir $(pf))), $(CURDIR)/$(pf) , $(pf)))

patch-fetch: $(XENO_PATCH_LOCALFILE)

else    # !XENO_PATCH_FILE && !XENO_PATCH_URI

$(error one of XENO_PATCH_URI or XENO_PATCH_FILE must be defined when \
		XENO_NO_PATCH is unset !)

endif   # XENO_PATCH_FILE && !XENO_PATCH_URI
else    # XENO_PATCH_URI (has precedence over XENO_PATCH_FILE)

XENO_PATCH_LOCALFILE = $(foreach pu, $(XENO_PATCH_URI),	\
		$(CURDIR)/$(XENO_DIST_DIR)/$(notdir $(pu)))

$(XENO_PATCH_LOCALFILE):
	(	\
	 	cd $(XENO_DIST_DIR) && \
	 	for pu in $(XENO_PATCH_URI) ;	\
	  	do	\
			$(XENO_FETCH) $(XENO_FETCH_FLAGS) $$pu ;	\
	  	done	\
	)

patch-fetch: $(XENO_PATCH_LOCALFILE)

endif   # !XENO_PATCH_URI

patch: .realpatch

.realpatch: .realunzip
	@$(MAKE) $(MAKE_ADD_FLAGS) patch-fetch patch-hook-pre patch-make \
        patch-hook-post
	@touch $@

patch-make:
	@echo "==> patching $(XENO_NAME) with $(XENO_PATCH_FILE)"
	(	\
		cd $(XENO_PATCH_DIR) && \
	  	for p in $(XENO_PATCH_LOCALFILE) ;	\
	  	do	\
	  		$(XENO_PATCH) $(XENO_PATCH_FLAGS) $$p ; \
	  	done	\
	)

patch-hook-pre patch-hook-post:

patch-hook-pre: 
patch-make: patch-hook-pre
patch-hook-post: patch-make

patch-clean: patch-clean-pre
	@rm -f .realpatch

patch-purge: patch-realpurge patch-clean

patch-realpurge:
ifdef XENO_PATCH_URI
	@rm -f $(XENO_PATCH_LOCALFILE)
endif

else    # XENO_NO_PATCH

patch: .realpatch

.realpatch:
	@touch .realpatch

patch-clean patch-purge: patch-clean-pre
	@rm -f .realpatch

endif   # !XENO_NO_PATCH

##
## conf{,-clean,-purge} targets
##
ifndef XENO_NO_CONF
conf: .realconf

.realconf: .realpatch
	@$(MAKE) $(MAKE_ADD_FLAGS) conf-hook-pre conf-make conf-hook-post
	@touch $@

conf-make:
	@echo "==> configuring in $(XENO_BUILD_DIR)/"
	@(cd $(XENO_BUILD_DIR) && $(XENO_CONF) $(XENO_CONF_FLAGS))

conf-hook-pre conf-hook-post:

conf-hook-pre:
conf-make: conf-hook-pre
conf-hook-post: conf-make

conf-clean: conf-clean-pre
	@rm -f .realconf

conf-purge: conf-clean

else    # XENO_NO_CONF

conf: .realconf

.realconf:
	@touch .realconf

conf-clean conf-purge: conf-clean-pre
	@rm -f .realconf

endif   # !XENO_NO_CONF

##
## build{,-clean,-purge} targets
##
ifndef XENO_NO_BUILD
build: .realbuild

.realbuild: .realconf
	@$(MAKE) $(MAKE_ADD_FLAGS) build-hook-pre build-make build-hook-post
	@touch $@

build-make:
	@echo "==> building in $(XENO_BUILD_DIR)/"
	@(cd $(XENO_BUILD_DIR) && $(XENO_BUILD) $(XENO_BUILD_FLAGS))

build-hook-pre build-hook-post:

build-hook-pre:
build-make: build-hook-pre
build-hook-post: build-make

build-clean: build-clean-pre
	@echo "==> cleaning up in $(XENO_BUILD_DIR)/"
	@if [ -d $(XENO_BUILD_DIR) ]; then \
	    (cd $(XENO_BUILD_DIR) && $(XENO_UNBUILD) $(XENO_UNBUILD_FLAGS)) \
	fi;
	@rm -f .realbuild

build-purge: build-clean

else    # XENO_NO_BUILD

build: .realbuild

.realbuild:
	@touch .realbuild

build-clean build-purge: build-clean-pre
	@rm -f .realbuild

endif   # !XENO_NO_BUILD

##
## install{,-clean,-purge} targets
##
ifndef XENO_NO_INSTALL
install: .realinstall

.realinstall: .realbuild
	@$(MAKE) $(MAKE_ADD_FLAGS) install-hook-pre install-make install-hook-post
	@touch $@

install-make:
	@echo "==> installing $(XENO_NAME)"
	@(cd $(XENO_BUILD_DIR) && $(XENO_INSTALL) $(XENO_INSTALL_FLAGS))

install-hook-pre install-hook-post:

install-hook-pre:
install-make: install-hook-pre
install-hook-post: install-make

install-clean: install-clean-pre
ifdef XENO_UNINSTALL
	@(cd $(XENO_BUILD_DIR) && $(XENO_UNINSTALL) $(XENO_UNINSTALL_FLAGS))
endif
	@rm -f .realinstall

install-purge: install-clean

else    # XENO_NO_INSTALL
install: .realinstall

.realinstall:
	@touch .realinstall

install-clean install-purge: install-clean-pre
	@rm -f .realinstall

endif   # !XENO_NO_INSTALL

##
## interface description
##
.help:
	@echo
	@echo "-------------------                                                 "
	@echo " Available targets                                                  "
	@echo "-------------------                                                 "
	@echo "all         fetch, patch, configure, build and install the          "
	@echo "            xeno package (default target)                           "
	@echo "clean       remove all step indicators                              "
	@echo "purge       deep clean: also remove fetched files                   "
	@echo
	@echo "Each target T given below has T-clean and T-purge companion         "
	@echo "targets which can be used to selectively remove the step            "
	@echo "indicators and perform deep clean at each stage                     "
	@echo
	@echo "fetch       retrieve the package tarball                            "
	@echo "unzip       deflate the tarball                                     "
	@echo "patch       apply the needed patches                                "
	@echo "install     install the package                                     "
	@echo "uninstall   remove the installed package                            "
	@echo
	@echo "Each target T also has T-hook-pre and T-hook-post companion         "
	@echo "targets. These (void) targets are at client's disposal and will     "
	@echo "always be called before / after the associated target               "
	@echo
	@echo "---------------------                                               "
	@echo " Available variables                                                "
	@echo "---------------------                                               "
	@echo "XENO_NAME         package name                                      "
	@echo
	@echo "XENO_FETCH        tool used to retrieve the package tarball         "
	@echo "XENO_FETCH_FLAGS  arguments to XENO_FETCH                           "
	@echo "XENO_FETCH_URI    remote resource name                              "
	@echo "XENO_FETCH_LOCAL  local resource name                               "
	@echo "XENO_FETCH_TREE   set it in case the package were fetched as a      "
	@echo "                  source tree (e.g. via CVS/SVN)                    "
	@echo "XENO_NO_FETCH     set it to skip the fetch target                   "
	@echo
	@echo "XENO_UNZIP        tool used to deflate the package tarball          "
	@echo "XENO_UNZIP_FLAGS  arguments to XENO_UNZIP                           "
	@echo "XENO_UNZIP_FLAGS_POST arguments to XENO_UNZIP after the tarball     "
	@echo "                      argument (e.g. the -C argument to tar(1))     "
	@echo "XENO_NO_UNZIP     set it to skip the unzip target                   "
	@echo
	@echo "XENO_PATCH        tool used to patch the retrieved package          "
	@echo "XENO_PATCH_FLAGS  arguments to XENO_PATCH                           "
	@echo "XENO_PATCH_URI    remote patch URI (if you need to download it)     "
	@echo "XENO_PATCH_DIR    where the XENO_PATCH command shall be invoked     "
	@echo "XENO_PATCH_FILE   local patch file: absolute path or simple patch   "
	@echo "                  file name if in the same directory as the xeno    "
	@echo "                  Makefile                                          "
	@echo "XENO_NO_PATCH     set it to skip the patch target                   "
	@echo
	@echo "XENO_CONF         tool used to configure the package                "
	@echo "XENO_CONF_FLAGS   arguments to XENO_CONF                            "
	@echo "XENO_NO_CONF      set it to skip the conf target                    "
	@echo
	@echo "XENO_BUILD        build command                                     "
	@echo "XENO_BUILD_FLAGS  arguments to XENO_BUILD                           "
	@echo "XENO_UNBUILD      unbuild command                                   "
	@echo "XENO_UNBUILD_FLAGS   arguments to XENO_UNBUILD                      "
	@echo "XENO_BUILD_DIR    top level build directory for the package (i.e.   "
	@echo "                  where the package build driver resides)           "
	@echo "XENO_NO_BUILD     set it to skip the build target                   "
	@echo
	@echo "XENO_INSTALL      install command                                   "
	@echo "XENO_INSTALL_FLAGS   arguments to XENO_INSTALL                      "
	@echo "XENO_UNINSTALL    uninstall command                                 "
	@echo "XENO_UNINSTALL_FLAGS arguments to XENO_UNINSTALL                    "
	@echo "XENO_NO_INSTALL   set it to skip the install target                 "
	@echo "DISTCLEANFILES    additional files to be removed when 'distclean'ing"
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/xeno.mk        "
	@echo

.PHONY: fetch-make patch-make unzip-make conf-make build-make install-make
.PHONY: fetch patch unzip conf build install
