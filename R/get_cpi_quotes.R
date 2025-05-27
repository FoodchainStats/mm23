valid_url <- function(url_in,t=2){
  con <- url(url_in)
  check <- suppressWarnings(try(open.connection(con,open="rt",timeout=t),silent=T)[1])
  suppressWarnings(try(close.connection(con),silent=T))
  ifelse(is.null(check),TRUE,FALSE)
}



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
      } else

        if(year == 2025 & month == 4){
          url <- paste(base, "pricequotesapril2025/pricequotes202504.xlsx", sep = "")
        } else {

          url <- paste(base,
                       "pricequotes", tolower(month.name[month]), year,
                       "/upload-pricequotes", year, formatC(month, width = 2, format = "d", flag = "0"),
                       ".csv",
                       sep = ""
          )
        }


  if(year == 2025 & month == 4){
    data <- openxlsx::read.xlsx(url)
  } else {
    data <- readr::read_csv(url, show_col_types = FALSE)
  }


  data <- data |>
    janitor::clean_names() |>
    dplyr::mutate(quote_date = lubridate::ym(.data$quote_date))


  if("cs_id" %in% names(data)) {
    data <- data |>
      dplyr::select("cs_id",
                    "cs_desc",
                    "quote_date",
                    "item_id",
                    "item_desc",
                    "validity",
                    "shop_code",
                    "price",
                    "indicator_box",
                    "region",
                    "shop_type",
                    "shop_weight")
  } else {
    data <- data |>
      dplyr::mutate(cs_id = NA,
                    cs_desc = NA) |>
      dplyr::select("cs_id",
                    "cs_desc",
                    "quote_date",
                    "item_id",
                    "item_desc",
                    "validity",
                    "shop_code",
                    "price",
                    "indicator_box",
                    "region",
                    "shop_type",
                    "shop_weight")

  }

  return(data)

}





#' Get CPI price quotes for food items.
#'
#' See [Price quotes](https://foodchainstats.github.io/mm23/articles/price-quotes.html) article.
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
#'
#' # You can extract multiple months, but beware that the format changes over
#' time
#'
#' get_cpi_price_quotes(2024, 1:12)
#'
#' }
get_cpi_price_quotes <- function(year, month, path){

  if(min(year) <= 2019) {stop("Does not work with dates before 2020 - use the make_archive function to get all 2010-2019 data")}

  year1 <- rep(year, length(month)) |> sort()
  month1 <- rep(month, length(year))

  if(missing(path)){
    purrr::map2(year1, month1, \(year1, month1){
      Sys.sleep(2)
      x <- read_quotes(year1, month1)
    }) |> purrr::list_rbind()

  } else {
  purrr::map2(year1, month1, \(year1, month1){
    Sys.sleep(2)
    x <- read_quotes(year1, month1)
    filename <- paste0(path, "/", year1, "-", formatC(month1, flag = "0", width = 2), "-price-quotes.rds")
    message(paste("Saving", filename))
    saveRDS(x, filename)
  }) |> purrr::list_c()

  }
}

