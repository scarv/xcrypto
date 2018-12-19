#!/bin/sh
cd $XC_HOME
mkdir -p work
cd work
git clone --branch riscv-binutils-2.30 https://github.com/riscv/riscv-binutils-gdb.git
cd riscv-binutils-gdb
git checkout .
git apply --apply $XC_HOME/external/riscv-binutils-gdb-2.30.patch

OUT=$?
if [ $OUT -eq 0 ];then
    mkdir build
    cd build
    ../configure --target=riscv32
    make -j 4
else
   echo "Failed to apply patch!"
fi

cd $XC_HOME
