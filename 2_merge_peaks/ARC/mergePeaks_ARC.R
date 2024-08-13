##Note: this script has been turned into a fuction; please refer to the .ipynb file in the main
##page for more information, thank you!

setwd("/home/users/astar/gis/stufrancis/scratch/R_work/retina_atac")

library('EnsDb.Hsapiens.v86')
library("Signac")
library("Seurat")
library("tidyverse")
library("data.table")
library("dplyr")
library("R.utils")
library("future")

##set peaks
CommonPeakSetter <- function(dataset_prefixes) {
  result_bed <- list()
  result_gr <- list()
  
  message('--Bed files--')
  for (i in dataset_prefixes){
    message(paste("loading",i))
    result_bed[[i]] <-  read.table(file = paste0("./bed/",i,"_peaks.bed"),
                                   col.names = c("chr", "start", "end"))
    
    result_gr[[i]] <- makeGRangesFromDataFrame(result_bed[[i]]) 
  }
  
  message('--Combine--')
  combined.peaks <- Signac::reduce(x = Reduce(c, result_gr))
  
  peakwidths <- width(combined.peaks)
  combined.peaks <- combined.peaks[peakwidths  < 10000 & peakwidths > 20]
  
  return(combined.peaks)
}


atac_prefixes <- readLines("accessions.txt")

CommonPeakSet <- CommonPeakSetter(atac_prefixes)


multiome_merger <-function(multiome_prefixes, common_peak_set){
  annotation <- GetGRangesFromEnsDb(ensdb = EnsDb.Hsapiens.v86)
  seqlevels(annotation) <- paste0('chr', seqlevels(annotation))
  
  for (id in multiome_prefixes){
    fragpath <- paste0("./frags/", id, "_f.tsv.gz")
    counts <- Read10X_h5(paste0("./filtered_matrix/", id, "_filtered_matrix.h5"))
    
    message(paste("loading_counts"))
    rna_counts <- counts$`Gene Expression`
    
    metadata <- read_csv(paste0("./metrics/", id, "_metrics.csv"), show_col_types = FALSE)
    #metadata <- metadata %>% column_to_rownames("barcode")
    
    message(paste("loading_metadata"))
    
    metadata <- dplyr::filter(metadata, is_cell ==1,
                              atac_fragments > 1000) %>%
      dplyr::rename(
        duplicate=atac_dup_reads,
        chimeric=atac_chimeric_reads,
        unmapped=atac_unmapped_reads,
        lowmapq=atac_lowmapq,
        mitochondrial=atac_mitochondrial_reads,
        passed_filters=atac_fragments,
        is__cell_barcode=is_cell,
        excluded_reason=excluded_reason,
        TSS_fragments=atac_TSS_fragments,
        peak_region_fragments=atac_peak_region_fragments,
        peak_region_cutsites=atac_peak_region_cutsites)%>%
      column_to_rownames("barcode")
    
    message(paste("removing low peak count cells from rna counts"))
    rna_counts <- rna_counts[, colnames(rna_counts) %in% rownames(metadata)]
    
    message(paste("loading_fragments"))
    
    fragments <- CreateFragmentObject(
      path = fragpath,
      cells = rownames(metadata)
    )
    
    
    message(paste("atac_counts"))
    
    atac_counts <- FeatureMatrix(
      fragments = fragments,
      features = common_peak_set,
      cells = rownames(metadata)
    )
    
    message(paste("seurat_object"))
    
    tmp <- CreateSeuratObject(
      counts = rna_counts,
      assay = "RNA",
      project = id
    )
    
    message(paste("loading_atac_assay"))
    
    tmp[["ATAC"]] <- CreateChromatinAssay(
      counts = atac_counts,
      sep = c(":", "-"),
      fragments = fragpath,
      annotation = annotation
    )
    
    tmp <- AddMetaData(
      object = tmp,
      metadata = metadata
    )
    assign(id, tmp, envir = .GlobalEnv)
  }
  
  return('done')
}

