% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/weights.R
\name{get_cpi_weights}
\alias{get_cpi_weights}
\title{Create a CPI weights dataset}
\usage{
get_cpi_weights(rawfile)
}
\arguments{
\item{rawfile}{A downloaded mm23.csv file. If missing will attempt to
download from ONS.}
}
\value{
A dataframe of monthly CPIH weights, including the January weights
which are not exposed in mm23 but only available in the Table 11 sheet of
the reference tables spreadsheet.
}
\description{
Create a CPI weights dataset
}
\examples{
\dontrun{
weights <- get_cpi_weights()
}
}
