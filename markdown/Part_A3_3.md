
# Computer-Assisted Potsherd Classification

#### [Top](../README.md)

Find the center of the base, i.e., axis of rotation
---------------------------------------------------

#### Retrieve Saved Perimeter Data

``` r
perimeter_data <- readRDS( PERIMETER_FILE )
```

#### Plot perimeter data

<img src="./images/perimeter_data.png" width="350" >

#### Estimate the center

``` r
# Estimate the center for a given height
# by choosing two points along the perimeter of the pot
# and finding the intersection of
# the radii passing through the points.
```

``` r
find_center <- function( p, h ){

  # Extract perimeter points at height, h
  perimeter <- p[ p[ , 'height' ] == h, c( 'perimeter_x', 'perimeter_y' ) ]
 
  # Default results: 
  # If not enough points, return the height only,
  # setting all other items to NA
  result <- data.frame(
    h = h, ctrX = NA, ctrY = NA, r = NA, N = NA
  )

  # If an insufficient number of perimeter points exist at height, h, return result unknown,
  # otherwise, find the center and radius
  if( nrow( perimeter ) > 2 ){
  
    # Calculate the slope of each segment defined by each consecutive pair of perimeter points
    delta_y <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, Y_AXIS ] - perimeter[ .x-1, Y_AXIS ] )
    delta_x <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, X_AXIS ] - perimeter[ .x-1, X_AXIS ] )
    slopes <- delta_y / delta_x

    N <- length( slopes )
    if( N > 3 ){
      pointA_index <- 1
      pointB_index <- N
      ray1 <- get_perpendicular2D( m = slopes[ pointA_index ], P = perimeter[ pointA_index + 1, ] )
      ray2 <- get_perpendicular2D( m = slopes[ pointB_index ], P = perimeter[ pointB_index - 1, ] )
      est_ctr <- get_intersection2D( ray1, ray2 )
      est_radius <- euclidean_distance( est_ctr, perimeter[ pointB_index, ] )

    # Prepare to return the results
    result <- data.frame(
      h = h, ctrX = est_ctr$x, ctrY = est_ctr$y, r = est_radius, N = N
    )
  }
    }

  # Round the results
  lapply( result[ complete.cases( result ), ], round, 2 )
}

WIREFRAME_HEIGHTS %>% map_df( ~find_center( perimeter_data, . )) -> radii
radii
```

    ## # A tibble: 9 x 5
    ##       h  ctrX  ctrY     r     N
    ##   <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1  0.10  0.49  0.67  0.57     6
    ## 2  0.15  0.33  0.21  0.30     8
    ## 3  0.20  0.32  0.32  0.44    11
    ## 4  0.25  0.62  1.07  1.00    12
    ## 5  0.30  0.57  0.92  0.85    12
    ## 6  0.35  0.86  2.01  1.93    12
    ## 7  0.40  0.64  1.23  1.22    12
    ## 8  0.45  0.62  0.95  0.96    12
    ## 9  0.50  0.56  0.49  0.51    12

``` r
saveRDS( file = 'radii.RDS', radii )
```

#### [Top](../README.md)
