#
# $Id: Makefile,v 1.3 2005/07/29 13:50:55 tho Exp $
#

MAKL_ROOT_DIR=`pwd`

all:
	@echo "MaKL - Installation and setup Makefile.  Available targets are:"
	@echo ""
	@echo "   - toolchain  -- install platform toolchain files"
	@echo "   - hints      -- output environment variables"
	@echo ""
	@echo "(c) 2005 - KoanLogic srl"
	@echo ""

toolchain:
	@setup/toolchain_setup.sh

hints:
	@setup/shell_setup.sh ${MAKL_ROOT_DIR}
