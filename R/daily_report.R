#' Get daily report data from API
#' @param site site id.
#' @param start_date character string for start date in ddmmyyyy format.
#' @param end_date character string for end date in ddmmyyyy format.
#' @param page page.
#' @param page_size. page size. Default 50.
#' @return Tibble of information about traffic per day in 15 minute intervals.
#' @export
daily_report <- function(
    site,
    start_date,
    end_date,
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