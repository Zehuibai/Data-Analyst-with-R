library(shiny)
library(markdown)

navbarPage(theme = shinythemes::shinytheme("united"),"Applied Statistics & Machine Learning",
           
############## DESCRIPTIVE STATISTICS ########################################################
#author - Lukose
           tabPanel("Descriptive Statistics",
                    sidebarLayout(
                      sidebarPanel(
                        
                        fileInput("file2", "Choose CSV File",
                                  multiple = FALSE,
                                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
                        
                        # Horizontal line ----
                        tags$hr(),
                        # Input: Checkbox if file has header ----
                        checkboxInput("header", "Header", TRUE),
                        # Input: Select separator ----
                        radioButtons("sep", "Separator",
                                     choices = c(Comma = ",",
                                                 Tab = "\t"),
                                     selected = ","),
                        # Input: Select quotes ----
                        radioButtons("quote", "Quote",
                                     choices = c("Double Quote" = "",
                                                 "None" = '"'),
                                     selected = '"'),
                        # Horizontal line ----
                        tags$hr(),
                        #helpText("Hist"),
                        uiOutput("histogramaxis")
                      ),
                      
                      mainPanel(
                        
                        DT::dataTableOutput('ex1'),
                        verbatimTextOutput("c2summary"),
                        plotOutput(outputId = 'desc_histogram')
                      
                      )
                    )
           ),

############## DISCRETE ########################################################
#author - Varad
tabPanel("Discrete Random Variables",
sidebarLayout(
        sidebarPanel(
                selectInput(
                  "dismodel", "Select Model", 
                        
                        choices = c("Binomial" = "binomial", 
                                    
                                    "Poisson" = "poisson", 
                                    
                                    "Geometric" = "geometric"), 
                        
                        selected = "binomial" 
                ),
                 conditionalPanel( 
              
              condition = "input.dismodel == 'binomial'", 
              
              numericInput("n", "parameter n in Binomial" , value = 10), 
              
              numericInput("p", "parameter p in Binomial" , value = 0.5) 
              
            ), 
            
            
            
            conditionalPanel(     
              
              condition = "input.dismodel == 'poisson'", 
              
              numericInput("lam", "parameter lambda in Poisson" , value = 1) 
              
            ), 
            
            
            
            conditionalPanel(     
              
              condition = "input.dismodel == 'geometric'", 
              
              numericInput("p", "parameter p in Geometric" , value = 0.5) 
              
            ),
              numericInput("max", "upper limit for x" , value = 5),  
            
            sliderInput("s", "number of simulated data" ,min=1, max=1000, value = 10),  
            
            
            
            conditionalPanel( 
              
              condition = "input.dismodel == 'binomial'", 
              
              numericInput("j1", "j for Bin" , value = 1) 
              
            ) ,
             conditionalPanel( 
              
              condition = "input.dismodel == 'poisson'", 
              
              numericInput("j2", "j for Poisson" , value = 1) 
              
            ), 
            
            
            
            conditionalPanel( 
              
              condition = "input.dismodel == 'geometric'", 
              
              numericInput("j3", "j for geometric" , value = 1) 
              
            ) 
#            
            
        ),
         mainPanel(  
          plotOutput("discretehistogram"),  
            
            tableOutput('discreteTab') 
            
          )     
)  

),

##############CONTINUOUS PROBABILITY########################################################
#author - Bharat
           tabPanel("Continuous Probability",
                    
                    sidebarPanel( 
                      
                      selectInput("conmodel", "Select Model", 
                                  
                                  choices = c("Normal" = "normal", 
                                              "Exponential" = "exponential", 
                                              "Uniform" = "uniform"), 
                                  selected = "normal" 
                                  
                      ), 
                      selectInput("dataset", "Select Data", 
                                  choices = c("Seat Belts" = "Seatbelts", 
                                              "USArrests" = "USArrests"
                                  ), 
                                  selected = "Seatbelts" 
                                  
                      ), 
                      
                      conditionalPanel( 
                        
                        condition = "input.dataset == 'Seatbelts'", 
                        selectInput("column1", "Select Column:",  
                                    choices=colnames(Seatbelts)) 
                        

                      ), 
                      
                      conditionalPanel( 
                        
                        condition = "input.dataset == 'USArrests'", 
                        selectInput("column2", "Select Column:",  
                                    choices=colnames(USArrests)) 
                        
                      ), 

                      
                      sliderInput("s", "number of simulated data" ,min=1, max=1000, value = 10), 
                      conditionalPanel(
                        condition = "input.conmodel == 'uniform'"
                      )

                    ), 
                    mainPanel(  
                      DT::dataTableOutput('summary'), 
                      verbatimTextOutput("prob"),
                      verbatimTextOutput("ErrorMessage"),
                      
                      ####PLOT############################
                      plotOutput("histogram"),  
                      #tableOutput("tab")
                      
                    )          
           ),

 ##############MACHINE LEARNING########################################################
  #author - Ishan

           tabPanel("Machine Learning",
                      sidebarPanel( 
                          selectInput("mlmodel", "Select Model", 
                                    
                                      choices = c("Naive Bayes" = "NB", 
                                                  "SVM" = "SVM", 
                                                  "MLR" = "MLR",
                                                  "ALL 3 with monte carlo" = "ALL"), 
                                      selected = "NB" 
                                     ),
                                     
                            helpText("Create scatterplot to analyse data.
                            Default : Glucose - Age."),
                            uiOutput("xaxis"),
                            uiOutput("yaxis")    
                     ),
                            mainPanel(
                              plotOutput(outputId ="scatterPima"), 
                              h4("Applying Classification models on PimaIndianDiabetic2 dataset"),
                              verbatimTextOutput('ml'),
                              plotOutput("ctx"),
                              h4("PimaIndianDiabetic2 dataset"),
                              DT::dataTableOutput('pima')
                            )
           ),


################################### TEAM DETAILS #####################################################33


tabPanel("Team",
         
        
         mainPanel(  
           
           h2("MSc. Business Analytics - CA1- 24th Dec 2019"),

           h5(" LUKOSE PANNAPARA - 10529675"),
           helpText("Worked on descriptive stats module & MLR model"),
           h5(" VARAD SANT - 10534368"),
           helpText("Worked on discrete prob module & visualization"),
           h5(" BHARAT SRINIVAS - 10532496"),
           helpText("Worked on continious prob module & UI alignments"),
           h5(" ISHAN DAS - 10532854"),
           helpText("Worked on NB,SVM and montecarlo module & vizualization")
         )          
           
         )
)
