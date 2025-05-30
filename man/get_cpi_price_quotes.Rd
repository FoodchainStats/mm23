% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_cpi_quotes.R
\name{get_cpi_price_quotes}
\alias{get_cpi_price_quotes}
\title{Get CPI price quotes for food items.}
\usage{
get_cpi_price_quotes(year, month, foodonly = TRUE, path)
}
\arguments{
\item{year}{Year to extract}

\item{month}{Month to extract}

\item{foodonly}{whether to exclude non-food products from the output.}

\item{path}{Optional path to save data}
}
\value{
a tibble of price quotes
}
\description{
See \href{https://foodchainstats.github.io/mm23/articles/price-quotes.html}{Price quotes} article.
}
\examples{
\dontrun{
get_cpi_price_quotes(2021, 8)

# You can extract multiple months, but beware that the format changes over
time

get_cpi_price_quotes(2024, 1:12)

}
}
