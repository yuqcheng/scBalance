library(SingleCellExperiment)
library(scmap)
library(Matrix)

memory.limit(40000)
setwd("C:/Users/Plus0/Desktop/Inter-dataset/PbmcBench")

set.seed(1)
rm(list=ls())
gc()

load("matrix_data.RData")
load("labels.RData")


for (dataset in c("10Xv2", "10Xv3", "CEL_Seq", "Drop_Seq","inDrop", "Seq_Well", "Smart_Seq2")){
  tmp_sce <- SingleCellExperiment(assays = list(normcounts = as.matrix(get(paste0("matrix_", dataset)))), colData = get(paste0("label_", dataset)))
  logcounts(tmp_sce) <- log2(normcounts(tmp_sce) + 1)
  rowData(tmp_sce)$feature_symbol <- rownames(tmp_sce)
  tmp_sce <- tmp_sce[!duplicated(rownames(tmp_sce)), ]
  
  tmp_sce <- selectFeatures(tmp_sce, suppress_plot = FALSE)
  tmp_sce <- indexCell(tmp_sce)
  assign(paste0("sce_", dataset), tmp_sce)
  save(list = c(paste0("sce_", dataset)), file = paste0("sce_cell_", dataset, ".RData"))
  rm(list = c(paste0("sce_", dataset)))
}

rm(list=ls())
gc()

for (ref in c("10Xv2", "10Xv3", "CEL_Seq", "Drop_Seq","inDrop", "Seq_Well", "Smart_Seq2")){
  for (test in c("10Xv2", "10Xv3", "CEL_Seq", "Drop_Seq","inDrop", "Seq_Well", "Smart_Seq2")){
    if (ref != test){
      load("labels.RData")
      load(paste0("sce_cell_", ref, ".RData"))
      load(paste0("sce_cell_", test, ".RData"))
      scmapCell_results <- scmapCell(
        get(paste0("sce_", test)), 
        list(yan = metadata(get(paste0("sce_", ref)))$scmap_cell_index)
      )
      scmapCell_clusters <- scmapCell2Cluster(
        scmapCell_results, 
        list(as.character(colData(get(paste0("sce_", ref)))$x))
      )
      result = scmapCell_clusters$scmap_cluster_labs
      result_new = rbind(true_label = get(paste0("label_", test))[,1], pred_label = result[,1])
      write.csv(result_new, paste0("result_", ref, "_", test, ".csv"), row.names = TRUE)
      save(result_new, file = paste0("result_", ref, "_", test, ".RData"))
      rm(list = c(paste0("sce_", ref), paste0("sce_", test)))
      gc()
    }
  }
}

