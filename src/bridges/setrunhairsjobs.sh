#!/bin/bash

# What should you space the jobs by?
startrun=${1:?Provide start run}
endrun=${2:?Provide end run}

echo Submitting simulations $startrun to $endrun.
mkdir temp/

for j in `seq $startrun $endrun`;
do

echo Job ${j}.
awk -v var="$j" 'NR==12 {$0="i="'"var"'""} 1' runhairs.job > temp/tmp${j}.job
cd temp/
sbatch tmp${j}.job
cd ..
done
