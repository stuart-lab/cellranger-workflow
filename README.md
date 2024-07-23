# retina-atlas
Pipelines for processing sc-multiome and sc-atacseq data using CellRanger

## To debug
```
snakemake -p --dry-run -s <insert snakefile name>
```

## Load management when running CellRanger
CellRanger takes up a lot of resources, so must add resources flag when running run_cr snakefile.
```
snakemake --cores all --keep-incomplete --resources load=100 -s run_cr_atac.snakefile
```

## Dependencies
| Dependencies  |Link                                                                       |
|:--------------|:-------------------------------------------------------------------       |
| CellRangerARC |https://www.10xgenomics.com/support/software/cell-ranger-arc/latest        |
| CellRangerATAC|https://support.10xgenomics.com/single-cell-atac/software/downloads/latest |
| SRA_Toolkit   |https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit         |
| Snakemake     |https://snakemake.readthedocs.io/en/stable/                                |
| PigZ          |https://zlib.net/pigz/                                                     |


## Instructions

Depending on the type of data being processed (Multiome vs ATAC-seq), download relevant folder(s).

## Snakemake rule pipeline

ATAC:                      |  Multiome:
:-------------------------:|:-------------------------:
![plot](./run_cr_atac.PNG) |  ![plot](./set_up.PNG)

### More detailed instructions in subfiles.
