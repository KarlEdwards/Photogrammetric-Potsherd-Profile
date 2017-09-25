#' A caching Function
#'
#' Create a configuration list, containing functions to...
#' * set the value of specific configurable items
#' * get the value of those items
#'
#' @param items numeric vector contents.
#' @keywords caching
#' @examples cfg <- configuration( list( theta=-90, phi=-2, fov=25, zoom=1 ) )
#' @export

# theta=-90,phi=-2,fov=25,zoom=1

configuration <- function( items = list() ){
  cache <- NULL                           # Begin with unknown configuration values

  clear_all  <- function() cache <<- NULL # Re-initialize to unknown values
  get <- function() items          # Return the values
  count <- function( items ) cache <<- items
  num_items <- function() cache
  set <- function( id, value ){         # Set new values
   # x <<- y
   # m <<- NULL

   # cache <<- new_values in global.env
   # num_items <<- NULL in global.env


  items[[ id ]] <<- value
  items
  }

  # Return the list of functions
  list(
      set = set
    , get = get
    , clear_all  = clear_all
    , count = count
    , num_items = num_items
  )
}

#' A caching Function
#'
#' Create a configuration, or update it if it exists already.
#'
#' @param items numeric vector contents. triple dot.
#' @keywords caching
#' @examples cfg <- cache_cfg( cfg )
#' @export

cache_cfg <- function(items, ...){
  # Given the data, see if the item count has already been determined
  cache <- items$num_items()
  
  # If so...
  if( !is.null( cache )){
    message( "getting cached data" ) # Announce use of cached data 
    cache                            # Return the number of items
  }
  
  # Otherwise...
  data <- items$get()         # Get the items
  cache <- length( data, ... )       # Count the items
  items$count( cache )          # Remember the count
  cache                              # Return the count
}

# Examples
# cfg <- NULL
# cfg <- configuration( list( theta=-90, phi=-2, fov=25, zoom=1 )  )
# print( cfg$get())
# print( cfg$num_items())
# cache_cfg(cfg)
# cfg$num_items()
# cfg$get()$theta
# cfg$get()['theta']
# print( cfg$get())
# print( cfg$num_items())
# cfg$set( 'theta', -80 )
# print( cfg$get())
