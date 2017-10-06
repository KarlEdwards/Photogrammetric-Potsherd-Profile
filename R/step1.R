#' ---
#' title:
#' author:
#' abstract: Build a usable model from a stereolithography file
#' date:
#' output:
#'   github_document:
#'     includes:
#'       in_header: header.md
#'       before_body: prefix.md
#'       after_body: footer.md
#'     md_extensions: -autolink_bare_uris+hard_line_breaks
#'     toc: TRUE
#'     toc_depth: 2
#'     fig_height: 7
#'     fig_width: 5
#' bibliography: potsherd.bibtex
#' ---

# -----------------------------------------------
#' ## Build a usable model from a stereolithography file
# -----------------------------------------------

#+ source_functions, echo = FALSE
# Load Functions
source( 'functions_basic.R' )
source( 'functions_contour.R' )
source( 'cache_viewpoint.R' )
source( 'configuration.R' )
source( 'cache_model.R' )
source( 'profile_to_wireframe.R' )

#' ### Read Stereolithography
#+ get_raw_data, echo = TRUE, cache = FALSE
STEREOLITHOGRAPHY_FILE %>%
  load_data() -> raw_data
     make_model( raw_data ) -> model        # Read the stereolithography file and create a model

#' ## Align the model in the reference frame
#' #####  ( For now, this is a manually-initiated action; Eventually, it will be automatic )

#' #### Push the model into a corner

#+ fix_rim, echo = TRUE, include = TRUE, cache = FALSE
model$move_backward( 4.5 )                  # The prototype potsherd model isn't tight against the origin
offset <- apply( model$get(), 2, min )      # Find the distance from each axis to the nearest model point
model$move_left(     offset[ 'x' ] )        # Remove the offset, effectively pushing the object
model$move_down(     offset[ 'y' ] )        # into the corner
model$move_backward( offset[ 'z' ] )
model$show( LEFT_VIEW )                     # Create the first of three figures shown below
make_figure( './images/initial_view' )        # and include it in this document
#' <img src="./images/initial_view.png" width="350" >
# -----------------------------------------------


#' #### Move the model away from the left wall
model$move_right(   0.4 )                   # Move the model away from the X-Y plane, so
model$move_forward( 0.4 )                   # there will be space to rotate it
model$show( LEFT_VIEW )                     # Create the second figure
make_figure( './images/second_view' )                # and include it in this document
#' <img src="./images/second_view.png" width="200">
# -----------------------------------------------

#' #### Tilt the model so the rim is parallel to the X-Z plane
model$rotate_about_x( 15 )                  # Make the rim parallel with the X-Z plane
model$show( LEFT_VIEW )                     # Create the third figure
make_figure( './images/third_view' )                 # and include it in this document
# -----------------------------------------------
#' <img src="./images/third_view.png" width="200">
#+ plum_and_square, echo = TRUE, include = TRUE, cache = FALSE

#' #### Scoot the object tight against each axis again
#+ make_four_views, cache = FALSE
offset <- apply( model$get(), 2, min )     
model$move_left( offset[ 'x' ] )
model$move_down( offset[ 'y' ] )
model$move_backward( offset[ 'z' ] )
model$show( LEFT_VIEW )
make_figure( './images/end_view_1' )
#' <img src="./images/end_view_1.png" width="200">
# -----------------------------------------------

#' ### Show the model from various vantage points
model$show( FRONT_VIEW )
make_figure( 'front_view' )
                                            #
model$show( TOP_VIEW_C )
make_figure( 'top_view' )
                                            #
model$show( RIGHT_VIEW )
make_figure( 'end_view_2' )
                                            #
#' <img src="./images/end_view_1.png" width="200">
#' <img src="./images/front_view.png" width="200">
#' <img src="./images/end_view_2.png" width="200">
# -----------------------------------------------
#' <img src="./images/top_view.png" width="200">
# -----------------------------------------------
#' ### Save the Model
#+ save_model, echo = TRUE, cache = FALSE
saveRDS( model$get(), MODEL_FILE )
