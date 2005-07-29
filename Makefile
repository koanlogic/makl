#
# $Id: Makefile,v 1.2 2005/07/29 12:21:26 tho Exp $
#

all:
	@echo "MaKL - Installation and setup Makefile.  Available targets are:"
	@echo ""
	@echo "   - toolchain  -- install platform toolchain files"
	@echo "   - hints      -- output environment variables"
	@echo "   - install    -- install MaKL to the supplied (-Ddir) directory"
	@echo ""
	@echo "(c) 2005 - KoanLogic srl"
	@echo ""

toolchain:
	@setup/toolchain_setup.sh

hints:
	@setup/shell_setup.sh `pwd`

install:
	@echo "[TODO] install MaKL to the supplied directory"
