# $Id: Makefile,v 1.1 2010/02/17 16:28:17 tho Exp $ 

MAKL_VERSION = 1.8.1
MAKL_TARBALL = makl-$(MAKL_VERSION).tar.gz
MAKL_URL = http://koanlogic.com/download/makl/$(MAKL_TARBALL)
MAKL_NAME = makl-$(MAKL_VERSION)
MAKL_DIR = $(MAKL_NAME)

RH_SOURCES = /usr/src/redhat/SOURCES
RH_MAKL_TARBALL = $(RH_SOURCES)/$(MAKL_TARBALL)
RH_MAKL_PATCH = $(RH_SOURCES)/makl-buildroot-symlink.patch

# collect the bits together
collect: .CREATED
	mkdir -p __collect__ ; \
	  grep -o ' .*$$' .CREATED | while read f ; do cp $$f __collect__/ ; done

# cook the rpm
.CREATED: $(RH_MAKL_TARBALL) $(RH_MAKL_PATCH)
	rpmbuild -ba makl.spec --pipe "grep '^Wrote'" > $@

# put the tarball and patch where rpm wants them to be 
$(RH_MAKL_TARBALL): ; cp $(MAKL_TARBALL) $(RH_SOURCES)
$(RH_MAKL_PATCH): ; cp makl-buildroot-symlink.patch $(RH_SOURCES)

# download
$(MAKL_TARBALL): ; wget $(MAKL_URL)

# cleanup
clean: ; rm -rf $(MAKL_TARBALL) .CREATED __collect__
distclean: clean ; rm -rf __collect__

