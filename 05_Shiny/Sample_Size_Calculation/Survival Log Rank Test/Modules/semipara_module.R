button_style1 = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
button_style2 = "color: #fff; background-color: #ff9e42; border-color: #ff7f42"

# <!-- ------------------------- -->
# <!--        ui for Cox         -->
# <!-- ------------------------- -->

semiPara_UI <- function(id)
{
  ns <- NS(id)
  fluidRow(
    tabBox(
      title = tagList(icon("cogs"),"Cox Proportional Hazard Model"),
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


# <!-- ------------------------- -->
# <!--      server for Cox       -->
# <!-- ------------------------- -->

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
