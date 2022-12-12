# scBalance

## Introduction

scBalance, a dropout neural network-based classifier, provides a fast and accurate cell type identification for a new single-cell RNA-seq profile. By leveraging the newly designed neural network structure, scBalance especially obtains an outperformance on rare cell type annotation and robustness on batch effect. 

Notably, scBalance is the only tool that is highly compatible with Scanpy. Users can easily use it with the Anndata structure during the analysis. Instructions and examples are provided in the following tutorials.

## Requirement

- Scanpy (Compatible with all versions)
- Pytorch (With Cudatoolkit is recommanded)
- Numpy > 1.20
- Pandas > 1.2

## Installation

```Python
pip install scBalance
```

## Tutorial

- [Annotation of 3k PBMCs](https://github.com/yuqcheng/scBalance/blob/main/Tutorial/scBalance%20Tuotrial_Annotation%20of%203k%20PBMCs.ipynb)
- [Intra-dataset and Inter-dataset annotation](https://github.com/yuqcheng/scBalance/blob/main/Tutorial/Intradataset%26Interdataset_annotation_tutorial.ipynb)
- [Modeling saving and sampling method choosing](https://github.com/yuqcheng/scBalance/blob/main/Tutorial/Model%20saving%20and%20sampling%20method%20selection.ipynb)

## Usage

### 0. Data preprocessing

We design a ```Scanpy_Obj_IO``` module for users to preprocess the input data to the input format of the scBalance. The use of this module can be seen in the Tutorial [Annotation of 3k PBMCs](https://github.com/yuqcheng/scBalance/blob/main/Tutorial/scBalance%20Tuotrial_Annotation%20of%203k%20PBMCs.ipynb).

```Python
import scBalance.scbalance_IO as ss
ss.Scanpy_Obj_IO(test_obj=adata, ref_obj=train_adata, label_obj=train_label, scale = False)
```

For users who want to process by yourselve, please follow the Tutorial [Intra-dataset and Inter-dataset annotation](https://github.com/yuqcheng/scBalance/blob/main/Tutorial/Intradataset%26Interdataset_annotation_tutorial.ipynb).

### 1. The inputs of scBalance are two expression matrices and one label vector. 

```Python
import scBalance as sb
pred_result = sb.scBalance(test, reference, label, processing_unit, save_model, save_path, load_model, load_dict, weighted_sampling)
```

in which 

- **test=The expression matrix of the sample to be annotated**,
- **reference=The expression matrix of the labeled dataset (reference set),** 
- **label = label vector (in pandas structure)**,
- **processing_unit = 'cpu'(Default)/'gpu'**. If no changes, the default processor will be CPU. We highly recommend setting as 'gpu' if your server supports.
- **save_model="False(default)/True"**. The trained model and cell type dictionary will be downloaded for the further reuse. The save path will be your root path without specify.
- **save_path = [None(default)/str]**. Saving path will be specified here. Default is None and the model will be saved in your root path.
- **weighted_sampling = True(Default)/False**. For this parameter, you may choose whether to use our internal weighted sampling method. If you choose True, then the weighted sampling method is applied. If False, then no sampling in the training step. In this section, you may use external smapling method for your interest. For example, for users who are more interested in one specific cell type, we recommand [scSynO](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-021-04469-x) for the pre-sampling.

The label vector should be a n rows \* 1 column vector. For example,

<img src="https://github.com/yuqcheng/scBalance/blob/main/Tutorial/usage1.png" width=140/>

Column name can be anything.

### 2. Waiting for the progress bar to finish.

```
--------Start annotating----------
Computational unit be used is: cuda
100%[====================->]28.94s
--------Annotation Finished----------
```

## Citation
A scalable sparse neural network framework for rare cell type annotation of single-cell transcriptome data. Yuqi Cheng, Xingyu Fan, Jianing Zhang, Yu Li bioRxiv 2022.06.22.497193; doi: https://doi.org/10.1101/2022.06.22.497193
