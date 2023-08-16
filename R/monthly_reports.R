# https://webtris.highwaysengland.co.uk/api/swagger/ui/index
# https://webtris.nationalhighways.co.uk/

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
    dplyr::mutate(across(c(Year, DayNumber, FlowValue, LargeVehiclePercentage), as.numeric))
  return(output)
}

# Call function and save data
readr::read_csv("data/sites.csv") |> 
  tibble::as_tibble() |> 
  dplyr::filter(Description == "30361533") |> 
  dplyr::pull(Id)
monthly_7090 <- get_monthly_reports(site = 7090)
readr::write_csv(monthly_7090, "data/monthly_report_7090_June2023.csv")
