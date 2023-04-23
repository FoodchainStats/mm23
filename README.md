
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mm23

<!-- badges: start -->
<!-- badges: end -->

Wrangle MM23 data. Functions to acquire and manipulate consumer price
inflation series as published by the Office for National Statistics. The
`mm23.csv` file they publish is a bit of a nightmare to deal with. This
package aims to help you get the data into a more usable form.

## Installation

You can install the development version of mm23 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("FoodchainStats/mm23", auth_token = "Your GitHub PAT")
```

## Example

Download the latest MM23 from ONS. `acquire_mm23()` will download the
full latest `mm23.csv` file, and return its location. By default it puts
it into a temporary file, but you can specify where you want to put it.

``` r
library(mm23)

# Puts the data in a temporary file and returns its name
mm23 <- acquire_mm23()

# Or specify a location
mm23 <- acquire_mm23("~/data")
data <- read.csv("~/data/mm23.csv")
```

## Getting data

The get\_\* functions will return data in a tidy format, eg:

| date       | cdid | value | period |
|:-----------|:-----|------:|:-------|
| 1947-06-01 | CDKO |  28.9 | M      |
| 1947-07-01 | CDKO |  29.1 | M      |
| 1947-07-01 | CDKP |   1.2 | M      |
| 1947-07-01 | CZEQ |   0.7 | M      |
| 1947-07-01 | CZFB |   0.8 | M      |
| 1947-07-01 | CZFG |   0.0 | M      |

Its more efficient to use `acquire_mm23` first so as to only download
the data once. But if used without parameters the `get_mm23_*` functions
will download the latest data.

``` r
mm23 <- acquire_mm23()
m <- get_mm23_month(mm23)
q <- get_mm23_quarter(mm23)
y <- get_mm23_year(mm23)

data <- dplyr::bind_rows(m, q, y)
```

Use `get_mm23_metadata()` to return details of what each series CDID
represents. You can join data and metadata by CDID.

| cdid | title                                                       | category             | level | pre_unit | unit | release_date | next_release | important_notes |
|:-----|:------------------------------------------------------------|:---------------------|------:|:---------|:-----|:-------------|:-------------|:----------------|
| L5MS | CPIH 1mth: Medical services (S) 2015=100                    | NA                   |    NA | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| J39L | 05.5.2.1 Non-Motorized Small Tools                          | CPIH Annual rate (%) |     4 | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| L8AI | CPI WEIGHTS 05.3.1.3 Cookers                                | NA                   |    NA | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| L7QE | CPI ANNUAL RATE 05.3.2.3 Irons 2015=100                     | NA                   |    NA | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| D7JZ | CPI MONTHLY RATE 03.2 : FOOTWEAR INCLUDING REPAIRS 2015=100 | NA                   |    NA | NA       | %    | 19-04-2023   | 24 May 2023  | NA              |

``` r
mm23 <- acquire_mm23()
metadata <- get_mm23_metadata(mm23)

m |>
filter(cdid == "L55O") |>
left_join(metadata)
```
