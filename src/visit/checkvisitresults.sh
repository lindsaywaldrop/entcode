#!/bin/bash

WD=${1:?Provide a top-level directory path}
#a=${2:?Provide the number of hairs in the array}
b=${2:?Provide the number of simulations to check}

a=3
cd "${WD}"/results/visit/${a}hair_runs/

if [ "$a" == 3 ]; then
  rows=1
elif [ "$a" == 5 ]; then
  rows=1
elif [ "$a" == 7 ]; then
  rows=2
elif [ "$a" == 12 ]; then
  rows=3
elif [ "$a" == 18 ]; then
  rows=4
elif [ "$row" == 25 ]; then
  rows=5
else
  echo "ERROR: row number unknown"
  exit 1
fi

echo "Hairline files: "
for i in `seq 1 $b`; do 
  for j in `seq 1 $rows`; do
    if [ ! -f sim${i}/leakiness${j}/leakiness0003.curve ]; then
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
echo " "

echo "Shear files: "
for i in `seq 1 $b`; do 
  for j in `seq 1 $a`; do
    if [ ! -f sim${i}/hairline_flux/flux_hair${j}_0003.curve ]; then
      echo "File sim ${i} hair ${j} missing"
    fi
  done
done
echo " "
