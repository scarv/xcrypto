#!/bin/sh
cd $COP_HOME
mkdir -p work
cd work
git clone --branch riscv-binutils-2.30 https://github.com/riscv/riscv-binutils-gdb.git
cd riscv-binutils-gdb
git checkout .
git apply --apply $COP_HOME/external/riscv-binutils-gdb-2.30.patch
mkdir build
cd build
../configure --target=riscv32
make
cd $COP_HOME
