##This pipeline is outdated; use atlas_snakefiles_faster##


Dependencies: 1)CellRangerARC 2)SRA tookit 3)Snakemake

fastq-dump -> clean&rename files -> run cellranger -> {atac_sec_accession}_{rna_seq_accession} file w/ outputs

**Note: 
1) pwd, paste into config.yaml wd:""
2) ref genome to directory is not added due to size; it should be in this directory along with snakefiles for it to work.
   link to reference genome: https://www.10xgenomics.com/support/software/cell-ranger-arc/downloads 
3) nth file in atac_accessions.txt corresponds to nth file in rna_accessions.txt; paste accession numbers in sequence
   e.g. 1st accession in atac_accessions.txt should be the atac_seq for the 1st accession in rna_accessions.txt

--Problems --
1) Can use fasterq-dump, but will have big fastq files; will speed up process significantly
2) If don't have the 4 fastq files required (for either atac or rna), the snakefile will not run.
