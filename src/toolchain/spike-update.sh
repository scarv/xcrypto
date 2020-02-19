#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

set -e
set -x

# ------ Spike -------------------------------------------------------------

cd           $DIR_SPIKE
git diff --cached > $PATCH_SPIKE



