#!/bin/bash

# What should you space the jobs by?
startrun=${1:?Provide start run}
endrun=${2:?Provide end run}

echo Submitting simulations $startrun to $endrun.
mkdir temp/

for j in `seq $startrun 8 $endrun`;
do

echo Job ${j}.

awk -v var="$j" 'NR==19 {$0="a="'"var"'""} 1' runent-sniff.job > temp/temp.job

if [ "$((j+7))" -le "$endrun" ]
then
    awk -v var="$((j+7))" 'NR==22 {$0="b="'"var"'""} 1' temp/temp.job > temp/mat${j}.job
else 
    awk -v var="$endrun" 'NR==22 {$0="b="'"var"'""} 1' temp/temp.job > temp/mat${j}.job 
fi

rm temp/temp.job
cd temp/

sbatch -C EGRESS -t 12:00:00 mat${j}.job

cd ..
done
