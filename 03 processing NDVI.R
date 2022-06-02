

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, crayon, geodata, fs, tidyverse, glue)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Load data ---------------------------------------------------------------
path <- '../ndvi_clases'
fles <- dir_ls(path, regexp = '.tif$')
fles <- as.character(fles)

# To make the scaling -----------------------------------------------------

i <- 1

rstr <- purrr::map(.x = 1:length(fles), .f = function(i){
  
  # To read as a raster the files
  cat(fles[i], '\n')
  fle <- fles[i]
  rst <- terra::rast(fle)
  plot(rst)
  
  
  cat('Done!\n')
  
})


