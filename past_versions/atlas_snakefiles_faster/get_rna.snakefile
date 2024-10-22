#Define input, first rule will be prefetch.

def read_rna_accession():
    with open('rna_accessions.txt') as f:
        samples = [sample for sample in f.read().split('\n') if len(sample) > 0]  # we dont want empty lines
        return samples


SRRs = read_rna_accession()

rule all:
    input:
      expand("rna_seq/{srr}/{srr}_S1_L001_I1_001.fastq", srr=SRRs),  # Update to look for fastq files
      expand("rna_seq/{srr}/{srr}_S1_L001_I2_001.fastq", srr=SRRs),
      expand("rna_seq/{srr}/{srr}_S1_L001_R1_001.fastq", srr=SRRs),
      expand("rna_seq/{srr}/{srr}_S1_L001_R2_001.fastq", srr=SRRs),

rule prefetch_rna:
    output:
      "rna_seq/{srr}/{srr}.sra"
    shell:
      """
      prefetch {wildcards.srr} --max-size 50G -O rna_seq
      """
      
rule fastq_dump_rna:
    input:
      "rna_seq/{srr}/{srr}.sra"
    output:
      "rna_seq/{srr}/{srr}_1.fastq",
      "rna_seq/{srr}/{srr}_2.fastq",
      "rna_seq/{srr}/{srr}_3.fastq",
      "rna_seq/{srr}/{srr}_4.fastq"
    shell:
      """
      fasterq-dump --split-files --include-technical {input} -O rna_seq/{wildcards.srr}
      """

rule rename_fastq_files:
    input:
      "rna_seq/{srr}/{srr}_1.fastq",
      "rna_seq/{srr}/{srr}_2.fastq",
      "rna_seq/{srr}/{srr}_3.fastq",
      "rna_seq/{srr}/{srr}_4.fastq"
    output:
      "rna_seq/{srr}/{srr}_S1_L001_I1_001.fastq",
      "rna_seq/{srr}/{srr}_S1_L001_I2_001.fastq",
      "rna_seq/{srr}/{srr}_S1_L001_R1_001.fastq",
      "rna_seq/{srr}/{srr}_S1_L001_R2_001.fastq"
    shell:
      """
      mv rna_seq/{wildcards.srr}/{wildcards.srr}_1.fastq rna_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_I1_001.fastq
      mv rna_seq/{wildcards.srr}/{wildcards.srr}_2.fastq rna_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_I2_001.fastq
      mv rna_seq/{wildcards.srr}/{wildcards.srr}_3.fastq rna_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R1_001.fastq
      mv rna_seq/{wildcards.srr}/{wildcards.srr}_4.fastq rna_seq/{wildcards.srr}/{wildcards.srr}_S1_L001_R2_001.fastq
      """
    

