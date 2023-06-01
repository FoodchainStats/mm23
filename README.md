
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mm23

<!-- badges: start -->
<!-- badges: end -->

Wrangle MM23 data. Functions to acquire and manipulate consumer price
inflation series as published by the Office for National Statistics. The
`mm23.csv` file they publish is a bit of a nightmare to deal with. This
package aims to help you get the data into a more usable form.

The core functions are based around downloading and wrangling the MM23
data into tidy formats. Additionally there are a few functions designed
to help with calculating an indices contribution to the overall 12 month
index rate.

## Installation

You can install the development version of mm23 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("FoodchainStats/mm23")
```

- [Get started with
  mm23](https://foodchainstats.github.io/mm23/articles/mm23.html)
- [Calculate index
  contributions](https://foodchainstats.github.io/mm23/articles/contribution.html)
