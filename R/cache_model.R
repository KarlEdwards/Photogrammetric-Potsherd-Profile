#' A caching Function
#'
#' Create a model matrix, which is really a list, containing functions to...
#' * move the model
#' * rotate the model
#'
#' @param model_data numeric vector contents.
#' @keywords caching
#' @examples model <- make_model( list( theta=-90, phi=-2, fov=25, zoom=1 ) )
#' @export

#+ cache_model, echo = TRUE
make_model <- function( model_data ){
  cache       <- NULL                                         # Begin with an empty model
  get         <- function() name_axes( model_data )           # Return the model data
  cache_it    <- function( model_data ) cache <<- model_data  # Cache the model data
  data_length <- function() cache                             # Determine the length of the model data matrix
  tilt_up     <- function( angle ){
    model_data <<- rotate3d( model_data, angle * pi / 180, 1, 0, 0 )
  }
  rotate_about_x     <- function( angle ){
    model_data <<- rotate3d( model_data, angle * pi / 180, 1, 0, 0 )
  }
  rotate_about_y     <- function( angle ){
    model_data <<- rotate3d( model_data, angle * pi / 180, 0, 1, 0 )
  }
  rotate_about_z     <- function( angle ){
    model_data <<- rotate3d( model_data, angle * pi / 180, 0, 0, 1 )
  }
  move_up     <- function( distance ){
    model_data[ ,2 ] <<- model_data[ ,2 ] + distance
  }
  move_down   <- function( distance ){
    model_data[ ,2 ] <<- model_data[ ,2 ] - distance
  }
  move_right     <- function( distance ){
    model_data[ ,1 ] <<- model_data[ ,1 ] + distance
  }
  move_left   <- function( distance ){
    model_data[ ,1 ] <<- model_data[ ,1 ] - distance
  }
  move_forward     <- function( distance ){
    model_data[ ,3 ] <<- model_data[ ,3 ] + distance
  }
  move_backward   <- function( distance ){
    model_data[ ,3 ] <<- model_data[ ,3 ] - distance
  }
  scale_it        <- function( scale_factor ){
    model_data[ ,1 ] <<- scale_factor * model_data[ ,1 ]
    model_data[ ,2 ] <<- scale_factor * model_data[ ,2 ]
    model_data[ ,3 ] <<- scale_factor * model_data[ ,3 ]
  }
  
  # Cut off the top/bottom, front/back, or left/right sides of the model
  clip_at <- function( ax=1, mn=0.3, mx=0.6 ){
    model_data <<- model_data[ model_data[ ,ax ] > mn & model_data[ ,ax ] < mx, ]
  }

  # Clip a thin band out of the middle, and keep that portion that was removed
  get_band        <- function( ax, ctr, thickness ){
    mn <- ctr - 0.5 * thickness
    mx <- ctr + 0.5 * thickness
    model_data <<- model_data[ model_data[ ,ax ] > mn & model_data[ ,ax ] < mx, ]
  }
  show         <- function( config, limits=c(0,1) ){
    clear3d()
    plot3d( name_axes( model_data ), xlim = limits , ylim = limits , zlim = limits )
    view( config )
    background( 'white' )
  }

  # Return the list of functions
  list(
      move_up = move_up
    , move_down = move_down
    , move_right = move_right
    , move_left = move_left
    , move_forward = move_forward
    , move_backward = move_backward
    , scale_it = scale_it
    , tilt_up = tilt_up
    , rotate_about_x = rotate_about_x
    , rotate_about_y = rotate_about_y
    , rotate_about_z = rotate_about_z
    , get = get
    , cache_it = cache_it
    , data_length = data_length
    , clip_at = clip_at
    , get_band = get_band
    , show = show
  )
}

#' A caching Function
#'
#' Create a model, or update it if it exists already.
#'
#' @param model_data numeric vector contents. triple dot.
#' @keywords caching
#' @examples model <- cache_model( model )
#' @export

cache_model <- function( model_data, ... ){
  # Given the data, see if its length has already been determined
  cache <- model_data$data_length()
  
  # If so...
  if( !is.null( cache )){
    message( "getting cached data" ) # Announce use of cached data 
    cache                            # Return the length of the model_data matrix
  }
  
  # Otherwise...
  data <- model_data$get()           # Get the model_data
  cache <- length( data, ... )       # cache the model_data
  model_data$cache_it( cache )       # Remember the model_data
  cache                              # Return the cached model_data
}

# Examples
# model <- NULL
# model <- make_model( readSTL( filename, plot=FALSE ) )
# model_matrix <- model$get()
# cache_model( model )
# print( model$data_length())
# model$data_length()
# model$move_up( 0.25 )
# model$move_down( 0.25 )
# model$move_left( 0.25 )
# model$move_right( 0.25 )
# model$move_forward( 0.25 )
# model$move_backward( 0.25 )
