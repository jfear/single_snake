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

I personally have `export SINGULARITY_BIND="/data/$USER,/lscratch"` in my `~/.bashrc`, but for this example I added it the two run scripts.


# Running on interactive node works as expected

```bash
$ ssh biowulf
$ sinteractive --cpus-per-task 2 --mem 2G --gres lscratch:10
$ cd /data/$USER/single_snake/workflow
$ conda activate single_snake
$ sh run_local.sh
```

Notice that you can see the contents of **Parent Dir:** `/data/$USER/single_snake` and `/lscratch`. The file `/data/$USER/single_snake/output/snakemake_generated_output.txt` was generated.

Output from `$ cat ls_dirs.txt`
```bash
Working Dir: /data/fearjm/single_snake/workflow
total 0
-rw-rw-r-- 1 fearjm fearjm  954 Mar 17 18:06 Snakefile
-rw-r--r-- 1 fearjm fearjm   48 Mar 17 18:06 ls_dir.txt
-rwxrwxr-x 1 fearjm fearjm  175 Mar 17 16:39 run_local.sh
drwxrwxr-x 2 fearjm fearjm 4.0K Mar 17 16:49 slurm_submit
-rw-rw-r-- 1 fearjm fearjm  382 Mar 17 16:44 submit_job.sh


Parent Dir: /data/fearjm/single_snake
total 0
-rw-rw-r-- 1 fearjm fearjm  890 Mar 17 17:57 README.md
-rw-rw-r-- 1 fearjm fearjm 3.3K Mar 17 16:43 environment.yaml
drwxrwxr-x 2 fearjm fearjm 4.0K Mar 17 18:06 output
drwxrwxr-x 4 fearjm fearjm 4.0K Mar 17 18:06 workflow


Local Scratch: /lscratch
total 8.0K
drwx------ 2 fearjm fearjm 4.0K Mar 17 17:50 52465847
drwx------ 2 root   root   4.0K Mar 17 17:50 meta


root: /
bin   dev	   gpfs  lib64	   mnt	 root  singularity  tmp
boot  environment  home  lscratch  opt	 run   srv	    usr
data  etc	   lib	 media	   proc  sbin  sys	    var


df -h
Filesystem      Size  Used Avail Use% Mounted on
overlay          16M   32K   16M   1% /
devtmpfs        189G     0  189G   0% /dev
tmpfs           189G     0  189G   0% /dev/shm
devpts             0     0     0    - /dev/pts
mqueue             0     0     0    - /dev/mqueue
hugetlbfs          0     0     0    - /dev/hugepages
/dev/sda4       3.5T   14G  3.3T   1% /usr/share/zoneinfo/UCT
/dev/sda4       3.5T   14G  3.3T   1% /etc/hosts
tmpfs            16M   32K   16M   1% /.singularity.d/actions
proc               0     0     0    - /proc
systemd-1          -     -     -    - /proc/sys/fs/binfmt_misc
binfmt_misc        0     0     0    - /proc/sys/fs/binfmt_misc
sysfs              0     0     0    - /sys
gsfs6           1.9P  1.5P  453T  77% /gpfs/gsfs6/users/fearjm/single_snake/workflow
/dev/sda4       3.5T   14G  3.3T   1% /tmp
/dev/sda4       3.5T   14G  3.3T   1% /var/tmp
tmpfs            16M   32K   16M   1% /etc/resolv.conf
tmpfs            16M   32K   16M   1% /etc/passwd
tmpfs            16M   32K   16M   1% /etc/group
gsfs6           1.9P  1.5P  453T  77% /mnt/snakemake
gsfs6           1.9P  1.5P  453T  77% /data/fearjm
/dev/sda4       3.5T   14G  3.3T   1% /lscratch
```

## Submitting to SLURM Does *Not* Work

```bash
$ ssh biowulf
$ cd /data/$USER/single_snake/workflow
$ conda activate single_snake
$ sh submit_job.sh
```
Rule `touch_outside` fails, and the file `/data/$USER/single_snake/output/snakemake_generated_output.txt` is not generated.

Output from `$ cat touch_outside.e.*`
```bash
Building DAG of jobs...

...<REMOVED FOR CLARITY>...

Activating singularity image /gpfs/gsfs6/users/fearjm/single_snake/workflow/.snakemake/singularity/012821358e8d64db71c693986426fb3d.simg
bash: ../output/snakemake_generated_output.txt: No such file or directory
[Tue Mar 17 18:09:17 2020]
Error in rule touch_outside:

...<REMOVED FOR CLARITY>...
```

Interestingly, `/lscratch` is properly mounted, but `/data/$USER/single_snake` only contains the current working directory `/data/$USER/single_snake/workflow`

Output from `$ cat ls_dirs.txt`
```bash
Working Dir: /gpfs/gsfs6/users/fearjm/single_snake/workflow
total 0
-rw-rw-r-- 1 fearjm fearjm  954 Mar 17 18:06 Snakefile
-rw-rw-r-- 1 fearjm fearjm  928 Mar 17 18:09 ls_dir.e.52466454
-rw-rw-r-- 1 fearjm fearjm    0 Mar 17 18:09 ls_dir.o.52466454
-rw-r--r-- 1 fearjm fearjm   60 Mar 17 18:09 ls_dir.txt
-rwxrwxr-x 1 fearjm fearjm  175 Mar 17 16:39 run_local.sh
drwxrwxr-x 2 fearjm fearjm 4.0K Mar 17 18:08 slurm_logs
drwxrwxr-x 2 fearjm fearjm 4.0K Mar 17 16:49 slurm_submit
-rw-rw-r-- 1 fearjm fearjm  382 Mar 17 16:44 submit_job.sh
-rw-rw-r-- 1 fearjm fearjm  598 Mar 17 18:09 touch_outside.e.52466453
-rw-rw-r-- 1 fearjm fearjm    0 Mar 17 18:09 touch_outside.o.52466453


Parent Dir: /gpfs/gsfs6/users/fearjm/single_snake
total 0
drwxrwxr-x 5 fearjm fearjm 4.0K Mar 17 18:09 workflow


Local Scratch: /lscratch
total 8.0K
drwx------ 2 fearjm fearjm 4.0K Mar 17 18:09 52466454
drwx------ 2 root   root   4.0K Mar 17 18:09 meta


root: /
bin   dev	   gpfs  lib64	   mnt	 root  singularity  tmp
boot  environment  home  lscratch  opt	 run   srv	    usr
data  etc	   lib	 media	   proc  sbin  sys	    var


df -h
Filesystem      Size  Used Avail Use% Mounted on
overlay          16M   32K   16M   1% /
devtmpfs         63G     0   63G   0% /dev
tmpfs            63G     0   63G   0% /dev/shm
devpts             0     0     0    - /dev/pts
hugetlbfs          0     0     0    - /dev/hugepages
mqueue             0     0     0    - /dev/mqueue
/dev/sda4       877G  7.8G  825G   1% /usr/share/zoneinfo/UCT
/dev/sda4       877G  7.8G  825G   1% /etc/hosts
tmpfs            16M   32K   16M   1% /.singularity.d/actions
proc               0     0     0    - /proc
systemd-1          -     -     -    - /proc/sys/fs/binfmt_misc
binfmt_misc        0     0     0    - /proc/sys/fs/binfmt_misc
sysfs              0     0     0    - /sys
gsfs6           1.9P  1.5P  453T  77% /gpfs/gsfs6/users/fearjm/single_snake/workflow
/dev/sda4       877G  7.8G  825G   1% /tmp
/dev/sda4       877G  7.8G  825G   1% /var/tmp
tmpfs            16M   32K   16M   1% /etc/resolv.conf
tmpfs            16M   32K   16M   1% /etc/passwd
tmpfs            16M   32K   16M   1% /etc/group
gsfs6           1.9P  1.5P  453T  77% /mnt/snakemake
gsfs6           1.9P  1.5P  453T  77% /data/fearjm
/dev/sda4       877G  7.8G  825G   1% /lscratch
```
