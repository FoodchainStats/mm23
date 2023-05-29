
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
devtools::install_github("FoodchainStats/mm23")
```

## Get MM23

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

## Get MM23 data series and metadata

The `get_mm23_*` functions will return data in a tidy format, eg:

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
represents. Here is a random sample of its output. You can join data and
metadata by CDID, for example with:

``` r
mm23 <- acquire_mm23()
metadata <- get_mm23_metadata(mm23)

m |>
filter(cdid == "L55O") |>
left_join(metadata)
```

| cdid | title                                                       | category             | level | pre_unit | unit | release_date | next_release | important_notes |
|:-----|:------------------------------------------------------------|:---------------------|------:|:---------|:-----|:-------------|:-------------|:----------------|
| L5MS | CPIH 1mth: Medical services (S) 2015=100                    | NA                   |    NA | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| J39L | 05.5.2.1 Non-Motorized Small Tools                          | CPIH Annual rate (%) |     4 | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| L8AI | CPI WEIGHTS 05.3.1.3 Cookers                                | NA                   |    NA | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| L7QE | CPI ANNUAL RATE 05.3.2.3 Irons 2015=100                     | NA                   |    NA | NA       | NA   | 19-04-2023   | 24 May 2023  | NA              |
| D7JZ | CPI MONTHLY RATE 03.2 : FOOTWEAR INCLUDING REPAIRS 2015=100 | NA                   |    NA | NA       | %    | 19-04-2023   | 24 May 2023  | NA              |

## Weights

CPIH weights are a problem. They are adjusted twice a year (since 2017),
in December and January. But the mm23 dataset only has a single weight
for each year. The only place the full weights are exposed are in the
‘detailed reference tables’ spreadsheet. So there is now a new function
`get_cpih_weights()` which generates a weights dataset. It may not be
very robust, it needs some testing, but if everything is in the right
place it works OK.

It returns a dataset with a weight for every month.

## Unchaining and calculating contribution

The `unchain()` function can be used within a `mutate()` call to produce
an unchained index. Its based on the assumption that CPI weights change
twice a year, and so an unchained index is based on previous January =
100, or for the January index, based on previous December = 100. Example
code below.

``` r

library(mm23)
library(dplyr)
library(lubridate)

mm23 <- acquire_mm23()
data <- get_mm23_month(mm23)

food_unchained <- data |> 
  filter(cdid %in% c("L522", "L523") & date >= "2017-01-01") |> 
  group_by(cdid) |> 
  mutate(unchained_value = unchain(month(date), value))
```

## Calculating contribution to ‘all items’ 12 month rate

The calculation is as follows, where:

$c = component\ c$

$a =\ 'all\ items'\ CPI\ index$

$W^c_{y} = weight\ of\ component\ c\ in\ year\ y$
$I^c_t = index\ for\ component\ c\ in\ month\ t\ based\ on\ January\ of\ current\ year =100$
$I^a_{Jan} = all\ items\ index\ for\ January\ based\ on\ previous\ month\ (December) = 100$
$I^a_{Dec} = all\ items\ index\ for\ December\ based\ on\ previous\ January = 100$

$$
(\frac{W^c_{y-1}} {W^a_{y-1}})
\times
(\frac{({I^c_{Dec}} - {I^c_{t-12}})}{I^a_{t-12}})
\times
100
\ \ +\ \ 
(\frac{W^c_y}{W^a_y})
\times
(\frac{({I^c_{Jan}}-100)}{I^a_{t-12}})
\times
I^a_{Dec}
\ \ +\ \
(\frac{W^c_y}{W^a_y})
\times
(\frac{(I^c_t - 100)}{I^a_{t-12}})
\times
\frac{I^a_{Jan}}{100}
\times
I^a_{Dec}
$$

Note that ‘all items’ doesn’t have to be all items CPIH, it can be a
category total (such as food). It is important that the calculations are
performed using **unchained indices** (i.e. based on previous January =
100, or for the January index, based on previous December =100). For the
month of interest, the contribution of each component of the CPI to the
12-month rate is calculated. The same is done for the preceding month.
The differences between the two are the contributions to the *change* in
the CPI 12-month rate.

The `contribution()` function applies this calculation to a wide dataset
(1 column with month number or date, and the indices and weights in
subsequent columns). It can then be used in a `mutate()` call. It takes
$I^a$, $W^a$, $I^c$, and $W^c$ as parameters, and leverages
`dplyr::lag()` to do the rest. Example below.

## Putting it all together

Code to calculate the contribution to changes in food and non-alcoholic
drinks inflation.

``` r
library(mm23)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)

# Get our data together
mm23 <- acquire_mm23()
data <- get_mm23_month(mm23)
wts <- get_cpih_weights()
lookup <- get_cpih_cdid_lookup() # not needed here, just for reference


# Select and unchain food indices
food_cdids <- c("L523",
                "L52I",
                "L52J",
                "L52K",
                "L52L",
                "L52M",
                "L52N",
                "L52O",
                "L52P",
                "L52Q",
                "L52S",
                "L52T")


food_unchained <- data |> 
  filter(cdid %in% food_cdids & date >= "2017-01-01") |> 
  group_by(cdid) |> 
  mutate(
    unchained_value = unchain(month(date), value)
  ) |> 
  select(date, cdid, value = unchained_value)


# Extract the relevant food weights
food_weights <- c("L5CZ",
                  "L5DH",
                  "L5DI",
                  "L5DJ",
                  "L5DK",
                  "L5DL",
                  "L5DM",
                  "L5DN",
                  "L5DO",
                  "L5DP",
                  "L5DR",
                  "L5DS")


foodwts <- wts |> 
  filter(cdid %in% food_weights & date >= "2017-01-01" & date <= "2023-03-01") 


# Combine the indices and weights and calculate the contribution to annual rate
unchained <- food_unchained |> 
  bind_rows(foodwts) |> 
  pivot_wider(names_from = cdid)

contribution <- unchained |> 
            mutate(bread = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52I,
                                        component_weight = L5DH),
                   meat = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52J,
                                        component_weight = L5DI),
                   fish = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52K,
                                        component_weight = L5DJ),
                   dairy = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52L,
                                        component_weight = L5DK),
                   oils = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52M,
                                        component_weight = L5DL),
                   fruit = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52N,
                                        component_weight = L5DM),
                   vegetables = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52O,
                                        component_weight = L5DN),
                   sugar = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52P,
                                        component_weight = L5DO),
                   food_nec = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52Q,
                                        component_weight = L5DP),
                   coffee = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52S,
                                        component_weight = L5DR),
                   water = contribution(month = month(date),
                                        all_items_index = L523,
                                        all_items_weight = L5CZ,
                                        component_index = L52T,
                                        component_weight = L5DS)
                   )


# put the data back into tidy form and plot some results
cont <- contribution |> 
  select(date, bread:water) |> 
  pivot_longer(cols = bread:water) |> 
  filter(!is.na(value))

cont |> 
  filter(date >= "2021-07-01") |> 
  ggplot() +
  geom_col(aes(x = date, y = value, fill = name)) +
  labs(title = "Contribution to annual food and non-alc inflation rate")
```
