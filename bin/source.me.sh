
#!/bin/sh


echo "-------------------------[Setting Up Project]--------------------------"

# Top level environment variables
export COP_HOME=`pwd`
export COP_WORK=$COP_HOME/work

if [ -z $YS_INSTALL ] ; then
    export YS_INSTALL=
fi

mkdir -p $COP_WORK

echo "COP_HOME      = $COP_HOME"
echo "COP_WORK      = $COP_WORK"
echo "YS_INSTALL    = $YS_INSTALL"

echo "------------------------------[Finished]-------------------------------"
