test_that("get_weights_jan returns a dataframe with positive length for CPI", {
  skip_on_cran()
  skip_on_os("windows")
  skip_on_ci()

  df <- get_weights_jan(measure = "cpi")

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 3)
})


test_that("get_weights_jan returns a dataframe with positive length for CPIH", {
  skip_on_cran()
  skip_on_os("windows")
  skip_on_ci()

  df <- get_weights_jan(measure = "cpih")

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 3)
})



test_that("get_weights returns a dataframe with positive length for CPI", {
  skip_on_cran()
  skip_on_os("windows")
  skip_on_ci()

  df <- get_weights(measure = "cpi")

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 3)
})


test_that("get_weights returns a dataframe with positive length for CPIH", {
  skip_on_cran()
  skip_on_os("windows")
  skip_on_ci()

  df <- get_weights(measure = "cpih")

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 3)
})


test_that("get_cpih_cdid_lookup returns a dataframe with positive length for CPIH", {
  skip_on_cran()
  skip_on_os("windows")
  skip_on_ci()

  df <- get_cpih_cdid_lookup()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
})
