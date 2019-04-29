#' @title Plot DWD stations within Germany
#'
#' @description This function allows you to plot the location of all stations of a dwd data tibble on a map of Germany.
#'
#' @param dwd_data a tibble containing DWD observation data with station information.
#'
#' @import raster
#' @import sp
#'
#' @export
#'
#'

dwd_stations_plot <- function(dwd_data){

  ## download German administrative borders
  map.ger <- raster::getData("GADM",country="DEU",level=1)
  # writeOGR(map.ger,"C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data","GER_borders",driver="ESRI Shapefile")


  ## convert tibble to shape file

  # define coordinates
  sp::coordinates(dwd_data)<-~lon+lat

  # set projection
  sp::proj4string(dwd_data) <- sp::CRS("+proj=longlat +datum=WGS84")

  # # write shape file
  # writeOGR(rbu_pp_stat,"C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data","rbu_stations",driver="ESRI Shapefile")


  ## plot stations with Germany as background
  raster::plot(map.ger,col="grey",main="DWD observation stations") # GER
  raster::plot(dwd_data,col="blue",pch=16,cex=0.6,add=T) # stations

}
