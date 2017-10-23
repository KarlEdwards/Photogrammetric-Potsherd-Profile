## ---- inserted

#+ basic_functions, echo = TRUE

# Get the data; don't plot
load_data <- function( filename ) name_axes( readSTL( filename, plot=FALSE ))

box_size <- function() round( reduce( model$calculate( function(f) max(f)-min(f) ), `*` ), 4 )

smallest_box <- function( ax, tilt_degrees ){
  steps <- 100 / tilt_degrees  # Take as many steps as needed to make sure the minimum occurs at least once, e.g., 100 degrees

  # At each position, check the box volume
  1:steps %>%
    map_dbl( ~{ model$rotate_on( ax=ax, angle = tilt_degrees ); box_size()}) -> rots
  # Then back up at rotate only as far as the minimum volume
  model$rotate_on( 
      ax    = ax
    , angle = ( tilt_degrees * ( which.min( rots ) - steps ))
  )
##  plot( rots )
  box_size()
}

get_one_grob <- function( grobname ){
  rasterGrob(
      as.raster(
        readPNG( grobname )
      )
    , interpolate = FALSE
  ) 
}

multi_view <- function( groblist ){
  map( groblist,
    ~get_one_grob(
      paste0( FIGURES_PATH, .x, '.png' )
    )
  ) -> grobs
  marrangeGrob( grobs, nrow=1, ncol=3, top = NULL )  
  #marrangeGrob(grobs, ncol, nrow, ..., top = quote(paste("page", g, "of", pages)))

}

# Cut off the top/bottom, front/back, or left/right sides of the model
clip_at <- function( obj, ax, mn, mx ) name_axes( obj[ obj[ ,ax ] > mn & obj[ ,ax ] < mx, ] )

# Alternatively, clip a thin band out of the middle, and keep that portion that was removed
get_band <- function( m=model_matrix, a=y_axis, b=0.5, w=STRIPE_WIDTH ) name_axes( clip_at( m, a, b - w, b + w ))

# Show bounding box
in_a_box <- function(){
  rgl.bbox(
      color = c( '#333377', 'black' )
    , emission = '#333377'
    , specular = '#3333FF'
    , shininess=5
    , alpha=0.8
    , nticks = 3
  )
}


view <- function( vp=cfg ) rgl.viewpoint(
    theta = vp$get()$theta
  , phi   = vp$get()$phi
  , fov   = vp$get()$fov
  , zoom  = vp$get()$zoom
)

adjust <- function( cfg, parameter, val ){
  cfg$set( parameter, val )
  view( cfg )
}

background      <- function( bgcolor ) bg3d( bgcolor )
see             <- function( obj, config, limits=c(0,1) ){
  clear3d()
  plot3d( obj, xlim = limits , ylim = limits , zlim = limits )
  view( config )
  background( 'white' )
}
reference_point <- function( coords=c(0,0,0), ref_color='red' ) points3d( coords[1], coords[2], coords[3], col = ref_color )
move_it         <- function( obj, dx, dy, dz ) assign( obj, translate3d( obj=obj, x=dx, y=dy, z=dz ), envir = .GlobalEnv )

make_figure <- function( fun, args, file_name ){
cat( sprintf( '\nmake_figure'))
  do.call( fun, args )
  rgl.snapshot( filename = paste0( FIGURES_PATH, file_name, '.png' ))
}

# Identify the slice having the highest density of points
best_slice <- function( model, ax ){
  breaks <- 100
  data <- model[ , ax ]
  h <- hist( data, breaks=breaks, plot = FALSE )
  biggest_slice <- which(h$counts==max(h$counts))
  h$mids[ biggest_slice ]
}
#best_x <- best_slice( model, X_AXIS )
#best_y <- best_slice( model, Y_AXIS )
#best_z <- best_slice( model, Z_AXIS )

# Show rotation in grey
transrotate <- function( obj, deg, u=0, v=0, w=0, x=0, y=0, z=0, color='darkgrey' ){
  limits <- c( 0, 1 )
  points3d(
    translate3d(
        rotate3d( obj=obj, angle=deg*pi/180, x=u, y=v, z=w )
      , x=x, y=y, z=z
    )
    , col=color
    , xlim = limits
    , ylim = limits
    , zlim = limits
  )
}

# Show slices in grey
transslice <- function( obj, ax=Y_AXIS, h=0.5, x=0, y=0, z=0, color='darkgrey' ){
  limits <- c( 0, 1 )
  points3d(
    translate3d(
        get_band( m=obj, a=ax,b=h*max(obj[,ax]), w=3*STRIPE_WIDTH )
      , x=x, y=y, z=z
    )
    , col=color
    , xlim = limits
    , ylim = limits
    , zlim = limits
  )
}

get_curve_points <- function( model_matrix, as_width='x', as_height='y', as_curve='z', tol = STRIPE_WIDTH, height, width, fun='min' ){
  is_near <- function( x, a, delta ){
    big_enough   <- x %>% map_lgl( ~ .x > a - delta )
    small_enough <- x %>% map_lgl( ~ .x < a + delta )
    big_enough & small_enough
  }

  # Return the max(min) value of as_curve in the box
  # defined by as_width near width and as_height near height
  cat(
    sprintf(
        '\nChecking ( %4.2f, %4.2f ) ...'
      , height
      , width
    )
  )
  goodx  <- model_matrix[ is_near( model_matrix[ ,as_width ], width , tol ), ]
  goodxy <- goodx[ is_near( goodx[ ,as_height], height, tol ), ]
  if( nrow( goodxy ) == 0 ) return( Inf )
  do.call( fun, as.list( goodxy[ ,as_curve ] ) )
}

get_minz_at_hx <- function( model, h, x, fun = 'min' ){
  results <- get_curve_points(
      model_matrix = model$get()
    , as_width='x'
    , as_height='y'
    , as_curve='z'
    , tol = 5 * STRIPE_WIDTH
    , height = h
    , width  = x
    , fun = fun
  )
  c( h, x, results )
}

get_perpendicular2D <- function( m, P ){
  if( m == 0 ){                             # perpendicular is vertical, i.e., slope undefined
    result <-  list( 'slope' = NA, 'intercept' = NA )
  } else {
    normal_slope <- -1 / m
    x <- P[ , 1 ]
    y <- P[ , 2 ]
    normal_intercept <- y - normal_slope * x
    result <- list( 'slope' = normal_slope, 'intercept' = normal_intercept )
  }
  result
}

# For line intersection in 3D, see https://math.stackexchange.com/questions/28503/how-to-find-intersection-of-two-lines-in-3d
get_intersection2D <- function( line1, line2 ){
  x <- ( line2$intercept - line1$intercept ) / ( line1$slope - line2$slope )
  y <- line1$slope * x + line1$intercept
  list( 'x' = x, 'y' = y )
}

euclidean_distance <- function( P1, P2 ){
  deltas <- unlist( matrix( P1, nrow = 1 ) ) - unlist( matrix( P2, nrow = 1 ) ) 
  sqrt( sum( deltas^2 ))
}

get_intercept <- function( P, m ) P[ ,2 ] - m * P[ ,1 ]

get_slope2D <- function( P1xy, P2xy ){
  delta_x <- P2xy[ ,1 ] - P1xy[ ,1 ]
  delta_y <- P2xy[ ,2 ] - P1xy[ ,2 ]
  cat( sprintf( '\ndelta x: %5.4f',delta_x))
  cat( sprintf( '\ndelta y: %5.4f',delta_y))
  if( delta_x == 0 ){
    slopeMsg <- "\nm: none"
    sloveVal <- null
  } else {
    slopeMsg <- sprintf( "\nm: %3.2f", delta_y / delta_x )
    slopeVal <- round( delta_y / delta_x, digits = 4 )
  }
  #noquote( slopeMsg )
  slopeVal
}

# Save images of multiple views of the model in multiple files
show_multi_view <- function( base_name, mdl ){
  # This function produces side effects:
  #   Create an image for each STANDARD VIEW
  #   Create a file for each image
  #   Name the files as base_name + index
  filenames <- 1:length( STANDARD_VIEWS ) %>% paste0( base_name, . )  %>% as.list()
  pwalk(                   # For each VIEW and FILE NAME...
      list(                #   create the image and save it in the file
          STANDARD_VIEWS  
      , filenames
    )
  , function( y, z ) make_figure( fun = mdl$show, args = list( y ), file_name = z )
)
  multi_view( filenames )
}
