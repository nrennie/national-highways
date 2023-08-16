# https://webtris.highwaysengland.co.uk/api/swagger/ui/index
# https://webtris.nationalhighways.co.uk/

# Function to get data from API
get_sites <- function() {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call_sites <- glue::glue("{url}/sites")
  sites_df <- jsonlite::fromJSON(api_call_sites) 
  sites <- sites_df["sites"][[1]] 
  return(sites)
}

# Call function and save data
sites <- get_sites()
readr::write_csv(sites, "data/sites.csv")
