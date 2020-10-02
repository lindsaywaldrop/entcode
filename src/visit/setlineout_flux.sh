#!/bin/bash

WD=${1:?Please provide a top-level working directory}
a=${2:?Provide the number of hairs in the array}

# Count number of lines in files
numlines=$(grep -c "^" "$WD"/data/lineout-files/lineout_h3-h2.txt)

cd "${WD}"/results/visit/${a}hair_runs/

# Clear hairline directories of curve files or make hairline directories. 
for i in `seq 1 $numlines`; do
  if [ -d "sim${i}/hairline_flux/" ]; then
    rm "sim${i}/hairline_flux/*.curve"
  else
    mkdir -p "sim${i}/hairline_flux/"
  fi
done

cd "${WD}"/src/visit/

# initialize variables
HX=0
HY=0
DIST=0.002


# For loop that interates over simulations
#for i in `seq 1 $numlines`; do
for i in `seq 1 1`; do

  # For loop that iterates over hairs 
  for j in `seq 1 ${a}`; do
  
    cut -d , -f $(($j+1)) "$WD"/data/csv-files/${a}hair_files/hairs${i}.csv > hair.txt

    # Sets Hair based on j and i
    HX=$(awk -v var="3" 'NR==var' hair.txt)
    HY=$(awk -v var="4" 'NR==var' hair.txt)

    /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout_flux.py \
    "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i} "$WD"/results/visit/${a}hair_runs/sim${i}/hairline_flux ${i} $HX $HY $DIST
    
    /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s Umean.py ${i} $HX $HY $DIST

  done

done

rm hair.txt
