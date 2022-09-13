
modules <- c("Value1","Value2")


moduleBodyUIWrapper <- function (id){
  itemsubs <- lapply(modules, function(mdl){
    moduleBodyUI(mdl)
  })

  do.call(tabItems, itemsubs)
}

moduleBodyUI <- function(id){
  ns <- NS(id)
  #moduleServer(
   # id, 
    #function(input, output, session){
      tabItem(tabName = paste(id),
              modulePageContentUI(id),
              uiOutput(paste(id))
      )
    #}
 # )
}


mododuleSidebarUI <- function(id) {
  ns <- NS(id)
  menuItem(paste("Module Testing"),
             tabName = "Testing",
             icon = icon("th"),
           lapply(modules, function(mdl){
             menuSubItem(paste(mdl), tabName = paste(mdl), href = NULL)
           })
  )
}

modulePageContentUI <- function(id) {
  ns <- NS(id)
  fluidRow(
    box(width = 12,
      title = "Select Cols",
      selectInput(ns("select"), "Select columns", names(iris), multiple = TRUE),
      plotlyOutput(ns("plot")),
      verbatimTextOutput(ns("selected"))
    )
  )
}

moduleTestServer <- function(id){
  moduleServer(
    id, 
    function(input, output, session){
      ns <- session$ns
      print(id)
      
      output[["plot"]] <- renderPlotly({
        p <- iris %>% 
          plot_ly(x=~Sepal.Length, y = ~Sepal.Width, color =~Species, type = "scatter" , mode = "markers", source = id) 
        p %>% layout(clickmode = "event+select") %>% 
          event_register("plotly_click")
       })
        eventClick <- reactive(event_data("plotly_click", source = id)) %>% debounce(500)
        
        observeEvent(eventClick(), {
          output$selected <- renderPrint({
            d <- eventClick()
            d
          })
        })
  
    }
  )
}

#### UI
app_ui <- function(request) {
  tagList(
    dashboardPage(
      header = dashboardHeader(title = "module_test"),
      sidebar = dashboardSidebar(
        sidebarMenu(id = "tabs",
                    mododuleSidebarUI("A"))
      ),
      #
      body =  dashboardBody(
        moduleBodyUIWrapper("A")
        )      , 
      title = "Testing Shiny modules"
    )
  )
}

### Server
app_server <- function(input, output, session) {
  lapply(modules, function(mdl){
    moduleTestServer(mdl)
  }) 
}

shinyApp(app_ui, app_server)

