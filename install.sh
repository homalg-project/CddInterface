#!/bin/bash

set -e # abort upon error

if [ "$#" -ge 1 ]; then
    gap_path=$1
    shift
else
    gap_path=../..
fi

current_dir=$(pwd)
cd $gap_path

if [ -f "sysinfo.gap" ]; then
    echo "Ok, thanks I found the gap installation."
else
    echo "ERROR: It seems that the given location for gap installation is not correct."
    echo "The given location is $(pwd)."
    exit 1
fi

cd $current_dir

echo "## Setting variables"
echo "I am now in $(pwd)"

cddlib_VERSION=0.94m
#cddlib_SHA256=?
cddlib_BASE=cddlib-${cddlib_VERSION}
cddlib_TAR=${cddlib_BASE}.tar.gz
cddlib_URL=https://github.com/cddlib/cddlib/releases/download/${cddlib_VERSION}/${cddlib_TAR}

echo
echo "##"
echo "## downloading ${cddlib_TAR}"
echo "##"

rm -rf cddlib*
rm -rf current_cddlib
etc/download.sh ${cddlib_URL}
tar xvf ${cddlib_TAR}
ln -sf $current_dir/${cddlib_BASE} $current_dir/current_cddlib
rm -rf ${cddlib_TAR}

echo "##"
echo "## compiling cddlib ${cddlib_VERSION}"
echo "##"

cd ${cddlib_BASE}
mkdir build
./bootstrap
./configure --prefix=$(pwd)/build
make
make install

echo "##"
echo "## compiling cdd interface"
echo "##"

cd $current_dir
./autogen.sh
./configure --with-gaproot=${gap_path} --with-cddlib=$(pwd)/current_cddlib/build
make
