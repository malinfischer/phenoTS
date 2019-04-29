#' @title Read DWD phenological station info file into R
#'
#' @description This function allows you to import a DWD station information meta file into R as a tidyverse tibble.
#'
#' @param dir directory where info file that shall be imported is located, including full file name.
#'
#' @return A tidyverse tibble containing the DWD phenological station info file data.
#'
#' @import tidyverse
#'
#' @export
#'
dwd_read_station_info <- function(dir){

  # define column names
  col_names <- c("stat_id","stat_name","lat","lon","alt","lsc_gr_id","lsc_gr","lsc_id","lsc","close_date","state") # lsc = landscape (Naturraum)

  # define data type of columns - skip last 2 ("eor" + empty)
  col_types <- list(readr::col_integer(),readr::col_character(),readr::col_double(),readr::col_double(),readr::col_integer(),readr::col_integer(),readr::col_character(),readr::col_integer(),readr::col_character(),readr::col_date(format="%d.%m.%Y"),readr::col_character(),readr::col_skip(),readr::col_skip())

  # read file as tibble - encoding is considered
  # note: warning last row empty is be ignored/suppressed
  my_station_info_file <- suppressWarnings(readr::read_delim(dir, delim=";", col_names = col_names, skip = 1, col_types=col_types, trim_ws = TRUE, skip_empty_rows = TRUE, locale = readr::locale(encoding="Latin1")))

  # return tibble
  return(my_station_info_file)

}
