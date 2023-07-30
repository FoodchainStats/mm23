
test_that("get_price_data returns a dataframe with positive length", {
  skip_on_cran()

  df <- get_price_data()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 3)
})

test_that("get_price_metadata returns a dataframe with positive length", {
  skip_on_cran()

  df <- get_price_metadata()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
})
