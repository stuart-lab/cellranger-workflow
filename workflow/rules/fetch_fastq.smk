#downloads the fastq files
rule fetch_fastq:
    input:
        "{param}/libraries/{id}_libraries.csv"
    params:
        proc_dir=config["path"]["process_dir"],
        run_type=config["type"],
        ATAC1=config["ATAC1"],
        ATAC2=config["ATAC2"],
        ATAC3=config["ATAC3"],
        ATAC4=config["ATAC4"],
        RNA1=config["RNA1"],
        RNA2=config["RNA2"],
        RNA3=config["RNA3"],
        RNA4=config["RNA4"]
    output:
        directory("{param}/fastq/{id}")
    run:
        tmp_df = df[df['ID']==f"{wildcards.id}"]

        for srr_number in tmp_df["Library"]:
            #lazy change the rest
            i = srr_number
            #get library type
            srr_row_in_df = df[df['Library'] == srr_number]
            library_type_of_srr = srr_row_in_df['library_type'].values[0]
            
            # Download and split files
            if library_type_of_srr == "Chromatin Accessibility":
                dest_folder = f"{params.proc_dir}/fastq/{wildcards.id}/atac_seq"
            else:
                dest_folder = f"{params.proc_dir}/fastq/{wildcards.id}/rna_seq"

            print("--fetching .sra file--")
            shell(f"prefetch {i} --max-size 100G -O {dest_folder}")

            print("--executing fastq dump--")
            shell(f"fasterq-dump --split-files --include-technical {dest_folder}/{i}/{i}.sra -O {dest_folder}/{srr_number}")

            # Rename

            print("--renaming files--")
            if library_type_of_srr == "Chromatin Accessibility":
                print("--renaming ATAC files--")
                if config["ATAC1"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_1.fastq {dest_folder}/{i}/{i}_{params.ATAC1}") 
                if config["ATAC2"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_2.fastq {dest_folder}/{i}/{i}_{params.ATAC2}")
                if config["ATAC3"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_3.fastq {dest_folder}/{i}/{i}_{params.ATAC3}")
                if config["ATAC4"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_4.fastq {dest_folder}/{i}/{i}_{params.ATAC4}")
            elif library_type_of_srr == "Gene Expression":    
                print("--renaming rna files--")            
                if config["RNA1"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_1.fastq {dest_folder}/{i}/{i}_{params.RNA1}")    
                if config["RNA2"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_2.fastq {dest_folder}/{i}/{i}_{params.RNA2}")
                if config["RNA3"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_3.fastq {dest_folder}/{i}/{i}_{params.RNA3}")
                if config["RNA4"]!="ignore":
                    shell(f"mv {dest_folder}/{i}/{i}_4.fastq {dest_folder}/{i}/{i}_{params.RNA4}")

            print("--zipping files--") 
            shell(f"pigz {dest_folder}/{srr_number}/*")
