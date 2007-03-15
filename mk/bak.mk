#
# $Id: bak.mk,v 1.1 2007/03/15 00:05:09 stewy Exp $ 
#
# Required Variables:
#
#	- BAK_SRC_DIRS  List of source directories
#
# Optional Variables:
#
#	- BAK_CMD				Backup command
#	- BAK_ARGS				Arguments to backup command
#	- BAK_VERBOSE   		Set this to increase verbosity
#	- BAK_SRC_HOST  		Hostname of source
#	- BAK_DST_HOST  		Hostname of destination
#	- BAK_DST_BASE  		Base directory of destination 
#	- BAK_DST_PFX           Prefix for backup directories
#	- BAK_DST_LATEST		Name of directory containing base backup
#	- BAK_EXCLUDE       	List of patterns to be excluded
#	- BAK_PERIDO            How often to execute backups ('month' or 'week')
#

BAK_CMD ?= rsync
BAK_ARGS ?= -varRH --delete --progress --numeric-ids 
BAK_VERBOSE ?= 

BAK_SRC_DIRS ?= /
BAK_DST_BASE ?= BAK
BAK_DST_PFX ?= bak-
BAK_DST_LATEST ?= $(BAK_DST_PFX)latest
BAK_EXCLUDE_FILE ?= .exclude
BAK_PERIOD ?= week

BAK_EXCLUDE ?= \
	.ccache \
	lost+found \
	tmp \
	Tmp \
	/proc

ifeq ($(strip $(BAK_PERIOD)),week)
BAK_DATE = $(shell date '+%a')
else
ifeq ($(strip $(BAK_PERIOD)),month)
BAK_DATE = $(shell date '+%d')
else
$(error BAK_PERIOD bad value! (must be 'week' or 'month'))
endif
endif

#
# Test preconditions
#
#ifndef BAK_SRC_DIRS 
#  $(error BAK_SRC_DIRS must be defined when using the bak.mk template!)
#endif

ifdef BAK_SRC_HOST
	BAK_SRC_HOST := $(BAK_SRC_HOST):
endif
ifdef BAK_DST_HOST
	BAK_DST_HOST := $(BAK_DST_HOST):
endif
ifndef BAK_VERBOSE
	BAK_REDIRECT = 1> /dev/null
endif

all: bak

$(BAK_DST_BASE):
	@mkdir -p $(BAK_DST_BASE)

bak: $(BAK_DST_BASE)
	@for dir in $(BAK_SRC_DIRS); do \
		echo "Backing up $(BAK_SRC_HOST)$$dir to $(BAK_DST_HOST)$(BAK_DST_BASE)/$(BAK_DST_LATEST)..." ; \
		$(BAK_CMD) $(BAK_ARGS) --exclude="$(BAK_EXCLUDE)" -b --backup-dir=../$(BAK_DST_PFX)$(BAK_DATE) \
			$(BAK_SRC_HOST)$$dir \
			$(BAK_DST_HOST)$(BAK_DST_BASE)/$(BAK_DST_LATEST) \
			$(BAK_REDIRECT); \
	done
 	
.PHONY: $(BAK_DST_BASE) bak
