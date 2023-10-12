#' Download a raw ppi.csv file
#' @description
#' [acquire_ppi()] is mainly a wrapper to download the file stored in
#' [ppi_url()]. You can optionally specify where to save the downloaded file.
#'
#' @param path Folder to put the downloaded data in. If missing a tempfile will
#'   be created.
#'
#' @return Path and filename of the downloaded file.
#' @export
#'
#' @examples
#' \dontrun{
#' file <- acquire_ppi()
#' data <- file |>
#'           get_ppi_metadata()
#'
#' my_ppi <- acquire_ppi("~/data")
#' }
acquire_ppi <- function(path){

  if(!missing(path)) {
    if(!dir.exists(path)) stop(paste(path, "does not exist"))
  }

  url <- ppi_url()

  if(missing(path)){
    tmp <- tempfile()
    utils::download.file(url, tmp)
    ppifile <- tmp
  } else {
    utils::download.file(url, destfile = paste0(path, "/", "ppi.csv"))
    ppifile <- paste0(path, "/", "ppi.csv")
  }

  return(ppifile)
}
