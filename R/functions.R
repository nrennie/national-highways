# https://webtris.highwaysengland.co.uk/api/swagger/ui/index
# https://webtris.nationalhighways.co.uk/

# Daily reports -----------------------------------------------------------

#' Function to get data from API
#' @param site site id.
#' @param start_date character string for start date in ddmmyyyy format.
#' @param end_date character string for end date in ddmmyyyy format.
#' @param page page.
#' @param page_size. page size. Default 50.
get_daily_reports <- function(
    site = 7090,
    start_date = "19062023",
    end_date = "25072023",
    page = 1,
    page_size = 1000) {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call <- glue::glue("{url}/reports/daily?sites={site}&start_date={start_date}&end_date={end_date}&page={page}&page_size={page_size}")
  api_df <- jsonlite::fromJSON(api_call)
  output <- api_df$Rows |>
    tibble::as_tibble() |>
    dplyr::mutate(SiteId = as.character(site), .before = 1) |> 
    dplyr::mutate(dplyr::across(`Time Interval`:`Total Volume`, as.numeric))
  return(output)
}


# Monthly reports ---------------------------------------------------------

#' Function to get data from API
#' @param site site id.
#' @param start_date character string for start date in ddmmyyyy format.
#' @param end_date character string for end date in ddmmyyyy format.
#' @param page page.
#' @param page_size. page size. Default 50.
get_monthly_reports <- function(
    site = 7090,
    start_date = "01062023",
    end_date = "30062023",
    page = 1,
    page_size = 50) {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call <- glue::glue("{url}/reports/monthly?sites={site}&start_date={start_date}&end_date={end_date}&page={page}&page_size={page_size}")
  api_df <- jsonlite::fromJSON(api_call) 
  output <- api_df$MonthCollection |> 
    tibble::as_tibble() |> 
    tidyr::separate(col = Month, into = c("Month", "Year"), sep = " ") |>
    tidyr::unnest(Days) |> 
    dplyr::rename(DayOfWeek = DayName) |> 
    dplyr::select(
      SiteId, Year, Month, DayNumber, DayOfWeek, FlowValue, 
      LargeVehiclePercentage
    ) |> 
    dplyr::mutate(dplyr::across(c(Year, DayNumber, FlowValue, LargeVehiclePercentage), as.numeric))
  return(output)
}


# Get sites ---------------------------------------------------------------

# Function to get data from API
get_sites <- function() {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call_sites <- glue::glue("{url}/sites")
  sites_df <- jsonlite::fromJSON(api_call_sites) 
  sites <- sites_df["sites"][[1]] 
  return(sites)
}


# Get site types ----------------------------------------------------------

# Function to get data from API
get_site_types <- function() {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call_site_types <- glue::glue("{url}/sitetypes")
  site_types_df <- jsonlite::fromJSON(api_call_site_types) 
  sitetypes <- site_types_df["sitetypes"][[1]] 
  return(sitetypes)
}