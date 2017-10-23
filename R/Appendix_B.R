#' ---
#' title: "Appendix B: Model Functions"
#' author: ""
#' header-includes:
#' date: ""
#' output:
#'   tufte::tufte_handout:
#'     citation_package: natbib
#'     latex_engine: xelatex
#'     toc: FALSE
#'   tufte::tufte_book:
#'     citation_package: natbib
#'     latex_engine: xelatex
#'   md_extensions: +fancy_lists+hard_line_breaks
#' link-citations: no
#' ---

#+ notes, echo=FALSE
#
# setwd( '~/Dropbox/Projects/Potsherd/example' )
#
# invalidate cache when the tufte version changes
knitr::opts_chunk$set(
    eval = FALSE
  , echo = TRUE
  , include=TRUE
  , tidy = FALSE
  , cache.extra = packageVersion('tufte')
)
options( htmltools.dir.version = FALSE )
library( png )
# ------ Beginning of Document ------
#+
#' ***
#+ r, code=readLines( './R/cache_model.R' )
#+
#' ***
