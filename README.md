## Overview

This repository describes an error in the OpenJDK font rendering on Ubuntu and other Debian-based distributions which is fixed in OpenJDK 12. The bug itself is described on this page under the **Report Classification** heading. See the [repository Wiki](https://github.com/jgneff/openjdk-freetype/wiki "Home") for more information about this repository and detailed test results of [OpenJDK](https://github.com/jgneff/openjdk-freetype/wiki/OpenJDK-FreeType-Tests) (Java Swing) and [OpenJFX](https://github.com/jgneff/openjdk-freetype/wiki/OpenJFX-FreeType-Tests) (JavaFX) with different versions of the FreeType library.

### History

* **2018-10-08:** Published this repository to demonstrate the problem.
* **2018-10-11:** Helped create Java bug report [JDK-8212071](https://bugs.openjdk.java.net/browse/JDK-8212071 "Java Bug System"), “Need to set the FreeType LCD Filter to reduce fringing.”
* **2018-10-16:** Provided the fix in [OpenJDK 12](https://jdk.java.net/12/ "JDK 12 Release-Candidate Builds") build 17 or later.
* **2019-02-07:** Created Ubuntu bug report [Bug #1815119](https://bugs.launchpad.net/ubuntu/+source/openjdk-lts/+bug/1815119 "Ubuntu openjdk-lts package"), “Backport JDK-8212071 font fix to OpenJDK 11.”
* **2019-03-19:** The [JDK 12 General-Availability Release](https://jdk.java.net/12/ "JDK 12 General-Availability Release") is published and includes this fix.

## Report Classification

**Issue Type:** Request for Enhancement  
**Component:** Client Libraries  
**Subcomponent:** *2d:* Java 2D API  
**Operating System:** Ubuntu  
**Java Release:** 12  

## Report Details

### Synopsis

Reduce color fringes in FreeType subpixel rendering

### Description

The text in Java applications often has severe color fringes using OpenJDK on Ubuntu. I may have figured out why, along with an easy fix.

#### The History

The problem originates in decisions made by the developers of FreeType, Debian, Fedora, and OpenJDK concerning the [Microsoft ClearType patents](http://david.freetype.org/cleartype-patents.html "ClearType Patents, FreeType and the Unix Desktop: an explanation").

* In **2007**, FreeType 2.3.0 added a compiler configuration macro to the file `ftoption.h` named `FT_CONFIG_OPTION_SUBPIXEL_RENDERING`. If defined, the FreeType library includes patented ClearType techniques in its subpixel rendering.

    But there’s a catch. When the ClearType methods are enabled, the subpixel rendering is not filtered, which results in severe color fringes. Clients of the FreeType library must make an explicit call to the function `FT_Library_SetLcdFilter` to apply color filtering. The filter was disabled by default, explained one of its authors, “to avoid major surprises to existing clients, including libXft and Cairo which already perform some wacky color filtering on top of FreeType.”

* In **2009**, Debian created a patch to FreeType 2.3.9, named `enable-subpixel-rendering.patch`, that defines the macro and enables ClearType-style rendering. The change log states, “This is considered no more or less evil than the bytecode interpreter which we also enable.” Ubuntu, based on Debian, applies the patch as well. Fedora created the same patch in 2007, named `freetype-2.3.0-enable-spr.patch`, but does not apply the patch by default.

* In **2017**, FreeType 2.8.1 included a new subpixel rendering technique, called *Harmony*, that is nearly identical in output to the ClearType technique but uses a different algorithm, avoiding the patents. FreeType now uses Harmony subpixel rendering when the ClearType methods are disabled, with no need for clients to set the LCD filter. (This would have been a good time for Debian to remove its subpixel rendering patch.) The latest Fedora Workstation 28 runs FreeType 2.8.0, which does not include Harmony.

* In **2019**, the Microsoft ClearType patents expire.

So now we have two variants of the FreeType library: one that requires a function call to set the LCD filter in Ubuntu and other distributions based on Debian, and another that doesn’t require the function call in Red Hat Enterprise Linux, Oracle Linux, and other distributions based on Fedora.

#### The Request

This is a request for OpenJDK to reduce the color fringes in subpixel rendering by [adding the following two lines](https://github.com/jgneff/openjdk-freetype/commit/0adb0e2fe6905a1a6efdd30011d32911f17c6331 "Set the default FreeType LCD filter") to `freetypeScaler.c`.

**java.desktop/share/native/libfontmanager/freetypeScaler.c**

```C
#include FT_LCD_FILTER_H
FT_Library_SetLcdFilter(scalerInfo->library, FT_LCD_FILTER_DEFAULT);
```

There are alternatives to setting the filter:

* Bundle the FreeType library by default and always use the new Harmony subpixel rendering technique. This option removes the uncertainty in the library at the expense of an additional 4.6 megabytes to the installed size—an increase of less than one percent. OpenJDK 12 even includes the latest FreeType 2.9.1, a newer version than the one found on most systems.

* Wait another year and see what changes are made to FreeType, if any, when the ClearType patents expire. This option, though, doesn’t solve the problem that users of Ubuntu and other Debian-based distributions have now.

#### The Application

To demonstrate the problem, I built four versions of the JDK from the latest OpenJDK sources. I built a version that uses the system FreeType library and another that uses the bundled FreeType library. Then I changed the OpenJDK code to set the default LCD filter and built the two versions again.

| OpenJDK     | lcdnone                | lcddefault                |
| ----------- | ---------------------- | ------------------------- |
| **system**  | jdk-12-system-lcdnone  | jdk-12-system-lcddefault  |
| **bundled** | jdk-12-bundled-lcdnone | jdk-12-bundled-lcddefault |

The system library is FreeType 2.8.1 in Ubuntu 18.04.1 LTS, which has the Debian patch applied (ClearType methods enabled), while the bundled library is FreeType 2.9.1 in OpenJDK 12, which uses the library default (ClearType methods disabled). I wrote a simple Java Swing application called [FontDemo](src/org/status6/FontDemo.java "FontDemo.java") that displays two text areas with the [Source Code Pro](https://github.com/adobe-fonts/source-code-pro "Monospaced font family for user interface and coding environments") font in TTF and OTF formats (the latest non-variable download). The results are shown below.

#### System FreeType Library

In this case, setting the LCD filter is critical. The screenshots below show the ClearType-style rendering without setting the LCD filter on the left (lcdnone), and after adding the change to set the filter on the right (lcddefault). The ClearType configuration macro is defined in the Ubuntu build of FreeType, so the function to set the filter returns success (0) when called and applies color filtering.

| ![Text rendered without an LCD filter. Screenshot.](images/01-system-lcdnone.png) | ![Text rendered with the default LCD filter. Screenshot.](images/02-system-lcddefault.png) |
|:------------------------:|:--------------------------:|
| Before (system, lcdnone) | After (system, lcddefault) |

The color fringes are more visible in the images below, cropped from the TrueType font in the upper text areas and scaled by 800 percent.

| ![Detail of text rendered without an LCD filter.](images/zoom-TTF-01-system-lcdnone.png) |
|:--------------------------------------------------:|
| Before (system, lcdnone): ClearType with no fitler |

| ![Detail of text rendered with the default LCD filter.](images/zoom-TTF-02-system-lcddefault.png) |
|:---------------------------------------------------------:|
| After (system, lcddefault): ClearType with default filter |

#### Bundled FreeType Library

In this case, setting the LCD filter does nothing. The screenshots below show the FreeType Harmony rendering without setting the LCD filter on the left (lcdnone), and after adding the change to set the filter on the right (lcddefault). The ClearType configuration macro is not defined in the OpenJDK build of FreeType, so the function to set the filter returns `FT_Err_Unimplemented_Feature` (7) when called and does nothing. The two images are **identical**.

| ![Text rendered without an LCD filter. Screenshot.](images/03-bundled-lcdnone.png) | ![Text rendered with the default LCD filter. Screenshot.](images/04-bundled-lcddefault.png) |
|:-------------------------:|:---------------------------:|
| Before (bundled, lcdnone) | After (bundled, lcddefault) |

The two TrueType scaled images are also **identical**.

| ![Detail of text rendered without an LCD filter.](images/zoom-TTF-03-bundled-lcdnone.png) |
|:----------------------------------:|
| Before (bundled, lcdnone): Harmony |

| ![Detail of text rendered with the default LCD filter.](images/zoom-TTF-04-bundled-lcddefault.png) |
|:------------------------------------:|
| After (bundled, lcddefault): Harmony |

### System / OS / Java Runtime Information

The test system is a QEMU/KVM guest virtual machine running Ubuntu 18.04.1 LTS (Bionic Beaver) with the details shown below. The display is a 27-inch Dell UltraSharp U2717D monitor with a resolution of 2560 × 1440 pixels at 109 pixels per inch.

```ShellSession
ubuntu@bionic:~$ uname -a
Linux bionic 4.15.0-36-generic #39-Ubuntu SMP
Mon Sep 24 16:19:09 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

ubuntu@bionic:~$ ldd --version
ldd (Ubuntu GLIBC 2.27-3ubuntu1) 2.27
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.

ubuntu@bionic:~$ getconf GNU_LIBPTHREAD_VERSION
NPTL 2.27

ubuntu@bionic:~$ $HOME/opt/jdk-12-system-lcdnone/bin/java -version
openjdk version "12-internal" 2019-03-19
OpenJDK Runtime Environment (build 12-internal+0-adhoc.ubuntu.jdk)
OpenJDK 64-Bit Server VM (build 12-internal+0-adhoc.ubuntu.jdk, mixed mode)
```

## Additional Information

### Background

For background information on LCD filters see [Section 2.2.1](http://rastertragedy.com/RTRCh2.htm#Sec21 "Sub-Pixel Anti-Aliasing Methods compared") of *The Raster Tragedy at Low-Resolution*, which has an interactive demonstration of the filters used in ClearType (Microsoft), CoolType (Adobe), FreeType (open source), and Quartz 2D (Apple). Hover your mouse over each of the samples in the illustration to remove the filter.

### Full Test Results

The results of 28 tests using seven versions of FreeType, with and without the ClearType methods enabled, and two builds of the latest JDK, with and without setting the LCD filter, are found on the Wiki page [OpenJDK FreeType Tests](https://github.com/jgneff/openjdk-freetype/wiki/OpenJDK-FreeType-Tests).

For the results of the corresponding tests with the latest JavaFX, see the Wiki page [OpenJFX FreeType Tests](https://github.com/jgneff/openjdk-freetype/wiki/OpenJFX-FreeType-Tests).

### The Macro

Below is the relevant section of the file `ftoption.h` in FreeType 2.9.1 bundled with OpenJDK 12.

**java.desktop/share/native/libfreetype/include/freetype/config/ftoption.h**

```C
  /*************************************************************************/
  /*                                                                       */
  /* Uncomment the line below if you want to activate LCD rendering        */
  /* technology similar to ClearType in this build of the library.  This   */
  /* technology triples the resolution in the direction color subpixels.   */
  /* To mitigate color fringes inherent to this technology, you also need  */
  /* to explicitly set up LCD filtering.                                   */
  /*                                                                       */
  /* Note that this feature is covered by several Microsoft patents        */
  /* and should not be activated in any default build of the library.      */
  /* When this macro is not defined, FreeType offers alternative LCD       */
  /* rendering technology that produces excellent output without LCD       */
  /* filtering.                                                            */
  /*                                                                       */
/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */
```
