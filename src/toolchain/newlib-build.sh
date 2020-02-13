#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

export RISCV=$INSTALL_DIR

mkdir -p $INSTALL_DIR

# ------ Newlib ------------------------------------------------------------

cd           $DIR_NEWLIB_BUILD

export PATH="$RISCV/bin:$PATH"

make -j$(nproc)
make install

