#' Creates ppi metadata
#'
#' @param rawfile A downloaded ppi.csv file. If missing will attempt to
#'   download from ONS.
#'
#' @return A tibble containing ppi metadata
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/
#' datasets/consumerpriceindices/current/ppi.csv"
#'     tmp <- tempfile()
#' download.file(url, tmp)
#' rawfile <- tmp
#' get_ppi_metadata(rawfile)
#' }
get_ppi_metadata <- function(rawfile){
  if(!missing(rawfile)){
    if(!file.exists(rawfile)) stop(paste(rawfile, "does not exist"))
  }

  if(missing(rawfile)){
    url <- ppi_url()
    tmp <- tempfile()
    utils::download.file(url, tmp)
    rawfile <- tmp
  }

  message("Processing metadata")

  metadata <- readr::read_csv(rawfile, n_max = 6, show_col_types = FALSE) |>
    t() |>
    tibble::as_tibble(rownames = "series", .name_repair = "unique") |>
    (\(.) stats::setNames(., .[1,]))() |>
    # setNames( .[1,]) |>
    # rename(series = Title) |>
    dplyr::filter(.data$Title != "Title") |>
    janitor::clean_names() |>
    dplyr::relocate("cdid")



  return(metadata)
}
