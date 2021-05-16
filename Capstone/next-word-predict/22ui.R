#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    
    fluidPage(

    # Application title
    titlePanel("Next Word Prediction Application"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput("userInput",
                      "Enter a word or phrase:",
                      value =  "",
                      placeholder = "Enter text here"),
            br(),
            sliderInput("numPredictions", "Number of Predictions:",
                        value = 1.0, min = 1.0, max = 3.0, step = 1.0)
        ),
    mainPanel(
            h4("Input text"),
            verbatimTextOutput("userSentence"),
            br(),
            h4("Predicted words"),
            verbatimTextOutput("prediction1"),
            verbatimTextOutput("prediction2"),
            verbatimTextOutput("prediction3")
        )
    )
))
