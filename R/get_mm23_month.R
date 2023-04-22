#' Get monthly mm23 data
#'
#' @param rawfile A downloaded mm23.csv file. If missing will attempt to
#'   download from ONS.
#'
#' @return A tibble containing date, CDID and value.
#' @export
#'
#' @examples
#' \dontrun{
#' url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/
#' datasets/consumerpriceindices/current/mm23.csv"
#'     tmp <- tempfile()
#' download.file(url, tmp)
#' rawfile <- tmp
#' get_mm23_month(rawfile)
#' }
get_mm23_month <- function(rawfile){

  if(missing(rawfile)){
    url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindices/current/mm23.csv"
    tmp <- tempfile()
    utils::download.file(url, tmp)
    rawfile <- tmp
  }

  message("Processing month")

  mm23_month <- readr::read_csv(rawfile, skip = 1, show_col_types = FALSE) |>
    dplyr::filter(nchar(CDID) == 8) |>
    dplyr::mutate(CDID = lubridate::ym(CDID)) |>
    dplyr::rename(date = CDID) |>
    tidyr::pivot_longer(cols = 2:tidyr::last_col(), names_to = "cdid") |>
    # tidyr::pivot_longer(cols = 2:ncol(.), names_to = "cdid") |>
    dplyr::mutate(value = as.numeric(value),
                  period = "M") |>
    dplyr::filter(!is.na(value))

  return(mm23_month)
}
