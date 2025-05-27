
test_that("get_mm23_quarter returns a dataframe with positive length", {
  skip_on_cran()

  df <- get_mm23_quarter()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 4)
})
