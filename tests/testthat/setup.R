

# results used in test_get_data.R
result_01 <- get_data(device_id = .get_cumulocity_device_id(), page_size = 2)
result_02 <- get_data(device_id = .get_cumulocity_device_id(), page_size = 11, parse_time = FALSE)

# results used in test_utils.R
url_01 <- paste0(.get_cumulocity_base_url(),
              "/inventory/managedObjects?fragmentType=c8y_IsDevice",
              collapse = "")
result_03 <- httr::GET(url = url_01, httr::authenticate("foo","bar"))
cont_03 <- httr::content(result_03, "text")
cont_parsed_03 <- jsonlite::fromJSON(cont_03)

