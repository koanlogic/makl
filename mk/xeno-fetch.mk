# $Id: xeno-fetch.mk,v 1.4 2008/05/21 18:51:33 stewy Exp $
#
# xeno helper for just fetching a package from a given set of locations
# to a local XENO_DIST_DIR.
# NOTE: when using multiple XENO_FETCH_URIs set XENO_TARBALL explicitly
# XENO_FETCH_MULTI_URI can be used instead of XENO_FETCH_URI for fetching
# multiple different tarballs from different locations into XENO_DIST_DIR.
# XENO_FETCH_MULTI_CLEANFILES can be set to supply explicit clean files.
#
# Available Targets:
# - all, clean (and fetch hooks)

XENO_NO_UNZIP = true
XENO_NO_CONF = true
XENO_NO_BUILD = true
XENO_NO_PATCH = true
XENO_NO_INSTALL = true

include xeno.mk

ifdef XENO_FETCH_MULTI_URI

##
## override fetch and fetch-{clean,purge}
##
XENO_FETCH_MULTI_CLEANFILES ?= $(addprefix $(XENO_DIST_DIR)/, \
        $(foreach cf, $(XENO_FETCH_MULTI_URI), $(notdir $(cf))))

fetch: .realfetch

.realfetch:
	@$(MAKE) $(MAKE_ADD_FLAGS) fetch-hook-pre fetch-make fetch-hook-post
	@touch $@

fetch-make:
	[ -d "$(XENO_DIST_DIR)" ] || mkdir -p $(XENO_DIST_DIR) ; \
    ( \
        cd $(XENO_DIST_DIR) ; \
        set $(XENO_FETCH_MULTI_URI) ; \
        while [ $$# -gt 0 ]; do \
            echo "now fetching $$1 into $(XENO_DIST_DIR)" ; \
            $(XENO_FETCH) $(XENO_FETCH_FLAGS) $$1 ; \
            [ $$? -eq 0 ] || exit 1 ; \
            shift; \
        done \
    ) && touch .realfetch

fetch-clean fetch-purge: fetch-clean-pre
	@rm -f $(XENO_FETCH_MULTI_CLEANFILES)
	@-rmdir $(XENO_DIST_DIR) 2>/dev/null
	@rm -f .realfetch

endif   # XENO_FETCH_MULTI_URI
