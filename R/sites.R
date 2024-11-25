#' Get sensor site data from API
#' @return Tibble of information about site locations
#' @export
sites <- function() {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call_sites <- glue::glue("{url}/sites")
  sites_df <- jsonlite::fromJSON(api_call_sites)
  sites <- sites_df["sites"][[1]]
  return(sites)
}
