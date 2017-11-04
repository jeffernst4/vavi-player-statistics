
# Setup -----

# Clear workspace
rm(list=ls())

# Load libraries
library(rvest)
library(dplyr)
library(stringr)

# Load scripts
source("1_scripts/leagues.R")
source("1_scripts/teams.R")
source("1_scripts/players.R")

leagues <- createLeagues("COMPLETED")
leagues <- bind_rows(leagues, createLeagues("LIVE"))
save(leagues, file = "3_results/leagues.RData")
teams <- createTeams(leagues)
save(teams, file = "3_results/teams.RData")
players <- createPlayers(teams)
save(players, file = "3_results/players.RData")

