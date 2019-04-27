#' @title Filter TS-relevant data
#'
#' @description This function allows you to filter observation data relevant to your time-series analysis. A single phase and observation period is selected. Observations of stations closed out of or within this period are deleted. All observations of a station with less than a selected number of observations is available are removed.
#'
#' @param dwd_data_list a list containing all observation data tibbles which shall be joined (returns of dwd_read(dir) or dwd_add_phase/station_info(dir)).
#' @param dwd_phase_id phase_id of selected phase according to DWD (not BBCH!) definition.
#' @param obs_start start of observation period (year).
#' @param obs_end end of observation period (year, included).
#' @param obs_min minimum number of available observations = years.
#'
#'
#' @return A tidyverse tibble containing all joined observation data.
#'
#' @import tidyverse
#' @importFrom lubridate year
#'
#' @export
#'
#' @examples
#' # test example
#'
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
  tly <- dplyr::tally(tly) # count observations per station
  filtered <- dplyr::left_join(filtered,tly,by="stat_id") # combine with observation table
  filtered <- dplyr::filter(filtered,n>=obs_min) # delete rows with too few observations
  dplyr::rename(filtered,"n_obs"="n") # rename new column with number of observations

  return(filtered)

}



