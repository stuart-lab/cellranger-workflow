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


#atac_merger <- function(atac_prefixes, common_peak_set){
annotation <- GetGRangesFromEnsDb(ensdb = EnsDb.Hsapiens.v86)
seqlevels(annotation) <- paste0('chr', seqlevels(annotation))
for (id in atac_prefixes){
  counts <- Read10X_h5(paste0("../retina_atac/filtered_matrix/", id, "_filtered_matrix.h5"))
  fragpath <- paste0("../retina_atac/frags/", id, "_f.tsv.gz")
  
  
  
  
  message(paste("loading_metadata"))
  
  metadata <- read.csv(
    file = paste0("../retina_atac/metrics/", id, "_metrics.csv"),
    header = TRUE,
  ) %>% dplyr::filter(barcode != "NO_BARCODE", 
                      is__cell_barcode == 1, 
                      passed_filters > 1000) %>%
    column_to_rownames("barcode") 
  
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
  message(paste("chromatin_assay"))
  chrom_assay <- CreateChromatinAssay(
    counts = atac_counts,
    sep = c(":", "-"),
    fragments = fragments,
    min.cells = 10,
    min.features = 200
  )
  
  message(paste("seurat_object"))
  tmp <- CreateSeuratObject(
    counts = chrom_assay,
    assay = "ATAC",
    meta.data = metadata,
    project = id      
  )
  
  assign(id, tmp, envir = .GlobalEnv)
}

return('done')
}

save(retina_atac_atlas, file = "retina_atac_atlas.rds")


