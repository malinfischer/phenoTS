################################################
###### R-Package phenoTS - examplary code ######
################################################

### install and activate phenoTS package

# devtools package - necessary to get package from github
install.packages("devtools")
library(devtools)

# phenoTS package from github
devtools::install_github("malinfischer/phenoTS")
library(phenoTS)


### download DWD phenology data
### INFO ###
# 

# set directory where files shall be saved - modify!
my_dir <- "C:/Users/Malin/Documents/Studium/Wuerzburg/Programming_Geostatistics/R_Pheno_Project/data"

# download
dwd_download("RBU",1900,2019,"JMSM",my_dir)
dwd_download("FIC",1900,2019,"JMSM",my_dir) 




