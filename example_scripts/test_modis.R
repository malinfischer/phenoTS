library(phenoTS)
library(raster)
library(tidyverse)

ras <- stack("C:/Users/Malin/Documents/Studium/Wuerzburg/phenoTS/example_scripts/MODIS_data_processed/ndvi_m_px_1.tif")
ras_2 <- stack("C:/Users/Malin/Documents/Studium/Wuerzburg/phenoTS/example_scripts/MODIS_data_processed/ndvi_m_px_2.tif")
# ras

ras_all <- ras_calc_mean(ras,date_flag=c(2000:2018))
ras_all_2 <- ras_calc_mean(ras_2,date_flag=c(2000:2018))
# ras_p

ras_points <- ras_calc_mean_points(ras,"C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data/dwd_stations_bw.shp",5000,c(2000:2018))
ras_points_2 <- ras_calc_mean_points(ras_2,"C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data/dwd_stations_bw.shp",5000,c(2000:2018))

my_plot <- ras_plot_ts(ras_all)
my_plot_2 <- ras_plot_ts(ras_points)

plot_1 <- ras_plot_2_ts(ras_points,ras_points_2)
