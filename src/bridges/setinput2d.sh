#!/bin/bash

WD=${1:?Provide a working directory}
a=${2:?Provide a simulation set number}

# Separate main parameter file into three files
#cut -f 1 allpara_1233.txt > angle.txt
#cut -f 2 allpara_1233.txt > gap.txt
cut -f 3 "$WD"/data/parameters/allpara_${a}.txt > Re.txt

# Count number of lines in files
numlines=$(grep -c "^" "$WD"/data/parameters/allpara_${a}.txt)

# initialize variables
#angle=0
#gap=0
Re=0
# For loop that will write files
for i in `seq 1 $numlines`;
do
# Sets Wo based on i
Re=$(awk -v var="$i" 'NR==var' Re.txt)
# Writes file to replace line with Wo
awk -v var="$Re" 'NR==6 {$0="RE = "'"var"'"   // Reynolds number of real aesthetasc"} 1' template-input2d1 > input2dRe
# Sets Freq based on i
name=hairs${i}
# Writes file to replace line with Freq
awk -v var="$name" 'NR==117 {$0="   structure_names = \42"'"var"'"\42    // "} 1' input2dRe > input2dRe1
awk -v var="$name" 'NR==118 {$0="   "'"var"'"{   // "} 1' input2dRe1 > input2dRe2
awk -v var="$name" 'NR==220 {$0="     structure_names                  = \42"'"var"'"\42   // "} 1' input2dRe2 > input2dRe3
# Edits input2d to create different IBlog and visit files and folders
awk -v var="$i" 'NR==254 {$0="   log_file_name = \42../results/ibamr/runs/IB2d.log"'"var"'"\42                //"} 1' input2dRe3 > input2dRe4
awk -v var="$i" 'NR==260 {$0="   viz_dump_dirname = \42../results/ibamr/runs/viz_IB2d"'"var"'"\42                //"} 1' input2dRe4 > input2dRe5

# Cleans up folder
rm input2dRe input2dRe1 input2dRe2 input2dRe3 input2dRe4
mv input2dRe5 "$WD"/data/input2d-files/input2d${i}

echo $i

done

rm Re.txt

