This is a R Shiny App for simple and interactive PK modeling. 
I wrote it as a potential teaching tool to demonstrate basic PK principles.
To run, put both the ui.R and server.R file into a folder named, "PK_Sim"
Set the WD to the location of the folder (but not the folder itself) and type in:    
     shiny::runApp('PK_Sim')
Note: you might need to download a few extra R packages before being able to run it. They are:
    -library(shiny)
    -library(shinydashboard)
    -library(deSolve)
    -library(ggplot2)
