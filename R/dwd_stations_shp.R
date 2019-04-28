#' @title Save DWD stations as shape file
#'
#' @description This function allows you to save the location of all stations of a dwd data tibble as shape file (with +proj=longlat, +datum=WGS84).
#'
#' @param dwd_data a tibble containing DWD observation data with station information.
#' @param out_dir directory of folder where created shape file shall be saved.
#'
#' @import rgdal
#' @import sp
#'
#' @export
#'
#' @examples
#' # test example
#'
#'

dwd_stations_shp <- function(dwd_data,out_dir){

  # filter only one entry per station
  dwd_data <- dplyr::distinct(dwd_data,stat_id,.keep_all=TRUE)

  # select only station-relevant columns
  dwd_data <- dplyr::select(dwd_data,stat_id,stat_name,alt,lsc_gr_id,lsc_gr,lsc,close_date,state,lon,lat)

  ## convert tibble to shape file

  # define coordinates
  sp::coordinates(dwd_data)<-~lon+lat

  # set projection
  sp::proj4string(dwd_data) <- sp::CRS("+proj=longlat +datum=WGS84")

  ## write shape file
  writeOGR(dwd_data,out_dir,"dwd_stations",driver="ESRI Shapefile",encoding="UTF-8")

}
