#!/bin/bash

#SBATCH -t 72:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node 48
#SBATCH --cpus-per-task 1
#SBATCH --mem 256G
#SBATCH -J 166175
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH -p cpu

export PATH=/home/users/astar/gis/stufrancis/scratch/CellRangerFiles/cellranger-atac-2.1.0:$PATH
export TMPDIR=/home/users/astar/gis/stufrancis/scratch
mamba activate snakemake
snakemake --cores all --keep-incomplete --resources load=100 -s run_cr_atac.snakefile

## sbatch run_nfcore_scrnaseq.sbatch
## squeue --job 1201585
