## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(fmi2)
library(dplyr)
library(sf)
library(lubridate)
library(ggplot2)
library(ggpmisc)

## -----------------------------------------------------------------------------
# ID code of the station from where we fetch data
stn_fmisid <- 101004 # Kumpula, change as needed
starttime.char <- "2022-12-31 22:00" # UTC midnight in Finland

## -----------------------------------------------------------------------------
if (!file.exists("fmi-weather-data-wide.Rda")) {
  # Used only once or when replacing all data
  starttime <- ymd_hm(starttime.char, tz = "UTC")
  wide_weather_data <- data.frame()
} else {
  load("fmi-weather-data-wide.Rda")
  # we start 59 min after end of previously downloaded data
  starttime <-force_tz(max(wide_weather_data$time), tzone = "UTC") + minutes(59)
}

endtime <- trunc(now(), units = "mins")

## -----------------------------------------------------------------------------
  # we read the new data to a new dataframe
  # (to avoid appending repeatedly to a long one)
  new_wide_data <- data.frame()
  while (starttime < endtime) {
    sliceendtime <- starttime + days(28) # keep query size at max of 4 weeks
    if (sliceendtime > endtime) {
      sliceendtime <- endtime
    }
    kumpula_data <- obs_weather_hourly(starttime = as.character(starttime),
                                       endtime = as.character(sliceendtime),
                                       fmisid = stn_fmisid)

    slice_data <- kumpula_data %>%
      tidyr::spread(variable, value) %>%
      # convert the sf object into a regular tibble
      sf::st_set_geometry(NULL)

    new_wide_data <- rbind(new_wide_data, slice_data)
    starttime <- sliceendtime + minutes(1)
    cat(".")
  }

  range(new_wide_data$time) # freshly read

  wide_weather_data <- rbind(wide_weather_data, new_wide_data)
  range(wide_weather_data$time) # all data to be saved
  colnames(wide_weather_data)

  save(wide_weather_data, file = "fmi-weather-data-wide.Rda")

## -----------------------------------------------------------------------------
fmi2::describe_variables(colnames(wide_weather_data)[-1])

## -----------------------------------------------------------------------------
ggplot(wide_weather_data, aes(with_tz(time, tzone = "EET"), TA_PT1H_AVG)) +
  geom_line()

## -----------------------------------------------------------------------------
if (!file.exists("fmi-sun-data-wide.Rda")) {
  # Used only once or when replacing all data
  starttime.char <- "2023-01-15 22:00"  # UTC at midnight in Finland
  starttime <- ymd_hm(starttime.char)
  wide_sun_data <- data.frame()
} else {
  load("fmi-sun-data-wide.Rda")
  # we start 1 h after end of previously downloaded data
  starttime <- max(wide_sun_data$time) + minutes(1) + hours(2) # convert to UTC + 2h
}

endtime <- trunc(now(), units = "mins")

## -----------------------------------------------------------------------------
# we read the new data to a new dataframe
# (to avoid appending repeatedly to a long one)
new_wide_data <- data.frame()
while (starttime < endtime) {
  sliceendtime <- starttime + days(7) # keep query size at max of 1 week
  if (sliceendtime > endtime) {
    sliceendtime <- endtime
  }
  kumpula_data <- obs_radiation_minute(starttime = as.character(starttime),
                                       endtime = as.character(sliceendtime),
                                       fmisid = 101004)
  
  slice_data <- kumpula_data %>%
    tidyr::spread(variable, value) %>%
    # convert the sf object into a regular tibble
    sf::st_set_geometry(NULL)

  new_wide_data <- rbind(new_wide_data, slice_data)
  starttime <- sliceendtime + minutes(1)
  cat(".")
}

range(new_wide_data$time)

wide_sun_data <- rbind(wide_sun_data, new_wide_data)
range(wide_sun_data$time)
colnames(wide_sun_data)

save(wide_sun_data, file = "fmi-sun-data-wide.Rda")

## -----------------------------------------------------------------------------
fmi2::describe_variables(colnames(wide_sun_data)[-1])

## -----------------------------------------------------------------------------
ggplot(wide_sun_data, aes(with_tz(time, tzone = "EET"), GLOB_1MIN)) +
  geom_line()

