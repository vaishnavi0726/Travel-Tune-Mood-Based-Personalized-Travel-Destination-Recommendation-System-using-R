# ============================================
# PHASE 4: Weighted Recommendation Scoring Engine
# ============================================

library(dplyr)

# ---- 4.1 Mood -> destination category mapping (same rules as before) ----
recommend_by_mood <- function(mood_input) {
  if (mood_input %in% c("Sad", "Stressed")) {
    return(c("Munnar", "Coorg", "Andaman", "Darjeeling", "Ooty"))
  } else if (mood_input %in% c("Happy", "Energetic")) {
    return(c("Goa", "Manali", "Ladakh", "Auli", "Bir Billing"))
  } else if (mood_input == "Relaxed") {
    return(c("Jaipur", "Mysore", "Hampi", "Varanasi", "Agra"))
  } else {
    return(unique(travel_data$Destination))  # fallback: consider everything
  }
}

# ---- 4.2 Weighted scoring function ----
calculate_match_score <- function(destination_row, mood_input, budget_input, season_input) {
  
  # Mood Match (35%) -- 1 if destination is in the mood's recommended list, else partial credit
  mood_candidates <- recommend_by_mood(mood_input)
  mood_score <- ifelse(destination_row$Destination %in% mood_candidates, 1, 0.3)
  
  # Budget Fit (25%) -- closer cost is to budget (without exceeding), higher the score
  if (destination_row$Cost > budget_input) {
    budget_score <- 0.2  # over budget, heavily penalized but not zero
  } else {
    budget_score <- 1 - (budget_input - destination_row$Cost) / budget_input
  }
  budget_score <- max(0, min(1, budget_score))
  
  # Season Match (20%)
  season_score <- ifelse(destination_row$Season == season_input, 1, 0.4)
  
  # Rating (20%) -- normalize 1-5 scale to 0-1
  rating_score <- destination_row$Rating / 5
  
  # Weighted total
  total_score <- (mood_score * 0.35) + (budget_score * 0.25) +
    (season_score * 0.20) + (rating_score * 0.20)
  
  return(round(total_score * 100, 1))  # as a percentage match
}

# ---- 4.3 Final recommendation function (Top 3 with score + reason) ----
get_recommendations <- function(mood_input, budget_input, season_input) {
  
  scored_data <- travel_data %>%
    rowwise() %>%
    mutate(MatchScore = calculate_match_score(
      pick(everything()), mood_input, budget_input, season_input
    )) %>%
    ungroup()
  
  result <- scored_data %>%
    group_by(Destination) %>%
    summarise(
      AvgCost   = round(mean(Cost)),
      AvgRating = round(mean(Rating), 1),
      MatchScore = round(mean(MatchScore), 1),
      .groups = "drop"
    ) %>%
    arrange(desc(MatchScore)) %>%
    head(3)
  
  result$Reason <- paste0(
    result$MatchScore, "% match for '", mood_input,
    "' mood, ", season_input, " season, within ~₹", budget_input, " budget"
  )
  
  return(result)
}

# ---- 4.4 Demo runs ----
get_recommendations("Stressed", 20000, "Winter")
get_recommendations("Happy", 30000, "Summer")
get_recommendations("Relaxed", 15000, "Monsoon")