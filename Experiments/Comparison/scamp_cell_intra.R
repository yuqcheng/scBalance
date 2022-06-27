library(Matrix)
library(scmap)
library(SingleCellExperiment)
setwd("C:/Users/zhangjn.CSDOMAIN/Desktop/Zheng 68K")
raw_data <- read.csv("Filtered_68K_PBMC_data.csv", header = T, row.names = 1)
Labels <- read.csv("Labels.csv", header = T)
memory.limit(80000)

data_matrix <- as(as.matrix(t(raw_data)), "dgCMatrix")
genes <- rownames(data_matrix)
rm(raw_data)
gc()
save(data_matrix, file = "DATAMATRIX.RData")

rm(list=ls())
gc()
load("DATAMATRIX.Rdata")
Labels <- read.csv("Labels.csv", header = T)
n_folds = 5
cols = dim(data_matrix)[2]
rows_block = cols%/%n_folds

for (i in 0:(n_folds-1){
  print(paste0("Fold :                ", i+1))
  lower = rows_block*i+1
  upper = rows_block*(i+1)
  test_data <- data_matrix[, lower:upper]
  test_label <- Labels[lower:upper, ]
  ref_data <- data_matrix[, c(1:lower, upper:cols)]
  ref_label <- Labels[c(1:lower, upper:cols), ]
  
  print("making ref_sce")
  ref_sce <- SingleCellExperiment(assays = list(normcounts = as.matrix(ref_data)), colData = ref_label)
  logcounts(ref_sce) <- log2(normcounts(ref_sce) + 1)
  rowData(ref_sce)$feature_symbol <- rownames(ref_sce)
  ref_sce <- ref_sce[!duplicated(rownames(ref_sce)), ]
  ref_sce <- selectFeatures(ref_sce, suppress_plot = FALSE)
  ref_sce <- indexCell(ref_sce)
  
  print("making test_sce")
  test_sce <- SingleCellExperiment(assays = list(normcounts = as.matrix(test_data)), colData = test_label)
  logcounts(test_sce) <- log2(normcounts(test_sce) + 1)
  rowData(test_sce)$feature_symbol <- rownames(test_sce)
  test_sce <- test_sce[!duplicated(rownames(test_sce)), ]
  test_sce <- selectFeatures(test_sce, suppress_plot = FALSE)
  test_sce <- indexCell(test_sce)
  
  print("predicting")
  scmapCell_results <- scmapCell(
    test_sce, 
    list(yan = metadata(ref_sce)$scmap_cell_index)
  )
  scmapCell_clusters <- scmapCell2Cluster(
    scmapCell_results, 
    list(as.character(colData(ref_sce)$X))
  )
  result = scmapCell_clusters$scmap_cluster_labs
  result_new = rbind(true_label = test_label, pred_label = result[,1])
  
  print("saving results")
  write.csv(result_new, paste0("result_block_", i+1, ".csv"), row.names = TRUE)
  save(result_new, file = paste0("result_block_", i+1, ".RData"))
  rm(ref_sce, test_sce, ref_data, result, result_new,scmapCell_clusters, scmapCell_results,test_data)
  gc()
  
}
rm(list=ls())
