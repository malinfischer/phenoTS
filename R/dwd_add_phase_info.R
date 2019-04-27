#' @title Add phase info to data file
#'
#' @description This function allows you to add phenological phase information to an observation data file.
#'
#' @param dwd_data a tibble containing DWD observation data to which station information shall be added = return of function dwd_read(dir).
#'
#' @return A tidyverse tibble containing the merged observation and phase data.
#'
#' @import tidyverse
#'
#' @export
#'
#' @examples
#' # test example
#'
#'

dwd_add_phase_info <- function(dwd_data){

  ### Step 1: Create full path to phase information file based on file name and location

  ## file location

  # get original file directory from dir column
  dir <- dwd_data$dir[1]

  # get index of second last "/" - for location of station info file = two folders "above" original file's location
  i_all <- stringr::str_locate_all(dir,"/") # list of all "/" indices
  i_2last <- i_all[[1]][(length(i_all[[1]][,1])-1)] # index of second last "/"

  dir_info <- stringr::str_sub(dir,1,i_2last) # ends with "/"


  ## file name - reporter type + overall crop type needed

  # get reporter type
  # --> check if dir contains "Jahresmelder" (annual reporter) or "Sofortmelder" (immediate reporter)
  if(stringr::str_detect(dir,"Jahresmelder")){
    rep_type <- "Jahresmelder"
  } else if(stringr::str_detect(dir,"Sofortmelder")) {
    rep_type <- "Sofortmelder"
  } else {
    print("Error while identifying reporter type.")
  }

  # get overall crop type (agriculture, fruit, etc.)
  crop_abbr <- stringr::str_sub(dir,i_2last+1,i_2last+3) # get crop abbreviation from folder name of file path

  crops_list <- c("DGR","FKV","FKN","FRU","GBO","GER","HAF","LUZ","MAI","RKL","RUE","ROS","SOG","SOW","SBL","SKA","TOM","WKO","WGE","WRA","WRO","WWZ","ZRU")
  farming_list <- c("FAR","WGA")
  fruit_list <- c("APF","AFR","AMR","ASR","APR","BIR","BFR","BSR","BRO","ERD","HIM","JOH","PFI","PFL","PFR","PSR","RJO","SAK","STA","SUK","SFR","SSR")
  vine_list <- c("WBT","WFA","WMT","WIR","WSC","WFR","WMR","WSR")
  wild_list <- c("ELA","FJA","FIC","FLI","FOR","GOL","HBI","HAS","HKR","HZL","HUF","HRO","KIE","KOR","LWZ","ROB","ROK","RBU","SWE","SLH","SBE","SGL","SER","SHO","SLI","SAH","SEI","TAN","TRA","WFU","WKN","WLI","ZWD")

  if(crop_abbr %in% crops_list){
    crop_type <- "Landwirtschaft_Kulturpflanze"
  } else if(crop_abbr %in% farming_list){
    crop_type <- "Feldarbeit"
  } else if(crop_abbr %in% fruit_list){
    crop_type <- "Obst"
  } else if(crop_abbr %in% vine_list){
    crop_type <- "Weinrebe"
  } else if(crop_abbr %in% wild_list){
    crop_type <- "Wildwachsende_Pflanze"
  } else {
    # error message for invalid input
    cat("Error while identifying overall crop type.")
  }

  ## create full path to phase information file
  path_phase_info <- paste0(dir_info,"PH_Beschreibung_Phasendefinition_",rep_type,"_",crop_type,".txt")


  ### Step 2: read phase info file
  # based on function dwd_read_phase_info
  phase_info <- dwd_read_phase_info(path_phase_info)


  ### Step 3: join data file and phase info file

  # remove potential duplicates in phase info file (e.g. GRL)
  phase_info <- dplyr::distinct(phase_info)

  my_joined_file <- dplyr::left_join(dwd_data,phase_info,by=c("phase_id","obj_id"))

  return(my_joined_file)

}
