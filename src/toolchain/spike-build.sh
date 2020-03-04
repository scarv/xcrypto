#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

export RISCV=$INSTALL_DIR

mkdir -p $INSTALL_DIR

# ------ Spike -------------------------------------------------------------

cd           $DIR_SPIKE_BUILD

make 
make install

