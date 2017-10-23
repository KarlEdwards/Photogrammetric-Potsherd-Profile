#+ profile_to_wireframe, echo = TRUE
require( purrr )
require( rgl )

profile_to_wireframe <- function( profile, every_n_degrees ){
  stopifnot( is.matrix( profile ))
  stopifnot( dim( profile )[ 2 ] == 3 )

  extents <- max(
      max( apply( profile, 2, max ))
    , min( apply( profile, 2, min ))
  ) %>% ceiling

  limits <- c( -extents, extents )

  clear3d()
  plot3d( profile, xlim=limits, ylim=limits, zlim=limits )

  seq( 0, 360, every_n_degrees ) %>%
    walk(
      ~points3d(
        rotate3d(
            profile
          , .x *pi/180
          , x=0
          , y=1
          , z=0
        )
      )
    )

}

## EXAMPLE
## x <- seq( 0, 1, length.out=10 )
## x %>% map_dbl( ~.x^3 ) -> y
## z <- rep( 0, length( x ))
## profile <- matrix( c( x, y, z ), ncol = 3 )
## profile_to_wireframe( profile, 15 )
