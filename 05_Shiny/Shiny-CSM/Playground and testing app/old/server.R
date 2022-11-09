#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
library(DT)


### Load results from CSM scripts
CSM.data.continuous <- read.csv("Z:/CSM/Shiny/ATR_CSM_Continuous_Overall.csv")

### Load prepared meta data for the study
source("C:/Users/rpaul/Projects/R Scripts/Shiny CSM/ShinyCSM/ShinyCSM_StudyMetaData_D01.R")
source("C:/Users/rpaul/Projects/R Scripts/Shiny CSM/ShinyCSM/ShinyCSM_Functions_D01.R")


shinyServer(function(input, output, session){
  ### Create the continuous CSM plots
  output$plot1 <- renderPlotly( plot1<- plot.xy() %>% CSM.cont.plot()  )
  output$plot2 <- renderPlotly( plot2<- plot.xy() %>% CSM.cont.plot()  )
  
  ############################################################################################
  # Pre-render all necessary menu items from the meta data.
  # Each item in the meta file should get its own item in the side bar
  ############################################################################################
  # This is to get the desired menuItem selected initially. 
  # selected=T seems not to work with a dynamic sidebarMenu.
  observeEvent(session, {
    updateTabItems(session, "tabs", selected = "initial")
  })
  

  # Get all item names as reactive values
  cont.overall.subitems <- reactiveVal(value = CSM.meta.continuous$item)
  
  # Dynamic sidebar menu 
  output$CSM.UI.sidebar <- renderUI({
    sidebarMenu(id = "tabs",
                ### Create a landing page
                menuItem("Start", tabName = "initial", icon = icon("star"), selected = T),
                ### Create the continuous overall section
                menuItem("Continuous overall", id = "CSM_ID_ContOverall", tabName = "CSM_ID_ContOverall",  icon = icon("dashboard"), 
                         startExpanded = T,
                         lapply(cont.overall.subitems(), function(x) {
                           menuSubItem( paste(CSM.meta.continuous$name[which(CSM.meta.continuous$item == x)]), 
                                        tabName = paste0("CSM_ID_ContOverall_", x),
                                        href = NULL
                                        )
                                        
                           })
                         ),
                ### Enter continuous site comparison
                ### Enter categorical
                ### Enter ordinal
                
                ### Setup: To be removed?
                menuItem("Setup", tabName = "setup")
    )
  })
  
  ### Dynamically create content 
  #   Note that everything so far is done server-side. The UI has (nearly) nothing to do
  output$CSM.UI.page.content <- renderUI({
    
    itemsSubs <- lapply(cont.overall.subitems(), function(x){
      tabItem( #paste(CSM.meta.continuous$name[which(CSM.meta.continuous$item == x)]) , 
               tabName = paste0("CSM_ID_ContOverall_", x), 
               fluidRow(
                 column(width = 12,
                        box(title =  paste0(CSM.meta.continuous$name[which(CSM.meta.continuous$item == x)], 
                                            " [",
                                           CSM.meta.continuous$unit[which(CSM.meta.continuous$item == x)],
                                           "]"
                                           ), 
                            ### Render the overall raw value comparison
                            renderPlotly({  
                                CSM.data.continuous %>% 
                                  filter(Entity == paste(gsub("CSM_ID_ContOverall_", "",paste(x), fixed = T)))  %>% 
                                  CSM.cont.plot() 
                               }), 
                           # textInput(inputId = "text2", paste(input$tabs)),
                            textInput(inputId = "text", "test"),
                            
                            #plotlyOutput("graph"),
                            #paste0("CSM_ID_ContOverall_", x),
                            #paste(gsub("CSM_ID_ContOverall_", "",paste(x), fixed = T)),
                            width = NULL)
                 )
               ),
               fluidRow(
                 column(width = 6,
                        box(#title = paste("Trend for subject",  event_data("plotly_click")$x), 
                           # div(style = 'overflow-x: scroll',dataTableOutput("CSM_overall_checks")),
                         # testThing(),
                            width = NULL),
                        #box(title = "Test Box for debug", verbatimTextOutput("selecting"), width = NULL)
                 ),
                 column(width = 6,
                        # box(title = "Patient information", div(style = 'overflow-x: scroll',dataTableOutput("pat_table")), width = NULL)
                 )
               ),
               uiOutput(paste0("CSM_ID_ContOverall_", x))
               
               )
    })
    
    items <- c(
      list(
        tabItem(tabName = "initial",
                "Welcome on the initial page!"
        )
      ),
      
      itemsSubs,
      
      list(
        tabItem(tabName = "setup",
                
                textInput("add_subitem", "Add subitem"),
                actionButton("add", "add!"),
                
                selectInput("rm_subitem", "Remove subitem", choices = cont.overall.subitems()),
                actionButton("rm", "remove!")
        )
      )
    )
    
    do.call(tabItems, items)
  })
  
  # dynamic content in the dynamic subitems #
  observe({ 
    lapply(cont.overall.subitems(), function(x){
      output[[paste0("sub_", x)]] <- renderUI ({
        list(fluidRow(
          box("hello ", x)
        )
        )
      })
    })
  })
  
  # add and remove tabs
  observeEvent(input$add, {
    req(input$add_subitem)
    
    s <- c(cont.overall.subitems(), input$add_subitem)
    cont.overall.subitems(s)
    
    updateTabItems(session, "tabs", selected = "setup")
  })
  
  observeEvent(input$rm, {
    req(input$rm_subitem)
    
    s <- cont.overall.subitems()[-which(cont.overall.subitems() == input$rm_subitem)]
    cont.overall.subitems(s)
    
    updateTabItems(session, "tabs", selected = "setup")
  })
  

  
  ############################################################################################
  # Functions to render output graphs and tables
  #
  ############################################################################################
  plot.xy <- reactive(
    {
      #CSM.data.continuous %>% filter(Entity == paste(gsub("CSM_ID_ContOverall_", "",paste(input$sidebartabs), fixed = T)) )
    }
  )
  
  #output$selecting <- renderPrint({
  #  d <- event_data("plotly_click")
  #  if (is.null(d)) "Brush points appear here (double-click to clear)" else d
  #})
  
  ### Patient info table in continuous CSM plots
  #output$pat_table <- renderDataTable({
  #  selected <- event_data("plotly_click")$x
  #  if (is.null(selected)){ 
  #    #datatable("iris")
  #  } else {
  #    datatable(CSM.cont.table(CSM.data.continuous, selected)) 
  #  }
  #}
  #)
  ### CSM check results for the given value
  #output$CSM_overall_checks <- renderDataTable({
  #  selected <- event_data("plotly_click")$x
  #  if (is.null(selected)){ 
  #    #datatable("iris")
  #  } else {
  #    datatable(CSM.cont.check.table(plot.xy(), selected)) 
  #  }
  #}
  #) 
  
})


