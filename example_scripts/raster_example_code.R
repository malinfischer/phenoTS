####################################################
######### R-Package phenoTS - example code #########
####################################################
######### Part 2: raster data (MODIS NDVI)##########
####################################################

###### 1. install and activate phenoTS package #####

## devtools package - necessary to get package from github
install.packages("devtools")
library(devtools)

## phenoTS package from github
devtools::install_github("malinfischer/phenoTS")
library(phenoTS)

## additional packages for this example code
install.packages("raster")
install.packages("tidyverse")
library(raster)
library(tidyverse)


############# 2. download raster data #############

# The general download of phenological raster information is not included in this package.
# The example script "modis_download.R" shows how MODIS NDVI data (MOD13Q1_V6, 16d-composite, 1km) can be downloaded using the getSpatialData package.
# As phenoTS raster functions are generalized, other raster data sources can be used as well.


############# 3. process raster data #############

# The general processing of phenological raster information is not included in this package.
# The example script "modis_process.R" shows how MODIS NDVI data can be processed using MODIStsp package and manual R functions.

# The processed results are provided in the folder "MODIS_data_processed".
# They contain raster stacks with pixel-wise mean NDVIs of each layer (year) for 3 scenes in April (1) or July (2).
# Cropped to area of interest, here the Bavarian Forest.

# load processed data
ndvi_m_px_1 <- stack(paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/MODIS_data_processed/ndvi_m_px_1.tif"))
ndvi_m_px_2 <- stack(paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/MODIS_data_processed/ndvi_m_px_2.tif"))
# or create paths manually


###### 4. calculate mean NDVI per point-buffer #####

## a) mean of all pixels in layer
ndvi_m_1 <- ras_calc_mean(ndvi_m_px_1,date_flag=c(2000:2018))
ndvi_m_2 <- ras_calc_mean(ndvi_m_px_2,date_flag=c(2000:2018))

## b) mean of all pixels in layer within point-buffer (around DWD stations)

# define path to shape file containing points of interest
# here: DWD stations used in DWD example script, provided in the folder "MODIS_data_processed"
dir_shp <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/MODIS_data_processed/dwd_stations.shp")
# or create path manually

# calculate mean per pixel-buffer of 5km
ndvi_m_1_poi <- ras_calc_mean_points(ndvi_m_px_1,dir_shp=dir_shp,buffer=5000,date_flag=c(2000:2018))
ndvi_m_2_poi <- ras_calc_mean_points(ndvi_m_px_2,dir_shp=dir_shp,buffer=5000,date_flag=c(2000:2018))


################ 5. plot time-series ###############
## whole scene

# create single plots - period 1 (April) and 2 (July)
plot_1 <- ras_plot_ts(ndvi_m_1,title="MODIS NDVI time-series April",x_lab="year",y_lab="NDVI")
plot_2 <- ras_plot_ts(ndvi_m_2,title="MODIS NDVI time-series July",x_lab="year",y_lab="NDVI")

# create plot with both periods
plot_both <- ras_plot_2_ts(ndvi_m_1,ndvi_m_2,title="MODIS NDVI time-series April and July",x_lab="year",y_lab="NDVI",lab_1="April",lab_2="July")

# save plots
my_dir <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/result_plots") # export destination folder
# or create path manually

ggplot2::ggsave("ndvi_plot_all_april.png",plot_1,width=200,height=100,units="mm",path=my_dir)
ggplot2::ggsave("ndvi_plot_all_july.png",plot_2,width=200,height=100,units="mm",path=my_dir)
ggplot2::ggsave("ndvi_plots_all.png",plot_both,width=200,height=100,units="mm",path=my_dir)


## per point-buffer (DWD station)

# create single plots - period 1 (April) and 2 (July)
plot_1 <- ras_plot_ts(ndvi_m_1_poi,title="MODIS NDVI time-series April",x_lab="year",y_lab="NDVI")
plot_2 <- ras_plot_ts(ndvi_m_2_poi,title="MODIS NDVI time-series July",x_lab="year",y_lab="NDVI")

# create plot with both periods
plot_both <- ras_plot_2_ts(ndvi_m_1_poi,ndvi_m_2_poi,title="MODIS NDVI time-series April and July",x_lab="year",y_lab="NDVI",lab_1="April",lab_2="July")

# save plots
my_dir <- "my_dir" # define export folder path

ggplot2::ggsave("ndvi_plot_poi_april.png",plot_1,width=200,height=200,units="mm",path=my_dir)
ggplot2::ggsave("ndvi_plot_poi_july.png",plot_2,width=200,height=200,units="mm",path=my_dir)
ggplot2::ggsave("ndvi_plots_poi.png",plot_both,width=200,height=200,units="mm",path=my_dir)


################# 6. interpretation ################

# up to the user :-)

# here (broadly): NDVI values have increased, especially during April
# might indicate that vegetation greening starts earlier

# supports results of DWD time-series but other kind of information
