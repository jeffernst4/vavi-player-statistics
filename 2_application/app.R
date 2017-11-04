
# Setup -----

# Clear workspace
rm(list=ls())

# Load libraries
library(rvest)
library(dplyr)
library(stringr)

# Load scripts
source("1_scripts/leagues.R")

leagues <- createLeagues("COMPLETED")
leagues <- bind_rows(leagues, createLeagues("LIVE"))

