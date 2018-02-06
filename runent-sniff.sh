#!/bin/bash
#SBATCH -p RM-shared
#SBATCH -t 12:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-type=ALL

#ARRAYNAME='runs'
#runs=( 93 98 121 128 )

#array="${ARRAYNAME}[@]"

#for run in "${!array}";
#for run in `seq 401 410`;
#do
#    echo $run
   # echo commands to stdout
   #set -x 
   # move to working directory
   cd /pylon5/ca4s8kp/lwaldrop/entcode/
   # add appropriate modules
   # module purge
   module load matlab
   # module load psc_path/1.1 slurm/15.08.8 git/2.10.2 intel/compilers icc/16.0.3 hdf5/1.8.16_intel 
   # MODULEPATH=${MODULEPATH}:$HOME/modulefiles
   # module load silo/4.10.2-intel-lw boost/1.60.0-intel-lw petsc/3.7.2-intel-lw samrai/2.4.4-intel-lw IBAMR/IBAMR-intel-lw remora/1.8-lw
   # copy input files to LOCAL file storage
   #srun -N $SLURM_NNODES -n 1 \
   #  sh `cp -r /pylon2/ca4s8kp/lwaldrop/peri-gPC-git/input.${SLURM_PROCID} $LOCAL`
   # run MPI program
   #mpirun -n 2 ./main2d input2d-files/input2d${run} > mpirun.out 
   matlab -r entsniff(401,403)
  #copy output files to persistent space
   #srun -N $SLURM_NNodes -n 1 \
   #  sh `cp -r $LOCAL/output.* /pylon2/ca4s8kp/lwaldrop/`
#done
