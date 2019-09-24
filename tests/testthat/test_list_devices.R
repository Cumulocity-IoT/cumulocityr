context("test list_devices")

test_that("list_devices returns data.frame", {
  expect_equal(is.data.frame(list_devices()), TRUE)
})
