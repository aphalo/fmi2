#' @title Any observations
#' @description Any observations from weather stations. Code common to all
#'   queries factored out to this fucntion.
#'
#' @details At least one location parameter (geoid/place/fmisid/wmo/bbox)
#' has to be given.
#'
#' The FMI WFS stored query used by this function is passed as an argument.
#' For more informations, see the
#' \href{https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services}{FMI documentation page}.
#'
#' @param storedquery_id character One of the strored query ids.
#' @param starttime character or Date start of the time interval in ISO-format.
#'                  character will be coerced into a Date object.
#' @param endtime character or Date end of the time interval in ISO-format.
#'                character will be coerced into a Date object.
# @param timestep numeric the time step of data in minutes.
# @param parameters character vector of parameters to return (see below).
# @param crs character coordinate projection to use in results.
# @param bbox numeric vector (EXAMPLE) bounding box of area for which to return
#        data.
#' @param place character location name for which to provide data.
#' @param fmisid numeric FMI observation station identifier
#'        (see \link[fmi2]{fmi_stations}.
#' @param ... Other named parameters.
# @param	maxlocations numeric maximum amount of locations.
# @param geoid numeric geoid of the location for which to return data.
# @param wmo numeric WMO code of the location for which to return data.
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters(<stored query id>)`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Variables returned depends on query.
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
fmi_obs_simple <- function(storedquery_id,
                           starttime,
                           endtime,
                           fmisid = NULL,
                           place = NULL,
                           ...) {
  # At least one location argument must be provided
  if (is.null(fmisid) & is.null(place)) {
    stop("No location argument provided", call. = FALSE)
  }

  # start and end time must be Dates or characters coercable to Dates, and must
  # be in the past

  fmi_obj <- fmi_api(request = "getFeature",
                     storedquery_id = storedquery_id,
                     starttime = starttime, endtime = endtime, fmisid = fmisid,
                     place = place,
                     ...)
  to_sf(fmi_obj) %>%
    dplyr::select(time = dplyr::matches("^[Tt]ime$"),
                  variable = .data$ParameterName,
                  value = .data$ParameterValue) %>%
                  # decodes times and dates
    dplyr::mutate(time = lubridate::parse_date_time(.data$time,
                                                    c("Ymd HMS", "Ymd")),
                  variable = as.character(.data$variable),
                  # Factor needs to be coerced into character first
                  value = as.numeric(as.character(.data$value))) %>%
                  # Convert NaN -> NA
    dplyr::mutate(value = ifelse(is.nan(.data$value), NA, .data$value))
}
