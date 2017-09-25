
#' # Functions
name_axes <- function( m ){
  colnames( m ) <- axes
  m
}

# Get the data; don't plot
load_model <- function( filename ) name_axes( readSTL( filename, plot=FALSE ))

# Move the model into the corner of [ X, Y, Z ] = [ 0, 0, 0 ]
center <- function( model ) name_axes( apply( model, 2, function(f) f - min( f )))

# Cut off the top/bottom, front/back, or left/right sides of the model
clip_at <- function( obj, ax, mn, mx ) name_axes( obj[ obj[ ,ax ] > mn & obj[ ,ax ] < mx, ] )

# Alternatively, clip a thin band out of the middle, and keep that portion that was removed
get_band <- function( m=model, a=y_axis, b=0.5, w=stripe_width ) name_axes( clip_at( m, a, b - w, b + w ))

# Show bounding box
in_a_box <- function(){
  rgl.bbox(
      color = c( '#333377', 'black' )
    , emission = '#333377'
    , specular = '#3333FF'
    , shininess=5
    , alpha=0.8
    , nticks = 3
  )
}

# Show the model from a particular point of view
see <- function( obj, viewpoint = 'oblique2', limits = c( 0, 1 ) ){

  views  <- tribble(
    # ________   _____   _____   _____   _____
      ~name    , ~xrot , ~yrot , ~zrot , ~zoom
    , 'oblique',   55  ,  -15  ,   45  ,   1
    , 'oblique2', 175  ,  -15  ,   45  ,   1
    , 'zy'     ,   90  ,  -0.5,    1  ,   1
    , 'zx'     ,    0  ,   90  ,    1  ,   1
    , 'xy'     ,    0.5,  -0.1,    0.5,   1
  )
  stopifnot( viewpoint %in% views[[ 'name' ]] )
  view_parameters <- views[ views[ 'name' ] == viewpoint, ]

  clear3d()                        # Start with nothing
  bg3d( 'lightgray' )              # Set background color
  plot3d(                          # Show the model
      obj
    , xlim = limits
    , ylim = limits
    , zlim = limits
  )
  points3d( 0, 0, 0, col = 'red' ) # Highlight the origin
  axes3d()                         # Show the axes
  in_a_box()                       # Show bounding box
  text3d( x=0.75, y=0.75, z=0.75, text=paste0( 'View ', viewpoint ) ,col="Blue")

  rgl.viewpoint(                   # Set the viewpoint
      theta = view_parameters[ 2 ]
    , phi   = view_parameters[ 3 ]
    , fov   = view_parameters[ 4 ]
    , zoom  = view_parameters[ 5 ]
  )
}

make_figure <- function( caption ) rgl.snapshot( filename = paste0( caption, '.png' ))

# Identify the slice having the highest density of points
best_slice <- function( model, ax ){
  breaks <- 100
  data <- model[ , ax ]
  h <- hist( data, breaks=breaks, plot = FALSE )
  biggest_slice <- which(h$counts==max(h$counts))
  h$mids[ biggest_slice ]
}
#best_x <- best_slice( model, x_axis )
#best_y <- best_slice( model, y_axis )
#best_z <- best_slice( model, z_axis )

# Show rotation in grey
transrotate <- function( obj, deg, u=0, v=0, w=0, x=0, y=0, z=0, color='darkgrey' ){
  limits <- c( 0, 1 )
  points3d(
    translate3d(
        rotate3d( obj=obj, angle=deg*pi/180, x=u, y=v, z=w )
      , x=x, y=y, z=z
    )
    , col=color
    , xlim = limits
    , ylim = limits
    , zlim = limits
  )
}

# Show slices in grey
transslice <- function( obj, ax=y_axis, h=0.5, x=0, y=0, z=0, color='darkgrey' ){
  limits <- c( 0, 1 )
  points3d(
    translate3d(
        get_band( m=obj, a=ax,b=h*max(obj[,ax]), w=4*stripe_width )
      , x=x, y=y, z=z
    )
    , col=color
    , xlim = limits
    , ylim = limits
    , zlim = limits
  )
}
