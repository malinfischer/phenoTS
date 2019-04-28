#' @title Plot one time-series per DWD station for two crops.
#'
#' @description This function allows you to plot one time-series per DWD station for two DWD data sets (e.g. two different crops). Specific stations can be filtered beforehand. For other filter operations use ggplot2:filter() to create customized data set. Furthermore, LOESS smoothening (local polynomial regression fitting) is applied.
#'
#' @param dwd_data_1 tibble 1 containing DWD observation data (pre-processed, with station + phase information) which shall be plotted.
#' @param dwd_data_2 tibble 2 containing additional DWD observation data.
#' @param stat_ids station ID(s) of station(s) which shall be plotted (optional). If empty, all stations are plotted.
#' @param title plot title (optional).
#' @param lab_1 legend label data set 1 (optional).
#' @param lab_2 legend label data set 2 (optional).
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

dwd_plot_2_ts <- function(dwd_data_1,dwd_data_2,stat_ids,title,lab_1,lab_2){

  # set + update ggplot2 theme
  ggplot2::theme_set(theme_bw()) # ggplot theme
  ggplot2::theme_update(plot.title = element_text(hjust = 0.5)) # all titles centered

  # select stations by stat_id if stat_ids is not empty
  if(!missing(stat_ids)){
    dwd_data_1 <- dplyr::filter(dwd_data_1, stat_id %in% stat_ids)
  }

  if(!missing(stat_ids)){
    dwd_data_2 <- dplyr::filter(dwd_data_2, stat_id %in% stat_ids)
  }

  # set title
  if(missing(title)){ # standard title
    title <- "Time-series DWD phenology data"
  } else {
    title <- title # customized title
  }

  # set legend labels
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

  # plot time-series
  my_plot <- ggplot2::ggplot()+
    geom_line(data=dwd_data_1, aes(x=ref_year,y=entry_doy,color="springgreen4"),size=0.5)+
    geom_point(data=dwd_data_1, aes(x=ref_year,y=entry_doy,color="springgreen4"),size=1)+
    labs(x="Year",y="DOY phase entry",title=title)+
    stat_smooth(data=dwd_data_1, aes(x=ref_year,y=entry_doy),color = "tan4", fill = "tan",method = "loess",size=0.5)+ # smoothening - LOESS local polynomial regression fitting
    geom_line(data=dwd_data_2,aes(x=ref_year,y=entry_doy,color="darkorange"),size=0.5)+
    geom_point(data=dwd_data_2,aes(x=ref_year,y=entry_doy,color="darkorange"),size=1)+
    stat_smooth(data=dwd_data_2,aes(x=ref_year,y=entry_doy),color = "red3", fill = "coral",method = "loess",size=0.5)+ # smoothening - LOESS local polynomial regression fitting
    facet_grid(stat_name ~.)+ # split plots by station and show station name
    theme(legend.position="top")+ # add legend on top of plot
    scale_color_manual(values=c("springgreen4","darkorange"),name="",labels = c(lab_1,lab_2))+ # legend labels

  # show plot in new window
  x11()
  print(my_plot)

  return(my_plot)

}
