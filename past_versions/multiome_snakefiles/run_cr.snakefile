import pandas as pd

# Read the CSV file to extract IDs
# input[0] because there's only one input file

df = pd.read_csv("GSE202747_metadata.csv")  
# Extract unique IDs from the 'ID' column
IDs = set(df['ID'])

rule all:
  input:
      expand("{id}", id  = IDs)
rule run_cr:
  output:
    directory("{id}")
  resources:
    load=50
  shell:
    """
    cellranger-arc count --id={wildcards.id} \
                         --reference=../CellRangerFiles/refdata-cellranger-arc-GRCh38-2020-A-2.0.0/ \
                         --libraries=libraries/{wildcards.id}_libraries.csv \
                         --localcores=48 \
                         --localmem=64
    """

