#' @title Sun radiation observations
#' @description Sun radiation observations from selected weather stations.
#'
#' @details Default set contains
#' At least one location parameter (geoid/place/fmisid/wmo/bbox)
#' has to be given.
#'
#' The FMI WFS stored query used by this function is
#' `fmi::observations::radiation::daily::simple`. For more informations, see the
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
#' `list_parameters("fmi::observations::radiation::daily::simple")`.
#'
#' @return sf object in a long (melted) form. Observation variables names are
#' given in `variable` column. Following variables are returned:
#'   \describe{
#'     \item{DIFF_1MIN}{Diffuse radiation}
#'     \item{DIR_1MIN}{Direct radiation}
#'     \item{GLOB_1MIN}{Global radiation}
#'     \item{REFL_1MIN}{Reflected radiation}
#'     \item{LWIN_1MIN}{Long wave solar radiation}
#'     \item{LWOUT_1MIN}{Long wave outgoing solar radiation}
#'     \item{NET_1MIN}{Radiation balance}
#'     \item{SUND_1MIN}{Sunshine duration}
#'     \item{UVB_U}{Ultraviolet irradiance}
#'   }
#'
#' @export
#'
#' @seealso https://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services,
#' @seealso \link[fmi2]{list_parameters}
#'
obs_sunrad_minute <- function(starttime, endtime, fmisid = NULL, place = NULL) {
  fmi_obs_simple("fmi::observations::radiation::simple",
                 starttime = starttime,
                 endtime = endtime,
                 fmisid = fmisid,
                 place = place)
}

