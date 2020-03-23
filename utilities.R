library(modules)


common <- module({
  require('rvest')
  require('xml2')
  require('dplyr')
  require('readr')
  
  scraper = function(folder_location,xml) {
    # can't use pipes ):
    
    ob = xml2::read_html(folder_location)
    ob = rvest::html_nodes(ob,'body')
    ob = xml2::xml_find_all(ob,xml)
    ob = rvest::html_text(ob)
    out = strsplit(ob,"\n")[[1]]
    return(out)
  }
  
  extractor = function(scraped,url) {
    ob = scraped[grep(".csv",scraped)]
    ob = gsub(" |Update","",ob)
    ob = unique(ob)
    out = paste(url, ob, sep = '')
    return(out)
  }
  
  checker = function(x, dfs) {
    ob = paste(dfs[x][[1]]$`Last Update`,":00",sep='')
    ob = as.Date(ob,'%m/%d/%Y %H:%M:%S')
    ob = !any(is.na(ob))
    return(ob)
  }
  
  manipulator = function(df) {
    ob = df
    ob$`Last Update` = paste(ob$`Last Update`,":00",sep="")
    ob$`Last Update` = as.POSIXct(strptime(ob$`Last Update`,'%m/%d/%Y %H:%M:%S', "UTC"))
    
    return(ob)
  }
  
  cleaner = function(keep) {
    rm(list = ls()[!ls() %in% keep])
    gc()
  }
}
)
