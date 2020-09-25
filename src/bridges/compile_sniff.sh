#!/bin/bash

#Shell script for compiling the main2d program in IBAMR. To be run on Bridges.
WD=${1:?Provide a path for the main directory}

cd $WD
mkdir bin/
mkdir results/
mkdir results/runs/
mkdir results/log-files/

cd "$WD"/src/ibamr
make main2d
mv main2d "$WD"/bin
rm *.o stamp-2d

cd $WD/src/bridges/
echo "Complete"
