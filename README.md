
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mm23

<!-- badges: start -->
<!-- badges: end -->

Wrangle MM23 data. Functions to acquire and manipulate consumer price
inflation series as published by the Office for National Statistics.

## Installation

You can install the development version of mm23 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("FoodchainStats/mm23")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(mm23)

## basic example code
get_mm23_metadata()
#> Processing metadata
#> New names:
#> Processing CPIH annual rates
#> Processing CPIH monthly rates
#> Processing RPI average prices
#> Processing CPIH contributions to annual rate
#> Processing CPIH contributions to monthly change in rate
#> Processing monthly change in annual rate
#> Processing RPI 12 month change
#> Processing CPIH Weights
#> • `` -> `...1`
#> • `` -> `...2`
#> • `` -> `...3`
#> • `` -> `...4`
#> • `` -> `...5`
#> • `` -> `...6`
#> # A tibble: 4,053 × 9
#>    cdid  title           category level pre_unit unit  release_date next_release
#>    <chr> <chr>           <chr>    <dbl> <chr>    <chr> <chr>        <chr>       
#>  1 A9ER  CPI wts: Non-e… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  2 A9ES  CPI wts: Durab… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  3 A9ET  CPI wts: Semi-… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  4 A9EU  CPI wts: Non-d… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  5 A9EV  CPI wts: Non-s… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  6 A9EW  CPI wts: Food,… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  7 A9EX  CPI wts: Proce… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  8 A9EY  CPI wts: Unpro… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#>  9 A9EZ  CPI wts: Seaso… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#> 10 A9F2  CPI wts: Indus… <NA>        NA <NA>     Part… 19-04-2023   24 May 2023 
#> # ℹ 4,043 more rows
#> # ℹ 1 more variable: important_notes <chr>
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
