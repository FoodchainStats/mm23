# Extract the January weights from  the ONS detailed reference tables
# spreadsheet. They are not included in mm23 which only has the weight at
# annual level. Exclude certain cdids since they are either duplicated or do
# not appear in the mm23 data
get_weights_jan <- function(measure = "cpi") {

  measure <- tolower(measure)

  if (measure == "cpih") {
    params <- list(sheet = "Table 11",
                   rowmin = 7,
                   rowmax = 371,
                   colmin = 1,
                   exclude = c("L5DD", "L5DE", "L5F3",
                               "L5F4", "L5FP", "J4XP",
                               "L5G8")
                   )
  } else if (measure == "cpi") {
    params <- list(sheet = "Table 25",
                   rowmin = 6,
                   rowmax = 366,
                   colmin = 1,
                   exclude = c("ICVH", "ICVI", "CJXN",
                               "CJXO", "CJYB", "L8LF")
                   )
  } else {
    stop("measure must be 'cpi' or 'cpih'")
  }

  # dowmload the reference table spreadsheet
  url <- reftables_url()

  tmp <- tempfile()
  acquire_safe(url, tmp, type = "binary")

  janweights <- tidyxl::xlsx_cells(tmp, sheets = params$sheet) |>
    dplyr::filter(row >= params$rowmin & row < params$rowmax & col > params$colmin) |>
    unpivotr::behead("up", "year") |>
    unpivotr::behead("left", "cdid") |>
    unpivotr::behead("left", "title")  |>
    dplyr::filter(!is.na(numeric)) |>
    dplyr::filter(stringr::str_detect(.data$year, "Jan") == TRUE) |>
    dplyr::mutate(date = lubridate::ym(.data$year),
                  cdid = stringr::str_trim(.data$cdid)) |>
    dplyr::select(date, "cdid", value = numeric) |>
    dplyr::filter(!.data$cdid %in% params$exclude) |>
    unique()

  return(janweights)


}



#' Create a weights dataset
#'
#' @param rawfile A downloaded mm23.csv file. If missing will attempt to
#'   download from ONS.
#' @param measure The inflation figure to get weights for. Defaults to "CPI",
#'   can be "CPIH"
#'
#' @return A dataframe of monthly weights, including the January weights which
#'   are not exposed in mm23 but only available in the reference tables
#'   spreadsheet.
#' @export
#'
#' @examples
#' \dontrun{
#' weights <- get_weights()
#' cpih_weights <- get_weights(measure = "cpih")
#' }
get_weights <- function(rawfile, measure = "cpi") {

  measure <- tolower(measure)
  if (measure == "cpi") {
    cat = "CPI Weights"
  } else if (measure == "cpih") {
    cat = "CPIH Weights"
  } else {
    stop("measure must be 'cpi' or 'cpih'")
  }

  if(!missing(rawfile)){
    if(!file.exists(rawfile)) stop(paste(rawfile, "does not exist"))
  }

  if(missing(rawfile)){
    mm23 <- acquire_mm23()
  } else {
    mm23 <- rawfile
  }

  metadata <- get_mm23_metadata(mm23)
  yr <- get_mm23_year(mm23)
  janweights <- get_weights_jan(measure = measure)
  maxdate <- lubridate::floor_date(
    lubridate::`%m-%`(lubridate::dmy(metadata$release_date[1]), months(1)),
    unit = "months") |>
    as.character()

  wts <- metadata |>
    dplyr::filter(.data$category == cat) |>
    dplyr::select("cdid") |>
    unlist()

  make_weight_series <- function(annual_data,
                                 series,
                                 start = "1998-01-01",
                                 end = maxdate) {
    data <- annual_data |>
      dplyr::filter(.data$cdid == series)
    dates <- data.frame(date = (seq.Date(as.Date(start), as.Date(end),by = "month")))
    weights <- dates |>
      dplyr::left_join(data, by = dplyr::join_by(date)) |>
      tidyr::fill("cdid":"period", .direction = "down")

    return(weights)
  }

  weights <- purrr::map(wts,
                        make_weight_series,
                        annual_data = yr,
                        .progress = paste("Getting", measure, "weights")) |>
    purrr::list_rbind() |>
    dplyr::select(-"period") |>
    tibble::as_tibble()

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
  acquire_safe(url, tmp, type = "binary")

  cpih_series_ref <- tidyxl::xlsx_cells(tmp, sheets = "Table 3") |>
    dplyr::filter(row >= 10 & row <= 182 & col <= 6 & col != 5) |>
    unpivotr::behead("left", "weight") |>
    unpivotr::behead("left", "index") |>
    unpivotr::behead("left", "rate_monthly") |>
    unpivotr::behead("left", "rate_annual") |>
    dplyr::select(title = "character", "index", "weight", "rate_annual", "rate_monthly") |>
    dplyr::filter(!is.na(.data$title) == TRUE)

  return(cpih_series_ref)


}



