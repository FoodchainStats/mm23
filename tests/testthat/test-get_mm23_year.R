
test_that("get_mm23_year returns a dataframe with positive length", {
  skip_on_cran()
  skip_on_ci()

  df <- get_mm23_year()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 4)
})
