#' ---
#' title:
#' author:
#' abstract: Find the center of the base, i.e., axis of rotation
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

#' ### Estimate the radius at several elevations

#+ source_functions, echo = FALSE, include = FALSE
# Load Functions
source( 'functions_basic.R' )
source( 'functions_contour.R' )
source( 'cache_viewpoint.R' )
source( 'configuration.R' )
source( 'cache_model.R' )
source( 'profile_to_wireframe.R' )

#' #### Retrieve Saved Model
model <- make_model( readRDS( MODEL_FILE ) )

#' #### Get perimeter data
#+ get_perimeter, echo = TRUE, include = FALSE, result = 'hide'
map(
    WIREFRAME_HEIGHTS                       # for each height, h
  , ~map2(
         .x 
       , POINTS_ALONG_X                     # for each point along the perimeter, x
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
