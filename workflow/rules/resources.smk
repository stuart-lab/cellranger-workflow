# Downloads and extracts cellranger arc and atac
rule get_cellranger:
    output:
        cr_arc_bin  = "resources/cellranger-arc/bin/cellranger-arc",
        cr_atac_bin = "resources/cellranger-atac/bin/cellranger-atac"
    params:
        cr_arc_url  = config["get_cellranger"]["cr_arc_url"],
        cr_atac_url = config["get_cellranger"]["cr_atac_url"]
    log:
        cr_arc_log  = "results/logs/get_cellranger/get_cellranger-arc.log",
        cr_atac_log = "results/logs/get_cellranger/get_cellranger-atac.log"
    shell:
        """
        curl -v -o resources/cellranger-arc.tar.gz "{params.cr_arc_url}" &> {log.cr_arc_log}
        tar -xzvf resources/cellranger-arc.tar.gz -C resources &> {log.cr_arc_log} && \
        rm -rf resources/cellranger-arc.tar.gz
        if [ -d "resources/cellranger-arc" ]; then
            rm -rf resources/cellranger-arc
        fi
        mv resources/cellranger-arc-* resources/cellranger-arc

        curl -v -o resources/cellranger-atac.tar.gz "{params.cr_atac_url}" &> {log.cr_atac_log}
        tar -xzvf resources/cellranger-atac.tar.gz -C resources &> {log.cr_arc_log} && \
        rm -rf resources/cellranger-atac.tar.gz
        if [ -d "resources/cellranger-atac" ]; then
            rm -rf resources/cellranger-atac
        fi
        mv resources/cellranger-atac-* resources/cellranger-atac
        """

rule get_reference:
    output:
        dir=directory("resources/genome")
    params:
        url=config["get_reference"]["ref_url"]
    log:
        "results/logs/get_reference/get_reference.log"
    shell:
        """
        curl -v -o resources/genome.tar.gz "{params.url}" &> {log}
        tar -xzf resources/genome.tar.gz -C resources &> {log} && \
        rm -rf resources/genome.tar.gz
        mv resources/refdata-* resources/genome
        """
