####################################################
######### R-Package phenoTS - example code #########
####################################################
########### Part 1: DWD phenology data #############
####################################################

###### 1. install and activate phenoTS package #####

## devtools package - necessary to get package from github
install.packages("devtools")
library(devtools)

## phenoTS package from github
devtools::install_github("malinfischer/phenoTS")
library(phenoTS)

## additional packages for this example code
install.packages("tidyverse")
install.packages("ggplot2")
library(tidyverse)
library(ggplot2)


########## 2. download DWD phenology data ##########

## set directory where data files shall be saved
my_dir <- "C:/Users/.../my_folder"


my_dir <- "C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data"

## check available crops  and their abbreviations
dwd_crop_list()

## download
# from DWD's public ftp-server: ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/phenology/
# all relevant data + meta files are selected and downloaded automatically
# crop: Rotbuche (European beech), max. observation period, annual + immediate reporters
dwd_download(crops="FIC", start=1900, end=2019, report="JMSM", dir_out=my_dir)


################# 3. process data ##################
# Note: includes several single processing steps using phenoTS functions:
# dwd_read, dwd_add_phase_info, dwd_add_station_info, dwd_clean, dwd_join_files
# See function descriptions and scripts for more details.

## create directory to folder containing files to be processed
folder_dir <- paste0(my_dir, "/RBU") # modify abbreviation accordingly

## process and join all files in folder
rbu_data <- dwd_process(folder_dir)

## view result (one tidyverse tibble with finally processed DWD data)
View(rbu_data)


################## 4. filter data ##################
## which is relevant to your time-series analysis ##

## a) general filters
# select one phase, define observation period, delete closed stations

# phase 4 (begin of foliation / Blattentfaltung Beginn) selected here
# = indicator for start of greening / spring
rbu_data <- dwd_filter(rbu_data, dwd_phase_id=4, obs_start=1950, obs_end=2018, obs_min=25)

## b) filter specific stations

# plot location of all available DWD stations within Germany
dwd_stations_plot(rbu_data)

# filter flexibly using dplyr package
# here: selected by stat_id
rbu_data <- dplyr::filter(rbu_data,stat_id%in%c(11162,11292,11295))

# plot location of selected stations within Germany
# three stations in the Bavarian Forest
dwd_stations_plot(rbu_data)

# save selected stations as shape file
dwd_stations_shp(rbu_data,my_dir)

## view filtered data
View(rbu_data)


############### 5. plot time-series ################

# create plot
rbu_plot <- dwd_plot_ts(rbu_data,title="DWD time-series beech foliation")

# save plot
ggplot2::ggsave("rbu_plot.png",rbu_plot,width=200,height=200,units="mm",path=my_dir)


##### 6. Repeat and plot for other crop type #######

# crop: Fichte (spruce)
dwd_download(crops="FIC", start=1900, end=2019, report="JMSM", dir_out=my_dir)

folder_dir <- paste0(my_dir, "/FIC")
fic_data <- dwd_process(folder_dir)

# phase 8 (burst of buds / Maitrieb) selected here
fic_data <- dwd_filter(fic_data, dwd_phase_id=8, obs_start=1950, obs_end=2018, obs_min=25)
fic_data <- dplyr::filter(fic_data,stat_id%in%c(11162,11292,11295))

# create single plot
fic_plot <- dwd_plot_ts(fic_data,title="DWD time-series spruce burst of buds")


### create plot with both crops ###
rbu_fic_plot <- dwd_plot_2_ts(rbu_data,fic_data,title="DWD time-series beech and spruce",lab_1="beech",lab_2="spruce")

# save plots
ggplot2::ggsave("fic_plot.png",fic_plot,width=200,height=200,units="mm",path=my_dir)
ggplot2::ggsave("rbu_fic_plot.png",rbu_fic_plot,width=200,height=200,units="mm",path=my_dir)


################# 6. interpretation ################
# up to the user :-)

# here (broadly): phase entries have shifted to later dates
# might indicate that vegetation greening starts earlier

# supports results of MODIS NDVI time-series but other kind of information

