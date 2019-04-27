#' @title DWD phenology data download
#'
#' @description This function allows you to download phenology in-situ observation data provided by the German Meteorological Service (DWD).
#'
#' @param crops crop abbreviation(s) - possible to chose multiple crops, use c("crop1","crop2",...) then.
#' @param start start of observation (year).
#' @param end end of observation (year).
#' @param report reporter type, (Jahresmelder="JM", Sofortmelder="SM", both="JMSM").
#' @param dir_out directory were downloaded files are saved (sub-folders are created within for each crop).
#'
#' @import tidyverse
#' @import RCurl
#'
#' @export
#'
#' @examples
#' # test example
#'

# input: list of crops, start + end of observation (year), SM and/or JM, output folder
dwd_download <- function(crops,start,end,report,dir_out){

  ### STEP 1 ###

  ##  creates 'http_list' for page(s) with files listed and 'file_list' for actual (partial) file name(s) with matching indices ###
  ##  for later accessing download page, getting all file names there and download matching files
  ##  based on input parameters; considers folder structure and naming conventions
  ##  note: not the full file names are created - end is neglected but sufficient for later comparison

  # check whether input arguments are valid + print error message if not
  if(typeof(crops) != "character"){cat("Argument 'crops' should be a 'character' object (crop type(s)). ")}
  if(typeof(start) != "double"){cat("Argument 'start' should be a 'double' object (year of start of observation period). ")}
  if(typeof(end) != "double"){cat("Argument 'end' should be a 'double' object (year of end of observation period). ")}
  if(typeof(report) != "character"){cat("Argument 'report' should be a 'character' object (JM/SM/SMJM/JMSM - type of reporter). ")}
  if(typeof(dir_out) != "character"){cat("Argument 'dir_out' should be a 'character' object (output directory). ")}

  # format dir_out path consistently so that it does not end with "/"
  if(stringr::str_sub(dir_out,-1)=="/"){
    dir_out <- stringr::str_sub(dir_out,1,stringr::str_length(dir_out)-1)
  }

  # create list of https for download by looping through crop list

  http_list <- c()
  file_list <- c()

  base <- "ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/phenology"

  for (i in 1:length(crops)){

    # note: variables appendix _f: for creating file names, otherwise for creating general http name (folder structure)

    # set used booleans to FALSE as default
    smjm_boo <- FALSE
    time_boo <- FALSE


    # define type of reporters dependent on argument 'report' - if SM + JM, 2 files need to be downloaded each!
    if(report=="JM"){
      reporters <- "annual_reporters"
      reporters_f <- "Jahresmelder"
    } else if(report=="SM"){
      reporters <- "immediate_reporters"
      reporters_f <- "Sofortmelder"
    } else if(report=="SMJM" | report=="JMSM"){
      reporters_1 <- "annual_reporters"
      reporters_2 <- "immediate_reporters"
      reporters_f_1 <- "Jahresmelder"
      reporters_f_2 <- "Sofortmelder"
      smjm_boo <- TRUE # for http creation as 2 files need to be downloaded
    } else {
      # error message for invalid input
      cat("Invalid input of argument 'reporters'. Please use 'SM', 'JM', 'SMJM' or 'JMSM' (last 2 ones give the same result)!")
    }


    ## define type of requested crop/info (crops, farming, fruit, vine, wild) and crop name of file based on argument 'crops' (crop abbreviations)

    # create lists of abbreviations and according crop names in file name
    crops_list <- c("DGR","FKV","FKN","FRU","GBO","GER","HAF","LUZ","MAI","RKL","RUE","ROS","SOG","SOW","SBL","SKA","TOM","WKO","WGE","WRA","WRO","WWZ","ZRU")
    crops_list_f <- c("Dauergruenland","Fruehkartoffel vorgekeimt","Fruehkartoffel nicht vorgekeimt","Futter-Ruebe","Gruenpflueck-Bohne","Gruenpflueck-Erbse","Hafer","Luzerne","Mais","Rotklee","Ruebe","Rueben_ohne_Sortenangabe","Sommergerste","Sommerweizen","Sonnenblume","Spaetkartoffel","Tomate","Weisskohl","Wintergerste","Winterraps","Winterroggen","Winterweizen","Zucker-Ruebe")

    farming_list <- c("FAR","WGA")
    farming_list_f <- c("Feldarbeit","Weidegang")

    fruit_list <- c("APF","AFR","AMR","ASR","APR","BIR","BFR","BSR","BRO","ERD","HIM","JOH","PFI","PFL","PFR","PSR","RJO","SAK","STA","SUK","SFR","SSR")
    fruit_list_f <- c("Apfel","Apfel_fruehe_Reife","Apfel_mittlere_Reife","Apfel_spaete_Reife","Aprikose","Birne","Birne_fruehe_Reife","Birne_spaete_Reife","Brombeere","Erdbeere","Himbeere","Johannisbeere_alle_Sorten","Pfirsich","Pflaume","Pflaume_fruehreifend","Pflaume_spaetreifend","Rote_Johannisbeere","Sauerkirsche","Stachelbeere","Suesskirsche","Suesskirsche_fruehe_Reife","Suesskirsche_spaete_Reife")

    vine_list <- c("WBT","WFA","WMT","WIR","WSC","WFR","WMR","WSR")
    vine_list_f <- c("Weinrebe_Weinrebe_blaue_Trauben","Wein_Faber","Wein_Mueller-Thurgau","Wein_Riesling","Wein_Scheurebe","Weinrebe_Weinrebe_fruehe_Reife","Weinrebe_Weinrebe_mittelspaete_Reife","Weinrebe_Weinrebe_spaete_Reife")

    wild_list <- c("ELA","FJA","FIC","FLI","FOR","GOL","HBI","HAS","HKR","HZL","HUF","HRO","KIE","KOR","LWZ","ROB","ROK","RBU","SWE","SLH","SBE","SGL","SER","SHO","SLI","SAH","SEI","TAN","TRA","WFU","WKN","WLI","ZWD")
    wild_list_f <- c("Europaeische-Laerche","Falscher_Jasmin","Fichte","Flieder","Forsythie","Goldregen","Haenge-Birke","Hasel","Heidekraut","Herbstzeitlose","Huflattich","Hunds-Rose","Kiefer","Kornelkirsche","Loewenzahn","Robinie","Rosskastanie","Rotbuche","Sal-Weide","Schlehe","Schneebeere","Schneegloeckchen","Schwarz-Erle","Schwarzer_Holunder","Sommer-Linde","Spitz-Ahorn","Stiel-Eiche","Tanne","Traubenkirsche","Wiesen-Fuchsschwanz","Wiesen-Knaeuelgras","Winter-Linde","Zweigriffliger_Weissdorn")

    # define type and crop name by comparing crops[i] with lists
    if(crops[i] %in% crops_list){
      type <- "crops"
      crop_f <- paste0("Landwirtschaft_Kulturpflanze_",crops_list_f[match(crops[i],crops_list)])
    } else if(crops[i] %in% farming_list){
      type <- "farming"
      crop_f <- paste0(farming_list_f[match(crops[i],farming_list)],"_",farming_list_f[match(crops[i],farming_list)])
    } else if(crops[i] %in% fruit_list){
      type <- "fruit"
      crop_f <- paste0("Obst_",fruit_list_f[match(crops[i],fruit_list)])
    } else if(crops[i] %in% vine_list){
      type <- "vine"
      crop_f <- vine_list_f[match(crops[i],vine_list)]
    } else if(crops[i] %in% wild_list){
      type <- "wild"
      crop_f <- paste0("Wildwachsende_Pflanze_",wild_list_f[match(crops[i],wild_list)])
    } else {
      # error message for invalid input
      cat("Invalid input of argument 'crops'. Please only use valid abbreviations!")
    }


    ## define time (historical/recent) dependent on start/end of observation; 2 files might need to be downloaded!
    if(end <= 2016){
      time <- "historical"
    } else if(end > 2016 & start >= 2016){
      time <- "recent"
    } else if(end > 2016 & start < 2016){
      time_1 <- "historical"
      time_2 <- "recent"
      time_boo <- TRUE # for http creation as 2 files need to be downloaded
    } else {
      # error message for invalid input
      cat("Invalid input of observation period arguments (start/end). Please check (end>=start, valid years, etc.) and try again!")
    }


    ## put together http(s) in http_list and (partial) file name(s) in file_list with matching indices
    if(!smjm_boo){ # only one reporter type

      file_name <- paste0("PH_",reporters_f,"_",crop_f) # same for historical + recent
      if(!time_boo){ # only historic or recent

        file_http <- paste(base,reporters,type,time,file_name,sep="/")
        file_list <- append(file_list,file_http)

        http <- paste(base,reporters,type,time,sep="/")
        http_list <- append(http_list,http)

      } else { # both historic + recent

        file_list <- append(file_list,c(file_name,file_name)) # twice because 2 files

        http_1 <- paste(base,reporters,type,time_1,sep="/")
        http_2 <- paste(base,reporters,type,time_2,sep="/")
        http_list <- append(http_list,c(http_1,http_2))

      }

    } else { # 2 reporter types

      file_name_1 <- paste0("PH_",reporters_f_1,"_",crop_f)
      file_name_2 <- paste0("PH_",reporters_f_2,"_",crop_f)

      if(!time_boo){ # only historic or recent

        file_list <- append(file_list,c(file_name_1,file_name_2))

        http_1 <- paste(base,reporters_1,type,time,sep="/")
        http_2 <- paste(base,reporters_2,type,time,sep="/")
        http_list <- append(http_list,c(http_1,http_2))

      } else { # both historic + recent

        file_list <- append(file_list,c(file_name_1,file_name_1,file_name_2,file_name_2))

        http_1 <- paste(base,reporters_1,type,time_1,sep="/")
        http_2 <- paste(base,reporters_1,type,time_2,sep="/")
        http_3 <- paste(base,reporters_2,type,time_1,sep="/")
        http_4 <- paste(base,reporters_2,type,time_2,sep="/")
        http_list <- append(http_list,c(http_1,http_2,http_3,http_4))

      }
    }


  } # end for step 1


  ### STEP 2: Compare file names (in file_list) with actually available ones accessed using http_list and create list of full https

  # loop through all https created

  http_download <- c() # list of https for final downloads

  for(i in 1:length(http_list)){ # note: same indexing for http_list and file_list!

    http <- paste0(http_list[i],"/")

    #try block as error occurs and function stops if http does not exist (e.g. if no recent records)
    tryCatch({

      content <- RCurl::getURL(http, verbose=TRUE, ftp.use.epsv=TRUE, dirlistonly = TRUE) # get content
      content <- stringr::str_split(content,"\n|\r\n") # split into single file names
      content <- content[[1]] # list to character
      content <- content[1:(length(content)-1)] # delete last empty entry

      # check whether according file in file_list exists on this page and add to http_download list
      for(j in 1:length(content)){

        if(stringr::str_sub(content[j],start=1,end=stringr::str_length(file_list[i]))==file_list[i]){

          http_file <- paste0(http_list[i],"/",content[j])
          http_download <- append(http_download,http_file)

        }

      }

    }, error = function(err){
      print("The following error occurred:")
      print(err)

    }) # end try(Catch)


  } # end for step 2


  ### STEP 3: Download all relevant files in fitting folder structure

  ## get matching type abbreviation for all files in http_download to create according folders + easier access later
  types <- c("crops","farming","fruit","vine","wild")
  abbr_list <- c()

  for(i in 1:length(http_download)){

    counter <- 0 # see below

    if(stringr::str_detect(http_download[i],"crops")){
      for(j in 1:length(crops_list_f)){
        if(stringr::str_detect(http_download[i],crops_list_f[j])){
          abbr_list <- append(abbr_list,crops_list[j])
          counter <- counter + 1}
      }
    }

    if(stringr::str_detect(http_download[i],"farming")){
      for(j in 1:length(farming_list_f)){
        if(stringr::str_detect(http_download[i],farming_list_f[j])){
          abbr_list <- append(abbr_list,farming_list[j])
          counter <- counter + 1}
      }
    }

    if(stringr::str_detect(http_download[i],"fruit")){
      for(j in 1:length(fruit_list_f)){
        if(stringr::str_detect(http_download[i],fruit_list_f[j])){
          abbr_list <- append(abbr_list,fruit_list[j])
          counter <- counter + 1}
      }
    }

    if(stringr::str_detect(http_download[i],"vine")){
      for(j in 1:length(vine_list_f)){
        if(stringr::str_detect(http_download[i],vine_list_f[j])){
          abbr_list <- append(abbr_list,vine_list[j])
          counter <- counter + 1}
      }
    }

    if(stringr::str_detect(http_download[i],"wild")){
      for(j in 1:length(wild_list_f)){
        if(stringr::str_detect(http_download[i],wild_list_f[j])){
          abbr_list <- append(abbr_list,wild_list[j])
          counter <- counter + 1}
      }
    }

    # check if counter > 1 (several matches) and take only one (the first) match (e.g. cases like Apfel + Apfel_fruehe_Reife, ...)
    if(counter>1){
      abbr_list <- abbr_list[1:(length(abbr_list)-(counter-1))]
    }

  } # end for abbr_list


  ## download files of http_download (integrate in for-loop above?)

  for (i in 1:length(http_download)){

    # create folder with matching abbreviation if it does not already exist
    if(!dir.exists(paste0(dir_out,"/",abbr_list[i]))){dir.create(paste0(dir_out,"/",abbr_list[i]))}

    # define file name from http
    http_split <- stringr::str_split(http_download[i],"/")
    file_name <- http_split[[1]][length(http_split[[1]])]

    # download file to this folder - whether already existent or not (for updating)
    try(download.file(http_download[i],paste0(dir_out,"/",abbr_list[i],"/",file_name)))

    print(paste0("file http: ",http_download[i],", dir out: ",paste0(dir_out,"/",abbr_list[i],"/",file_name)))

  } # end for download


  ## download info files to out_dir folder (stage/station descriptions etc.)

  # 1) all starting with PH_ in specific ftp-folder

  http <- "ftp://ftp-cdc.dwd.de/pub/CDC/help/"
  content <- RCurl::getURL(http, verbose=TRUE, ftp.use.epsv=TRUE, dirlistonly = TRUE) # get content
  content <- stringr::str_split(content,"\n|\r\n") # split into single file names
  content <- content[[1]] # list to character
  content <- content[1:(length(content)-1)] # delete last empty entry

  for(i in 1:length(content)){
    if(stringr::str_sub(content[i],1,3)=="PH_"){
      download.file(paste0(http,content[i]),paste0(dir_out,"/",content[i]))
    }
  }

  # 2) phase description in folder with txt-files (using http_list)

  # delete duplicates in http_list
  http_list <- unique(http_list)

  for(i in 1:length(http_list)){

    http_split <- stringr::str_split(http_list[i],"/")
    http_split <- http_split[[1]]

    # define reporters forin file name http (German)
    if(http_split[8]=="annual_reporters"){
      melder <- "Jahresmelder"
    } else if(http_split[8]=="immediate_reporters") {
      melder <- "Sofortmelder"
    }

    # define types for file name http (German)
    if(http_split[9]=="crops"){
      type <- "Landwirtschaft_Kulturpflanze"
    } else if(http_split[9]=="fruit"){
      type <- "Obst"
    } else if(http_split[9]=="farming"){
      type <- "Feldarbeit"                   # !2nd File Weidegang
    } else if(http_split[9]=="vine"){
      type <- "Weinrebe"
    } else if(http_split[9]=="wild"){
      type <- "Wildwachsende_Pflanze"
    }

    http <- paste0("ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/phenology/",http_split[8],"/",http_split[9],"/",http_split[10],"/PH_Beschreibung_Phasendefinition_",melder,"_",type,".txt")

    try(download.file(http,paste0(dir_out,"/PH_Beschreibung_Phasendefinition_",melder,"_",type,".txt")))

  }


} # end function
