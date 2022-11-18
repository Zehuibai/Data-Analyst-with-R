library(shiny)
library(shinythemes)
library(caTools)
library(ROCR)
library(GGally)
library(plotly)
library(ggplot2)
ui<-navbarPage(theme = shinytheme("united"),"logistic Regration ",
               tags$head(
                   tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Play&display=swap');
        @import url('https://fonts.googleapis.com/css2?family=Monda&display=swap');
        
      body{
        font-family:Monda;
        font-size:16px;
      }
      .tab-pane{
        margin-right:2%;
        margin-left:2%;
      }
      h1, h2, h3{
        color: #FF5E13;
        text-align:center;
        font-family:Play;
      }
      p{
        color: #FF5E13;
        font-family:Play;
      }
      h2{
        font-family:Play;
        font-size: 50px;
        text-align: left;
        padding-left:24px;
      }
      h4{
      color: #FF5E13;
        font-family:Play;
        font-size: 30px;
        text-align: left;
        padding-top:24px;
      }
      h5{
        color: #FF5E13;
        font-family:Play;
        font-size: 20px;
        text-align: left;
        padding-top:24px;
      }
      h2::first-letter {
      
        font-size: 70px;
      }
      h3{
        font-size: 35px;
      }
      table, th, td {
        color: #FF5E13;
        }
      .col-sm-8{
        border-radius: 5px;
        border: 1px solid black;
        border-color:#b0b0b0;
      }
      li{
        color: #FF5E13;
      }
      .well{
        border-radius: 10px;
      }
    "))
               ),
               
               sidebarLayout(sidebarPanel
                             ( fileInput
                                 ("file","Upload your CSV",multiple = FALSE),
                                 tags$hr(),
                                 checkboxInput(inputId = 'header', label = 'Header', value = FALSE),
                                 radioButtons(inputId = 'sep', label = 'Separator',
                                              choices = c(Comma=',',Semicolon=';',Tab='\t', Space=''), selected = ','),
                                 uiOutput("var1_select"),
                                 uiOutput("var2_select"),
                                 ),
                             mainPanel(
                                 tabsetPanel(
                                     tabPanel("Data Set",
                                              tags$h3("Data Set"),
                                              uiOutput("tb1")
                                              ),
                                     tabPanel("Structure",
                                              tags$h3("Structure"),
                                              verbatimTextOutput("otherone_val_show")
                                                  ),
                                     tabPanel("Regration Model",
                                              tags$h3("Regration Model"),
                                              verbatimTextOutput("other_val_show")
                                             ),
                                     tabPanel("Confidence Level",
                                              tags$h3("Confidence Level"),
                                              verbatimTextOutput("other_val_show121")
                                     ),
                                     tabPanel("Predict Value",
                                              tags$h3("Predict Test Value"),
                                              verbatimTextOutput("predict_test"),
                                              tags$h3("Predict Train Value"),
                                              verbatimTextOutput("predict_train")
                                     ),
                                     tabPanel("Visualization",
                                              plotOutput("other_val_show1")
                                     ),
                                     tabPanel("Theory",
                                              tags$h1("Logistic Regression"),
                                              tags$h2("What Is Regression ?"),
                                              tags$h5("Regression is a statistical Relationship Between two or more variables where a change in indepent variable is associated with a change in dependent variable."),
                                              imageOutput("image2"),
                                              tags$h5("Here, The change in one variable(height) is closely associated with the change in other variable(age)"),
                                              tags$h5("We see that the height is the dependent variable and age is the independent variable"),
                                              tags$h4("Type of Regression"), 
                                              tags$div(
                                                  HTML("<ol><li>Linear Regression</li><li>Logistic Regression</li><li>Polynomial Regression</li>")
                                                  
                                              ),
                                              tags$h4("Why Logistic Regression"),
                                              imageOutput("image3"),
                                              tags$h4("What is Logistic Regression"),
                                              imageOutput("image4"),
                                              imageOutput("image5"),
                                              imageOutput("image6"),
                                              tags$h4("Use Case- College Admission using Logistic Regression Steps"),
                                              imageOutput("image7"),
                                              ),
                                     tabPanel("Contact Us",h3("Conatct us by Mail"),h4("Aniket Roy: aniketroy997@gmail.com"),h4("Krutik Shah: krutikyshah@gmail.com"),br(),h3("Conatct us on Linkdin"),h4(tags$a("Aniket Roy",href="https://www.linkedin.com/in/aniket-roy-407214126/")),h4(tags$a("Krutik Shah",href="https://www.linkedin.com/in/krutik-shah-825264190/")))
                                     )
                             )
               )
)
server<-function(input,output) { 
data <- reactive({
file1 <- input$file
if(is.null(file1)){return()}
tt1=read.table(file=file1$datapath, sep=input$sep, header = input$header)
})  
output$table <-  DT::renderDataTable({
    DT::datatable(data(), filter = 'top', options = list( autoWidth = TRUE))
})
output$tb1 <- renderUI({
    DT::dataTableOutput("table")
})
output$var1_select<-renderUI({
    selectInput("ind_var_select","Select prediction Var", choices =as.list(names(data())),multiple = FALSE)
})

output$var2_select<-renderUI({
    selectInput("dpe_var_select","Select independent Var", choices =as.list(names(data())),multiple = TRUE)
})
output$var2_select1<-renderUI({
  selectInput("dpe_var_select1","Select dependent Var", choices =as.list(names(data())),multiple = TRUE)
})
output$otherone_val_show<-renderPrint({
    f<-data()
    str(f)
    summary(f)
})
output$image2 <- renderImage({
    list(
        src = "image1.png",
        contentType = "png",
        alt = "Face"
    )
    })
output$image3 <- renderImage({
  list(
    src = "image2.png",
    contentType = "png",
    alt = "Face"
  )
})
output$image4 <- renderImage({
  list(
    src = "image3.png",
    contentType = "png",
    alt = "Face"
  )
})
output$image5 <- renderImage({
  list(
    src = "image4.png",
    contentType = "png",
    alt = "Face"
  )
})
output$image6 <- renderImage({
  list(
    src = "image5.png",
    contentType = "png",
    alt = "Face"
  )
})
output$image7 <- renderImage({
  list(
    src = "image6.png",
    contentType = "png",
    alt = "Face"
  )
})
output$other_val_show<-renderPrint({
    
    f<-data()
    
    y <- f[,input$ind_var_select]
    x <- (f[,input$dpe_var_select])
    split <- sample.split(f, SplitRatio = 0.8)
    split
    
    train <- subset(f, split == "TRUE")
    test <- subset(f, split == "FALSE")
    
    if(is.vector(x))
    {
        x <- f[,input$dpe_var_select]
        logreg <- glm(y~x, family = "binomial")
    }
    else
    {
        x <- f[,input$dpe_var_select]
        logreg <- glm(y~ . ,data = x, family = "binomial")
    }
    print(summary(logreg))
    res <- predict(logreg, as.data.frame(test), type = "response")
    
    res <- predict(logreg, as.data.frame(train), type = "response")
})

output$predict_test<-renderPrint({
  
  f<-data()
  
  y <- f[,input$ind_var_select]
  x <- (f[,input$dpe_var_select])
  split <- sample.split(f, SplitRatio = 0.8)
  
  train <- subset(f, split == "TRUE")
  test <- subset(f, split == "FALSE")
  
  if(is.vector(x))
  {
    x <- f[,input$dpe_var_select]
    logreg <- glm(y~x, family = "binomial")
  }
  else
  {
    x <- f[,input$dpe_var_select]
    logreg <- glm(y~ . ,data = x, family = "binomial")
  }
  res <- predict(logreg, as.data.frame(test), type = "response")
  print(res)
  
  res <- predict(logreg, as.data.frame(train), type = "response")
})

output$predict_train<-renderPrint({
  
  f<-data()
  
  y <- f[,input$ind_var_select]
  x <- (f[,input$dpe_var_select])
  split <- sample.split(f, SplitRatio = 0.8)
  
  train <- subset(f, split == "TRUE")
  test <- subset(f, split == "FALSE")
  
  if(is.vector(x))
  {
    x <- f[,input$dpe_var_select]
    logreg <- glm(y~x, family = "binomial")
  }
  else
  {
    x <- f[,input$dpe_var_select]
    logreg <- glm(y~ . ,data = x, family = "binomial")
  }
  res <- predict(logreg, as.data.frame(test), type = "response")
  
  res <- predict(logreg, as.data.frame(train), type = "response")
  print(res)
})

output$other_val_show121<-renderPrint({
  
  f<-data()
  
  y <- f[,input$ind_var_select]
  x <- (f[,input$dpe_var_select])
  split <- sample.split(f, SplitRatio = 0.8)
  train <- subset(f, split == "TRUE")
  test <- subset(f, split == "FALSE")
  
  if(is.vector(x))
  {
    x <- f[,input$dpe_var_select]
    logreg <- glm(y~x, family = "binomial")
  }
  else
  {
    x <- f[,input$dpe_var_select]
    logreg <- glm(y~ . ,data = x, family = "binomial")
  }
  res <- predict(logreg, as.data.frame(test), type = "response")
  res <- predict(logreg, as.data.frame(train), type = "response")

  
  if(is.vector(x))
  {
    confmatrix <- table(Actual_Value = train[,input$ind_var_select], Predicted_Value = res > 0.5)
    print(confmatrix)
  }
  else
  {
    confmatrix <- table(Actual_Value = train[,input$ind_var_select], Predicted_Value = res > 0.5)
    print(confmatrix)
    ( confmatrix[[1,1]] + confmatrix[[2,2]] )/sum(confmatrix)
  }
  
  
})
output$other_val_show1<-renderPlot({
    
    f<-data()
    x <- (f[,input$ind_var_select])
    if(is.character(x))
    {
      ggpairs(data(),aes(colour=data()[,input$ind_var_select]))
    }
    else
    {
      ggpairs(data())
    }
    
    
})

}
shinyApp(ui=ui,server=server)