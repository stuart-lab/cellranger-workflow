# Pipeline to process ATAC-Seq data 

## Important: the rule "rename_fastq_files" in "get_atac.snakefile" needs to be amended depending on reads given in SRA run selector.
E.g. some SRR's may have index reads, some may not. File naming convention: https://www.10xgenomics.com/support/software/cell-ranger-arc/latest/tutorials/inputs/specifying-input-fastq-count

### Setup

In the config.yaml file, with reference to location of scripts, change cd to **absolute** path, and ref_genome to **relative** path.

### Instructions

How to use:
1) Paste "SRR" accession numbers in "atac_accessions.txt" (SRR accession numbers can be obtained from SRA run selector).
2) Let the HPC cook.
3) Output files that are important: metrics.csv, fragment file.tsv.gz & .tsv.gz.tbi, filtered_matrix.h5. Move to downstream analysis.

### To run
```
##to run pipeline:
snakemake --cores all --keep-incomplete --resources load=100 -s run_cr_atac.snakefile

##it is suggested to run on HPC using cr_slurmtemplate.sbatch - to run:
sbatch cr_slurmtemplate.sbatch
```


