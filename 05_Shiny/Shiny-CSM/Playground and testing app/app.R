### Packages
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

### Load prepared meta data for the study
source("Z:/CSM/Shiny/Shiny R Scripts/ShinyCSM_StudyMetaData_D02.R")
source("Z:/CSM/Shiny/Shiny R Scripts/ShinyCSM_Functions_D02.R")
source("Z:/CSM/Shiny/Shiny R Scripts/ShinyCSM_LoadUI_D01.R")

modules <- CSM.meta.continuous$item

ui <- function(request){
  modules <-  CSM.meta.continuous$item
  print("Loading user interface")
  tagList(
    dashboardPage(
      header = dashboardHeader(title = "CSM dev"),
      sidebar = dashboardSidebar( 
        sidebarMenu(id = "tabs", UISidebar("A", modules))
      ),
      body = dashboardBody(
        UIBodyWrapper("A", modules)
      )
    )
  
  )
}



modularServer <- function(id){
  moduleServer(
    id,
    function(input, output, session){
      ns <- session$ns
      print(paste0("Loading functions for ", id,"...") )
      contScatterServer(id)
    }
  )
}





server <- function(input, output, session){
  #modules <- CSM.meta.continuous$item
  source("Z:/CSM/Shiny/Shiny R Scripts/ShinyCSM_Functions_D02.R")
  
  lapply(modules, function(mdl){
    modularServer(mdl)
  }) 
#output$plot1 <- renderPlotly( plot1<- plot.xy() %>% CSM.cont.plot()  )
#output$plot2 <- renderPlotly( plot2<- plot.xy() %>% CSM.cont.plot()  )

############################################################################################
# Pre-render all necessary menu items from the meta data.
# Each item in the meta file should get its own item in the side bar
############################################################################################
# This is to get the desired menuItem selected initially. 
# selected=T seems not to work with a dynamic sidebarMenu.
#observeEvent(session, {
#  updateTabItems(session, "tabs", selected = "initial")
#})
#
#
## Get all item names as reactive values
#
#cont.overall.subitems <- reactiveVal(value = CSM.meta.continuous$item)
#
## Dynamic sidebar menu 
#output$CSM.UI.sidebar <- renderUI({
#  sidebarMenu(id = "tabs",
#              ### Create a landing page
#              menuItem("Start", tabName = "initial", icon = icon("star"), selected = T),
#              ### Create the continuous overall section
#              menuItem("Continuous overall", id = "CSM_ID_ContOverall", tabName = "CSM_ID_ContOverall",  icon = icon("dashboard"), 
#                       startExpanded = T,
#                       lapply(cont.overall.subitems(), function(x) {
#                         menuSubItem( paste(CSM.meta.continuous$name[which(CSM.meta.continuous$item == x)]), 
#                                      tabName = paste0("CSM_ID_ContOverall_", x),
#                                      href = NULL
#                         )
#                         
#                       })
#              )
#  )
#})
#
#
#### Dynamically create content 
##   Note that everything so far is done server-side. The UI has (nearly) nothing to do
#output$CSM.UI.page.content <- renderUI({
#  
#  
#  itemsSubs <- lapply(cont.overall.subitems(), function(x){
#    #Entity <- reactiveVal(value = paste(x))
#      
#    button <- reactive({
#      actionButton(inputId = paste0("button",x), "Drück mich")
#    })
#    text2 <- reactive({
#      textInput(inputId = paste0("text2",x), "test")
#    })
#    
#    eval(parse(text=
#                 paste0(
#                    "observeEvent(input$button",x,", {
#                      req(input$button",x,")
#                      updateTextInput(session,'text2",x,"', label = 'blubb')
#                    })"
#                 )
#      )
#    )
#    
#    x <- isolate(x)
#    tabItem(# paste(Entity) , 
#      tabName = paste0("CSM_ID_ContOverall_", x), 
#      fluidRow(
#        column(width = 12,
#               box(title =  paste0(CSM.meta.continuous$name[which(CSM.meta.continuous$item == x)], 
#                                   " [",
#                                   CSM.meta.continuous$unit[which(CSM.meta.continuous$item == x)],
#                                   "]"
#               ), 
#               button(),
#               text2(),
#               
#               width = NULL)
#        )
#      ),
#      uiOutput(paste0("CSM_ID_ContOverall_", x))
#      
#    )
#  })
#  
#  items <- c(
#    itemsSubs
#  )
#  
#  
#  
#  do.call(tabItems, items)
#  })
}

shinyApp(ui, server)


