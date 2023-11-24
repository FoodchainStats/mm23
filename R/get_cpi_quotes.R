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

  data <- readr::read_csv(url)

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




#' Creates a dataframe of CPI price quotes for food items.
#'
#' @param year Year to extract
#' @param month Month to extract
#' @param path path to save data
#'
#' @return a data frame of price quotes
#' @export
#'
#' @examples
#' \dontrun{
#' get_cpi_price_quotes(2021, 8)
#' }
get_cpi_price_quotes <- function(year, month, path = getwd()){
  purrr::map2(year, month, \(year, month){
    x <- read_quotes(year, month)
    saveRDS(x, paste0(path, "/", year, "_", month, ".rds"))
  })
}

