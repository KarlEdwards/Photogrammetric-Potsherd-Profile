critical_points <- function( data, delta ){
  # Examine the slope of the segment defined by pairs of
  # consecutive points (A and B), which are separated by
  # a distance of at least delta. Identify relative minima
  # and maxima.
  N         <- nrow( data )

  y         <- vector( mode = 'numeric', length = 0)
  z         <- vector( mode = 'numeric', length = 0)
  m         <- vector( mode = 'numeric', length = 0)
  d         <- vector( mode = 'character', length = 0)

  i         <- 1           # first row of results
  point_A   <- 1           # begin with the first point in the data
  point_B   <- 1 + point_A # try the next point
  direction <- 'unknown'   # until the first segment is analyzed, direction is unknown
  base_x    <- data[ 1, 1 ]
  base_y    <- data[ 1, 2 ]

  # Find the distance along the artifact axis of rotation between A and B
  delta_y   <- function() data[ point_B , 1 ] - data[ point_A, 1 ]

  # Find the distance along the artifact radius between A and B
  delta_z   <- function() data[ point_B , 2 ] - data[ point_A, 2 ]

  # Keep going until the last point has been examined
  more_rows <- function() point_B < N

  # Return rise / run, unless run is zero or rise is insignificant 
  slope <- function(){
    ifelse(
      ( ( abs( delta_z() ) < delta ) | delta_y() == 0 )
      , NA
      , delta_z() / delta_y()
    )
  }

  set_direction <- function(){
    if( abs( delta_z() ) < delta ){
      direction <<- 'flat'
    } else {
      # translate sign ( 1 or -1 ) into TRUE/FALSE
      up <- 1 + sign( slope() )
      direction <<- switch( direction
        , unknown          = ifelse( up, 'rising'        , 'falling'        )
        , flat             = ifelse( up, 'rising'        , 'falling'        )
        , falling          = ifelse( up, 'ridge'       , 'falling'        )
        , rising           = ifelse( up, 'rising'        , 'groove'        )
        , groove          = ifelse( up, 'rising'        , 'shoulder_left'  )
        , ridge          = ifelse( up, 'shoulder_right', 'falling'        )
        , shoulder_right   = ifelse( up, 'rising'        , 'falling'        )
        , shoulder_left    = ifelse( up, 'rising'        , 'falling'        )
        , 'other'
      ) # end switch
    }
  }

  while( more_rows() ){

    while( ( abs( delta_z() ) < delta ) & more_rows() ) point_B <- point_B + 1

    if( abs( delta_z() ) >= delta ){
      EMPIRICALLY_DETERMINED_MAGIC_NUMBER <- 0.25  # Why not 0.5 * distance between points, i.e., mean?
      y[ i ] <- data[ point_A, 1 ] + EMPIRICALLY_DETERMINED_MAGIC_NUMBER * ( data[ point_B, 1 ] - data[ point_A, 1 ] )
      z[ i ] <- data[ point_A, 2 ] - EMPIRICALLY_DETERMINED_MAGIC_NUMBER * ( data[ point_B, 2 ] - data[ point_A, 2 ] )
##      y[ i ] <- data[ point_A, 1 ]
##      z[ i ] <- data[ point_A, 2 ]
      m[ i ] <- slope()
      d[ i ] <- set_direction()

      point_A <- point_B
      point_B <- point_A + 1
      i <- i + 1
    }
  } #end while

  # return result
##  results <- do.call( rbind, results )
##  colnames( results ) <- c( 'y', 'z', 'slope', 'direction' )
##  as.tibble( results )
  data.frame( y = y, z = z, slope = m, direction = d )
}
