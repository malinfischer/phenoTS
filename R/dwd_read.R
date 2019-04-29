#' @title Read DWD phenology file into R
#'
#' @description This function allows you to import a DWD phenology file into R as a tidyverse tibble.
#'
#' @param dir directory where the file that shall be imported is located, including full file name.
#'
#' @return A tidyverse tibble containing the DWD phenology data.
#'
#' @import tidyverse
#'
#' @export
#'

dwd_read <- function(dir){

  # define column names
  col_names <- c("stat_id","ref_year","qual","obj_id","phase_id","entry_date","entry_qual","entry_doy")

  # define data type of columns - skip last 2 ("eor" + empty)
  col_types <- list(readr::col_integer(),readr::col_integer(),readr::col_integer(),readr::col_integer(),readr::col_integer(),readr::col_date(format="%Y%m%d"),readr::col_integer(),readr::col_integer(),readr::col_skip(),readr::col_skip())

  # read file as tibble
  # note: warning about last empty row is suppressed as not relevant
  my_file <- suppressWarnings(readr::read_delim(dir, delim=";", col_names = col_names, skip = 1, col_types=col_types, trim_ws = TRUE, skip_empty_rows = TRUE, locale = readr::locale(encoding="Latin1")))

  # add new column with dir as entries - necessary for subsequent processing functions
  my_file <- tibble::add_column(my_file,dir=dir)

  # return tibble
  return(my_file)

}
