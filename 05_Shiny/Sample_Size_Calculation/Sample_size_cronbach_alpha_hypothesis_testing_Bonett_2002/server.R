# This is the back end file.


size.cronbach.power = function(cronbach1, cronbach0, k, power, alpha) {
    
    z_alpha = qnorm(1 - alpha/2)
    
    z_beta = qnorm(power)
    
    delta = (1-cronbach0)/(1-cronbach1)
    
    n = ceiling(((2*k/(k-1)) * (z_alpha+z_beta)^2) / (log(delta)^2) + 2)
    
    return(n)
}



shinyServer(
    
    function(input, output) {
        output$estimation <- renderText({size.cronbach.power(input$cronbach1, input$cronbach0, input$k, input$power, input$alpha)})
        
    }
    
    
    
)



