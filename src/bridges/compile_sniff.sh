#!/bin/bash

#Shell script for compiling the main2d program in IBAMR. To be run on Bridges.
WD=${1:?Please provide a path for the main directory}
a=${2:?Provide a simulation set number}

if [ -z "$WD" ]; then
  echo "\$WD is empty, please define WD in the top-level directory before proceeding with setup."
      exit
fi
path2=`basename "$WD"`
if [ "$path2" != "entcode" ]; then
  echo "\$WD does not describe the top-level directory. Go to 'entcode/' folder and try redefining WD."
  exit
fi

if [ "$a" = "165" ]; then
  echo "Setting up for 165 simulations"
elif [ "$a" = "681" ]; then
  echo "Setting up for 681 simulations"
elif [ "$a" = "1233" ]; then
  echo "Setting up for 1233 simulations"
else 
  echo "Error: simulation set not recognized"
  echo "Choose: 165, 681, or 1233"
  exit
fi

cd "$WD"
echo "Setting up directories..."
mkdir bin/
mkdir results/
mkdir results/ibamr
mkdir results/ibamr/runs/
mkdir results/ibamr/log-files/
mkdir results/visit/
mkdir results/visit/3hair_runs/
mkdir results/visit/5hair_runs/
mkdir results/visit/7hair_runs/
mkdir results/visit/12hair_runs/
mkdir results/visit/18hair_runs/
mkdir results/visit/25hair_runs/
mkdir results/r-csv-files/
mkdir results/odorcapture/
mkdir -p results/odorcapture/3hair_array/air/
mkdir -p results/odorcapture/3hair_array/water/
mkdir -p results/odorcapture/5hair_array/air/
mkdir -p results/odorcapture/5hair_array/water/
mkdir -p results/odorcapture/7hair_array/air/
mkdir -p results/odorcapture/7hair_array/water/
mkdir -p results/odorcapture/12hair_array/air/
mkdir -p results/odorcapture/12hair_array/water/
mkdir -p results/odorcapture/18hair_array/air/
mkdir -p results/odorcapture/18hair_array/water/
mkdir -p results/odorcapture/25hair_array/air/
mkdir -p results/odorcapture/25hair_array/water/
mkdir data/
mkdir data/vertex-files/
mkdir data/csv-files/
mkdir data/hairinfo-files/
mkdir data/lineout-files/
mkdir data/input2d-files/

cd "$WD"/src/ibamr
echo "Compiling main2d..."
make clean
make main2d
mv main2d "$WD"/bin
rm *.o stamp-2d

echo "Setting up input2d files..."
cd "$WD"/src/bridges/
sh setinput2d.sh "$WD" "$a"

echo "Complete"
