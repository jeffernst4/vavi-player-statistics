
# Setup -----

# Load libraries
library(rvest)


# IDK WHAT TO CALL THIS -----

# Read leagues html page
leaguesHTML <-
  read_html(
    "http://govavi.leagueapps.com/leagues/soccer?state=COMPLETED&locationId=&seasonId=&days=&levelId="
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

# Extract league links
leagueLinks <- NULL
for (i in 1:length(leagueIds)) {
  leagueLinks[i] <-
    leaguesHTML %>%
    html_nodes(xpath = paste("//*[@id='baseevent-", leagueIds[i], "']/div[1]/div/h2", sep = "")) %>%
    html_nodes("a") %>%
    html_attr("href")
}

# Extract league dates
leagueDates <- NULL
for (i in 1:length(leagueIds)) {
  leagueDates[i] <-
    leaguesHTML %>%
    html_nodes(xpath = paste("//*[@id='baseevent-", leagueIds[i], "']/div[1]/div/dl/dd[2]", sep = "")) %>%
    html_text()
}
leagueStart <- as.Date(substr(leagueDates, 10, 19))
leagueEnd <- as.Date(substr(leagueDates, 65, 74))

# Create data frame
leagues <-
  data.frame(
    Id = leagueIds,
    Name = leagueNames,
    Link = leagueLinks,
    Start = leagueStart,
    End = leagueEnd,
    stringsAsFactors = FALSE
  )



