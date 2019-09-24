context("test get_data")


# test_that("when abridged=TRUE, 'self' and 'source' fields are excluded from results", {
#   skip_on_travis()
#   expect_null(result_01$self)
#   expect_null(result_01$source)
# })
#
# test_that("page_size controls number of records returned", {
#   skip_on_travis()
#   expect_equal(NROW(result_01), 2)
#   expect_equal(NROW(result_02), 11)
# })
#
# test_that("time is parsed or not depending on parse_time", {
#   skip_on_travis()
#   expect_true(inherits(result_01$time[1], "POSIXlt"))
#   expect_false(inherits(result_02$time[1], "POSIXlt"))
# })
