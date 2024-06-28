Dependencies: 1)CellRanger ARC 2)SRA tookit 3)Snakemake

fastq-dump -> clean&rename files -> run cellranger -> {atac_sec_accession}_{rna_seq_accession} file w/ outputs

**Note: 
1) pwd, paste into config.yaml wd:""
2) ref genome to directory is not added due to size; it should be in this directory along with snakefiles for it to work.
   link to reference genome: https://www.10xgenomics.com/support/software/cell-ranger-arc/downloads 

--Problems --
1) Can use fasterq-dump, but will have big fastq files; will speed up process significantly
2) If don't have the 4 fastq files required (for either atac or rna), the snakefile will not run.
