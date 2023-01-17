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
library(DT)
library(fmi2)
library(ggplot2)
library(knitr)
library(leaflet)
library(sf)
library(skimr)

## ----show-stations------------------------------------------------------------
station_data <- fmi2::fmi_stations() 

station_data %>% 
  DT::datatable()


## ----plot-hanko-map-----------------------------------------------------------
# Get data for Tulliniemi only
tulliniemi_station <- station_data %>% 
  dplyr::filter(fmisid == 100946)

# Plot on a map using leaflet
leaflet::leaflet(station_data) %>% 
  leaflet::setView(lng = tulliniemi_station$lon, 
                   lat = tulliniemi_station$lat, 
                   zoom = 11) %>% 
  leaflet::addTiles() %>%  
  leaflet::addMarkers(~lon, ~lat, popup = ~name, label = ~as.character(fmisid))

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
var_descriptions <- fmi2::describe_variables(tulliniemi_data$variable)
var_descriptions %>% 
  DT::datatable()

## ----spread-data--------------------------------------------------------------
wide_data <- tulliniemi_data %>% 
  tidyr::spread(variable, value) %>% 
  # Let's convert the sf object into a regular tibble
  sf::st_set_geometry(NULL)

wide_data %>% 
  DT::datatable()

## ----skim-data, results='asis'------------------------------------------------
(skimr::skim(wide_data))

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
  dplyr::filter(variable == "tday" | variable == "tmax" | variable == "tmin") %>% 
  ggplot(aes(x = time, y = value, color = variable)) + 
  geom_line() + facet_wrap(~ location, ncol=1) + ylab("Temperature (C)\n") +
  xlab("\nDate") + theme_minimal()


## ----hourly-data--------------------------------------------------------------
# Get the hourly observations for the first day of 2019 in Hanko Tulliniemi
tulliniemi_data <- fmi2::obs_weather_hourly(starttime = "2019-02-01",
                                            endtime = "2019-02-02",
                                            fmisid = 100946)

## ----descrive-variables-2-----------------------------------------------------
var_descriptions <- fmi2::describe_variables(tulliniemi_data$variable)
var_descriptions %>% 
  DT::datatable()

