#' Download a raw mm23.csv file
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
