library(shiny)
shinyUI(pageWithSidebar(
                # Application Title
                headerPanel("Head and Neck Cancer Survival App"),
                sidebarPanel(
                        selectInput("TumorSite","Patient Group(s)",c("Larynx Cancer"="Larynx",
                                                                    "Oral Cavity Cancer"="Oral Cavity",
                                                                    "Oropharynx Cancer"="Oropharynx")),
                        selectInput("Survival","Type of Survival Analysis",c("Disease specific survival","Overall survival")),
                        selectInput("Stratification","Patient Stratification",c("By Gender"="gender","By Race"="race",
                                                                                "By Ethnicity"="ethnicity","By Current Smoking Status"="current_smoker",
                                                                                "By Current Drinking Status"="current_drinker","By Nodal Status"="node_status")
                        ),
                        tags$div(class="header", checked=NA,
                                 tags$p("Documentation on this App"),
                                 tags$a(href="http://rpubs.com/tbelbin/SurvAppDocumentation", "Click Here!",target="_blank"))
                ),
                mainPanel(
                        plotOutput("newKM",height=400,width=400),
                        h6('Median Age of Patients: '),
                        verbatimTextOutput("MedianAge"),
                        h6('Number of Patients: '),
                        verbatimTextOutput('NumPatients'),
                        h6('Significance of difference in survival curves: '),
                        verbatimTextOutput('Significance')
                        )
                )
)