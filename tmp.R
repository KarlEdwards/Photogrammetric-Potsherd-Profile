# Load Libraries
require( rgl )
require( ggplot2 )
require( grid )
require( gridExtra )
require( purrr )
require( tibble )
require( lattice )
require( png )

# Paths
FIGURES_PATH <- './images/'

# Names for convenience and readability
X_AXIS         <- 1
Y_AXIS         <- 2
Z_AXIS         <- 3
axes           <- 1:3
axes[ X_AXIS ] <- 'x'
axes[ Y_AXIS ] <- 'y'
axes[ Z_AXIS ] <- 'z'

name_axes <- function( m ){
  colnames( m ) <- axes
  m
}

# Wireframe parameters
STRIPE_WIDTH   <- 0.001
STRIPE_TOL     <- 0.0005
BASE_RADIUS    <- 0.3
SCALE_FACTOR   <- 8.0 * 25.4

#' #### Use these elevations and X-coordinates
#  --- mini-configuration ---
WIREFRAME_HEIGHTS <- seq( 0.10, 0.60, by=0.05 )
POINTS_ALONG_X    <- seq( 0.20, 0.80, by=0.05 )


# Data file
STEREOLITHOGRAPHY_FILE <- './R/stereolithograph.stl'
MODEL_FILE     <- 'model.RDS'
PERIMETER_FILE <- 'perimeter.RDS'

TOP_VIEW_A     <- viewpoint( list( theta=   0, phi=  90, fov=10, zoom=1 ))
TOP_VIEW_B     <- viewpoint( list( theta=  90, phi=  90, fov=0, zoom=1 ))
TOP_VIEW_C     <- viewpoint( list( theta= 180, phi=  90, fov=0, zoom=1 ))
TOP_VIEW_D     <- viewpoint( list( theta= 270, phi=  90, fov=0, zoom=1 ))
BOTTOM_VIEW_A  <- viewpoint( list( theta=   0, phi= -90, fov=0, zoom=1 ))
BOTTOM_VIEW_B  <- viewpoint( list( theta=  90, phi= -90, fov=0, zoom=1 ))
BOTTOM_VIEW_C  <- viewpoint( list( theta= 180, phi= -90, fov=0, zoom=1 ))
BOTTOM_VIEW_D  <- viewpoint( list( theta= 270, phi= -90, fov=0, zoom=1 ))
BACK_VIEW      <- viewpoint( list( theta=   0, phi=   0, fov=0, zoom=1 ))
FRONT_VIEW     <- viewpoint( list( theta= 170, phi=   0, fov=10, zoom=1 ))
LEFT_VIEW      <- viewpoint( list( theta= 260, phi=   0, fov=10, zoom=1 ))
RIGHT_VIEW     <- viewpoint( list( theta=  90, phi=   0, fov=0, zoom=1 ))
TOP_VIEW       <- TOP_VIEW_A
BOTTOM_VIEW    <- BOTTOM_VIEW_A
STANDARD_VIEWS <- list( LEFT_VIEW, FRONT_VIEW, TOP_VIEW )
