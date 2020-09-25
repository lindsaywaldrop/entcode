#!/bin/bash
#SBATCH -p RM-shared
#SBATCH -t 28:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=8
#SBATCH --mail-type=ALL

first=1
last=8
# echo commands to stdout
set -x 
# move to working directory
cd /pylon5/bi561lp/lwaldrop/entcode/shilpacode/
# add appropriate modules
module purge
module load matlab
# run matlab program
matlab -r "entsniff2($first,$last);exit"
#
