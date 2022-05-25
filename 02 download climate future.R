
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, crayon, geodata, fs, tidyverse, glue)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Download ----------------------------------------------------------------
ssps <- c('ssp370')
prds <- '2081-2100'
mdls <- c("ACCESS-CM2", "ACCESS-ESM1-5", "AWI-CM-1-1-MR", "BCC-CSM2-MR", "CanESM5", "CanESM5-CanOE", "CMCC-ESM2", "CNRM-CM6-1", "CNRM-CM6-1-HR", "CNRM-ESM2-1", "EC-Earth3-Veg", "EC-Earth3-Veg-LR", "FIO-ESM-2-0", "GFDL-ESM4", "GISS-E2-1-G", "GISS-E2-1-H", "HadGEM3-GC31-LL", "INM-CM4-8", "INM-CM5-0", "IPSL-CM6A-LR", "MIROC-ES2L", "MIROC6", "MPI-ESM1-2-HR", "MPI-ESM1-2-LR", "MRI-ESM2-0", "UKESM1-0-LL")
base <- 'https://geodata.ucdavis.edu/cmip6/tiles/'
vars <- c('prec', 'tmax', 'tmin')

# Limit
cntr <- 'PER'
dir.create(cntr)
limt <- geodata::gadm(country = cntr, level = 0, path = '../tmpr')
plot(limt)

terra::writeVector(limt, '../shp/peru.shp')

isoc <- country_codes()
isoc <- as_tibble(isoc)
filter(isoc, NAME == 'Chile')


# To make the function ----------------------------------------------------
download <- function(ssp, mdl, prd, var){
  
  cat('To download the climate change data\n')
  path <- glue('{base}/{mdl}/{ssp}/wc2.1_30s_{var}_{mdl}_{ssp}_{prd}_tile-40.tif')
  dout <- glue('../raster/future/cm6/tile/{ssp}/{mdl}/{prd}')
  ifelse(!file.exists(dout), dir_create(dout), print('Exists'))
  dout <- glue('{dout}/{basename(path)}')
  download.file(url = path, destfile = dout, mode = 'wb')
  
  cat('To make the extract by mask\n')
  fles <- dir_ls(dirname(dout))
  fles <- as.character(fles)
  print(fles)
  
  
  
}



# To apply the function ---------------------------------------------------

# Proof
ssp <- ssps[1]
mdl <- mdls[1]
prd <- prdo[1]
var <- vars[1]

# Loop



purrr::map(.x = 1:length(ssp), .f = function(i){
  
  purrr::map(.x = 1:length(prdo), .f = function(j){
    
    purrr::map(.x = 1:length(mdls), .f = function(k){
      
      purrr::map(.x = 1:length(vars), .f = function(v){
        
        ssp <- ssps[i]
        prd <- prds[j]
        mdl <- mdls[k]
        var <- vars[v]
        
        pth1 <- glue('{base}/{mdl}/{ssp}/wc2.1_30s_{var}_{mdl}_{ssp}_{prd}_tile-40.tif')
        dout <- glue('../raster/future/cm6/tile/{ssp}/{mdl}/{prd}')
        ifelse(!file.exists(dout), dir_create(dout), print('Exists'))
        dout <- glue('{dout}/{basename(pth1)}')
        download.file(url = pth1, destfile = dout, mode = 'wb')
        
        # To make the extract by mask for the country
        rst1 <- terra::rast(dout)
        rst1 <- terra::crop(rst1, limt)
        rst1 <- terra::mask(rst1, limt)
        
        # To write these raster 
        dout <- glue('../raster/future/cm6/peru/{ssp}/{mdl}/{prd}')
        ifelse(!file.exists(dout), dir_create(dout), print('Already exists'))
        
        purrr::map(.x = 1:12, .f = function(l){
          cat(month.abb[l], '\t')
          dout <- glue('{dout}/{var}_{l}.asc')
          terra::writeRaster(rst1[[l]], dout, overwrite = TRUE)
          cat('Write...!\n')
        })

      })
      
    })
    
  })
  
})






