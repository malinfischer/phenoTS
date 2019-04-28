#' @title Calculate mean of each raster layer for buffered points
#'
#' @description This function allows you to calculate the mean of all pixels within a buffer-zone around points of interest (POIs) for each layer in a raster stack. A tibble with mean values and additional columns with the provided date flags and other information is returned and can be used for forther analysis and plotting.
#'
#' @param ras_stack Raster stack to analyze.
#' @param dir_shp Full path to shape-file containing POIs (with file name and .shp) - e.g. created using dwd_stations_shp(). Provide unique point-IDs, column name = 'stat_id'!
#' @param buffer_size Size of buffer around each point within which pixels are extracted and averaged (in meters).
#' @param date_flag A vector containing the date flags of each layer, e.g. observation years, which is appended to result. Ascending numbers are assigned if empty.
#'
#' @return A tibble with calculated mean values per station and layer plus other information and date flags.
#'
#' @import tidyverse
#' @import raster
#' @import rgdal
#' @import rgeos
#'
#' @export
#'
#' @examples
#' # test example
#'

ras_calc_mean_points <- function(ras_stack,dir_shp,buffer,date_flag){


  ### load shp file with points of interest (POI) ###

  # get path to directory from dir_shp
  dir_split <- stringr::str_split(dir_shp,"/",simplify=TRUE)
  dir_path <- paste(dir_split[1:(length(dir_split)-1)],collapse="/")

  # get file name from dir_shp
  file_name <- stringr::str_sub(dir_split[length(dir_split)],1,-5)

  # read shp file
  poi <- rgdal::readOGR(dir_path,file_name,pointDropZ = TRUE,encoding="UTF-8")

  # reproject to raster stack's projection
  poi <- spTransform(poi,CRS(proj4string(ras)))

  # extract station info for table later
  stat_names <- poi$stat_name


  ### analysis ###

  # counter
  j <- 1

  # loop through POIs - unique column 'stat_id'
  for(i in poi$stat_id){

    # extract POI
    poi_tmp <- poi[poi$stat_id == i,]

    # extract point and create buffer around it
    buff <- rgeos::gBuffer(poi_tmp,width=buffer)
    buff <- raster::mask(ras_stack,buff)

    # calculate mean value for this POI-buffer for all years (= raster layers)
    mean_tmp <- raster::cellStats(buff,stat="mean")

    # convert to tibble and add columns with relevant station and date_flag information
    mean_tmp <- tibble::as_tibble(mean_tmp)
    mean_tmp <- tibble::add_column(mean_tmp,stat_id=i,stat_name=poi_tmp$stat_name,alt=poi_tmp$alt,lsc_gr_id=poi_tmp$lsc_gr_id,lsc_gr=poi_tmp$lsc_gr,lsc=poi_tmp$lsc,close_date=poi_tmp$close_date,state=poi_tmp$state,date_flag=date_flag)

    # add to tibble with all POIs
    if(j==1){ # 1st layer
      ras_mean <- mean_tmp
    } else {
      ras_mean <- dplyr::bind_rows(ras_mean,mean_tmp)
    }

    # counter
    j <- j+1

  } # end for through stations

  # move column stat_id to the front
  ras_mean <- dplyr::select(ras_mean,stat_id,everything())

  # rename column title
  ras_mean <- dplyr::rename(ras_mean,mean_value=value)

  # view result tibble
  View(ras_mean)

  # return result tibble
  return(ras_mean)

}
