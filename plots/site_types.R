# https://webtris.highwaysengland.co.uk/api/swagger/ui/index
# https://webtris.nationalhighways.co.uk/

# Function to get data from API
get_site_types <- function() {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call_site_types <- glue::glue("{url}/sitetypes")
  site_types_df <- jsonlite::fromJSON(api_call_site_types) 
  sitetypes <- site_types_df["sitetypes"][[1]] 
  return(sitetypes)
}

# Call function and save data
site_types <- get_site_types()
readr::write_csv(site_types, "data/site_types.csv")
