Dump of all snakefiles to run cellranger from fastq_dump using SRA_toolit

**Note: the file path in the create_libraries_csv rule in run_cr.snakefile must be the asbolute path, not the relative path.

--Things to do --
1) Make configfile.yaml for atac_accessions, rna_accessions, and absolute path to folders to make pipeline cleaner and more modular
2) Somehow incorporate get_atac and get_rna into run_cr
3) Add code to remove temporary files to make it cleaner