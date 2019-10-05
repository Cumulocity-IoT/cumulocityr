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

#' Get the events for a device.
#'
#'
#' @inheritParams get_measurements
#'
#' @return A \code{data.frame} with events.
#'
#'
#' If \code{parse_json} is TRUE, the JSON object is parsed using \code{jsonlite::fromJSON}
#' before being returned. The data is converted to a single flattened data frame.
#' If a page does not contain any events, it does not get added to the data frame.
#'
#' If \code{parse_json} is FALSE, the JSON object is returned as a JSON string. For queries with multiple pages, a
#' list of such objects is returned. All pages are added to the list, even if there are no events.
#' The parameter \code{parse_datetime} has no effect.
#'
#'
#'
#' @details
#' Get the events for a device for a time period.
#'
#' The parameter \code{page_size} is only used if \code{date_from}
#' or \code{date_to} are NULL, or both are NULL.
#'
#'
#' @author Dmitriy Bolotov
#'
#' @references
#' \href{https://cumulocity.com/guides/reference/events/}{Cumulocity Events API}
#'
#'
#' @examples
#' \dontrun{
#' get_events(device_id)
#' }
#' @export
get_events <- function(device_id,
                       date_from = NULL,
                       date_to = NULL,
                       page_size = 2000,
                       pages_per_query = 1,
                       start_page = 1,
                       parse_datetime = TRUE,
                       parse_json = TRUE) {
  .check_date(date_from)
  .check_date(date_to)

  url <- paste0(.get_cumulocity_base_url(),
    "/event/events",
    collapse = ""
  )


  df_list <- list()
  df_list_counter <- 1


  if (parse_json == FALSE) { # do not parse result


    for (cur_page in c(start_page:pages_per_query)) {
      query <- list(
        source = device_id, pageSize = page_size,
        currentPage = cur_page, dateFrom = date_from,
        dateTo = date_to
      )

      response <- .get_with_query(url, query)

      cont <- .get_content_from_response(response, cur_page, "event")

      df_list[[df_list_counter]] <- cont
      df_list_counter <- df_list_counter + 1
    }

    return(df_list)
  } else { # parse result

    for (cur_page in c(start_page:pages_per_query)) {
      query <- list(
        source = device_id, pageSize = page_size,
        currentPage = cur_page, dateFrom = date_from,
        dateTo = date_to
      )

      response <- .get_with_query(url, query)

      dat <- .get_em_from_response(response, cur_page, "event")

      if (length(dat) > 0) { # Only add if dat is not an empty list.
        # Flatten to avoid error when stacking nested data frames.
        df_list[[df_list_counter]] <- jsonlite::flatten(dat)
        df_list_counter <- df_list_counter + 1
      }
    }

    the_data <- do.call("rbind", df_list)

    if (parse_datetime) {
      the_data$time <- .parse_datetime(the_data$time)
      the_data$creationTime <- .parse_datetime(the_data$creationTime)
    }

    return(the_data)
  }
}
