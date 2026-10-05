
set.seed(123)
n <- 200

TravelStyle <- sample(c("Beach", "Adventure", "Cultural", "Mountains"), n, replace = TRUE)
Season <- sample(c("Summer", "Winter", "Monsoon", "Spring"), n, replace = TRUE)
Companions <- sample(c("Solo", "Family", "Friends", "Couple"), n, replace = TRUE)
Mood <- sample(c("Relaxed", "Excited", "Happy", "Adventurous"), n, replace = TRUE)
PastDestination <- sample(c("Goa", "Manali", "Kerala", "Rajasthan", "Ooty"), n, replace = TRUE)
Rating <- sample(1:5, n, replace = TRUE)
Age <- sample(18:60, n, replace = TRUE)
Budget <- sample(10000:50000, n, replace = TRUE)
UserID <- 1:n

destination_pool <- list(
  Beach = c("Goa", "Maldives", "Bali", "Andaman"),
  Adventure = c("Manali", "Ladakh", "Rishikesh", "Spiti"),
  Cultural = c("Jaipur", "Varanasi", "Hampi", "Madurai"),
  Mountains = c("Ooty", "Munnar", "Darjeeling", "Shimla")
)

climate_pool <- c(Beach = "Tropical", Adventure = "Cold", Cultural = "Hot", Mountains = "Moderate")
base_cost <- c(Beach = 15000, Adventure = 20000, Cultural = 12000, Mountains = 18000)

Destination <- sapply(TravelStyle, function(x) sample(destination_pool[[x]], 1))
Climate <- climate_pool[TravelStyle]
Cost <- sapply(TravelStyle, function(x) base_cost[x] + sample(-4000:4000, 1))

travel_data <- data.frame(
  UserID, Age, Budget, TravelStyle, Season, Companions,
  PastDestination, Rating, Destination, Cost, Climate,
  stringsAsFactors = FALSE
)

head(travel_data)
str(travel_data)

write.csv(travel_data, "travel_data.csv", row.names = FALSE)