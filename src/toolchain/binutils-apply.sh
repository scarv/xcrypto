#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

# ------ Binutils ----------------------------------------------------------

cd           $DIR_BINUTILS
git apply    $PATCH_BINUTILS
git add      --all

