#Define input, first rule will be prefetch.

def read_atac_accession():
    with open('atac_accessions.txt') as f:
        samples = [sample for sample in f.read().split('\n') if len(sample) > 0]  # we dont want empty lines
        return samples


SRRs = read_atac_accession()

rule all:
    input:
      expand("atac_seq/{srr}/{srr}_S1_L001_I1_001.fastq.gz", srr=SRRs),  # Update to look for fastq.gz files
      expand("atac_seq/{srr}/{srr}_S1_L001_R1_001.fastq.gz", srr=SRRs),
      expand("atac_seq/{srr}/{srr}_S1_L001_R2_001.fastq.gz", srr=SRRs),
      expand("atac_seq/{srr}/{srr}_S1_L001_R3_001.fastq.gz", srr=SRRs),

rule prefetch_atac:
    output:
      "atac_seq/{srr}/{srr}.sra"
    shell:
      """
      prefetch {wildcards.srr} --max-size 50G -O atac_seq/{wildcards.srr}
      """

rule fastq_dump_atac:
    input:
      "atac_seq/{srr}/{srr}.sra"
    output:
      "atac_seq/{srr}/{srr}_1.fastq.gz",
      "atac_seq/{srr}/{srr}_2.fastq.gz",
      "atac_seq/{srr}/{srr}_3.fastq.gz",
      "atac_seq/{srr}/{srr}_4.fastq.gz"
    shell:
      """
      fastq-dump --split-files --gzip {input} -O atac_seq/{wildcards.srr}
      """

rule rename_fastq_files:
    input:
      "atac_seq/{srr}/{srr}_1.fastq.gz",
      "atac_seq/{srr}/{srr}_2.fastq.gz",
      "atac_seq/{srr}/{srr}_3.fastq.gz",
      "atac_seq/{srr}/{srr}_4.fastq.gz"
    output:
      "atac_seq/{srr}/{srr}_S1_L001_I1_001.fastq.gz",
      "atac_seq/{srr}/{srr}_S1_L001_R1_001.fastq.gz",
      "atac_seq/{srr}/{srr}_S1_L001_R2_001.fastq.gz",
      "atac_seq/{srr}/{srr}_S1_L001_R3_001.fastq.gz"
    shell:
      """
      mv atac_seq/{wildcards.srr}/{wildcards.srr}_1.fastq.gz atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_I1_001.fastq.gz
      mv atac_seq/{wildcards.srr}/{wildcards.srr}_2.fastq.gz atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R1_001.fastq.gz
      mv atac_seq/{wildcards.srr}/{wildcards.srr}_3.fastq.gz atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R2_001.fastq.gz
      mv atac_seq/{wildcards.srr}/{wildcards.srr}_4.fastq.gz atac_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R3_001.fastq.gz
      """
    


