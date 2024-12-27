#creates libraries.csv file
rule create_libraries_csv:
    params:
        proc_dir=config["path"]["process_dir"],
        run_type=config["type"]
    output:
        "{param}/libraries/{id}_libraries.csv"
    run:
        if config["type"]=="multiome" or config["type"]=="ATAC":
            curr_id = wildcards.id
            tmp_df = df[df['ID']==f"{curr_id}"]

            atac_srr = tmp_df[tmp_df['library_type'] == 'Chromatin Accessibility']
            rna_srr = tmp_df[tmp_df['library_type'] == 'Gene Expression']

            with open(output[0], "w") as f:
                f.write("fastqs,sample,library_type\n")
                for i in atac_srr['Library']:
                    f.write(f"{params.proc_dir}/fastq/{wildcards.id}/atac_seq/{i},{i},Chromatin Accessibility\n")
                for j in rna_srr['Library']:
                    f.write(f"{params.proc_dir}/fastq/{wildcards.id}/rna_seq/{j},{j},Gene Expression\n")
        else:
            print("Please fix config file")
