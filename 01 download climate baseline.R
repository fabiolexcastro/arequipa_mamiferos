

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, glue)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Download ----------------------------------------------------------------

cntr <- 'PER'
dir.create('../tmpr')
limt <- geodata::gadm(country = cntr, path = '../tmpr')


