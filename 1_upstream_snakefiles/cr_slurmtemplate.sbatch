#!/bin/bash

#SBATCH -t 72:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node 60
#SBATCH --cpus-per-task 1
#SBATCH --mem 128G
#SBATCH -J m_tst
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH -p cpu


export PATH=/home/users/astar/gis/stufrancis/scratch/CellRangerFiles/cellranger-atac-2.1.0:$PATH
export TMPDIR=/home/users/astar/gis/stufrancis/scratch
snakemake --cores all --keep-incomplete --resource load=100

## sbatch run_nfcore_scrnaseq.sbatch
## squeue --job 1201585
