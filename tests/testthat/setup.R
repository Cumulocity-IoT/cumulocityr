

# results used in test_get_measurements.R
result_01 <- get_measurements(device_id = .get_cumulocity_device_id(), page_size = 2)
result_02 <- get_measurements(device_id = .get_cumulocity_device_id(), page_size = 11, parse_datetime = FALSE)
result_08 <- get_measurements(device_id = .get_cumulocity_device_id(), page_size = 7, parse = FALSE)

# results used in test_utils.R
url_01 <- paste0(.get_cumulocity_base_url(),
  "/inventory/managedObjects?fragmentType=c8y_IsDevice",
  collapse = ""
)
result_03 <- httr::GET(url = url_01, httr::authenticate("foo", "bar"))
cont_03 <- httr::content(result_03, "text")
cont_parsed_03 <- jsonlite::fromJSON(cont_03)

# results used in test_get_devices.R
result_04 <- get_devices(page_size = 2)
result_05 <- get_devices(page_size = 10, parse_datetime = FALSE)
result_09 <- get_devices(page_size = 3, parse = FALSE)

# results used in test_get_events.R
result_06 <- get_events(device_id = .get_cumulocity_device_id(), page_size = 2)
result_07 <- get_events(device_id = .get_cumulocity_device_id(), page_size = 4, parse_datetime = FALSE)
result_10 <- get_events(device_id = .get_cumulocity_device_id(), page_size = 3, parse = FALSE)
