

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, crayon, geodata, fs, tidyverse, glue)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Download ----------------------------------------------------------------

cntr <- 'PER'
dir.create('../tmpr')
limt <- geodata::gadm(country = cntr, level = 0, path = '../tmpr')

# To download 
vars <- c('prec', 'tmax', 'tmin', 'tavg', 'bio')

trra <- purrr::map(.x = 1:length(vars), .f = function(i){
  
  cat(bgGreen('Start ', i, '\n'))
  var <- vars[i]
  rstr <- geodata::worldclim_country(country = cntr,
                                     var = var,
                                     path = '../tmpr')
  
  rstr <- terra::crop(rstr, limt)
  rstr <- terra::mask(rstr, limt)
  
  cat('Done!\n')
  return(rstr)
  
  
})


# To write the results ----------------------------------------------------

dout <- '../raster/wc21/'
dir_create(dout)

# Precipitation
terra::writeRaster(x = trra[[1]], filename = glue('{dout}/prec.tif'))

# T max 
terra::writeRaster(x = trra[[2]], filename = glue('{dout}/tmax.tif'))

# T min 
terra::writeRaster(x = trra[[3]], filename = glue('{dout}/tmin.tif'))

# T avg 
terra::writeRaster(x = trra[[4]], filename = glue('{dout}/tavg.tif'))

# Bioclimatic variables
terra::writeRaster(x = trra[[5]], filename = glue('{dout}/bioc.tif'))



# To write en ascii -------------------------------------------------------

# Prec, tmax, tmin, tavg
for(i in 1:12){
  
  terra::writeRaster(x = trra[[1]][[i]], filename = glue('{dout}/prec_{i}.asc'))
  terra::writeRaster(x = trra[[2]][[i]], filename = glue('{dout}/tmax_{i}.asc'))
  terra::writeRaster(x = trra[[3]][[i]], filename = glue('{dout}/tmin_{i}.asc'))
  terra::writeRaster(x = trra[[4]][[i]], filename = glue('{dout}/tavg_{i}.asc'))
  
}


# Bioclim
for(i in 1:19){
  
  terra::writeRaster(x = trra[[1]][[i]], filename = glue('{dout}/bioc_{i}.asc'))
  
}




























