Computer-Assisted Potsherd Classification
================
Karl Edwards

-   [A. Data Acquisition](#a.-data-acquisition)
    -   [1. [Photography](./markdown/Part_A1.md)](#photography)
    -   [2. [Three-Dimensional Model](./markdown/Part_A2.md)](#three-dimensional-model)
    -   [3. Pre-Process](#pre-process)
    -   [4. Measurement](#measurement)
    -   [5. Feature Matrix **X**](#feature-matrix-x)
-   [B. Unsupervised Clustering](#b.-unsupervised-clustering)
    -   [1. Feature Definition](#feature-definition)
    -   [2. Feature Similarity](#feature-similarity)
    -   [3. Pairwise Object Similarity](#pairwise-object-similarity)
-   [C. Semi-Supervised Feature Selection](#c.-semi-supervised-feature-selection)
    -   [1. Feature Weight Computation](#feature-weight-computation)
    -   [2. Provisional Prototypes](#provisional-prototypes)
    -   [3. Dimensionality Reduction](#dimensionality-reduction)
-   [D. Supervised Provisional Classification](#d.-supervised-provisional-classification)
    -   [1. CART](#cart)
    -   [2. ID3](#id3)
    -   [3. C4.5](#c4.5)

A. Data Acquisition
===================

1. [Photography](./markdown/Part_A1.md)
---------------------------------------

2. [Three-Dimensional Model](./markdown/Part_A2.md)
---------------------------------------------------

3. Pre-Process
--------------

    3.1 [Process Stereolithography](./markdown/Part_A3_1.md)        ................................................... [source](./R/Part_A3_1.R)

    3.2 [Estimate the radius at several elevations](./markdown/Part_A3_2.md)        ............................. [source](./R/Part_A3_2.R)

    3.3 [Extract perimeter points at various heights](./markdown/Part_A3_3.md)        ......................... [source](./R/Part_A3_3.R)

    3.4 [Create a wireframe model](./markdown/Part_A3_4.md)        .................................................... [source](./R/Part_A3_4.R)

4. Measurement
--------------

5. Feature Matrix **X**
-----------------------

B. Unsupervised Clustering
==========================

1. Feature Definition
---------------------

2. Feature Similarity
---------------------

3. Pairwise Object Similarity
-----------------------------

C. Semi-Supervised Feature Selection
====================================

1. Feature Weight Computation
-----------------------------

2. Provisional Prototypes
-------------------------

3. Dimensionality Reduction
---------------------------

D. Supervised Provisional Classification
========================================

1. CART
-------

2. ID3
------

3. C4.5
-------
