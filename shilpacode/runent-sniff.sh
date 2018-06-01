#!/bin/bash
# SBATCH -p RM
# SBATCH -t 24:00:00
# SBATCH -N 1
# SBATCH --ntasks-per-node=1
# SBATCH --mail-type=ALL


# echo commands to stdout
#set -x 
# move to working directory
cd /Users/Bosque/Documents/MATLAB/shilpa2/
# add appropriate modules
#module load matlab
# run matlab program
matlab -r "entsniff(1050,1050)"
# copy output files to persistent space
# srun -N 1 -n 1 \
#  sh `cp -r *.mat /pylon2/bi561lp/lwaldrop/addiff_results/`
