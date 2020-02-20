#!/bin/bash

# Copyright (C) 2019 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which
# can be found at https://opensource.org/licenses/MIT (or should be included
# as LICENSE.txt within the associated archive or repository).

echo "-------------------------[Setting Up Project]--------------------------"

export REPO_HOME="${PWD}"
export REPO_BUILD=$REPO_HOME/build

export REPO_VERSION_MAJOR="1"
export REPO_VERSION_MINOR="1"
export REPO_VERSION_PATCH="0"
export REPO_VERSION="${REPO_VERSION_MAJOR}.${REPO_VERSION_MINOR}.${REPO_VERSION_PATCH}"

if [ -z $RISCV ] ; then
    export RISCV=$REPO_BUILD/toolchain/install
    echo "\$RISCV is empty. Setting to '$RISCV'"
else
    echo "\$RISCV is already set to '$RISCV'"
fi

export TEXMFLOCAL="${TEXMFLOCAL}:${REPO_HOME}/extern/texmf"

if [ -z $YOSYS_ROOT ] ; then
    # Export a dummy "Yosys Root" path environment variable.
    export YOSYS_ROOT=/usr/bin
    echo "\$YOSYS_ROOT is empty. Setting to '$YOSYS_ROOT'"
fi

echo "----"
echo "REPO_HOME      = $REPO_HOME"
echo "REPO_BUILD     = $REPO_BUILD"
echo "REPO_VERSION   = $REPO_VERSION"
echo "YOSYS_ROOT     = $YOSYS_ROOT"
echo "RISCV          = $RISCV"

echo "------------------------------[Finished]-------------------------------"

