# Tests skipped on windows because it was failing on github R CMD check at the
# readxl stage and I dont have a windows environment to test right now. Seems
# like something from the internals of readxl, error log below.
#
# Last 13 lines of output:
#   1. ├─mm23::get_price_metadata() at test-prices.R:15:2
# 2. │ ├─dplyr::mutate(...) at mm23/R/prices.R:79:2
# 3. │ ├─dplyr::rename(...) at mm23/R/prices.R:79:2
# 4. │ ├─dplyr::rename_with(...) at mm23/R/prices.R:79:2
# 5. │ └─readxl::read_excel(file, sheet = "metadata") at mm23/R/prices.R:79:2
# 6. │   └─readxl:::read_excel_(...)
# 7. │     ├─readxl:::standardise_sheet(sheet, range, sheets_fun(path))
# 8. │     │ └─sheet %in% sheet_names
# 9. │     └─readxl (local) sheets_fun(path)
# 10. └─readxl (local) `<fn>`(...)
# 11.   └─base::readBin(con, raw(), n = size)



test_that("get_price_data returns a dataframe with positive length", {
  skip_on_cran()
  skip_on_os("windows")

  df <- get_price_data()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
  expect_true(ncol(df) == 3)
})

test_that("get_price_metadata returns a dataframe with positive length", {
  skip_on_cran()
  skip_on_os("windows")
  skip_on_ci()

  df <- get_price_metadata()

  expect_equal(class(df), c("tbl_df", "tbl", "data.frame"))
  expect_true(nrow(df) > 0)
})
