# retina-atlas
All files stored in "atlas_snakefiles_faster" directory

## To debug
```
snakemake -p --dry-run -s <insert snakefile name>
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
