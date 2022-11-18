
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
# library(shinyBS)
source("global.R")

shinyServer(function(input, output, session) {

  ## Solve for power/sample size and make power curve --------------------------
  out <- reactive(power.wrapper(input))
  power.n.curve <- reactive(plot.power.n(input))

  ## update input fields -------------------------------------------------------
  observe({
    if(input$solveFor=="Sample size"){
      updateNumericInput(session, "n", value=ceiling(out()$n))
    }
    if(input$solveFor=="Power"){
      updateNumericInput(session, "power", value=round(out()$power, 3),
                         min=input$alpha)
    }
  })

  ## output --------------------------------------------------------------------
  output$power.curve <- renderPlot({
    power.n.curve()
    })
  output$print.solveFor <- renderText({
      print(input$solveFor)
    })

})
