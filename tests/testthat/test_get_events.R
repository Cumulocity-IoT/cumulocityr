context("test get_events")


test_that("when drop_fields=TRUE, 'self' and 'source' fields are excluded from results", {
  expect_null(result_06$self)
  expect_null(result_06$source.self)
  expect_null(result_06$source.id)
})

test_that("page_size controls number of records returned", {
  expect_equal(NROW(result_06), 2)
  expect_equal(NROW(result_07), 4)
})

test_that("time is parsed or not depending on parse_datetime", {
  expect_true(inherits(result_06$time[1], "POSIXlt"))
  expect_true(is.character(result_07$time[1]))
})

test_that("warning message is issued when measurements list is empty", {
  expect_warning(get_events(123), "No events found on page 1.", fixed = TRUE)
})

test_that("parse = FALSE returns character string", {
  expect_true(inherits(result_10[[1]],"character"))
})
