

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
rstr <- purrr::map(.x = 1:length(fles), .f = function(i){
  
  # To read as a raster the files
  cat(fles[i], '\n')
  fle <- fles[i]
  rst <- terra::rast(fle)
  rst
  scl <- terra::scale(rst)
  scl
  tbl <- terra::as.data.frame(scl, xy = TRUE)
  tbl <- as_tibble(tbl)
  head(tbl)
  
  # Negative values
  tbl_neg <- filter(tbl, NDVI < 0)
  tbl_neg <- mutate(tbl_neg, NDVI = NDVI * -1)
  tbl_neg <- mutate(tbl_neg, NDVI_scale = (NDVI - min(NDVI)) / (max(NDVI) - min(NDVI)))
  tbl_neg <- mutate(tbl_neg, NDVI_scale = NDVI_scale * -1)
  hist(tbl_neg$NDVI_scale, main = 'Hist negative values')
  
  # Positive values
  tbl_pos <- filter(tbl, NDVI > 0)
  tbl_pos <- mutate(tbl_pos, NDVI_scale = (NDVI - min(NDVI)) / (max(NDVI) - min(NDVI)))
  hist(tbl_pos$NDVI_scale, main = 'Hist negative values')
  
  # Join the previous tibbles into only one
  tbl_all <- rbind(tbl_neg, tbl_pos)
  tbl_all <- dplyr::select(tbl_all, x, y, NDVI_scale)
  rst <- terra::rast(tbl_all, type = 'xyz')
  rst
  cat('Done!\n')
  return(rst)
  
})

# Checking the results
plot(rstr[[1]]) # Chile
plot(rstr[[2]]) # Ecuador
plot(rstr[[3]]) # Peru

# To make the rscale -----------------------------------------

# Plotting spatial data
plot(chle)

mask_chle <- geodata::worldclim_tile(var = 'prec', lon = -75, lat = -40, path = '../tmpr')
mask_chle <- terra::crop(mask_chle, chle) %>% terra::mask(., chle)
plot(chle); plot(mask_chle, add = TRUE, border = 'blue')

plot(mask_chle[[1]])
mask_chle <- mask_chle[[1]] * 0 
plot(mask_chle)

mask_ecu1 <- geodata::worldclim_tile(var = 'prec', lon = -76, lat = 1, path = '../tmpr')
mask_ecu1 <- terra::crop(mask_ecu1, ecua) %>% terra::mask(., ecua)
plot(mask_ecu1[[1]])
mask_ecu1 <- mask_ecu1[[1]] * 0

mask_ecu2 <- geodata::worldclim_tile(var = 'prec', lon = -80, lat = -5, path = '../tmpr')
mask_ecu2 <- terra::crop(mask_ecu2, ecua) %>% terra::mask(., ecua)
mask_ecu2 <- mask_ecu2[[1]] * 0

mask_ecua <- mosaic(mask_ecu1, mask_ecu2)
plot(mask_ecua)

mask_peru <- geodata::worldclim_tile(var = 'prec', lon = -75, lat = -10, path = '../tmpr')
mask_peru <- terra::crop(mask_peru, peru) %>% terra::mask(., peru)
mask_peru <- mask_peru[[1]] * 0

# Chile -----------------
terra::crs(rstr[[1]]) <- terra::crs(mask_chle)
rstr[[1]] <- terra::resample(rstr[[1]], mask_chle)
rstr[[1]]
plot(rstr[[1]])





# To make the mosaic ------------------------------------------









