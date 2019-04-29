#' @title Process DWD phenology files
#'
#' @description This function allows you to process and join all relevant files of one crop at once. \cr
#' The following processing steps are applied to each file in the passed folder: \cr
#' \enumerate{
#'   \item read downloaded file into R (\code{\link{dwd_read}})
#'   \item add phase information from matching meta files (\code{\link{dwd_add_phase_info}})
#'   \item add station information from matching meta files (\code{\link{dwd_add_station_info}})
#'   \item clean data (\code{\link{dwd_clean}})
#' }
#' Then, the files are joined (\code{\link{dwd_join_files}}) and returned as one single tidyverse tibble.\cr
#' Note: The single functions for these steps can be accessed individually as well.
#'
#' @param dir directory of the folder which contains all DWD files to be processed (not ending with "/").
#'
#' @return A tidyverse tibble containing the processed and joined DWD phenology data.
#'
#' @import tidyverse
#'
#' @export
#'
#' @examples
#' ## set directory where data files shall be saved
#' my_dir <- "C:/Users/.../my_folder"
#'
#' ## check available crops  and their abbreviations
#' dwd_crop_list()
#'
#' ## download
#' # both data + meta files
#' dwd_download("RBU",1900,2019,"JMSM",my_dir)
#'
#' ## create directory to folder containing files to be processed
#' folder_dir <- paste0(my_dir, "/RBU") # modify abbreviation accordingly
#'
#' ## process and join all files in folder
#' rbu_data <- dwd_process(dir)
#'

dwd_process <- function(dir){

  # get all .txt-file names in directory
  files <- list.files(dir,pattern=".txt")

  # print message with files to be processed
  cat("The following files were found and will be processed: \n")
  cat(files, sep = "\n")

  file_list <- list() # initialize list to store all processed files

  # iterate through all files
  for(file in files){

    # create full path to file
    dir_tmp <- paste0(dir,"/",file)

    # read file into R
    my_file <- dwd_read(dir_tmp) # result: tidyverse tibble

    # add phase information from matching phase meta file
    my_file <- dwd_add_phase_info(my_file)

    # add station information from matching station meta file
    my_file <- dwd_add_station_info(my_file)

    # clean observation data
    my_file <- dwd_clean(my_file)

    # add to list of all processed files
    file_list[[file]] <- my_file


  } # end for through files

  # join files
  file_joined <- dwd_join_files(file_list)

  # return processed file
  return(file_joined)

}
