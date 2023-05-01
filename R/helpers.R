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
