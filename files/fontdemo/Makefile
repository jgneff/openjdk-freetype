# ======================================================================
# Makefile - run make in the subdirectories
# ======================================================================

.PHONY: all clean lcdnone lcddefault

all clean: lcdnone lcddefault

lcdnone lcddefault:
	$(MAKE) -C $@ $(MAKECMDGOALS)
