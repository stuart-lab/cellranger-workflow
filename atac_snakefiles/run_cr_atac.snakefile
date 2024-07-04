configfile:'config.yaml'

def read_atac_accession():
    with open('atac_accessions.txt') as f:
        samples = [sample for sample in f.read().split('\n') if len(sample) > 0]  # Remove empty lines
        return samples

# Read ATAC and RNA accession IDs
atac_SRRs = read_atac_accession()

rule all:
  input:
      expand("{atac_srr}", atac_srr=atac_SRRs)

rule get_files_atac:
  output:
    temp(directory("atac_seq/"))
  shell:
    """
    snakemake --cores all --keep-incomplete -s get_atac.snakefile
    """

rule run_cr_atac:
  input:
    "atac_seq/",
  output:
    directory("{atac_srr}")
  params:
    ref=config['path']['ref_genome'],
    fastqs=lambda wildcards, output: config['path']['wd'] + f"/atac_seq/{output}"
  shell:
    """
    cellranger-atac count --id=sample345 \
                          --reference={params.ref} \
                          --fastqs={params.fastqs} \
                          --localcores=48 \
    """



