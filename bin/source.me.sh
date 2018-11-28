
#!/bin/sh


echo "-------------------------[Setting Up Project]--------------------------"

# Top level environment variables
export XC_HOME=`pwd`
export XC_WORK=$XC_HOME/work
export LIBSCARV=$XC_HOME/external/libscarv

if [ -z $YS_INSTALL ] ; then
    # Export a dummy "Yosys Root" path environment variable.
    export YS_INSTALL=
fi

if [ -z $RISCV ] ; then
    echo "[WARN] No 'RISCV' environment variable defined"
fi

if [ -z $VERILATOR_ROOT ] ; then
    echo "[WARN] No 'VERILATOR_ROOT' environment variable defined"
    echo "       - See $XC_HOME/flow/verilator/README.md"
fi

mkdir -p $XC_WORK

echo "XC_HOME        = $XC_HOME"
echo "XC_WORK        = $XC_WORK"
echo "YS_INSTALL     = $YS_INSTALL"
echo "LIBSCARV       = $LIBSCARV"
echo "RISCV          = $RISCV"
echo "VERILATOR_ROOT = $VERILATOR_ROOT"

echo "------------------------------[Finished]-------------------------------"
