# $Id: xeno-fetch.mk,v 1.1 2007/03/08 09:23:09 tho Exp $
#
# xeno helper for just fetching a package from a given set of locations
# to a local XENO_DIST_DIR.
# NOTE: when using multiple XENO_FETCH_URIs set XENO_TARBALL explicitly
#
# Available Targets:
# - all, clean (and fetch hooks)

XENO_NO_UNZIP = true
XENO_NO_CONF = true
XENO_NO_BUILD = true
XENO_NO_PATCH = true
XENO_NO_INSTALL = true

include xeno.mk
