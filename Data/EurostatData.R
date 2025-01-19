library(eurostat)
library(dplyr)
library(sf)

# Fetch Eurostat Data for Immigration
EurostatData <- get_eurostat("migr_imm8") %>%
  filter(
    age == "TOTAL",
    sex == "T",
    agedef == "COMPLET"
  ) %>%
  mutate(TIME_PERIOD = as.Date(TIME_PERIOD))  