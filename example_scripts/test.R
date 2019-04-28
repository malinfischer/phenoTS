library(phenoTS)

#dwd_download("WRO",2012,2015,"JM","C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data")
#dwd_download("WRO",1900,2018,"JMSM","C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data") 

my_file <- dwd_read("C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data/RBU/PH_Jahresmelder_Wildwachsende_Pflanze_Rotbuche_1925_2017_hist.txt")
my_file_2 <- dwd_read("C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data/FIC/PH_Jahresmelder_Wildwachsende_Pflanze_Fichte_1925_2017_hist.txt")

my_stage_info_file <- dwd_read_phase_info("C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data/PH_Beschreibung_Phasendefinition_Sofortmelder_Wildwachsende_Pflanze.txt")

my_station_info_file <- dwd_read_station_info("C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data/PH_Beschreibung_Phaenologie_Stationen_Jahresmelder.txt")

my_file_stat <- dwd_add_station_info(my_file)
my_file_stat_2 <- dwd_add_station_info(my_file_2)

my_file_phase <- dwd_add_phase_info(my_file_stat)
my_file_phase_2 <- dwd_add_phase_info(my_file_stat_2)

my_file_cleaned <- dwd_clean(my_file_phase)
my_file_cleaned_2 <- dwd_clean(my_file_phase_2)

#stack <- list(my_file,my_file2)
#stack[[1]]

#my_file_joined <- dwd_join_files(stack)

my_file_filtered <- dwd_filter(my_file_cleaned,4,1960,2018,10)
my_file_filtered_2 <- dwd_filter(my_file_cleaned_2,8,1960,2018,10)

#View(my_file_filtered)

#my_list <- dwd_crop_list()

#dwd_stations_plot(my_file_filtered)

#dwd_stations_shp(my_file_filtered,"C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/plots")

#my_file_2 <- dplyr::filter(my_file_filtered,stat_id%in%c(164,9809))
#my_plot <- dwd_plot_ts(my_file_2)

my_multi_plot <- dwd_plot_2_ts(my_file_filtered,my_file_filtered_2,c(11162,11172),subtitle="Examplary results",lab_1="Rotbuche (Europ. Beech)",lab_2="Fichte (Spruce)")



