include Makefile.conf

SUBDIR = lib prog-c prog-c++ man include etc

include subdir.mk

DISTCLEANFILES = makl.conf Makefile.conf conf.h

# special post actions for 'distclean' and 'uninstall' targets
distclean-post: ; rm -f $(DISTCLEANFILES)
uninstall-post: ; -rmdir $(SHAREDIR)
