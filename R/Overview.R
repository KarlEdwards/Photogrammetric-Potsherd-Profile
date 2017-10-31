#' ---
#' title: "Photogrammetric Potsherd Profiling"
#' subtitle: "Based on An implementation in R Markdown, by JJ Allaire and Yihui Xie"
#' author: "Karl Edwards"
#' header-includes:
#' date: "`r Sys.Date()`"
#' output:
#'   tufte::tufte_handout:
#'     citation_package: natbib
#'     latex_engine: xelatex
#'     toc: TRUE
#'     toc_depth: 1
#'   tufte::tufte_book:
#'     citation_package: natbib
#'     latex_engine: xelatex
#'   md_extensions: +fancy_lists+hard_line_breaks
#' link-citations: yes
#' ---

#+ notes, echo=FALSE
# setwd( '~/Dropbox/Projects/Potsherd/example' )

#+setup, include=FALSE
library(tufte)
# invalidate cache when the tufte version changes
knitr::opts_chunk$set(tidy = FALSE, cache.extra = packageVersion('tufte'))
options(htmltools.dir.version = FALSE)
library( png )

#+ source_functions, echo = FALSE, include = FALSE
# Load Functions
source( './R/functions_basic.R' )
source( './R/functions_slicing.R' )
source( './R/functions_contour.R' )
source( './R/cache_viewpoint.R' )
source( './R/configuration.R' )
source( './R/cache_model.R' )
source( './R/profile_to_wireframe.R' )
source( './R/critical_points.R' )

#+
#' ***

#+
#' \newthought{Abstract}
#+
#' An archaeologist lamented the fact that students having any interest in programming typically go off to study computer science.
#' At the same time, students who are fully committed to archaeology have neither the interest nor the capacity to develop the types of computational tools that would speed up the tedious, repetetive aspects of archaeological practice.
#' Perhaps specialists, in collaboration with generalists, can accomplish more together than either could accomplish alone.
#' For example, imagine how useful it would be to leverage recent advances in photogrammetry and machine learning for the purpose of more quickly and accurately measuring a batch of objects and arranging them into a provisional hierarchy.
#' This article describes a simple method for photographing pottery vessels and for turning those photographs into 3-D models, from which we derive characteristic measurements that will be useful in the evaluation of object similarity, and, ultimately, classification.
#' The example includes fully-annotated __R__ code for manipulating the modeled object in space, obtaining cross-sections, and calculating characteristic quantities.
#'  Subsequent articles will describe how to quantify similarity between objects, present a principled method for determining feature importance, and suggest an iterative process for generating provisional archetypes and resolving any resulting mis-classifications.

#' \newpage
#+
#' # Related Work

#+
#' ## Photogrammetry Using Photoscan^[ Photoscan is available at [(http://www.agisoft.com)](http://www.agisoft.com)]
#' Bj&ouml;rn K. Nilssen^[ SketchUp with PhotoScan plugin [(http://bknilssen.no/X/Photogrammetry/)](http://bknilssen.no/X/Photogrammetry/)] combines photography with minimal manual modeling to create 3D models from of very large objects, such as sculptures and buildings.
#' The Poor Man's Guide To Photogrammetry^[ Poor Man's Guide [(http://bertrand-benoit.com/blog/the-poor-mans-guide-to-photogrammetry/)](http://bertrand-benoit.com/blog/the-poor-mans-guide-to-photogrammetry/)] illustrates in great detail the modeling of small objects.

#+
#' ## Open Source Photogrammetry
#'For more control over the modeling process, the artist, Gleb Alexandrov, presents a photo scanning workflow based on open source projects VisualSFM^[ Visual Structure From Motion, by Changchang Wu[(http://ccwu.me/vsfm/)](http://ccwu.me/vsfm/)], Meshlab^[Meshlab, the open source system for processing and editing 3D triangular meshes [(http://www.meshlab.net)](http://www.meshlab.net)], and Blender.^[ Blender, an open source 3D creation suite [(https://www.blender.org)](https://www.blender.org)]

#+
#' ## Photogrammetry for Archeology
#' The nonprofit corporation, chi^[[ Cultural Heritage Imaging ](http://culturalheritageimaging.org/Technologies/Photogrammetry/)], demonstrates photogrammetry in the field of cultural heritage.
#' The Archaeology Data Service at University of York has published a number of Guides to Good Practice, including Close-Range Photogrammetry: A Guide to Good Practice.^[ Guides to Good Practice [(http://guides.archaeologydataservice.ac.uk/g2gp/Photogram_2-1)](http://guides.archaeologydataservice.ac.uk/g2gp/Photogram_2-1)]
#' Potsherd: Atlas of Roman Pottery^[ http://potsherd.net/atlas,  P A Tyers, Sherd Scanning Advice [(http://potsherd.net/atlas/topics/scanning)](http://potsherd.net/atlas/topics/scanning)] recommends CCD flatbed scanning for small, flat objects.

#+
#' ## Machine Learning for Archeology
#' A group of German researchers^[[ H&ouml;rr, Lindinger, and Brunnett, in __Machine Learning Based Typology Development in Archaeology__](https://www.researchgate.net/publication/261961185_Machine_learning_based_typology_development_in_archaeology)] describe how, using measurements obtained from a 3D-scanner, they have classified nearly 600 clay vessels from a Bronze-Age site in Saxony. Beginning with a pair-wise analysis of morphological features, they explain how to assess similarity between pairs of artifacts, and then find clusters of similar items. In the second phase, they develop a rational approach to calculating feature importance. Then they alternate between describing archetypes and classifying the artifacts using those preliminary definitions, adjusting the typology until the complete hierarchy emerges. 

#' \newpage
#+
#' # Photography

#' ## You will need:

#' * One or more potsherds to measure
#' * Location with plenty of natural light. See [photography guidelines](https://homes.esat.kuleuven.be/~visit3d/webservice/v2/manual3.php#SEC2)
#' * Work table
#' * Camera
#' * Tripod
#' * Turntable
#' * Dark background

#+
#' ## Prepare the photography area as follows:

#+ margin_fig1, fig.margin = TRUE, fig.cap = "Using a Turntable", fig.width=3.5, fig.height=3.5, echo = FALSE, cache = FALSE
grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'illustration_stage.png' ) ) )

#' * Put dark paper or cloth under and behind the turntable to serve as a backdrop
#' * Adjust the height of the camera on the tripod so the center of the lense is at the same height as the center of the artifact to be photographed

#+
#' ## Photograph each artifact

#' * Place the pot (or potsherd) on the turntable.

#' * Even though the accompanying photo does not illustrate this, prop the artifact so that the rim of the pot is parallel to the turntable (Rim up or rim down is not so important)

#+ margin_fig2, fig.margin = TRUE, fig.cap = "Every Ten Degrees", fig.width=3.5, fig.height=3.5, echo = FALSE, cache = FALSE
grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'every_ten_degrees.png' )) )

#' * To minimize distortion, place the artifact so that the center of the rim (or base) is approximately on the center of the turntable
#' * Take a series of photographs at roughly 10-degree intervals, resulting in 36 images per artifact

#' \newpage
#+
#' # Model Creation

#+
#' ## image files --> textured mesh --> stereolithography

#+
#' \newthought{The basic workflow} is: (1) Take photographs from various perspectives, (2) Convert the photographs into a 3-Dimensional model, and, (3) since the model arrives as a textured mesh, convert it to stereolithography

#+
#' ## Image Files --> Textured Mesh
#' * Upload images to ARC3D^[ If you are not already an ARC3D user, apply for a free account at [ https://homes.esat.kuleuven.be/~visit3d/webservice/v2/request_login.php ](https://homes.esat.kuleuven.be/~visit3d/webservice/v2/request_login.php) ] web service
#+ margin_fig31, fig.margin = TRUE, fig.cap = "Textured Mesh Model", fig.width=3.5, fig.height=3.5, echo = FALSE, cache = FALSE
grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'model.png' )) )
#' * Pour yourself a cup of coffee
#' * In a few minutes to a few hours, if all goes well, ARC3D will send you a textured mesh object

#+
#' ## Textured Mesh --> Stereolithography
#+
#' Enter the following command into a terminal window:

#+
#' `./meshconv textured_mesh.obj -c stl -o stereolithograph`


#+
#' This tells the conversion utility^[ The *meshconv* utility is available at [(http://www.patrickmin.com/meshconv/)](http://www.patrickmin.com/meshconv/)] three things:
#+
#' #. The object to use as input: *textured_mesh.obj*,
#' #. The action(s) to perform: convert to stereolithography format [ **-c stl** ],
#' #. Where to put the results: in a file called **-o stereolithograph[.stl]**

#' \newpage
#+
#' # Cross-Sectioning
#+
#' \newthought{The basic idea} is to (1) orient the model squarely in the reference frame, (2) estimate the location of the center of the vessel, (3) extract relevant characteristics and dimensions from the profile.

#+ get_raw_data, echo = FALSE, cache = FALSE
STEREOLITHOGRAPHY_FILE %>%
  load_data() -> raw_data
     make_model( raw_data ) -> model

#+ show_initial_view, echo = FALSE, include = FALSE, cache = FALSE
# Push the model into the corner where the three axes meet
offset <- apply( model$get(), 2, min )      # How far from each wall?
model$move_right_left(   -offset[ 'x' ] )  # Remove the offset
model$move_up_down(    -offset[ 'y' ] )     # and push the model
model$move_forward_backward( -offset[ 'z' ] )        # into the corner.
model$rotate_on( ax='z', angle = -10 )
model$rotate_on( ax='y', angle = -20 )
model$rotate_on( ax='x', angle = -30 )
offset <- apply( model$get(), 2, min )      # How far from each wall?
model$move_right_left(    -offset[ 'x' ] )  # Remove the offset
model$move_up_down(    -offset[ 'y' ] )      # and push the model
model$move_forward_backward( -offset[ 'z' ] ) # into the corner.

# Save images of multiple views of the model in multiple files
filenames_before <- 41:43 %>% paste0( 'view_', . ) %>% as.list()
pwalk(
    list(
        STANDARD_VIEWS
      , filenames_before
    )
  , function( y, z ) make_figure( fun = model$show, args = list( y ), file_name = z )
)

#+
#' ## A. Align Model With Reference Frame

#' To find the best orientation for the model of the sherd, begin by measuring the extent of the model along each axis, and calculating the product of these dimensions. Then tilt the model slightly, recalculate the volume, and repeat until finding the minimum. 

#+ before_alignment, echo=FALSE, include=TRUE
#' Initially, the object requires a box volume of at least `r box_size()` units.
#+

#+ alignment41, echo=FALSE, include=FALSE
# Align the model in the reference frame
axes %>% # Tilt on each axis in turn
  map_dbl( ~smallest_box( ., tilt_degrees=5 ) )

# Align the model in the reference frame
axes %>% # Tilt on each axis in turn
  map_dbl( ~smallest_box( ., tilt_degrees=1 ) )

# Push the model into the corner where the three axes meet
#+ fix_rim, echo = FALSE, include = FALSE, cache = FALSE
offset <- apply( model$get(), 2, min )      # How far from each wall?
model$move_right_left(   -offset[ 'x' ] )        # Remove the offset
model$move_up_down(    -offset[ 'y' ] )        # and push the model
model$move_forward_backward(-offset[ 'z' ] )        # into the corner.

# Save images of multiple views of the model in multiple files
filenames_after <- 44:46 %>% paste0( 'view_', . ) %>% as.list()
pwalk(
    list(
        STANDARD_VIEWS
      , filenames_after
    )
  , function( y, z ) make_figure( fun = model$show, args = list( y ), file_name = z )
)

#+ before_after, echo=FALSE, include=TRUE
# Include multiple figures all in one go
multi_view( filenames_before )
#' After alignment with the reference frame, the box is `r box_size()` units.
#+ after_alignment, echo=FALSE, include=TRUE
multi_view( filenames_after )

#+
#' ## B. Locate the Center of the Vessel
#' #. Extract a thin slice from the model, parallel with each axis
#' #. One of the resulting cross-sections should be roughly circular.
#' #. We will use this to estimate the center of the vessel and orientation of the axis of rotation

#+ partB, echo = FALSE, include = FALSE, cache = FALSE
# Duplicate the model, once for each axis
models <- list()
models <- map( 1:6, ~make_model( model$get() ))

# Slice through the middle three ways
# (once in each model)
mids <- model$calculate( f = get_midpoint )
walk( 1:3, ~models[[ . ]]$get_band( ax=., ctr = mids[ . ], thickness = 4*STRIPE_WIDTH ))

#+ sliced_x, echo = FALSE, include = FALSE, cache = FALSE
# Save images of multiple views of the model in multiple files
filenames_slice_x <- 47:49 %>% paste0( 'view_', . ) %>% as.list()
which_model <- 1
pwalk(
    list(
        list( which_model, which_model, which_model )
      , STANDARD_VIEWS
      , filenames_slice_x
    )
  , function( x, y, z ) make_figure( fun = models[[ x ]]$show, args = list( y ), file_name = z )
)
illustrate_slice_centers( models, which_model, file_name='slice_x' ) # Show the slice with estimated center and radii

#+ sliced_y, echo = FALSE, include = FALSE, cache = FALSE
filenames_slice_y <- 50:52 %>% paste0( 'view_', . ) %>% as.list()
which_model <- 3
pwalk(
    list(
        list( which_model, which_model, which_model )
      , STANDARD_VIEWS
      , filenames_slice_y
    )
  , function( x, y, z ) make_figure( fun = models[[ x ]]$show, args = list( y ), file_name = z )
)
illustrate_slice_centers( models, which_model, file_name='slice_y' ) # Show the slice with estimated center and radii

#+ sliced_z, echo = FALSE, include = FALSE, cache = FALSE
filenames_slice_z <- 53:55 %>% paste0( 'view_', . ) %>% as.list()
which_model <- 2
pwalk(
    list(
        list( which_model, which_model, which_model )
      , STANDARD_VIEWS
      , filenames_slice_z
    )
  , function( x, y, z ) make_figure( fun = models[[ x ]]$show, args = list( y ), file_name = z )
)
illustrate_slice_centers( models, which_model, file_name='slice_z' ) # Show the slice with estimated center and radii

#+ sliced_show, echo = FALSE, include = FALSE
# Which cross section is most nearly circular?
# By subtracting the estimated radius, in red, from the edge of the vessel, in black, we can see how far each cross section is from being circular. The one with the smallest difference must be a view of the vessel as seen from the top, with the vessel axis of rotation being located at the red dot.
#multi_view( filenames_slice_x )       # Show the slice from three perspectives
#multi_view( filenames_slice_y )       # Show the slice from three perspectives
#multi_view( filenames_slice_z )       # Show the slice from three perspectives
#grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'slice_x.png' ) ) )
#grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'slice_y.png' ) ) )
#grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'slice_z.png' ) ) )


#+ show_slices, echo = FALSE, include = TRUE, cache = FALSE
multi_view(                           # Show the three slices with estimated centers
  list( 'slice_x', 'slice_y', 'slice_z' )
)

#' \newpage

#+
#' ## C. Re-Section 

#+ section_C, echo = FALSE, include = FALSE
base_name <- 'section_C'

# Make three more copies of the model
#models <- list()
#models <- map( 1:3, ~make_model( model$get() ))
models[[ 1 ]] <- make_model( models[[ 4 ]]$get() )
models[[ 2 ]] <- make_model( models[[ 5 ]]$get() )
models[[ 3 ]] <- make_model( models[[ 6 ]]$get() )

ax <- 2

#' Taking the roundest cross-section as the top view and then re-sectioning the model through the vessel's axis of rotation results in a profile of the pot. In order to get the most information, cut at the tallest ( widest, as shown here ) portion of the sherd.

#+ section_C1, echo = FALSE, include = TRUE
# model ax + 3 is a shadow of model ax that we can manipulate ( or destroy ) without consequence 
models[[ ax + 3 ]]$show(
    viewpoint( list( theta= 180, phi=   5, fov=0, zoom=1 ))
  , lims = c( -1, 1 ), size = 0.8
) 
axes3d( edges = 'y' )
grid3d( side  = 'z' )
segments3d( x=c(0, 0.6), y=c(0.9, 0.9), z=c(0,0), color='red' )
rgl.snapshot( filename = paste0( FIGURES_PATH, 'margin_fig_measure_1', '.png' ))

#+ margin_fig_measure_1, fig.margin = TRUE, fig.cap = "Where to cut?", fig.width=3.5, fig.height=3.5, echo = FALSE, cache = FALSE
grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'margin_fig_measure_1.png' ) ) )


#+
#' # Measurement
#' 


#+ measurement_1, echo = FALSE, include = FALSE
thin_slice <- micro_slice( base_name, models, ax )

#+ show_thin, echo = FALSE, include = FALSE
# Show the resulting profile

# Establish plot limits
boundaries <- plot_limits( thin_slice )
plot_limit_lo <- boundaries[ 1 ]
plot_limit_hi <- boundaries[ 2 ]

#+ find_extrema, echo = FALSE
keep_axes <- axes[ -ax ]
df <- thin_slice[ , keep_axes ]
df <- unique( df[ order( df[ , 1 ] ), ] )
df <- df[ df[ , 1 ] > plot_limit_lo & df[ , 1 ] < plot_limit_hi, ]
extrema <- critical_points( df, 0.001 )
extrema <- extrema[ extrema[ , 'direction' ] %in% 'ridge', ]

p <- ggplot( df, aes_string( x = keep_axes[ 2 ], y = keep_axes[ 1 ] )) +
  geom_point() +
  expand_limits( x = plot_limit_hi , y = plot_limit_hi )

u <- ( seq( nrow(extrema)) %>%
  map( ~geom_hline( yintercept = extrema[ ., 1 ], colour = 'red', linetype=2) ) )
v <- ( seq( nrow(extrema)) %>%
  map( ~geom_vline( xintercept = extrema[ ., 2 ], colour = 'red', linetype=2) ) )

# Two of the ridges have nearly the same radius;
# suppress the label for one to make the other label visible
HIDE_CLOSE_LABELS <- c( 1, 3 ) 

g <- round( extrema[ , 1 ], 3 )
breaks_y <- g - g[ 1 ]
h <- sort( round( extrema[ , 2 ], 3 ))
breaks_x <- h[ 3 ] - h
breaks_x <- breaks_x[ 1 ]

#+ show_sliver, echo = FALSE, include = TRUE
# _____ Begin Plotting _____
png( paste0( FIGURES_PATH, 'dimensioned_profile.png' ))
p + u + v +
  xlab( 'Radius   [ mm ]' ) +
  ylab( 'Height   [ mm ]' ) +
  theme(
    axis.title = element_text(
      colour = "darkblue"
      , size = 24
      , angle = 0
    )
  , axis.line = element_line(
        colour = "darkblue"
      , size = 1
      , linetype = "solid"
    )
  , axis.text = element_text(
      colour = "darkblue"
    , size = 14
    , angle = 0
  )
) +
  scale_y_continuous( 
      breaks = c( 0, round( extrema[ , 1 ], 3 ) )
    , labels = c( 0, round( SCALE_FACTOR * breaks_y, 0 ))
  ) +
  scale_x_continuous(
      breaks = c( 0, round( extrema[ HIDE_CLOSE_LABELS, 2 ], 3 ))
    , labels = c( '', round( SCALE_FACTOR * breaks_x, 0 ), 0 )
  )

dev.off()
# _____ End Plotting _____


grid::grid.raster( readPNG( paste0( FIGURES_PATH, 'dimensioned_profile.png' ) ) )

#' \newpage
#+
#' # Conclusion
#+
#' ## A. Summary
#' This document describes in some detail the steps to photograph a potsherd and generate a mathematical model from the resulting images, and, in much less detail, suggests how to automatically measure to object represented by the model. The R source code is available on github and an R package is will be available soon. A number of simplifications, described below, accelerated this initial draft.

#+
#' ## B. Item-Specific Configuration
#' * Scaling to Real-World Units
#' The process of selecting a scale factor will most likely need to be automated for measurement of multiple objects, since the relationship between model units and real-world units may depend on factors that were not tightly controlled, such as the distance between camera and object.
#+
#' * Manual Selection of Cross-Section Axis
#' The example suggests that knowing the orientation of the most nearly circular cross-section tells us which reference axis, X, Y, or Z, is the axis of rotation for the vessel. The illustration of measurement uses a manually-selected orientation; This selection will need to be automated.
#+
#' * Fragility of Dimensioning Process
#' Since the process has been applied to a single example, it is almost certain that object-specific assumptions have been included inadvertently in the calculations. The only way to identify and purge such assumptions is to apply the process to a variety of objects, evaluate the performance, and make refinements.
#+
#' * Photographic Procedure
#' Similarly, the photographic procedure has been used by only one person on only one object, and would benefit from being exposed to more rigorous evaluation.
#+
#' ## C. Next Steps
#'

#+
#' [ ] Solicit feedback on clarity of photographic instructions
#+
#' [ ] Test the photographic procedure on a small number of artifacts
#+
#' [ ] Test and refine the measurement functions
#+
#' [ ] Create an R package and associated vignette

#' #