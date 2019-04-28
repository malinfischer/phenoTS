#' @title Plot one time-series per DWD station
#'
#' @description This function allows you to plot one time-series per DWD station for an input DWD data set. Specific stations can be filtered beforehand. For other filter operations use ggplot2:filter() to create customized data set. Furthermore, LOESS smoothening (local polynomial regression fitting) is applied.
#'
#' @param dwd_data a tibble containing DWD observation data (pre-processed, with station + phase information) which shall be plotted.
#' @param stat_ids station ID(s) of station(s) which shall be plotted (optional). If empty, all stations are plotted.
#' @param title plot title (optional).
#'
#' @return The resulting time-series ggplot.
#'
#' @import ggplot2
#' @import tidyverse
#'
#' @export
#'
#' @examples
#' # test example
#'
#'

dwd_plot_ts <- function(dwd_data,stat_ids,title){

  # set + update ggplot2 theme
  ggplot2::theme_set(theme_bw()) # ggplot theme
  ggplot2::theme_update(plot.title = element_text(hjust = 0.5)) # all titles centered

  # select stations by stat_id if stat_ids is not empty
  if(!missing(stat_ids)){
    dwd_data <- dplyr::filter(dwd_data, stat_id %in% stat_ids)
  }

  # set title
  if(missing(title)){ # standard title
    title <- "Time-series DWD phenology data"
  } else {
    title <- title # customized title
  }

  # create time-series plot
  my_plot <- ggplot2::ggplot(data=dwd_data, aes(x=ref_year,y=entry_doy))+
              geom_line(color="springgreen4",size=1)+
              geom_point(color="springgreen4",size=2)+
              labs(x="Year",y="DOY phase entry",title=title)+
              stat_smooth(color = "tan4", fill = "tan",method = "loess")+ # smoothening - LOESS local polynomial regression fitting
              facet_grid(stat_name ~.) # split plots by station and show station name

  # show plot in new window
  x11()
  print(my_plot)

  # return plot
  return(my_plot)

}
