#!/bin/bash

# Optional clear hairline of curve files. 
#for i in `seq 1 1233`; do cd viz_IB2d${i}/hairline; rm *.curve; cd /Users/Bosque/IBAMR/entcode/code/runs; done

# Separate main parameter file into three files
cut -f 2 lineout_h13-h18.txt > startx.txt
cut -f 3 lineout_h13-h18.txt > starty.txt
cut -f 4 lineout_h13-h18.txt > endx.txt
cut -f 5 lineout_h13-h18.txt > endy.txt

cut -f 6 lineout_h13-h18.txt > hair1x.txt
cut -f 7 lineout_h13-h18.txt > hair1y.txt
cut -f 8 lineout_h13-h18.txt > hair2x.txt
cut -f 9 lineout_h13-h18.txt > hair2y.txt
cut -f 10 lineout_h13-h18.txt > hair3x.txt
cut -f 11 lineout_h13-h18.txt > hair3y.txt
cut -f 12 lineout_h13-h18.txt > gapwidths.txt

# Count number of lines in files
numlines=$(grep -c "^" lineout_h13-h18.txt)

# initialize variables
SX=0
SY=0
EX=0
EY=0

# For loop that will write files
for i in `seq 1 $numlines`;
#for i in `seq 1 12`;
do
# Sets Wo based on i
SX=$(awk -v var="$i" 'NR==var' startx.txt)
SY=$(awk -v var="$i" 'NR==var' starty.txt)
EX=$(awk -v var="$i" 'NR==var' endx.txt)
EY=$(awk -v var="$i" 'NR==var' endy.txt)

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout1.py ${i} $SX $SY $EX $EY

done

