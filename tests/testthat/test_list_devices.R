context("test list_devices")

test_that("list_devices returns data.frame", {
  expect_equal(is.data.frame(list_devices(page_size = 3)), TRUE)
})

test_that("when abridged = TRUE, certain fields are excluded from results", {
  aa <- list_devices(page_size = 5, abridged = TRUE)

  exclude_list <- c("additionParents", "childDevices",
                    "childAssets", "childAdditions",
                    "assetParents", "deviceParents",
                    "self")
  expect_false(any(names(aa) %in% exclude_list))

})


test_that("time is parsed or not depending on parse_datetime", {
  expect_true(inherits(result_04$creationTime[1], "POSIXlt"))
  expect_true(inherits(result_04$lastUpdated[1], "POSIXlt"))
  expect_true(inherits(result_04$c8y_Availability$lastMessage[1], "POSIXlt"))

  expect_true(is.character(result_05$creationTime[1]))
  expect_true(is.character(result_05$lastUpdated[1]))
  expect_true(is.character(result_05$c8y_Availability$lastMessage[1]))

})
