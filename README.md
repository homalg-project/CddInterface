[![Build Status](https://github.com/homalg-project/CddInterface/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/homalg-project/CddInterface/actions?query=workflow%3ACI+branch%3Amaster)
[![Code Coverage](https://codecov.io/github/homalg-project/CddInterface/coverage.svg?branch=master&token=)](https://codecov.io/gh/homalg-project/CddInterface)

# The GAP 4 package `CddInterface'

## Why CddInterface

Every convex polyhedron P has two representations, one as the intersection of finite halfspaces and the other as Minkowski sum of the convex hull of
finite points and the nonnegative hull of finite directions. These are called H-representation and V-representation, respectively.

[CddInterface](https://homalg-project.github.io/CddInterface/) is a gap interface with the C package [Cddlib
](https://www.inf.ethz.ch/personal/fukudak/cdd_home/) which among other things can translate between H,V- representations of a polyhedron P and solve linear programming problems over P, i.e. a problem of maximizing and minimizing a linear function over P. A list of all available operations can be found in the [manual.pdf](https://homalg-project.github.io/CddInterface/manual.pdf).

## Prerequisites

To use CddInterace, it has to be compiled. That means you need at the very
least a C compiler on your system. If you managed to install GAP, you probably
already have one, so we won't cover this here. However, various other
prerequisites are needed, described below.

### ... when building from a `git` clone

If you are building CddInterface directly from `git`, you first need
to generate the `configure` script. This require autoconf. On
Debian and Ubuntu, you can install it via
    
    sudo apt-get install autoconf

On macOS, if you are using Homebrew, you can install it via

    brew install autoconf

Then run

    ./autogen.sh

Now proceed as in the next section

### ... when building a release version

Compiling CddInterface requires development headers for the GMP library as well
as for cddlib. On Debian or Ubuntu, you can install these via

    sudo apt-get install libgmp-dev libcdd-dev

On macOS, if you are using Homebrew, you can install them via

    brew install gmp cddlib

Most other package managers include comparable packages, at least for GMP.
For cddlib, if your package manager does not provide it, we describe
further down how to install it yourself.


## Installation

Assuming the prerequisites are present (see the previous section),
you can now build cddlib as follows:

    ./configure --with-gaproot=path/to/gaproot
    make

where the `path/to/gaproot` is the path to the folder where you installed and
compiled GAP and which contains the file `sysinfo.gap`. The default value is
`../..`.

## Simple installation (includes building the current cdd from source):

For a simplified installation, try the following command in the main CddInterface directory

    ./install.sh path/to/gaproot

If that does not work, try the following:

## Advanced installation (includes building the current cdd from source):

Go inside the CddInterface directory and download some release of
[cddlib](https://github.com/cddlib/cddlib/releases) and extract it. For
example the release 0.94m:
    
    wget https://github.com/cddlib/cddlib/releases/download/0.94m/cddlib-0.94m.tar.gz
    tar xvf cddlib-0.94m.tar.gz
    ln -sf $(pwd)/cddlib-0.94m $(pwd)/current_cddlib

After that, compile cddlib via
    
    cd current_cddlib
    mkdir build
    ./bootstrap
    ./configure --prefix=$(pwd)/build
    make
    make install

Cdd should now be installed in the `build` directory. After that, go back to the CddInterface main folder
and install CddInterface with the following commands

    ./autogen.sh
    ./configure --with-gaproot=path/to/gaproot --with-cddlib=$(pwd)/current_cddlib/build
    make

After that, you should be able to load CddInterface.

## Documentation
To create the documentation:
    
    gap makedoc.g

To run the test files

    gap tst/testall.g
    
## Update
The package can be updated using the following commands

    git pull
    make

## Using the package via Docker
With docker app you can run an image of the newest version of gap && CddInterface via
the command

    docker run -it ghcr.io/homalg-project/gap-docker-master:latest

## License

CddInterface is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.
