#' Get quarterly mm23 data
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
get_mm23_quarter <- function(rawfile){

  if(!missing(rawfile)){
    if(!file.exists(rawfile)) stop(paste(rawfile, "does not exist"))
  }

  if(missing(rawfile)){
    url <- mm23_url()
    tmp <- tempfile()
    acquire_safe(url, tmp)
    rawfile <- tmp
  }

  mm23_quarter <- readr::read_csv(rawfile, skip = 1, show_col_types = FALSE) |>
    dplyr::filter(nchar(.data$CDID) == 7 & .data$CDID != "PreUnit") |>
    dplyr::mutate(CDID = lubridate::yq(.data$CDID)) |>
    dplyr::rename(date = "CDID") |>
    tidyr::pivot_longer(cols = 2:tidyr::last_col(), names_to = "cdid") |>
    dplyr::mutate(value = as.numeric(.data$value),
                  period = "Q") |>
    dplyr::filter(!is.na(.data$value))

  # clean up if file was downloaded
  if(missing(rawfile)){
    unlink(rawfile)
  }

  return(mm23_quarter)

}





#' Get quarterly ppi data
#'
#' @param rawfile A downloaded ppi.csv file. If missing will attempt to
#'   download from ONS.
#'
#' @return A tibble containing date, CDID and value.
#' @export
#'
#' @examples
#' \dontrun{
#' get_ppi_quarter()
#' }
get_ppi_quarter <- function(rawfile) {

  if(!missing(rawfile)){
    if(!file.exists(rawfile)) stop(paste(rawfile, "does not exist"))
  }

  if(missing(rawfile)){
    url <- ppi_url()
    tmp <- tempfile()
    acquire_safe(url, tmp)
    rawfile <- tmp
  }

  out <- get_mm23_quarter(rawfile)

  return(out)

}

