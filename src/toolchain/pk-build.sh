#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

export RISCV=$INSTALL_DIR

mkdir -p $INSTALL_DIR

# ------ Proxy Kernel (PK) -------------------------------------------------

refresh_dir  $DIR_PK_BUILD
cd           $DIR_PK_BUILD

export PATH="$RISCV/bin:$PATH"

$DIR_PK/configure \
    --prefix=$INSTALL_DIR \
    --host=$TARGET_ARCH \
    --with-arch=rv32imac --with-abi=$ABI_STRING

make
make install

