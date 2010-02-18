# $Id: Makefile,v 1.3 2010/02/18 16:07:06 tho Exp $

MAKL_VERSION = 1.8.1
MAKL_TARBALL = makl-$(MAKL_VERSION).tar.gz
MAKL_URL = http://koanlogic.com/download/makl/$(MAKL_TARBALL)
MAKL_NAME = makl-$(MAKL_VERSION)
MAKL_DEB_NAME = $(subst -,_, $(MAKL_NAME))
MAKL_DIR = $(MAKL_NAME)

KL_MAKL_DIR = root@koanlogic.com:/var/www-anemic/www/download/makl/debian

# collect all the generated bits together
collect: pkg ; mkdir __collect__ && mv $(MAKL_DEB_NAME)* __collect__

# create the binary pkg
pkg: $(MAKL_DIR)/debian ; ( cd $(MAKL_DIR) && debuild -us -uc )

# link debian/ pkg build
$(MAKL_DIR)/debian: $(MAKL_DIR) ; ( cd $(MAKL_DIR) && ln -fs ../debian ) 

# explode pkg
$(MAKL_DIR): $(MAKL_TARBALL) ; tar zxf $(MAKL_TARBALL)

# download pkg
$(MAKL_TARBALL): ; wget $(MAKL_URL)

# cleanup
clean: ; rm -rf $(MAKL_DIR) $(MAKL_DEB_NAME)* __collect__

distclean: clean ; rm -f $(MAKL_TARBALL)

# upload to kl.com
upload: ; ( cd __collect__ && scp * $(KL_MAKL_DIR) )

