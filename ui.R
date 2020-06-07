#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)
data1 <- as.data.frame(state.x77)
names(data1)[4] <- "LifeExp"
names(data1)[6] <- "HighSchoolGrad"
# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
    # Application title
    titlePanel("C9W4 Project - Life Expectency Prediction"),

    # Sidebar with a slider input for number of bins

    sidebarLayout(
        sidebarPanel(
            code("Select the line size"),
            sliderInput("linesize",
                        "Line Size:",
                        min = 1,
                        max = 10,
                        value = 1),
            code("Liner Regression Model"),
            selectInput("yvar","Y Variable:", choices = names(data1), selected = names(data1)[4], multiple = FALSE),
            checkboxInput("xlab", "See the Variable Label", value = TRUE),
            checkboxInput("ylab", "See the 
                          Dependable Label", value = TRUE),
            selectInput("xvar","X Variable", choices = names(data1), selected = names(data1)[2], multiple = FALSE),
            selectInput("zvar","Z Variable, Select One More Factor Only", choices=names(data1), multiple = TRUE),
            code("Make Prediction-Limit to One Variable Model"),
            numericInput("customvalue", "Enter a numeric X variable to Predict the Y variable", value = 1000),
            numericInput("customvalue2", "Enter a numeric Z variable to Predict the Y varible", value = 0),
            actionButton(inputId = "clicks", label = "Click Me for a Prediction"),
            
            code("Visual Graphics on Varibles"),
            selectInput("nvar","Select One More Factor", choices = names(data1), selected = names(data1)[5], multiple = FALSE),
            code("Change the Color of the Circle"),
            sliderInput("Red", "Change the Red Degree", min = 0, max = 255, value =44),
            sliderInput("Green", "Change the Green Degree", min = 0, max = 255, value =88),
            sliderInput("Blue", "Change the Blue Degree", min = 0, max = 255, value =166),
                ),
           
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            plotOutput("fitPlot"),
            tableOutput("predictext"),
            plotlyOutput("plotlypot")

            
        )
    )
    
))
