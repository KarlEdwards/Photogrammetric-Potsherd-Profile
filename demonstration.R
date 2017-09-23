#' ---
#' title: "Photogrammetric Potsherd Profile Demonstration"
#' author: "Karl Edwards"
#' output:
#'   html_document:
#'    toc: true
#'    highlight: tango
#'    keep_md: TRUE
#'    fig_caption: yes
#' ---

#' <br>
#' # Configuration
#+ setup, include = FALSE
# Style adapted from http://stat545.com/bit006_github-browsability-wins.html#source-code
#
# TO RENDER THIS AS HTML:
#   library('rmarkdown')
#   rmarkdown::render('demonstration.R')

# Load Libraries
require( rgl )
require( ggplot2 )
require( grid )
require( gridExtra )
require( purrr )
require( tibble )
require( lattice )

# Names for convenience and readability
x_axis         <- 1
y_axis         <- 2
z_axis         <- 3
axes           <- 1:3
axes[ x_axis ] <- 'x'
axes[ y_axis ] <- 'y'
axes[ z_axis ] <- 'z'

# Wireframe parameters
stripe_width   <- 0.0003
stripe_tol     <- 0.00003

# Data file
filename <- 'stereolithograph.stl'



#' # Functions
# Get the data; don't plot
load_model <- function( filename ){
  model <- readSTL( filename, plot=FALSE )
  colnames( model ) <- axes
  model
}

# Move the model into the corner of [ X, Y, Z ] = [ 0, 0, 0 ]
scoot <- function( model ) apply( model, 2, function(f) f - min( f ))

# Cut off the top/bottom, front/back, or left/right sides of the model
clip_at <- function( obj, ax, mn, mx ) obj[ obj[ ,ax ] > mn & obj[ ,ax ] < mx, ]

# Alternatively, clip a thin band out of the middle, and keep that portion that was removed
get_band <- function( m=model, a=y_axis, b=0.5, w=stripe_width ){
  band <- clip_at( m, a, b - w, b + w )
  colnames( band ) <- axes
  band
}

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
make_figure <- function( fig_index, obj, viewpoint = 'oblique', limits = c( 0, 1 ) ){

  views  <- tribble(
    # ________   _____   _____   _____   _____
      ~name    , ~xrot , ~yrot , ~zrot , ~zoom
    , 'oblique',   55  ,  -15  ,   45  ,   1
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
  rgl.snapshot( filename = paste0( 'figure', as.character( fig_index ), '.png' ))
}

# Identify the slice having the highest density of points
best_slice <- function( model, ax ){
  breaks <- 100
  data <- model[ , ax ]
  h <- hist( data, breaks=breaks, plot = FALSE )
  biggest_slice <- which(h$counts==max(h$counts))
  h$mids[ biggest_slice ]
}
best_x <- best_slice( model, x_axis )
best_y <- best_slice( model, y_axis )
best_z <- best_slice( model, z_axis )

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

# Show rotation in grey
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

#' # Demonstration
# Load the model data
model <- readSTL( filename, plot=FALSE )

# Move the model into the corner and then display it
model <- scoot( model )
colnames( model ) <- axes

make_figure( 1, model )
make_figure( 2, model, 'xy' )
make_figure( 3, model, 'zy' )
make_figure( 4, model, 'zx' )

#' #### Oblique view of the prototype potsherd
#' <img src="figure1.png" width="300" alt="Figure 1">
#+

#' #### Front and Side Views
#' <img src="figure2.png" width="300" alt="Figure 2">
#' <img src="figure3.png" width="300">
#+

#' #### Top view
#' <img src="figure4.png" width="300">
#+

#' ### Observations
#' + The model scale does not reflect any real-world measurement units and will need to be adjusted
#' + The side view reveals that the rim is not parallel with the X-Z plane. In order for measurement in the direction of the Y-axis to represent height of the pot, it will be necessary to rotate the model slightly about the X-axis.  
#' + From the top view, it is apparent that the center of the pot lies somewhere in the vicinity of ( 0.6, 0.6 )
#' <br>
#+

#' ### Adjust the model to be plum, level, and square with the X-, Y-, and Z-axes 

best_x
best_y
best_z

left_side <- clip_at( model, x_axis, 0, best_x ) 
band_x <- get_band( m=model, a=x_axis,b=best_x, w=4*stripe_width )
right_side <- clip_at( model, x_axis, best_x, 1 ) 
make_figure( 5, left_side, 'xy' )

# Show rotation in grey
make_figure( 5, left_side, 'xy' )
rot <- list( 0, 15, 30, 45, 90 )
ofs <- list( 0.1, 0.2, 0.35, 0.5, 0.8 )
clr <- list( 'grey', 'grey', 'darkgrey', 'darkgrey', 'black' )

pwalk(
  list( rot, ofs, clr )
  , function( rot, ofs, clr ) transrotate(
      obj=band_x, deg=rot, u=0, v=1, w=0, x=ofs, y=0, z=0, color=clr
    )
)
rgl.snapshot( filename = paste0( 'figure', as.character( 5 ), '.png' ))

make_figure( 6, right_side, 'xy' )

#' <img src="figure5.png" width="200">
#' <img src="figure6.png" width="200">
#' <br>
#+


top <- clip_at( model, y_axis, 0, best_y ) 
band_y <- get_band( m=model, a=y_axis,b=best_y, w=4*stripe_width )
bottom <- clip_at( model, y_axis, best_y, 1 ) 

# Show front view, then slice horizontally at various heights
#' <img src="figure2.png" width="300" alt="Figure 2">

limits <- c( 0, 1 )
tilted_model <- rotate3d(model,20*pi/180,x=1,y=0,z=1)
plot3d( 
  get_band( m=tilted_model, a=y_axis, b=0.05, w=4*stripe_width )
    , col='grey'
    , xlim = limits
    , ylim = limits
    , zlim = limits
)

heights <- as.list( seq( from=0.9, to = 0.1, length.out = 5 ))
offsets <- list( 0.2, 0.3, 0.4, 0.6, 0.75)

pwalk(
    list( heights, offsets, clr )
  , function( heights, offsets, clr ) transslice( tilted_model, ax=y_axis, h=heights, x=0, y=0, z=offsets, color=clr )
)

rgl.snapshot( filename = paste0( 'figure', as.character( 5 ), '.png' ))

make_figure( 8, bottom, 'zx' )

#' <img src="figure7.png" width="200">
#' <img src="figure8.png" width="200">
#' <br>
#+


#' The profile, **P**, comprises points $p_0, p_1, p_2, ... p_n$, which lie on the perimeter of the pot
#' <br>
#' Each point, $p_i$, has coordinates (h,r)
#' <br>
#' h is the height, the vertical distance above base plane X-Z
#' <br>
#' r is the radius, the horizontal distance from the axis of rotation, $r=\sqrt{ (x(h)-x_0)^2+(z(h)-z_0)^2 }$
#' <br>
#' <br>
#' The axis of rotation is perpendicular to the X-Z plane, intersecting it at point **$O_0$**$(x_0,z_0)$
#' <br>
#' Point **O** is at the intersection of rays $\overrightarrow{OA}$ and $\overrightarrow{OB}$
#' <br>
#' The coordinates of $x_0$ and $z_0$ are estimated as the mean(x) and mean(z) for an arbitrarily-selected number of approximate center points **O**(h)
#' <br>
#' Points **A**(h) and **B**(h) are any two points along the perimeter at the same height above the base.
#' <br>
#' 
#' <br>
#' 
#' <br>
#' 
#' <br>
#' 
#' <br>


