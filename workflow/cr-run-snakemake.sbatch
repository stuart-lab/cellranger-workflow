#!/bin/bash

#SBATCH -t 72:00:00
#SBATCH -N 1
#SBATCH --ntasks-per-node 60
#SBATCH --cpus-per-task 1
#SBATCH --mem 128G
#SBATCH -J CR_pipeline
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH -p cpu

snakemake --cores all --keep-incomplete --resources load=100
