#' ---
#' title:
#' author:
#' abstract: Extract perimeter points at various heights
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
#' ## Find the center of the base, i.e., axis of rotation
# -----------------------------------------------

#' #### Retrieve Saved Perimeter Data
#+ estimate_base, echo = TRUE
perimeter_data <- readRDS( PERIMETER_FILE )

#' #### Plot perimeter data
#+ plot_perimeter_data
ggplot( perimeter_data, aes( x = perimeter_x, y = perimeter_y, color = height )) +
  geom_point() +
  xlim( 0, 1 ) +
  ylim( 0, 1 )

#' #### Choose two points along the perimeter of the pot at the selected height(s)

#+ choose_height
# Choose a height, from which to estimate the axis of rotation
selected_height_index <- 4 # length( heights )

find_center <- function( p, h ){

  # Extract perimeter points at height, h
  perimeter <- p[ p[ , 'height' ] == h, c( 'perimeter_x', 'perimeter_y' ) ]
  
  # If an insufficient number of perimeter points exist at height, h, return result unknown,
  # otherwise, find the center and radius
  if( nrow( perimeter ) > 2 ){
  
    # Calculate the slope of each segment defined by each consecutive pair of perimeter points
    delta_y <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, Y_AXIS ] - perimeter[ .x-1, Y_AXIS ] )
    delta_x <- 2:nrow( perimeter ) %>%  map_dbl( ~perimeter[ .x, X_AXIS ] - perimeter[ .x-1, X_AXIS ] )
    slopes <- delta_y / delta_x
    slopes
    N <- length( slopes )
    ray1 <- get_perpendicular2D( m = slopes[ 1 ], P = perimeter_points[ 2, ] )
    ray2 <- get_perpendicular2D( m = slopes[ N ], P = perimeter_points[ N-1, ] )
    est_ctr <- get_intersection2D( ray1, ray2 )
    est_radius <- euclidean_distance( est_ctr, perimeter_points[ 2, ] )
    result <- data.frame(
      h = h, ctrX = est_ctr$x, ctrY = est_ctr$y, r = est_radius
    )
  } else {
    result <- data.frame(
      h = h, ctrX = NA, ctrY = NA, r = NA
    )
  }
  lapply( result[ complete.cases( result ), ], round, 2 )
}

heights %>% map_df( ~find_center( perimeter_data, . )) -> radii
radii

saveRDS( file = 'radii.RDS', radii )
