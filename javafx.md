# OpenJFX FreeType Tests

Below are my test results using five versions of FreeType built first with the ClearType methods disabled (the default) and then again with them enabled. I ran all 10 libraries under OpenJDK 11, first with OpenJFX failing to set the LCD filter and then again after adding [the fix to set the default LCD filter](https://github.com/javafxports/openjdk-jfx/pull/235 "JDK-8188810: Fonts are blurry on Ubuntu 16.04 and Debian 9").

## Before the Fix

| Year | FreeType | Library | Included With    | ClearType Off | ClearType On   |
|:----:|:--------:|:--------|:-----------------|:--------------|:---------------|
| 2008 | 2.3.5    | 6.3.16  | Ubuntu 8.04 LTS  | Mystery mix   | Severe fringes |
| 2014 | 2.5.2    | 6.11.1  | Ubuntu 14.04 LTS | Mystery mix   | Severe fringes |
| 2016 | 2.6.1    | 6.12.1  | Ubuntu 16.04 LTS | Mystery mix   | Severe fringes |
| 2018 | 2.8.1    | 6.15.0  | Ubuntu 18.04 LTS | Harmony       | Severe fringes |
| 2019 | 2.9.1    | 6.16.1  | OpenJDK 12       | Harmony       | Severe fringes |

Before the fix, OpenJFX silently fails to set the LCD filter but still returns success (0), resulting in severe color fringes when the ClearType methods are enabled.

When the ClearType methods are disabled, FreeType 2.8.1 and later uses the new *Harmony* subpixel rendering, equal in quality to ClearType. I can’t explain what happens with FreeType 2.6.1 and earlier (the *mystery mix*). The documentation says that FreeType should return a grayscale version of subpixel rendering with subpixels R=G=B, but it seems that some glyphs are rendered using grayscale anti-aliasing and others using unfiltered subpixel rendering with color fringes. Java 2D in the OpenJDK, for comparison, gets the expected grayscale anti-aliasing in these three tests.

## After the Fix

| Year | FreeType | Library | Included With    | ClearType Off | ClearType On   |
|:----:|:--------:|:--------|:-----------------|:--------------|:---------------|
| 2008 | 2.3.5    | 6.3.16  | Ubuntu 8.04 LTS  | Grayscale     | ClearType      |
| 2014 | 2.5.2    | 6.11.1  | Ubuntu 14.04 LTS | Grayscale     | ClearType      |
| 2016 | 2.6.1    | 6.12.1  | Ubuntu 16.04 LTS | Grayscale     | ClearType      |
| 2018 | 2.8.1    | 6.15.0  | Ubuntu 18.04 LTS | Grayscale     | ClearType      |
| 2019 | 2.9.1    | 6.16.1  | OpenJDK 12       | Grayscale     | ClearType      |

After the fix, OpenJFX sets the default LCD filter with `FT_Library_SetLcdFilter` and returns success (0), resulting in filtered ClearType-style subpixel rendering when the ClearType methods are enabled.

When the ClearType methods are disabled, the function to set the filter returns the error `FT_Err_Unimplemented_Feature` (7), so OpenJFX reverts to grayscale anti-aliasing. Notice that we are worse off in two of the tests: we used to have the new Harmony subpixel rendering in FreeType 2.8.1 and later, but now we have just grayscale anti-aliasing. We could change OpenJFX to ignore the return code and get the Harmony rendering again in these two tests, at the expense of having minor color fringes in the earlier versions of FreeType (the mystery mix). On the other hand, FreeType 2.8.1 started showing up in systems only this year, and the [Microsoft ClearType patents](http://david.freetype.org/cleartype-patents.html "ClearType Patents, FreeType and the Unix Desktop: an explanation") should expire a year from now anyway, on October 7, 2019. It may be best just to wait and see what changes are made to FreeType when the patents expire.

## Screenshots

The following images show details from the screenshots taken in each of the 20 tests, scaled by 800 percent, going down the ClearType columns in order starting with the first table.

### Before the Fix

#### ClearType Methods Disabled

The first three images have an unexpected mix of some glyphs with grayscale anti-aliasing and others with unfiltered color fringes, while the last two image are the FreeType Harmony subpixel rendering, equal in quality to ClearType.

| ![](files/ensemble/lcdnone/8xdefault-libfreetype.so.6.3.16.png) |
|:---------------------------------------------:|
| Before (lcdnone, default, 2.3.5): Mystery mix |

| ![](files/ensemble/lcdnone/8xdefault-libfreetype.so.6.11.1.png) |
|:--------------------------------------------:|
| Before (lcdnone, default, 2.5.2) Mystery mix |

| ![](files/ensemble/lcdnone/8xdefault-libfreetype.so.6.12.1.png) |
|:--------------------------------------------:|
| Before (lcdnone, default, 2.6.1) Mystery mix |

| ![](files/ensemble/lcdnone/8xdefault-libfreetype.so.6.15.0.png) |
|:-----------------------------------------:|
| Before (lcdnone, default, 2.8.1): Harmony |

| ![](files/ensemble/lcdnone/8xdefault-libfreetype.so.6.16.1.png) |
|:-----------------------------------------:|
| Before (lcdnone, default, 2.9.1): Harmony |

#### ClearType Methods Enabled

All of these images show severe color fringes because OpenJFX fails to set the LCD filter.

| ![](files/ensemble/lcdnone/8xenabled-libfreetype.so.6.3.16.png) |
|:----------------------------------------------------------:|
| Before (lcdnone, enabled, 2.3.5): ClearType with no fitler |

| ![](files/ensemble/lcdnone/8xenabled-libfreetype.so.6.11.1.png) |
|:----------------------------------------------------------:|
| Before (lcdnone, enabled, 2.5.2): ClearType with no fitler |

| ![](files/ensemble/lcdnone/8xenabled-libfreetype.so.6.12.1.png) |
|:----------------------------------------------------------:|
| Before (lcdnone, enabled, 2.6.1): ClearType with no fitler |

| ![](files/ensemble/lcdnone/8xenabled-libfreetype.so.6.15.0.png) |
|:----------------------------------------------------------:|
| Before (lcdnone, enabled, 2.8.1): ClearType with no fitler |

| ![](files/ensemble/lcdnone/8xenabled-libfreetype.so.6.16.1.png) |
|:----------------------------------------------------------:|
| Before (lcdnone, enabled, 2.9.1): ClearType with no fitler |

### After the Fix

#### ClearType Methods Disabled

The function to set the filter, `FT_Library_SetLcdFilter`, returns the error `FT_Err_Unimplemented_Feature` (7), so OpenJFX reverts to grayscale anti-aliasing.

| ![](files/ensemble/lcddefault/8xdefault-libfreetype.so.6.3.16.png) |
|:-----------------------------------------------------------:|
| After (lcddefault, default, 2.3.5): Grayscale anti-aliasing |

| ![](files/ensemble/lcddefault/8xdefault-libfreetype.so.6.11.1.png) |
|:-----------------------------------------------------------:|
| After (lcddefault, default, 2.5.2): Grayscale anti-aliasing |

| ![](files/ensemble/lcddefault/8xdefault-libfreetype.so.6.12.1.png) |
|:-----------------------------------------------------------:|
| After (lcddefault, default, 2.6.1): Grayscale anti-aliasing |

| ![](files/ensemble/lcddefault/8xdefault-libfreetype.so.6.15.0.png) |
|:-----------------------------------------------------------:|
| After (lcddefault, default, 2.8.1): Grayscale anti-aliasing |

| ![](files/ensemble/lcddefault/8xdefault-libfreetype.so.6.16.1.png) |
|:-----------------------------------------------------------:|
| After (lcddefault, default, 2.9.1): Grayscale anti-aliasing |

#### ClearType Methods Enabled

The function to set the filter, `FT_Library_SetLcdFilter`, returns success (0), so OpenJFX uses subpixel rendering and FreeType applies the default LCD filter to the output of its ClearType methods.

| ![](files/ensemble/lcddefault/8xenabled-libfreetype.so.6.3.16.png) |
|:-----------------------------------------------------------------:|
| After (lcddefault, enabled, 2.3.5): ClearType with default filter |

| ![](files/ensemble/lcddefault/8xenabled-libfreetype.so.6.11.1.png) |
|:-----------------------------------------------------------------:|
| After (lcddefault, enabled, 2.5.2): ClearType with default filter |

| ![](files/ensemble/lcddefault/8xenabled-libfreetype.so.6.12.1.png) |
|:-----------------------------------------------------------------:|
| After (lcddefault, enabled, 2.6.1): ClearType with default filter |

| ![](files/ensemble/lcddefault/8xenabled-libfreetype.so.6.15.0.png) |
|:-----------------------------------------------------------------:|
| After (lcddefault, enabled, 2.8.1): ClearType with default filter |

| ![](files/ensemble/lcddefault/8xenabled-libfreetype.so.6.16.1.png) |
|:-----------------------------------------------------------------:|
| After (lcddefault, enabled, 2.9.1): ClearType with default filter |
