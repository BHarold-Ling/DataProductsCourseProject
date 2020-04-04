#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Code to run once
library(shiny)
library(lubridate)

cov <- readRDS("cov.rds")
last.report <- max(cov$date)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("COVID-19 Recent Cases vs Previous Cases"),
    br(),
    p("B Harold, April 3, 2020"),
    br(),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h4("Control Panel"),
            selectInput("country",
                        "Country",
                        choices = sort(unique(cov$country)),
                        selected = "Spain",
                        selectize = TRUE
            ),
            dateInput("endnew",
                      "Report as of",
                      min = date("2020-01-01"),
                      max = last.report,
                      value = last.report
            ),
            sliderInput("days",
                        "Number of Days for Recent:",
                        min = 1,
                        max = 14,
                        value = 7
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("Cases Reported by Date"),
            plotOutput("colPlot"),
            h3("Proportions"),
            plotOutput("doughnut")
        )
    ),
    
    includeHTML("Instructions.html")
    
))
