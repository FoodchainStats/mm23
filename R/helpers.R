#' Default url for the current mm23 dataset
#'
#' @return url of mm23 data
#' @export
#'
#' @examples
#' url <- mm23_url()
mm23_url <- function() {
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindices/current/mm23.csv"
  return(url)
}


#' Default url for the current mm22 PPI dataset
#'
#' @return url of mm22 data
#' @export
#'
#' @examples
#' url <- mm22_url()
mm22_url <- function() {
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/producerpriceindex/current/mm22.csv"
  return(url)
}

#' Default url for the current PPI dataset
#'
#' @return url of ppi dta
#' @export
#'
#' @examples
#' url <- ppi_url()
ppi_url <- function() {
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/producerpriceindexstatisticalbulletindataset/current/ppi.csv"
  return(url)
}

#' Default url for the CPI reference tables spreadsheet
#'
#' @description Its not clear yet if this url is stable, need to test over
#'   future months.
#'
#' @return url of reference tables
#' @export
#'
#' @examples
#' url <- reftables_url()
reftables_url <- function() {
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceinflation/current/consumerpriceinflationdetailedreferencetables2.xlsx"
  return(url)
}


#' Default url for the CPI average prices spreadsheet
#'
#' Its not clear yet if this url is stable, need to test over future months.
#'
#' @return url of data download spreadsheet
#' @export
#'
#' @examples
#' url <- prices_url()
prices_url <- function() {
  url <- "https://github.com/ONSvisual/cpi-items-actions/raw/main/datadownload.xlsx"
  return(url)
}


#' URL for the page containing CPI price quote downloads
#'
#' @return url of the ONS price quote page
#' @export
#'
#' @examples
#' url <- cpi_price_quotes_url()
cpi_price_quotes_url <- function(){
  url <- "https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes"
  return(url)
}


#' Unchains a CPI series
#'
#' Use with [dplyr::mutate()] to calculate an unchained index. Requires a dataset
#' with a month variable, or use something like lubridate::month(date) to get
#' the month as a number, uses [dplyr::lag()] to unchain using previous values.
#' Assumes that CPI weights change twice a year.
#'
#' @param month The month number for the index
#' @param value The index value
#'
#' @return An unchained index value
#' @export
#'
#' @examples
#' \dontrun{
#' library(mm23)
#' library(dplyr)
#' library(lubridate)
#'
#' mm23 <- acquire_mm23()
#' data <- get_mm23_month(mm23)
#' wts <- get_cpih_weights()
#'
#' food_unchained <- data |>
#'  filter(cdid %in% c("L522", "L523") & date >= "2017-01-01") |>
#'   group_by(cdid) |>
#'   mutate(
#'     unchained_value = unchain(month(date), value)
#'   ) |>
#'   select(date, cdid, value = unchained_value)
#'
#' }
unchain <- function(month, value) {
  dplyr::case_when(
    month == 1 ~ value/dplyr::lag(value) * 100,
    month == 2 ~ value/dplyr::lag(value, 1) * 100,
    month == 3 ~ value/dplyr::lag(value, 2) * 100,
    month == 4 ~ value/dplyr::lag(value, 3) * 100,
    month == 5 ~ value/dplyr::lag(value, 4) * 100,
    month == 6 ~ value/dplyr::lag(value, 5) * 100,
    month == 7 ~ value/dplyr::lag(value, 6) * 100,
    month == 8 ~ value/dplyr::lag(value, 7) * 100,
    month == 9 ~ value/dplyr::lag(value, 8) * 100,
    month == 10 ~ value/dplyr::lag(value, 9) * 100,
    month == 11 ~ value/dplyr::lag(value, 10) * 100,
    month == 12 ~ value/dplyr::lag(value, 11) * 100
  )
}


# download function which should respect ONS rate limiting. See
# https://developer.ons.gov.uk/bots/
acquire_safe <- function(url, filename, type = "string") {
  resp <- httr2::request(url) |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_perform()

  ext <- tools::file_ext(basename(url))

if(ext %in% c("csv")) {
  message("text type detected")
  message(filename)
  resp |>
    httr2::resp_body_string() |>
    # readr::write_file(filename)
    write(filename)
} else
if(ext %in% c("xls", "xlsx", "zip")) {
  message("binary file type detected")
  message(filename)
  resp |>
    httr2::resp_body_raw() |>
    # readr::write_file(filename)
    writeBin(con = filename)
} else {
  stop("unknown file type")
}

}

ignore_unused_imports <- function() {
  # To get rid of NOTE about use of ggplot in vignette
  # https://r-pkgs.org/dependencies-in-practice.html#how-to-not-use-a-package-in-imports

  ggplot2::ggplot()
}
