#!/bin/bash

WD=${1:?Provide a top-level directory path}
b=${2:?Provide the number of simulations to check}
c=${3:?Check zip or folders? 1 for folders}

a=3
cd "${WD}"/results/ibamr/3hair_runs/


if(($c==1)); then
  echo "Testing folders"
  for i in `seq 1 $b`; do
    test -d "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i}/lag_data.cycle_030000 && echo "Simulation found" || echo "Folder ${i} missing."
  done
else
  echo "Testing zip files"
  for i in `seq 1 $b`; do
    test -f "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i}.zip && echo "File found" || echo "File ${i} not found."
  done
fi
