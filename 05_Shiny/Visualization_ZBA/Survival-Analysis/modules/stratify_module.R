# Stratification

stratify_UI <- function(id)
{
  ns = NS(id)
  
  tagList(
    h4(strong("Plot Customization"), style = "color: steelblue"),
    h5(strong("Risk Table"), style = "color: #666666"),
    checkboxInput(ns("isRiskTbl"), "Risk Table", FALSE),
    
    br(),
    
    h5(strong("Cumulative Censoring"), style = "color: #666666"),
    checkboxInput(ns("isCensPlot"), "No. of Censored Subjects Barplot", FALSE),
    
    br(),
    
    h5(strong("Stratification"), style = "color: #666666"),
    checkboxInput(ns("isStrat"), "Draw stratified curves?", FALSE),
    
    conditionalPanel(
      condition = "input.isStrat == true",
      ns = ns,
      
      strong(
        tags$i(class = HTML("&nbsp; fa fa-angle-right")), 
        style = "color: #666666", 
        HTML("&nbsp; Stratification Variable &nbsp;")),
      
      selectInput(ns("varStrat"), label = NULL, choices = ""),
      
      column(12, offset = 2,
             checkboxInput(
               ns("isContinuous"),
               "Continuous variable?", FALSE)
             ),
      
      br(),
      
      conditionalPanel(
        condition = "input.isContinuous == true",
        ns = ns,
        br(),
        strong(tags$i(class = HTML("&nbsp; fa fa-angle-right")),
               style = "color: #666666", 
               HTML("&nbsp; Enter cutoff point(s) &nbsp;")),
        
        textInput(ns("cutpoint"), NULL),
        
        helpText("Range: [",
                 textOutput(ns("min_val"), inline = TRUE),", ",
                 textOutput(ns("max_val"), inline = TRUE), "]",
                 style = "color: red; margin-bottom: 0px"),
        
        helpText("Format: num1, num2, num3, ...",
                 style = "color: black; margin-bottom: 0px")
        )
      )
  )
}

stratify <- function(input, output, session, data, Time, Event)
{
  isStrat <- reactive({input$isStrat})
  varStrat <- reactive({req(input$varStrat); input$varStrat})
  isContinuous <- reactive({input$isContinuous})
  isRiskTbl <- reactive({input$isRiskTbl})
  cutpoint <- reactive({req(input$cutpoint); input$cutpoint})
  isCensPlot <- reactive({input$isCensPlot})
  
  
  observeEvent(
    isContinuous(),
    {
      output$min_val <- renderText(round(min(data()[, varStrat()]), 3))
      output$max_val <- renderText(round(max(data()[, varStrat()]), 3))
    }
  )
  
  # Stratification
  observeEvent(
    isStrat(),
    {
    updateSelectInput(
      session = getDefaultReactiveDomain(),
      "varStrat",
      label = NULL,
      choices = setdiff(names(data()), c(Time(), Event()))
      )
    }
  )
  
  return(list(
    isStrat = isStrat,
    varStrat = varStrat,
    isRiskTbl = isRiskTbl,
    isContinuous = isContinuous,
    isCensPlot = isCensPlot,
    cutpoint = cutpoint
  ))
}