#' Get January CPIH weights
#'
#' @return A dataframe of the January weights as published in Table 11 of the
#'   CPI reference tables spreadsheet. They are not included in mm23 which only
#'   has the weight at annual level.
#'
#' @examples
#' \dontrun{
#' get_cpih_weights_jan()
#' }
get_cpih_weights_jan <- function() {
  url <- reftables_url()

  tmp <- tempfile()
  utils::download.file(url, tmp)

# Extract the January weights from Table 11 in the ONS detailed reference tables
# spreadsheet. Exclude certain cdids since they are either duplicated or do not
# appear in the mm23 data
  janweights <- tidyxl::xlsx_cells(tmp, sheets = "Table 11") |>
    dplyr::filter(row >=7 & row < 371 & col > 1) |>
    unpivotr::behead("up", "year") |>
    unpivotr::behead("left", "cdid") |>
    unpivotr::behead("left", "title")  |>
    dplyr::filter(!is.na(numeric)) |>
    dplyr::filter(stringr::str_detect(.data$year, "Jan") == TRUE) |>
    dplyr::mutate(date = lubridate::ym(.data$year),
                  cdid = stringr::str_trim(.data$cdid)) |>
    dplyr::select(date, .data$cdid, value = numeric) |>
    dplyr::filter(!.data$cdid %in% c("L5DD",
                                     "L5DE",
                                     "L5F3",
                                     "L5F4",
                                     "L5FP",
                                     "J4XP",
                                     "L5G8")) |>
    unique()

  return(janweights)


}






#' Create a CPIH weights dataset
#'
#' @param rawfile A downloaded mm23.csv file. If missing will attempt to
#'   download from ONS.
#'
#' @return A dataframe of monthly CPIH weights, including the January weights
#'   which are not exposed in mm23 but only available in the Table 11 sheet of
#'   the reference tables spreadsheet.
#' @export
#'
#' @examples
#' \dontrun{
#' weights <- get_cpih_weights()
#' }
get_cpih_weights <- function(rawfile) {

  if(missing(rawfile)){
    mm23 <- acquire_mm23()
  } else {
    mm23 <- rawfile
  }

  metadata <- get_mm23_metadata(mm23)
  yr <- get_mm23_year(mm23)
  janweights <- get_cpih_weights_jan()

  wts <- metadata |>
    dplyr::filter(.data$category == "CPIH Weights") |>
    dplyr::select(.data$cdid) |>
    unlist()

  make_weight_series <- function(annual_data,
                                 series,
                                 start = "1998-01-01",
                                 end = "2023-12-01") {
    data <- annual_data |>
      dplyr::filter(.data$cdid == series)
    dates <- data.frame(date = (seq.Date(as.Date(start), as.Date(end),by = "month")))
    weights <- dates |>
      dplyr::left_join(data, by = dplyr::join_by(date)) |>
      tidyr::fill(.data$cdid:.data$period, .direction = "down")

    return(weights)
  }

  weights <- purrr::map(wts, make_weight_series, annual_data = yr, .progress = "Getting weights") |>
    purrr::list_rbind() |>
    dplyr::select(-.data$period)

  final_weights <- dplyr::rows_update(weights, janweights, by = c("date", "cdid"))

  return(final_weights)
}





#' Get a reference table of CPIH CDIDs
#'
#' @return A data frame of CDIDs for overall index, weight, 1 month rate and 12
#'   month rate for all CPIH series. Can be useful as a reference table.
#' @export
#'
#' @examples
#' \dontrun{
#' lookup <- get_cpih_cdid_lookup()
#' }
get_cpih_cdid_lookup <- function() {
  url <- reftables_url()

  tmp <- tempfile()
  utils::download.file(url, tmp)

  cpih_series_ref <- tidyxl::xlsx_cells(tmp, sheets = "Table 3") |>
    dplyr::filter(row >= 10 & row <= 182 & col <= 6 & col != 5) |>
    unpivotr::behead("left", "weight") |>
    unpivotr::behead("left", "index") |>
    unpivotr::behead("left", "rate_monthly") |>
    unpivotr::behead("left", "rate_annual") |>
    dplyr::select(title = .data$character, .data$index, .data$weight, .data$rate_annual, .data$rate_monthly) |>
    dplyr::filter(!is.na(.data$title) == TRUE)

  return(cpih_series_ref)


}




#' Get January CPI weights
#'
#' @return A dataframe of the January weights as published in Table 11 of the
#'   CPI reference tables spreadsheet. They are not included in mm23 which only
#'   has the weight at annual level.
#'
#' @examples
#' \dontrun{
#' get_cpi_weights_jan()
#' }
get_cpi_weights_jan <- function() {
  url <- reftables_url()

  tmp <- tempfile()
  utils::download.file(url, tmp)

  # Extract the January weights from Table 11 in the ONS detailed reference tables
  # spreadsheet. Exclude certain cdids since they are either duplicated or do not
  # appear in the mm23 data
  janweights <- tidyxl::xlsx_cells(tmp, sheets = "Table 25") |>
    dplyr::filter(row >=6 & row < 366 & col > 1) |>
    unpivotr::behead("up", "year") |>
    unpivotr::behead("left", "cdid") |>
    unpivotr::behead("left", "title")  |>
    dplyr::filter(!is.na(numeric)) |>
    dplyr::filter(stringr::str_detect(.data$year, "Jan") == TRUE) |>
    dplyr::mutate(date = lubridate::ym(.data$year),
                  cdid = stringr::str_trim(.data$cdid)) |>
    dplyr::select(date, .data$cdid, value = numeric) |>
    dplyr::filter(!.data$cdid %in% c("ICVH",
                                     "ICVI",
                                     "CJXN",
                                     "CJXO",
                                     "CJYB",
                                     "L8LF")) |>
    unique()

  return(janweights)


}




#' Create a CPI weights dataset
#'
#' @param rawfile A downloaded mm23.csv file. If missing will attempt to
#'   download from ONS.
#'
#'
#' @return A dataframe of monthly CPIH weights, including the January weights
#'   which are not exposed in mm23 but only available in the Table 11 sheet of
#'   the reference tables spreadsheet.
#' @export
#'
#' @examples
#' \dontrun{
#' weights <- get_cpi_weights()
#' }
get_cpi_weights <- function(rawfile) {

  if(missing(rawfile)){
    mm23 <- acquire_mm23()
  } else {
    mm23 <- rawfile
  }

  mm23 <- acquire_mm23()
  metadata <- get_mm23_metadata(mm23)
  yr <- get_mm23_year(mm23)
  janweights <- get_cpi_weights_jan()

  wts <- metadata |>
    dplyr::filter(.data$category == "CPI Weights") |>
    dplyr::select(.data$cdid) |>
    unlist()

  make_weight_series <- function(annual_data,
                                 series,
                                 start = "1998-01-01",
                                 end = "2023-12-01") {
    data <- annual_data |>
      dplyr::filter(.data$cdid == series)
    dates <- data.frame(date = (seq.Date(as.Date(start), as.Date(end),by = "month")))
    weights <- dates |>
      dplyr::left_join(data, by = dplyr::join_by(date)) |>
      tidyr::fill(.data$cdid:.data$period, .direction = "down")

    return(weights)
  }

  weights <- purrr::map(wts, make_weight_series, annual_data = yr, .progress = "Getting weights") |>
    purrr::list_rbind() |>
    dplyr::select(-.data$period)

  final_weights <- dplyr::rows_update(weights, janweights, by = c("date", "cdid"))

  return(final_weights)
}





