# fmi2 (development version)

## CHANGES IN VERSION 0.1.1 (2019-XX-XX)

+ Remove local weather stations table (CSV). This means that FMI weather 
stations are downloaded from the FMI website once per each session. Table is no 
longer available when offline, but so are most of the data as well. 

+ Man pages revised and merged.
+ Expand vignette.
+ Refactoring of code from individual `obs` functions into `fmi_obs_simple()`.

### New features

+ `obs_sunrad_minute()`
+ `obs_weather_monthly()`
+ `obs_soil_hourly()` (No working example???!)

### Bug fixes

### Development related

+ Test coverage increased to 100%.
+ Internally, `fmi2_global$function_map` is now a tibble instead of a list. 
+ Stored query / function -mapping in README is generated automatically with
  `list_queries()`.

## CHANGES IN VERSION 0.1.0 (2019-09-09)

+ `fmi2` is here! 
