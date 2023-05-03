# Stores the ONS url
# Not exported
mm23_url <- function(){
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceindices/current/mm23.csv"
  return(url)
}


# Stores the link to the reference tables xlsx. Im not sure if this url is
# stable or not.
# Not exported
reftables_url <- function(){
  url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceinflation/current/consumerpriceinflationdetailedreferencetables2.xlsx"
  return(url)
}

# Hopefully unchains a CPI series
# not exported
unchain <- function(month, value) {
  case_when(
    month == 1 ~ value/lag(value),
    month == 2 ~ value/lag(value, 1),
    month == 3 ~ value/lag(value, 2),
    month == 4 ~ value/lag(value, 3),
    month == 5 ~ value/lag(value, 4),
    month == 6 ~ value/lag(value, 5),
    month == 7 ~ value/lag(value, 6),
    month == 8 ~ value/lag(value, 7),
    month == 9 ~ value/lag(value, 8),
    month == 10 ~ value/lag(value, 9),
    month == 11 ~ value/lag(value, 10),
    month == 12 ~ value/lag(value, 11)
  )
}
