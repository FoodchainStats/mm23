get_metadata <- function(file) {

  metadata <- readr::read_csv(file, n_max = 6, show_col_types = FALSE) |>
    t() |>
    tibble::as_tibble(rownames = "series", .name_repair = "unique") |>
    (\(.) stats::setNames(., .[1,]))() |>
    # setNames( .[1,]) |>
    # rename(series = Title) |>
    dplyr::filter(.data$Title != "Title") |>
    janitor::clean_names() |>
    dplyr::relocate("cdid")

  return(metadata)

}
