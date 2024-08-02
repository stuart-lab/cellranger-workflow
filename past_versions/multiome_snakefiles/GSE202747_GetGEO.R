id <- 'GSE202747'

setwd(paste0("C:/Users/castillofhn/Desktop/SCEA/", id))

pacman::p_load(tidyverse, janitor, readxl, GEOquery)


## Get the data from correct slot
df <- getGEO(id)
p  <- df[[1]] %>% pData()

identical( rownames(p), p$geo_accession)

## get the variable component
v <- p %>% remove_constant()


## get the constant component
constant <- p[ , setdiff( colnames(p), colnames(v) ) ] %>% 
  unique() %>% 
  t() %>% 
  data.frame() %>% 
  rownames_to_column("Column")

## write out
openxlsx::write.xlsx(
  list(GSE = v, GSE_constant = constant),
  file = paste0(id, "_metadata_tmp.xlsx") 
  )

## Update excel

## Create the library files
id2gsm  <- read_excel(paste0(id, "_metadata.xlsx"), sheet = "multiome") %>% 
  select(ID, `Chromatin Accessibility`, `Gene Expression`) %>% 
  pivot_longer(cols = !ID, 
               names_to = "library_type", 
               values_to = "GSM")

gsm2srr <- read_excel(paste0(id, "_metadata.xlsx"), sheet = "runtable_min") %>% 
  select(GSM = 'Sample Name', Library = 'Run')

meta <- left_join(id2gsm, gsm2srr) 


write_csv(meta, file = paste0(id, "_metadata.csv"))

# fastqs,sample,library_type
# /home/jdoe/runs/HNGEXSQXXX/outs/fastq_path,example,Gene Expression
# /home/jdoe/runs/HNATACSQXX/outs/fastq_path,example,Chromatin Accessibility





