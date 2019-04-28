#######################################################
########### Example: Get MODIS NDVI data ##############
#######################################################
# This script shows how MODIS NDVI data can be downloaded using the getSpatialData package.
# It provides the raster NDVI data which can be analyzed with phenoTS-functions.
# The general download of phenological raster information is not included in this package.
# MODIS NDVI product (MOD13Q1_V6, 16d-composite, 1km) is often a useful data source and taken in this example.
# Info: https://modis.gsfc.nasa.gov/data/dataprod/mod13.php
#######################################################
#######################################################

# install and activate package devtools
install.packages("devtools")
library(devtools)

# install package getSpatialData from github
devtools::install_github("16EAGLE/getSpatialData")
library(getSpatialData)

# further information on package
?`getSpatialData-package`


### set parameters ###

# set archive = download destination
set_archive("C:/Users/.../myfolder")

# login to USGS (registration: https://earthexplorer.usgs.gov/)
login_USGS(username="my_username",password="my_password")

# set (draw) area of interest
set_aoi()

# check available MODIS products
getMODIS_names()

# search for and view available data
rec <- getMODIS_query(time_range=c("2000-01-01","2019-04-01"),name="MODIS_MOD13Q1_V6")
View(rec)

# preview first record
getMODIS_preview(record=rec[1,])


### search for available data ###
# NOTE: data for two observation periods is downloaded, 3 scenes each in spring (April) and summer (July).
# Can be modified to get other time-series.

# define start and end of observation period
y_start <- 2000
y_end <- 2019

# iterate through all years to download available files
for(i in y_start:y_end){

  # display process (year)
  print("Current year:")
  print(i)


  ### 1st observation period - April ###
  # also some days of March/May included in 16d periods

  s_start_1 <- paste0(toString(i),"-04-01")
  s_end_1 <- paste0(toString(i),"-04-30")

  # create query
  rec_1 <- getMODIS_query(time_range=c(s_start_1,s_end_1),name="MODIS_MOD13Q1_V6")

  # print available data
  print("Available data:")
  print(rec_1[1:3])

  # download all files
  getMODIS_data(records=rec_1)


  ### 2nd observation period - July ###
  # also some days of June/August included in 16d periods

  # create query
  s_start_2 <- paste0(toString(i),"-07-01")
  s_end_2 <- paste0(toString(i),"-07-31")

  # create query
  rec_2 <- getMODIS_query(time_range=c(s_start_2,s_end_2),name="MODIS_MOD13Q1_V6")

  # print available data
  print("Available data:")
  print(rec_2[1:3])

  # download all files
  getMODIS_data(records=rec_2)

} # end for through years

