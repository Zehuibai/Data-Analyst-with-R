button_style1 = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
button_style2 = "color: #fff; background-color: #ff9e42; border-color: #ff7f42"



semiPara_UI <- function(id)
{
  ns <- NS(id)
  fluidRow(
    tabBox(
      title = tagList(icon("gear"),"Cox Proportional Hazard Model"),
      width = 9,
      
      tabPanel("Model Results",
               fluidRow(
                 
                 column(12, align = "center",
                        tableOutput(ns("cox_output")),
                        br(),
                        br(),
                        tableOutput(ns("cox_aic"))
                       )
                 )
               ),
      
      tabPanel("Model Diagnosis",
               
               sidebarLayout(
                 sidebarPanel(
                   
                   h4("Model Diagnosis", style = "color:#666666"),
                   
                   selectInput(ns("diag"), NULL,
                               choices = c("Overall Fit" = "Fit",
                                           "Proportional Hazard Assumption" = "PH")),
                   conditionalPanel(
                     "input.diag == 'PH'",
                     ns = ns,
                     
                     checkboxInput(ns("isInteract"),
                                   "Include Time interaction?"),
                     
                     conditionalPanel(
                       "input.isInteract == true",
                       ns = ns,
                       selectInput(ns("interact_var"),
                                   "Choose the covariate for Time interaction:",
                                   choices = ""),
                       
                       column(width = 12, align = "center",
                              actionButton(ns("interactButton"), "Submit",
                                           icon = icon("paper-plane"),
                                           style = button_style1,
                                           width = 160)
                              )
                       ),
                     br()
                     )

                   ),
                 mainPanel(column(12,align = "center",
                                  plotOutput(ns("diag_plot"))
                                  ),
                           br(),
                           br(),
                           conditionalPanel(
                             "input.diag == 'PH'",
                             ns = ns,
                             column(12, align = "center",
                                    tableOutput(ns("interact_tbl"))
                             )
                           )
                 )
               )
      )
    ),
      
    column(3,
           box(
             title = "Cox Proportional Hazard Model", width = 12,
             status = "primary", solidHeader = TRUE,
             selectInput(ns("cox_var"),
                         label = "Select Variables for Cox Model: ",
                         choices = "",
                         multiple = TRUE, width = 300
             ),
             
             column(width = 12, align = "center",
                    fluidRow(
                      actionButton(ns("coxVarButton"), "Submit", 
                                   icon = icon("paper-plane"), style = button_style1),
                      actionButton(ns("resetButton"), "Clear All",
                                   icon = icon("broom")))
             )
           ))
  )
}

semiPara <- function(input, output, session, data, Time, Event){
  
  cox_var <- reactive({req(input$cox_var)
    input$cox_var})
  
  # Cox Regression for Selected Variables
  v <- reactiveValues(semiPara = NULL)
  
  observe({
    updateSelectInput(session = getDefaultReactiveDomain(), "cox_var",
                      choices = setdiff(names(data()),c(Time(), Event()))
                      )
    }
  )
  
  observe({
    updateSelectInput(session = getDefaultReactiveDomain(),
                      "interact_var",
                      choices = input$cox_var
                      )
    }
  )
  
  # varButton
  observeEvent(input$coxVarButton, {
    v$semiPara <- coxfit(var_names = cox_var(), data = data(),
                         Time = Time(), Event = Event())})
  
  # Reset Button
  observeEvent(input$resetButton, {
    v$semiPara <- NULL
    updateSelectInput(session = getDefaultReactiveDomain(), "cox_var",
                      choices = setdiff(names(data()),c(Time(), Event())),
                      selected = NULL)
    
    updateSelectInput(session = getDefaultReactiveDomain(), "interact_var",
                      choices = NULL)
  })
  
  # Interaction Button
  observeEvent(input$interactButton, {
    v$semiPara <- coxfit(var_names = cox_var(), data = data(), 
                         Time = Time(), Event = Event(),
                         int_var = input$interact_var)
    
    updateActionButton(session = getDefaultReactiveDomain(),
                       "interactButton",
                       label = "Refresh",
                       icon = icon("sync"))
    })
  
  # Output ------
  output$cox_output <- renderTable({
    if (is.null(v$semiPara)) return()
    v$semiPara$summary},
    digits = 3,
    spacing = "s",
    rownames = TRUE,
    width = 100
  )
  
  output$cox_aic <- renderTable({
    if (is.null(v$semiPara)) return()
    v$semiPara$aic_tb},
    width = 440,
    align = "c")
    
  # Diagnosis Plot
  output$diag_plot <- renderPlot({
    if (is.null(v$semiPara)) return()
    p_schoenfeld <- ggpar(v$semiPara$p_schoenfeld,
                          font.main = c(12, "plain", "black"),
                          font.x = c(11, "plain", "black"),
                          font.y = c(11, "plain", "black"),
                          font.family = "Cambria")
    switch(input$diag,
           "Fit" = v$semiPara$p_deviance,
           "PH" = p_schoenfeld)},
    width = 500, height = "auto"
  )
  
  # Regression output including Time interaction
  output$interact_tbl <- renderTable({
    if (is.null(v$semiPara)) return()
    v$semiPara$fit_int.summ},
    digits = 3,
    spacing = "s",
    rownames = TRUE,
    width = 100
  )
}
