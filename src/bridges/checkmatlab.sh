#!/bin/bash

WD=${1:?Provide a top-level directory path}
a=${2:?Provide the number of hairs in the array}
b=${3:?Provide the number of simulations to check}

#a=3
cd "${WD}"/results/odorcapture/${a}hair_array/
echo $PWD

echo "Concentration files: "
for i in `seq -f "%04g" 1 $b`; do 
    if [ ! -f c_${i}.mat ]; then
      echo "File c_${i}.mat missing"
    fi
done
echo " "

echo "Init data files: "
for i in `seq -f "%04g" 1 $b`; do 
    if [ ! -f initdata_${i}.mat ]; then
      echo "File initdata_${i}.mat missing"
    fi
done
echo " "

echo "Hair concentration files: "
for i in `seq -f "%04g" 1 $b`; do 
    if [ ! -f hairs_c_${i}.mat ]; then
      echo "File hairs_c_${i}.mat missing"
    fi
done
echo " "

echo "velocity files: "
for i in `seq -f "%04g" 1 $b`; do 
    if [ ! -f velocity_${i}.mat ]; then
      echo "File velocity_${i}.mat missing"
    fi
done
echo " "