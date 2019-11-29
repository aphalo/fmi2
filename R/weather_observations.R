#' @title Weather observations
#' @description Daily weather observations from weather stations.
#'
#' @details Default set contains daily precipitation rate, mean temperature,
#' snow depth,
#' and minimum and maximum temperature. By default, the data is returned from
#' last 744 hours. At least one location parameter (geoid/place/fmisid/wmo/bbox)
#' has to be given.
#'
#' The FMI WFS stored query used by this function is
#' `fmi::observations::weather::daily::simple`. For more informations, see the
#' \href{https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services}{FMI documentation page}.
#'
#' @param starttime character or Date start of the time interval in ISO-format.
#'                  character will be coerced into a Date object.
#' @param endtime character or Date end of the time interval in ISO-format.
#'                character will be coerced into a Date object.
# @param timestep numeric the time step of data in minutes.
# @param parameters character vector of parameters to return (see below).
# @param crs character coordinate projection to use in results.
# @param bbox numeric vector (EXAMPLE) bounding box of area for which to return
#'        data.
#' @param place character location name for which to provide data.
#' @param fmisid numeric FMI observation station identifier
#'        (see \link[fmi2]{fmi_stations}.
# @param	maxlocations numeric maximum amount of locations.
# @param geoid numeric geoid of the location for which to return data.
# @param wmo numeric WMO code of the location for which to return data.
#'
#' @note For a complete description of the accepted arguments, see
#' `list_parameters("fmi::observations::weather::daily::simple")`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{rrday}{Precipitation amount}
#'     \item{snow}{Snow depth}
#'     \item{tday}{Average air temperature}
#'     \item{tmin}{Minimum air temperature}
#'     \item{tmax}{Maximum air temperature}
#'     \item{TG_PT12H_min}{Ground minimum temperature}
#'   }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_weather_daily <- function(starttime, endtime, fmisid = NULL, place = NULL) {
  fmi_obs_simple("fmi::observations::weather::daily::simple",
                 starttime = starttime,
                 endtime = endtime,
                 fmisid = fmisid,
                 place = place)
}

#' @rdname obs_weather_daily
#' @export
#'
obs_weather_hourly <- function(starttime, endtime, fmisid = NULL, place = NULL) {
  fmi_obs_simple("fmi::observations::weather::hourly::simple",
                 starttime = starttime,
                 endtime = endtime,
                 fmisid = fmisid,
                 place = place)
}

#' @rdname obs_weather_daily
#' @export
#'
obs_weather_monthly <- function(starttime, endtime, fmisid = NULL, place = NULL) {
  fmi_obs_simple("fmi::observations::weather::monthly::simple",
                 starttime = starttime,
                 endtime = endtime,
                 fmisid = fmisid,
                 place = place)
}
