# The output is a 2-row matrix, with each row representing 
# true_labels and predict_labels of one fold

setwd("C:/Users/Plus0/Desktop/data1/Baron Human")
Labels <- read.csv("Labels.csv", header = T)
n_folds = 5
cols = dim(Labels)[1]
rows_block = cols%/%n_folds

for (i in 0:(n_folds-1)){
  lower = rows_block*i+1
  upper = rows_block*(i+1)
  true_labels <- Labels[lower:upper, ]
  pred_labels_raw <- read.csv(paste0("result_block_", i+1, ".csv"), header = T, row.names = 1)
  pred_labels_index <- apply(pred_labels_raw, 2, which.max)
  pred_labels <- row.names(pred_labels_raw)[pred_labels_index]
  pred_labels <- pred_labels[1:length(true_labels)]
  
  result <- rbind(true_labels, pred_labels)
  write.csv(result, paste0("result_", i+1, ".csv"), row.names = TRUE)
}
