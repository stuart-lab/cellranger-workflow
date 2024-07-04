#Define input, first rule will be prefetch.

def read_atac_accession():
    with open('atac_accessions.txt') as f:
        samples = [sample for sample in f.read().split('\n') if len(sample) > 0]  # we dont want empty lines
        return samples


SRRs = read_atac_accession()

rule all:
    input: # Update to look for fastq files
      expand("atac_seq/{srr}/{srr}_S1_L001_R1_001.fastq.gz", srr=SRRs),
      expand("atac_seq/{srr}/{srr}_S1_L001_R2_001.fastq.gz", srr=SRRs),
      expand("atac_seq/{srr}/{srr}_S1_L001_R3_001.fastq.gz", srr=SRRs)

rule prefetch_atac:
    output:
      "atac_seq/{srr}/{srr}.sra"
    shell:
      """
      prefetch {wildcards.srr} --max-size 50G -O atac_seq
      """

rule fastq_dump_atac:
    input:
      "atac_seq/{srr}/{srr}.sra"
    output:
      "atac_seq/{srr}/{srr}_1.fastq",
      "atac_seq/{srr}/{srr}_2.fastq",
      "atac_seq/{srr}/{srr}_3.fastq"
    shell:
      """
      fasterq-dump --split-files --include-technical {input} -O atac_seq/{wildcards.srr}
      """

rule rename_fastq_files:
    input:
      "atac_seq/{srr}/{srr}_1.fastq",
      "atac_seq/{srr}/{srr}_2.fastq",
      "atac_seq/{srr}/{srr}_3.fastq"
    output:
      "atac_seq/{srr}/{srr}_S1_L001_R1_001.fastq",
      "atac_seq/{srr}/{srr}_S1_L001_R2_001.fastq",
      "atac_seq/{srr}/{srr}_S1_L001_R3_001.fastq"
    shell:
      """
      mv atac_seq/{wildcards.srr}/{wildcards.srr}_1.fastq atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R1_001.fastq
      mv atac_seq/{wildcards.srr}/{wildcards.srr}_2.fastq atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R2_001.fastq
      mv atac_seq/{wildcards.srr}/{wildcards.srr}_3.fastq atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R3_001.fastq
      """


rule pigz_fastq_atac:
    input:
      "atac_seq/{srr}/{srr}_S1_L001_R1_001.fastq",
      "atac_seq/{srr}/{srr}_S1_L001_R2_001.fastq",
      "atac_seq/{srr}/{srr}_S1_L001_R3_001.fastq"
    output:
      "atac_seq/{srr}/{srr}_S1_L001_R1_001.fastq.gz",
      "atac_seq/{srr}/{srr}_S1_L001_R2_001.fastq.gz",
      "atac_seq/{srr}/{srr}_S1_L001_R3_001.fastq.gz"
    shell:
      """
      pigz atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R1_001.fastq
      pigz atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R2_001.fastq
      pigz atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R3_001.fastq
      """