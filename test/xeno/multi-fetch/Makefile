include common.mk
include ../../Makefile.conf

XENO_FETCH_MULTI_URI = http://koanlogic.com/download/mklatest.sh
XENO_FETCH_MULTI_URI += http://koanlogic.com/download/makl/dummy.tc
# if the following is set, fetch op is aborted
#XENO_FETCH_MULTI_URI = http://koanlogic.com/download/ZXZ

# set a custom dir where to place the retrieved resources
XENO_DIST_DIR = $(CURDIR)

# the following can be set to provide a different cleanfiles set 
#XENO_FETCH_MULTI_CLEANFILES = mklatest.sh dummy.tc _another_file_

include xeno-fetch.mk

fetch-hook-pre:
	@$(ECHO) HOOK-PRE

fetch-hook-post:
	@$(ECHO) HOOK-POST
