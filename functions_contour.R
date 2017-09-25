slice_the_model <- function( model=model, as_x='x', as_y='z', slice_on='y', n_slices = 20, tol = 0.0025 ){
  a <- min( model[ , slice_on ])
  b <- max( model[ , slice_on ])
  slice_range <- b - a

  nominal_contours <<-
    seq( n_slices ) %>%
      map_dbl( ~a + .x * slice_range / n_slices )

  a_slice <- function( i ){
    this <- model[ , slice_on ]
    that <- nominal_contours[ i ]
    fields <- c( as_x, as_y )
    indecies <- abs( this - that ) < tol
    df <- as.data.frame( model[ indecies, fields ] )
    names( df ) <- c( 'x', 'y' )
    df
  }

  actual_contours <-
    seq( n_slices ) %>%
      map( ~a_slice( .x ))

}

# Calculate the data slices on x, y, and z
# data <- slice_the_model( model, 'z', 'y', 'x', 16, 0.0025 )
# data <- slice_the_model( model, 'x', 'z', 'y', 16, 0.0025 )
# data <- slice_the_model( model, 'y', 'x', 'z', 16, 0.0025 )

get_slice_plots <- function( slice_data ){
  slice_plots <- seq_along( slice_data ) %>%
    map(
      ~ggplot(
          data[[ .x ]]
        , aes(x=x, y=y)
        , main = paste( 'slice', as.character( .x ))
      ) +
      geom_point( size=0.1 ) +
      xlim( 0, 1 ) +
      ylim( 0, 1 )
    )

  # Create a matrix of plots
  d <- ceiling( sqrt( length( slice_data)))
  marrangeGrob( slice_plots, nrow=d, ncol=d)
}
