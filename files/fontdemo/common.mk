# ======================================================================
# Makefile - crops and enlarges details from screenshots
# ======================================================================

# Commands
CONVERT := convert
OPTIPNG := optipng

# Command options
cropTTF := -crop 67x14+253+73 +repage
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
    8xdefault-libfreetype.so.6.3.16-OTF.png \
    8xdefault-libfreetype.so.6.3.16-TTF.png \
    8xdefault-libfreetype.so.6.11.1-OTF.png \
    8xdefault-libfreetype.so.6.11.1-TTF.png \
    8xdefault-libfreetype.so.6.12.1-OTF.png \
    8xdefault-libfreetype.so.6.12.1-TTF.png \
    8xdefault-libfreetype.so.6.15.0-OTF.png \
    8xdefault-libfreetype.so.6.15.0-TTF.png \
    8xdefault-libfreetype.so.6.16.1-OTF.png \
    8xdefault-libfreetype.so.6.16.1-TTF.png \
    8xenabled-libfreetype.so.6.3.16-OTF.png \
    8xenabled-libfreetype.so.6.3.16-TTF.png \
    8xenabled-libfreetype.so.6.11.1-OTF.png \
    8xenabled-libfreetype.so.6.11.1-TTF.png \
    8xenabled-libfreetype.so.6.12.1-OTF.png \
    8xenabled-libfreetype.so.6.12.1-TTF.png \
    8xenabled-libfreetype.so.6.15.0-OTF.png \
    8xenabled-libfreetype.so.6.15.0-TTF.png \
    8xenabled-libfreetype.so.6.16.1-OTF.png \
    8xenabled-libfreetype.so.6.16.1-TTF.png

clean:
	rm -f 8x*.png *crop.png
