
#!/bin/sh


echo "-------------------------[Setting Up Project]--------------------------"

# Top level environment variables
export XC_HOME=`pwd`
export XC_WORK=$XC_HOME/work

if [ -z $YS_INSTALL ] ; then
    export YS_INSTALL=
fi

mkdir -p $XC_WORK

echo "XC_HOME    = $XC_HOME"
echo "XC_WORK    = $XC_WORK"
echo "YS_INSTALL = $YS_INSTALL"

echo "------------------------------[Finished]-------------------------------"
