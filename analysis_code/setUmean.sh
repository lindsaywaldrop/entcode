#!/bin/bash

cd /Volumes/HelmsDeep/IBAMR/entcode/usedruns

# Count number of lines in files
numlines=$(grep -c "^" hair1x.txt)

# initialize variables
HX=0
HY=0
DIST=0.01

# For loop that will write files
for i in `seq 1 $numlines`;
#for i in `seq 1 2`;
do
# Sets Hair 1 based on i
HX=$(awk -v var="$i" 'NR==var' hair1x.txt)
HY=$(awk -v var="$i" 'NR==var' hair1y.txt)

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s Umean.py ${i} $HX $HY $DIST

# Sets Hair 2 based on i
HX=$(awk -v var="$i" 'NR==var' hair2x.txt)
HY=$(awk -v var="$i" 'NR==var' hair2y.txt)

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s Umean.py ${i} $HX $HY $DIST

# Sets Hair 3 based on i
HX=$(awk -v var="$i" 'NR==var' hair3x.txt)
HY=$(awk -v var="$i" 'NR==var' hair3y.txt)

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s Umean.py ${i} $HX $HY $DIST


done

