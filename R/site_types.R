#' Get sensor site type data from API
#' @return Tibble of information about site types
#' @export
site_types <- function() {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call_site_types <- glue::glue("{url}/sitetypes")
  site_types_df <- jsonlite::fromJSON(api_call_site_types) 
  sitetypes <- site_types_df["sitetypes"][[1]] 
  return(sitetypes)
}