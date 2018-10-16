#!/bin/bash
# Runs the FontDemo Swing application with various FreeType libraries.
trap exit INT TERM
set -o errexit

# Builds of OpenJDK 12
#   lcdnone - does not set the LCD filter
#   lcddefault - sets the default LCD filter
lcdfilter="lcdnone lcddefault"

# Sets of FreeType libraries
#   default - ClearType methods disabled (the library default)
#   enabled - ClearType methods enabled
versions="default enabled"

# FreeType library versions
#   2.3.5  (6.3.16) in Ubuntu  8.04 LTS
#   2.3.11 (6.3.22) in Ubuntu 10.04 LTS
#   2.4.8  (6.8.0)  in Ubuntu 12.04 LTS
#   2.5.2  (6.11.1) in Ubuntu 14.04 LTS
#   2.6.1  (6.12.1) in Ubuntu 16.04 LTS
#   2.8.1  (6.15.0) in Ubuntu 18.04 LTS
#   2.9.1  (6.16.1) in OpenJDK 12 (bundled)
libraries="\
    libfreetype.so.6.3.16 \
    libfreetype.so.6.3.22 \
    libfreetype.so.6.8.0 \
    libfreetype.so.6.11.1 \
    libfreetype.so.6.12.1 \
    libfreetype.so.6.15.0 \
    libfreetype.so.6.16.1"

ln_options="--force --relative --symbolic --verbose"
libdir=$HOME/lib/amd64
compile_name=libfreetype.so
runtime_name=libfreetype.so.6
appfile=$HOME/src/openjdk-freetype/dist/openjdk-freetype.jar

# Loops through all FreeType libraries for each OpenJDK build.
for lcd in $lcdfilter; do
    export JDK_HOME=$HOME/opt/jdk-12-system-$lcd
    export LD_LIBRARY_PATH=$HOME/lib/amd64:$JDK_HOME/lib:/lib:/usr/lib
    for ver in $versions; do
        for lib in $libraries; do
            printf "Test name = $lcd-$ver-$lib\n"
            ln $ln_options $libdir/$ver/$lib $libdir/$compile_name
            ln $ln_options $libdir/$ver/$lib $libdir/$runtime_name
            $JDK_HOME/bin/java -Djava.library.path=$LD_LIBRARY_PATH \
                -jar $appfile
        done
    done
done
