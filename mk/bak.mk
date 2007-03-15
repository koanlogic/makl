#
# $Id: bak.mk,v 1.3 2007/03/15 09:46:20 stewy Exp $ 
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
#	- BAK_PERIOD            How often to execute backups ('month' or 'week')
#

BAK_CMD ?= rsync
BAK_ARGS ?= -vaRH --delete --progress --numeric-ids 
BAK_VERBOSE ?= 

BAK_SRC_DIRS ?= /
BAK_DST_BASE ?= BAK
BAK_DST_PFX ?= bak-
BAK_DST_LATEST ?= $(BAK_DST_PFX)latest
BAK_PERIOD ?= week

BAK_EXCLUDE ?= \
	.ccache \
	lost+found \
	tmp \
	Tmp \
	/proc/ \
	/sys/
BAK_EXCLUDE_FILE ?= .exclude

#
# Test preconditions
#

ifeq ($(strip $(BAK_PERIOD)),week)
BAK_DATE = $(shell date '+%a')
else
ifeq ($(strip $(BAK_PERIOD)),month)
BAK_DATE = $(shell date '+%d')
else
$(error BAK_PERIOD bad value! (must be 'week' or 'month'))
endif
endif

ifdef BAK_SRC_HOST
	BAK_SRC_HOST := $(BAK_SRC_HOST):
endif
ifdef BAK_DST_HOST
	BAK_DST_HOST := $(BAK_DST_HOST):
endif
ifndef BAK_VERBOSE
	BAK_REDIRECT = 1> /dev/null
endif

all: pre bak

pre:
	rm -f $(BAK_EXCLUDE_FILE)
	for pattern in $(BAK_EXCLUDE); do \
		echo $$pattern >> $(BAK_EXCLUDE_FILE); \
	done

$(BAK_DST_BASE):
	@mkdir -p $(BAK_DST_BASE)

bak: $(BAK_DST_BASE)
	for dir in $(BAK_SRC_DIRS); do \
		echo "Backing up $(BAK_SRC_HOST)$$dir to $(BAK_DST_HOST)$(BAK_DST_BASE)/$(BAK_DST_LATEST)..." ; \
		$(BAK_CMD) $(BAK_ARGS) --exclude-from=$(BAK_EXCLUDE_FILE) -b --backup-dir=../$(BAK_DST_PFX)$(BAK_DATE) \
			$(BAK_SRC_HOST)$$dir \
			$(BAK_DST_HOST)$(BAK_DST_BASE)/$(BAK_DST_LATEST) \
			$(BAK_REDIRECT); \
	done
 	
.PHONY: $(BAK_DST_BASE) bak
