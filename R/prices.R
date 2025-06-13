
#' Get average price data from the ONS Shopping Price tool
#'
#' @param file A spreadsheet download of price data
#'
#' @return A tidy dataset of average prices
#' @export
#'
#' @examples
#' \dontrun{
#' data <- get_price_data()
#' }
get_price_data <- function(file) {

  if(!missing(file)){
    if(!file.exists(file)) stop(paste(file, "does not exist"))
  }


  if(missing(file)){
    url <- prices_url()
    tmp <- tempfile()
    utils::download.file(url, tmp)
    file <- tmp
  }

  if(is.na(readxl::excel_format(file))) {
    stop(paste("File", file, "is not an xlsx spreadsheet"))
  }

  c <- list("chained", "averageprice", "monthlygrowth", "annualgrowth")

  avgprice <- purrr::map(c, \(x) {
    readxl::read_excel(file, sheet = x) |>
      tidyr::pivot_longer(!"ITEM_ID") |>
      dplyr::mutate(ITEM_ID = as.character(.data$ITEM_ID),
                    date = as.Date(as.numeric(.data$name), origin = "1899-12-30"),
                    category = x) |>
      dplyr::select(date, "category", item_id = "ITEM_ID", "value")
  }) |> dplyr::bind_rows()


# tidyxl version kept crashing with the download
  # avgprice <- tidyxl::xlsx_cells(file, sheets = "averageprice") |>
  #   unpivotr::behead("up", "date") |>
  #   unpivotr::behead("left", "item_id") |>
  #   dplyr::mutate(date = lubridate::as_date(.data$date.header),
  #                 item_id = as.character(.data$item_id)) |>
  #   dplyr::select(date, .data$item_id, value = numeric)

  return(avgprice)

}


#' Get average price metadata from the ONS Shopping Price tool
#'
#' @param file A spreadsheet download of price data
#'
#' @return A dataset of price metadata
#' @export
#'
#' @examples
#' \dontrun{
#' metadata <- get_price_metadata()
#' }
get_price_metadata <- function(file) {

  if(!missing(file)){
    if(!file.exists(file)) stop(paste(file, "does not exist"))
  }

  if(missing(file)){
    url <- prices_url()
    tmp <- tempfile()
    utils::download.file(url, tmp)
    file <- tmp
  }

  if(is.na(readxl::excel_format(file))) {
    stop(paste("File", file, "is not an xlsx spreadsheet"))
  }

  price_metadata <- readxl::read_excel(file, sheet = "metadata") |>
    dplyr::rename_with(tolower) |>
    dplyr::rename(weight_size = "weight\\size") |>
    dplyr::mutate(item_id = as.character(.data$item_id))


# tidyxl kept crashing with the download
  # price_metadata <- tidyxl::xlsx_cells(file, sheets = "metadata") |>
  #   unpivotr::behead("left", "item_id") |>
  #   unpivotr::behead("left", "item_start") |>
  #   unpivotr::behead("left", "co  icop2") |>
  #   unpivotr::behead("left", "coicop3") |>
  #   unpivotr::behead("left", "coicop4") |>
  #   unpivotr::behead("left", "coicop5") |>
  #   unpivotr::behead("left", "category1") |>
  #   unpivotr::behead("left", "category2") |>
  #   unpivotr::behead("left", "item_desc") |>
  #   dplyr::filter(row > 1) |>
  #   dplyr::select(.data$item_id:.data$item_desc, weight_size = character) |>
  #   dplyr::mutate(item_start = lubridate::as_date(.data$item_start))

  return(price_metadata)
}
