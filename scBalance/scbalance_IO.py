import numpy as np
import pandas as pd
import scanpy as sc
from warnings import simplefilter

def Scanpy_Obj_IO(test_obj=None, ref_obj=None, label_obj=None, scale = False):
    '''

    :param test_obj: Input Anndata object for cell type annotation
    :param ref_obj: Input reference cell atlas, please note that an csv file required
    :param label_obj: (IF APPLICABLE) If the reference dataset is splited as expression matrix.csv and label.csv, input the label path
    :return: test_matrix (pd.dataframe) for annotation,
    ref_matrix (pd.dataframe) contain reference expression matrix,
    label (pd.dataframe) contain the label list.
    :scale: Whether to scale the reference dataset
    '''

    ref_adata = ref_obj
    # normallize and log reference dataset
    if label_obj is None:
        label = ref_adata[:, ref_adata.n_vars - 1].to_df()
        ref_adata = ref_adata[:, 0:ref_adata.n_vars - 1]

    else:
        label = label_obj

    sc.pp.normalize_total(ref_adata, target_sum=1e4)
    sc.pp.log1p(ref_adata)
    simplefilter(action='ignore', category=FutureWarning)
    gene = ref_adata.var_names & test_obj.var_names

    if 'log1p' in test_obj.uns:
        # test whether the dataset is in log format
        ref = ref_adata[:,gene]
        test_matrix = test_obj.to_df()[gene]
    else:
        sc.pp.log1p(test_obj)
        ref = ref_adata[:,gene]
        test_matrix = test_obj.to_df()[gene]

    if scale:
        sc.pp.scale(ref, max_value=10)
        ref_matrix = ref.to_df()
    else:
        ref_matrix = ref.to_df()


    return test_matrix, ref_matrix, label



def CSV_IO(csv_path:str = None, label_path:str = None, with_label:bool = True):

    '''

    :param csv_path: Input csv path to load expression matrix
    :param label_path: Input csv path to load label
    :param label: whether we have label (whether this is the reference)
    :return:
    '''
    #normalize the reference dataset
    adata = sc.read_csv(csv_path)
    sc.pp.normalize_total(adata, target_sum=1e4)
    sc.pp.log1p(adata)

    if with_label:
        #load label
        label = pd.read_csv(label_path)

        #turn to label matrix
        label.columns = ['Label']
        status_dict = label['Label'].unique().tolist()
        label['transfromed'] = label['Label'].apply(lambda x: status_dict.index(x))
        label_matrix = label['transfromed'].values

        count_matrix = adata.to_df()
        return count_matrix, label_matrix, status_dict

    else:
        count_matrix = adata.to_df()

        return count_matrix


