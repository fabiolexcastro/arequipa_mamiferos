
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

# Download administrative limits
peru <- gadm(country = 'PER', level = 1, path = '../tmpr')
peru
plot(peru)
areq <- peru[peru$NAME_1 == 'Arequipa',]
plot(areq, add = TRUE, col = 'red')

# Masking for arequipa
areq_ndvi <- terra::crop(rstr[[3]], areq)
areq_ndvi <- terra::mask(areq_ndvi, areq)
plot(areq_ndvi)
mask <- area_ndvi * 0 + 1

# Create a empty raster -----
resolution <- 0.00083333
ext <- terra::ext(mask)
naraster <- terra::rast(terra::ext(mask), ncols = (diff(ext[1:2]/resolution)), nrow = (diff(ext[3:4]/resolution)))
x <- setValues(naraster, 1:ncell(naraster))
x
values(x) <- runif(ncell(x))
x
plot(x)
x <- terra::crop(x, areq) %>% terra::mask(., areq)
plot(x)
values(x) <- 1
plot(x)
x <- terra::crop(x, areq) %>% terra::mask(., areq)
plot(x)

ndvi_peru_100m <- terra::resample(areq_ndvi, x)
ndvi_areq_100m <- terra::mask(areq_ndvi, areq)
ndvi_areq_100m
plot(ndvi_areq_100m)

terra::writeRaster(x = ndvi_areq_100m, filename = '../ndvi_clases_scale/ndvi_arequipa_100m.asc', overwrite = T)


