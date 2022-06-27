library(Seurat)
library(SingleR)
library(scRNAseq)
library(SingleCellExperiment)
library(Matrix)
library(plyr)
memory.limit(50000)
setwd("C:/Users/Plus0/Desktop/Inter-dataset/PbmcBench")

rm(list=ls())
gc()
load("matrix_data.RData")
load("labels.RData")

for (ref in c("inDrop")){
  for(test in c("10Xv2", "10Xv3", "CEL_Seq", "Drop_Seq","inDrop", "Seq_Well", "Smart_Seq2")){
    if(ref != test){
      print(paste0(ref,"---->", test))
      ref_data <- get(paste0("matrix_", ref))
      ref_labels <- get(paste0("label_", ref))[,1]
      test_data <- get(paste0("matrix_", test))
      test_labels <- get(paste0("label_", test))[,1]
      
      print("Running...")
      system.time(result_test <- SingleR(method = "single", test_data, ref_data, ref_labels, clusters = NULL))
      print("Done")
      
      result_labels <- result_test@listData[["first.labels"]]
      result <- rbind(true_label = test_labels, pred_label = result_labels)
      
      write.csv(result, paste0("result_", ref, "_", test, ".csv"), row.names = TRUE)
      save(result, file = paste0("result_", ref, "_", test, ".RData"))
    }
  }
}
