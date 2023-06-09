% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_mm23_year.R
\name{get_mm23_year}
\alias{get_mm23_year}
\title{Get yearly mm23 data}
\usage{
get_mm23_year(rawfile)
}
\arguments{
\item{rawfile}{A downloaded mm23.csv file. If missing will attempt to
download from ONS.}
}
\value{
A tibble containing date, CDID and value.
}
\description{
Get yearly mm23 data
}
\examples{
\dontrun{
url <- "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/
datasets/consumerpriceindices/current/mm23.csv"
    tmp <- tempfile()
download.file(url, tmp)
rawfile <- tmp
get_mm23_month(rawfile)
}
}
