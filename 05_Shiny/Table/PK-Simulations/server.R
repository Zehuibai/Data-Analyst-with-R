#Server code for modeling via differential equations for oral and iv PK

library(deSolve)
library(shiny)
library(mlxR)
library(shinydashboard)
library(ggplot2)

shinyServer(function(input, output) {
  output$plot <- renderPlot({

  ka <- input$ka #Absorption constant (conditional INPUT)    
  
  k <- (input$num1)/(input$num1.5) #Rate of elimination= CL/V (INPUT)
  z <- input$num2 #Initial conc (INPUT)
  u <- input$num3 #How many daily injections? (INPUT)
  x <- input$num4 #Dose per injection? (INPUT)
  w <- input$num5 #Duration of the Model (INPUT)
  v <- input$slid1 #Frequency? (INPUT)
  tw1 <-input$num6 #Upper therapeutic limit (INPUT)
  tw2 <-input$num7 #Lower therapeutic limit (INPUT)
  
  yinib <- c(blood = z) #Initial conc (INPUT)
  yinig <- c(gut= 0, blood = z) #Initial conc (INPUT)
  
pkIV <- function(t, blood, p) {
  dblood <- - k * blood
  list(dblood)
}  
#The differential equation that models the dynamics of the drug in the blood
#in between bolus injections

injectevents <- data.frame(var = "blood",
                           time = seq(0, u, 1/v),   #How many injections and how frequently? (INPUT)
                           value = x,    #Dose per injection? (INPUT)
                           method = "add")
#Unfortunately, the solvers in deSolve ignore any changes in the state 
#variable values when made in the derivative function, 
#so we have to make a data frame to specify at what time each bolus injection takes place

timesb <- seq(from = 0, to = w, by = 1/24) #Interval in days (INPUT)
output1 <- ode(func = pkIV, times = timesb, y = yinib,
              parms = NULL, method = "impAdams",
              events = list(data = injectevents))
#Differential equation solver doing its thing for IV Bolus

pkOral <- function(t, y, p) {
  
  if ( (24*t) %% 24 <= 1)
    uptake <- 2
  else
    uptake <- 0
  dy1 <- - ka* y[1] + uptake
  dy2 <- ka* y[1] - k* y[2]
  list(c(dy1, dy2))
}
#The differential equation that models the dynamics of the drug in the blood
#in between oral intake of the drug

oralevents <- data.frame(var = c("gut"),
                         time = seq(0, u, 1/v),   #How many oral intakes and how frequently? (INPUT)
                         value = x,    #Dose per intake? (INPUT)
                         method = "add")

#Unfortunately, the solvers in deSolve ignore any changes in the state 
#variable values when made in the derivative function, 
#so we have to make a data frame to specify at what time each oral administration takes place

timesg <- seq(from = 0, to = w, by = 3/24) #Interval in days (INPUT)
output2 <- ode(func = pkOral, times = timesg, y = yinig, atol = 1e-10, 
               parms = NULL, method = "impAdams", hmax = 1/24, events = list(data = oralevents)) 
#Differential equation solver doing its thing for 2-Comp Oral

finaloutput1 <- data.frame(timesb= output1[,1], 
                           IV= output1[,2])
finaloutput2 <- data.frame(timesg= output2[,1],
                           Oral= output2[,3])
#Converting both lists' output into a dataframe for ggplot

vdisp <- rep(FALSE,2)
pl=ggplotmlx()
if (input$bolus == 1){
  pl=pl + geom_line(data=finaloutput1, aes(x=timesb, y=IV, colour="IV"), size=1.075)  
  vdisp[1] <- TRUE}
if (input$oral == 1){
  pl=pl + geom_line(data=finaloutput2, aes(x=timesg, y=Oral, colour="Oral"), size=1.075) 
  vdisp[2] <- TRUE}
pl <- pl + labs(x='Time (Days)') + labs(y='Plasma Concentration (ng/mL)') + 
  labs(title='Simulated Concentration vs. Time Curve')
pl <- pl + geom_hline(yintercept= tw1, colour="#7D26CD", linetype="dashed")
pl <- pl + geom_hline(yintercept= tw2, colour="#7D26CD", linetype="dashed")
pl <- pl + theme(legend.position=c(.75, 0.8), legend.justification=c(0,1), legend.title=element_blank())
print(pl)
#If bolus is checked, then the ggplot will display the IV bolus graph
#After that, just add the labels, title, legend, and the Therapeutic Window overlay

})

})
