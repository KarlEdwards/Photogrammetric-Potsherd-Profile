#' ---
#' title:
#' author:
#' abstract: Extract perimeter points at various heights
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

# -----------------------------------------------
#' ## Find the center of the base, i.e., axis of rotation
# -----------------------------------------------

#+ source_functions, echo = FALSE, include = FALSE
# Load Functions
source( 'functions_basic.R' )
#source( 'functions_contour.R' )
source( 'cache_viewpoint.R' )
source( 'configuration.R' )
#source( 'cache_model.R' )
#source( 'profile_to_wireframe.R' )

#' #### Retrieve Saved Perimeter Data
#+ estimate_base, echo = TRUE
perimeter_data <- readRDS( PERIMETER_FILE )

#' #### Plot perimeter data
#+ plot_perimeter_data, echo = TRUE, include = FALSE
png( './images/perimeter_data.png' )
  p <- ggplot( perimeter_data, aes( x = perimeter_x, y = perimeter_y, color = height )) +
    geom_point() +
    xlim( 0, 1 ) +
    ylim( 0, 1 )
  print( p )
dev.off()
#' <img src="./images/perimeter_data.png" width="350" >


#' #### Estimate the center
# Estimate the center for a given height
# by choosing two points along the perimeter of the pot
# and finding the intersection of
# the radii passing through the points.
#+ estimate_center
find_center <- function( p, h ){

  # Extract perimeter points at height, h
  perimeter <- p[ p[ , 'height' ] == h, c( 'perimeter_x', 'perimeter_y' ) ]
  
    # If not enough points, return the height only,
    # setting all other items to NA
    result <- data.frame(
      h = h, ctrX = NA, ctrY = NA, r = NA
    )

  # If an insufficient number of perimeter points exist at height, h, return result unknown,
  # otherwise, find the center and radius
  if( nrow( perimeter ) > 2 ){
  
    # Calculate the slope of each segment defined by each consecutive pair of perimeter points
    delta_y <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, Y_AXIS ] - perimeter[ .x-1, Y_AXIS ] )
    delta_x <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, X_AXIS ] - perimeter[ .x-1, X_AXIS ] )
    slopes <- delta_y / delta_x

    N <- length( slopes )
    if( N > 3 ){
      pointA_index <- 1
      pointB_index <- N
      ray1 <- get_perpendicular2D( m = slopes[ pointA_index ], P = perimeter[ pointA_index + 1, ] )
      ray2 <- get_perpendicular2D( m = slopes[ pointB_index ], P = perimeter[ pointB_index - 1, ] )
      est_ctr <- get_intersection2D( ray1, ray2 )
      est_radius <- euclidean_distance( est_ctr, perimeter[ pointB_index, ] )

    # Prepare to return the results
    result <- data.frame(
      h = h, ctrX = est_ctr$x, ctrY = est_ctr$y, r = est_radius
    )
  } # else {
#
#  }
    }

  # Round the results
  lapply( result[ complete.cases( result ), ], round, 2 )
}

WIREFRAME_HEIGHTS %>% map_df( ~find_center( perimeter_data, . )) -> radii
radii

saveRDS( file = 'radii.RDS', radii )
