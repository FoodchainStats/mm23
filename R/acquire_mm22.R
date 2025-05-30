#' Download a raw mm22.csv file
#' @description
#' [acquire_mm22()] is mainly a wrapper to download the file stored in
#' [mm22_url()]. You can optionally specify where to save the downloaded file.
#'
#' @param path Folder to put the downloaded data in. If missing a tempfile will
#'   be created.
#'
#' @return Path and filename of the downloaded file.
#' @export
#'
#' @examples
#' \dontrun{
#' file <- acquire_mm22()
#' data <- file |>
#'           get_mm22_metadata()
#'
#' my_mm22 <- acquire_mm22("~/data")
#' }
acquire_mm22 <- function(path){

  if(!missing(path)) {
    if(!dir.exists(path)) stop(paste(path, "does not exist"))
  }

  url <- mm22_url()

  if(missing(path)){
    fname <- tempfile()
  } else {
    fname <- paste0(path, "/", "mm22.csv")
  }

    acquire_safe(url, fname)
    mm22file <- fname
    return(mm22file)
}
