source("R/functions.R")


# Get sites ---------------------------------------------------------------

sites <- get_sites()
readr::write_csv(sites, "data/sites.csv")


# Get site types ----------------------------------------------------------

site_types <- get_site_types()
readr::write_csv(site_types, "data/site_types.csv")


# Daily reports -----------------------------------------------------------

readr::read_csv("data/sites.csv") |> 
  tibble::as_tibble() |> 
  dplyr::filter(Description == "30361533") |> 
  dplyr::pull(Id)
daily_7090 <- get_daily_reports(site = 7090, page_size = 2000)
readr::write_csv(daily_7090, "data/daily_report_7090_19Jun2023.csv")


# Monthly reports ---------------------------------------------------------

readr::read_csv("data/sites.csv") |> 
  tibble::as_tibble() |> 
  dplyr::filter(Description == "30361533") |> 
  dplyr::pull(Id)
monthly_7090 <- get_monthly_reports(site = 7090)
readr::write_csv(monthly_7090, "data/monthly_report_7090_June2023.csv")

