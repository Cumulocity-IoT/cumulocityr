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
#'
#' @return R object listing available devices.
#'
#' @details
#' List available devices or group of devices for a tenant.
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
#' list_devices()
#' }
#'
#' @import httr
#' @import jsonlite
#' @export
list_devices <- function(page_size = NULL) {

  response <- .get_devices(page_size)

  cont <- httr::content(response, "text")
  cont_parsed <- jsonlite::fromJSON(cont)

  .check_response_for_error(response, cont_parsed)

  return(cont_parsed$managedObjects)
}
