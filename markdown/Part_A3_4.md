
# Computer-Assisted Potsherd Classification

#### [Top](../README.md)

#### Get data from previous step

``` r
radii   <- readRDS( file = 'radii.RDS' )
medians <- radii %>% map_dbl( ~median( . ))
center  <- medians[ 2:3 ]
model   <- make_model( readRDS( MODEL_FILE ) )
vp      <- viewpoint( list( theta = 15, phi = 10, fov = 0, zoom = 0.75 ))
best_x  <- best_slice( model$get(), X_AXIS )
best_x
```

    ## [1] 0.275

``` r
model$get_band( ax = X_AXIS, ctr = best_x, thickness =  1.8 * STRIPE_WIDTH )
model$show( LEFT_VIEW )
make_figure( 'band_1' )
```

<img src="./images/band_1.png" width="400">

``` r
model_data        <- model$get()
histogram_buckets <- model_data[ , 'x'] %>% hist( plot = FALSE )
best_mid          <- as.list( histogram_buckets )[[ 'mids' ]][ which.max( histogram_buckets$counts ) ]
thin_slice        <- as.data.frame( get_band( model_data, 1, best_mid ))

ggplot( thin_slice, aes( x = z, y = y )) +
  geom_point()   +
  xlim( 0, 0.6 ) +
  ylim( 0, 0.6 )
```

![](Part_A3_4_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-1-1.png)

``` r
df <- thin_slice[ ,c( 'y', 'z' ) ]
df <- unique( df[ order( df[ , 'y' ] ), ] )
df <- df[ df[ ,'y' ] > 0.1 & df[ , 'y' ] < 0.6, ]
plot( df )
```

![](Part_A3_4_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-1-2.png)

``` r
extrema <- critical_points( df, 0.001 )
extrema <- extrema[ !extrema[ ,4 ] %in% c( 'rising', 'falling' ), ]
extrema
```

    ##      y         z          slope       direction
    ## [1,] 0.1557411 0.1406569  0.07167859  "minimum"
    ## [2,] 0.2370778 0.1564948  -0.07729668 "maximum"
    ## [3,] 0.2718609 0.1424539  0.1297551   "minimum"
    ## [4,] 0.3336196 0.1626891  -0.09773631 "maximum"
    ## [5,] 0.4746265 0.06772798 0.1090784   "minimum"

#### Square the model in the reference frame

``` r
offset <- apply( model$get(), 2, min )      # Find the distance from each axis to the nearest model point
model$move_left(     offset[ 'x' ] )        # Remove the offset, effectively pushing the object
model$move_down(     offset[ 'y' ] )        # into the corner
model$move_backward( offset[ 'z' ] )
model$show( LEFT_VIEW )
```

#### Flip profile

``` r
# move z-width backward, then rotate about y
offset <- apply( model$get(), 2, max ) 
model$move_backward( offset[ 'z' ] )
model$show( TOP_VIEW_A )
model$rotate_about_y( 90 )
model$show( LEFT_VIEW )
model$show( FRONT_VIEW )
model$move_right( medians[ 'r' ] )
model$show( FRONT_VIEW )
model$scale_it( SCALE_FACTOR )
model$show( FRONT_VIEW, limits=c( -SCALE_FACTOR, SCALE_FACTOR ))
profile_to_wireframe( model$get(), 3 )
```

#### Make figures

``` r
make_figure( 'band_3' )
```

<img src="./images/band_3.png" width="400">

``` r
adjust( vp, 'theta', 15 )
adjust( vp, 'phi', 10 )
make_figure( 'wireframe' )
```

<img src="./images/wireframe.png" width="400">

``` r
adjust( vp, 'theta', 90 )
adjust( vp, 'phi', 0 )
make_figure( 'wireframe_side' )
```

<img src="./images/wireframe_side.png" width="400">

``` r
adjust( vp, 'theta', 90 )
adjust( vp, 'phi', 90 )
make_figure( 'wireframe_top' )
```

<img src="./images/wireframe_top.png" width="400">
<br>

References
----------

The style for this document has been adapted from http://stat545.com/bit006\_github-browsability-wins.html\#source-code

#### [Top](../README.md)
