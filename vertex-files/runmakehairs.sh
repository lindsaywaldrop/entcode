#!/bin/bash
#SBATCH -p RM-shared
#SBATCH -t 12:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-type=ALL

#set -x 
   # move to working directory
   cd /pylon5/ca4s8kp/lwaldrop/entcode/vertex-files/
   # add appropriate modules
   # module purge
   module load matlab

matlab -r makehairs
