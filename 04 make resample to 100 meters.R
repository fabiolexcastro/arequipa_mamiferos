
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
mask <- rstr[[1]] * 0

# Create a empty raster ---------------------------------------------------
resolution <- 0.00083333
ext <- terra::ext(mask)
naraster <- terra::rast(terra::ext(mask), ncols = (diff(ext[1:2]/resolution)), nrow = (diff(ext[3:4]/resolution)))
x <- setValues(naraster, 1:ncell(naraster))
x
values(x) <- runif(ncell(x))
x
plot(x)

