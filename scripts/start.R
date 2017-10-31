
# Setup -----

# Load libraries
library(rvest)


# Read html
leagues <- read_html("http://govavi.leagueapps.com/leagues/soccer?state=COMPLETED&locationId=&seasonId=&days=&levelId=")

leagues %>%
  html_nodes(xpath = '//*[@id="content"]/div/div/div[3]/div[3]') %>%
  html_nodes("li") %>%
  html_attr("id")

leagues %>%
  html_nodes(xpath = '//*[@id="baseevent-99577"]/div[1]/div/h2') %>%
  html_nodes("a") %>%
  html_attr("href")

leagues %>%
  html_nodes(xpath = '//*[@id="baseevent-99577"]/div[1]/div/h2') %>%
  html_nodes("a") %>%
  html_text()



html_nodes(xpath = '//*[@id="a"]') %>%
  html_attr("value")

leagues %>%
  html_nodes("a") %>%
  html_attr("href")

# Identify number of dogs in database
dogcount <- dogs %>%
  html_nodes(xpath = "//*[@id='dogsearch']/p[2]/strong") %>%
  html_text() %>%
  as.numeric()

# Retreive Dog ID's
dog_id <- NULL
for (i in 1:dogcount) {
  dog_id[i] <-
    dogs %>%
    html_nodes(xpath = paste("//*[@id='dogsearch']/div[", i, "]/div/div[1]/div/ul/li[2]/a", sep = "")) %>%
    html_text() %>%
    str_sub(start = -4) %>%
    as.numeric()
}

# Create Dog Data Frame
dog_df <- data.frame(ID = dog_id)
for (i in 1:10) {
  dog_df[, i + 1] <- NA
}

# Retreive Dog Stats
for (i in 1:length(dog_id)) {
  dog <- read_html(paste("http://www.labsandmore.org/dog/?animalidnumber=", dog_id[i], sep = ""))
  breed <-
    dog %>%
    html_nodes(xpath = "//*[@id='details']/table") %>%
    html_table()
  breed <- t(breed[[1]])
  dog_df[dog_df$ID == dog_id[i], 2:11] <- breed[2, -11]
}
