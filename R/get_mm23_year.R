#' Get yearly mm23 data
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
get_mm23_year <- function(rawfile){

  if(!missing(rawfile)){
    if(!file.exists(rawfile)) stop(paste(rawfile, "does not exist"))
  }

  if(missing(rawfile)){
    url <- mm23_url()
    tmp <- tempfile()
    utils::download.file(url, tmp)
    rawfile <- tmp
  }

  message("Processing year")
  # See
  # https://dplyr.tidyverse.org/articles/in-packages.html#data-masking-and-tidy-selection-notes
  # for use of .data when using dplyr in packages
  mm23_year <- readr::read_csv(rawfile, skip = 1, show_col_types = FALSE) |>
    dplyr::filter(nchar(.data$CDID) == 4 & .data$CDID != "Unit") |>
    dplyr::mutate(CDID = lubridate::ymd(paste(.data$CDID, "-01-01"))) |>
    dplyr::rename(date = .data$CDID) |>
    tidyr::pivot_longer(cols = 2:tidyr::last_col(), names_to = "cdid") |>
    dplyr::mutate(value = as.numeric(.data$value),
                  period = "Y") |>
    dplyr::filter(!is.na(.data$value))

  # clean up if file was downloaded
  if(missing(rawfile)){
  unlink(rawfile)
  }

  return(mm23_year)
}
