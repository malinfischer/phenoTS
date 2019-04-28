#' @title Calculate mean of each raster layer
#'
#' @description This function allows you to calculate the mean of all pixels per layer in a raster stack. A tibble with mean values and a column with a provided date flag is returned and can be used for forther analysis and plotting.
#'
#' @param ras_stack Raster stack to analyse.
#' @param date_flag A vector containing the date flags of each layer, e.g. observation years, which is appended to result. Ascending numbers are assigned if empty.
#'
#' @return A tibble with calculated mean values per layer and according date flags.
#'
#' @import tidyverse
#' @import raster
#'
#' @export
#'
#' @examples
#' # test example
#'

ras_calc_mean <- function(ras_stack,date_flag){

  # calculate mean of all pixels in each layer in raster stack
  ras_mean <- raster::cellStats(ras_stack,stat="mean")

  # convert to tibble
  ras_mean <- tibble::as_tibble(ras_mean)

  # rename column title
  ras_mean <- dplyr::rename(ras_mean,mean_value=value)

  # add column with date flag
  if(missing(date_flag)){ # missing date_flag
    date_flag <- c(1:raster::nlayers(ras_stack)) # assign ascending numbers
  } else {
    date_flag <- date_flag # assign provided date_flag
  }

  ras_mean <- tibble::add_column(ras_mean,date_flag=date_flag)

  # add column stat_name indicating that whole scene is taken - necessary for ras_plot_ts()
  ras_mean <- tibble::add_column(ras_mean,stat_name="entire scene")

  # show result tibble
  View(ras_mean)

  # return result tibble
  return(ras_mean)

}
