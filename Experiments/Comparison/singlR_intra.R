# Using 5_fold cross validation, read the expression matrix with their true labels, 
# then predict their labels and save the result in variable "result_test"
# The output, "result" is a 2-row matrix, with each row representing 
# true_labels and predict_labels of every fold
library(Seurat)
library(SingleR)
library(scRNAseq)
library(SingleCellExperiment)
library(Matrix)
setwd("C:/Users/Plus0/Desktop/data1/Baron Mouse")
raw_data <- read.csv("Filtered_TM_data.csv", header = T, row.names = 1)
data_matrix <- as(as.matrix(t(raw_data)), "dgCMatrix")
Labels <- read.csv("Labels.csv", header = T)
genes <- rownames(data_matrix)
rm(raw_data)
gc()

n_folds = 5
cols = dim(data_matrix)[2]
rows_block = cols%/%5

for (i in 0:4){
  lower = rows_block*i+1
  upper = rows_block*(i+1)
  test_data <- data_matrix[, lower:upper]
  test_labels <- Labels[lower:upper, 1]
  ref_data <- data_matrix[, c(1:lower, upper:cols)]
  ref_labels <- Labels[c(1:lower, upper:cols), 1]
  
  system.time(result_test <- SingleR(method = "single", test_data, ref_data, ref_labels, cluster = NULL))
  
  result_labels = result_test@listData[["first.labels"]]
  result <- rbind(true_labels = test_labels, pred_labels = result_labels)
  
  write.csv(result, paste0("result_block_", i+1, ".csv"), row.names = TRUE)
  save(result, file = paste0('result_block_', i+1, '.RData'))
}