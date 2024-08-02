#!/bin/bash

#SBATCH -t 72:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node 48
#SBATCH --cpus-per-task 1
#SBATCH --mem 256G
#SBATCH -J DS1
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH -p cpu

snakemake --cores all --keep-incomplete -s run_cr.snakefile

## sbatch run_nfcore_scrnaseq.sbatch
## squeue --job 1201585
