library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

# Sample Data - if travel_data.csv illa-na ithu work aagum
travel_data <- data.frame(
  Destination = c("Goa Beach", "Manali Hills", "Jaipur Palace", "Munnar Tea Hills", 
                  "Kerala Backwaters", "Ladakh Adventure", "Ooty Cool Stay", "Andaman Beach"),
  Mood_Tag = c("Happy", "Relaxed", "Happy", "Stressed", "Relaxed", "Energetic", "Sad", "Happy"),
  Budget = c(15000, 24000, 18000, 20000, 25000, 35000, 17000, 30000),
  Season = c("Summer", "Winter", "Winter", "Monsoon", "Winter", "Summer", "Monsoon", "Summer"),
  Type = c("Beach", "Hill", "Cultural", "Hill", "Beach", "Adventure", "Hill", "Beach"),
  Rating = c(4.8, 4.7, 4.5, 4.6, 4.9, 4.8, 4.4, 4.7),
  stringsAsFactors = FALSE
)

# === MAIN FUNCTION - ITHU THAN MISSING-A IRUNTHUCHU ===
get_recommendations <- function(mood_input, budget_input, season_input) {
  
  df <- travel_data %>%
    mutate(
      mood_score = ifelse(Mood_Tag == mood_input, 30, 5),
      budget_score = ifelse(Budget <= budget_input, 15, 0),
      season_score = ifelse(Season == season_input, 25, 10),
      rating_score = Rating * 3, # Rating/5 * 15
      type_score = 15,
      total_score = mood_score + budget_score + season_score + rating_score + type_score
    ) %>%
    arrange(desc(total_score)) %>%
    head(3)
  
  return(df)
}

# UI
ui <- fluidPage(
  titlePanel("Travel Tune — Mood-Based Travel Recommender"),
  sidebarLayout(
    sidebarPanel(
      selectInput("mood", "How are you feeling?", choices = c("Happy", "Sad", "Stressed", "Relaxed", "Energetic")),
      sliderInput("budget", "Budget (INR):", min = 5000, max = 60000, value = 24000, step = 1000),
      selectInput("season", "Season:", choices = c("Summer", "Winter", "Monsoon")),
      actionButton("go", "Get Recommendations", class = "btn-primary")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("My Recommendations", 
                 br(),
                 DTOutput("rec_table"),
                 br(),
                 plotOutput("score_plot")
        ),
        tabPanel("Travel Insights", 
                 br(),
                 plotOutput("insights_plot")
        )
      )
    )
  )
)

# SERVER
server <- function(input, output) {
  
  rec_data <- eventReactive(input$go, {
    get_recommendations(input$mood, input$budget, input$season)
  })
  
  output$rec_table <- renderDT({
    req(rec_data())
    datatable(rec_data()[, c("Destination", "Mood_Tag", "Budget", "Season", "Type", "Rating", "total_score")])
  })
  
  output$score_plot <- renderPlot({
    req(rec_data())
    ggplot(rec_data(), aes(x = Destination, y = total_score, fill = Destination)) +
      geom_bar(stat = "identity") + coord_flip() + theme_minimal() +
      labs(title = "Top 3 Score", y = "Score /100", x = "")
  })
  
  output$insights_plot <- renderPlot({
    ggplot(travel_data, aes(x = Type, fill = Mood_Tag)) + 
      geom_bar() + theme_minimal() + labs(title = "Mood vs Destination Type")
  })
}

shinyApp(ui = ui, server = server)