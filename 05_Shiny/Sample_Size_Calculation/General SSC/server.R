
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(pwr)
library(googleVis)
library(tidyr)

shinyServer(function(input, output) {
    datasetInput <- reactive({
    h <- seq(.2,1.8,.01)
    nh<-length(h)
    h
    
    p <- seq(.5,.9,.1)
    np <- length(p)
    p
    
    # obtain sample sizes
    samsize <- array(numeric(nh+np), dim=c(nh,np))
    for (i in 1:np){
      for (j in 1:nh){
        if(input$type == "t") { 
          result <- pwr.t.test(n = NULL, d = h[j],
                               sig.level = as.numeric(input$sig.level), power = p[i],
                               alternative = input$alternative,type=input$type.of.t)
        } else{
          result <- pwr.2p.test(n = NULL, h = h[j],
                                sig.level = as.numeric(input$sig.level), power = p[i],
                                alternative = input$alternative)
        }
        
        result
        samsize[j,i] <- round(result$n)
      }
    }
    data.power <- data.frame(h,samsize)
    colnames(data.power) <- c("Effect",p)
    data.power
    }
  )
  
  output$sSizeCalc <- renderPrint({

    
    if(input$type == "t") { 
      result <- pwr.t.test(n = NULL, d = input$effect,
                                               sig.level = as.numeric(input$sig.level), power = input$power,
                                               alternative = input$alternative,type=input$type.of.t)
    } else{
       result <- pwr.2p.test(n = NULL, h = input$effect,
                                 sig.level = as.numeric(input$sig.level), power = input$power,
                                 alternative = input$alternative)
    }
    
      result
    }
  )
  
  
  output$view <- renderGvis({
    data <- datasetInput()

    gvisScatterChart(data, options=list(title=paste("Sample sizes with significance level of", input$sig.level),width=800, height=800)
    )
    
  })
  
  

})
  

