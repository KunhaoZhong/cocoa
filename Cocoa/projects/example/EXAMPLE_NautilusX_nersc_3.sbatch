#!/bin/bash

#SBATCH --job-name=example_nautilus
#SBATCH --output=example_nautilus-%A_%a.out
#SBATCH -e example_nautilus-%A_%a.out.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=80
#SBATCH --cpus-per-task=1
#SBATCH --qos=regular
#SBATCH --time=8:00:00
#SBATCH --constraint=cpu

echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo Slurm job NAME is $SLURM_JOB_NAME
echo Slurm job ID is $SLURM_JOBID
echo Number of task is $SLURM_NTASKS
echo Number of cpus per task is $SLURM_CPUS_PER_TASK

cd $SLURM_SUBMIT_DIR

source /global/u1/k/kunhaoz/miniconda3/etc/profile.d/conda.sh
conda activate /global/common/software/des/kunhaoz/cocoa_common
export CONDA_PREFIX=/global/common/software/des/kunhaoz/cocoa_common
source start_cocoa

export OMP_PROC_BIND=close
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
  export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
else
  export OMP_NUM_THREADS=1
fi

$CONDA_PREFIX/bin/mpirun -n ${SLURM_NTASKS} --oversubscribe --map-by numa:pe=${OMP_NUM_THREADS} cobaya-run ./projects/example/EXAMPLE_Nautilus${SLURM_ARRAY_TASK_ID}.yaml -r