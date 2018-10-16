#!/bin/bash
# Runs the Ensemble JavaFX application with various FreeType libraries.
trap exit INT TERM
set -o errexit

# OpenJDK 11 (build 11+28)
export JDK_HOME=$HOME/opt/jdk-11
export LD_LIBRARY_PATH=$HOME/lib/amd64:$JDK_HOME/lib:/lib:/usr/lib

# Sets of OpenJFX 12 modules
#   lcdnone - fails to set the LCD filter
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

lnopts="--force --relative --symbolic --verbose"
libdir=$HOME/lib/amd64
libname=libfreetype.so.6
appfile=$HOME/opt/jdk1.8.0_181/demo/javafx_samples/Ensemble8.jar

# Removes the unversioned linker name of the shared library.
rm -f $libdir/libfreetype.so

# Loops through all FreeType libraries for each set of OpenJFX modules.
for lcd in $lcdfilter; do
    for ver in $versions; do
        for lib in $libraries; do
            testname=$lcd-$ver-$lib
            printf "Test name = $testname\n"
            logfile=$testname.log
            ln $lnopts $libdir/$ver/$lib $libdir/$libname >> $logfile
            $JDK_HOME/bin/java -Dprism.debugfonts=true \
                -Djava.library.path=$LD_LIBRARY_PATH \
                --module-path $HOME/lib/$lcd \
                --add-modules javafx.controls \
                -jar $appfile 2>&1 | head -n 5 >> $logfile
        done
    done
done
