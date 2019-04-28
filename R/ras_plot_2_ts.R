#' @title Plot one time-series per scene or point for two data sets
#'
#' @description This function allows you to plot one time-series for two data sets, each per scene or extracted points - e.g. the results of ras_calc_mean() or ras_calc_mean_point(). Furthermore, LOESS smoothening (local polynomial regression fitting) is applied.
#'
#' @param ras_data_1 tibble 1 containing mean raster values which shall be plotted, e.g. result of ras_calc_mean() or ras_calc_mean_point().
#' @param ras_data_2 tibble 2 containing mean raster values which shall be plotted.
#' @param title plot title (optional).
#' @param x_lab x-axis label (optional).
#' @param y_lab y-axis label (optional).
#' @param lab_1 legend label data set 1 (optional).
#' @param lab_2 legend label data set 2 (optional).
#'
#' @return The resulting time-series ggplot.
#'
#' @import ggplot2
#'
#' @export
#'
#' @examples
#' # test example
#'
#'

ras_plot_2_ts <- function(ras_data_1,ras_data_2,title,x_lab,y_lab,lab_1,lab_2){

  # set + update ggplot2 theme
  ggplot2::theme_set(theme_bw()) # ggplot theme
  ggplot2::theme_update(plot.title = element_text(hjust = 0.5)) # all titles centered
  ggplot2::theme_update(plot.subtitle = element_text(hjust = 0.5)) # all subtitles centered

  # set title, x/y-axis and legend labels
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

  if(missing(lab_1)){ # standard label of data set 1
    lab_1 <- "data set 1"
  } else {
    lab_1 <- lab_1 # customized label of data set 1
  }

  if(missing(lab_2)){ # standard label of data set 2
    lab_2 <- "data set 2"
  } else {
    lab_2 <- lab_2 # customized label of data set 2
  }

  # create plot
  my_plot <- ggplot2::ggplot()+
    geom_line(data=ras_data_1, aes(x=date_flag,y=mean_value,color="mediumorchid4"),size=0.5)+
    geom_point(data=ras_data_1, aes(x=date_flag,y=mean_value,color="mediumorchid4"),size=1)+
    labs(x=x_lab,y=y_lab,title=title)+
    stat_smooth(data=ras_data_1, aes(x=date_flag,y=mean_value),color = "lightblue4", fill = "lightblue2",method = "loess",size=0.5)+ # smoothening - LOESS local polynomial regression fitting
    geom_line(data=ras_data_2,aes(x=date_flag,y=mean_value,color="peru"),size=0.5)+
    geom_point(data=ras_data_2,aes(x=date_flag,y=mean_value,color="peru"),size=1)+
    stat_smooth(data=ras_data_2,aes(x=date_flag,y=mean_value),color = "khaki4", fill = "khaki1",method = "loess",size=0.5)+ # smoothening - LOESS local polynomial regression fitting
    facet_grid(stat_name ~.)+ # split plots by station and show station name (or note that whole scene was taken)
    theme(legend.position="top")+
    scale_color_manual(values=c("mediumorchid4","peru"),name="",labels = c(lab_1,lab_2))

  # show plot in new window
  x11()
  print(my_plot)

  # return plot
  return(my_plot)

}
