% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dwd_read_phase_info.R
\name{dwd_read_phase_info}
\alias{dwd_read_phase_info}
\title{Read DWD phenological stage info file into R}
\usage{
dwd_read_phase_info(dir)
}
\arguments{
\item{dir}{directory where info file that shall be imported is located, including full file name.}
}
\value{
A tidyverse tibble containing the DWD phenological stage info file data.
}
\description{
This function allows you to import a DWD phenological stage information meta file into R as a tidyverse tibble.
}
