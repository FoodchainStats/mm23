
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
devtools::install_github("FoodchainStats/mm23", auth_token = "Your GitHub PAT")
```

## Example

Download the latest MM23 from ONS.

``` r
library(mm23)

# Puts the data in a temporary file and returns its name
# mm23 <- acquire_mm23()
# metadata <- mm23 |> get_mm23_metadata()

# Or specify a location
# mm23 <- acquire_mm23("~/data")
# data <- read.csv("~/data/mm23.csv")
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
