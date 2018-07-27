
#!/bin/sh


echo "-------------------------[Setting Up Project]--------------------------"

# Top level environment variables
export ROP_HOME=`pwd`

if [ -n ${YOSYS_INSTALL} ]; then
    export YOSYS_INSTALL=~/yosys
fi


mkdir -p $ROP_HOME/work

echo "ROP_HOME      = $ROP_HOME"
echo "YOSYS_INSTALL = $YOSYS_INSTALL"

echo "------------------------------[Finished]-------------------------------"
