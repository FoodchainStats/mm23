#' Default url for the current mm23 dataset
#'
#' @return url of mme23 data
#' @export
#'
#' @examples
#' url <- mm23_url()
mm23_url <- function(){
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindices/current/mm23.csv"
  return(url)
}


#' Default url for the CPI reference tables spreadsheet
#'
#' Its not clear yet if this url is stable, need to test over future months.
#'
#' @return url of reference tables
#' @export
#'
#' @examples
#' url <- reftables_url()
reftables_url <- function(){
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceinflation/current/consumerpriceinflationdetailedreferencetables2.xlsx"
  return(url)
}

#' Hopefully unchains a CPI series
#'
#' Requires a data set with a month variable, uses dplyr::lag to unchain using
#' previous values. Assumes that CPI weights change twice a year.
#'
#' @param month The month number for the index
#' @param value The index value
#'
#' @return An unchained index value
#' @export
#'
#' @examples
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
