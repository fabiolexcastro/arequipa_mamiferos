

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

# Getting for each country ------------------------------------------------
chle <- grep('chile', fles, value = T)
chle

