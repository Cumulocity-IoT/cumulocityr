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
