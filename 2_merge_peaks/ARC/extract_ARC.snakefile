configfile:'config.yaml'


rule all:
    input:
        "bed",
        "metrics",
        "filtered_matrix",
        "frags"



rule extract_bed:
    output:
        directory("bed")
    params:
        bed_directory=config['path']['wd']+"bed"
    shell:
        """
        mkdir bed

        echo extracting bed files
        find . -type f -name "atac_peaks.bed" | while read -r file; do
            directory=$(dirname "$file")
            filename=$(basename "$file")
            bed_directory={params.bed_directory}

            second_parent=$(dirname "$(dirname "$file")")
            newname=$(basename "$second_parent")

            #echo $directory/$filename
            #echo $bed_directory/$newname"_peaks.bed"
            #echo $file

            cp $directory/$filename $bed_directory/$newname"_peaks.bed"
            
        done

        echo bed files extracted
        """

rule extract_metadata:
    output:
        directory("metrics")
    params:
        new_directory=config['path']['wd']+"metrics"
    shell:
        """
        mkdir metrics

        echo extracting metadata files
        find . -type f -name "per_barcode_metrics.csv" | while read -r file; do
            directory=$(dirname "$file")
            filename=$(basename "$file")

            new_directory={params.new_directory}

            second_parent=$(dirname "$(dirname "$file")")
            newname=$(basename "$second_parent")
            
            copy_from="$directory/$filename"
            copy_to="$new_directory/$newname"_metrics.csv""

            #echo $copy_from
            #echo $copy_to
            #echo $file

            cp $directory/$filename $new_directory/$newname"_metrics.csv"

        done
        echo metadata files extracted
        """

rule extract_h5:
    output:
        directory("filtered_matrix")
    params:
        new_directory=config['path']['wd']+"filtered_matrix"
    shell:
        """
        mkdir filtered_matrix

        echo extracting sparse matrix files
        find . -type f -name "filtered_feature_bc_matrix.h5" | while read -r file; do
            directory=$(dirname "$file")
            filename=$(basename "$file")

            new_directory={params.new_directory}

            second_parent=$(dirname "$(dirname "$file")")
            newname=$(basename "$second_parent")
            
            copy_from="$directory/$filename"
            copy_to="$new_directory/$newname"_filtered_matrix.h5""

            #echo $copy_from
            #echo $copy_to
            #echo $file

            cp $copy_from $copy_to

        done
        echo sparse matrix files extracted
        """

rule extract_frags:
    output:
        directory("frags")
    params:
        new_directory=config['path']['wd']+"frags"
    shell:
        """
        mkdir frags

        echo extracting fragment files
        find . -type f -name "atac_fragments.tsv.gz" | while read -r file; do
            directory=$(dirname "$file")
            filename=$(basename "$file")

            new_directory={params.new_directory}

            second_parent=$(dirname "$(dirname "$file")")
            newname=$(basename "$second_parent")
            
            copy_from="$directory/$filename"
            copy_to="$new_directory/$newname"_f.tsv.gz""

            #echo $copy_from
            #echo $copy_to
            #echo $file

            cp $copy_from $copy_to

        done
        echo fragment files extracted

        echo extracting fragment index files
        find . -type f -name "atac_fragments.tsv.gz.tbi" | while read -r file; do
            directory=$(dirname "$file")
            filename=$(basename "$file")

            new_directory={params.new_directory}

            second_parent=$(dirname "$(dirname "$file")")
            newname=$(basename "$second_parent")
            
            copy_from="$directory/$filename"
            copy_to="$new_directory/$newname"_f.tsv.gz.tbi""

            #echo $copy_from
            #echo $copy_to
            #echo $file

            cp $copy_from $copy_to

        done
        echo fragment index files extracted
        """





