
#!/bin/sh


echo "-------------------------[Setting Up Project]--------------------------"

# Top level environment variables
export COP_HOME=`pwd`
export COP_WORK=$COP_HOME/work

mkdir -p $COP_WORK

echo "COP_HOME      = $COP_HOME"
echo "COP_WORK      = $COP_WORK"

echo "------------------------------[Finished]-------------------------------"
