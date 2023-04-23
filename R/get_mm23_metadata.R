#' Creates mm23 metadata
#'
#' @param rawfile A downloaded mm23.csv file. If missing will attempt to
#'   download from ONS.
#'
#' @return A tibble containing mm23 metadata
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/
#' datasets/consumerpriceindices/current/mm23.csv"
#'     tmp <- tempfile()
#' download.file(url, tmp)
#' rawfile <- tmp
#' get_mm23_metadata(rawfile)
#' }
get_mm23_metadata <- function(rawfile){

    if(missing(rawfile)){
    url <- mm23_url()
    tmp <- tempfile()
    utils::download.file(url, tmp)
    rawfile <- tmp
  }

  message("Processing metadata")

  metadata <- readr::read_csv(rawfile, n_max = 6, show_col_types = FALSE,) |>
    t() |>
    tibble::as_tibble(rownames = "series", .name_repair = "unique") |>
    (\(.) stats::setNames(., .[1,]))() |>
    # setNames( .[1,]) |>
    # rename(series = Title) |>
    dplyr::filter(.data$Title != "Title") |>
    janitor::clean_names() |>
    dplyr::relocate(.data$cdid)

  # CPIH annual rates ------------------------------------------------------------
  # Extract series and add a level flag to show hierarchy

  message("Processing CPIH annual rates")

  cpih_ann1 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH ANNUAL RATE [0-9][0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH ANNUAL RATE ")) |>
    dplyr::mutate(level = 1)

  cpih_ann2 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH ANNUAL RATE [0-9][0-9]\\.[0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH ANNUAL RATE ")) |>
    dplyr::mutate(level = 2)

  cpih_ann3 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH ANN[A-Z]* RATE [0-9][0-9]\\.[0-9].[0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH ANN[A-Z]* RATE ")) |>
    dplyr::mutate(level = 3)


  cpih_ann4 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH ANNUAL RATE [0-9][0-9]\\.[0-9].[0-9].[0-9]")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH ANNUAL RATE ")) |>
    dplyr::mutate(level = 4)


  cpih_ann_rate_cdids <- dplyr::bind_rows(list(cpih_ann1, cpih_ann2, cpih_ann3, cpih_ann4)) |>
    dplyr::mutate(title = stringr::str_to_title(stringr::str_remove(.data$title, " 2015=100"))) |>
    dplyr::mutate(category = "CPIH Annual rate (%)") |>
    dplyr::select("cdid", "title", "category", "level") |>
    dplyr::arrange(.data$title)



  # CPIH monthly rates -----------------------------------------------------------

  message("Processing CPIH monthly rates")

  cpih_mth1 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH MONTHLY RATE [0-9][0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH MONTHLY RATE ")) |>
    dplyr::mutate(level = 1)

  cpih_mth2 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH MONTHLY RATE [0-9][0-9]\\.[0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH MONTHLY RATE ")) |>
    dplyr::mutate(level = 2)

  cpih_mth3 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH MONTHLY RATE [0-9][0-9]\\.[0-9].[0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH MONTHLY RATE ")) |>
    dplyr::mutate(level = 3)


  cpih_mth4 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH MONTHLY RATE [0-9][0-9]\\.[0-9].[0-9].[0-9]")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH MONTHLY RATE ")) |>
    dplyr::mutate(level = 4)


  cpih_mth_rate_cdids <- dplyr::bind_rows(list(cpih_mth1, cpih_mth2, cpih_mth3, cpih_mth4)) |>
    dplyr::mutate(title = stringr::str_to_title(stringr::str_remove(.data$title, " 2015=100"))) |>
    dplyr::mutate(category = "CPIH Monthly rate (%)") |>
    dplyr::select("cdid", "title", "category", "level") |>
    dplyr::arrange(.data$title)






  # RPI average prices -----------------------------------------------------------
  message("Processing RPI average prices")

  rpi_avg_price_cdids <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "RPI? ?:? ?Ave")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI: Ave price - ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI: Ave Price - ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI: Ave Price: ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI :Ave price - ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI: Average [Pp]rice - ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI Average [Pp]rice- ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI Average [Pp]rice - ")) |>
    dplyr::mutate(title = stringr::str_to_title(.data$title)) |>
    dplyr::mutate(category = "RPI Average price (pence)") |>
    dplyr::select("cdid", "title", "category") |>
    dplyr::arrange(.data$title)




  # Contributions to CPIH annual rate -------------------------------------------
  message("Processing CPIH contributions to annual rate")

  cpih_cont_ann_cdids <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH: Contribution to all items annual rate: ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH: Contribution to all items annual rate: ")) |>
    dplyr::mutate(category = "CPIH contribution to all items annual rate") |>
    dplyr::select("cdid", "title", "category") |>
    dplyr::arrange(.data$title)



  # Contributions to monthly change in rate -------------------------------
  message("Processing CPIH contributions to monthly change in rate")

  cpih_cont_mth_chg_cdids <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH: Contribution to monthly change in all items index: ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH: Contribution to monthly change in all items index: ")) |>
    dplyr::mutate(category = "CPIH contribution to monthly change in all items index") |>
    dplyr::select("cdid", "title", "category") |>
    dplyr::arrange(.data$title)



  # Contributions to monthly change in annual rate -------------------------------
  message("Processing monthly change in annual rate")

  cpih_cont_ann_chg_cdids <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH: % points change over previous month \\(12 month rate\\): ")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH: % points change over previous month \\(12 month rate\\): ")) |>
    dplyr::mutate(category = "CPIH % points change over previous months 12 month rate") |>
    dplyr::select("cdid", "title", "category") |>
    dplyr::arrange(.data$title)

  # RPI 12 month change---------------------------------------------------------
  message("Processing RPI 12 month change")

  rpi_12_mth_cdids <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "RPI:Percentage change over 12 months[ :][ -] *")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "RPI:Percentage change over 12 months[ :][ -] *")) |>
    dplyr::mutate(category = "RPI Percentage change over 12 months")|>
    dplyr::select("cdid", "title", "category") |>
    dplyr::arrange(.data$title)

  # CPIH Weights----------------------------------------------------------------

  message("Processing CPIH Weights")

  cpih_wt1 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH WEIGHTS [0-9][0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH WEIGHTS ")) |>
    dplyr::mutate(level = 1)

  cpih_wt2 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH WEIGHTS [0-9][0-9]\\.[0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH WEIGHTS ")) |>
    dplyr::mutate(level = 2)

  cpih_wt3 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH WEIGHTS [0-9][0-9]\\.[0-9].[0-9] ?:")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH WEIGHTS ")) |>
    dplyr::mutate(level = 3)

  cpih_wt4 <- metadata |>
    dplyr::filter(stringr::str_detect(.data$title, "CPIH WEIGHTS [0-9][0-9]\\.[0-9].[0-9].[0-9]")) |>
    dplyr::mutate(title = stringr::str_remove(.data$title, "CPIH WEIGHTS ")) |>
    dplyr::mutate(level = 4)

  cpih_wt_cdids <- dplyr::bind_rows(list(cpih_wt1, cpih_wt2, cpih_wt3, cpih_wt4)) |>
    dplyr::mutate(title = stringr::str_to_title(.data$title)) |>
    dplyr::mutate(category = "CPIH Weights") |>
    dplyr::select("cdid", "title", "category", "level") |>
    dplyr::arrange(.data$title)


  # rebuild metadata

  series <- dplyr::bind_rows(list(cpih_ann_rate_cdids,
                           cpih_mth_rate_cdids,
                           cpih_cont_ann_cdids,
                           cpih_cont_ann_chg_cdids,
                           cpih_cont_mth_chg_cdids,
                           rpi_avg_price_cdids,
                           rpi_12_mth_cdids,
                           cpih_wt_cdids))

  metadata <- metadata |>
    dplyr::left_join(series, by = "cdid") |>
    dplyr::mutate(t2 = ifelse(is.na(.data$title.y), .data$title.x, .data$title.y)) |>
    dplyr::rename(title_original = .data$title.x,
           title = .data$t2) |>
    dplyr::select("cdid",
                  "title",
                  "category",
                  "level",
                  "pre_unit",
                  "unit",
                  "release_date",
                  "next_release",
                  "important_notes")

  # clean up if file was downloaded
  if(missing(rawfile)){
    unlink(rawfile)
  }

  return(metadata)
}
