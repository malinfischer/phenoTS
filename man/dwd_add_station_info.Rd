% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dwd_add_station_info.R
\name{dwd_add_station_info}
\alias{dwd_add_station_info}
\title{Add station info to data file}
\usage{
dwd_add_station_info(dwd_data)
}
\arguments{
\item{dwd_data}{tibble containing DWD observation data to which station information shall be added = return of \code{\link{dwd_read}}.}
}
\value{
A tidyverse tibble containing the merged observation and station data.
}
\description{
This function allows you to add station information to an observation data tibble. The matching DWD meta file containing relevant station information is processed and joined.
}
\examples{
# read DWD file into R
my_file <- dwd_read(my_dir) # result: tidyverse tibble

# add station information
my_file <- dwd_add_station_info(my_file)

}
