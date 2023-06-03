#' Download a raw mm23.csv file
#' @description
#' [acquire_mm23()] is mainly a wrapper to download the file stored in
#' [mm23_url()]. You can optionally specify where to save the downloaded file.
#'
#' @param path Folder to put the downloaded data in. If missing a tempfile will
#'   be created.
#'
#' @return Path and filename of the downloaded file.
#' @export
#'
#' @examples
#' \dontrun{
#' file <- acquire_mm23()
#' data <- file |> get_mm23_metadata()
#'
#' my_mm23 <- acquire_mm23("~/data")
#' }
acquire_mm23 <- function(path){

  if(!missing(path)) {
    if(!dir.exists(path)) stop(paste(path, "does not exist"))
  }

    url <- mm23_url()

  if(missing(path)){
    tmp <- tempfile()
    utils::download.file(url, tmp)
    mm23file <- tmp
  } else {
    utils::download.file(url, destfile = paste0(path, "/", "mm23.csv"))
    mm23file <- paste0(path, "/", "mm23.csv")
  }

    return(mm23file)
}
