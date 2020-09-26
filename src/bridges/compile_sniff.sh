#!/bin/bash

#Shell script for compiling the main2d program in IBAMR. To be run on Bridges.
WD=${1:?Please provide a path for the main directory}

cd "$WD"
echo "Setting up directories..."
mkdir bin/
mkdir results/
mkdir results/ibamr
mkdir results/ibamr/runs/
mkdir results/ibamr/log-files/
mkdir results/visit/
mkdir results/visit/7hair_runs/
mkdir results/visit/12hair_runs/
mkdir results/visit/18hair_runs/
mkdir results/visit/25hair_runs/
mkdir data/
mkdir data/vertex-files/
mkdir data/vertex-files/7hair_files/
mkdir data/vertex-files/12hair_files/
mkdir data/vertex-files/18hair_files/
mkdir data/vertex-files/25hair_files/
mkdir data/csv-files/
mkdir data/csv-files/7hair_files/
mkdir data/csv-files/12hair_files/
mkdir data/csv-files/18hair_files/
mkdir data/csv-files/25hair_files/
mkdir data/lineout-files/
mkdir data/input2d-files/

cd "$WD"/src/ibamr
echo "Compiling main2d..."
make main2d
mv main2d "$WD"/bin
rm *.o stamp-2d

cd "$WD"/src/bridges/
echo "Complete"
