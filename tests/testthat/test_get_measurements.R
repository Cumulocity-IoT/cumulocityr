context("test get_measurements")


test_that("page_size controls number of records returned", {
  skip_on_cran()

  result_01 <- get_measurements(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 2
  )

  result_02 <- get_measurements(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 11, parse_datetime = FALSE
  )

  expect_equal(NROW(result_01), 2)
  expect_equal(NROW(result_02), 11)
})

test_that("time is parsed or not depending on parse_datetime", {
  skip_on_cran()

  result_01 <- get_measurements(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 2
  )

  result_02 <- get_measurements(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 11, parse_datetime = FALSE
  )

  expect_true(inherits(result_01$time[1], "POSIXlt"))
  expect_true(is.character(result_02$time[1]))
})


test_that("when num_rows is NULL, return all records between two dates", {
  result_10 <- get_measurements(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-10-01T00:00:00Z", date_to = "2019-10-01T00:00:10Z"
  )
  expect_equal(NROW(result_10), 2)
})

# test_that("what happens when num_rows is very large but there is only data on page 1?", {
#   get_measurements(device_id = .get_cumulocity_device_id(),
#                    date_from = "2019-10-01T02:00:00Z")
# })



test_that("warning message is issued when measurements list is empty", {
  skip_on_cran()
  # Measurements list is empty because the device_id does not exist.
  expect_warning(get_measurements(
    device_id = 123,
    date_from = "2019-09-30T20:00:00Z"
  ),
  "No measurements found on page 1.",
  fixed = TRUE
  )
})

test_that("parse_json = FALSE returns character string", {
  skip_on_cran()
  result_08 <- get_measurements(
    device_id = .get_cumulocity_device_id(),
    date_from = "2019-09-30T20:00:00Z",
    num_rows = 7, parse_json = FALSE
  )
  expect_true(inherits(result_08[[1]], "character"))
})
