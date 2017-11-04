player_stats <- merge(players, teams, by = c("TeamId", "LeagueId"), all.x = TRUE)

player_stats_agg <- aggregate(cbind(GP, W, L, T, PS, PSA) ~ PlayerId, player_stats, sum)


### teams needs to be merged from leagues
### player real names needs to be part of players.R UPDATE script, should be done manually for now


### ideas for visualization/app:
##### player spotlight - league genders, number of players, games played, win %, games won, lost, average goals scored, average against