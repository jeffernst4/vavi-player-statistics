
# Setup -----

# Load libraries
library(rvest)
library(dplyr)


# IDK WHAT TO CALL THIS -----

playersDF <- data.frame(
  LeagueId = as.character(),
  TeamId = as.character(),
  PlayerId = as.character(),
  stringsAsFactors = FALSE
)

for (i in 1:length(teamsDF$TeamId)) {
  # Read leagues html page
  rosterHTML <-
    read_html(paste(
      "http://govavi.leagueapps.com/leagues/",
      teamsDF$LeagueId[i],
      "/teamRoster?teamId=",
      teamsDF$TeamId[i],
      sep = ""
    ))
  
  playerIds <- sapply(
    strsplit(
      rosterHTML %>%
        html_nodes(xpath = "//*[@id='teammates-container']/ul") %>%
        html_nodes(xpath = "//*[@class='thumb']") %>%
        html_nodes("a") %>%
        html_attr("href"),
      "/"
    ), function(x)
      tail(x, 1))
  
  teamId <- teamsDF$TeamId[i]
  
  leagueId <- teamsDF$LeagueId[i]
  
  players <- data.frame(
    leagueId,
    teamId,
    playerIds
  )
  
  playersDF <- bind_rows(playersDF, players)
  
}