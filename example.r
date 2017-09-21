#' ---
#' author: "Karl Edwards"
#' output:
#'   html_document:
#'     keep_md: TRUE
#' ---

#'Style adapted from http://stat545.com/bit006_github-browsability-wins.html#source-code

#+ setup, include = FALSE
#' General
require( rgl )
require( ggplot2 )
require( grid )
require( gridExtra )
require( purrr )
require( tibble )
require( lattice )

#+ specific, include = TRUE
filename <- 'stereolithograph.stl'
x_axis         <- 1
y_axis         <- 2
z_axis         <- 3
axes           <- 1:3
axes[ x_axis ] <- 'x'
axes[ y_axis ] <- 'y'
axes[ z_axis ] <- 'z'

stripe_width   <- 0.0003
stripe_tol     <- 0.00003

#' Note: this HTML is made by applying `knitr::spin()` to an R script. So the
#' narrative is very minimal.

[SUGGEST an edit to this page!](https://github.com/KarlEdwards/Photogrammetric-Potsherd-Profile/edit/master/example.md)
