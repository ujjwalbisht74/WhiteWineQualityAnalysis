library(shiny)
library(randomForest)

load("random_forest_model.RData")


ui <- fluidPage(
  titlePanel("Wine Quality Predictor"),
  sidebarLayout(
    sidebarPanel(
      numericInput("fixed_acidity", "Fixed Acidity:", value = 7),
      numericInput("volatile_acidity", "Volatile Acidity:", value = 0.5),
      numericInput("citric_acid", "Citric Acid:", value = 0.3),
      numericInput("residual_sugar", "Residual Sugar:", value = 5),
      numericInput("chlorides", "Chlorides:", value = 0.05),
      numericInput("free_sulfur_dioxide", "Free Sulfur Dioxide:", value = 30),
      numericInput("total_sulfur_dioxide", "Total Sulfur Dioxide:", value = 100),
      numericInput("density", "Density:", value = 0.997),
      numericInput("pH", "pH:", value = 3.3),
      numericInput("sulphates", "Sulphates:", value = 0.6),
      numericInput("alcohol", "Alcohol:", value = 10),
      actionButton("predict_btn", "Predict")
    ),
    mainPanel(
      h3("Predicted Wine Quality:"),
      htmlOutput("emoji_output")
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$predict_btn, {

    new_data <- data.frame(
      fixed_acidity = input$fixed_acidity,
      volatile_acidity = input$volatile_acidity,
      citric_acid = input$citric_acid,
      residual_sugar = input$residual_sugar,
      chlorides = input$chlorides,
      free_sulfur_dioxide = input$free_sulfur_dioxide,
      total_sulfur_dioxide = input$total_sulfur_dioxide,
      density = input$density,
      pH = input$pH,
      sulphates = input$sulphates,
      alcohol = input$alcohol
    )
    
    prediction <- predict(random_forest_model, newdata = new_data)
    
    emoji <- ifelse(prediction >= 7, "😄", "😞")
    
    output$emoji_output <- renderText({
      paste("Predicted Quality:", emoji)
    })
  })
}


shinyApp(ui = ui, server = server)