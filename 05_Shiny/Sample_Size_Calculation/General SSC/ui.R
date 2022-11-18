
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Simple Sample Size Calculator"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("power",
                  "Power",
                  min = 0.5,
                  max = 0.9,
                  value = 0.8,step = 0.1),
      sliderInput("effect",
                  "Effect Size",
                  min = 0.2,
                  max = 1.8,
                  value = 0.8,step = 0.1),
      textInput("sig.level","Level of Significance",value = 0.05),
      radioButtons("alternative", "Alternative", c("Two-sided"="two.sided", "Greater" = "greater", "Less"="less"),"two.sided"),
      radioButtons("type", "Type of test", c("T -test"="t", "Propotions"="prop"),"t"),
      radioButtons("type.of.t", "Type of t-test", c("Two Sample"="two.sample", "One Sample"="one.sample","Paired"="paired"),"two.sample")

    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Calculation",verbatimTextOutput("sSizeCalc")),
        tabPanel("View", htmlOutput("view"))
      )
    )
  )
)
)
