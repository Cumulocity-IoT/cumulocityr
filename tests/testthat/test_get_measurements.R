context("test get_measurements")


test_that("when abridged=TRUE, 'self' and 'source' fields are excluded from results", {
  expect_null(result_01$self)
  expect_null(result_01$source)
})

test_that("page_size controls number of records returned", {
  expect_equal(NROW(result_01), 2)
  expect_equal(NROW(result_02), 11)
})

test_that("time is parsed or not depending on parse_time", {
  expect_true(inherits(result_01$time[1], "POSIXlt"))
  expect_false(inherits(result_02$time[1], "POSIXlt"))
})

test_that("warning message is issues when measurements list is empty", {
  expect_warning(get_measurements(123), "No measurements found.")
})
