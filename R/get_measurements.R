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

#' Get the measurements for a device.
#'
#'
#' @param device_id The device id.
#' @param date_from The starting datetime.
#' @param date_to The ending datetime.
#' @param num_rows Number of rows of data to return.
#' @param parse_json If TRUE, parse the JSON object into a data frame.
#' @param parse_datetime If TRUE, parse "time" field from char to POSIXlt.
#'
#' @return A \code{data.frame} if \code{parse_json = TRUE},
#' and a character string otherwise.
#'
#' \code{date_from} and \code{date_from} are expected to be strings in the format "YYYY-MM-DDTHH:MM:SSZ".
#'
#' If \code{date_to} is null, it is set to the current time.
#'
#' If num_rows and both dates are specified, the lesser of the two ranges is returned.
#'
#' If \code{parse_json} is TRUE, the JSON object is parsed using \code{jsonlite::fromJSON}
#' before being returned. The data is converted to a single flattened data frame.
#' If a page does not contain any measurements, it does not get added to the data frame.
#'
#' If \code{parse_json} is FALSE, the JSON object is returned as a JSON string.
#' For queries with multiple pages, a list of such objects is returned. Each
#' element in this list contains up to 2000 records. The parameter \code{parse_datetime}
#' has no effect.
#'
#' @details
#' Get the measurements for a device for a time period.
#'
#' @author Dmitriy Bolotov
#'
#' @references
#' \href{https://cumulocity.com/guides/reference/measurements/}{Cumulocity Measurements API}
#'
#'
#' @examples
#' \dontrun{
#' get_measurements(device_id, date_from = "2019-09-30T20:00:00Z")
#' }
#' @export
get_measurements <- function(device_id,
                             date_from,
                             date_to = NULL,
                             num_rows = NULL,
                             parse_json = TRUE,
                             parse_datetime = TRUE) {
  .check_date(date_from)
  .check_date(date_to)

  if (is.null(date_to)) {
    date_to <- format(Sys.time(), format = "%Y-%m-%dT%H:%M:%OSZ")
  }

  if (is.null(num_rows)) {
    num_rows <- 1000000
  }

  url <- paste0(.get_cumulocity_base_url(),
    "/measurement/measurements",
    collapse = ""
  )


  df_list <- list()
  df_list_counter <- 1
  page_size <- 2000
  pages_per_query <- ceiling(num_rows / page_size)
  page_sizes <- .create_page_sizes(num_rows, pages_per_query)


  if (parse_json == FALSE) { # do not parse result

    for (cur_page in c(1:pages_per_query)) {
      query <- list(
        source = device_id, pageSize = page_sizes[cur_page],
        currentPage = cur_page, dateFrom = date_from,
        dateTo = date_to
      )

      response <- .get_with_query(url, query)

      cont <- .get_content_from_response(response, cur_page, "meas")

      if (grepl("measurements\\\":\\[]", cont)) {
        # If there are no measurements, exit the loop.
        break
      } else {
        df_list[[df_list_counter]] <- cont
        df_list_counter <- df_list_counter + 1
      }
    }

    return(df_list)
  } else { # parse result

    for (cur_page in c(1:pages_per_query)) {
      query <- list(
        source = device_id, pageSize = page_sizes[cur_page],
        currentPage = cur_page, dateFrom = date_from,
        dateTo = date_to
      )

      response <- .get_with_query(url, query)

      dat <- .get_em_from_response(response, cur_page, "meas")

      if (length(dat) > 0) {
        # Flatten to avoid error when stacking nested data frames.
        df_list[[df_list_counter]] <- jsonlite::flatten(dat)
        df_list_counter <- df_list_counter + 1
      } else {
        break
      }
    }

    the_data <- do.call("rbind", df_list)

    if (parse_datetime) {
      the_data$time <- .parse_datetime(the_data$time)
    }

    return(the_data)
  }
}
