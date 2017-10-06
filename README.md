---
title: "Computer-Assisted Potsherd Classification"
output:
  html_document:
   toc: true
   highlight: tango
   css: styles.css
---
## How archaeologists can use photogrammetry and machine learning to efficiently classify a large number of potsherds

### A. Data Acquisition
1. [Photography](./markdown/Part_A1.md)
2. [Three-Dimensional Model](./markdown/Part_A2.md)
3. [Process Stereolithography](./markdown/step1.md) - - - Clean [source](./R/step1.R)
4. [Estimate the radius at several elevations](./markdown/step2.md) - - - Clean [source](./R/step2.R)
5. [Extract perimeter points at various heights](./markdown/step3.md) - - - Clean [source](./R/step3.R)
6. [Create a wireframe model](./markdown/step4.md) - - - Clean [source](./R/step4.R)
7. Measurement
8. Feature Matrix **X**

### B. Unsupervised Clustering
1. Feature Definition
2. Feature Similarity
3. Pairwise Object Similarity

### C. Semi-Supervised Feature Selection
1. Feature Weight Computation
2. Provisional Prototypes
3. Dimensionality Reduction

### D. Supervised Provisional Classification
1. CART
2. ID3
3. C4.5
