context("test get_events")


test_that("page_size controls number of records returned", {
  skip_on_cran()
  expect_equal(NROW(result_06), 2)
  expect_equal(NROW(result_07), 4)
})

test_that("time is parsed or not depending on parse_datetime", {
  skip_on_cran()
  expect_true(inherits(result_06$time[1], "POSIXlt"))
  expect_true(is.character(result_07$time[1]))
})

test_that("warning message is issued when measurements list is empty", {
  skip_on_cran()
  expect_warning(get_events(123, date_from = "2019-09-30T20:00:00Z"),
    "No events found on page 1.",
    fixed = TRUE
  )
})

test_that("parse_json = FALSE returns character string", {
  skip_on_cran()
  expect_true(inherits(result_10[[1]], "character"))
})
