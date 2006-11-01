#
# $Id: party.mk,v 1.12 2006/11/01 16:09:03 stewy Exp $
# 
# User Variables:
# - PARTY_NAME  The name of the 3rd party package
# - PARTY_FILE  Package filename
# - PARTY_BASE  Base directory for build 
# - PARTY_CONF  Configure script to be used
# - PARTY_ARGS  Arguments to be passed to configure script
#
# Applicable Targets:
# - party clean

PARTY_CONF ?= ./configure
PARTY_DECOMP ?= tar
PARTY_DECOMP_ARGS ?= xzvf
PARTY_DOWN ?= wget --passive-ftp
PARTY_CHK ?= md5
PARTY_LOG ?= $(shell pwd)/party.log
PARTY_BASE ?= $(PARTY_NAME)
PARTY_FILE ?= $(PARTY_NAME).tar.gz
PARTY_FILE_CHK ?= $(PARTY_FILE).md5

all: .pre $(PARTY_FILE) $(PARTY_FILE_CHK) $(PARTY_BASE) conf make install

.pre:
	@[ ! -e $(PARTY_LOG) ] || rm -f $(PARTY_LOG)
	@touch $(PARTY_LOG)
	@touch .pre
	@echo "==> processing $(PARTY_NAME)   [see $(PARTY_LOG) for details]"

$(PARTY_FILE): 
ifndef PARTY_NO_DOWN
	@echo "==> downloading $(PARTY_NAME) from $(PARTY_URL)"
	@$(PARTY_DOWN) $(PARTY_URL)/$(PARTY_FILE) \
      1>> $(PARTY_LOG) 2>> $(PARTY_LOG)
endif

$(PARTY_FILE_CHK):
# disable temporarily
ifdef 0
ifndef PARTY_NO_CHK
ifndef PARTY_NO_DOWN
	@echo "==> downloading $(PARTY_NAME) checksum file $(PARTY_FILE_CHK)"
	@$(PARTY_DOWN) $(PARTY_URL)/$(PARTY_FILE_CHK) \
      1>> $(PARTY_LOG) 2>> $(PARTY_LOG)
endif
	@echo "==> verifying checksum for $(PARTY_NAME)"
	@$(PARTY_CHK) $(PARTY_FILE) | cut -f 2 -d "=" | sed 's/^[ \t]*//' \
      > $(PARTY_FILE_CHK).vfy 2>> $(PARTY_LOG)
	@cat $(PARTY_FILE_CHK) | cut -f 2 -d "=" | sed 's/^[ \t]*//' \
      > $(PARTY_FILE_CHK).chk 2>> $(PARTY_LOG)
	@diff $(PARTY_FILE_CHK).vfy $(PARTY_FILE_CHK).chk
endif
endif
  
$(PARTY_BASE):
ifndef PARTY_NO_DECOMP
	@echo "==> decompressing $(PARTY_NAME)"
	@$(PARTY_DECOMP) $(PARTY_DECOMP_ARGS) $(PARTY_FILE) \
      1>> $(PARTY_LOG) 2>> $(PARTY_LOG)
endif
ifdef PARTY_PATCH
	@patch -d $(PARTY_BASE) -p1 < $(PARTY_PATCH)
endif

conf: beforeconf .realconf afterconf
beforeconf:
.realconf:
ifndef PARTY_NO_CONF
	@echo "==> configuring $(PARTY_NAME)"
	@cd $(PARTY_BASE) && $(PARTY_CONF) $(PARTY_ARGS) \
      1>> $(PARTY_LOG) 2>> $(PARTY_LOG)
	@touch .realconf
endif
afterconf:

make: .realmake
.realmake:
ifndef PARTY_NO_MAKE
	@echo "==> building $(PARTY_NAME)"
	@$(MAKE) -C $(PARTY_BASE) \
      1>> $(PARTY_LOG) 2>> $(PARTY_LOG)
	@touch .realmake
endif

install: beforeinstall .realinstall afterinstall
beforeinstall:
.realinstall:
ifndef PARTY_NO_INSTALL
	@echo "==> installing $(PARTY_NAME)"
	@$(MAKE) -C $(PARTY_BASE) install \
      1>> $(PARTY_LOG) 2>> $(PARTY_LOG)
	@touch .realinstall
endif
afterinstall:

clean:
	@echo "==> cleaning $(PARTY_NAME)"
	@rm -f .pre
ifndef PARTY_NO_DECOMP
	@rm -rf $(PARTY_BASE) 
endif
	@rm -f .realconf 
	@rm -f .realmake
	@rm -f .realinstall
	@rm -f $(PARTY_LOG)

purge: clean
	@echo "==> purging $(PARTY_NAME)"
ifndef PARTY_NO_DOWN
	@rm -f $(PARTY_FILE) 
	@rm -f $(PARTY_FILE_CHK) 
endif  
	@rm -f $(PARTY_FILE_CHK).tmp 

# set standard MaKL targets even if they don't do anything
install uninstall depend cleandepend:

include ../etc/map.mk
