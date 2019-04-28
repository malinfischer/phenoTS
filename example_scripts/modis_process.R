#######################################################
########### Example: Get MODIS NDVI data ##############
#######################################################
# This script shows how MODIS NDVI data can be processed using the MODIStsp package and manual R functions.
# MODIStsp: calibration etc., see http://ropensci.github.io/MODIStsp/index.html.
# Manual processing in R: crop to AOI, further NDVI value processing, crop to CLC forest classes, plotting.
# + Creating one raster stack for each period seperately.
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


### Calculate pixelwise yearly mean NDVI of each period ###
# necessary for subsequent analysis using phenoTS functions
# raster stack with mixed up observation periods (3 layers per observation period and year) needs to be seperated
# result: one raster stack for each observation period with pixelswise yearly mean NDVI

# initialize layer name vectors
l_names <- character(0)   # for stack with both oeriods
l_names_1 <- character(0) # for stack with 1st period
l_names_2 <- character(0) # for stack with 2nd period

counter <- 1 # for assigning layer names

# iterate through stack in steps of 3 (= number of scenes per single observation)
for(i in seq(1,nlayers(ts_ndvi),by=3)){

  # calculate mean NDVI of 3 layers each (= one observation period within one year)
  tmp <- overlay(ts_ndvi[[i:(i+2)]],fun=function(x,y,z){(x+y+z)/3},unstack=TRUE)

  # stack of all periods (2 each year)
  if(i==1){ # first scene initialization
    ndvi_m_px <- tmp
    ndvi_m_px_1 <- tmp
  }else{
    ndvi_m_px <- stack(ndvi_m_px,tmp)
  }

  # split into 2 RasterStacks - one for each period (1 - April/2 - July) and create layer names
  if(i%%2==1){ # 1st period

    if(i>1){ndvi_m_px_1 <- stack(ndvi_m_px_1,tmp)} # stack 1st period only

    # define layer names
    l_name <- paste0("mean_NDVI_",toString(1999+counter-(counter-1)/2),"_",toString(1)) # for complete stack
    l_names_1[counter-(counter-1)/2] <- paste0("mean_NDVI_",toString(1999+counter-(counter-1)/2),"_",toString(1)) # for stack 1st period

  } else { # 2nd period

    if(i==4){
      ndvi_m_px_2 <- tmp
    }else{
      ndvi_m_px_2 <- stack(ndvi_m_px_2,tmp) # stack 2nd period only
    }

    # define layer names
    l_name <- paste0("mean_NDVI_",toString(2000+counter-counter/2-1),"_",toString(2)) # for complete stack
    l_names_2[counter-counter/2] <- paste0("mean_NDVI_",toString(2000+counter-counter/2-1),"_",toString(2)) # for stack 2nd period

  }

  l_names[counter] <- l_name
  counter <- counter + 1

} # end for through stack

# assign layer names to stacks
names(ndvi_m_px) <- l_names
names(ndvi_m_px_1) <- l_names_1
names(ndvi_m_px_2) <- l_names_2


### save stacks ###
# so they can be analyzed using phenoTS-functions subsequently

# set directory
setwd("C:/User/.../my_directory")

# save files as GeoTiff
writeRaster(ndvi_m_px,"ndvi_m_px.tif",format="GTiff")
writeRaster(ndvi_m_px_1,"ndvi_m_px_1.tif",format="GTiff")
writeRaster(ndvi_m_px_2,"ndvi_m_px_2.tif",format="GTiff")

### finished processing - ready to analyze ###


