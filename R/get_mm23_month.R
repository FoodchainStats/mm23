#' Get monthly mm23 data
#'
#' @param rawfile A downloaded mm23.csv file. If missing will attempt to
#'   download from ONS.
#'
#' @return A tibble containing date, CDID and value.
#' @importFrom rlang .data
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

  if(!missing(rawfile)){
    if(!file.exists(rawfile)) stop(paste(rawfile, "does not exist"))
  }

  if(missing(rawfile)){
    url <- mm23_url()
    tmp <- tempfile()
    acquire_safe(url, tmp)
    rawfile <- tmp
  }

  message("Processing month")

  mm23_month <- readr::read_csv(rawfile, skip = 1, show_col_types = FALSE) |>
    dplyr::filter(nchar(.data$CDID) == 8) |>
    dplyr::mutate(CDID = lubridate::ym(.data$CDID)) |>
    dplyr::rename(date = "CDID") |>
    tidyr::pivot_longer(cols = 2:tidyr::last_col(), names_to = "cdid") |>
    # tidyr::pivot_longer(cols = 2:ncol(.), names_to = "cdid") |>
    dplyr::mutate(value = as.numeric(.data$value),
                  period = "M") |>
    dplyr::filter(!is.na(.data$value))

  # clean up if file was downloaded
  if(missing(rawfile)){
    unlink(rawfile)
  }

  return(mm23_month)
}


#' Get monthly PPI data
#'
#' @param rawfile a downloaded ppi.csv file. If missing will attempt to
#'  download from ONS.
#'
#' @return A tibble containint date, CDID and value.
#' @export
#'
#' @examples
#' \dontrun{
#' get_ppi_month()
#' }
get_ppi_month <- function(rawfile) {

  if(!missing(rawfile)){
    if(!file.exists(rawfile)) stop(paste(rawfile, "does not exist"))
  }

  if(missing(rawfile)){
    url <- ppi_url()
    tmp <- tempfile()
    acquire_safe(url, tmp)
    rawfile <- tmp
  }

  out <- get_mm23_month(rawfile)

  return(out)

}
