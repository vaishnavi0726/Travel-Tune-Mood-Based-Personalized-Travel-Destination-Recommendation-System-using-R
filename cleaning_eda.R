# ============================================
# PHASE 2: Cleaning + EDA - FIXED CODE
# ============================================

library(dplyr)
library(ggplot2)

# ---- 2.1 Cleaning ----
travel_data <- travel_data %>%
  distinct() %>%
  mutate(
    Mood        = as.factor(Mood),
    TravelStyle = as.factor(TravelStyle),
    Season      = as.factor(Season),
    Companions  = as.factor(Companions),
    Climate     = as.factor(Climate),
    Cost        = abs(Cost)
  ) %>%
  filter(!is.na(Budget), !is.na(Cost), Age >= 18)

summary(travel_data)

# ---- 2.2 Bar Chart: Popular Destinations by Mood ----
ggplot(travel_data, aes(x = Destination, fill = Mood)) +
  geom_bar(position = "dodge") +
  labs(title = "Popular Destinations by Mood",
       x = "Destination", y = "Number of Users") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))

# ---- 2.3 Boxplot: Budget vs Mood ----
ggplot(travel_data, aes(x = Mood, y = Budget, fill = Mood)) +
  geom_boxplot() +
  labs(title = "Budget Distribution across Different Moods",
       x = "Mood", y = "Budget (INR)") +
  theme_minimal()

# ---- 2.4 Pie Chart: Travel Style Preference ----
style_counts <- travel_data %>%
  count(TravelStyle) %>%
  mutate(Percent = round(n / sum(n) * 100, 1))

ggplot(style_counts, aes(x = "", y = n, fill = TravelStyle)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Travel Style Preference Distribution") +
  geom_text(aes(label = paste0(Percent, "%")),
            position = position_stack(vjust = 0.5)) +
  theme_void()

# ---- 2.5 Scatter Plot: Cost vs Rating ----
ggplot(travel_data, aes(x = Cost, y = Rating, color = TravelStyle)) +
  geom_point(size = 3, alpha = 0.75) +
  labs(title = "Cost vs Rating (colored by Travel Style)",
       x = "Cost (INR)", y = "Rating (1-5)") +
  theme_minimal()


dest_count <- as.data.frame(table(travel_data$Destination))
colnames(dest_count) <- c("Destination", "Count")

ggplot(dest_count, aes(x = reorder(Destination, Count), y = Count)) +
  geom_bar(stat = "identity", fill = "tomato") +
  coord_flip() +
  labs(title = "Destination Frequency - Wordcloud Replacement", 
       x = "Destination", y = "Count") +
  theme_minimal()
