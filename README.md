# Travel Tune — Mood-Based Personalized Travel Destination Recommendation System using R

A rule-based Travel Recommender built in **R & Shiny** – No ML/DL.
**Logic:** Mood + Budget + Season = Top 3 Destinations with WHY

## 📌 Problem Statement
Travelers struggle to pick a destination matching their current mood, budget, and season. Existing apps show only popular places. Travel Tune solves this with mood-based personalization.

## 🚀 Features
- **Smart Inputs:** Mood (Happy/Sad/Stressed/Relaxed/Energetic), Budget Slider (5k-60k INR), Season (Summer/Winter/Monsoon)
- **Core Function:** `get_recommendations()` – calculates total_score out of 100
- **Scoring Rule:** Mood Match 30 + Budget Check 15 + Season Match 25 + Rating*3 + Type 15 = 100
- **Tab 1 - My Recommendations:** Top 3 ranked destinations table (DT) + Horizontal Bar Chart (Top 3 Score)
- **Tab 2 - Travel Insights:** Mood vs Destination Type Stacked Bar Chart for pattern analysis
- **R Concepts Used:** `data.frame()`, `mutate()`, `filter()`, `arrange(desc())`, `ggplot2`, `DT::datatable()`

## 📸 Output
**Fig 1:** My Recommendations shows Jaipur Palace (98.5), Goa Beach (84.4), Manali Hills (74.1) for Happy + 24k + Winter.
**Fig 2:** Travel Insights shows distribution of destinations across Adventure/Beach/Cultural/Hill vs Mood.

## 🛠️ Tech Stack
R, Shiny, dplyr, ggplot2, DT

## ▶️ How to Run
```R
install.packages(c("shiny","dplyr","ggplot2","DT"))
library(shiny)
runApp("app.R")
