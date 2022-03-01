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

[Annotation of 3k PBMCs](https://github.com/yuqcheng/scBalance/blob/main/Tutorial/scBalance%20Tuotrial_Annotation%20of%203k%20PBMCs.ipynb)

## Usage

The inputs of scBalance are two expression matrices and one label vector. 

```Python
import scBalance as sb
pred_result = sb.scBalance(test, reference, label, 'gpu')
```

in which 

- **test=The expression matrix of the sample to be annotated**,
- **reference=The expression matrix of the labeled dataset (reference set),** 
- **label = label vector (in pandas structure)**.

The label vector should be a n rows \* 1 column vector. For example,

<img src="https://github.com/yuqcheng/scBalance/blob/main/Tutorial/usage1.png" width=100/>

## Citation

