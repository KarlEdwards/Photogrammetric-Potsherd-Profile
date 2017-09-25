Potsherd Photogrammetry
================
Karl Edwards
September 20, 2017

-   [Overview](#overview)
-   [Project-Specific Configuration](#project-specific-configuration)
-   [Load Libraries](#load-libraries)

Overview
--------

-   Read model data from .STL file
-   Align the model with the axes and scoot it up against x = y = z = 0
-   Plot the profile
-   Estimate key dimensions

Project-Specific Configuration
------------------------------

``` r
filename <- 'stereolithograph.stl'

# Convenient names to improve readability
x_axis <- 1
y_axis <- 2
z_axis <- 3
axes <- 1:3
axes[ x_axis ] <- 'x'
axes[ y_axis ] <- 'y'
axes[ z_axis ] <- 'z'

# Wireframe parameters
stripe_width <- 0.0003
stripe_tol   <- 0.00003
```

Load Libraries
--------------

``` r
# General
require( rgl )
```

    ## Loading required package: rgl

``` r
require( ggplot2 )
```

    ## Loading required package: ggplot2

``` r
require( gridExtra )
```

    ## Loading required package: gridExtra

``` r
require( purrr )
```

    ## Loading required package: purrr

``` r
require( tibble )
```

    ## Loading required package: tibble

``` r
require( lattice )
```

    ## Loading required package: lattice
