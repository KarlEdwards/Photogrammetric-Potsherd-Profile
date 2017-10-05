#' ---
#' title:
#' author:
#' abstract: Find the center of the base, i.e., axis of rotation
#' date:
#' output:
#'   github_document:
#'     toc: FALSE
#' bibliography: potsherd.bibtex
#' nocite: | 
#'   @arc3d, @bryan, @strayer, @tyers
#' ---

#' ### Estimate the radius at several elevations

#' #### Retrieve Saved Model
model <- make_model( readRDS( MODEL_FILE ) )


#' #### Use these elevations and X-coordinates
#  --- mini-configuration ---
heights        <- seq( 0.10, 0.60, by=0.05 )
points_along_x <- seq( 0.20, 0.80, by=0.05 )

#' #### Get perimeter data
#+ get_perimeter, echo = TRUE, result = 'hide', cache = TRUE
map(
    heights                                 # for each height, h
  , ~map2(
         .x 
       , points_along_x                     # for each point along the perimeter, x
       , ~get_minz_at_hx(                   # return minimum( z ) as partial radius at ( h, x )
            model
          , h=.x
          , x=.y
          , fun='min'
         )
     )
) %>% unlist() -> perimeter_data

#' #### Clean the data
#+ clean_data, echo = TRUE, include = TRUE
perimeter_matrix <- matrix(
    perimeter_data
  , ncol     = 3
  , byrow    = TRUE
  , dimnames = list( NULL, c( 'height', 'perimeter_x', 'perimeter_y' ))
)

#' #### Remove invalid points
#+ remove_bad_points, echo = TRUE
valid_points <- is.finite( perimeter_matrix[ , 'perimeter_y' ] )
perimeter <- data.frame( perimeter_matrix[ valid_points, ] )
perimeter

#' #### Save the results
#+ save_perimeter, echo = TRUE
saveRDS( perimeter, PERIMETER_FILE )
