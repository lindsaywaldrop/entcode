#!/bin/bash
#SBATCH -p RM-shared
#SBATCH -t 1:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-type=ALL


# echo commands to stdout
set -x 
# move to working directory
cd /pylon5/ca4s8kp/lwaldrop/entcode/
# add appropriate modules
module load matlab
# run matlab program
matlab -r "entsniff(401,410)"
# copy output files to persistent space
srun -N 1 -n 1 \
  sh `cp -r *.mat /pylon2/ca4s8kp/lwaldrop/addiff_results/`
