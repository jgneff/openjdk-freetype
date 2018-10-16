# OpenJDK FreeType Font Fix

This repository is a NetBeans project for comparing the text rendering of various builds of OpenJDK and FreeType. The project contains a simple Java Swing application called [FontDemo](src/org/status6/FontDemo.java "FontDemo.java") that displays two text areas with the [Source Code Pro](https://github.com/adobe-fonts/source-code-pro "Monospaced font family for user interface and coding environments") font in TTF and OTF formats (the latest non-variable download).

The goal of this repository was to report the severe color fringes in text rendered by OpenJDK on Ubuntu, and the problem is now being tracked by [JDK-8212071](https://bugs.openjdk.java.net/browse/JDK-8212071 "Need to set the FreeType LCD Filter to reduce fringing."). Please see this repository’s [Wiki](https://github.com/jgneff/openjdk-freetype/wiki "Home") for the original [Request for Enhancement](https://github.com/jgneff/openjdk-freetype/wiki/OpenJDK-FreeType-Font-Fix "OpenJDK FreeType Font Fix") and all of the test results.

For example, the following two screenshots show the FontDemo application running on Ubuntu 18.04.1 LTS with two builds of OpenJDK: one that does not set the LCD filter (left), and the other that sets the default LCD filter (right).

| ![Text rendered without an LCD filter. Screenshot.](images/01-system-lcdnone.png) | ![Text rendered with the default LCD filter. Screenshot.](images/02-system-lcddefault.png) |
|:-------------:|:------------------:|
| No LCD filter | Default LCD filter |

## Prerequisites

I built four editions of the JDK from the latest OpenJDK sources. I built one that uses the system FreeType library and another that uses the bundled FreeType library. I then [changed the OpenJDK code](https://github.com/jgneff/openjdk-freetype/commit/0adb0e2fe6905a1a6efdd30011d32911f17c6331 "Set the default FreeType LCD filter") to set the default LCD filter and built the two editions again.

| OpenJDK     | lcdnone                | lcddefault                |
| ----------- | ---------------------- | ------------------------- |
| **system**  | jdk-12-system-lcdnone  | jdk-12-system-lcddefault  |
| **bundled** | jdk-12-bundled-lcdnone | jdk-12-bundled-lcddefault |

I built 14 editions of the FreeType library. I built each of the following FreeType versions with the ClearType methods disabled (the library default). I then defined the configuration macro `FT_CONFIG_OPTION_SUBPIXEL_RENDERING` and built them again with the ClearType methods enabled.

| Year | FreeType | Library | Included With    |
| ---- | -------- | ------- | ---------------- |
| 2008 | 2.3.5    | 6.3.16  | Ubuntu 8.04 LTS  |
| 2010 | 2.3.11   | 6.3.22  | Ubuntu 10.04 LTS |
| 2012 | 2.4.8    | 6.8.0   | Ubuntu 12.04 LTS |
| 2014 | 2.5.2    | 6.11.1  | Ubuntu 14.04 LTS |
| 2016 | 2.6.1    | 6.12.1  | Ubuntu 16.04 LTS |
| 2018 | 2.8.1    | 6.15.0  | Ubuntu 18.04 LTS |
| 2019 | 2.9.1    | 6.16.1  | OpenJDK 12       |

## Running the Tests

I automated the tests with the Bash script [fontdemo.sh](bin/fontdemo.sh "Runs the FontDemo Swing application with various FreeType libraries"). The script loops over the builds of OpenJDK that use the system library and assumes they are installed in `$HOME/opt`. The FreeType libraries are expected to be found under `$HOME/lib/amd64/default` or `$HOME/lib/amd64/enabled`, depending on whether the ClearType methods are disabled (the default) or enabled. The script runs the Java Swing application 28 times covering seven FreeType versions, built with and without the ClearType methods enabled, and two OpenJDK builds, with and without setting the LCD filter.

See this repository’s [Wiki](https://github.com/jgneff/openjdk-freetype/wiki "Home") for all of the test results.

## Built With

The FontDemo application is built with NetBeans 9 running under OpenJDK 11.

* [Apache NetBeans IDE 9.0](https://netbeans.apache.org/ "Welcome to Apache NetBeans")
* [OpenJDK 11](https://jdk.java.net/11/ "JDK 11 General-Availability Release")

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

Fonts by Adobe Systems, 2012, licensed under the [SIL Open Font License Version 1.1](src/org/status6/SourceCodePro-LICENSE). Prose by Mary Shelley, 1818, in the public domain. ([Read on](https://standardebooks.org/ "Standard Ebooks") and [contribute](https://github.com/standardebooks "Standard Ebooks on GitHub")!)
