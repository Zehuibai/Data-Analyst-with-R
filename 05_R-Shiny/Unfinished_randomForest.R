# #Upload to Shiny IO
# install.packages('rsconnect')
# library(rsconnect)
#install.packages(c('shiny','DT','ggplot2','purrr','dplyr','corrplot','plotly','randomForest'))
# 
# rsconnect::setAccountInfo(name='chrisedstrom', token='88D536E091400263E74E70661483E0F1', secret='OYmlIwBg/jZdy9htFnQf8Kgex0crEwWkYFQKLOf4')
# rsconnect::deployApp('C:\\Users\\Chris\\Desktop\\Shiny')
# deployApp()

#Load libraries
library(Boruta)
library(corrplot)
library(dplyr)
library(DT)
library(ggplot2)
library(plotly)
library(purrr)
library(randomForest)
library(rpart)
library(rpart.plot)
library(shiny)
library(shinydashboard)

# Load data and create variable converting it to numeric for correlation
df <-read.csv(file="C:\\Users\\cyberguerra\\Desktop\\HR_Cat.csv", 
              header = T, 
              check.names=F, 
              fileEncoding="UTF-8-BOM")

#df<-read.csv("./HR_Cat.csv")

#########################################################################################################
ui <- dashboardPage(
  dashboardHeader(title = "Simple Descriptive Analytics"),
  dashboardSidebar(
    fileInput("file1", "Choose CSV File",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")),
    
    # Horizontal line ----
    tags$hr(),
    
    # Input: Select what to display
    selectInput("dataset",
                "Data:",
                choices =list(df="df",uploaded_file = "inFile"),
                selected=NULL)),
  
  dashboardBody(
    
    # Output: Tabset w/ correlation, summary, and table ----
    tabsetPanel(type = "tabs",
                tabPanel("Data",DT::dataTableOutput("table"),
                         style = "overflow-y: scroll;overflow-x: scroll;"),
                tabPanel("Summary",
                         verbatimTextOutput("summary")),        
                tabPanel("Correlation",
                         verbatimTextOutput("selection"),
                         plotlyOutput("heat"),
                         plotlyOutput("scatterplot")),
                tabPanel("Graphs",
                            sidebarPanel(
                                  selectInput("plot.type",
                                             "Plot Type:",
                                             list(histogram = "histogram",
                                                  boxplot = "boxplot",
                                                  density = "density",
                                                  bar = "bar")),
                                  checkboxInput("show.points",
                                               "show points for Boxplot",
                                               TRUE),
                                  selectInput('xcol', 'Dependent Variable (y)', "",
                                              selected = ""),
                                  selectInput("ycol", 'Independent Variable (X)',
                                              choices = NULL)),
                                uiOutput("graph")),

                tabPanel("Random Forest",
                         sidebarPanel(
                           # Input: Select number of trees for Random Forest
                           sliderInput("ntree", "Number of Trees (ntree):", 
                                       min = 1,
                                       max = 100,
                                       value = 1),
                           # Input: Select number of variables to consider
                           sliderInput("mtry", "Number of Variables (mtry):", 
                                       min = 1,
                                       max = 100,
                                       value = 1,
                                       step=1),
                           # Input: Select number of variables to consider
                           sliderInput("nodesize",
                                       "Number of Branches (nodesize):", 
                                       min = 1,
                                       max = 100,
                                       value = 1,
                                       step=1)),
                         mainPanel(
                           plotOutput("varImpPlot"),
                           verbatimTextOutput("rf",
                                            placeholder = TRUE))),
                tabPanel("Decision Tree",
                         sidebarPanel(
                           # Input: Select number of variables to consider
                           sliderInput("minsplit",
                                       "Minimum Number of Observations (minsplit):", 
                                       min = 1,
                                       max = 100,
                                       value = 1,
                                       step=1),
                           # Input: Select number of nodes
                           sliderInput("maxdepth",
                                       "Tree Depth (maxdepth):",
                                       min = 1,
                                       max = 100,
                                       value = 1,
                                       step=1)),

                         mainPanel(plotOutput("decisiontree"),
                         verbatimTextOutput("DTsum",
                                            placeholder = TRUE))))
              )
      )


##############################################################################################################
##############################################################################################################
server <- function(input, output, session) {
  datasetInput <- reactive({
    switch(input$dataset,
           "df" = df,
           "inFile" = read.csv(input$file1$datapath,fileEncoding="UTF-8-BOM"))
  })
  
  #update group and variables based on the data
  observe({
    if(!exists(input$dataset)) return() #make sure upload exists
    var.opts<-colnames(get(input$dataset))
    updateSelectInput(session,
                      "ycol",
                      choices = var.opts)
    updateSelectInput(session,
                      "xcol",
                      choices = var.opts)
    updateSliderInput(session, 'mtry',
                      max = ncol(datasetInput())-1)
    updateSliderInput(session, 'maxdepth',
                      max = ncol(datasetInput())-2)
  })
  
  output$graph <- renderUI({
    plotOutput("p")
  })

  #Get data object
  get_data<-reactive({
    if(!exists(input$dataset)) return() # if no upload
    check<-function(x){is.null(x) || x==""}
    if(check(input$dataset)) return()
    obj<-list(data=get(input$dataset),
              effect=input$ycol,
              cause=input$xcol
    )

    #Require all to be set to proceed
    if(any(sapply(obj,check))) return()
    #Make sure choices had a chance to update
    check<-function(obj){
      !all(c(obj$effect,obj$cause) %in% colnames(obj$data))
    }

    if(check(obj)) return()
    obj
  })

  #Plot function using ggplot2
  output$p <- renderPlot({eval(expr)
    plot.obj<-get_data()
    #conditions for plotting
    if(is.null(plot.obj)) return()
    #make sure variable and group have loaded
    if(plot.obj$effect == "" | plot.obj$cause =="") return()
    #plot types
    plot.type<-switch(input$plot.type,
                      "histogram" =	geom_histogram(alpha=0.5,position="identity"),#,stat = "count"),
                      "boxplot" = geom_boxplot(),
                      "density" =	geom_density(alpha=.75),
                      "bar" =	geom_bar(position="dodge")
    )
    if(input$plot.type=="histogram")	{
      p<-ggplot(plot.obj$data,
                aes_string(as.numeric(plot.obj$cause),
                  y 		= plot.obj$effect,
                  x 		= plot.obj$cause,
                  fill 	= plot.obj$cause # let type determine plotting
                )
      ) + plot.type
    }
    if(input$plot.type=="boxplot")	{		#control for 1D or 2D graphs
      p<-ggplot(plot.obj$data,
                aes_string(
                  y 		= plot.obj$effect,
                  x 		= plot.obj$cause,
                  fill 	= plot.obj$cause # let type determine plotting
                )
      ) + plot.type
      
      if(input$show.points==TRUE)
      {
        p<-p+ geom_point(aes_string(color=input$xcol),
                         alpha=0.5, 
                         position = 'jitter',
                         show.legend = F)
      }
    } else {
      p<-ggplot(plot.obj$data,
                aes_string(
                  x 		= plot.obj$effect,
                  fill 	= plot.obj$cause,
                  group 	= plot.obj$cause
                )
      ) + plot.type
    }
    p<-p+labs(
      fill 	= input$cause,
      x 		= input$effect,
      y 		= ""
    )  +
      .theme
    print(p)
  })

  # set uploaded file
  upload_data<-reactive({
    inFile <- input$file1

    if (is.null(inFile))
      return(NULL)

    #could also store in a reactiveValues
    read.csv(inFile$datapath,fileEncoding="UTF-8-BOM")
  })
  
  observeEvent(input$file1,{
    inFile<<-upload_data()
  })
  
  # Generate a correlation matrix of the data ----
  output$heat <- renderPlotly({
    dfNum <- datasetInput() %>% mutate_if(is.factor, as.numeric)
    nms <- names(datasetInput())
    # compute a correlation matrix
    correlation <- cor(dfNum)
    
    plot_ly(x = nms, y = nms, z = correlation, 
            key = correlation, type = "heatmap", 
            source = "heatplot",
            colors = colorRamp(c("black", "gray", "yellow"))) %>%
      layout(xaxis = list(title = ""), 
             yaxis = list(title = ""))
  })
  
  output$selection <- renderPrint({'Click on a cell in the heatmap to display a scatterplot'})
  
  # Show scatterplot for correlation matrix selection
  output$scatterplot <- renderPlotly({
    dfNum <- Filter(is.numeric, datasetInput())
    s <- event_data("plotly_click", source = "heatplot")
    if (length(s)) {
      vars <- c(s[["x"]], s[["y"]])
      d <- setNames(datasetInput()[vars], c("x", "y"))
      yhat <- fitted(lm(y ~ x, data = d))
      plot_ly(d, x = ~x) %>%
        add_markers(y = ~y) %>%
        add_lines(y = ~yhat) %>%
        layout(xaxis = list(title = s[["x"]]),
               yaxis = list(title = s[["y"]]),
               showlegend = FALSE)
    } else {
      plotly_empty()
    }
  })
  
  # Show data in table
  output$table <- DT::renderDataTable({
    if (is.null(datasetInput))
      return(NULL)
    datasetInput()
  },
  filter = 'top',
  rownames = FALSE)
  
  #Get Summary
  output$summary <- renderPrint({
     if (is.null(datasetInput))
       return(NULL)
    summary(datasetInput())
  })
  
  # Reactive expression to create data frame of all input values ----
  sliderValues <- reactive({
    data.frame(
      Name = c("ntree",
               "mtry",
               "nodesize",
               "maxdepth"),
      Value = as.character(c(input$ntree,
                             input$mtry,
                             input$nodesize,
                             input$maxdepth)),
      stringsAsFactors = FALSE)
  })

  output$rf<-renderPrint({
    mydf <- data.frame(datasetInput())
    mydf<-rename(mydf, target = 1)
    # Split into Train and Validation sets
    # Training Set : Validation Set = 70 : 30 (random)
    set.seed(100)
    train <- sample(nrow(mydf),
                    0.7*nrow(mydf),
                    replace = FALSE)
    TrainSet <- mydf[train,]
    ValidSet <- mydf[-train,]
    
    # Fine tuning parameters of Random Forest model
    RF_Model <<- randomForest(target ~ .,               #@change
                            data = TrainSet,
                            ntree = input$ntree,
                            mtry = input$mtry,
                            nodesize = input$nodesize,  #@change
                            importance = TRUE)
    
    # Predicting on train set
    predTrain <- predict(RF_Model,
                         TrainSet,
                         type = "class")
    # Checking classification accuracy
    out_table1 <- table(predTrain,                    #@change
                        TrainSet$target)
    
    # Predicting on Validation set
    predValid <- predict(RF_Model,
                         ValidSet,
                         type = "class")
    # Checking classification accuracy
    out_mean2 <- mean(predValid == ValidSet$target) #@change
    out_table2 <- table(predValid,                     #@change
                        ValidSet$target)
    
    mean(predValid == ValidSet$target)
    
    out_importance <- importance(RF_Model)               #@change

    #--- output --- @change
    cat("\n----- Model -----\n")
    cat("\nRF_Model:\n")
    print(RF_Model)
    cat("\n----- Checking classification accuracy -----\n")
    cat("\nTrainSet:\n")
    print(out_table1)
    cat("\nValidSet:\n")
    print(out_table2)
    cat("\naccuracy:\n")
    print(out_mean2)
    cat("\n----- importance (RF_Model) -----\n")
    print(out_importance)

  })
  output$varImpPlot <- renderPlot({  #@change
    mydf <- data.frame(datasetInput())
    mydf<-rename(mydf, target = 1)
    # Split into Train and Validation sets
    # Training Set : Validation Set = 70 : 30 (random)
    set.seed(100)
    train <- sample(nrow(mydf),
                    0.7*nrow(mydf),
                    replace = FALSE)
    TrainSet <- mydf[train,]
    boruta_output <- Boruta(target ~ ., data=TrainSet,                             
                            ntree = input$ntree,
                            mtry = input$mtry,
                            doTrace=0)
    # names(boruta_output)
    
    # Get significant variables including tentatives
    boruta_signif <- getSelectedAttributes(boruta_output, withTentative = TRUE)
    # print(boruta_signif)
    
    # Do a tentative rough fix
    roughFixMod <- TentativeRoughFix(boruta_output)
    boruta_signif <- getSelectedAttributes(roughFixMod)
    # print(boruta_signif)
    
    # Variable Importance Scores
    imps <- attStats(roughFixMod)
    imps2 = imps[imps$decision != 'Rejected', c('meanImp', 'decision')]
    head(imps2[order(-imps2$meanImp), ])  # descending sort
    
    # Plot variable importance
    plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance")
  }) 

  # Classification Tree Summary with rpart
  output$DTsum <- renderPrint({
    mydf <- data.frame(datasetInput())
    mydf<-rename(mydf, target = 1)
    set.seed(100)
    fit <- rpart(target ~ ., 
                 method="class",
                 data = mydf,
                 control=rpart.control(minsplit = input$minsplit,
                                       maxdepth = input$maxdepth))
    print(printcp(fit)) # display the results
    print(plotcp(fit)) # visualize cross-validation results
    print(summary(fit)) # detailed summary of splits
    rpart.plot(fit, uniform=TRUE,
               main="Classification Tree",
               extra= 1)
  })
  
  # Classification Tree
  output$decisiontree <- renderPlot({
    mydf <- data.frame(datasetInput())
    mydf<-rename(mydf, target = 1)
    set.seed(100)
    #grow tree
    fit <- rpart(target ~ ., 
                 method="class",
                 data = mydf,
                 control=rpart.control(minsplit = input$minsplit,
                                       maxdepth = input$maxdepth))
    # plot tree
    rpart.plot(fit, uniform=TRUE,
         main="Classification Tree",
         extra= 1)

  })

}

shinyApp(ui, server)