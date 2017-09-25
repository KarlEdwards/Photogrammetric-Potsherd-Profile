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
