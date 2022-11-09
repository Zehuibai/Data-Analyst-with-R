# Library for shiny
library(shiny)
library(shinythemes)
library(shinyvalidate)
library(shinyjs)
library(shinyalert)
library(shinydashboard)

# Libraries for survival analysis
library(tidyverse)
library(knitr)
library(survminer)
library(survival)
library(dplyr)
library(broom)
library(ggplot2)
library(comprehenr)


# Define UI for application that draws a histogram
ui <- fluidPage(
    #theme
    title = "Survival Analysis",
    theme = shinytheme("darkly"),
    useShinyjs(),  
    # Application title
    titlePanel(
        h1("Survival Analysis", align = "center")),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            div(id = "form",
                h3("Inputs"),
                br(),
                fileInput("file1", "Choose CSV File",
                          multiple = FALSE,
                          accept = c("text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")),
                br(),
                uiOutput("time"),
                uiOutput("status"),
                uiOutput("factor"),
                conditionalPanel(
                  condition = "input.factor != 1",
                  hidden(uiOutput("with")),
                  hidden(uiOutput("against"))
                )),
            
            div(style="",
                actionButton("submit", label = "Submit", 
                                      style="background-color: #337ab7;"),
                actionButton("reset",label = "Reset",
                                      style="background-color: #337ab7;")),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            hidden(dataTableOutput("contents")),
            br(),
            uiOutput("summary_table_heading"),
            br(),
            dataTableOutput("survivalSummary"),
            br(),
            uiOutput("mean_table_heading"),
            br(),
            dataTableOutput("mean_table"),
            br(),
            uiOutput("median_table_heading"),
            br(),
            dataTableOutput("median_table"),
            br(),
            uiOutput("plot_heading"),
            br(),
            plotOutput("kaplan_meier_plot")
        )
    )
)










# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    # Adding upload data to reactive state
    uiValues <- reactiveValues(km_plot = NULL,
                               fileData = NULL)
  
    observe({
        if(!is.null(input$file1$datapath))
        {
            uiValues$fileData <- read.csv(input$file1$datapath)
        }
    })
    
    
    # Select input for time
    output$time <- renderUI({
        req(input$file1)
        tryCatch(
            {
                df <- read.csv(input$file1$datapath)
                dataFields <- c("Select a field")
                column_names <- sort(colnames(df))
                dataFields <- append(dataFields,column_names)
                selectInput("time",
                                   label = h3("Time"),
                                   choices = dataFields)
            },
            error = function(e){
                stop(safeError(e))
            }
        )
    })
    
    # Select input for status
    output$status <- renderUI({
        req(input$file1)
        tryCatch(
            {
                df <- read.csv(input$file1$datapath)
                dataFields <- c("Select a field")
                column_names <- sort(colnames(df))
                dataFields <- append(dataFields,column_names)
                selectInput("status",
                            label = h3("Status"),
                            choices = dataFields)
            },
            error = function(e){
                stop(safeError(e))
            }
        )
    })
    
    # Select input for factors
    output$factor <- renderUI({
        req(input$file1)
        tryCatch(
            {
                df <- read.csv(input$file1$datapath)
                dataFields <- c("Select a field")
                column_names <- sort(colnames(df))
                dataFields <- append(dataFields,column_names)
                selectInput("factor",
                            label = h3("Factor"),
                            choices = dataFields)
            },
            error = function(e){
                stop(safeError(e))
            }
        )
    })
    
    
    # Select input for with
    output$with <- renderUI({
      tryCatch(
        {
          selectInput("withFactors",
                      label = h3("With"),
                      choices = NULL)
        },
        error = function(e){
          stop(safeError(e))
        }
      )
    })
    
    # Reset action
    observeEvent(input$reset,{
        removeUI(selector = "#summary_table_heading")
        removeUI(selector = "#mean_table_heading")
        removeUI(selector = "#median_table_heading")
        removeUI(selector = "#survivalSummary")
        removeUI(selector = "#contents")
        removeUI(selector = "#mean_table")
        removeUI(selector = "#median_table")
        removeUI(selector = "#plot_heading")
        output$kaplan_meier_plot <- NULL
        updateSelectInput(session,"time",selected = "Select a field")
        updateSelectInput(session,"status",selected = "Select a field")
        updateSelectInput(session,"factor",selected = "Select a field")
        updateSelectInput(session,"with",selected = "Select a field")
        updateSelectInput(session,"against",selected = "Select a field")
    })
    
    # Submit action
    observeEvent(input$submit,{
        if(is.null(input$file1))
        {
          shinyalert("Please select a file", type = "error")
        }
        else if(input$time == "Select a field")
        {
          shinyalert("Please choose an option for 'Time'", type = "error")
        }
        else if(input$status == "Select a field")
        {
          shinyalert("Please choose an option for 'Status'", type = "error")
        }
        else if(input$factor == "Select a field")
        {
          shinyalert("Please choose an option for 'Factor'", type = "error")
        }
        else if(input$with == "Select a field")
        {
          shinyalert("Please choose an option for 'With'", type = "error")
        }
        else if(input$against == "Select a field")
        {
          shinyalert("Please choose an option for 'Against'", type = "error")
        }
        else
        {
          # Reading and getting individual columns.
          tryCatch(
            {
              df <- read.csv(input$file1$datapath)
              time <- as.character(input$time)
              status <- as.character(input$status)
              factors <- as.character(input$factor)
              
              time_data <- df[,time]
              status_data <- df[,status]
              factors_data <- df[,factors]
              
              final_data <- data.frame(time = time_data,
                                       status = status_data,
                                       factors = factors_data)
              
              finalized_data <- final_data %>% select(time,
                                                      status,
                                                      factors) %>%
                filter(factors %in% c(input$with,input$against))
              
              
              time_data <- finalized_data$time
              status_data <- finalized_data$status
              factor_data <- as.factor(finalized_data$factors)
              survival <- Surv(time = time_data, event = status_data)
              Survfit <- do.call(survfit,list(formula = Surv(time = time_data, event = status_data) ~ factor_data, data = finalized_data))
              res <- summary(Survfit)
              
              cols <- lapply(c(2:10,15,16) , function(x) res[x])
              tbl <- do.call(data.frame, cols)
              head(tbl)
              tbl$strata <- str_split(as.character(tbl$strata),"=",simplify = T)[,2]
              
              output$summary_table_heading <- renderUI({
                h3("Survival analysis summary")
              })
              
              output$survivalSummary <- renderDataTable({
                return(tbl)
              })
              
              # Mean of survival table
              mean_survival_table <- data.frame(c1 = c(input$with, input$against,"overall"),
                                                c2 = c(
                                                  round(mean(tbl[tbl$strata == input$with,5]),2),
                                                  round(mean(tbl[tbl$strata == input$against,5]),2),
                                                  round(mean(tbl$surv),2)
                                                ),
                                                c3 = c(
                                                  round(mean(tbl[tbl$strata == input$with,6]),2),
                                                  round(mean(tbl[tbl$strata == input$against,6]),2),
                                                  round(mean(tbl$std.err),2)
                                                ),
                                                c4 = c(
                                                  round(mean(tbl[tbl$strata == input$with,10]),2),
                                                  round(mean(tbl[tbl$strata == input$against,10]),2),
                                                  round(mean(tbl$lower),2)
                                                ),
                                                c5 = c(
                                                  round(mean(tbl[tbl$strata == input$with,11]),2),
                                                  round(mean(tbl[tbl$strata == input$against,11]),2),
                                                  round(mean(tbl$upper),2)
                                                ))
              
              names(mean_survival_table) = c(factors,"Estimate", "Std.Error", "Lower bound", "Upper bound")
              
              output$mean_table_heading <- renderUI({
                h3("Means of survival Times")
              })
              
              output$mean_table <- renderDataTable({
                return(mean_survival_table)
              })
              
              # Medians of survival table
              tbl_sorted = tbl[order(tbl$surv, tbl$std.err, tbl$lower, tbl$upper),]
              median_survival_table <- data.frame(c1 = c(input$with, input$against,"overall"),
                                                  c2 = c(
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$with,5]),2),
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$against,5]),2),
                                                    round(median(tbl_sorted$surv),2)
                                                  ),
                                                  c3 = c(
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$with,6]),2),
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$against,6]),2),
                                                    round(median(tbl_sorted$std.err),2)
                                                  ),
                                                  c4 = c(
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$with,10]),2),
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$against,10]),2),
                                                    round(median(tbl_sorted$lower),2)
                                                  ),
                                                  c5 = c(
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$with,11]),2),
                                                    round(median(tbl_sorted[tbl_sorted$strata == input$against,11]),2),
                                                    round(median(tbl_sorted$upper),2)
                                                  ))
              
              names(median_survival_table) = c(factors,"Estimate", "Std.Error", "Lower bound", "Upper bound")
              
              output$median_table_heading <- renderUI({
                h3("Medians of survival Times")
              })
              
              output$median_table <- renderDataTable({
                return(median_survival_table)
              })
              
              # plot heading
              output$plot_heading <- renderUI({
                h3("Survival plot")
              })
              
              uiValues$km_plot <- ggsurvplot(fit = Survfit, 
                                             data = finalized_data,
                                             ####### Format Title #######
                                             title = "Overall Survival",
                                             subtitle = "Stratified By Mutations",
                                             pval = T,
                                             pval.method = T,
                                             font.title = c(22, "bold", "black"),
                                             ggtheme = theme_classic() + theme(plot.title = element_text(hjust = 0.5, face = "bold"))+ # theme_classic will give a white background with no lines on the plot
                                               theme(plot.subtitle = element_text(hjust = 0.5, size = 16, face = "italic")), 
                                             ####### Format Axes #######
                                             xlab="Months", # changes xlabel,
                                             ylab = "Survival Probability",
                                             font.x=c(18,"bold"), # changes x axis labels
                                             font.y=c(18,"bold"), # changes y axis labels
                                             font.xtickslab=c(14,"plain"), # changes the tick label on x axis
                                             font.ytickslab=c(14,"plain"),
                                             ####### Format Curve Lines #######
                                             palette = c("red","black"),
                                             ####### Censor Details ########
                                             censor = TRUE, # logical value. If TRUE, censors will be drawn,
                                             censor.shape="|",
                                             censor.size = 5,
                                             ####### Confidence Intervals ########
                                             conf.int = FALSE, # To Remove conf intervals use "FALSE"
                                             conf.int.fill = "purple", # fill color to be used for confidence interval
                                             surv.median.line = "hv", # allowed values include one of c("none", "hv", "h", "v"). v: vertical, h:horizontal
                                             ######## Format Legend #######
                                             legend = "top", # If you'd prefer more space for your plot, consider removing the legend
                                             #legend.title = "All Patients",
                                             legend.labs = c(input$with,input$against), # Change the Strata Legend
                                             ######## Risk Table #######
                                             risk.table = TRUE, # Adds Risk Table
                                             risk.table.height = 0.25 # Adjusts the height of the risk table (default is 0.25)
              )
              uiValues$km_plot$plot <- uiValues$km_plot$plot + scale_x_continuous(expand=c(0,0))
              
              output$kaplan_meier_plot <- renderPlot({
                if(is.null(uiValues$km_plot))
                {
                  return()
                }
                else
                {
                  uiValues$km_plot
                }
              })
            },
            error = function(e){
              # stop(safeError(e))
              shinyalert("Something went wrong!!!! Please check your inputs", type = "error")
            }
          )
        }
    })
    
    # Comparing mutations
    # Select inputs for with
    output$with <- renderUI({
      df <- uiValues$fileData
      if(input$factor == "Select a field" || input$factor == "1")
      {
        return(NULL)
      }
      else
      {
        dataFields <- c("Select a field")
        col_values = unique(df[,input$factor[1]])
        dataFields <- append(dataFields,col_values)
        selectInput("with",
                    label = h4("With"),
                    choices = dataFields)
      }
    })
    
    # Select inputs for with
    output$against <- renderUI({
      df <- uiValues$fileData
      if(input$with == "Select a field")
      {
        return(NULL)
      }
      else
      {
        dataFields <- c("Select a field")
        col_values = unique(df[,input$factor[1]])
        dataFields <- append(dataFields,col_values)
        dataFields <- dataFields[!dataFields %in% c(input$with)]
        selectInput("against",
                    label = h4("Against"),
                    choices = dataFields)
      }
    })
    
    # Based on the change in factors and with dropdown hidden UI elements are shown
    observeEvent(input$factor,{show("with")},ignoreInit = T)
    observeEvent(input$with,{show("against")},ignoreInit = T)
}

# Run the application 
shinyApp(ui = ui, server = server)
