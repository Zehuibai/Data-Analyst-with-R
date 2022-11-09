# UI with tabs and conditional panels [SHINYDASHBOARD ONLY]

# setwd("~/R/R Shiny")
# shiny::runApp('PK_Sim')

library(shiny)
library(shinydashboard)

sidebar <- dashboardSidebar( width=225,
  hr(),
            sidebarMenu(id= "tabs",
                        menuItem("Model", icon = icon("chevron-circle-right"),
              checkboxInput("bolus", "IV Bolus", TRUE),
              checkboxInput("oral", "Two-Compartment Oral", FALSE),
              numericInput("num5", label = h4("Duration of Model (Days)"), value = 10),
              numericInput("num6", label = h4("Upper Tpx Limit (ng/mL)"), value = 60),
              numericInput("num7", label = h4("Lower Tpx Limit (ng/mL)"), value = 20)
                        ),
                        menuItem("PK Parameters", icon = icon("chevron-circle-right"),
              numericInput("num1", label = h4("Clearance"), value = 5),
              numericInput("num1.5", label = h4("Volume"), value = 10),
              numericInput("num2", label = h4("Initial Plasma Conc."), value= 0),
              conditionalPanel(condition= "input.oral == 1 ",
                  sliderInput("ka", "ka:", value = 6, min = 0.1, max = 10, step=0.1))
                        ),
                        menuItem("Dosing", icon = icon("chevron-circle-right"),
              numericInput("num4", label = h4("Dose (mg)"), value = 30),
              numericInput("num3", label = h4("Duration of Therapy (Days)"), value = 5), 
              sliderInput("slid1", "Frequency per Day:", value = 1, min = 1, max = 4, step=1)
)
),
hr()
)
  
body <- dashboardBody(
    tabItem(tabName = "plot", 
           box(width = NULL, plotOutput("plot"), collapsible = TRUE, 
           title = "Simulated Simulated PK Model", status = "primary", solidHeader = TRUE))
            )
   # tabItem(tabName = "plot2", 
    #   conditionalPanel(condition = "input.oral == 1",
     #       box(width = NULL, plotOutput("plot2"), collapsible = TRUE, 
      #          title = "Simulated 2-Compartment Oral PK Model", status = "primary", 
       #         solidHeader = TRUE))
        #          ))      


dashboardPage(
  dashboardHeader(title= "Simulated PK Model Plot" ),
  skin= "purple",
  sidebar,
  body
  )
