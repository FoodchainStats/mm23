#' Creates mm23 metadata
#'
#' @param rawfile A downloaded mm23.csv file. If missing will attempt to
#'   download from ONS.
#'
#' @return A tibble containing nn23 metadata
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
get_metadata <- function(rawfile){

    if(missing(rawfile)){
    url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindices/current/mm23.csv"
    tmp <- tempfile()
    utils::download.file(url, tmp)
    rawfile <- tmp
  }

  message("Processing metadata")

  metadata <- readr::read_csv(rawfile, n_max = 6, show_col_types = FALSE,) |>
    t() |>
    tibble::as_tibble(rownames = "series", .name_repair = "unique") |>
    (\(.) stats::setNames(., .[1,]))() |>
    # setNames( .[1,]) %>%
    # rename(series = Title) %>%
    dplyr::filter(Title != "Title") |>
    janitor::clean_names() |>
    dplyr::relocate(cdid)

  return(metadata)
}
