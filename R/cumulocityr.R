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

#' R client for the Cumulocity API
#'
#' This package contains functions to interact with the Cumulocity API.
#'
#' @section Functions:
#' \itemize{
#' \item \code{\link{get_devices}} returns available devices for a tenant.
#' \item \code{\link{get_measurements}} returns measurements for a device.
#' }
#'
#' @section Authentication:
#'
#' Environment variables used for authentication are stored in a local .Renviron file:
#' \itemize{
#' \item \env{CUMULOCITY_base_url = "[tenant url]"}\cr
#' \item \env{CUMULOCITY_usr = "[username]"}\cr
#' \item \env{CUMULOCITY_pwd = "[password]"}\cr
#' \item \env{CUMULOCITY_device_id = "[an example device id]"}
#' }
#'
#' The tenant url should be of the form \code{"https://tenant_name.cumulocity.com"}.
#'
#' @section Other considerations:
#'
#' There is a limit of 2000 on \code{pageSize} for each call.
#'
#' @section References:
#' \itemize{
#' \item \href{https://cumulocity.com/guides/reference/inventory/}{Cumulocity Inventory API}
#' \item \href{https://cumulocity.com/guides/reference/events/}{Cumulocity Events API}
#' \item \href{https://cumulocity.com/guides/reference/measurements/}{Cumulocity Measurements API}
#' }
#'
#' @docType package
#' @aliases cumulocityr-package
#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
