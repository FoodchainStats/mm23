
test_that("get_mm23_metadata returns a dataframe with positive length", {
  skip_on_cran()
  skip_on_ci()

  df <- get_mm23_metadata()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
})
