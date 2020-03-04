#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

# ------ Binutils ----------------------------------------------------------

cd           $DIR_SPIKE
git apply    $PATCH_SPIKE
git add      --all

