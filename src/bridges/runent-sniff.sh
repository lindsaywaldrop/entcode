#!/bin/bash
#SBATCH -p RM
#SBATCH -t 28:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=8
#SBATCH --mail-type=ALL

# echo commands to stdout
set -x 
# move to working directory
cd /pylon5/bi561lp/lwaldrop/entcode/shilpacode/
# add appropriate modules
module purge
module load matlab
# run matlab program
#matlab -r "entsniff3([8,122,124,126])"
matlab -r 'entsniff3([335,337,338,339,341,342,343,344]);exit'
#
