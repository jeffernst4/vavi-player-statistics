
createLeagues <- function(state) {
  
  # Read leagues html page
  leaguesHTML <-
    read_html(
      paste(
        "http://govavi.leagueapps.com/leagues/soccer?state=",
        state,
        "&locationId=&seasonId=&days=&levelId=",
        sep = ""
      )
    )
  
  # Extract league ids
  leagueIds <- leaguesHTML %>%
    html_nodes(xpath = '//*[@id="content"]/div/div/div[3]/div[3]') %>%
    html_nodes("li") %>%
    html_attr("id")
  leagueIds <- gsub("baseevent-", "", leagueIds)
  
  # Extract league names
  leagueNames <- NULL
  for (i in 1:length(leagueIds)) {
    leagueNames[i] <-
      leaguesHTML %>%
      html_nodes(xpath = paste("//*[@id='baseevent-", leagueIds[i], "']/div[1]/div/h2", sep = "")) %>%
      html_nodes("a") %>%
      html_text()
  }
  
  # Extract league dates
  leagueDates <- NULL
  for (i in 1:length(leagueIds)) {
    leagueDatesHTML <-
      leaguesHTML %>%
      html_nodes(xpath = paste(
        "//*[@id='baseevent-",
        leagueIds[i],
        "']/div[1]/div/dl/dd[2]",
        sep = ""
      ))
    if (length(leagueDatesHTML) > 0) {
      leagueDates[i] <- html_text(leagueDatesHTML)
    } else {
      leagueDates[i] <- NA
    }
  }
  leagueDates <- regmatches(leagueDates,
                            gregexpr("[0-9]{4}-[0-9]{2}-[0-9]{2}", leagueDates))
  leagueStart <-
    as.Date(sapply(leagueDates, function(x)
      ifelse(length(x) >= 1, x[[1]], NA)))
  leagueEnd <-
    as.Date(sapply(leagueDates, function(x)
      ifelse(length(x) >= 2, x[[2]], NA)))
  
  # Extract league gender and league level
  leagueGender <- NULL
  leagueLevel <- NULL
  types <- c("Co-Ed", "Male")
  levels <- c("Recreational", "Intermediate", "Competitive")
  for (i in 1:length(leagueIds)) {
    leagueTypesHTML <-
      leaguesHTML %>%
      html_nodes(xpath = paste(
        "//*[@id='baseevent-",
        leagueIds[i],
        "']/div[1]/div/p",
        sep = ""
      )) %>%
      html_text()
    leagueGender[i] <-
      str_extract(leagueTypesHTML, paste(types, collapse = "|"))
    leagueLevel[i] <-
      str_extract(leagueTypesHTML, paste(levels, collapse = "|"))
  }
  
  # Identify number of players per game
  leaguePlayers <- gsub(" ",
                        "",
                        str_extract(leagueNames, "[0-9]{1,2}\\s?v\\s?[0-9]{1,2}"))
  leaguePlayers <- as.numeric(sapply(str_split(leaguePlayers, "v"), unique))
  
  # Create data frame
  leaguesDF <-
    data.frame(
      LeagueId = leagueIds,
      Name = leagueNames,
      Start = leagueStart,
      End = leagueEnd,
      Gender = leagueGender,
      Level = leagueLevel,
      Players = leaguePlayers,
      stringsAsFactors = FALSE
    )
  
  # Remove leagues without a start date
  leaguesDF <- leaguesDF[!(is.na(leaguesDF$Start)), ]
  
  # Return leagues data frame
  return(leaguesDF)
  
}
