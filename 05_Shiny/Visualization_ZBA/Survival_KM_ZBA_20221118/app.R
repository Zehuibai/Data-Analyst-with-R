# <!-- ---------------------------------------------------------------------- -->
# <!--                    1. load the required packages                       -->
# <!-- ---------------------------------------------------------------------- --> 
 
packages<-c("shiny", "shinydashboard", "shinyjs", "tidyverse", "data.table", "DT", 
            "markdown","knitr", "ggthemes",
            "rpact",
            "survival", "survminer", "survMisc")
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}
ipak(packages)

# <!-- ---------------------------------------------------------------------- -->
# <!--                    2. load the required functions                      -->
# <!-- ---------------------------------------------------------------------- --> 


source(file.path("Modules", "Functions.R")) 
source(file.path("Modules", "nonpara_tableplot_module.R"))
source(file.path("Modules", "stratify_module.R"))
source(file.path("Modules", "nonpara_module.R"))
source(file.path("Modules", "semipara_module.R")) 
source(file.path("Modules", "ssc-logrankcompeting.R")) 


button_style1 = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
button_style2 = "color: #fff; background-color: #ff9e42; border-color: #ff7f42"

setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd() 

# Read in data 
dummy <- read_csv("Data/Dummy Data.csv")

dummy$RiskGroup <- as.factor(dummy$RiskGroup)
dummy$Subgroup <- as.factor(dummy$Subgroup)


dummy$Sex <- factor(dummy$Sex, levels= c("1", "2"), labels = c("Male",  "Female"))
dummy$MSS_Status <- factor(dummy$MSS_Status, levels= c("0", "1", "2"), labels = c("Censoned",  "Melanoma-Specific Survival (MSS) ", "Other Death"))
dummy$RFS_Status <- factor(dummy$RFS_Status, levels= c("0", "1", "2"), labels = c("Censoned",  "Relapse-Free Survival (RFS) ", "Death"))


# Convert column names to lowercase for convenience
names(dummy) <- tolower(names(dummy))

# <!-- ---------------------------------------------------------------------- -->
# <!--                                  3. ui.R                               -->
# <!-- ---------------------------------------------------------------------- --> 

ui<-dashboardPage(
  dashboardHeader(title = "Survival Analys"),
  dashboardSidebar(
    
    ## https://rstudio.github.io/shinydashboard/appearance.html
    ## Customizing dashboard appearance
    tags$style(".shiny-input-container {margin-bottom: 0px}
                #file1_progress {margin-bottom: 0px}
                .checkbox {margin-top: 0px}"),
    
    sidebarMenu(id="tabs",
                sidebarSearchForm(textId = "searchbar",
                                  buttonId = "searchbtn",
                                  label = "Search..."),
                menuItem("Instructions",
                         tabName = "Home",
                         icon = icon("home")),
                
                menuItem("Sample Size Calculation",
                         tabName = "SSC",
                         icon = icon("calendar")),
                
                menuItem("Data Input",
                         tabName = "Data",
                         icon = icon("upload")),

                
                menuItem("Data Visualization",
                         tabName = "Visualization",
                         icon = icon("table")),     
                
                menuItem("Survival Analysis",
                         tabName = "Tools",
                         icon = icon("cogs"),
                         
                         menuSubItem("Kaplan Meier Method",
                                     tabName = "NonPara",
                                     icon = icon("angle-right")),
                         
                         menuSubItem("Cox Proportional Hazards Model",
                                     tabName ="SemiPara",
                                     icon = icon("angle-right"))
                         )                )
  ),
  
  dashboardBody(
    
    tabItems(
      
      # <!-- ----------------------------------- -->
      # <!--        Introduction Side            -->
      # <!-- ----------------------------------- --> 
      tabItem(tabName = "Home", 
              fluidRow(
                column(11, 
                       includeMarkdown("README.md"),
                       offset = 1)
              )),
      
      # <!-- ----------------------------------- -->
      # <!--               SSC Side              -->
      # <!-- ----------------------------------- --> 
      tabItem(
        
        tabName = "SSC",
        sidebarLayout(
          
          sidebarPanel(
            h4(strong("Assumption", style = "color: steelblue")),
            
            selectInput(inputId = "Subgroup",
                        label = "Choose a subgroup:",
                        choices = c("IIIA", "IIIB", "IIIC")),
            
            
            # Input: Numeric entry for number of obs to view ----
            numericInput(inputId = "alpha",
                         label = "Overall one-sided alpha of each subgroup:",
                         value = 0.0083),
            numericInput(inputId = "Power",
                         label = "Targeted power of each subgroup:",
                         value = 0.9),
            numericInput(inputId = "t",
                         label = "Time information (ratio of interim analysis sample based on of initially target sample):",
                         value = 0.83),
            numericInput(inputId = "HighRisk",
                         label = "Estimated 5-year MSS in MelaGenix high score group:",
                         value = 0.527),
            numericInput(inputId = "LowRisk",
                         label = "Estimated 5-year MSS in MelaGenix low score group:",
                         value = 0.85),
            numericInput(inputId = "CompetingRisk",
                         label = "Competing risk rate (5-year incidence of death for other cause):",
                         value = 0.05),
            numericInput(inputId = "HighDist",
                         label = "Fraction of patients in MelaGenix high score group XX% (1-XX% for MelaGenix low score group):",
                         value = 0.9),
            width = 3
          ),
          
          mainPanel(
          # Output: Verbatim text for data summary ----
          DT::dataTableOutput("SSCTable"))
        )
      ),
      
      # <!-- ----------------------------------- -->
      # <!--               Data Side             -->
      # <!-- ----------------------------------- --> 
      tabItem(
        
        tabName = "Data",
        sidebarLayout(
          
          sidebarPanel(
            
            h4(strong("Upload Data", style = "color: steelblue")),
            
            fileInput("file1", HTML("Choose a CSV File (defaut as Dummy Data.csv): "),
                      accept = c("text/csv", ".csv", "text/comma-separated-values,text/plain"),
                      placeholder = "Example: ovarian {survival}"),
            
            column(12, align = "right", checkboxInput("header", "Header", TRUE)),
            
            br(),
            
            selectInput(inputId="var_time", label="Time Variable: ", choices="RFS_Time"),
            selectInput(inputId="var_event", label="Event Variable: ", choices="RFS_Status"),
            
            width = 3
          ),
          
          mainPanel(
            DT::dataTableOutput("DataTable"))
        )
      ),
      
      # <!-- ----------------------------------- -->
      # <!--       Visualization Side            -->
      # <!-- ----------------------------------- --> 
      tabItem(
        tabName = "Visualization",
        fluidPage(
          br(), 
          titlePanel("Descriptive Statistics Visualization"),
          p("Explore the difference between MelaGenix High Score Group and MelaGenix Low Score Group."),
          
          # Add first fluidRow to select input for subgroup 
          fluidRow(
            column(12, 
                   wellPanel(
                     selectInput(
                       inputId = "subgroup", 
                       label = "Select Subgroup:", 
                       choices = c("IIIA", "IIIB", "IIIC")
                     )
                   )  # add select input 
            )
          ),
          
          # Add second fluidRow to control how to plot the continuous variables
          fluidRow(
            column(3, 
                   wellPanel(
                     p("Select a continuous variable and graph type (histogram or boxplot)."),
                     radioButtons("continuous_variable", 
                                  "Continuous:", 
                                  choices = c("Age"="age", "RFS Time"="rfs_time", "MSS Time"="mss_time")),  
                     radioButtons("graph_type", 
                                  "Graph:", 
                                  choices = c("Histogram"="histogram", "Box Plot"="boxplot")),    
                   )
            ),
            column(9, plotOutput("p1"))  # add plot output
          ),
          
          # Add third fluidRow to control how to plot the categorical variables
          fluidRow(
            column(3, 
                   wellPanel(
                     p("Select a categorical variable to view bar chart."),
                     radioButtons("categorical_variable", 
                                  "Categorical:", 
                                  choices = c("Sex"="sex", "RFS Status"="rfs_status", "MSS Status"="mss_status")),    
                     checkboxInput("is_stacked", "Stack Bars Option:", value = FALSE)        # add check box input for stacked bar chart option
                   )
            ),
            column(9, plotOutput("p2"))  # add plot output
          )
        )
        ),
      
      # <!-- ----------------------------------- -->
      # <!--         Analysis Side               -->
      # <!-- ----------------------------------- -->     
      tabItem(tabName="NonPara", nonPara_UI("nonPara_Panel")),
      tabItem(tabName="SemiPara", semiPara_UI("semiPara_Panel"))
    )
  )
 )



server <- function(input, output, session){

  # <!-- ----------------------------------- -->
  # <!--               SSC Side              -->
  # <!-- ----------------------------------- -->    
  
  # t <- 0.83
  # alpha <- 0.008333333
  # local <- alpha*log(1+(exp(1)-1)*t)
  # Power <- 0.9
  # HighRisk <- 0.527
  # LowRisk <- 0.85
   
 
  # out_table%>% kable(caption = "Sample size calculation for subgroups", col.names = c("Results"))
  # Output----------

 
  output$SSCTable <- DT::renderDataTable(DT::datatable({
    ut_table <- data.frame(
      Event=c("Number of Event for Mela Genix high score group",
              "Number of Event for Mela Genix low score group",
              "Sample Size of Mela Genix high score group (IA)",
              "Sample Size of Mela Genix low score group (IA)",
              "Total Sample Size at interim analysis",
              "Recruitment after interim analysis",
              "Achieved Power at final analysis in %"),
      result=  LogrankCR2(alpha=input$alpha, 
                          Power=input$Power, 
                          S_ev1 = input$HighRisk, 
                          S_ev2=input$LowRisk,
                          S_cr=1-input$CompetingRisk, 
                          P1=input$HighDist, 
                          P2=1-input$HighDist, 
                          T=5.0000000001, R=0.0000000001))
    ut_table
  }))

  # <!-- ----------------------------------- -->
  # <!--               Data Side             -->
  # <!-- ----------------------------------- --> 
  rawData <- reactive({
    inFile <- input$file1
    
    if(!is.null(inFile)) {
      
      read.csv(inFile$datapath,
               header = input$header,
               sep = input$separator)
    }
    else {read.csv(file.path("Data","Dummy Data.csv"))}
    }
    )
  
  # Time and Event Variable Selection
  observe({
    updateSelectInput(session, "var_time", label = "Time Variable",
                      choices = names(rawData()))
  })
  
  observeEvent(Time(), {
    updateSelectInput(session, "var_event", label = "Event Variable",
                      choices = setdiff(names(rawData()), Time()))
    
  })
  
  Time = reactive({input$var_time})
  Event = reactive({input$var_event})

  # Output----------
  output$DataTable <- DT::renderDataTable(
    DT::datatable(rawData(), options = list(scrollX = TRUE)) )
 
  
  
  # <!-- ----------------------------------- -->
  # <!--       Visualization Side            -->
  # <!-- ----------------------------------- --> 
  df_subgroup <- reactive({
    dummy %>% filter(subgroup == input$subgroup)
  })
  
  ## Create logic to plot histogram or boxplot
  output$p1 <- renderPlot({
    if (input$graph_type == "histogram") {
      # Histogram
      ggplot(df_subgroup(), aes_string(x = input$continuous_variable)) +
        geom_histogram(fill="#0047b3", alpha=.4, col="black", size=.1) +
        labs(title = paste("Distribution of", input$continuous_variable), y = "Number of Patients") +   
        facet_wrap(~riskgroup)    # facet by RiskGroup
    }
    else {
      # Boxplot
      ggplot(df_subgroup(), aes_string(y = input$continuous_variable)) +
        geom_boxplot(fill="#0047b3", alpha=.4) +   
        coord_flip() +   
        labs(title = paste("Distribution of", input$continuous_variable), y = "Number of Patients") +   
        facet_wrap(~riskgroup)    # facet by risk groups
    }
    
  })
  # Create logic to plot faceted bar chart or stacked bar chart 
  output$p2 <- renderPlot({
    # Bar chartHappy
    p <- ggplot(df_subgroup(), aes_string(x = input$categorical_variable)) +
      labs(title = paste("Distribution of", input$categorical_variable), y = "Number of Patients") +
      scale_fill_brewer(palette="Paired")      
    if (input$is_stacked) {
      p + geom_bar(alpha=.6, width=.4, position = "stack", aes(fill = df_subgroup()$riskgroup)) +   
        theme(axis.text.x = element_text(angle = 0), legend.position = "bottom")+
        scale_fill_discrete(name = "Risk Group") # add bar geom and use RiskGroup as fill
    }
    else{
      p + geom_bar(alpha=.6, width=.4, aes_string(fill = input$categorical_variable)) +  # add bar geom and use input$categorical_variables as fill
        facet_wrap(~riskgroup) + 
        theme(axis.text.x = element_text(angle = 0), legend.position = "bottom") # facet by RiskGroup 
    }
  })
  
  # <!-- ----------------------------------- -->
  # <!--         Analysis Side               -->
  # <!-- ----------------------------------- -->   
  callModule(nonPara, "nonPara_Panel", data = rawData,
             Time = Time, Event = Event)
  callModule(semiPara, "semiPara_Panel", data = rawData,
             Time = Time, Event = Event)
  
  
}


shinyApp(ui = ui, server = server)