devtools::install_github("16EAGLE/getSpatialData")
library(getSpatialData)

# set archive (donwload destination)
set_archive("C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data/MODIS")

# login to USGS
login_USGS(username="my_username",password="my_password")

# set (draw) area of interest
set_aoi()

# check available MODIS products
getMODIS_names()

# search for available data
rec <- getMODIS_query(time_range=c("2000-01-01","2019-04-01"),name="MODIS_MOD13Q1_V6")
View(rec)

# preview first record
getMODIS_preview(record=rec[1,])

# search for available data

# define start and end of observation period
y_start <- 2000
y_end <- 2019

for(i in y_start:y_end){

  print("Current year:")
  print(i)

  # first observation period - April (also some days of March/May included in 16d periods)
  s_start_1 <- paste0(toString(i),"-04-01")
  s_end_1 <- paste0(toString(i),"-04-30")

  rec_1 <- getMODIS_query(time_range=c(s_start_1,s_end_1),name="MODIS_MOD13Q1_V6")

  print("Available data:")
  print(rec_1[1:3])

  getMODIS_data(records=rec_1)

  # second observation period - July (also some days of June/August included in 16d periods)
  s_start_2 <- paste0(toString(i),"-07-01")
  s_end_2 <- paste0(toString(i),"-07-31")

  rec_2 <- getMODIS_query(time_range=c(s_start_2,s_end_2),name="MODIS_MOD13Q1_V6")

  print("Available data:")
  print(rec_2[1:3])

  getMODIS_data(records=rec_2)

}

