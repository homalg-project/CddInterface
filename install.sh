#!/bin/bash

gap_path=$1
current_dir=$(pwd)

echo "Building cdd"

cd cddlib
make clean
./bootstrap.sh
mkdir build
./configure --prefix=$(pwd)/build
make
make install

echo "building cdd interface"

cd $current_dir
./autogen.sh
./configure --with-gaproot=${gap_path} --with-cddlib=$(pwd)/cddlib/build
make
