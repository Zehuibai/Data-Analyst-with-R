library(shiny)
library(ggplot2)
library(rbokeh)
source('./ext/logistic.R')

options(digits.secs=4)


# Define server logic to manage learning about logistic regression
shinyServer(function(input, output) {
  
  
  data_reactive <- reactive({
    if ('fixed_seed' %in% input$options){  # Replicable data
      plot_data <- logitdat(vars = 1, weights=input$effect_size, n = input$sample_size, bias=input$the_bias, replicable=T)   
    } else {  # Unique data
      plot_data <- logitdat(vars = 1, weights=input$effect_size, n = input$sample_size, bias=input$the_bias, replicable=T)   
    }
    return(plot_data)
  })
  

  
  output$plot_bokeh <- renderRbokeh({
    theData <- data_reactive()
    logistic_model <- glm(y ~ x1, data=theData, family=binomial(link="logit"))
    
    if('jitter' %in% input$options){
      p <- figure(xlim = c(-3, 3), ylim=c(-0.3, 1.3), logo='normal',
                  xlab = 'Predictor',
                  ylab='Pr(Disease)') %>%
        ly_points(jitter(x1, factor=.2), jitter(y, factor=.2), data=theData, size=5) 
    } else{
      p <- figure(xlim = c(-3, 3), ylim=c(-0.3, 1.3), logo='normal',
                  xlab = 'Predictor',
                  ylab='Pr(Disease)') %>%
        ly_points(x1, y, data=theData, size=7)
    }
    
    
    if("linear" %in% input$modeltype){
      linear_model <- lm(y ~ x1, data=theData)
      p <- ly_abline(p, linear_model, col='Purple', width=1.5)
    }
    if("logistic" %in% input$modeltype){
      predict_x1 <- seq(-3, 3, 0.05)
      predictDF <- data.frame(cbind(y=rep(0, 121), x1 = predict_x1))
      predict_y <- invlogit(as.numeric(predict(logistic_model, newdata = predictDF)))
      p <- p %>% ly_lines(predict_x1, predict_y, col='Blue', width=2)
    }
    if("loess" %in% input$modeltype){
      p <- p %>% ly_lines(lowess(theData, f=3/4), col='Red', width=1.5)
    }

     if('intercept' %in% input$options){
       print('Intercept')
       intercept <- as.numeric(1/(1 + exp(-(logistic_model$coef[1]))))
       p <- p %>% ly_points(x=0, y=intercept, color='Red', hover='intercept', glyph='asterisk')
     }
    
    p
    # rbokeh:::plot.BokehFigure(p)
  })
  
  # Generate the analysis of the Logistic Regression
  data_analysis <- reactive({
    dataset <- data_reactive()
    glm_output <- glm(y ~ x1, data=dataset, family=binomial(link="logit"))
    return(glm_output)
  })
  
  
})
