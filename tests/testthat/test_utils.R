context("test utils")


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
