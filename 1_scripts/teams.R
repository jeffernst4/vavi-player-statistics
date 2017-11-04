
# Setup -----

# Load libraries
library(rvest)
library(dplyr)


# IDK WHAT TO CALL THIS -----

teamsDF <- data.frame(
  Name = as.character(),
  GP = as.numeric(),
  W = as.numeric(),
  L = as.numeric(),
  T = as.numeric(),
  PS = as.numeric(),
  PSA = as.numeric(),
  DNP = as.numeric(),
  PF = as.numeric(),
  TeamId = as.character(),
  LeagueId = as.character(),
  stringsAsFactors = FALSE
)

for (i in 1:length(leaguesDF$LeagueId)) {
  # Read leagues html page
  teamHTML <-
    read_html(paste(
      "http://govavi.leagueapps.com/leagues/",
      leaguesDF$LeagueId[i],
      "/standings",
      sep = ""
    ))
  
  errorText <- teamHTML %>%
    html_nodes(xpath = "//*[@id='content']/div/div/div[2]/div/p") %>%
    html_text()
  
  if (errorText == "Sorry, the standings have not yet been posted.") {
    next
  }
  
  teams <- teamHTML %>%
    html_nodes(xpath = "//*[@id='content']/div/div/div[2]/div/table") %>%
    html_table(fill = TRUE) %>%
    data.frame()
  
  teams <- teams[!(is.na(teams$GP)), ]
  
  columnsDel <- grep("NA", names(teams))
    if (length(columnsDel) > 0) {
    teams <- teams[, -grep("NA", names(teams))]
  }
  
  teamIds <- sapply(strsplit(
    teamHTML %>%
      html_nodes(xpath = "//*[@id='content']/div/div/div[2]/div/table") %>%
      html_nodes("a") %>%
      html_attr("href"),
    "/"
  ), function(x)
    tail(x, 1))
  
  teams$TeamId <- teamIds
  
  teams$LeagueId <- leaguesDF$LeagueId[i]
  
  names(teams)[names(teams) == "Team"] <- "Name"
  
  teamsDF <- bind_rows(teamsDF, teams)
  
}
