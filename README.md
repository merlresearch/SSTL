<!--
Copyright (C) 2018,2023 Mitsubishi Electric Research Laboratories (MERL)

SPDX-License-Identifier: AGPL-3.0-or-later
-->
# Semi-Supervised Transfer Learning Using Marginal Predictors

## Summary

Successful state-of-the-art machine learning techniques rely on the existence of large well sampled and labeled datasets. Today it is easy to obtain a finely sampled dataset because of the decreasing cost of connected low-energy devices. However, it is often difficult to obtain a large number of labels. The reason for this is two-fold. First, labels are often provided by people whose attention span is limited. Second, even if a person was able to label perpetually, this person would need to be shown data in a large variety of conditions. One approach to addressing these problems is to combine labeled data collected in different sessions through transfer learning. Still even this approach suffers from dataset limitations.

This code allows the use of unlabeled data to improve transfer learning in the case where: the training and testing datasets are drawn from similar probability distributions; and the unlabeled data in each dataset can be described by similar underlying manifolds. The code implements a distribution free, kernel and graph Laplacian-based approach which optimizes empirical risk in the appropriate reproducing kernel Hilbert space. The approach presented in this code was published in the 2018 IEEE Data Science workshop in a paper titled "Semi-Supervised Transfer Learning Using Marginal Predictors".

## Usage

Steps to run the code -

1)    Add ./datasets folder in the path
2)    Download LapSVM package and add ./lapsvmp_v02 folder in the path
3)    Run LapSVMTL to get results on synthetic data (classification) and LapSVMRTL on Parkinson's data (regression)
4)    Take the mean of 20 x 10 matrix generated at step 4 to get results for "Semisupervised Learning using Marginal Predictors".

Files -
1)    LapSVMTL is built on the LapSVM package. For more details on this package, visit - http://www.dii.unisi.it/~melacci/lapsvmp/ [1].

2)    For comparison with pooling and transfer learning (LMP) we use the fast implementation at https://github.com/aniketde/DomainGeneralizationMarginal [2].

3)    Synthetic dataset is created using twospirals.m which is called by SpiralSyntheticData100. For more details on how this synthetic data is created, visit - https://www.mathworks.com/matlabcentral/fileexchange/41459-6-functions-for-generating-artificial-datasets.

4)    Parkinson's telemonitoring dataset is downloaded from https://archive.ics.uci.edu/ml/datasets/parkinsons+telemonitoring [3].

References -

[1] Melacci, Stefano, and Mikhail Belkin. "Laplacian support vector machines trained in the primal." Journal of Machine Learning Research 12, no. Mar (2011): 1149-1184.

[2] Blanchard, Gilles, Aniket Anand Deshmukh, Urun Dogan, Gyemin Lee, and Clayton Scott. "Domain Generalization by Marginal Transfer Learning." arXiv preprint arXiv:1711.07910 (2017).

[3] A Tsanas, MA Little, PE McSharry, LO Ramig (2009) 'Accurate telemonitoring of Parkinson’s disease progression by non-invasive speech tests', IEEE Transactions on Biomedical Engineering (to appear).

## Citation

If you use the software, please cite the following  ([MERL TR2018-040](https://merl.com/publications/TR2018-040)):

```
@inproceedings{Deshmukh2018jun,
author = {Deshmukh, Aniket and Laftchiev, Emil},
title = {Semi-Supervised Transfer Learning Using Marginal Predictors},
booktitle = {IEEE Data Science Workshop},
year = 2018,
pages = {160--164},
month = jun,
doi = {10.1109/DSW.2018.8439908},
url = {https://www.merl.com/publications/TR2018-040}
}
```

## Contact
Daniel Nikovski <nikovski@merl.com>

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for our policy on contributions.

## License

Released under `AGPL-3.0-or-later` license, as found in the [LICENSE.md](LICENSE.md) file.

All files:

```
Copyright (c) 2018,2023 Mitsubishi Electric Research Laboratories (MERL).

SPDX-License-Identifier: AGPL-3.0-or-later
```
