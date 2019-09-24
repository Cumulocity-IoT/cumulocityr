# CUMULOCITYR
#
# Copyright (c) 2019, Software AG, Darmstadt, Germany and/or Software AG
# USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates
# and/or their licensors.
#
# This file is part of the CUMULOCITYR package for R.
#
# The CUMULOCITYR package is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# The CUMULOCITYR package is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Please see the
# GNU General Public License for details (http://www.gnu.org/licenses/).
# #############################################################################

#' Get the measurements for a device for a time period.
#'
#'
#' @param device_id The device id.
#' @param date_from The starting datetime.
#' @param date_to The ending datetime.
#' @param page_size The page size.
#' @param abridged If TRUE, exclude "self" and "source" fields from results.
#' @param parse_time If TRUE, parse "time" field from char to POSIXlt.
#'
#' @return R object with measurements.
#'
#' @details
#' Get the measurements for a device for a time period.
#'
#' The parameter \code{page_size} is only used if \code{date_from}
#' or \code{date_to} are NULL, or both are NULL.
#'
#'
#' @author Dmitriy Bolotov
#'
#' @references
#' \href{https://cumulocity.com/guides/reference/events/}{Cumulocity Events API}
#' \href{https://cumulocity.com/guides/reference/measurements/}{Cumulocity Measurements API}
#'
#'
#' @examples
#' \dontrun{
#' get_data(device_id)
#' }
#' @export
get_data <- function(device_id,
                     date_from = NULL,
                     date_to = NULL,
                     page_size = 10,
                     abridged = TRUE,
                     parse_time = TRUE) {
  # response <- .get_measurements(device_id, date_from, date_to)

  .check_date(date_from)
  .check_date(date_to)

  url <- paste0(.get_cumulocity_base_url(),
    "/measurement/measurements",
    collapse = ""
  )

  query <- .form_query(device_id, date_from, date_to, page_size)


  response <- GET(
    url = url,
    query = query,
    httr::authenticate(
      .get_cumulocity_usr(),
      .get_cumulocity_pwd()
    )
  )

  cont <- httr::content(response, "text")
  cont_parsed <- jsonlite::fromJSON(cont)

  .check_response_for_error(response, cont_parsed)


  measurements <- cont_parsed$measurements

  if (!length(measurements)) {
    warning("No measurements found.")
    return(measurements)
  }

  if (abridged) {
    measurements <- measurements[, -which(names(measurements) %in% c("self", "source"))]
  }

  if (parse_time) {
    measurements$time <- strptime(measurements$time, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "Z")
  }

  return(measurements)
}
