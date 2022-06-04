
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, crayon, geodata, fs, tidyverse, glue)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Load data ---------------------------------------------------------------
path <- '../ndvi_clases_scale'
fles <- dir_ls(path, regexp = '.tif') %>% as.character()

rstr <- purrr::map(.x = fles, .f = terra::rast)

