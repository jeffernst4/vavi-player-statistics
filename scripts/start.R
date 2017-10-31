
# Setup -----

# Load libraries
library(rvest)


# IDK WHAT TO CALL THIS -----

# Read leagues html page
leagues <-
  read_html(
    "http://govavi.leagueapps.com/leagues/soccer?state=COMPLETED&locationId=&seasonId=&days=&levelId="
  )

# Extract league ids
leagueIds <- leagues %>%
  html_nodes(xpath = '//*[@id="content"]/div/div/div[3]/div[3]') %>%
  html_nodes("li") %>%
  html_attr("id")

# Extract league names
leagueNames <- NULL
for (i in 1:length(leagueIds)) {
  leagueNames[i] <-
    leagues %>%
    html_nodes(xpath = paste("//*[@id='", leagueIds[i], "']/div[1]/div/h2", sep = "")) %>%
    html_nodes("a") %>%
    html_text()
}

# Extract league links
leagueLinks <- NULL
for (i in 1:length(leagueIds)) {
  leagueLinks[i] <-
    leagues %>%
    html_nodes(xpath = paste("//*[@id='", leagueIds[i], "']/div[1]/div/h2", sep = "")) %>%
    html_nodes("a") %>%
    html_attr("href")
}

# Extract league dates
leagueDates <- NULL
for (i in 1:length(leagueIds)) {
  leagueDates[i] <-
    leagues %>%
    html_nodes(xpath = paste("//*[@id='", leagueIds[i], "']/div[1]/div/dl/dd[2]", sep = "")) %>%
    html_text()
}
leagueStart <- substr(leagueDates, 10, 19)
leagueEnd <- substr(leagueDates, 65, 74)



