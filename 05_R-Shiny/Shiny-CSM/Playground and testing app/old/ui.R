#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

### Dashboard page always expects 3 parts:
# Header, sidebar, body. Alternatively this can be done:
# header <- dashboardHeader()
#
# sidebar <- dashboardSidebar()
#
# body <- dashboardBody()
#
# dashboardPage(header, sidebar, body)
#
dashboardPage(
    dashboardHeader(title = "CSM"),
    
    
    dashboardSidebar( 
        uiOutput("CSM.UI.sidebar")
    ),
    
    dashboardBody(
        uiOutput("CSM.UI.page.content")
    )
    

)
 