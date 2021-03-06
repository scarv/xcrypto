#!/bin/bash

source $REPO_HOME/src/toolchain/share.sh

echo "Setting up toolchain..."
echo "---------------------------------------------------"
echo "Download Dir    : $DIR_BASE"
echo "Installation Dir: $INSTALL_DIR"
echo "Target Arch     : $TARGET_ARCH / $ARCH_STRING / $ABI_STRING"
echo "GCC Commit      : $COMMIT_GCC"
echo "Binutils Commit : $COMMIT_BINUTILS"
echo "Spike Commit    : $COMMIT_SPIKE"
echo ""
echo "DIR_GCC         = $DIR_GCC"
echo "DIR_BINUTILS    = $DIR_BINUTILS"
echo "DIR_NEWLIB      = $DIR_NEWLIB"
echo "DIR_PK          = $DIR_PK"
echo "DIR_SPIKE       = $DIR_SPIKE"
echo ""
echo "Branch Name     = $BRANCH_NAME"
echo "---------------------------------------------------"

set -e
set -x

# ------ Binutils ----------------------------------------------------------

if [ ! -d $DIR_BINUTILS ]; then
    git clone https://github.com/riscv/riscv-binutils-gdb.git $DIR_BINUTILS
fi

cd $DIR_BINUTILS
git fetch origin $COMMIT_BINUTILS:$BRANCH_NAME
git checkout $BRANCH_NAME
cd -

# ------ GCC ---------------------------------------------------------------

if [ ! -d $DIR_GCC ]; then
    git clone https://github.com/riscv/riscv-gcc.git $DIR_GCC
fi

cd $DIR_GCC
git fetch origin $COMMIT_GCC:$BRANCH_NAME
git checkout $BRANCH_NAME
./contrib/download_prerequisites
cd -

# ------ NewLib ------------------------------------------------------------

if [ ! -d $DIR_NEWLIB ]; then
    git clone https://github.com/riscv/riscv-newlib.git $DIR_NEWLIB
fi

cd $DIR_NEWLIB
git checkout -B $BRANCH_NAME
cd -

# ------ Proxy Kernel (PK) -------------------------------------------------

if [ ! -d $DIR_PK ]; then
    git clone https://github.com/riscv/riscv-pk.git $DIR_PK
fi

cd $DIR_PK
git checkout -B $BRANCH_NAME
cd -

# ------ SPIKE ISA Simulator -----------------------------------------------

if [ ! -d $DIR_SPIKE ]; then
    git clone https://github.com/riscv/riscv-isa-sim.git $DIR_SPIKE
fi

cd $DIR_SPIKE
git fetch origin $COMMIT_SPIKE:$BRANCH_NAME
git checkout $BRANCH_NAME
cd -

# --------------------------------------------------------------------------

