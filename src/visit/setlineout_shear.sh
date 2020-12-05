#!/bin/bash

WD=${1:?Please provide a top-level working directory}
a=${2:?Provide the number of hairs in the array}
b=${3:?Provide the number of simulations in the set}

cd "${WD}"/results/visit/${a}hair_runs/

# Clear hairline directories of curve files or make hairline directories. 
for i in `seq 1 $b`; do
  if [ -d "sim${i}/shear" ]; then
    rm sim${i}/shear/*.curve
  else
    mkdir -p sim${i}/shear/
  fi
done

cd "${WD}"/src/visit/

# initialize variables
HX=0
HY=0
DIST=0.004

echo "1 through $b"

# For loop that interates over simulations
for i in `seq 1 $b`; do
  # For loop that iterates over hairs 
  for j in `seq 1 ${a}`; do
    cut -d , -f $(($j+1)) "$WD"/data/csv-files/${a}hair_files/hairs${i}.csv > hair.txt
  
    # Sets Hair based on j and i
    HX=$(awk -v var="3" 'NR==var' hair.txt)
    HY=$(awk -v var="4" 'NR==var' hair.txt)
  
    /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout_shear.py \
    "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i} "$WD"/results/visit/${a}hair_runs/sim${i}/shear ${i} ${j} $HX $HY $DIST
    
    #mv "$WD"/results/visit/${a}hair_runs/sim${i}/shear/
    
  done
done

rm hair.txt