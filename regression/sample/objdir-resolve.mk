# test if OBJDIR variable is in use, if so set a suitable PAD dir for lib 
# relocation

ifeq ($(OBJDIR),$(CURDIR))
PAD =
else
PAD = $(OBJDIR)
endif
