context("test get_devices")


test_that("get_devices returns data.frame", {
  skip_on_cran()
  expect_equal(is.data.frame(get_devices(page_size = 3)), TRUE)
})


test_that("time is parsed or not depending on parse_datetime", {
  skip_on_cran()

  result_04 <- get_devices(page_size = 2)
  result_05 <- get_devices(page_size = 10, parse_datetime = FALSE)

  expect_true(inherits(result_04$creationTime[1], "POSIXlt"))
  expect_true(inherits(result_04$lastUpdated[1], "POSIXlt"))
  expect_true(inherits(result_04$c8y_Availability$lastMessage[1], "POSIXlt"))

  result_05_row <- result_05[which(result_05$id == .get_cumulocity_device_id()), ]

  expect_true(is.character(result_05_row$creationTime[1]))
  expect_true(is.character(result_05_row$lastUpdated[1]))
  expect_true(is.character(result_05_row$c8y_Availability.lastMessage[1]))
})


test_that("parse_json = FALSE returns character string", {
  skip_on_cran()

  result_09 <- get_devices(page_size = 3, parse_json = FALSE)

  expect_true(inherits(result_09[[1]], "character"))
})
