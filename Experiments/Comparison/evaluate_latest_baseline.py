#!/usr/bin/env python
# coding: utf-8

import numpy as np
import pandas as pd
import warnings
from sklearn.metrics import f1_score, accuracy_score, cohen_kappa_score

warnings.filterwarnings('ignore')


file_path = "C:/Users/Plus0/Desktop/Zhang Jianing/Intra/SingleR/results/Zheng 68k/"
n_folds = 5
pred_labels_all = []
true_labels_all = []
for i in range(n_folds):
    data = pd.read_csv(file_path + "result_block_" + str(i+1) + ".csv")
    result = data.values.tolist()

    pred_labels = result[0][1:]
    true_labels = result[1][1:]
    pred_labels_all.extend(pred_labels)
    true_labels_all.extend(true_labels)


macro_f1 = f1_score(true_labels_all, pred_labels_all, average = "macro")
micro_f1 = f1_score(true_labels_all, pred_labels_all, average = "micro")
weighted_f1 = f1_score(true_labels_all, pred_labels_all, average = "weighted")
acc = accuracy_score(true_labels_all, pred_labels_all)
cohen_kappa = cohen_kappa_score(true_labels_all, pred_labels_all)


print("Macro f1 is  ", macro_f1)
print("Micro f1 is  ", micro_f1)
print("Weighted f1 is  ", weighted_f1)
print("Accuracy is  ", acc)
print("Cohen Kappa is  ", cohen_kappa)
