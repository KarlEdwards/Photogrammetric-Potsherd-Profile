

#' ### Read Stereolithography
#+ get_raw_data, echo = TRUE, cache = FALSE
STEREOLITHOGRAPHY_FILE %>%
  load_data() -> raw_data
     make_model( raw_data ) -> model        # Read the stereolithography file and create a model

#' The initial box size is `r round( box_size(), 4 )` units.



axes %>%  # Align the model in the reference frame
  map_dbl( ~gross_box( ., step_size=5 ) )

#' ## Push the model into a corner
#+ fix_rim, echo = TRUE, include = TRUE, cache = FALSE
offset <- apply( model$get(), 2, min )      # Find the distance from each axis to the nearest model point
model$move_left(     offset[ 'x' ] )        # Remove the offset, effectively pushing the object
model$move_down(     offset[ 'y' ] )        # into the corner
model$move_backward( offset[ 'z' ] )
model$show( LEFT_VIEW )                     # Create the first of three figures shown below
make_figure( './images/initial_view' )        # and include it in this document
#' <img src="./images/initial_view.png" width="350" >
# -----------------------------------------------


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
axis3d( 'x', pos=c( NA, -0.02, 0.0 ), col = c( 'red', 'black' ), at=c( 0.3, 0.6 ))
make_figure( './images/front_view' )
                                            #
model$show( TOP_VIEW_C )
make_figure( './images/top_view' )
                                            #
model$show( RIGHT_VIEW )
make_figure( './images/end_view_2' )
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
