
createTeams <- function(leagues) {
  
  # Create teams data frame
  teamsDF <- data.frame(
    TeamName = as.character(),
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
  
  # Specify valid columns
  validColumns <- names(teamsDF)
  
  # Extract team details
  for (i in 1:length(leagues$LeagueId)) {
    
    # Read league html page
    teamHTML <-
      read_html(paste(
        "http://govavi.leagueapps.com/leagues/",
        leagues$LeagueId[i],
        "/standings",
        sep = ""
      ))
    
    # Look for error text
    errorText <- teamHTML %>%
      html_nodes(xpath = "//*[@id='content']/div/div/div[2]/div/p") %>%
      html_text()
    if (errorText == "Sorry, the standings have not yet been posted.") {
      next
    }
    
    # Extract data frame of league standings
    teams <- teamHTML %>%
      html_nodes(xpath = "//*[@id='content']/div/div/div[2]/div/table") %>%
      html_table(fill = TRUE) %>%
      data.frame()
    
    # Remove rows with multiple teams
    teams <- teams[!(is.na(suppressWarnings(as.numeric(teams$GP)))), ]
    
    # Remove invalid columns
    invalidColumns <- grep("NA", names(teams))
    if (length(invalidColumns) > 0) {
      teams <- teams[, -grep("NA", names(teams))]
    }
    
    # Convert stats to numeric
    teams[, -1] <- apply(teams[, -1], 2, as.numeric)
    
    # Extract team ids
    teamIds <- sapply(strsplit(
      teamHTML %>%
        html_nodes(xpath = "//*[@id='content']/div/div/div[2]/div/table") %>%
        html_nodes("a") %>%
        html_attr("href"),
      "/"
    ), function(x)
      tail(x, 1))
    
    # Create teams data frame
    teams <-
      data.frame(
        teams,
        TeamId = teamIds,
        LeagueId = leagues$LeagueId[i],
        stringsAsFactors = FALSE
      )
    
    # Rename team column name
    names(teams)[names(teams) == "Team"] <- "TeamName"
    
    # Merge new teams with teams data frame
    teamsDF <- bind_rows(teamsDF, teams)
    
  }
  
  # Filter valid columns in teams data frame
  teamsDF <- teamsDF[, validColumns]
  
  # Return teams data frame
  return(teamsDF)
  
}


