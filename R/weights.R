#' Get January CPIH weights
#'
#' @return
#'
#' @examples
get_weights_jan <- function() {
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






#' Title
#'
#' @return
#' @export
#'
#' @examples
get_cpih_weights <- function() {

  mm23 <- acquire_mm23()
  metadata <- get_mm23_metadata(mm23)
  yr <- get_mm23_year(mm23)
  janweights <- get_weights_jan()

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
      dplyr::left_join(data) |>
      tidyr::fill(.data$cdid:.data$period, .direction = "down")

    return(weights)
  }

  weights <- purrr::map(wts, make_weight_series, annual_data = yr) |>
    purrr::list_rbind() |>
    dplyr::select(-.data$period)

  final_weights <- dplyr::rows_update(weights, janweights, by = c("date", "cdid"))

  return(final_weights)
}



# make_weight_series <- function(annual_data, series, start = "1998-01-01", end = "2023-12-01") {
#   data <- annual_data |>
#     dplyr::filter(.data$cdid == series)
#
#   dates <- data.frame(date = (seq.Date(as.Date(start), as.Date(end),by = "month")))
#
#   weights <- dates |>
#     dplyr::left_join(data) |>
#     tidyr::fill(cdid:period, .direction = "down")
#
#   return(weights)
# }









