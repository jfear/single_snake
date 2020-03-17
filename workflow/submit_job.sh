#!/bin/bash
#SBATCH --job-name="single_snake"
#SBATCH --partition="quick"
#SBATCH --time=00:01:00
#SBATCH --cpus-per-task=1

# Make required folders
if [[ ! -e slurm_logs ]]; then mkdir -p slurm_logs; fi

module load singularity/3.5.3
export SINGULARITY_BIND="/data/$USER,/lscratch"

# run pipeline
snakemake \
    --profile ../slurm_submit \
    --jobname "s.{rulename}.{jobid}.sh" \
    > "Snakefile.log" 2>&1
