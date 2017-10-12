#' ---
#' title:
#' author:
#' abstract: Make a wireframe model
#' date:
#' output:
#'   github_document:
#'     includes:
#'       in_header:   ./markdown/header.md
#'       before_body: ./markdown/prefix.md
#'       after_body:  ./markdown/footer.md
#'     md_extensions: -autolink_bare_uris+hard_line_breaks
#'     toc: FALSE
#'     toc_depth: 2
#'     fig_height: 7
#'     fig_width: 5
#' bibliography: potsherd.bibtex
#' ---

#+ source_functions, echo = FALSE, include = FALSE
# Load Functions
source( 'functions_basic.R' )
source( 'functions_contour.R' )
source( 'cache_viewpoint.R' )
source( 'configuration.R' )
source( 'cache_model.R' )
source( 'profile_to_wireframe.R' )
source( 'critical_points.R' )

#' #### Get data from previous step
#+ get_radii, echo = TRUE
radii   <- readRDS( file = 'radii.RDS' )
medians <- radii %>% map_dbl( ~median( . ))
center  <- medians[ 2:3 ]
model   <- make_model( readRDS( MODEL_FILE ) )
vp      <- viewpoint( list( theta = 15, phi = 10, fov = 0, zoom = 0.75 ))

#' #### Find the tallest cross-section
#' Recall that the front view looks like this:
#' <img src="./images/front_view.png" width="300">


best_x  <- best_slice( model$get(), X_AXIS )
#' The tallest cross-section is at X = ```r best_x```


#' #### Slice the model at this point
#+ show_thick, echo = TRUE, include = FALSE
model$get_band( ax = X_AXIS, ctr = best_x, thickness =  1.8 * STRIPE_WIDTH )
model$show( LEFT_VIEW )
make_figure( './images/thick_band' )
#' <img src="./images/thick_band.png" width="400">
# -----------------------------------------------


#' The slice is thick in the Z-direction
#' We are interested in the points along the outside of the pot,
#' so find the most dense cloud of points, and keep only that
#' very thin slice of the band.
model_data        <- model$get()
histogram_buckets <- model_data[ , 'x'] %>% hist( plot = FALSE )
best_mid          <- as.list( histogram_buckets )[[ 'mids' ]][ which.max( histogram_buckets$counts ) ]
thin_slice        <- as.data.frame( get_band( model_data, 1, best_mid ))

#+ show_thin, echo = TRUE, include = FALSE
# Show the resulting profile
  png( './images/thin_band.png' )
    ggplot( thin_slice, aes( x = z, y = y )) +
      geom_point()   +
      xlim( 0, 0.6 ) +
      ylim( 0, 0.6 )
  dev.off()
#' <img src="./images/thin_band.png" width="400">
# -----------------------------------------------


# Establish plot limits
plot_limit_lo <- round( min( thin_slice[ , 'y' ] ), 3 )
plot_limit_hi <- round( max( thin_slice[ , 'y' ] ), 3 )

#+ find_extrema, echo = TRUE
df <- thin_slice[ ,c( 'y', 'z' ) ]
df <- unique( df[ order( df[ , 'y' ] ), ] )
df <- df[ df[ ,'y' ] > plot_limit_lo & df[ , 'y' ] < plot_limit_hi, ]
extrema <- critical_points( df, 0.001 )
extrema <- extrema[ extrema[ , 'direction' ] %in% 'ridge', ]

p <- ggplot( df, aes( x = z, y = y )) +
  geom_point() +
  expand_limits( x = plot_limit_hi , y = plot_limit_hi )

u <- ( seq( nrow(extrema)) %>% map( ~geom_hline( yintercept = extrema[ ., 'y' ], colour = 'red', linetype=2) ) )
v <- ( seq( nrow(extrema)) %>% map( ~geom_vline( xintercept = extrema[ ., 'z' ], colour = 'red', linetype=2) ) )

# Two of the ridges have nearly the same radius;
# suppress the label for one to make the other label visible
HIDE_CLOSE_LABELS <- c( 1, 3 ) 

g <- round( extrema[ , 'y' ], 3 )
breaks_y <- g - g[ 1 ]
h <- sort( round( extrema[ , 'z' ], 3 ))
breaks_x <- h[ 3 ] - h
breaks_x <- breaks_x[ 1 ]

#+ show_sliver, echo = TRUE, include = FALSE
png( './images/sliver.png' )
p + u + v +
  xlab( 'Radius   [ mm ]' ) +
  ylab( 'Height   [ mm ]' ) +
  theme(
    axis.title = element_text(
      colour = "darkblue"
      , size = 24
      , angle = 0
    )
  , axis.line = element_line(
        colour = "darkblue"
      , size = 1
      , linetype = "solid"
    )
  , axis.text = element_text(
      colour = "darkblue"
    , size = 14
    , angle = 0
  )
) +
  scale_y_continuous( 
      breaks = c( 0, round( extrema[,'y'], 3 ) )
    , labels = c( 0, round( SCALE_FACTOR * breaks_y, 0 ))
  ) +
  scale_x_continuous(
      breaks = c( 0, round( extrema[ HIDE_CLOSE_LABELS,'z' ], 3 ))
    , labels = c( '', round( SCALE_FACTOR * breaks_x, 0 ), 0 )
  )

dev.off()
# _____ End Plotting _____
#' <img src="./images/sliver.png" width="400">
# -----------------------------------------------


#' #### Square the model in the reference frame
#+ square_in_frame
offset <- apply( model$get(), 2, min )      # Find the distance from each axis to the nearest model point
model$move_left(     offset[ 'x' ] )        # Remove the offset, effectively pushing the object
model$move_down(     offset[ 'y' ] )        # into the corner
model$move_backward( offset[ 'z' ] )
model$show( LEFT_VIEW )

#' #### Flip profile
#+ flip_profile
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

#' #### Make figures
#+ make_figures
make_figure( 'band_3' )
#' <img src="./images/band_3.png" width="400">
adjust( vp, 'theta', 15 )
adjust( vp, 'phi', 10 )
make_figure( 'wireframe' )
#' <img src="./images/wireframe.png" width="400">
adjust( vp, 'theta', 90 )
adjust( vp, 'phi', 0 )
make_figure( 'wireframe_side' )
#' <img src="./images/wireframe_side.png" width="400">
adjust( vp, 'theta', 90 )
adjust( vp, 'phi', 90 )
make_figure( 'wireframe_top' )
#' <img src="./images/wireframe_top.png" width="400">
#'<br>

#+ instructions, echo = FALSE
# TO RENDER THIS AS HTML:
#   setwd( '~/Dropbox/Projects/Potsherd/example' )
#   library('rmarkdown')
#   rmarkdown::render('Part_A3_4.R')
#
#   sh update.sh Part_A3_4.R

#' ## References
#' The style for this document has been adapted from http://stat545.com/bit006_github-browsability-wins.html#source-code
