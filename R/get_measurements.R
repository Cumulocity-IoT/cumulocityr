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
#' @param page_size The page size, set to 2000 (maximum) by default.
#' @param pages_per_query The number of pages to return per function call.
#' @param start_page The first page used in the query.
#' @param drop_fields If TRUE, exclude "self" and "source" fields from the result.
#' @param parse_datetime If TRUE, parse "time" field from char to POSIXlt.
#' @param parse If TRUE, parse the JSON object into a data frame.
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
#' If \code{parse} is TRUE, the JSON object is parsed using \code{jsonlite::fromJSON}
#' before being returned. The data is converted to a single flattened data frame.
#' If a page does not contain any measurements, it does not get added to the data frame.
#'
#' If \code{parse} is FALSE, the JSON object is returned as a JSON string. For queries with multiple pages, a
#' list of such objects is returned. All pages are added to the list, even if there are no measurements.
#' The params \code{drop_fields} and \code{parse_datetime} have no effect.
#'
#'
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
                             pages_per_query = 1,
                             start_page = 1,
                             drop_fields = TRUE,
                             parse_datetime = TRUE,
                             parse = TRUE) {
  .check_date(date_from)
  .check_date(date_to)

  url <- paste0(.get_cumulocity_base_url(),
    "/measurement/measurements",
    collapse = ""
  )


  df_list <- list()
  df_list_counter <- 1


  if (parse == FALSE) { # do not parse result


    for (cur_page in c(start_page:pages_per_query)) {

      # query <- list(source = device_id, pageSize = page_size, currentPage = cur_page)
      query <- list(
        source = device_id, pageSize = page_size,
        currentPage = cur_page, dateFrom = date_from,
        dateTo = date_to
      )

      response <- .get_with_query(url, query)

      cont <- .get_content_from_response(response, cur_page)

      df_list[[df_list_counter]] <- cont
      df_list_counter <- df_list_counter + 1
    }

    return(df_list)
  } else { # parse result

    for (cur_page in c(start_page:pages_per_query)) {

      # query <- list(source = device_id, pageSize = page_size, currentPage = cur_page)

      query <- list(
        source = device_id, pageSize = page_size,
        currentPage = cur_page, dateFrom = date_from,
        dateTo = date_to
      )

      response <- .get_with_query(url, query)

      meas <- .get_measurements_from_response(response, cur_page)

      if (length(meas) > 0) { # Only add if meas is not an empty list.
        # Flatten to avoid error when stacking nested data frames.
        df_list[[df_list_counter]] <- jsonlite::flatten(meas)
        df_list_counter <- df_list_counter + 1
      }
    }

    measurements <- do.call("rbind", df_list)


    if (drop_fields) {
      measurements <- measurements[, -which(names(measurements) %in% c("self", "source.self", "source.id"))]
    }

    if (parse_datetime) {
      measurements$time <- .parse_datetime(measurements$time)
    }

    return(measurements)
  }
}
