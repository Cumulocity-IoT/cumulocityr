

# responses used in test_get_data.R
result_01 <- get_data(device_id = .get_cumulocity_device_id(), page_size = 2)
result_02 <- get_data(device_id = .get_cumulocity_device_id(), page_size = 11, parse_time = FALSE)
