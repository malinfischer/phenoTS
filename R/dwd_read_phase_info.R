#' @title Read DWD phenological stage info file into R
#'
#' @description This function allows you to import a DWD phenological stage information meta file into R as a tidyverse tibble.
#'
#' @param dir directory where info file that shall be imported is located, including full file name.
#'
#' @return A tidyverse tibble containing the DWD phenological stage info file data.
#'
#' @import tidyverse
#'
#' @export
#'
#'
#'

dwd_read_phase_info <- function(dir){

  # define column names
  col_names <- c("obj_id","obj","phase_id","phase","phase_def","bbch","bbch_note")

  # define data type of columns - skip last 2 ("eor" + empty)
  col_types <- list(readr::col_integer(),readr::col_character(),readr::col_integer(),readr::col_character(),readr::col_character(),readr::col_integer(),readr::col_character(),readr::col_skip(),readr::col_skip())

  # read file as tibble - encoding is considered
  # note: warning last row empty is be ignored/suppressed
  my_stage_info_file <- suppressWarnings(readr::read_delim(dir, delim=";", col_names = col_names, skip = 1, col_types=col_types, trim_ws = TRUE, skip_empty_rows = TRUE, locale = readr::locale(encoding="Latin1"),quote=""))


  # return tibble
  return(my_stage_info_file)

}
