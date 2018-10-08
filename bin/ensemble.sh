#!/bin/bash
# Runs the Ensemble JavaFX application with various FreeType libraries.
trap exit INT TERM
set -o errexit

# OpenJDK 11 (build 11+28)
export JDK_HOME=$HOME/opt/jdk-11
export LD_LIBRARY_PATH=$HOME/lib/amd64:$JDK_HOME/lib:/lib:/usr/lib

# Two builds of OpenJFX 12:
#   One fails to set the LCD filter (lcdnone)
#   One sets the default LCD filter (lcddefault)
#module_path=$HOME/lib/lcdnone
module_path=$HOME/lib/lcddefault

# FreeType built with the default and with ClearType methods enabled
versions="default enabled"

# Libraries of FreeType 2.3.5, 2.5.2, 2.6.1, 2.8.1, and 2.9.1
libraries="libfreetype.so.6.3.16 libfreetype.so.6.11.1 \
    libfreetype.so.6.12.1 libfreetype.so.6.15.0 libfreetype.so.6.16.1"

ln_options="--force --relative --symbolic --verbose"
libdir=$HOME/lib/amd64
libname=libfreetype.so.6
appfile=$HOME/opt/jdk1.8.0_181/demo/javafx_samples/Ensemble8.jar

# Removes the unversioned linker name of the shared library.
rm -f $libdir/libfreetype.so

# Loops through all builds and versions of the FreeType libraries.
for ver in $versions; do
    for lib in $libraries; do
        logfile=$ver-$lib.log
        printf "FreeType library = $ver-$lib\n"
        ln $ln_options $libdir/$ver/$lib $libdir/$libname >> $logfile
        $JDK_HOME/bin/java -Dprism.debugfonts=true \
            -Djava.library.path=$LD_LIBRARY_PATH \
            --module-path $module_path \
            --add-modules javafx.controls \
            -jar $appfile 2>&1 | head -n 5 >> $logfile
    done
done
