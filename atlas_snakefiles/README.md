Dump of all snakefiles to run cellranger from fastq_dump using SRA_toolit

**Note: 
1) The file path in the create_libraries_csv rule in run_cr.snakefile must be the asbolute path, not the relative path.
2) ref genome to directory is not added due to size; it should be in this directory along with snakefiles for it to work.
   link to reference genome: https://www.10xgenomics.com/support/software/cell-ranger-arc/downloads 

--Things to do --
1) Make configfile.yaml for atac_accessions, rna_accessions, and absolute path to folders to make pipeline cleaner and more modular
2) Somehow incorporate get_atac and get_rna into run_cr
3) Add code to remove temporary files to make it cleaner