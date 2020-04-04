## Prep.R

# Preparation for the Shiny App

library(lubridate)
library(dplyr)
library(ggplot2)

# Data preparation


# Downloaded COVID data 04/01/20, 8:30 AM EDT.

# download.file("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", "data/casedistribution.csv", mode = "wb")

cov <- read.csv("data/casedistribution.csv", stringsAsFactors = FALSE)

names(cov)[1] <- "date"
cov$date <- dmy(cov$date)
cov <- select(cov, date, cases, country = countriesAndTerritories)
saveRDS(cov, file = "cov.rds")

