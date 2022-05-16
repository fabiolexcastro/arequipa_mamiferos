

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

purrr::map(.x = 1:length(vars), .f = function(i){
  
  cat(bgGreen('Start ', i, '\n'))
  var <- vars[i]
  
  rstr <- geodata::worldclim_country(country = cntr,
                                     var = var,
                                     path = '../tmpr')
  
  rstr <- 
  
  
})




























