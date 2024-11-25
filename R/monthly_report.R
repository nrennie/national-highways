#' Get monthly report data from API
#' @param site site id.
#' @param start_date character string for start date in ddmmyyyy format.
#' @param end_date character string for end date in ddmmyyyy format.
#' @param page Page. Default 1.
#' @param page_size. Page size i.e. number of rows to return. Default 50.
#' @return Tibble of information about traffic per day.
#' @export
monthly_report <- function(
    site,
    start_date,
    end_date,
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