#!/bin/bash

module load singularity/3.5.3
export SINGULARITY_BIND="/data/$USER,/lscratch"

snakemake \
    --verbose \
    --cores 1 \
    --forceall \
    --use-singularity
