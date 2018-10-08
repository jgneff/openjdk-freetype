# ======================================================================
# Makefile - crops and enlarges details from screenshots
# ======================================================================

# Commands
CONVERT := convert
OPTIPNG := optipng

# Command options
cropTTF := -crop 67x14+253+74 +repage
cropOTF := -crop 67x14+253+265 +repage
scale8x := -scale 800%

# ======================================================================
# Pattern rules
# ======================================================================

%-TTF-crop.png: %.png
	$(CONVERT) $< $(cropTTF) $@

%-OTF-crop.png: %.png
	$(CONVERT) $< $(cropOTF) $@

8x%.png: %-crop.png
	$(CONVERT) $< $(scale8x) $@
	$(OPTIPNG) -quiet $@

# ======================================================================
# Explicit rules
# ======================================================================

.PHONY: all clean

all: \
    8x01-system-lcdnone-TTF.png \
    8x02-system-lcddefault-TTF.png \
    8x03-bundled-lcdnone-TTF.png \
    8x04-bundled-lcddefault-TTF.png \
    8x01-system-lcdnone-OTF.png \
    8x02-system-lcddefault-OTF.png \
    8x03-bundled-lcdnone-OTF.png \
    8x04-bundled-lcddefault-OTF.png

clean:
	rm -f 8x*.png *crop.png
