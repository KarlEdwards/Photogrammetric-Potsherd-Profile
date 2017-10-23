#' A caching Function
#'
#' Create a viewpoint configuration, containing functions to...
#' * set the value of specific viewpoint parameters
#' * get the value of those parameters
#'
#' @param params numeric vector contents.
#' @keywords caching
#' @examples vp <- viewpoint( list( theta=-90, phi=-2, fov=25, zoom=1 ) )
#' @export

viewpoint <- function( params = list() ){
  cache <- NULL                             # Begin with unknown viewpoint parameters

  get <- function() params                  # Return the parameters
  count <- function( params ) cache <<- params
  num_params <- function() cache
  set <- function( id, value ){             # Set new parameters
  params[[ id ]] <<- value
  params
  }

  # Return the list of functions
  list(
      set = set
    , get = get
    , count = count
    , num_params = num_params
  )
}

#' A caching Function
#'
#' Create a viewpoint, or update it if it exists already.
#'
#' @param params numeric vector contents. triple dot.
#' @keywords caching
#' @examples vp <- cache_vp( vp )
#' @export

cache_vp <- function( params, ... ){
  # Given the data, see if the parameter count has already been determined
  cache <- params$num_params()
  
  # If so...
  if( !is.null( cache )){
    message( "getting cached data" ) # Announce use of cached data 
    cache                            # Return the number of params
  }
  
  # Otherwise...
  data <- params$get()               # Get the parameters
  cache <- length( data, ... )       # Count the parameters
  params$count( cache )              # Remember the count
  cache                              # Return the count
}

# Examples
# vp <- NULL
# vp <- viewpoint( list( theta=-90, phi=-2, fov=25, zoom=1 )  )
# print( vp$get())
# print( vp$num_params())
# cache_vp(vp)
# vp$num_params()
# vp$get()$theta
# vp$get()['theta']
# print( vp$get())
# print( vp$num_params())
# vp$set( 'theta', -80 )
# print( vp$get())
