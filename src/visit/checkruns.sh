#!/bin/bash

WD=${1:?Provide a top-level directory path}
b1=${2:?Provide the start number of simulations to check}
b2=${3:?Provide the end number of simulations to check}
w=${4:?Check zip or folders? 1 for folders}

a=3
cd "${WD}"/results/ibamr/3hair_runs/


if [ "$w" == "1" ]; then
  echo "Testing folders"
  for i in `seq $b1 $b2`; do
    test -d "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i}/lag_data.cycle_030000 && echo "Simulation found" || echo "Folder ${i} missing."
  done
else
  echo "Testing zip files"
  for i in `seq $b1 $b2`; do
    test -f "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i}.zip && echo "File found" || echo "File ${i} not found."
  done
fi
