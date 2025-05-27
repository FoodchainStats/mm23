test_that("get_cpi_price_quotes returns a dataframe with positive length", {
  skip_on_cran()

  df <- get_cpi_price_quotes(2022, 4)

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 12)
})
