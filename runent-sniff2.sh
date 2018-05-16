#!/bin/bash
#SBATCH -p RM
#SBATCH -t 28:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=8
#SBATCH --mail-type=ALL

first=345
last=352
# echo commands to stdout
set -x 
# move to working directory
cd /pylon5/bi561lp/lwaldrop/shilpa/
# add appropriate modules
module load matlab
# run matlab program
matlab -r "entsniff2($first,$last)"
# copy output files to persistent space
# srun -N 1 -n 1 \
#  sh `cp -r *.mat /pylon2/bi561lp/lwaldrop/addiff_results/`
for i in `seq $first $last`;
do
printf -v j "%04d" $i
rm /pylon5/bi561lp/lwaldrop/shilpa/postprocessing/c_${j}.mat
rm /pylon5/bi561lp/lwaldrop/shilpa/pivdata/viz_IB2d${i}.mat
done
