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

#' Get the devices or group of devices for a tenant.
#'
#'
#' @param page_size The page size, set to 2000 (maximum) by default.
#' @param drop_fields If TRUE, exclude several fields from the result.
#' @param parse_datetime If TRUE, parse datetime fields from char to POSIXlt.
#' @param parse If TRUE, parse the JSON object into a data frame.
#'
#' @return A \code{data.frame} with measurements.
#'
#' @details
#' Get the devices or group of devices for a tenant.
#'
#' If \code{drop_fields = TRUE}, the following fields are excluded from
#' the returned data frame: \code{additionParents, childDevices, childAssets,
#' childAdditions, assetParents, deviceParents, self}.
#'
#' If \code{parse_datetime = TRUE}, the following fields are parsed from char to
#' POSIXlt: \code{creationTime, lastUpdated, c8y_Availability.lastMessage}.
#'
#' If \code{parse} is TRUE, the JSON object is parsed using \code{jsonlite::fromJSON}
#' before being returned. The data is converted to a single flattened data frame.
#'
#' If \code{parse} is FALSE, the JSON object is returned as a JSON string.
#' The params \code{drop_fields} and \code{parse_datetime} have no effect.
#'
#'
#' @author Dmitriy Bolotov
#'
#' @references
#' \href{https://cumulocity.com/guides/reference/inventory/}{Cumulocity Inventory API}
#'
#'
#' @examples
#' \dontrun{
#' get_devices()
#' }
#'
#' @export
get_devices <- function(page_size = 2000,
                        drop_fields = TRUE,
                        parse_datetime = TRUE,
                        parse = TRUE) {
  response <- .get_devices(page_size)

  cont <- httr::content(response, "text")

  if (parse == FALSE) {
    .check_response_for_error(response)
    return(cont)
  } else {
    cont_parsed <- jsonlite::fromJSON(cont, flatten = TRUE)

    .check_response_for_error(response, cont_parsed)

    managed_objects <- cont_parsed$managedObjects

    if (drop_fields) {
      exclude_list <- c(
        "additionParents.self", "additionParents.references", "childDevices.self",
        "childDevices.references", "childAssets.self", "childAssets.references", "childAdditions.self",
        "childAdditions.references","deviceParents.self", "deviceParents.references",
        "assetParents.self", "assetParents.references", "self")

      managed_objects <- managed_objects[, -which(names(managed_objects) %in% exclude_list)]
    }

    if (parse_datetime) {
      managed_objects$creationTime <- .parse_datetime(managed_objects$creationTime)
      managed_objects$lastUpdated <- .parse_datetime(managed_objects$lastUpdated)
      managed_objects$c8y_Availability$lastMessage <- .parse_datetime(managed_objects$c8y_Availability$lastMessage)
    }

    return(managed_objects)
  }
}
