suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage("Data Science Capstone: Course Project",
                   tabPanel("Web App",
                            HTML("<H1>Next Word Prediction Web Application</H1>"),
                            br(),
                            br(),
                            sidebarLayout(
                              sidebarPanel(
                                textInput("inputString", "Start typing below to get predictions",value = "")
                              ),
                              mainPanel(
                                h3("Prediction"),
                                verbatimTextOutput("prediction"),
                              )
                            ),
                            HTML("<H6> Web Application by: HB</H6>")
                   ),
                   tabPanel("About",
                            mainPanel(
                              includeMarkdown("about.Rmd")
                            )
                   )
      )
)


