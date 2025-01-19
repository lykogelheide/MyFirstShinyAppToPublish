library(shiny)
library(ggplot2)
library(dplyr)

source("Data/EurostatData.R")

# Define UI
ui <- fluidPage(
  titlePanel("Immigration Time Series by Country"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "selected_countries",
        label = "Select Countries (2-letter codes):",
        choices = unique(EurostatData$geo),
        selected = unique(EurostatData$geo)[1:3],
        multiple = TRUE
      ),
      sliderInput(
        inputId = "selected_years",
        label = "Select Year Range:",
        min = as.numeric(format(min(EurostatData$TIME_PERIOD), "%Y")),
        max = as.numeric(format(max(EurostatData$TIME_PERIOD), "%Y")),
        value = c(2015, 2019),
        step = 1
      )
    ),
    mainPanel(
      plotOutput("timeSeriesPlot", height = "500px")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  # Reactive data for the filtered time series
  filtered_time_series <- reactive({
    req(input$selected_countries, input$selected_years)
    EurostatData %>%
      filter(
        geo %in% input$selected_countries,
        as.numeric(format(TIME_PERIOD, "%Y")) %in% seq(input$selected_years[1], input$selected_years[2])
      )
  })
  
  # Render the time series plot
  output$timeSeriesPlot <- renderPlot({
    ggplot(filtered_time_series(), aes(x = TIME_PERIOD, y = values, group = geo, color = geo)) +
      geom_line(size = 1) +
      labs(
        title = "Immigration Time Series by Country",
        x = "Year",
        y = "Total Immigration"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
}

# Run the app
shinyApp(ui = ui, server = server)