#######################################################
########### Example: Get MODIS NDVI data ##############
#######################################################
# This script shows how MODIS NDVI data can be processed using the MODIStsp package and manual R functions.
# MODIStsp: calibration etc., see http://ropensci.github.io/MODIStsp/index.html.
# Manual processing in R: crop to AOI, further NDVI value processing, crop to CLC forest classes, plotting.
#######################################################
#######################################################

# install + activate packages
install.packages("MODIStsp")
install.packages("raster")
install.packages("rgdal")
install.packages("ggplot2")
install.packages("gWidgetsRGtk2")

library(MODIStsp)
library(raster)
library(rgdal)
library(ggplot2)
library(gWidgetsRGtk2)

### process MODIS files using MODIStsp-package ###

## option 1: use MODIStsp's Graphical User Interface
MODIStsp(gui=TRUE,options_file)

## option 2: use available json-file
# needs to be modified depending on used product and desired processing steps
json_path <- "C:/Users/.../my_json_file.json"
MODIStsp(gui=FALSE,options_file = json_path)


### further processing in R ###

# load downloaded NDVI raster stack
path_ndvi <- "C:/Users/.../my_stack.RData"
ts_ndvi <- get(load(path_ndvi))
names(ts_ndvi) <- substr(names(ts_ndvi),9,21) # rename layers to shorter version

## crop to area of interest (AOI) ##

# load shapefile with AOI = cropping extent
path_aoi <- "C:/Users/.../my_folder" # without file name
name_aoi <- "my_aoi_shp" # without .shp

aoi <- readOGR(path_aoi,layer=name_aoi)
aoi <- spTransform(aoi,CRS(proj4string(ts_ndvi))) # reproject AOI to same CRS as rasterStack

# plot AOI extent on NDVI product
plot(ts_ndvi[[1]])
plot(aoi,add=T)

# crop stack to extents of AOI
ts_ndvi <- crop(ts_ndvi,extent(aoi))

# mask rasterStack to AOI
ts_ndvi <- mask(ts_ndvi,aoi)

## process NDVI values ##

# convert to actual NDVI values
ts_ndvi <- ts_ndvi/10000

# delete low values which are most probably snow or settlements (NDVI < 0.25)
ts_ndvi[ts_ndvi<0.25] <- NA

## select only pixels with forest cover ##
# based on Corine Land Cover (CLC) 2012 (classes broad-leaved, coniferous, mixed forest)
# get CLC data + info here: https://land.copernicus.eu/pan-european/corine-land-cover
# optional processing and needs to be modified depending on observed crops/land cover

# read CLC shape file
path_clc <- "C:/Users/.../my_path" # without file name
name_clc <- "my_CLC_shp" # without .shp

clc <- readOGR(path_clc,name_clc)
clc <- spTransform(clc,CRS(proj4string(ts_ndvi)))

# select relevant CLC classes (here: forest classes)
clc <- clc[clc$code_12==311 | clc$code_12 == 312 | clc$code_12 == 313,]

# mask NDVI raster stack
ts_ndvi <- mask(ts_ndvi,clc)

## plot ##
plot(ts_ndvi[[1]])
plot(aoi,add=T)
plot(clc,add=T)

