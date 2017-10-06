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


#' #### Get data from previous step
#+ get_radii, echo = TRUE
radii   <- readRDS( file = 'radii.RDS' )
medians <- radii %>% map_dbl( ~median( . ))
center  <- medians[ 2:3 ]
model   <- make_model( readRDS( MODEL_FILE ) )
vp      <- viewpoint( list( theta = 15, phi = 10, fov = 0, zoom = 0.75 ))
best_x  <- best_slice( model$get(), X_AXIS )
best_x
model$get_band( ax=X_AXIS, ctr=best_x, thickness=STRIPE_WIDTH )
model$show( LEFT_VIEW )
make_figure( 'band_1' )
#' <img src="./images/band_1.png" width="400">
# --

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
#   rmarkdown::render('step4.R')
#

#' ## References
#' The style for this document has been adapted from http://stat545.com/bit006_github-browsability-wins.html#source-code

#' ## References
