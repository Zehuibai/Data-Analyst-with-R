library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
library(data.table)
library(DT)
library(markdown)
library(survival)
library(survminer)
library(survMisc)

source(file.path("helpers", "ggcoxzph.R"))

source(file.path("helpers", "nonpara_helpers.R"))
source(file.path("helpers", "semipara_helpers.R"))

source(file.path("modules", "nonpara_tableplot_module.R"))
source(file.path("modules", "stratify_module.R"))
source(file.path("modules", "nonpara_module.R"))
source(file.path("modules", "semipara_module.R"))

button_style1 = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
button_style2 = "color: #fff; background-color: #ff9e42; border-color: #ff7f42"

ui<-dashboardPage(
  dashboardHeader(title = "Survival Analysis"),
  dashboardSidebar(
    
    tags$style(".shiny-input-container {margin-bottom: 0px}
                #file1_progress {margin-bottom: 0px}
                .checkbox {margin-top: 0px}"),
    
    sidebarMenu(id="tabs",
                sidebarSearchForm(textId = "searchbar",
                                  buttonId = "searchbtn",
                                  label = "Search..."),
                menuItem("Home",
                         tabName = "Home",
                         icon = icon("home")),
                
                menuItem("Data",
                         tabName = "Data",
                         icon = icon("table")),
                
                menuItem("Sample Size Calculation",
                         tabName = "SSC",
                         icon = icon("table")),
                
                menuItem("Analysis Tools",
                         tabName = "Tools",
                         icon = icon("cogs"),
                         
                         menuSubItem("Non-Parametric Methods",
                                     tabName = "NonPara",
                                     icon = icon("angle-right")),
                         
                         menuSubItem("Semi-Parametric Methods",
                                     tabName ="SemiPara",
                                     icon = icon("angle-right"))
                         )                )
  ),
  
  dashboardBody(
    
    tabItems(
      
      tabItem(tabName = "Home", 
              fluidRow(
                column(11, 
                       includeMarkdown("README.md"),
                       offset = 1)
              )),
      
      tabItem(
        
        tabName = "Data",
        sidebarLayout(
          
          sidebarPanel(
            
            h4(strong("Upload Data", style = "color: steelblue")),
            
            fileInput("file1", HTML("Choose a CSV File: "),
                      accept = c("text/csv", ".csv", "text/comma-separated-values,text/plain"),
                      placeholder = "Example: ovarian {survival}"),
              
            column(12, align = "right", checkboxInput("header", "Header", TRUE)),
            
            radioButtons("separator", "Separator: ", 
                         choices = c(',', ';', Tab='\t'),
                         selected=",", inline=TRUE),
            
            br(),
            
            selectInput("var_time", "Time Variable: ", ""),
            selectInput("var_event", "Event Variable: ", ""),
            
            width = 3
            ),
          
          mainPanel(
            DT::dataTableOutput("DataTable"))
          )
        ),
      
      
   
      
      tabItem(tabName="NonPara", nonPara_UI("nonPara_Panel")),
      tabItem(tabName="SemiPara", semiPara_UI("semiPara_Panel"))
    )
  )
 )



server <- function(input, output, session){
  
  rawData <- reactive({
    inFile <- input$file1
    
    if(!is.null(inFile)) {
      
      read.csv(inFile$datapath,
               header = input$header,
               sep = input$separator)
    }
    else {read.csv(file.path("data", "ovarian.csv"))}
    }
    )
  
  # Time and Event Variable Selection
  observe({
    updateSelectInput(session, "var_time", label = "Time Variable",
                      choices = names(rawData()))
  })
  
  observeEvent(Time(), {
    updateSelectInput(session, "var_event", label = "Event Variable",
                      choices = setdiff(names(rawData()), Time()))
    
  })
  
  observeEvent(input$reset_all,
               {shinyjs::reset("separator")})
  
  Time = reactive({input$var_time})
  Event = reactive({input$var_event})
  
  callModule(nonPara, "nonPara_Panel", data = rawData,
             Time = Time, Event = Event)
  callModule(semiPara, "semiPara_Panel", data = rawData,
             Time = Time, Event = Event)
  
  
  # Output----------
  output$DataTable <- DT::renderDataTable(
    DT::datatable(rawData(), options = list(scrollX = TRUE)) )
}


shinyApp(ui = ui, server = server)