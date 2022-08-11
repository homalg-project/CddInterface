#!/bin/bash

set -e # abort upon error

if [ "$#" -ge 1 ]; then
    gap_path=$1
    shift
else
    gap_path=../..
fi

./prerequisites.sh ${gap_path}

echo "##"
echo "## compiling cdd interface"
echo "##"

./autogen.sh
./configure --with-gaproot=${gap_path} --with-cddlib=$(pwd)/current_cddlib/build
make
