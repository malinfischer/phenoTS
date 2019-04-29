#' @title List available DWD crops and abbreviations
#'
#' @description This function allows you to get and view a list of all crops with available phenological observations by the DWD. Names, overall crop type as well as abbreviation used in other functions are shown.
#'
#' @return A tidyverse tibble containing information on all available crops, their overall type and abbreviation used for other functions.
#'
#' @import tidyverse
#'
#' @export
#'

dwd_crop_list <- function(){

  # define abbreviations, full names for each overall crop type - partly taken from dwd_download()
  crops_list <- c("DGR","FKV","FKN","FRU","GBO","GER","HAF","LUZ","MAI","RKL","RUE","ROS","SOG","SOW","SBL","SKA","TOM","WKO","WGE","WRA","WRO","WWZ","ZRU")
  crops_list_f <- c("Dauergruenland","Fruehkartoffel vorgekeimt","Fruehkartoffel nicht vorgekeimt","Futter-Ruebe","Gruenpflueck-Bohne","Gruenpflueck-Erbse","Hafer","Luzerne","Mais","Rotklee","Ruebe","Rueben_ohne_Sortenangabe","Sommergerste","Sommerweizen","Sonnenblume","Spaetkartoffel","Tomate","Weisskohl","Wintergerste","Winterraps","Winterroggen","Winterweizen","Zucker-Ruebe")
  crops_type <- replicate(length(crops_list),"agricultural crops")

  farming_list <- c("FAR","WGA")
  farming_list_f <- c("Feldarbeit","Weidegang")
  farming_type <- c("farming","farming")

  fruit_list <- c("APF","AFR","AMR","ASR","APR","BIR","BFR","BSR","BRO","ERD","HIM","JOH","PFI","PFL","PFR","PSR","RJO","SAK","STA","SUK","SFR","SSR")
  fruit_list_f <- c("Apfel","Apfel_fruehe_Reife","Apfel_mittlere_Reife","Apfel_spaete_Reife","Aprikose","Birne","Birne_fruehe_Reife","Birne_spaete_Reife","Brombeere","Erdbeere","Himbeere","Johannisbeere_alle_Sorten","Pfirsich","Pflaume","Pflaume_fruehreifend","Pflaume_spaetreifend","Rote_Johannisbeere","Sauerkirsche","Stachelbeere","Suesskirsche","Suesskirsche_fruehe_Reife","Suesskirsche_spaete_Reife")
  fruit_type <- replicate(length(fruit_list),"fruits")

  vine_list <- c("WBT","WFA","WMT","WIR","WSC","WFR","WMR","WSR")
  vine_list_f <- c("Weinrebe_blaue_Trauben","Wein_Faber","Wein_Mueller-Thurgau","Wein_Riesling","Wein_Scheurebe","Weinrebe_fruehe_Reife","Weinrebe_mittelspaete_Reife","Weinrebe_spaete_Reife")
  vine_type <- replicate(length(vine_list),"vine")

  wild_list <- c("ELA","FJA","FIC","FLI","FOR","GOL","HBI","HAS","HKR","HZL","HUF","HRO","KIE","KOR","LWZ","ROB","ROK","RBU","SWE","SLH","SBE","SGL","SER","SHO","SLI","SAH","SEI","TAN","TRA","WFU","WKN","WLI","ZWD")
  wild_list_f <- c("Europaeische-Laerche","Falscher_Jasmin","Fichte","Flieder","Forsythie","Goldregen","Haenge-Birke","Hasel","Heidekraut","Herbstzeitlose","Huflattich","Hunds-Rose","Kiefer","Kornelkirsche","Loewenzahn","Robinie","Rosskastanie","Rotbuche","Sal-Weide","Schlehe","Schneebeere","Schneegloeckchen","Schwarz-Erle","Schwarzer_Holunder","Sommer-Linde","Spitz-Ahorn","Stiel-Eiche","Tanne","Traubenkirsche","Wiesen-Fuchsschwanz","Wiesen-Knaeuelgras","Winter-Linde","Zweigriffliger_Weissdorn")
  wild_type <- replicate(length(wild_list),"wild")

  # put columns together
  l_abbreviation <- c(crops_list,farming_list,fruit_list,vine_list,wild_list)
  l_full_name <- c(crops_list_f,farming_list_f,fruit_list_f,vine_list_f,wild_list_f)
  l_crop_type <- c(crops_type,farming_type,fruit_type,vine_type,wild_type)

  # create tibble
  crop_tibble <- dplyr::tibble(abbreviation=l_abbreviation,full_name=l_full_name,crop_type=l_crop_type)

  # show full tibble
  View(crop_tibble)

  # return tibble
  return(crop_tibble)

}
