# Using 5_fold cross validation, read the expression matrix with their true labels, 
# then predict their labels and save the result in variable "classRes_val_all"
# The output is the predict_labels of every fold
library(singleCellNet)
library(Matrix)
setwd("C:/Users/Plus0/Desktop/data1/Baron Human")
raw_data <- read.csv("Filtered_Baron_HumanPancreas_data.csv", header = T, row.names = 1)
Labels <- read.csv("Labels.csv", header = T)

data_matrix <- as(as.matrix(t(raw_data)), "dgCMatrix")
genes <- rownames(data_matrix)
rm(raw_data)
gc()

n_folds = 5
cols = dim(data_matrix)[2]
rows_block = cols%/%n_folds

#stTrain is a dataframe that matches the samples with category
for (i in 0:(n_folds-1)){
  lower = rows_block*i+1
  upper = rows_block*(i+1)
  test_data <- data_matrix[, lower:upper]
  test_label <- Labels[lower:upper, 1]
  ref_data <- data_matrix[, c(1:lower, upper:cols)]
  ref_labels <- Labels[c(1:lower, upper:cols), 1]
  stTrain <- data.frame(colnames(ref_data), ref_labels)
  names(stTrain) = c("cell", "cluster_ids")
  row.names(stTrain) <- colnames(ref_data)
  
  system.time(class_info <- scn_train(stTrain = stTrain, expTrain = ref_data, 
                                    dLevel = "cluster_ids", colName_samp = "cell"))
  classRes_val_all <- scn_predict(cnProc = class_info[['cnProc']], expDat = test_data)
  
  save(class_info, classRes_val_all, file = paste0("result_block_", i+1, ".RData"))
  write.csv(classRes_val_all, paste0("result_block_", i+1, ".csv"), row.names = TRUE)
}

