#!/bin/bash
#SBATCH -p RM-shared
#SBATCH -t 5:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-type=ALL

cd /pylon2/ca4s8kp/lwaldrop/entcode_finished
for i in `seq 1 1233`; do 
unzip viz_IB2d${i}.zip
#test -d viz_IB2d${i} && echo "File found" || echo "File ${i} not found."
#test -f viz_IB2d${i}.zip && echo "File found" || echo "File ${i} no found."
done
