#!/bin/bash

WD=${1:?Please provide a top-level working directory}
startnum=${2:?Please provide a simulation start number}
endnum=${3:?Please provide a simulation end number}

a=3
filename="lineout_h3-h2.txt"
echo $filename

numlines=$(grep -c "^" "$WD"/data/lineout-files/$filename)

cd "${WD}"/results/visit/${a}hair_runs/

echo "Clear hairline directories of curve files or make hairline directories."
for i in `seq $startnum $endnum`; do
  if [ -d "sim${i}/hairline_flux" ]; then
    rm sim${i}/hairline_flux/*.curve
  else
    mkdir -p sim${i}/hairline_flux/
  fi
done

for i in `seq $startnum $endnum`; do
  if [ -d "sim${i}/Umean/" ]; then
    rm sim${i}/Umean/*.curve
  else
    mkdir -p sim${i}/Umean/
  fi
done

# Clear hairline directories of curve files or make hairline directories. 
for i in `seq 1 $b`; do
  if [ -d "sim${i}/shear" ]; then
    rm sim${i}/shear/*.curve
  else
    mkdir -p sim${i}/shear/
  fi
done

echo "Switching to visit directory"

cd "${WD}"/src/visit/

echo "Initializing variables"
HX=0
HY=0
DIST1=0.002
DIST2=0.004

# For loop that interates over simulations
for i in `seq $startnum $endnum`; do
#for i in `seq 84 165`; do
  
  # For loop that iterates over hairs 
  for j in `seq 1 ${a}`; do
  #for j in `seq 1 10`; do
    cut -d , -f $(($j+1)) "$WD"/data/csv-files/${a}hair_files/hairs${i}.csv > hair.txt

    # Sets Hair based on j and i
    HX=$(awk -v var="3" 'NR==var' hair.txt)
    HY=$(awk -v var="4" 'NR==var' hair.txt)

    /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout_flux.py \
    "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i} "$WD"/results/visit/${a}hair_runs/sim${i}/hairline_flux ${i} ${j} $HX $HY $DIST1
    
    for k in `seq 0 3`; do
      csplit "$WD"/results/visit/${a}hair_runs/sim${i}/hairline_flux/flux_hair${j}_000${k}.curve '/^\# curve/'
      mv xx00 "$WD"/results/visit/${a}hair_runs/sim${i}/hairline_flux/flux_hair${j}_Ux_side${k}.curve
      mv xx01 "$WD"/results/visit/${a}hair_runs/sim${i}/hairline_flux/flux_hair${j}_Uy_side${k}.curve
    done
    
    /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s Umean.py \
    "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i} "$WD"/results/visit/${a}hair_runs/sim${i}/Umean ${j} $HX $HY $DIST1
    
    /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout_shear.py \
    "$WD"/results/ibamr/${a}hair_runs/viz_IB2d${i} "$WD"/results/visit/${a}hair_runs/sim${i}/shear ${i} ${j} $HX $HY $DIST2
    

  done
  
  #rm "$WD"/results/visit/${a}hair_runs/sim${i}/hairline_flux/flux_hair?_side?.curve
  #rm "$WD"/results/visit/${a}hair_runs/sim${i}/hairline_flux/flux_hair??_side?.curve

done

rm hair.txt
