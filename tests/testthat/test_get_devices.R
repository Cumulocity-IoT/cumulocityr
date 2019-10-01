context("test get_devices")

test_that("get_devices returns data.frame", {
  expect_equal(is.data.frame(get_devices(page_size = 3)), TRUE)
})

test_that("when drop_fields = TRUE, certain fields are excluded from results", {
  aa <- get_devices(page_size = 5, drop_fields = TRUE)

  exclude_list <- c(
    "additionParents.self", "additionParents.references", "childDevices.self",
    "childDevices.references", "childAssets.self", "childAssets.references", "childAdditions.self",
    "childAdditions.references","deviceParents.self", "deviceParents.references",
    "assetParents.self", "assetParents.references", "self")

  expect_false(any(names(aa) %in% exclude_list))
})


test_that("time is parsed or not depending on parse_datetime", {
  expect_true(inherits(result_04$creationTime[1], "POSIXlt"))
  expect_true(inherits(result_04$lastUpdated[1], "POSIXlt"))
  expect_true(inherits(result_04$c8y_Availability$lastMessage[1], "POSIXlt"))

  result_05_row <- result_05[which(result_05$id == .get_cumulocity_device_id()), ]

  expect_true(is.character(result_05_row$creationTime[1]))
  expect_true(is.character(result_05_row$lastUpdated[1]))
  expect_true(is.character(result_05_row$c8y_Availability.lastMessage[1]))
})


test_that("parse = FALSE returns character string", {
  expect_true(inherits(result_09[[1]],"character"))
})
