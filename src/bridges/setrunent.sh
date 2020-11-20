#!/bin/bash

# What should you space the jobs by?
startrun=${1:?Provide start run}
endrun=${2:?Provide end run}

echo Submitting simulations $startrun to $endrun.
mkdir temp/

for j in `seq $startrun $endrun 8`;
do

echo Job ${j}.
awk -v var="$j" 'NR==18 {$0="a="'"var"'""} 1' runent-sniff.job > temp/temp.job
awk -v var="$((j+7))" 'NR==21 {$0="b="'"var"'""} 1' temp/temp.job > temp/mat${j}.job
rm temp/temp.job
cd temp/
sbatch mat${j}.job
cd ..
done
