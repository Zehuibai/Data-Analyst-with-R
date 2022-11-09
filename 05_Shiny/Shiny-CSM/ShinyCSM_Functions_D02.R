### Generic scatter plot function
#CSM.cont.plot <- function(df){
#  df %>% plot_ly(y = ~value, x = ~subject_id, color = ~color, type = "scatter", mode = "markers",
#                 marker = list(size = ~rscore, sizeref = 0.1, sizemode = 'area', source = "cont.scatter.plot"), 
#                 text = ~subject_id#,
#                 #hovertemplate = paste(
#                #   "<b>%{text}</b><br><br>",
#                #   "%{yaxis.title.text}: %{y:$,.0f}<br>",
#                #   "%{xaxis.title.text}: %{x:.0%}<br>",
#                #   "Risk score: %{marker.size:,}",
#                #   "<extra></extra>"
#                # )
#  ) %>% 
#    layout(clickmode = "event+select") %>% 
#    event_register("plotly_click")
#}
#
### Generic function for patient info table
#CSM.cont.table <- function(df, id){
#  df %>% filter(subject_id == id) %>% 
#    pivot_wider(id_cols = c("visn"), names_from = "ent.name", values_from ="value")
#}#
### Generic function for value CSM check results
#CSM.cont.check.table <- function(df, id){
#  df %>% filter(subject_id == id ) %>% 
#    pivot_longer(cols = c("F1", "F2", "F3", "F4"), names_to = "F.Check", values_to = "Suspcious") %>% 
#    left_join(a_CSM.checks, by = "F.Check") #%>% 
#  #select(Check.txt, Suspcious) %>% replace_na(list(Suspicious = 0))
#}

#
#### Modularization functions
#buildContUI <- function(id){
#  namespace <- NS(id)
#  x <- id
#  tabItem(# paste(Entity) , 
#    tabName = id,#paste0("CSM_ID_ContOverall_", x), 
#    fluidRow(
#      column(width = 12,
#             box(title =  paste0(CSM.meta.continuous$name[which(CSM.meta.continuous$item == x)], 
#                                 " [",
#                                 CSM.meta.continuous$unit[which(CSM.meta.continuous$item == x)],
#                                 "]"
#             ), 
#             #cont.scatter.plot(),
#             #visit.selection(),
#             
#             visitSelectionUi(x),
#             siteSelectionUi(x),
#             contScatterPlotUI(x),
#             testButton(x),
#             whichPatientSelectedUI(x),
#             #button(),
#             #text2(),
#             
#             width = NULL)
#      )
#    ),
#    uiOutput(id)#paste0("CSM_ID_ContOverall_", x))
#    
#  )
#}



#   Visit selection
visitSelectionUI <- function(id){
  ### Assign a namespace in which this item is created
  ns <- NS(id)
  #visit.items <- reactiveVal(value = visits)
  tagList(
    selectInput(inputId = ns("visit.selection"), 
                label = "Select visit",
                choices =setNames(c("ALL",visits), 
                                   c("All visits", visit.names) ),
                selected = "ALL")
  )
}
#   Site selection
siteSelectionUI <- function(id){
  ### Assign a namespace in which this item is created
  ns <- NS(id)
  #visit.items <- reactiveVal(value = visits)
  sites <- unique(CSM.data.continuous$site_code)
  tagList(
    selectInput(inputId = ns("site.selection"), 
                label = "Select site",
                choices =setNames(c("ALL", sites), 
                                  c("All sites", sites) ),
                selected = "ALL")
  )
}

#   Continuous scatter plot
#   1) Prepare the output
contScatterPlotUI <- function(id){
  ns <- NS(id)
  tagList(
    plotlyOutput(ns("cont.scatter.plot")),
    verbatimTextOutput(ns("selected"))
  )
}

contSubjectLinePlotUI <- function(id){
  ns <- NS(id)
  tagList(
    plotlyOutput(ns("cont.subj.line.plot"))
  )
}
#   2) Function to draw the scatter plot
#contScatterServer <- function(id, source){
#  moduleServer(
#    id,
contScatterServer <-    function(input, output, session, id){
  source <- id
  ns <- session$ns
  plot.data <- reactiveVal({value = plot.df <- CSM.data.continuous %>% 
    filter(Entity == id) %>% 
    mutate(display = T) 
  })
  
  observe({
    req(input$visit.selection, input$site.selection)
    
    visit <- reactiveVal({value = input$visit.selection})
    site <- reactiveVal({value = input$site.selection})
    
    print(visit())
    print(site())
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
  })    
    output[["cont.scatter.plot"]] <- renderPlotly({
      p <- plot.df %>% filter(display) %>% 
        #filter(Entity == id & 
        #         event_name %in% visit.display &
        #         site_code %in% visit.display) %>% 
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

  
  eventClick <- reactive(event_data("plotly_click", source = source)) %>% debounce(500)
  
  observeEvent(eventClick(), {
    output$selected <- renderPrint({
      d <- eventClick()
      d
    })
  })
}

#}
# )
#}



### START DEBUG

### Which patient is selected
#whichPatientSelectedUI <- function(id){
#  namespace <- NS(id)
#  tagList(
#    
#    #actionButton(inputId = namespace("testbutton2"), label = "Update"),
#    verbatimTextOutput(outputId = namespace("selected"), placeholder = T)
#  )
#}
#
#
#testButton <- function(id, label = "This is a testbutton"){
#  ### Assign a namespace in which this item is created
#  namespace <- NS(id)
#  tagList(
#    actionButton(inputId = namespace("testbutton"), label = label),
#    verbatimTextOutput(outputId = namespace("out"))
#  )
#}
#
#testButtonServer <- function(id) {
#  moduleServer(
#    id,
#    function(input, output, session) {
#      ### Do smth when the button is pressed
#      observeEvent(input$testbutton, {
#        click <- reactive(event_data("plotly_click", source = "cont.scatter.plot"))
#        output$selected <- renderText({click()})
#        output$out <- renderText({
#          id
#        })
#      })
#    }
#  )
#}
#
#
#testSelectServer <- function(id) {
#  moduleServer(
#    id,
#    function(input, output, session) {
#      ### Do smth when the button is pressed
#      observeEvent(input$visit.selection, {
#        output$out <- renderText({
#          input$visit.selection
#        })
#      })
#    }
#  )
#}
#
#
### END DEBUG








