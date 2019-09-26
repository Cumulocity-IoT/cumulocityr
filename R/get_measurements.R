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
#' @param page_size The page size, set to 2000 (maximum) by default. Used
#' when at least one of the dates is NULL.
#' @param abridged If TRUE, exclude "self" and "source" fields from the result.
#' @param parse_datetime If TRUE, parse "time" field from char to POSIXlt.
#'
#' @return A \code{data.frame} with measurements.
#'
#' Note that some columns in the returned data frame contain data frames themselves.
#' For example, \code{c8y_Mobile} is a \code{data.frame} of 11 variables.
#'
#' If both \code{date_from} and \code{date_to} are present, \code{page_size}
#' is not used.
#'
#' If \code{page_size} and both dates are NULL, the function will return up to 5 rows of data.
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
#' get_measurements(device_id)
#' }
#' @export
get_measurements <- function(device_id,
                     date_from = NULL,
                     date_to = NULL,
                     page_size = 2000,
                     abridged = TRUE,
                     parse_datetime = TRUE) {
  # response <- .get_measurements(device_id, date_from, date_to)

  .check_date(date_from)
  .check_date(date_to)

  url <- paste0(.get_cumulocity_base_url(),
    "/measurement/measurements",
    collapse = ""
  )

  query <- .form_query(device_id, date_from, date_to, page_size)


  response <- httr::GET(
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

  if (parse_datetime) {

    # measurements$time <- strptime(measurements$time, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "Z")
    measurements$time <- .parse_datetime(measurements$time)
  }

  return(measurements)
}
