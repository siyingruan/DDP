#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(ggplot2)
data1 <- as.data.frame(state.x77)
data1$Illiteracy <- ceiling(data1$Population*data1$Illiteracy/100)
data1$Murder <- ceiling(data1$Population/1000*data1$Murder)
data1$`HS Grad` <- ceiling(data1$Population*data1$`HS Grad`/100)
data1$Area <- data1$Area/data1$Population
names(data1)[4] <- "LifeExp"
names(data1)[6] <- "HighSchoolGrad"


shinyServer(function(input, output) {
#Turn selectinput into ggplot acceptable format:strings. the class of selectinput is a character.  
   repaes <- reactive({
    if (length(input$zvar) >0)
      {x1 <- paste0(input$xvar,"+",input$zvar)
      aes_string(x = x1, y = input$yvar)}
    else{
      aes_string(x=input$xvar, y = input$yvar)}
                     })
#Turn selectinput into lm() acceptable formate: reformulate() function. 
  
   lmxy <- reactive({
     if (length(input$zvar) >0){
        x2 <- paste0(input$xvar,"+",input$zvar)
        reformulate(x2, input$yvar)}
     else{
       reformulate(input$xvar,input$yvar)}
                   })
    
  output$distPlot <- renderPlot({
        xlabel <- ifelse(input$xlab, input$xvar,"")
        ylabel <- ifelse(input$ylab, input$yvar,"")
        ggplot(data1, repaes()) + geom_line(color = "dodgerblue", size = 5) + geom_smooth(method = lm, color = 'steelblue', size = input$linesize)
                               })
#Make Prediction: How to add the 2nd variable?    
  re <- eventReactive(input$clicks, {
       
        fit <- lm(lmxy(),data1)
        new <- data.frame(input$customvalue, input$customvalue2)
        names(new) <- c(input$xvar, input$zvar)
        Prediction <- predict(fit, new, se.fit = FALSE)
        result <- cbind(new, Prediction)
        result
      })
  #Prediction Table       
  output$predictext <- renderTable({re()})

  output$fitPlot <- renderPlot({
     fit <- lm(lmxy(), data1)
     par(mfrow=c(2,2))
     plot(fit)
   })
  
  # Get the variale selected to put in the add_trace() code. How to add multiple variables into the plot?     
  y <- reactive({
    ynum <- grep(input$nvar,colnames(data1))
    y <- data1[[ynum]]
    y
  })
  # Combine the input of colors into a string of rgb() function to put in the add_trace() code.  
  colorlist <-reactive({
    colorlist <- paste(input$Red,input$Green,input$Blue,sep=",")
    colorlist <- paste0("rgb","(",colorlist,")")
    colorlist
  }) 
  #Plotly scatter plot. Use the function get() to get the formular that's represent by the charactor input$xvar. 
    output$plotlypot <- renderPlotly({
     f <- list(family = 'Courier New, monospace', size = 30, color = "#7f6f8f")
     x <- list(title = input$xvar, titlefont = f)
     y <- list(title = input$yvar, titlefont = f)
     fig <- plot_ly(data1, x = ~get(input$yvar), y = ~get(input$xvar), name = input$xvar, type = 'scatter', mode = 'markers')
     fig <- fig %>% layout(xaxis = y, yaxis = x, showlegend = TRUE)
     fig <- add_trace(fig, y=y(), name = input$nvar, type = 'scatter', mode = 'markers', marker=list(color='rgb(100,234,23)',size = 10, line=list(color=colorlist(), width =3)))
     
     fig
   })
  
})
