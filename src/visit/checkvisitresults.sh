#!/bin/bash

WD=${1:?Provide a top-level directory path}
a=${2:?Provide the number of hairs in the array}
b=${3:?Provide the number of simulations to check}

cd "${WD}"/results/visit/${a}hair_runs/

echo "Hairline files: "
for i in `seq 1 $b`; do 
  for j in `seq 1 4`; do
    if [ ! -f sim${i}/hairline${j}/hairline0003.curve ]; then
      echo "File sim ${i} hairline ${j} missing"
    fi
  done
done
echo " "
echo "Umean files: "
for i in `seq 1 $b`; do 
  for j in `seq 1 $a`; do
    if [ ! -f sim${i}/Umean/Umag_hair${j}.curve ]; then
      echo "File sim ${i} hair ${j} missing"
    fi
  done
done
echo " "
echo "Flux files: "
for i in `seq 1 $b`; do 
  for j in `seq 1 $a`; do
    if [ ! -f sim${i}/hairline_flux/flux_hair${j}_Ux_side3.curve ]; then
      echo "File sim ${i} hair ${j} missing"
    fi
  done
done
