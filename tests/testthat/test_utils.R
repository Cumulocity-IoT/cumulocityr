context("test utils")


test_that(".get_env throws error if var is not found", {
  expect_error(.get_env("dummy_var_00"), "env var 'dummy_var_00' not found.")
})
