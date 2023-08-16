# https://webtris.highwaysengland.co.uk/api/swagger/ui/index
# https://webtris.nationalhighways.co.uk/

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

# Call function and save data
readr::read_csv("data/sites.csv") |> 
  tibble::as_tibble() |> 
  dplyr::filter(Description == "30361533") |> 
  dplyr::pull(Id)
daily_7090 <- get_daily_reports(site = 7090, page_size = 2000)
readr::write_csv(daily_7090, "data/daily_report_7090_26Jun2023.csv")
