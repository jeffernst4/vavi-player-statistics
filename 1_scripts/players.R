
createPlayers <- function(teams) {
  
  # Create players data frame
  playersDF <- data.frame(
    LeagueId = as.character(),
    TeamId = as.character(),
    PlayerId = as.character(),
    stringsAsFactors = FALSE
  )
  
  # Extract team details
  for (i in 1:length(teams$TeamId)) {
    
    # Read players html page
    rosterHTML <-
      read_html(
        paste(
          "http://govavi.leagueapps.com/leagues/",
          teams$LeagueId[i],
          "/teamRoster?teamId=",
          teams$TeamId[i],
          sep = ""
        )
      )
    
    # Extract player ids
    playerIds <- sapply(strsplit(
      rosterHTML %>%
        html_nodes(xpath = "//*[@id='teammates-container']/ul") %>%
        html_nodes(xpath = "//*[@class='thumb']") %>%
        html_nodes("a") %>%
        html_attr("href"),
      "/"
    ), function(x)
      tail(x, 1))
    
    # Create players data frame
    players <- data.frame(
      LeagueId = teams$LeagueId[i],
      TeamId = teams$TeamId[i],
      PlayerId = playerIds,
      stringsAsFactors = FALSE
    )
    
    # Merge new players with players data frame
    playersDF <- bind_rows(playersDF, players)
    
  }
  
  # Return teams data frame
  return(playersDF)
  
}