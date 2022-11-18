# ui.R
library(rbokeh)
shinyUI(fluidPage(
  titlePanel("Logistic Regression"),
  
  sidebarLayout(
    sidebarPanel(
      
      sliderInput(inputId = 'the_bias', 
                  label = h4('Base probability'), 
                  min = 0.1, max = 0.9, value = 0.5, step = .05,
                  ticks = FALSE, animate = FALSE),
      
      
      sliderInput(inputId = 'sample_size', 
                  label = h4('Sample size:'), 
                  min = 10, max = 2000, value = 100, step = 10, round = T,
                  ticks = FALSE, animate = FALSE),
      
      
      sliderInput(inputId = 'effect_size', 
                  label = h4('"Effect" size:'), 
                  min = 0, max = 5, value = 0, step = .1, round = FALSE,
                  ticks = TRUE, animate = FALSE),
      
      
      checkboxGroupInput(inputId = "modeltype", 
                         label = h4("Model:"),
                         choices = c("Linear" = 'linear',
                                     "Logistic" = 'logistic',
                                     "Local smoother" = 'loess'),
                         selected = NULL,
                         inline=T),
      
      
      checkboxGroupInput(inputId='options', 
                         label = h4('Options:'),
                         choices = c("Model summary" = 'summary_output',
                                     "Jitter points" = 'jitter',
                                     "Mark intercept" = 'intercept',
                                     "Replicable results" = 'fixed_seed'),
                         selected = NULL)
    ), 
    
    mainPanel( rbokehOutput("plot_bokeh"),
               conditionalPanel(condition="input.options.indexOf('summary_output') != -1",
                                verbatimTextOutput("summary"))
    ))))
  