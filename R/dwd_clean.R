#' @title Clean relevant observation data
#'
#' @description This function allows you to clean observation data which is already joined with station and phase information by filtering relevant information. Duplicates are removed and irrelevant columns as well as incomplete or low-quality (based on quality flags) observations are deleted.
#'
#' @param dwd_data tibble containing DWD observation data to which station and phase information has been added already = return of functions dwd_add_phase/station_info(dir) or dwd_join_files(dwd_data_list).
#'
#' @return A tidyverse tibble containing the cleaned observation data.
#'
#' @import tidyverse
#'
#' @export
#'
#' @examples
#' # test example
#'
#'

dwd_clean <- function(dwd_data){

  # remove (full) duplicates as time spans of JM and SM might overlap (usually 1 year)
  cleaned_data <- dplyr::distinct(dwd_data)

  # remove duplicates with different quality information although same observation - only look at "characteristic" columns
  cleaned_data <- dplyr::distinct(cleaned_data,stat_id,ref_year,phase_id,.keep_all = T)

  # remove column "object" which only contains (always similar) name of observed crop (from phase info file)
  cleaned_data <- dplyr::select(cleaned_data,-"obj")

  # remove column "dir" which only contains (always similar) file directory
  cleaned_data <- dplyr::select(cleaned_data,-"dir")

  # remove observations without any station information
  cleaned_data <- dplyr::filter(cleaned_data,!is.na(stat_name))

  # remove low-quality observations based on attached quality byte ("Qualitaetsbyte" 5 (doubtful) or 8 (wrong))
  cleaned_data <- dplyr::filter(cleaned_data,entry_qual!=5)
  cleaned_data <- dplyr::filter(cleaned_data,entry_qual!=8)

  return(cleaned_data)

}
