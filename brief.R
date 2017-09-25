#' ---
#' output:
#'   html_document:
#'    toc: true
#'    highlight: tango
#'    keep_md: TRUE
#'    fig_caption: yes
#' ---

#+ demo, echo = TRUE, include = TRUE
#' ### End of YAML header
#' <br>
limits <- c( 0, 1 )

# Style adapted from http://stat545.com/bit006_github-browsability-wins.html#source-code
#
# TO RENDER THIS AS HTML:
#   setwd( '~/Dropbox/Projects/Potsherd/example' )
#   library('rmarkdown')
#   rmarkdown::render('demonstration.R')

#+ setup, echo = TRUE, include = TRUE
#' ### START HERE
#' # Configuration