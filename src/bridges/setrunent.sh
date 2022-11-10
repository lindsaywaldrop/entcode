#!/bin/bash

# What should you space the jobs by?
WD=${1:?Provide working directory}
startrun=${2:?Provide start run}
endrun=${3:?Provide end run}

echo Submitting simulations $startrun to $endrun.
mkdir temp/

# Extract parameter files
cut -f 6 "$WD"/data/parameters/data_uniform_2000.txt > diff_coef.txt
cut -f 7 "$WD"/data/parameters/data_uniform_2000.txt > stink_width.txt
cut -f 8 "$WD"/data/parameters/data_uniform_2000.txt > init_conc.txt

# Initialize variables
diff=0
stink=0
ic=0

#Loop through and submit jobs

for j in `seq $startrun $endrun`;
  do
  echo Job ${j}.
  # Changing 
  awk -v var="$j" 'NR==20 {$0="a="'"var"'""} 1' runent-sniff.job > temp/temp.job

  diff=$(awk -v var="$j" 'NR==var' diff_coef.txt)
  awk -v var="$diff" 'NR==23 {$0="D="'"var"'""} 1' temp/temp.job > temp/temp-1.job
  
  stink=$(awk -v var="$j" 'NR==var' stink_width.txt)
  awk -v var="$stink" 'NR==26 {$0="width="'"var"'""} 1' temp/temp-1.job > temp/temp-2.job
  
  ic=$(awk -v var="$j" 'NR==var' init_conc.txt)
  awk -v var="$ic" 'NR==29 {$0="initconc="'"var"'""} 1' temp/temp-2.job > temp/mat${j}.job

  rm temp/temp*.job
  cd temp/

  sbatch mat${j}.job

  cd ..
done

rm diff_coef.txt stink_width.txt init_conc.txt
