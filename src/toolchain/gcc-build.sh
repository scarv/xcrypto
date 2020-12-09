#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

export RISCV=$INSTALL_DIR

mkdir -p $INSTALL_DIR

# ------ GCC ---------------------------------------------------------------

cd   $DIR_GCC_BUILD

make -j4
make install

