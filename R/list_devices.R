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

#' List available devices or group of devices for a tenant.
#'
#'
#' @param page_size The page size.
#' @param abridged If TRUE, exclude several fields from the result.
#'
#' @return A \code{data.frame} with measurements.
#'
#' @details
#' List available devices or group of devices for a tenant.
#'
#' Note that some columns in the returned data frame contain data frames themselves.
#' For example, \code{c8y_Availability} is a \code{data.frame} of 2 variables.
#'
#' When \code{abridged = TRUE}, the following fields are excluded from
#' the returned data frame: \code{additionParents, childDevices, childAssets,
#' childAdditions, assetParents, deviceParents, self}.
#'
#' @author Dmitriy Bolotov
#'
#' @references
#' \href{https://cumulocity.com/guides/reference/inventory/}{Cumulocity Inventory API}
#'
#'
#' @examples
#' \dontrun{
#' list_devices()
#' }
#'
#' @import httr
#' @import jsonlite
#' @export
list_devices <- function(page_size = NULL, abridged = TRUE) {

  response <- .get_devices(page_size)

  cont <- httr::content(response, "text")
  cont_parsed <- jsonlite::fromJSON(cont)

  .check_response_for_error(response, cont_parsed)

  managed_objects <- cont_parsed$managedObjects

  if (abridged) {
    exclude_list <- c("additionParents", "childDevices", "childAssets", "childAdditions",
                      "assetParents", "deviceParents", "self")
    managed_objects <- managed_objects[, -which(names(managed_objects) %in% exclude_list)]
  }

  return(managed_objects)
}
