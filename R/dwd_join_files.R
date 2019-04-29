#' @title Add phase info to data file
#'
#' @description This function allows you to join different tibbles containing observation data (usually immediate/annual reporters and/or recent/historic observations). Duplicates are removed.
#'
#' @param dwd_data_list a list containing all observation data tibbles which shall be joined (returns of \code{\link{dwd_read}} or \code{\link{dwd_process}}).
#'
#' @return A tidyverse tibble containing all joined observation data.
#'
#' @import tidyverse
#'
#' @export
#'
#' @examples
#' file_list <- c() # initialize list to wtore all processed files
#'
#' # iterate through all files
#' for(file in dwd_data_list){
#'
#' # add processing steps for single files here
#'
#' # add processed file to list of all processed files
#' file_list <- c(file_list,my_file)
#'
#' }
#'
#' # join files
#' file_joined <- dwd_join_files(file_list)
#'

dwd_join_files <- function(dwd_data_list){

  dwd_joined <- dwd_data_list[[1]]

  for (i in 2:length(dwd_data_list)){

    dwd_joined <- dplyr::bind_rows(dwd_joined,dwd_data_list[[i]])

  }

  # remove (full) duplicates as time spans of JM and SM might overlap (usually 1 year)
  dwd_joined <- dplyr::distinct(dwd_joined)

  # return joined file
  return(dwd_joined)

}
