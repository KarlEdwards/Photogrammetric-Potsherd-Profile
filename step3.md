
Find the center of the base, i.e., axis of rotation
---------------------------------------------------

#### Retrieve Saved Perimeter Data

``` r
perimeter_data <- readRDS( PERIMETER_FILE )
```

#### Plot perimeter data

``` r
ggplot( perimeter_data, aes( x = perimeter_x, y = perimeter_y, color = height )) +
  geom_point() +
  xlim( 0, 1 ) +
  ylim( 0, 1 )
```

![](step3_files/figure-markdown_github-ascii_identifiers/plot_perimeter_data-1.png)

#### Choose two points along the perimeter of the pot at the selected height(s)

``` r
# Choose a height, from which to estimate the axis of rotation
selected_height_index <- 4 # length( heights )

find_center <- function( p, h ){

  # Extract perimeter points at height, h
  perimeter <- p[ p[ , 'height' ] == h, c( 'perimeter_x', 'perimeter_y' ) ]
  
  # If an insufficient number of perimeter points exist at height, h, return result unknown,
  # otherwise, find the center and radius
  if( nrow( perimeter ) > 2 ){
  
    # Calculate the slope of each segment defined by each consecutive pair of perimeter points
    delta_y <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, Y_AXIS ] - perimeter[ .x-1, Y_AXIS ] )
    delta_x <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, X_AXIS ] - perimeter[ .x-1, X_AXIS ] )
    slopes <- delta_y / delta_x
    slopes
    N <- length( slopes )
    ray1 <- get_perpendicular2D( m = slopes[ 1 ], P = perimeter_points[ 2, ] )
    ray2 <- get_perpendicular2D( m = slopes[ N ], P = perimeter_points[ N-1, ] )
    est_ctr <- get_intersection2D( ray1, ray2 )
    est_radius <- euclidean_distance( est_ctr, perimeter_points[ 2, ] )
    result <- data.frame(
      h = h, ctrX = est_ctr$x, ctrY = est_ctr$y, r = est_radius
    )
  } else {
    result <- data.frame(
      h = h, ctrX = NA, ctrY = NA, r = NA
    )
  }
  lapply( result[ complete.cases( result ), ], round, 2 )
}

heights %>% map_df( ~find_center( perimeter_data, . )) -> radii
radii
```

    ## # A tibble: 9 x 4
    ##       h  ctrX  ctrY     r
    ##   <dbl> <dbl> <dbl> <dbl>
    ## 1  0.10  0.44  0.68  0.56
    ## 2  0.15  0.28  0.23  0.08
    ## 3  0.20  0.32  0.31  0.17
    ## 4  0.25  0.62  1.07  0.99
    ## 5  0.30  0.57  0.90  0.82
    ## 6  0.35  0.86  2.00  1.94
    ## 7  0.40  0.64  1.29  1.20
    ## 8  0.45  0.61  1.03  0.95
    ## 9  0.50  0.56  0.55  0.50

``` r
saveRDS( file = 'radii.RDS', radii )
```

<br>

References
----------

The style for this document has been adapted from <http://stat545.com/bit006_github-browsability-wins.html#source-code> \#\# References

Bryan, Jenny. 2017. “Happy Git and Github for the UseR.” http://happygitwithr.com.

consortium, 3D-COFORM. 2013. “ARC 3D Webservice.” http://www.3d-coform.eu/index.php/tools/arc-3d-webservice.

Strayer, Nick, and Lucy D’Agostino McGowan. 2016. “How to Make an Rmarkdown Website.” http://nickstrayer.me/RMarkdown\_Sites\_tutorial/.
