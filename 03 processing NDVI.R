

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
plot(rstr[[1]])
plot(rstr[[2]])
plot(rstr[[3]])






