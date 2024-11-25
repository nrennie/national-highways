#' Get monthly report data from API
#' @param site site id.
#' @param start_date character string for start date in ddmmyyyy format.
#' @param end_date character string for end date in ddmmyyyy format.
#' @param page Page. Default 1.
#' @param page_size. Page size i.e. number of rows to return. Default 50.
#' @importFrom rlang .data
#' @return Tibble of information about traffic per day.
#' @export
monthly_report <- function(
    site,
    start_date,
    end_date,
    page = 1,
    page_size = 50) {
  url <- "http://webtris.nationalhighways.co.uk/api/v1.0"
  api_call <- glue::glue(
    "{url}/reports/monthly?sites={site}&start_date={start_date}&end_date={end_date}&page={page}&page_size={page_size}" # nolint
  )
  api_df <- jsonlite::fromJSON(api_call)
  output <- api_df$MonthCollection |>
    tibble::as_tibble() |>
    tidyr::separate(
      col = .data$Month,
      into = c("Month", "Year"),
      sep = " "
    ) |>
    tidyr::unnest(.data$Days) |>
    dplyr::rename(DayOfWeek = .data$DayName) |>
    dplyr::select(
      .data$SiteId, .data$Year, .data$Month,
      .data$DayNumber, .data$DayOfWeek, .data$FlowValue,
      .data$LargeVehiclePercentage
    ) |>
    dplyr::mutate(
      dplyr::across(
        c(
          .data$Year, .data$DayNumber,
          .data$FlowValue, .data$LargeVehiclePercentage
        ),
        as.numeric
      )
    )
  return(output)
}
