Computer-Assisted Potsherd Classification
================
Karl Edwards

-   [A. Data Acquisition](#a.-data-acquisition)
-   [B. Unsupervised Clustering](#b.-unsupervised-clustering)
-   [C. Semi-Supervised Feature Selection](#c.-semi-supervised-feature-selection)
-   [D. Supervised Provisional Classification](#d.-supervised-provisional-classification)

#### A. Data Acquisition

1.  [Photography](./markdown/Part_A1.md)
2.  [Three-Dimensional Model](./markdown/Part_A2.md)
3.  Pre-Process

    3.1 [Process Stereolithography](./markdown/Part_A3_1.md) ................................................... [source](./R/Part_A3_1.R)

    3.2 [Estimate the radius at several elevations](./markdown/Part_A3_2.md) ............................. [source](./R/Part_A3_2.R)

    3.3 [Extract perimeter points at various heights](./markdown/Part_A3_3.md) ......................... [source](./R/Part_A3_3.R)

    3.4 [Create a wireframe model](./markdown/Part_A3_4.md) .................................................... [source](./R/Part_A3_4.R)

4.  Measurement
5.  Feature Matrix **X**

#### B. Unsupervised Clustering

1.  Feature Definition
2.  Feature Similarity
3.  Pairwise Object Similarity

#### C. Semi-Supervised Feature Selection

1.  Feature Weight Computation
2.  Provisional Prototypes
3.  Dimensionality Reduction

#### D. Supervised Provisional Classification

1.  CART
2.  ID3
3.  C4.5
