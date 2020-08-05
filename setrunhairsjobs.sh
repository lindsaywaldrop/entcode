#!/bin/bash

# What should you space the jobs by?
startrun=11
endrun=12

echo Submitting simulations $startrun to $endrun.

for j in `seq $startrun $endrun`;
do

echo Job ${j}.
awk -v var="$j" 'NR==11 {$0="i="'"var"'""} 1' runhairs.job > temp${j}.job

sbatch temp${j}.job

done
