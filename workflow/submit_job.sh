#!/bin/bash
#SBATCH --job-name="single_snake"
#SBATCH --partition="quick"
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1

# Make required folders
module load singularity/3.5.3
export SINGULARITY_BIND="/gpfs/gsfs6/users/fearjm,/data/$USER,/lscratch"

# run pipeline
snakemake \
    --profile ./slurm_submit \
    --jobname "s.{rulename}.{jobid}.sh"
