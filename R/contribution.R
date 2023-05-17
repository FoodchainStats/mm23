#' Calculate contribution of a series to 'all items' 12 month rate
#'
#' @param year
#' @param month
#' @param all_items_index
#' @param all_items_weight
#' @param component_index
#' @param component_weight
#'
#' @return
#' @export
#'
#' @examples
contribution <- function(year,
                 month,
                 all_items_index,
                 all_items_weight,
                 component_index,
                 component_weight) {

  # c = component c
  # a = 'all items' CPI
  # Wc(y) = weight of component c in year y
  # Ic(t) = index for component c in month t based on January of current year = 100
  # Ia(Jan) = all items index for January based on previous month (December) = 100
  # Ia(Dec) = all items index for December based on previous January = 100

  # Section 1
  # Wc(y-1)/ Wa(y-1)
  a <- (dplyr::lag(component_weight, 12) / dplyr::lag(all_items_weight, 12))

  # ((Ic(Dec) - Ic(t-12))/Ia(t-12)) * 100
  b <- (I_x_Dec(month, component_index) - dplyr::lag(component_index, 12)) / dplyr::lag(all_items_index, 12)

  section1 <- a * b * 100

  # return(section1)
  # Section 2

  # Wc(y) / Wa(y)
  c <- (component_weight/all_items_weight)

  # ((Ic(Jan) - 100) / Ia(t-12)) * Ia(Dec)
  d <- (I_x_Jan(month, component_index) - 100) / dplyr::lag(all_items_index, 12)

  section2 <- c * d * I_x_Dec(month, all_items_index)

  # return(section2)

  # Section 3

  # Wc(y)/ Wa(y)
  e <- (component_weight/all_items_weight)

  # (Ic(t) - 100)/Ia(t-12)
  f <- (component_index - 100) / dplyr::lag(all_items_index, 12)

  # Ia(Jan) / 100
  g <- I_x_Jan(month, all_items_index) / 100

  section3 <- e * f * g * I_x_Dec(month, all_items_index)


  # Final calculation to add the sections
  return(section1 + section2 + section3)
}



#' Title
#'
#' @param month
#' @param value
#'
#' @return
#' @export
#'
#' @examples
I_x_Dec <- function(month, value){
  dplyr::case_when(
    month == 1 ~ dplyr::lag(value, 1),
    month == 2 ~ dplyr::lag(value, 2),
    month == 3 ~ dplyr::lag(value, 3),
    month == 4 ~ dplyr::lag(value, 4),
    month == 5 ~ dplyr::lag(value, 5),
    month == 6 ~ dplyr::lag(value, 6),
    month == 7 ~ dplyr::lag(value, 7),
    month == 8 ~ dplyr::lag(value, 8),
    month == 9 ~ dplyr::lag(value, 9),
    month == 10 ~ dplyr::lag(value, 10),
    month == 11 ~ dplyr::lag(value, 11),
    month == 12 ~ dplyr::lag(value, 12),
  )
}


#' Title
#'
#' @param month
#' @param value
#'
#' @return
#' @export
#'
#' @examples
I_x_Jan <- function(month, value){
  dplyr::case_when(
    month == 1 ~ dplyr::lag(value, 12),
    month == 2 ~ dplyr::lag(value),
    month == 3 ~ dplyr::lag(value, 2),
    month == 4 ~ dplyr::lag(value, 3),
    month == 5 ~ dplyr::lag(value, 4),
    month == 6 ~ dplyr::lag(value, 5),
    month == 7 ~ dplyr::lag(value, 6),
    month == 8 ~ dplyr::lag(value, 7),
    month == 9 ~ dplyr::lag(value, 8),
    month == 10 ~ dplyr::lag(value, 9),
    month == 11 ~ dplyr::lag(value, 10),
    month == 12 ~ dplyr::lag(value, 11),
  )
}
