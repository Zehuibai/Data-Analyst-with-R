button_style1 = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
button_style2 = "color: #fff; background-color: #ff9e42; border-color: #ff7f42"

nonPara_UI<-function(id)
{
  ns = NS(id)
  fluidRow(
    tabBox(
      title = tagList(icon("gear"), "Non-Parametric Methods"),
      id = ns("NonPara_TabBox"),
      width = 9,
      
      tabPanel("Table", DT::dataTableOutput(ns("surv_table"))),
      
      tabPanel("Plot",
               sidebarLayout(
                 sidebarPanel(
                   stratify_UI(ns("stratify")),
                   br(),
                   column(12, align = "center",
                          actionButton(
                            ns("submitButton_plot"),
                            label = "Submit",
                            icon = icon("paper-plane"),
                            style = button_style1, width = 160)),
                   br(),
                   br()
                 ),
                 
                 mainPanel(plotOutput(ns("surv_plot")),
                           br(),
                           br(),
                           br(),
                           plotOutput(ns("cumhaz_plot")))
               )
      ),
      
      tabPanel("Test", DT::dataTableOutput(ns("test_result")))
    ),
    
    column(3,
           conditionalPanel(
             "input.NonPara_TabBox == 'Table' || input.NonPara_TabBox == 'Plot'",
             ns = ns,
             box(title = "Table & Plot", width = 12, status = "primary", solidHeader = TRUE,
                 nonPara_TablePlot_UI(ns("nonPara_TablePlot")),
                 br(),
                 column(12, align = "center",
                        actionButton(
                          ns("submitButton"), "Submit",
                          width = 160,
                          icon = icon("paper-plane"),
                          style = button_style1))
                 )
               ),
           
           conditionalPanel(
             "input.NonPara_TabBox == 'Test'",
             ns = ns,
             box(title = "Test", width = 12, status = "warning", solidHeader = TRUE,
                 strong("Stratification Variable"),
                 selectInput(ns("varStrat_test"), NULL, choices = ""),
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
                 ),
                 
                 h4("Method"),
                 br(),
                 checkboxGroupInput(ns("testMethod"), NULL,
                                    choices = c("log-rank" = 1,	
                                                "Gehan-Breslow Generalized Wilcoxon" = 2,	
                                                "Tarone-Ware" = 3,	
                                                "Peto-Peto" = 4,
                                                "Modified Peto-Peto (by Andersen)" = 5,
                                                "Fleming-Harrington" = 6)),
                 
                 column(12, align = "center",
                        actionButton(
                          ns("submitButton_test"), "Submit",
                          width = 160,
                          icon = icon("paper-plane"),
                          style = button_style2))
             )
           )
    )
  )
}

nonPara <- function(input, output, session, data, Time, Event)
{
  # Call Inner Modules
  side_TablePlot = callModule(nonPara_TablePlot, "nonPara_TablePlot")
  stratify = callModule(stratify, "stratify", data = data, 
                        Time = Time, Event = Event)
  
  submitButton <- reactive({input$submitButton})
  submitButton_plot <- reactive({input$submitButton_plot})
  submitButton_test <- reactive({input$submitButton_test})
  varStrat_test <- reactive({req(input$varStrat_test)
                             input$varStrat_test})
  testMethod <- reactive({req(input$testMethod)
                              input$testMethod})
  isContinuous <- reactive({input$isContinuous})
  cutpoint <- reactive({req(input$cutpoint); input$cutpoint})
  
  observeEvent(
    isContinuous(),
    {
      output$min_val <- renderText(round(min(data()[, varStrat_test()]), 3))
      output$max_val <- renderText(round(max(data()[, varStrat_test()]), 3))
    }
  )
  
  observe(
    {
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        "varStrat_test",
        label = NULL,
        choices = setdiff(names(data()), c(Time(), Event()))
      )
    }
  )
  
  v <- reactiveValues(nonPara = NULL,
                      nonPara_test = NULL)
  
  observeEvent(
    eventExpr = input$submitButton,
    handlerExpr = {
      v$nonPara <- surv_est(data = data(),
                            Time = Time(),
                            Event = Event(),
                            conf.int = side_TablePlot$conf.int(),
                            conf.type = side_TablePlot$conf.type(),
                            type = side_TablePlot$type(),
                            isCumHaz = side_TablePlot$isCumHaz(),
                            isStrat = stratify$isStrat(),
                            isContinuous = stratify$isContinuous(),
                            isRiskTbl = stratify$isRiskTbl(),
                            isCensPlot = stratify$isCensPlot(),
                            varStrat = stratify$varStrat(),
                            cutpoint = stratify$cutpoint())
      
      updateActionButton(session, "submitButton",
                         label = "Refresh", icon = icon("sync"))
    }
  )
  
  observeEvent(
    eventExpr = input$submitButton_plot,
    handlerExpr = {
      v$nonPara <- surv_est(data = data(),
                            Time = Time(),
                            Event = Event(),
                            conf.int = side_TablePlot$conf.int(),
                            conf.type = side_TablePlot$conf.type(),
                            isCumHaz = side_TablePlot$isCumHaz(),
                            type = side_TablePlot$type(),
                            isStrat = stratify$isStrat(),
                            isContinuous = stratify$isContinuous(),
                            isRiskTbl = stratify$isRiskTbl(),
                            isCensPlot = stratify$isCensPlot(),
                            varStrat = stratify$varStrat(),
                            cutpoint = stratify$cutpoint())
      
      updateActionButton(session, "submitButton_plot",
                         label = "Refresh", icon = icon("sync"))
    }
  )
  
  
  observeEvent(
    eventExpr = input$submitButton_test,
    handlerExpr = {
      v$nonPara_test <- surv_test(data = data(),
                                  Time = Time(),
                                  Event = Event(),
                                  varStrat_test = varStrat_test(),
                                  testMethod = testMethod(),
                                  isContinuous = isContinuous(),
                                  cutpoint = cutpoint())
      
      updateActionButton(session, "submitButton_test",
                         label = "Refresh", icon = icon("sync"))
    }
  )
  
  # output -----------
  output$surv_table = DT::renderDataTable({
    if (is.null(v$nonPara)) return()
    var_round <- setdiff(1:ncol(v$nonPara$tbl), 2:4)
    
    v$nonPara$tbl%>%
      DT::datatable() %>%
      DT::formatRound(columns = var_round, digits=3)
  })
  
  output$surv_plot = renderPlot({
    if (is.null(v$nonPara)) return()
    v$nonPara$p_surv
    },
    width = 500, height = "auto")
  
  output$cumhaz_plot = renderPlot({
    if (is.null(v$nonPara) || !side_TablePlot$isCumHaz()) return()
    v$nonPara$p_cumhaz
    },
    width = 500, height = "auto")
  
  output$test_result = DT::renderDataTable({
    if (is.null(v$nonPara_test)) return()
    v$nonPara_test})
}