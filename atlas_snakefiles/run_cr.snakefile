#Make 1 library.csv for a pair of ATAC and RNA seq accession numbers
def read_rna_accession():
    with open('rna_accessions.txt') as f:
        samples = [sample for sample in f.read().split('\n') if len(sample) > 0]  # Remove empty lines
        return samples

def read_atac_accession():
    with open('atac_accessions.txt') as f:
        samples = [sample for sample in f.read().split('\n') if len(sample) > 0]  # Remove empty lines
        return samples

# Read ATAC and RNA accession IDs
atac_SRRs = read_atac_accession()
rna_SRRs = read_rna_accession()


rule all:
  input:
      expand("{atac_srr}_{rna_srr}",zip, atac_srr=atac_SRRs, rna_srr=rna_SRRs)


# Rule to create libraries.csv
rule create_libraries_csv:
  output:
      "{atac_srr}_{rna_srr}_libraries.csv"
  run:
    atac_srr = wildcards.atac_srr
    rna_srr = wildcards.rna_srr
    with open(output[0], "w") as f:
        f.write("fastqs,sample,library_type\n")
        f.write(f"atac_seq/{atac_srr},{atac_srr},Chromatin Accessibility\n")
        f.write(f"rna_seq/{rna_srr},{rna_srr},Gene Expression\n")
          
            
rule run_cr:
  output:"{atac_srr}_{rna_srr}"
  shell:
    """
    cellranger-arc count --id={wildcards.atac_srr}_{wildcards.rna_srr} \
                         --reference=refdata-cellranger-arc-GRCh38-2020-A-2.0.0 \
                         --libraries={wildcards.atac_srr}_{wildcards.rna_srr}_libraries.csv \
    """

  

