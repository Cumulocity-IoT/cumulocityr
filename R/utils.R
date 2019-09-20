# utility functions

.get_env <- function(the_var) {
  # get value of environment variable, throw error if not found.
  result <- Sys.getenv(the_var)
  if (result == "") {
    stop(paste0(c("env var '", the_var, "' not found."), collapse = ""))
  }
  return(result)
}

.get_cumulocity_base_url <- function() {
  .get_env("CUMULOCITY_base_url")
}

.get_cumulocity_usr <- function() {
  .get_env("CUMULOCITY_usr")
}

.get_cumulocity_pwd <- function() {
  .get_env("CUMULOCITY_pwd")
}



.get_devices <- function() {
  # Get object with devices.
  url <- paste0(.get_cumulocity_base_url(),
    "/inventory/managedObjects?fragmentType=c8y_IsDevice",
    collapse = ""
  )

  response <- httr::GET(
    url = url,
    httr::authenticate(
      .get_cumulocity_usr(),
      .get_cumulocity_pwd()
    )
  )
  return(response)
}


.get_measurements <- function(device_id, time_period) {
  # Get measurements for a device.
  url <- paste0(.get_cumulocity_base_url(),
    "/measurement/measurements",
    collapse = ""
  )

  response <- GET(
    url = url,
    query = list(source = device_id, pageSize = "20"),
    httr::authenticate(
      .get_cumulocity_usr(),
      .get_cumulocity_pwd()
    )
  )
  return(response)
}


.check_response <- function(response, cont_parsed) {
  # Check for http error; if TRUE, print an error message.
  error_resp <- httr::http_error(response)
  if (error_resp) {
    error_message <- sprintf(
      "Cumulocity API request failed with status code %s:\n%s\n%s\n%s\n%s",
      httr::status_code(response),
      httr::http_status(response)$category,
      httr::http_status(response)$reason,
      httr::http_status(response)$message,
      cont_parsed$message
    )
    stop(error_message, call. = FALSE)
  }
}
