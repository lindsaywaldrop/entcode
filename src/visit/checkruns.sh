#!/bin/bash

WD=${1:?Provide a top-level directory path}
a=${2:?Provide the number of hairs in the array}
b=${3:?Provide the number of simulations to check}

cd "${WD}"/results/ibamr/${a}hair_runs/

for i in `seq 1 $b`; do 
test -d viz_IB2d${i}/lag_data.cycle_030000 && echo "Simulation found" || echo "Simulation ${i} missing."
#test -f "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i}.zip && echo "File found" || echo "File ${i} not found."
done

