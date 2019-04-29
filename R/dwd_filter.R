#' @title Filter TS-relevant data
#'
#' @description This function allows you to filter observation data relevant to your time-series analysis. A single phase and observation period is selected. Observations of stations closed out of or within this period are deleted. All observations of a station with less than a selected number of observations is available are removed.
#'
#' @param dwd_data tibble containing processed DWD observation data which shall be filtered (return of \code{\link{dwd_process}}).
#' @param dwd_phase_id phase_id of selected phase according to DWD (not BBCH!) definition.
#' @param obs_start start of observation period (year).
#' @param obs_end end of observation period (year, included).
#' @param obs_min minimum number of available observations per station.
#'
#'
#' @return A tidyverse tibble containing the filtered observation data.
#'
#' @import tidyverse
#' @importFrom lubridate year
#'
#' @export
#'
#' @examples
#' ## set directory where data files shall be saved
#' my_dir <- "C:/Users/.../my_folder"
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
#' ## filter time-series relevant data
#' rbu_data <- dwd_filter(rbu_data, dwd_phase_id=4, obs_start=1950, obs_end=2018, obs_min=25)
#'

dwd_filter <- function(dwd_data, dwd_phase_id, obs_start, obs_end, obs_min){

  # filter data of selected phase
  filtered <- dplyr::filter(dwd_data,phase_id==dwd_phase_id)

  # filter data obtained under observation period
  filtered <- dplyr::filter(filtered,ref_year>=obs_start) # delete before observation start
  filtered <- dplyr::filter(filtered,ref_year<=obs_end) # delete after observation end

  # delete data if station was closed more than one year before end of observation period
  filtered <- dplyr::filter(filtered,(lubridate::year(close_date)>obs_end | is.na(filtered$close_date)))

  # delete observations of a station when less than selected number of years (obs_min) are available
  tly <- dplyr::group_by(filtered,stat_id)

  # count observations per station
  tly <- dplyr::tally(tly)

  # combine with observation table
  filtered <- dplyr::left_join(filtered,tly,by="stat_id")

  # delete rows with too few observations
  filtered <- dplyr::filter(filtered,n>=obs_min)

  # rename new column with number of observations
  dplyr::rename(filtered,"n_obs"="n")

  # return filtered result
  return(filtered)

}



