context("test utils")


test_that(".get_cumulocity_* does not result in error", {
  expect_error(.get_cumulocity_base_url(), NA)
  expect_error(.get_cumulocity_usr(), NA)
  expect_error(.get_cumulocity_pwd(), NA)
  expect_error(.get_cumulocity_device_id(), NA)
})


test_that(".get_env throws error if var is not found", {
  expect_error(.get_env("dummy_var_00"), "env var 'dummy_var_00' not found.")
})


test_that(".check_date throws error if input is not of character class", {
  expect_error(.check_date(123), "Dates must be of class character.")

  expect_error(
    .check_date(strptime("2019-08-28T18:53:15Z",
      format = "%Y-%m-%dT%H:%M:%OSZ", tz = "Z"
    )),
    "Dates must be of class character."
  )

  expect_error(
    .check_date(as.POSIXlt("2000-08-28T18:53:15Z")),
    "Dates must be of class character."
  )
})

test_that("query is formed correctly", {
  query_01 <- .form_query(
    device_id = 111,
    date_from = "1980-03-11T13:22:43Z",
    date_to = "1990-02-23T14:33:34Z",
    page_size = 99
  )

  expect_equal(query_01$source, 111)
  expect_equal(query_01$dateFrom, "1980-03-11T13:22:43Z")
  expect_equal(query_01$dateTo, "1990-02-23T14:33:34Z")
  expect_null(query_01$pageSize)

  query_02 <- .form_query(
    device_id = 111,
    date_from = NULL,
    date_to = "1990-02-23T14:33:14Z",
    page_size = 99
  )

  expect_equal(query_02$source, 111)
  expect_null(query_02$dateFrom)
  expect_equal(query_02$dateTo, "1990-02-23T14:33:14Z")
  expect_equal(query_02$pageSize, 99)

  query_03 <- .form_query(
    device_id = 111,
    date_from = NULL,
    date_to = NULL,
    page_size = 99
  )

  expect_equal(query_03$source, 111)
  expect_null(query_03$dateFrom)
  expect_null(query_03$dateFrom)
  expect_equal(query_03$pageSize, 99)

  query_04 <- .form_query(
    device_id = 111,
    date_from = "1980-03-11T13:22:44Z",
    date_to = NULL,
    page_size = 99
  )

  expect_equal(query_04$source, 111)
  expect_equal(query_04$dateFrom, "1980-03-11T13:22:44Z")
  expect_null(query_04$dateTo)
  expect_equal(query_04$pageSize, 99)
})

test_that(".get_devices does not throw error", {
  expect_error(.get_devices(),NA)
  expect_equal(.get_devices()$status_code, 200)
})


test_that(".get_devices does not throw error", {
  expect_error(.get_devices(),NA)
  expect_equal(.get_devices()$status_code, 200)
})

