# Pipeline to process Multiome data

### Important: the bash scripts "rename_rna.sh" & "rename_atac.sh" need to be amended depending on reads given in SRA run selector.
E.g. some SRR's may have index reads, some may not. File naming convention: https://www.10xgenomics.com/support/software/cell-ranger-arc/latest/tutorials/inputs/specifying-input-fastq-count

**Instructions**

How to use:
1)  Set-up a file similar to "GSE202747_metadata.csv"; a sample R script written by Dr Ramasamy is given. (credits: https://www.a-star.edu.sg/gis/our-people/platform-leaders/members-page/adaikalavan-ramasamy)
2)  Run set_up.snakefile first. This will set up a file strcuture in this way:
    ```
    .
    ├── <other stuff like your snakefiles>
    ├── libraries
    └── tissues
    ```
3) Then, run run_cr.snakefile. The two commands for running both can be inserted sequentially into one .sbatch file.


**Rules in set_up.snakefile**
| Rules               |What they do                                                        |
|:--------------------|:-------------------------------------------------------------------|
|create_libraries_csv |"libraries.csv" created; needed for CellRangerARC                   |
|prefetch             |downloads all the SRR files                                         |
|rename               |Renames files for CR; ".sh" used, snakemake bad at renaming files   |



**To run**
```
##some rules need to be edited as pipeline is catered to "GSE202747_metadata.csv"
snakemake --cores all --keep-incomplete -s run_cr_atac.snakefile
snakemake --cores all --keep-incomplete --resources load=100 -s run_cr.snakefile
```

**For future improvement**
1) Add config file for ease of use
2) Prefetch should run in parallel so it is faster