# Singularity + Snakemake + Biowulf

## Problem

Singularity bind paths are not correctly set when submitting as a batch job, but work correctly on an interactive session. This is a minium viable example.

## Set up

```bash
$ ssh biowulf
$ cd /data/$USER
$ git clone https://github.com/jfear/single_snake
$ cd single_snake
$ conda env create --file environment.yaml
```


## Running on interactive node works

```bash
$ ssh biowulf
$ sinteractive --cpus-per-task 2 --mem 2G --gres lscratch:10
$ cd /data/$USER/single_snake/workflow
$ conda activate single_snake
$ sh run_local.sh
```

Output from `$ cat ls_dirs.txt`
```bash
Working Dir
/data/fearjm/single_snake/workflow
total 0
-rw-rw-r-- 1 fearjm fearjm  468 Mar 17 16:28 Snakefile
-rwxrwxr-x 1 fearjm fearjm  203 Mar 17 16:28 run_local.sh
drwxrwxr-x 2 fearjm fearjm 4.0K Mar 17 16:18 slurm_submit
-rw-rw-r-- 1 fearjm fearjm  412 Mar 17 16:18 submit_job.sh
Parent Dir
total 0
drwxrwxr-x 2 fearjm fearjm 4.0K Mar 17 16:31 output
drwxrwxr-x 4 fearjm fearjm 4.0K Mar 17 16:28 workflow
/lscratch
total 8.0K
drwx------ 2 fearjm fearjm 4.0K Mar 17 16:23 52444722
drwx------ 2 root   root   4.0K Mar 17 16:23 meta

```

Output from `$ cat ../output/snakemake_generated_output.txt`



## Submitting to SLURM Does Not

```bash
$ ssh biowulf
$ cd /data/$USER/single_snake/workflow
$ conda activate single_snake
$ sh submit_job.sh
$ cat ../output/snakemake_generated_output.txt
```

