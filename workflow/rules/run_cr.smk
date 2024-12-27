rule run_cr:
    input:
        "{param}/fastq/{id}",
        cr_arc_bin=rules.get_cellranger.output.cr_arc_bin,
        cr_atac_bin=rules.get_cellranger.output.cr_atac_bin,
        genome=rules.get_reference.output.dir
    output:
        directory("{param}/{id}")
    resources:
        load=50
    params:
        proc_dir=config["path"]["process_dir"],
        run_type=config["type"],
    run:
        print("--running cellranger rule--")
        if config["type"]=="multiome":
            print("--running cellranger arc for multiome data--")
            shell(  
                """
                {input.cr_arc_bin} count --id={wildcards.id} \
                        --reference={input.genome} \
                        --libraries=02_snakemake_download_cellranger/libraries/{wildcards.id}_libraries.csv \
                        --localcores=48 \
                        --localmem=64
                """
                )       

        elif config["type"]=="ATAC":
            print("--running cellranger atac for ATAC data--")

            lib_csv = pd.read_csv(f"02_snakemake_download_cellranger/libraries/{wildcards.id}_libraries.csv") 
            comma_separated_string_paths = ','.join(lib_csv['fastqs'])
            shell(
                f"""
                {input.cr_atac_bin} count --id={wildcards.id} \
                                    --reference={input.genome} \
                                    --fastqs={comma_separated_string_paths} \
                                    --localcores=48 \
                    """         
            )

        shell("mv {wildcards.id} {params.proc_dir}/{wildcards.id}")
