#' @title Plot one time-series per scene or point
#'
#' @description This function allows you to plot one time-series per scene or extracted points, e.g. the result of ras_calc_mean() or ras_calc_mean_point(). Furthermore, LOESS smoothening (local polynomial regression fitting) is applied.
#'
#' @param ras_data a tibble containing mean raster values which shall be plotted, e.g. result of ras_calc_mean() or ras_calc_mean_point().
#' @param title plot title (optional).
#' @param x_lab x-axis label (optional).
#' @param y_lab y-axis label (optional).
#'
#' @return The resulting time-series ggplot.
#'
#' @import ggplot2
#'
#' @export
#'

ras_plot_ts <- function(ras_data,title,x_lab,y_lab){

  # set + update ggplot2 theme
  ggplot2::theme_set(theme_bw()) # ggplot theme
  ggplot2::theme_update(plot.title = element_text(hjust = 0.5)) # all titles centered

  # set title and x/y-labels
  if(missing(title)){ # standard title
    title <- "Time-series MODIS NDVI"
  } else {
    title <- title # customized title
  }

  if(missing(x_lab)){ # standard x-axis label
    x_lab <- "year"
  } else {
    x_lab <- x_lab # customized x-axis label
  }

  if(missing(y_lab)){ # standard y-axis label
    y_lab <- "NDVI"
  } else {
    y_lab <- y_lab # customized y-axis label
  }

  # plot
  my_plot <- ggplot2::ggplot(data=ras_data, aes(x=date_flag,y=mean_value))+
              geom_line(color="springgreen4",size=1)+
              geom_point(color="springgreen4",size=2)+
              labs(x=x_lab,y=y_lab,title=title)+
              stat_smooth(color = "tan4", fill = "tan",method = "loess")+ # smoothening - LOESS local polynomial regression fitting
              facet_grid(stat_name ~.) # split plots by station and show station name (or note that whole scene was taken)

  # show plot in new window
  x11()
  print(my_plot)

  # return plot
  return(my_plot)

}
