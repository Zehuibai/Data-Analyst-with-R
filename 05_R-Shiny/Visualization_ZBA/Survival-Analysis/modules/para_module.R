title_style = "color: steelblue; font-weight: bold"

Para_UI <- function(id)
{
  ns <- NS(id)
  fluidRow(
    tags$style(".well {margin-left: 30px}"),
    tabBox(
      title = tagList(icon("gear"),"Parametric Model"), width = 9,
      
      tabPanel(
        "Model Results",
        navlistPanel(
          
          widths = c(3, 8),
          
          tabPanel(
            "Coefficient Estimates & Model Comparison",
            
            fluidRow(
              column(
                12, align = "center",
                br(),
                h4(textOutput(ns("exp_title1")), style = title_style),
                tableOutput(ns("exp_output")),
                br(),
                h4(textOutput(ns("weibull_title1")), style = title_style),
                tableOutput(ns("weibull_output")),
                br(),
                tableOutput(ns("aic_output"))
                ))
            ),
          
          tabPanel(
            "Acceleration Factor",
            fluidRow(
              column(
                12, align = "center",
                
                br(),
                h4(textOutput(ns("exp_title2")), style = title_style),
                tableOutput(ns("exp_acc")),
                br(),
                
                h4(textOutput(ns("weibull_title2")), style = title_style),
                tableOutput(ns("weibull_acc")),
                br()
              ))
          ),
          
          tabPanel(
            "Hazard Ratio",
            fluidRow(
              column(12, align = "center",
                     br(),
                     h4(textOutput(ns("exp_title3")), style = title_style),
                     tableOutput(ns("exp_hr")),
                     br(),
                     
                     h4(textOutput(ns("weibull_title3")), style = title_style),
                     tableOutput(ns("weibull_hr")),
                     br()
                     ))
            )
          )
        ),
      
      tabPanel("Model Diagnosis",
               fluidRow(
                 column(6, align = "center", 
                        plotOutput(ns("diag_exp"))),
                 column(6, align = "center", 
                        plotOutput(ns("diag_weibull")))
               ))
    ),
    
    column(3,
           box(
             title = "Parametric Model", width = 12,
             status = "primary", solidHeader = TRUE,
             strong("Distribution",
                    style = "color: #666666"),
             checkboxGroupInput(
               ns("dist"),
               label = "",
               choices = c("exponential", "weibull")
             ),
             br(),
             selectInput(ns("para_var"),
                         label = "Select Variables for Parametric Model: ",
                         choices = "",
                         multiple = TRUE, width = 300
             ),
             
             column(width = 12, align = "center",
                    fluidRow(
                      actionButton(ns("paraVarButton"), "Submit", 
                                   icon = icon("paper-plane"),
                                   style = button_style1),
                      
                      actionButton(ns("paraResetButton"), "Clear All",
                                   icon = icon("broom"))
                    )
             )
           ))
  )
}

Para <- function(input, output, session, data, Time, Event){
  
  para_var <- reactive({req(input$para_var); input$para_var})
  dist <- reactive({req(input$dist); input$dist})
  
  # Cox Regression for Selected Variables
  v <- reactiveValues(Para = NULL)
  
  observe({
    updateSelectInput(session = getDefaultReactiveDomain(), "para_var",
                      choices = setdiff(names(data()),c(Time(), Event()))
                      )
    })
  
  # varButton
  observeEvent(input$paraVarButton, {
    for(i in 1:length(dist())){
      v$Para[[dist()[i]]] <- parafit(var_names = para_var(), data = data(),
                                    Time = Time(), Event = Event(),
                                    dist = dist()[i])
    }
    
    updateActionButton(session = getDefaultReactiveDomain(),
                       "paraVarButton",
                       label = "Refresh",
                       icon = icon("sync"))
    
    output$exp_title1 <- output$exp_title2 <- output$exp_title3 <- renderText({
      if (!"exponential" %in% dist()) return()
      "Exponential Model"
    })
    
    output$weibull_title1 <- output$weibull_title2 <- output$weibull_title3 <- renderText({
      if (!"weibull" %in% dist()) return()
      "Weibull Model"
    })
    }
    )
  
  # Reset Button
  observeEvent(input$paraResetButton, {
    v$Para <- NULL
    output$weibull_title1 <- output$weibull_title2 <- output$weibull_title3<- NULL
    output$exp_title1 <- output$exp_title2 <- output$exp_title3<- NULL
    updateSelectInput(session = getDefaultReactiveDomain(),"para_var",
                      choices = setdiff(names(data()),c(Time(), Event())),
                      selected = NULL)
    
  })
  
  
  # Output ------
  output$exp_output <- renderTable({
    if (!"exponential" %in% dist()) return()
    v$Para$exponential$summary},
    digits = 3,
    spacing = "s",
    rownames = TRUE
  )
  
  output$exp_acc <- renderTable({
    if (!"exponential" %in% dist()) return()
    v$Para$exponential$acc_factor},
    digits = 3,
    align = "lccc",
    spacing = "s",
    rownames = TRUE
  )
  
  
  output$exp_hr <- renderTable({
    if (!"exponential" %in% dist()) return()
    v$Para$exponential$HR_tbl},
    digits = 3,
    align = "lccc",
    spacing = "s",
    rownames = TRUE
  )
  
  output$diag_exp <- renderPlot({
    if (!"exponential" %in% dist()) return()
    v$Para$exponential$p_exp})
  
  output$weibull_output <- renderTable({
    if (!"weibull" %in% dist()) return()
    v$Para$weibull$summary},
    digits = 3,
    spacing = "s",
    rownames = TRUE
  )
  
  output$weibull_acc <- renderTable({
    if (!"weibull" %in% dist()) return()
    v$Para$weibull$acc_factor},
    digits = 3,
    align = "lccc",
    spacing = "s",
    rownames = TRUE)
  
  output$weibull_hr <- renderTable({
    if (!"weibull" %in% dist()) return()
    v$Para$weibull$HR_tbl},
    digits = 3,
    align = "lccc",
    spacing = "s",
    rownames = TRUE)
  
  
  output$diag_weibull <- renderPlot({
    if (!"weibull" %in% dist()) return()
    v$Para$weibull$p_weibull})
  
  
  output$aic_output <- renderTable({
    if (is.null(dist())) return()
    aic_exp = aic_weibull = NULL
    if ("exponential" %in% dist()) {aic_exp = v$Para$exponential$aic_tb}
    if ("weibull" %in% dist()) {aic_weibull = v$Para$weibull$aic_tb}
    
    rbind(Exponential = aic_exp,
          Weibull = aic_weibull)},
    
    align = "c",
    digits = 3,
    rownames = TRUE)
}
