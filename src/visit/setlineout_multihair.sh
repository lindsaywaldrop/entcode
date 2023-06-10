#!/bin/bash

# This script calls lineout_leak.py in python and VisIt to calculate leakiness in the hair array.
# It will produce a number of curve files based on how many time steps there are in the viz_IB2d 
# folder. Use the last time step in a steady-state leakiness calculation.

WD=${1:?Please provide a top-level working directory}
a=${2:?Provide the number of hairs in the array}
row=${3:?Provide the row number to process}
startrun=${4:?Provide a starting run}
endrun=${5:?Provide an ending run}

# Setting variables for 3-hair only
#a=3
#row=1

if [ "$row" == 1 ] && [ "$a" == 5 ]; then
  filename="lineout_h5-h4.txt"
elif [ "$row" == 1 ] && [ "$a" != 5 ]; then
  filename="lineout_h3-h2.txt"
elif [ "$row" == 2 ]; then
  filename="lineout_h7-h6.txt"
elif [ "$row" == 3 ]; then
  filename="lineout_h8-h12.txt"
elif [ "$row" == 4 ]; then
  filename="lineout_h13-h18.txt"
elif [ "$row" == 5 ]; then
  filename="lineout_h19-h25.txt"
else
  echo "ERROR: row number unknown"
  exit 1
fi

echo $filename

numlines=$(grep -c "^" "$WD"/data/lineout-files/$filename)

cd "${WD}"/results/visit/${a}hair_runs/

# Clear leakiness directories of curve files or make leakiness directories. 
for i in `seq $startrun $endrun`; do
  if [ -d "sim${i}/leakiness${row}/" ]; then
    rm sim${i}/leakiness${row}/*.curve
  else
    mkdir -p sim${i}/leakiness${row}/
  fi
done

cd "${WD}"/src/visit/

# Separate main parameter file into four files
cut -f 2 "$WD"/data/lineout-files/$filename > startx.txt
cut -f 3 "$WD"/data/lineout-files/$filename > starty.txt
cut -f 4 "$WD"/data/lineout-files/$filename > endx.txt
cut -f 5 "$WD"/data/lineout-files/$filename > endy.txt

# initialize variables
SX=0
SY=0
EX=0
EY=0

# For loop that will write files
for i in `seq $startrun $endrun`; do
#for i in `seq 67 67`; do
  # Sets Wo based on i
  SX=$(awk -v var="$i" 'NR==var' startx.txt)
  SY=$(awk -v var="$i" 'NR==var' starty.txt)
  EX=$(awk -v var="$i" 'NR==var' endx.txt)
  EY=$(awk -v var="$i" 'NR==var' endy.txt)

  /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout_leak.py \
 "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i} "$WD"/results/visit/${a}hair_runs/sim${i}/leakiness${row} ${i} $SX $SY $EX $EY

done

rm startx.txt starty.txt endx.txt endy.txt 

