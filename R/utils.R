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

.get_cumulocity_device_id <- function() {
  .get_env("CUMULOCITY_device_id")
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



.check_response_for_error <- function(response, cont_parsed) {
  # Check for http error; if TRUE, print an error message.
  error_resp <- httr::http_error(response)
  if (error_resp) {
    if (!is.null(cont_parsed$message)) {
      message_2 <- cont_parsed$message
    } else if (!is.null(cont_parsed$error)) {
      message_2 <- cont_parsed$error
    } else {
      message_2 <- "."
    }

    error_message <- sprintf(
      "Cumulocity API request failed with status code %s.\n\n%s\n%s\n%s\n%s",
      httr::status_code(response),
      paste("Category:         ", httr::http_status(response)$category, sep = ""),
      paste("Reason:           ", httr::http_status(response)$reason, sep = ""),
      paste("Status message:   ", httr::http_status(response)$message, sep = ""),
      paste("Response message: ", message_2, sep = "")
    )
    stop(error_message, call. = FALSE)
  }
}

.check_date <- function(the_date) {
  # TODO: Check that the input is of class POSIXlt or can be converted to POSIXlt.

  # if (inherits(the_date, "POSIXlt")){
  #   the_date <- as.character(the_date)
  # } else {
  #   stop("Dates must be of class POSIXlt.")
  # }

  # the_date <- as.character(the_date)

  if (!is.null(the_date) & !is.character(the_date)) {
    stop("Dates must be of class character.")
  }
}


.form_query <- function(device_id, date_from, date_to, page_size) {
  # Form the query for GET in get_data.
  if (is.null(date_from) & is.null(date_to)) {
    query <- list(source = device_id, pageSize = page_size)
  } else if (!is.null(date_from) & !is.null(date_to)) {
    query <- list(source = device_id, dateFrom = date_from, dateTo = date_to)
  } else if (!is.null(date_from)) {
    query <- list(source = device_id, dateFrom = date_from, pageSize = page_size)
  } else if (!is.null(date_to)) {
    query <- list(source = device_id, dateTo = date_to, pageSize = page_size)
  }

  return(query)
}



# .get_measurements <- function(device_id, date_from, date_to) {
#   # Get measurements for a device.
#   url <- paste0(.get_cumulocity_base_url(),
#     "/measurement/measurements",
#     collapse = ""
#   )
#
#   if (is.null(date_from) | is.null(date_to)) {
#     query <- list(source = device_id, pageSize = "20")
#   } else {
#     query <- list(source = device_id, dateFrom = date_from, dateTo = date_to)
#   }
#
#   response <- GET(
#     url = url,
#     query = query,
#     httr::authenticate(
#       .get_cumulocity_usr(),
#       .get_cumulocity_pwd()
#     )
#   )
#   return(response)
# }
#
