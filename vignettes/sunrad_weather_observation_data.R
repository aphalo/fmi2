## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----installs, eval=FALSE-----------------------------------------------------
#  install.packages(c("DT", "ggplot2", "leaflet", "remotes", "sf", "tidyverse"))
#  
#  remotes::install_github("ropengov/fmi2")
#  remotes::install_github("ropensci/skimr")

## ----load-libraries, message=FALSE, warning=FALSE-----------------------------
library(fmi2)
library(ggplot2)
library(leaflet)
library(sf)
library(skimr)

## ----show-stations------------------------------------------------------------
station_data <- fmi2::fmi_stations() 

station_data

## ----find-by-partial-name-match-----------------------------------------------
station_data %>% 
  dplyr::filter(grepl("Helsinki", Name) & grepl("Precipitation", Groups))

## ----find-has-WMO-------------------------------------------------------------
station_data %>% 
  dplyr::filter(!is.na(WMO))

## ----find-longest-------------------------------------------------------------
station_data %>% 
  dplyr::arrange(Started) %>% 
  dplyr::slice(1)

## ----arrange-N2S--------------------------------------------------------------
station_data %>% 
  dplyr::arrange(-Lat)

## ----find-by-elevation--------------------------------------------------------
station_data %>% 
  dplyr::arrange(-Elevation) %>% 
  dplyr::slice(1:3)

## ----find-by-lat-range--------------------------------------------------------
station_data %>% 
  dplyr::filter(dplyr::between(Lat, 60, 60.1))

## ----plot-hanko-map-----------------------------------------------------------
# Get data for Tulliniemi only
tulliniemi_station <- station_data %>% 
  dplyr::filter(FMISID == 100946)

# Plot on a map using leaflet
leaflet::leaflet(station_data) %>% 
  leaflet::setView(lng = tulliniemi_station$Lon, 
                   lat = tulliniemi_station$Lat, 
                   zoom = 11) %>% 
  leaflet::addTiles() %>%  
  leaflet::addMarkers(~Lon, ~Lat, popup = ~Name, label = ~as.character(FMISID))

## ----getting-data-------------------------------------------------------------
# Use Hanko Tulliniemi weather station FMISID
tulliniemi_data <- obs_weather_daily(starttime = "2019-01-01",
                                     endtime = "2019-06-30",
                                     fmisid = 100946)

## ----sf-class-----------------------------------------------------------------
class(tulliniemi_data)

## -----------------------------------------------------------------------------
unique(tulliniemi_data$variable)

## ----describe-variables-------------------------------------------------------
fmi2::describe_variables(tulliniemi_data$variable)

## ----spread-data--------------------------------------------------------------
wide_data <- tulliniemi_data %>% 
  tidyr::spread(variable, value) %>% 
  # Let's convert the sf object into a regular tibble
  sf::st_set_geometry(NULL) %>%
  tibble::as_tibble()

class(wide_data)
wide_data

## ----skim-data, results='asis'------------------------------------------------
knitr::kable(skimr::skim(wide_data))

## ----multiple stations, warning=FALSE-----------------------------------------
oulu_data <- obs_weather_daily(starttime = "2019-01-01",
                               endtime = "2019-06-30",
                               place = "Oulu")
nuorgam_data <- obs_weather_daily(starttime = "2019-01-01",
                                  endtime = "2019-06-30",
                                  place = "Nuorgam")
# Add location name to each data set and combine them
oulu_data$location <- "Oulu"
nuorgam_data$location <- "Nuorgam"
tulliniemi_data$location <- "Hanko"

all_data <- rbind(tulliniemi_data, oulu_data, nuorgam_data)
# Factorize location and make order explicit
all_data <- all_data %>% 
  dplyr::mutate(location = factor(location, 
                                  levels = c("Nuorgam", "Oulu", "Hanko"),
                                  ordered = TRUE))

## ----plot-data----------------------------------------------------------------
all_data %>% 
  dplyr::filter(variable %in% c("tday", "tmax", "tmin")) %>% 
  ggplot(aes(x = time, y = value, color = variable)) + 
  geom_line() + 
  scale_color_manual(name = "",
                     values = c(tmax = "red", tday = "black", tmin = "blue"),
                     breaks = c("tmax", "tday", "tmin"),
                     labels = c(tmax = expression(t[max]), 
                                tday = expression(t[mean]), 
                                tmin = expression(t[min]))) +
  facet_wrap(~ location, ncol=1) + 
  ylab("Temperature, daily (C)\n") +
  xlab("\nDate") + theme_minimal()

## ----hourly-data--------------------------------------------------------------
# Get the hourly observations for the first day of February 2019 in Hanko Tulliniemi
tulliniemi_data <- fmi2::obs_weather_hourly(starttime = "2019-02-01",
                                            endtime = "2019-02-02",
                                            fmisid = 100946)

## ----descrive-variables-2-----------------------------------------------------
fmi2::describe_variables(tulliniemi_data$variable)

## ----getting-sun-data---------------------------------------------------------
# Use Kumpula station FMISID
kumpula_sun_data <- obs_sunrad_minute(starttime = "2019-01-01",
                                     endtime = "2019-01-02",
                                     fmisid = 101004)

## ----sf-class-kumpula---------------------------------------------------------
class(kumpula_sun_data)

## -----------------------------------------------------------------------------
unique(kumpula_sun_data$variable)

