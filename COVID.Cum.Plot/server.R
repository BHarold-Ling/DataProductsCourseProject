#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Code to run once
library(shiny)
library(lubridate)
library(dplyr)
library(ggplot2)

cov <- readRDS("cov.rds")
names(cov)[1] <- "repdate"
last.report <- max(cov$repdate)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    workset <- reactive({
        # Dates
        end.new <- ymd(input$endnew)
        start.new <- end.new - input$days + 1
        # Work set
        workset1 <- cov %>%
            filter(country == input$country, repdate <= end.new) %>%
            select(repdate, cases)
        if (nrow(workset1) > 0) {
            workset1$status <- "Previous"
            workset1$status[workset1$repdate >= start.new] <- "Recent"
        } else {
            workset1$status = character()
        }
        workset1
    })
    
    output$colPlot <- renderPlot({
        country.df <- workset()
        
        p <- ggplot(country.df, aes(repdate, cases)) + 
            geom_col(aes(fill = status)) +
            scale_color_manual(values = c("#56B4E9", "#D55E00"), aesthetics = c("color", "fill")) # + 
            # labs(title = "Cases Reported by Date")
        p
    })
    
    output$doughnut <- renderPlot({
        country.df <- workset()
        
        # Donut chart (code adapted from https://www.r-graph-gallery.com/128-ring-or-donut-plot.html)
        
        data <- data.frame(
            category = c("Recent", "Previous"),
            count = c(
                sum(country.df$cases[country.df$status == "Recent"]),
                sum(country.df$cases[country.df$status == "Previous"])
            )
        )
        
        # Compute percentages
        data$fraction <- data$count / sum(data$count)
        
        # Compute the cumulative percentages (top of each rectangle)
        data$ymax <- cumsum(data$fraction)
        
        # Compute the bottom of each rectangle
        data$ymin <- c(0, head(data$ymax, n=-1))
        
        # Compute label position
        data$labelPosition <- (data$ymax + data$ymin) / 2
        
        # Compute a good label
        data$label <- paste0(data$category,
                             " cases: ",
                             format(data$count, big.mark = ",",
                                    scientific = FALSE),
                             " \n",
                             round(data$fraction * 100, 0),
                             "%"
        )
        
        # Make the plot
        ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, 
                         fill=category)) +
            geom_rect() +
            geom_text( x=2, aes(y=labelPosition, label=label), size=6) + 
            scale_color_manual(values = c("#56B4E9", "#D55E00"),
                               aesthetics = c("color", "fill")) +
            coord_polar(theta="y") +
            xlim(c(-1, 4)) +
            theme_void() +
            theme(legend.position = "none") # +
            # labs(title = "Proportion of Recent Cases")
    })

})
