### Packages
library(shiny)
library(purrr)
library(shinydashboard)
library(plotly)
library(DT)
library(shinyWidgets)

### Load prepared meta data for the study
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()
source("ShinyCSM_StudyMetaData_D02.R")
source("ShinyCSM_Functions_D02.R")
source("ShinyCSM_LoadUI_D01.R")


ui <- function(request){
    #modules <-  CSM.meta.continuous$item
    print("Loading user interface")
    tagList(
        dashboardPage(
            header = dashboardHeader(title = "CSM dev"),
            sidebar = dashboardSidebar( 
                sidebarMenu(id = "tabs", UISidebar())
            ),
            body = dashboardBody(
                    UIBodyWrapper()
                )
        )
    )
        
        

}

modularServerCont <- function(id){
    moduleServer(
        id,
        function(input, output, session){
            ns <- session$ns
            #print(paste0("Loading functions for ", id,"...") )
            #contScatterServer(input, output, session, source = id)
            
          #  visit.display <- unique(CSM.data.continuous$event_name)
            source <- id
          # observeEvent(input$visit.selection, {
          #  visit <- reactiveVal({input$visit.selection})
          # })
          # 
            plot.data <- reactiveVal({value = plot.df <- CSM.data.continuous %>% 
                                    filter(Entity == id) %>% 
                                    mutate(display = T) 
                        })
            subject.data <- reactiveVal({
                value = subject.df <- CSM.data.continuous %>% 
                    filter(Entity == id) %>% 
                    mutate(sub.display = 1)
            })
            
            
           observe({#Event(input$visit.selection, {
             req(input$visit.selection, input$site.selection)
             
               visit <- reactiveVal({value = input$visit.selection})
               site <- reactiveVal({value = input$site.selection})
             
              # print(visit())
              # print(site())
             if (visit() == "ALL"){
                 plot.df <- plot.df %>% mutate(vdisplay = T)
             } else {
                 plot.df <-  plot.df %>% mutate(vdisplay = ifelse(event_name == visit(),T,F))
             }
               
             if (site() == "ALL"){
                 plot.df <- plot.df %>% mutate(sdisplay = T)
             } else {
                 plot.df <- plot.df %>% mutate(sdisplay = ifelse(site_code == site() ,T,F))
             }
               plot.df <- plot.df %>% mutate(display = vdisplay & sdisplay)
            
            output[["cont.scatter.plot"]] <- renderPlotly({
                p <- plot.df %>% filter(display) %>% 
                    plot_ly(source = source, y = ~value, x = ~subject_id, color = ~color, type = "scatter", mode = "markers", 
                            marker = list(size = ~rscore, sizeref = 0.1, sizemode = 'area' ), 
                            text = ~subject_id#,
                            #hovertemplate = paste(
                            #   "<b>%{text}</b><br><br>",
                            #   "%{yaxis.title.text}: %{y:$,.0f}<br>",
                            #   "%{xaxis.title.text}: %{x:.0%}<br>",
                            #   "Risk score: %{marker.size:,}",
                            #   "<extra></extra>"
                            )
                p %>% layout(clickmode = "event+select") %>% 
                    event_register("plotly_click")
            })
           })
            
            eventClick <- reactive(event_data("plotly_click", source = source)) %>% debounce(500)
            
            observeEvent(eventClick(), {
                subject.id <- reactiveVal({ eventClick()["x"]})
                
                print(subject.id)
                
                plot.subject.df <- subject.df %>% 
                    mutate(sub.display = ifelse(subject_id == as.character(subject.id()) , subject_id, "All other subjects"))%>% 
                    group_by(sub.display, visn) %>% 
                    summarise(value = mean(value, na.rm=T), .groups = "keep") %>% 
                    ungroup()
                
                print(plot.subject.df)
                
                
                output$selected <- renderPrint({
                    d <- eventClick()
                    d["x"]
                })
                output[["cont.subj.line.plot"]] <- renderPlotly({
                    q <- plot.subject.df  %>% 
                        plot_ly(y = ~value, x = ~visn, linetype  = ~sub.display,
                                type = 'scatter', 
                                 mode = 'lines+markers'# ,connectgaps = TRUE
                               #  marker = list(size = ~rscore, sizeref = 0.1, sizemode = 'area' ), 
                               # text = ~subject_id#,
                                #hovertemplate = paste(
                                #   "<b>%{text}</b><br><br>",
                                #   "%{yaxis.title.text}: %{y:$,.0f}<br>",
                                #   "%{xaxis.title.text}: %{x:.0%}<br>",
                                #   "Risk score: %{marker.size:,}",
                                #   "<extra></extra>"
                        )
                })  
            })
        }
    )
}





server <- function(input, output, session){
    #modules <- CSM.meta.continuous$item
    #source("Z:/CSM/Shiny/Shiny R Scripts/ShinyCSM_Functions_D01.R")
    
    lapply(modules, function(mdl){
            modularServerCont(mdl)
        #modularServerSite(mdl)
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


