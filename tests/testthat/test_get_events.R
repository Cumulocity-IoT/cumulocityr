context("test get_events")

test_that("page_size controls number of records returned", {
  skip_on_cran()

  # results used in test_get_events.R
  result_06 <- get_events(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 2
  )

  result_07 <- get_events(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 4
  )

  expect_equal(NROW(result_06), 2)
  expect_equal(NROW(result_07), 4)
})

# test_that("time is parsed or not depending on parse_datetime", {
#   skip_on_cran()
#
#   result_06 <- get_events(
#     device_id = .get_cumulocity_device_id(),
#     date_from = "2019-09-30T20:00:00Z",
#     num_rows = 2
#   )
#
#   result_07 <- get_events(
#     device_id = .get_cumulocity_device_id(),
#     date_from = "2019-09-30T20:00:00Z",
#     num_rows = 4, parse_datetime = FALSE
#   )
#
#   expect_true(inherits(result_06$time[1], "POSIXlt"))
#   expect_true(is.character(result_07$time[1]))
# })

# test_that("warning message is issued when measurements list is empty", {
#   skip_on_cran()
#   expect_warning(get_events(123, date_from = "2019-09-30T20:00:00Z"),
#     "No events found on page 1.",
#     fixed = TRUE
#   )
# })

test_that("parse_json = FALSE returns character string", {
  skip_on_cran()

  result_10 <- get_events(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 7, parse_json = FALSE
  )

  expect_true(inherits(result_10[[1]], "character"))
})


test_that("when num_rows is NULL, return all records between two dates", {
  result_11 <- get_events(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T00:00:00Z", date_to = "2019-10-01T04:40:10Z"
  )
  expect_equal(NROW(result_11), 1)
})
