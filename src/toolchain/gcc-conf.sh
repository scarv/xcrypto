#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

export RISCV=$INSTALL_DIR

mkdir -p $INSTALL_DIR

# ------ GCC ---------------------------------------------------------------

refresh_dir  $DIR_GCC_BUILD
cd           $DIR_GCC_BUILD
$DIR_GCC/configure \
    --prefix=$INSTALL_DIR \
    --enable-languages=c \
    --disable-libssp \
    --disable-float --disable-atomic \
    --target=$TARGET_ARCH \
    --with-arch=$ARCH_STRING --with-abi=$ABI_STRING

