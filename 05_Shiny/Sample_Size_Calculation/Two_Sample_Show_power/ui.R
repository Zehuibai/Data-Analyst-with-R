
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  titlePanel("Sample size and power calculation"),
  fluidRow(
    column(6,
      selectInput("whichTest", "Analysis Type:",
                  choices = c("Two-sample T-test" = "t.test",
                              "Two-sample Z-test for proportions" = "prop.test"),
                  width=NULL),

      conditionalPanel(condition = "input.whichTest == 't.test'",
                       numericInput("delta",
                                    label = "Diffence in means:",
                                    value = 1,
                                    min=-Inf,
                                    max=Inf,
                                    step=1,
                                    width=NULL),
                       numericInput("stdDev",
                                    label = "SD of data:",
                                    value = 1,
                                    min=.Machine$double.eps,
                                    max=Inf,
                                    step=1,
                                    width=NULL)),
      conditionalPanel(condition = "input.whichTest == 'prop.test'",
                       numericInput("p1",
                                    label = "Probability in group 1",
                                    value = .3,
                                    min=.Machine$double.eps,
                                    max=1-.Machine$double.eps,
                                    step=.01,
                                    width=NULL),
                       numericInput("p2",
                                    label = "Probability in group 2",
                                    value = .7,
                                    min=.Machine$double.eps,
                                    max=1-.Machine$double.eps,
                                    step=.01,
                                    width=NULL))
    ),
    column(6,
           numericInput("alpha",
                        label = "alpha:", value = 0.05,
                        min=0, max=1, step=0.01,
                        width=NULL),
           numericInput("power",
                        label = "Power:", value = 0.8,
                        min=0, max=1, step=0.05,
                        width=NULL),
           numericInput("n",
                        label = "Sample size:", value = 30,
                        min = 2, max = Inf, step=5,
                        width=NULL)
    )
  ),
  fluidRow(
    column(4,
           radioButtons("alternative", label = "Alternative:",
                        choices = c("Two sided"="two.sided",
                                    "One sided"="one.sided"),
                        inline = TRUE)
    ),
    column(4,
      radioButtons("solveFor", label = "Solve for:",
                   choices = c("Power"="Power",
                               "Sample size"="Sample size"),
                   inline = TRUE)
    ),
    column(4,
           bsModal("powerCurve", "", "plotBut", size = "large",
                   plotOutput("power.curve")),
           bsButton(inputId = "plotBut", label = "Power curve",
                    style="info", icon=icon("line-chart")),
           tags$style(type='text/css', "#plotBut {margin-top: 15px;}")
    )
  )
))
