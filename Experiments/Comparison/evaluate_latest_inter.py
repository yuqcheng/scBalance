#!/usr/bin/env python
# coding: utf-8

import numpy as np
import pandas as pd
import warnings
from sklearn.metrics import f1_score, accuracy_score, cohen_kappa_score

warnings.filterwarnings('ignore')


file_path = "C:/Users/Plus0/Desktop/Zhang Jianing/Inter/SingleCellNet/result/predicted_labels/"
ref_all = ["10Xv2", "10Xv3", "CEL_Seq", "Drop_Seq","inDrop", "Seq_Well", "Smart_Seq2"]
test_all = ["10Xv2", "10Xv3", "CEL_Seq", "Drop_Seq","inDrop", "Seq_Well", "Smart_Seq2"]
macro_f1_all = np.zeros((7,7))
micro_f1_all = np.zeros((7,7))
weighted_f1_all = np.zeros((7,7))
acc_all = np.zeros((7,7))
cohen_kappa_all = np.zeros((7,7))

for ref in ref_all:
    for test in test_all:
        if ref != test:
            i = ref_all.index(ref)
            j = ref_all.index(test)
            print(ref, "--->", test)
            data = pd.read_csv(file_path + "result_" + ref + "_" + test + ".csv")
            result = data.values.tolist()

            pred_labels = result[1][1:]
            true_labels = result[0][1:]
            names = set(true_labels)|set(pred_labels)
            
            macro_f1 = f1_score(true_labels, pred_labels, average = "macro")
            macro_f1_all[i][j] = macro_f1
            micro_f1 = f1_score(true_labels, pred_labels, average = "micro")
            micro_f1_all[i][j] = micro_f1
            weighted_f1 = f1_score(true_labels, pred_labels, average = "weighted")
            weighted_f1_all[i][j] = weighted_f1
            acc = accuracy_score(true_labels, pred_labels)
            acc_all[i][j] = acc
            cohen_kappa = cohen_kappa_score(true_labels, pred_labels)
            cohen_kappa_all[i][j] = cohen_kappa

df = pd.DataFrame(macro_f1_all)
df.columns = ref_all
df.index = ref_all           
df.to_csv(file_path + "macro_f1.csv", index= True)
df = pd.DataFrame(micro_f1_all)
df.columns = ref_all
df.index = ref_all           
df.to_csv(file_path + "micro_f1.csv", index= True)
df = pd.DataFrame(weighted_f1_all)
df.columns = ref_all
df.index = ref_all           
df.to_csv(file_path + "weighted_f1.csv", index= True)
df = pd.DataFrame(acc_all)
df.columns = ref_all
df.index = ref_all           
df.to_csv(file_path + "accuracy.csv", index= True)
df = pd.DataFrame(cohen_kappa_all)
df.columns = ref_all
df.index = ref_all           
df.to_csv(file_path + "cohen_kappa.csv", index= True)
