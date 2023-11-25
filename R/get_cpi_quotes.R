read_quotes <- function(year, month) {

  if(year <= 2019) {stop("Does not work with dates before 2020 - use the make_archive function to get all 2010-2019 data")}

  message(paste("Reading ", year, month))

  base <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/"


  # Deal with inconsistencies
  if(year == 2020 & month %in% c(1,2,3,4,7)) {
    url <- paste(base,
                 "pricesquotes", tolower(month.name[month]), year,
                 "/upload-pricequotes", year, formatC(month, width = 2, format = "d", flag = "0"),
                 ".csv",
                 sep = ""
    )
  } else

    if(year == 2020 & month == 5) {
      url <- paste(base, "pricesquotesmay2020/upload-202005pricequotes.csv", sep = "")
    } else

      if(year == 2021 & month == 5) {
        url <- paste(base, "pricequotesmay2021/upload-pricequotes2021051.csv", sep = "")
      } else {

        url <- paste(base,
                     "pricequotes", tolower(month.name[month]), year,
                     "/upload-pricequotes", year, formatC(month, width = 2, format = "d", flag = "0"),
                     ".csv",
                     sep = ""
        )
      }

  colspec <- readr::cols(
    QUOTE_DATE = readr::col_double(),
    ITEM_ID = readr::col_double(),
    ITEM_DESC = readr::col_character(),
    VALIDITY = readr::col_double(),
    SHOP_CODE = readr::col_double(),
    PRICE = readr::col_double(),
    INDICATOR_BOX = readr::col_character(),
    ORIG_INDICATOR_BOX = readr::col_character(),
    PRICE_RELATIVE = readr::col_double(),
    LOG_PRICE_RELATIVE = readr::col_double(),
    STRATUM_WEIGHT = readr::col_double(),
    STRATUM_TYPE = readr::col_double(),
    START_DATE = readr::col_double(),
    END_DATE = readr::col_double(),
    REGION = readr::col_double(),
    SHOP_TYPE = readr::col_double(),
    SHOP_WEIGHT = readr::col_double(),
    BASE_PRICE = readr::col_double(),
    BASE_VALIDITY = readr::col_double(),
    STRATUM_CELL = readr::col_double()
  )

  data <- readr::read_csv(url, col_types = colspec)

  data <- data |>
    janitor::clean_names() |>
    dplyr::filter(.data$item_id <= 400000) |>
    dplyr::select("quote_date",
                  "item_id",
                  "item_desc",
                  "validity",
                  "shop_code",
                  "price",
                  "indicator_box",
                  "region",
                  "shop_type",
                  "shop_weight") |>
    dplyr::mutate(quote_date = lubridate::ym(.data$quote_date))

  return(data)

}




#' Get CPI price quotes for food items.
#'
#' @param year Year to extract
#' @param month Month to extract
#' @param path Optional path to save data
#'
#' @return a tibble of price quotes
#' @export
#'
#' @examples
#' \dontrun{
#' get_cpi_price_quotes(2021, 8)
#' }
get_cpi_price_quotes <- function(year, month, path){

  if(min(year) <= 2019) {stop("Does not work with dates before 2020 - use the make_archive function to get all 2010-2019 data")}

  year1 <- rep(year, length(month)) |> sort()
  month1 <- rep(month, length(year))

  if(missing(path)){
    purrr::map2(year1, month1, \(year1, month1){
      x <- read_quotes(year1, month1)
    }) |> purrr::list_rbind()

  } else {
  purrr::map2(year1, month1, \(year1, month1){
    x <- read_quotes(year1, month1)
    filename <- paste0(path, "/", year1, "-", formatC(month1, flag = "0", width = 2), "-price-quotes.rds")
    message(paste("Saving", filename))
    saveRDS(x, filename)
  }) |> purrr::list_c()

  }
}

