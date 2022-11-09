library(shiny)

# nonPara_TablePlot---------------------------------------------------
nonPara_TablePlot_UI <- function(id){
  ns = NS(id)
  
  tagList(
    radioButtons(ns("estType"), "Estimate Method",
                 choices = c("Kaplan-Meier",
                             "Fleming-Harrington"),
                 selected = "Kaplan-Meier"),
    br(),
    
    strong("Cumulative Hazard"),
    checkboxInput(ns("isCumHaz"), "Show Cumulative Hazard (Plot)", FALSE),
    br(),
    
    strong("Confidence Interval"),
    checkboxInput(ns("isCI"), "Show Confidence Interval", FALSE),
    
    conditionalPanel(
      condition = "input.isCI == true",
      ns = ns,
      fixedRow(
        column(12,
               strong(tags$i(class = HTML("&nbsp; fa fa-angle-right")),
                      style = "color: #666666; margin-left: 15px", 
                      HTML("&nbsp; Type &nbsp;"))
        ),
        
        column(12, offset = 1,
               radioButtons(
                 ns("CIType"),
                 label = NULL,
                 choiceNames = list(
                   tags$span(style = "color: #666666", "Linear"),
                   tags$span(style = "color: #666666", "Log"),
                   tags$span(style = "color: #666666", "Log-Log")
                   ),
                 choiceValues = c("plain", "log", "log-log"),
                 selected = "log-log",
                 inline = TRUE
                 )
        )
      ),
      style = "background-color: #f0f8ff; margin-left: -10px; margin-right: -10px"
    )
  )
}

nonPara_TablePlot <- function(input, output, session) {
  
  conf.int = reactive({input$isCI})
  conf.type = reactive({input$CIType})
  type = reactive({input$estType})
  isCumHaz = reactive({input$isCumHaz})
  
  return(list(conf.int = conf.int, conf.type = conf.type,
              type = type, isCumHaz = isCumHaz))
}

