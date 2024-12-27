# cr-run-snakemake

```cr-run-snakemake``` is a Snakemake pipeline designed to process raw ATAC-seq and multiome data from public datasets, handling everything from data download to generating processed outputs compatible with the Signac package.

## Installation & Running 
### Installation 
```cr-run-snakemake``` can be installed by cloning the Github repository
```
# Clone this repository into your local machine
git clone https://github.com/stuart-lab/cr-run-snakemake

# Change into the workflow directory
cd cr-run-snakemake/workflow
```

After cloning the GitHub repo, you can install snakemake and the other dependencies using [mamba](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html) by using the code below:
```
# Make sure mamba is already installed
mamba env create -f environment.yaml

# Activate cr-run-snakemake mamba environment
mamba activate run_cellranger_env
```

### Running
#### On local computer
```
snakemake --configfile config/config.yaml --cores all --keep-incomplete --resources load=100
```
<div style="color: red;">
  <strong>Resources flag must be added when running Snakemake pipeline to ensure proper load management; modify according to computing power.</strong>
</div>
[For reference, 1 run_cr requires a load of 50; 256GB of ram allows for ~ 2 simultaneous runs of CellRanger.]

#### On HPC

example.sbatch script must be present

*Example of example.sbatch format to run pipeline:*

```
#!/bin/bash

#SBATCH -t 72:00:00           # Maximum time to run the whole pipeline, will stop after the time exceed
#SBATCH -N 1
#SBATCH --ntasks-per-node 60
#SBATCH --cpus-per-task 1
#SBATCH --mem 128G            # Max RAM memory needed
#SBATCH -J CR_pipeline        # Prefix for .out and .err file
#SBATCH --output=%x-%j.out    # Show the output produced
#SBATCH --error=%x-%j.err     # Show the error output produced
#SBATCH -p cpu

snakemake --cores all --keep-incomplete --resources load=100
```

After preparing the sbatch file, submit the job to HPC:

```
sbatch xxx.sbatch
```

After running the code above, job_id will be given and you can check the jon status (```RUNNING```, ```PENDING```, ```FAILED```) by:

```
sacct -j [job id]
```

## Workflow

### #1 Preparation of "metadata.csv"

Most important step of entire workflow. In this example, the file [atac_only_md_example.csv](./workflow/metadata_folder/atac_only_md_example.csv) is used in the config.yaml file - any file name can be used just edit config file accordingly.
Ensure format of example_metadata.csv is adhered to strictly; Format should be exactly as that of the "example_metadata.csv" file provided.

Note: "GSM" typically refers to a library and "SRR" to a run. Although these terminologies may be used inaccurately in the current context, please adhere to the column names specified in test_run_multiome.csv for consistency and accuracy.


### #2 Adjusting parameters in config.yaml
The config.yaml file should look like as [config.yaml](./config/config.yaml)

Ensure config.yaml files is properly adjusted. For more information and to know what suffix to use, please refer to: https://www.10xgenomics.com/support/software/cell-ranger-arc/latest/tutorials/inputs/specifying-input-fastq-count

*Common mistakes include forgetting "ignore" in the suffixes section and mistyping respective paths, which may lead to errors.*

*Ensure the link to download [cellranger-arc](https://support.10xgenomics.com/single-cell-multiome-atac-gex/software/downloads/latest) and [cellranger-atac](https://support.10xgenomics.com/single-cell-atac/software/downloads/latest) is the latest as they keep changing the link*

### #3 Maintaining proper directory structure 
#### Before running
Prior to running the snakemake pipeline, the file stucture should look like this:

```
    .
    ├── config
    │   └── config.yaml
    ├── workflow
        └── cellranger_output
        └── metadata_folder
        |   └── metadata.csv
        └── resources
        └── rules
        |   └── create_libraries_csv.smk
        |   └── fetch_fastq.smk
        |   └── resources.smk
        |   └── run_cr.smk
        └── Snakefile
        └── cr-run-snakemake.sbatch
```
    
Runs will be generated according to "ID" in metadata.csv [i.e. 1  "ID" will have 1 "outs" folder].

#### After running
After running the pipeline, here is how the structure look like:

```
    .
    ├── config
    │   └── config.yaml
    ├── workflow
        └── cellranger_output
        |   └── sample1
        |       └── outs
        └── metadata_folder
        |   └── metadata.csv
        └── resources
        |   └── cellranger-arc
        |   |   └── bin
        |   |       └── cellranger-arc
        |   └── cellranger-atac
        |   |    └── bin
        |   |       └── cellranger-arc
        |   └── genome
        └── rules
        |   └── create_libraries_csv.smk
        |   └── fetch_fastq.smk
        |   └── resources.smk
        |   └── run_cr.smk
        └── Snakefile
        └── cr-run-snakemake.sbatch
```


## Dependencies
| Dependencies  |Link                                                                       |
|:--------------|:-------------------------------------------------------------------       |
| CellRangerARC |https://www.10xgenomics.com/support/software/cell-ranger-arc/latest        |
| CellRangerATAC|https://support.10xgenomics.com/single-cell-atac/software/downloads/latest |
| SRA_Toolkit   |https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit         |
| Snakemake     |https://snakemake.readthedocs.io/en/stable/                                |
| PigZ          |https://zlib.net/pigz/     
