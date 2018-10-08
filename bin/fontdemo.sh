#!/bin/bash
# Runs the FontDemo Swing application with various FreeType libraries.
trap exit INT TERM
set -o errexit

# Two builds of OpenJDK 12:
#   One does not set the LCD filter (lcdnone)
#   One sets the default LCD filter (lcddefault)
#export JDK_HOME=$HOME/opt/jdk-12-system-lcdnone
export JDK_HOME=$HOME/opt/jdk-12-system-lcddefault

export LD_LIBRARY_PATH=$HOME/lib/amd64:$JDK_HOME/lib:/lib:/usr/lib

# FreeType built with the default and with ClearType methods enabled
versions="default enabled"

# Libraries of FreeType 2.3.5, 2.5.2, 2.6.1, 2.8.1, and 2.9.1
libraries="libfreetype.so.6.3.16 libfreetype.so.6.11.1 \
    libfreetype.so.6.12.1 libfreetype.so.6.15.0 libfreetype.so.6.16.1"

ln_options="--force --relative --symbolic --verbose"
libdir=$HOME/lib/amd64
compile_name=libfreetype.so
runtime_name=libfreetype.so.6
appfile=$HOME/src/openjdk-freetype/dist/openjdk-freetype.jar

# Loops through all builds and versions of the FreeType libraries.
for ver in $versions; do
    for lib in $libraries; do
        printf "FreeType library = $ver-$lib\n"
        ln $ln_options $libdir/$ver/$lib $libdir/$compile_name
        ln $ln_options $libdir/$ver/$lib $libdir/$runtime_name
        $JDK_HOME/bin/java -Djava.library.path=$LD_LIBRARY_PATH \
            -jar $appfile
    done
done
