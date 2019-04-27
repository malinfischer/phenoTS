#' @title Add phase info to data file
#'
#' @description This function allows you to join different tibbles containing observation data (usually immediate/annual reporters and/or recent/historic observations). Duplicates are removed.
#'
#' @param dwd_data_list a list containing all observation data tibbles which shall be joined (returns of dwd_read(dir) or dwd_add_phase/station_info(dir)).
#'
#' @return A tidyverse tibble containing all joined observation data.
#'
#' @import tidyverse
#'
#' @export
#'
#' @examples
#' # test example
#'
#'

dwd_join_files <- function(dwd_data_list){

  dwd_joined <- dwd_data_list[[1]]

  for (i in 2:length(dwd_data_list)){

    dwd_joined <- dplyr::bind_rows(dwd_joined,dwd_data_list[[i]])

  }

  # remove (full) duplicates as time spans of JM and SM might overlap (usually 1 year)
  dwd_joined <- dplyr::distinct(dwd_joined)

  return(dwd_joined)

}
