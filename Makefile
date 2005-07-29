all:
	@echo "MaKL - Installation and setup Makefile.  Available targets are:"
	@echo ""
	@echo "   - toolchain  -- install platform toolchain files"
	@echo "   - shell      -- output environment variables"
	@echo "   - install    -- install MaKL to the supplied (-Ddir) directory"
	@echo ""
	@echo "(c) 2005 - KoanLogic srl"
	@echo ""

toolchain:
	@echo "install platform toolchain files"

shell:
	@echo "output environment variables"

install:
	@echo "install MaKL to the supplied directory"
