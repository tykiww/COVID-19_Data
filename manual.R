

# Initialize
utilities = "https://raw.githubusercontent.com/tykiww/COVID-19_Data/master/utilities.R"
configuration = "https://raw.githubusercontent.com/tykiww/COVID-19_Data/master/config.yml"
download.file(url = configuration, destfile = "config.yml")
config <- config::get(file="config.yml")
source(utilities)




# main

main <- function(destination) {
  
  # Retrieve Request
  raw = common$scraper(config$folder_url,
                       config$xml_tag)
  # Extract csv names
  urls = common$extractor(raw,config$base_url)
  
  # Retrieve Tables
  dfs = lapply(urls, function(x) dplyr::select(readr::read_csv(x), config$columns))
  
  # Check table for date format
  idds = sapply(1:length(urls),function(x) common$checker(x,dfs))
  
  # Format Dates
  insert = lapply(1:sum(idds),function(x) common$manipulator(dfs[idds][[x]]))
  dfs[idds] = insert
  
  # Reformat for output and clean
  final_df = do.call(rbind,dfs)
  common$cleaner(c("final_df","common"))
  
  return(final_df)
}



# If scripting, it will write a csv. otherwise this can be used as a source() file
if (!interactive()) {
  write.csv(main(),"covid_data.csv")
} else {
  df = main()
}





