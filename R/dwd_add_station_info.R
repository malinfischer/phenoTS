#' @title Add station info to data file
#'
#' @description This function allows you to add station information to an observation data file.
#'
#' @param dwd_data tibble containing DWD observation data to which station information shall be added = return of function dwd_read(dir).
#'
#' @return A tidyverse tibble containing the merged observation and station data.
#'
#' @import tidyverse
#'
#' @export
#'
#' @examples
#' # test example
#'
#'

dwd_add_station_info <- function(dwd_data){

  ### Step 1: Create full path to station information file based on file name and location

  # get original file directory from dir column
  dir <- dwd_data$dir[1]

  # get index of second last "/" - for location of station info file = two folders "above" original file's location
  i_all <- stringr::str_locate_all(dir,"/") # list of all "/" indices
  i_2last <- i_all[[1]][(length(i_all[[1]][,1])-1)] # index of second last "/"

  dir_info <- stringr::str_sub(dir,1,i_2last) # ends with "/"

  # define station info file name based on data file name
  # --> check if dir contains "Jahresmelder" (annual reporter) or "Sofortmelder" (immediate reporter)
  if(stringr::str_detect(dir,"Jahresmelder")){
    name_info <- "PH_Beschreibung_Phaenologie_Stationen_Jahresmelder.txt"
  } else if(stringr::str_detect(dir,"Sofortmelder")) {
    name_info <- "PH_Beschreibung_Phaenologie_Stationen_Sofortmelder.txt"
  } else {
    print("Error while identifying reporter type. Please check whether file name with directory is correct.")
  }

  path_stat_info <- paste0(dir_info,name_info)

  ### Step 2: read station info file
  # based on function dwd_read_station_info
  station_info <- dwd_read_station_info(path_stat_info)


  ### Step 3: join data file and station info file
  my_joined_file <- dplyr::left_join(dwd_data,station_info,by="stat_id")

  return(my_joined_file)

}


