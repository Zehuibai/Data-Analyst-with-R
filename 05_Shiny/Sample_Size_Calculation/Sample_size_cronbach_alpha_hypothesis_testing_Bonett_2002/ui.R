# This is the front end file.


shinyUI(pageWithSidebar(
    
    headerPanel("Required sample size for Cronbach alpha value with desired power (hypothesis testing)"),
    
    sidebarPanel(
        
        numericInput('cronbach1', 'Expected value of Cronbach alpha', 0.80, min = 0, max = 1, step = 0.01),
        
        numericInput('cronbach0', 'Minimum acceptable Cronbach alpha', 0.65, min = 0, max = 1, step = 0.01),
        
        numericInput('k', 'Number of items', 5, min = 0, max = 999, step = 1),
        
        numericInput('power', 'Desired power (1 - beta)', 0.90, min = 0, max = 1, step = 0.01),
        
        numericInput('alpha', 'Significance level (alpha, two-sided)', 0.05, min = 0, max = 1, step = 0.01)
        
        
    ),
    
    mainPanel(
        
        verbatimTextOutput("obeta"),
        
        h4('Required sample size (n):'),
        
        verbatimTextOutput("estimation"),
        
        h6('Approximate number of subjects required to test a Cronbach alpha coefficient 
           with desired power.'),
        h6(em('Note: For a one-tailed hypothesis test, multiply the desired significance 
              level by two (e.g., 0.05 * 2 = 0.1)')),
        br(),
        
        h6('For example: for an expected Cronbach alpha of 0.85 for a (sub-)scale of 5 items 
           and a desired power of 0.9 (90%), 86 subjects are needed to demonstrate that this 
           Cronbach alpha value is significantly different from a minimum acceptable Cronbach 
           alpha value of 0.65 at a significance level of 0.05 (two-tailed significance, for 
           a one-tailed test the required sample size is 71 subjects).'),
        
        br(),
        
        h5('References:'),
        
        h6('Bonett DG. Sample size requirements for testing and estimating coefficient alpha. J Educ Behav Stat. 2002;27(4):335–40.'),
        h6('Bonett DG, Wright TA. Cronbachs alpha reliability: Interval estimation, hypothesis testing, and sample size planning. J Organ Behav. 2015;36(1):3–15.')
        
        
    )
    
))