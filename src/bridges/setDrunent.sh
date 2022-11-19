#!/bin/bash

# What should you space the jobs by?
WD=${1:?Provide working directory}
startline=${2:?Provide start run}
endline=${3:?Provide end run}

for j in `seq $startline $endline`;do
 HX1=$(awk -v var="$j" 'NR==var' lowD.txt)
 sh setrunent.sh "$WD" $HX1 $HX1
done
