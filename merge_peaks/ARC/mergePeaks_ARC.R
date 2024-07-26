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


##merge
SeuratObjectMerger_atac <- function(dataset_prefixes, common_peak_set) {
  # load metadata
  result_md <- list()
  
  message('--Metadata--')
  for (i in dataset_prefixes){
    result_md[[i]] <- read.table(
      file = paste0("./metrics/", i, "_metrics.csv"),
      stringsAsFactors = FALSE,
      sep = ",",
      header = TRUE
    )%>% 
      filter(barcode != "NO_BARCODE", 
             is__cell_barcode ==1, 
             passed_filters > 1000) %>%
      column_to_rownames("barcode")        
  }
  
  # create fragment object
  
  message('--Fragments--')
  result_frags <- list()
  for (i in dataset_prefixes){
    result_frags[[i]] <- CreateFragmentObject(
      path = paste0("./frags/", i, "_f.tsv.gz"),
      cells = rownames(result_md[[i]])
    )
  }
  
  #Quantify peaks in each dataset
  
  message('--Counts--')
  result_counts <- list()
  for (i in dataset_prefixes){
    message(paste("loading_counts",i))
    result_counts[[i]] <- FeatureMatrix(
      fragments = result_frags[[i]],
      features = common_peak_set,
      cells = rownames(result_md[[i]])
    )
  }
  
  message('--Create Chromatin Assay--')
  
  result_assay <- list()
  for (i in dataset_prefixes){
    result_assay[[i]] <- CreateChromatinAssay(result_counts[[i]], fragments = result_frags[[i]])
  }
  
  message('--Create Seurat Object--')
  
  result_list <- list()
  for (i in dataset_prefixes){
    result_list[[i]] <- CreateSeuratObject(result_assay[[i]], assay = "ATAC_only", meta.data=result_md[[i]])
    
    result_list[[i]]$dataset <- i
  }
  message('--Merge--')
  
  combined <- merge(
    x = result_list[[1]],
    y = result_list[2:length(result_list)],
    add.cell.ids = dataset_prefixes)
  
  return(combined) 
}

retina_atac_atlas <- SeuratObjectMerger_atac(atac_prefixes, CommonPeakSet)

# extract gene annotations from EnsDb
annotations <- GetGRangesFromEnsDb(ensdb = EnsDb.Hsapiens.v86)

# change to UCSC style since the data was mapped to hg19
seqlevels(annotations) <- paste0('chr', seqlevels(annotations))
genome(annotations) <- "hg38"

Annotation(retina_atac_atlas) <- annotations


retina_atac_atlas <- NucleosomeSignal(object = retina_atac_atlas, verbose = TRUE)
retina_atac_atlas <- TSSEnrichment(object = retina_atac_atlas, fast = FALSE, verbose = TRUE)

save(retina_atac_atlas, file = "retina_atac_atlas.rds")


