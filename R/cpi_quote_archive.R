#' Create an rds containing 2010-2019 CPI price quotes.
#'
#' @param path The folder to put the final archive into.
#' @param foodonly whether to exclude non-food products from the output. Can
#'   help if your computer has memory issues with compiling the full dataset.
#'
#' @return creates an rds file in the chosen folder
#' @export
#'
#' @examples
#' \dontrun{
#' make_cpi_quote_archive(dir = "~")
#' }
make_cpi_quote_archive <- function(path, foodonly = TRUE) {

  if(!missing(path)) {
    if(!dir.exists(path)) stop(paste(path, "does not exist"))
  }

  tmpdir <- tempdir()
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/itemindicesdecember2019/upload-itemindices201912v1.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesnovember2019/upload-pricequotes201911.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesseptember2019/upload-pricequotes201909.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesoctober2019/upload-pricequotes201910.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/upload-pricequotes201908.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesdecember2018/upload-pricequotes201812.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotenovember2018/pricequote201811.zip

  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2010/pricequote2010.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2011/pricequote2011.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2012/pricequote2012.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricesquote2013/pricequote2013.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2014/pricequote2014.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2017/pricequote201703to201711.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesdecember2017/pricequote201712.zip

  # function to download zipped prices files
  get_cpi_zips <- function(url_stub, exdir = tmpdir) {
    message(paste("Acquiring", url_stub))
    base <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/"
    url <- paste(base, url_stub, sep = "")
    tmp <- tempfile()
    # utils::download.file(url, destfile = tmp, quiet = TRUE)
    acquire_safe(url, tmp, type = "binary")
    utils::unzip(tmp, exdir = exdir)
    unlink(tmp)
  }


  # Get 2010-2014 (note the typo in the url for 2013)
  stubs <- list(
    "pricequotes2010/pricequote2010.zip",
    "pricequotes2011/pricequote2011.zip",
    "pricequotes2012/pricequote2012.zip",
    "pricesquote2013/pricequote2013.zip",
    "pricequotes2014/pricequote2014.zip"
  )

  purrr::map(stubs, get_cpi_zips)

  # get 2015 - 2016
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesquarter12015/upload-pricequote2015q1.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesquarter22015/upload-pricequote2015q2.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesquarter32015/upload-pricequote2015q3.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotequarter42015/upload-pricequote2015q4.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotequarter12016/upload-pricequote2016q1.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotequarter22016/upload-pricequote2016q2.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotequarter32016/upload-pricequote2016q3.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesquarter42016/upload-pricequote2016q4.csv

  stubs <- list(
    "pricequotesquarter12015/upload-pricequote2015q1.csv",
    "pricequotesquarter22015/upload-pricequote2015q2.csv",
    "pricequotesquarter32015/upload-pricequote2015q3.csv",
    "pricequotequarter42015/upload-pricequote2015q4.csv",
    "pricequotequarter12016/upload-pricequote2016q1.csv",
    "pricequotequarter22016/upload-pricequote2016q2.csv",
    "pricequotequarter32016/upload-pricequote2016q3.csv",
    "pricequotesquarter42016/upload-pricequote2016q4.csv"
  )

  purrr::map(stubs, \(x){
    message(paste("Acquiring", x))
    base <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/"
    url <- paste(base, x, sep = "")
    acquire_safe(url,
                 filename = paste(tmpdir, "/", stringr::str_extract(x, "([^/]+$)"), sep = ""),
                 type = "string")
    # utils::download.file(url,
    #               destfile = paste(tmpdir, "/", stringr::str_extract(x, "([^/]+$)"), sep = ""),
    #               quiet = TRUE)

  })

  # Get 2017 - Nov 2018
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2017/pricequote201703to201711.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesdecember2017/pricequote201712.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotejanuary2018/pricequote201801.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotefebruary2018/pricequote201802.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotemarch2018/pricequote201803.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequoteapril2018/pricequote201804.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotemay2018/pricequote201805.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotejune2018/pricequote201806.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotejuly2018/pricequote201807.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequoteaugust2018/pricequote201808.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequoteseptember2018/pricequote201809.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequoteoctober2018/pricequote201810.zip
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotenovember2018/pricequote201811.zip

  stubs <- list(
    "pricequotes2017/pricequote201703to201711.zip",
    "pricequotesdecember2017/pricequote201712.zip",
    "pricequotejanuary2018/pricequote201801.zip",
    "pricequotefebruary2018/pricequote201802.zip",
    "pricequotemarch2018/pricequote201803.zip",
    "pricequoteapril2018/pricequote201804.zip",
    "pricequotemay2018/pricequote201805.zip",
    "pricequotejune2018/pricequote201806.zip",
    "pricequotejuly2018/pricequote201807.zip",
    "pricequoteaugust2018/pricequote201808.zip",
    "pricequoteseptember2018/pricequote201809.zip",
    "pricequoteoctober2018/pricequote201810.zip",
    "pricequotenovember2018/pricequote201811.zip"
  )

  purrr::map(stubs, get_cpi_zips)

  # Now need to double unzip since some of the 2017 ones are
  purrr::map(list.files(tmpdir, pattern = "*.zip", full.names = TRUE),
             \(x) {
               utils::unzip(x, exdir = tmpdir)
               unlink(x)
             }
  )

  # Get Dec 2017 - 2019
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesdecember2018/upload-pricequotes201812.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/previous/v1/upload-pricequotes201901.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/previous/v2/upload-pricequotes201902.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/previous/v3/upload-pricequotes201903.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/previous/v4/upload-pricequote201904.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/previous/v5/upload-pricequote201905.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/previous/v6/upload-pricequotes201906.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/previous/v7/upload-pricequotes201907.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotes2019/upload-pricequotes201908.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesseptember2019/upload-pricequotes201909.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesoctober2019/upload-pricequotes201910.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesnovember2019/upload-pricequotes201911.csv
  # https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/pricequotesdecember2019/upload-pricequotes201912v1.csv

  stubs <- list(
    "pricequotesdecember2018/upload-pricequotes201812.csv",
    "pricequotes2019/previous/v1/upload-pricequotes201901.csv",
    "pricequotes2019/previous/v2/upload-pricequotes201902.csv",
    "pricequotes2019/previous/v3/upload-pricequotes201903.csv",
    "pricequotes2019/previous/v4/upload-pricequote201904.csv",
    "pricequotes2019/previous/v5/upload-pricequote201905.csv",
    "pricequotes2019/previous/v6/upload-pricequotes201906.csv",
    "pricequotes2019/previous/v7/upload-pricequotes201907.csv",
    "pricequotes2019/upload-pricequotes201908.csv",
    "pricequotesseptember2019/upload-pricequotes201909.csv",
    "pricequotesoctober2019/upload-pricequotes201910.csv",
    "pricequotesnovember2019/upload-pricequotes201911.csv",
    "pricequotesdecember2019/upload-pricequotes201912v1.csv"
  )

  purrr::map(stubs, \(x){
    message(paste("Acquiring", x))
    base <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/"
    url <- paste(base, x, sep = "")
    acquire_safe(url,
                 filename = paste(tmpdir, "/", stringr::str_extract(x, "([^/]+$)"), sep = ""),
                 type = "string")
    # utils::download.file(url,
    #               destfile = paste(tmpdir, "/", stringr::str_extract(x, "([^/]+$)"), sep = ""),
    #               quiet = TRUE)

  })



  # Build dataset
  archive <- purrr::map(list.files(tmpdir, pattern = "*.csv", full.names = TRUE), \(x) {
    message(paste("Reading", x))
    data <- readr::read_csv(x, show_col_types = FALSE)

    if(foodonly == TRUE) {
    data <- data |>
      janitor::clean_names() |>
      dplyr::filter(item_id <= 320000 & item_id >= 210000) |>
      dplyr::mutate(quote_date = lubridate::ym(.data$quote_date)) |>
      dplyr::mutate(cs_id = NA,
                    cs_desc = NA)
    } else {
      data <- data |>
        janitor::clean_names() |>
        dplyr::mutate(quote_date = lubridate::ym(.data$quote_date)) |>
        dplyr::mutate(cs_id = NA,
                      cs_desc = NA)
    }

    return(data)

  }) |>
    dplyr::bind_rows()  |>
    dplyr::select(.data$cs_id,
                  .data$cs_desc,
                  .data$quote_date,
                  .data$item_id,
                  .data$item_desc,
                  .data$validity,
                  .data$shop_code,
                  .data$price,
                  .data$indicator_box,
                  .data$region,
                  .data$shop_type,
                  .data$shop_weight)


  if(missing(path)){
    # outdir <- tempdir()
    # message(paste("Saving archive cpi_price_quote_archive_2010_2019.rds in", outdir))
    # saveRDS(archive, paste(outdir, "/", "cpi_price_quote_archive_2010_2019.rds", sep = ""))
    return(archive)
  } else {
    message(paste("Saving archive cpi_price_quote_archive_2010_2019.rds in", path))
    saveRDS(archive, paste(path, "/", "cpi_price_quote_archive_2010_2019.rds", sep = ""))
    return(archive)
  }


  unlink(list.files(tmpdir, pattern = "*.csv", full.names = TRUE))

}




archive_stubs <- function() {
  stub <- c(
    "pricequotes2010/pricequote2010.zip",
    "pricequotes2011/pricequote2011.zip",
    "pricequotes2012/pricequote2012.zip",
    "pricesquote2013/pricequote2013.zip",
    "pricequotes2014/pricequote2014.zip",
    "pricequotesquarter12015/upload-pricequote2015q1.csv",
    "pricequotesquarter22015/upload-pricequote2015q2.csv",
    "pricequotesquarter32015/upload-pricequote2015q3.csv",
    "pricequotequarter42015/upload-pricequote2015q4.csv",
    "pricequotequarter12016/upload-pricequote2016q1.csv",
    "pricequotequarter22016/upload-pricequote2016q2.csv",
    "pricequotequarter32016/upload-pricequote2016q3.csv",
    "pricequotesquarter42016/upload-pricequote2016q4.csv",
    "pricequotes2017/pricequote201703to201711.zip",
    "pricequotesdecember2017/pricequote201712.zip",
    "pricequotejanuary2018/pricequote201801.zip",
    "pricequotefebruary2018/pricequote201802.zip",
    "pricequotemarch2018/pricequote201803.zip",
    "pricequoteapril2018/pricequote201804.zip",
    "pricequotemay2018/pricequote201805.zip",
    "pricequotejune2018/pricequote201806.zip",
    "pricequotejuly2018/pricequote201807.zip",
    "pricequoteaugust2018/pricequote201808.zip",
    "pricequoteseptember2018/pricequote201809.zip",
    "pricequoteoctober2018/pricequote201810.zip",
    "pricequotenovember2018/pricequote201811.zip",
    "pricequotesdecember2018/upload-pricequotes201812.csv",
    "pricequotes2019/previous/v1/upload-pricequotes201901.csv",
    "pricequotes2019/previous/v2/upload-pricequotes201902.csv",
    "pricequotes2019/previous/v3/upload-pricequotes201903.csv",
    "pricequotes2019/previous/v4/upload-pricequote201904.csv",
    "pricequotes2019/previous/v5/upload-pricequote201905.csv",
    "pricequotes2019/previous/v6/upload-pricequotes201906.csv",
    "pricequotes2019/previous/v7/upload-pricequotes201907.csv",
    "pricequotes2019/upload-pricequotes201908.csv",
    "pricequotesseptember2019/upload-pricequotes201909.csv",
    "pricequotesoctober2019/upload-pricequotes201910.csv",
    "pricequotesnovember2019/upload-pricequotes201911.csv",
    "pricequotesdecember2019/upload-pricequotes201912v1.csv"
  )

  yr <- c(2010,
          2011,
          2012,
          2013,
          2014,
          2015, 2015, 2015, 2015,
          2016, 2016, 2016, 2016,
          2017, 2017,
          2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018,
          2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019)

  x <- data.frame(yr, stub)
  return(x)

}


archive <- function(year, path, foodonly = TRUE) {

  if(!missing(path)) {
    if(!dir.exists(path)) stop(paste(path, "does not exist"))
  }

  tmpdir <- tempdir()
  base <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindicescpiandretailpricesindexrpiitemindicesandpricequotes/"

  stubs <- archive_stubs() |> dplyr::filter(yr %in% year) |> dplyr::select(stub) |> as.list()
  urls <- purrr::map2(base, stubs, paste0) |> unlist()
  files <- basename(urls)

  purrr::walk2(urls, files, \(urls,files){
    acquire_safe(urls,paste0(tmpdir, "/",files))
  })

  list.files(tmpdir,pattern = "*.zip", full.names = TRUE) |>
    purrr::walk(\(x) {
      utils::unzip(x, exdir = tmpdir)
      unlink(x)
      })

  # double unzip in 2017
  list.files(tmpdir,pattern = ".*2017.*\\.zip", full.names = TRUE) |>
    purrr::walk(\(x) {
      utils::unzip(x, exdir = tmpdir)
      unlink(x)
      })

  # Build dataset
  output <- purrr::map(list.files(tmpdir, pattern = "*.csv", full.names = TRUE), \(x) {
    message(paste("Reading", basename(x)))
    data <- readr::read_csv(x, show_col_types = FALSE)

    if(foodonly == TRUE) {
      data <- data |>
        janitor::clean_names() |>
        dplyr::filter(item_id <= 320000 & item_id >= 210000) |>
        dplyr::mutate(quote_date = lubridate::ym(.data$quote_date)) |>
        dplyr::mutate(cs_id = NA,
                      cs_desc = NA)
    } else {
      data <- data |>
        janitor::clean_names() |>
        dplyr::mutate(quote_date = lubridate::ym(.data$quote_date)) |>
        dplyr::mutate(cs_id = NA,
                      cs_desc = NA)
    }

    if(! rlang::has_name(data, "item_desc")) {
      data <- data |> dplyr::mutate(item_desc = NA)
    }
    # message(paste("item_desc exists:", rlang::has_name(data, "item_desc")))

    return(data)

  }) |>
    dplyr::bind_rows() |>
    dplyr::select(.data$cs_id,
                  .data$cs_desc,
                  .data$quote_date,
                  .data$item_id,
                  .data$item_desc,
                  .data$validity,
                  .data$shop_code,
                  .data$price,
                  .data$indicator_box,
                  .data$region,
                  .data$shop_type,
                  .data$shop_weight)


  purrr::map(list.files(tmpdir, pattern = "*.csv", full.names = TRUE), unlink)
  return(output)

}

