# ============================================
# PHASE 3: K-Means Clustering + Elbow Validation
# ============================================

library(dplyr)
library(cluster)
library(factoextra)

# ---- 3.1 Prepare clustering data ----
cluster_input <- data.frame(
  MoodNum = as.numeric(travel_data$Mood),
  Budget  = travel_data$Budget,
  Age     = travel_data$Age
)
cluster_scaled <- scale(cluster_input)

# ---- 3.2 Elbow Method: find optimal k ----
set.seed(123)
fviz_nbclust(cluster_scaled, kmeans, method = "wss", k.max = 8) +
  labs(title = "Elbow Method for Optimal Number of Clusters",
       subtitle = "Look for the point where the drop flattens out")

# ---- 3.3 (Optional but recommended) Silhouette score check ----
fviz_nbclust(cluster_scaled, kmeans, method = "silhouette", k.max = 8) +
  labs(title = "Silhouette Method - Confirms Best k")

# ---- 3.4 Run K-means with k = 3 (justified by the elbow plot above) ----
set.seed(123)
km_model <- kmeans(cluster_scaled, centers = 3, nstart = 25)
travel_data$Cluster <- km_model$cluster

# Print variance explained -- another number you can quote in your report/viva
cat("Between-cluster variance explained:",
    round(km_model$betweenss / km_model$totss * 100, 1), "%\n")

# ---- 3.5 Label clusters meaningfully (rank by avg budget, not arbitrary) ----
cluster_summary <- travel_data %>%
  group_by(Cluster) %>%
  summarise(AvgBudget = mean(Budget), AvgAge = mean(Age), n = n()) %>%
  arrange(AvgBudget)

persona_labels <- c("Peace Seekers", "Adventure Junkies", "Party Lovers")
cluster_summary$UserType <- persona_labels
print(cluster_summary)

travel_data <- travel_data %>%
  left_join(cluster_summary %>% select(Cluster, UserType), by = "Cluster")

table(travel_data$UserType)

# ---- 3.6 Visualize the clusters ----
fviz_cluster(km_model, data = cluster_scaled, geom = "point",
             ellipse.type = "convex", show.clust.cent = TRUE) +
  labs(title = "User Clusters based on Mood, Budget & Age")

