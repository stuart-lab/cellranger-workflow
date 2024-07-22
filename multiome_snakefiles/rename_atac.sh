cd /home/users/astar/gis/stufrancis/scratch/adai_snakemake

find tissues -type f -path '*/atac_seq/*/SRR*_?.fastq.gz' | while read -r file; do
    directory=$(dirname "$file")
    filename=$(basename "$file")
    
    # Example to extract specific part from the filename
    srr=$(echo "$filename" | cut -d'_' -f1)
    read_no=$(echo "$filename" | cut -d'_' -f2 | cut -d'.' -f1)

    new_filename="${srr}_S1_L001_R${read_no}_001.fastq.gz"
    
    mv "$directory/$filename" "$directory/$new_filename"
done


