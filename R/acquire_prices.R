
#' Download ONS shopping price dataset
#'
#' @description
#' [acquire_prices()] is mainly a wrapper to download the file stored in
#' [prices_url()]. You can optionally specify where to save the downloaded file.
#'
#'
#' @param path Folder to put the downloaded data in. If missing a tempfile will
#'   be created.
#'
#' @return The file path and name of the downloaded file.
#' @export
#'
#' @examples
#' \dontrun{
#' file <- acquire_prices()
#'
#' my_prices <- acquire_prices("~/data")
#' }
acquire_prices <- function(path) {

  if(!missing(path)) {
    if(!dir.exists(path)) stop(paste(path, "does not exist"))
  }

  url <- prices_url()

  if(missing(path)){
    fname <- tempfile()
  } else {
    fname <- paste0(path, "/", "datadownload.xlsx")
  }

    acquire_safe(url, fname, type = "binary")
    pricesfile <- fname
  return(pricesfile)

}
