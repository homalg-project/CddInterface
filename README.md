The GAP 4 package `CddInterface'
==============================

# Install

## Simple

For a simplyfied installation, try
    install.sh <path-to-gaproot>
If that does not work, try the following

## Advanced

Go inside the cddlib directory, and create an install directory
    cd cddlib
    mkdir build
After that, compile cddlib via
    ./bootstrap.sh
    ./configure --prefix=$(pwd)/build
    make
    make install
Cdd should now be installed in the `build` directory. After that, go back to the CddInterface main folder
and install CddInterface with the following commands
    ./autogen.sh
    ./configure --with-gaproot=path/to/gaproot --with-cddlib=$(pwd)/cddlib/build
    make
After that, you should be able to load CddInterface.