# retina-atlas
All files stored in "atlas_snakefiles_faster" directory

**To run**
```
##change "run_cr_atac.snakefile" accordingly, if running multiome pipeline##
snakemake --cores all --keep-incomplete --resources load=100 -s run_cr_atac.snakefile
```
**Dependencies**
| Dependencies  |Link                                                                |
|:--------------|:-------------------------------------------------------------------|
| CellRangerARC |https://www.10xgenomics.com/support/software/cell-ranger-arc/latest |
| SRA_Toolkit   |https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit  |
| Snakemake     |https://snakemake.readthedocs.io/en/stable/                         |
| PigZ          |https://zlib.net/pigz/                                              |

**Setup**

In the config.yaml file, with reference to location of scripts, change cd to absolute path, and ref_genome to relative path.

**Instructions**

How to use:
1)Depending on if it is multiome or ATAC-seq, download respective folder.
2)Paste "SRR" accession numbers in "atac_accessions.txt" (and "rna_accessions.txt")
3)For multiome run, ensure accession numbers of scRNA and scATAC are in sequence.
**Note: rename_fastq_files needs to be modified according to the reads given in SRA tookit (e.g. some datasets don't have index files,etc)

**Workflow**

![plot](./run_cr.PNG)
