import pandas as pd

# Read the CSV file to extract IDs
# input[0] because there's only one input file

df = pd.read_csv("GSE202747_metadata.csv")  
# Extract unique IDs from the 'ID' column
IDs = set(df['ID'])

rule all:
    input:
        expand("tissues.done/{id}/atac_seq.done", id  = IDs),
        expand("tissues.done/{id}/rna_seq.done", id  = IDs)
##makes libraries.csv for 
rule create_libraries_csv:
  output:
    "libraries/{id}_libraries.csv"
  run:
    hello = wildcards.id
    tmp_df = df[df['ID']==f"{hello}"]

    atac_srr = tmp_df[tmp_df['library_type'] == 'Chromatin Accessibility']
    rna_srr = tmp_df[tmp_df['library_type'] == 'Gene Expression']

    with open(output[0], "w") as f:
        f.write("fastqs,sample,library_type\n")
        for i in atac_srr['Library']:
            f.write(f"/home/users/astar/gis/stufrancis/scratch/adai_snakemake/tissues/{wildcards.id}/atac_seq/{i},{i},Chromatin Accessibility\n")
        for j in rna_srr['Library']:
            f.write(f"/home/users/astar/gis/stufrancis/scratch/adai_snakemake/tissues/{wildcards.id}/rna_seq/{j},{j},Gene Expression\n")

##downloads all the SRR files
rule prefetch:
    input:
        "libraries/{id}_libraries.csv"
    output:
        directory("tissues/{id}/atac_seq"),
        directory("tissues/{id}/rna_seq")
    run:
        tmp_df = df[df['ID']==f"{wildcards.id}"]

        atac_srr = tmp_df[tmp_df['library_type'] == 'Chromatin Accessibility']['Library']
        rna_srr = tmp_df[tmp_df['library_type'] == 'Gene Expression']['Library']
        for i in atac_srr:
            shell(f"prefetch {i} --max-size 100G -O tissues/{wildcards.id}/atac_seq")
            shell(f"fasterq-dump --split-files "
                  f"--include-technical tissues/{wildcards.id}/atac_seq/{i}/{i}.sra -O tissues/{wildcards.id}/atac_seq/{i}")
            shell(f"pigz tissues/{wildcards.id}/atac_seq/{i}/*")
        for j in rna_srr:
            shell(f"prefetch {j} --max-size 100G -O tissues/{wildcards.id}/rna_seq")
            shell(f"fasterq-dump --split-files "
                  f"--include-technical tissues/{wildcards.id}/rna_seq/{j}/{j}.sra -O tissues/{wildcards.id}/rna_seq/{j}")
            shell(f"pigz tissues/{wildcards.id}/rna_seq/{j}/*")

rule rename:
    input:
        expand("tissues/{id}/atac_seq", id = IDs),
        expand("tissues/{id}/rna_seq", id = IDs)
    output:
        touch(directory("tissues.done/{id}/atac_seq.done")),
        touch(directory("tissues.done/{id}/rna_seq.done"))
    shell:
        """
        bash rename_atac.sh
        bash rename_rna.sh
        """
