# ======================================================================
# Makefile - crops and enlarges details from screenshots
# ======================================================================

# Commands
CONVERT := convert
OPTIPNG := optipng

# Command options
crop  := -crop 80x17+119+140 +repage
scale := -scale 800%

# ======================================================================
# Pattern rules
# ======================================================================

%-crop.png: %.png
	$(CONVERT) $< $(crop) $@

8x%.png: %-crop.png
	$(CONVERT) $< $(scale) $@
	$(OPTIPNG) -quiet $@

# ======================================================================
# Explicit rules
# ======================================================================

.PHONY: all clean

all: \
    8xdefault-libfreetype.so.6.3.16.png \
    8xdefault-libfreetype.so.6.11.1.png \
    8xdefault-libfreetype.so.6.12.1.png \
    8xdefault-libfreetype.so.6.15.0.png \
    8xdefault-libfreetype.so.6.16.1.png \
    8xenabled-libfreetype.so.6.3.16.png \
    8xenabled-libfreetype.so.6.11.1.png \
    8xenabled-libfreetype.so.6.12.1.png \
    8xenabled-libfreetype.so.6.15.0.png \
    8xenabled-libfreetype.so.6.16.1.png

clean:
	rm -f 8x*.png *crop.png
