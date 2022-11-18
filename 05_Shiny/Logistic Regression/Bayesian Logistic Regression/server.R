## This script contains all the 'behind-the scenes' calculations for the app.

## Load libraries and code. This only needs to be run once.
library(arm)
library(MCMCpack)
library(coda)
library(fBasics)
library(stats4)
library(MASS)
library(vcd)
library(caret)
library(pROC)
library(ROCR)
library(BoomSpikeSlab)
source('model.R')

shinyServer(function(input, output, session) { 
  
  ## Determines which tabs are active when the app lanuches.
  ## Outlines conditions for tabs to become active as we upload data etc. into the app.
  session$sendCustomMessage('activeNavs', "Training data input")
  session$sendCustomMessage('activeNavs', "Test data input")
  
  observe({
    if (!is.null(input$datafile)) {
      session$sendCustomMessage('activeNavs', "Training data")
    }
  })
  
  observe({
    if (!is.null(input$datafile_test)) {
      session$sendCustomMessage('activeNavs', "Test data")
    }
  })
  
  observe({
    if (!is.null(input$iv)) {
      session$sendCustomMessage('activeNavs', "Prior")
      session$sendCustomMessage('activeNavs', "Model summary and plots")
    }
  })
  
  observe({
   if (!is.null(input$datafile_test) && !is.null(input$iv) && !is.null(input$datafile)) {
    session$sendCustomMessage('activeNavs', "Test data results")
  }
  })

  observe({
   if (!is.null(input$var_selection) && !is.null(input$iv) && !is.null(input$datafile) && input$var_selection == 'Yes') {
     session$sendCustomMessage('activeNavs', "Variable selection information")
   }
  })


  

  ## Read in the training data file and convert any '.factor' variables to factors.
  data <-  reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    data <- read.csv(infile$datapath)
    for(i in 1:dim(data)[2]){
      if(grepl('factor',colnames(data)[i])){data[,i] <- as.factor(data[,i])}
    }
    data
  })
  
  ## Read in the test data file and convert any '.factor' variables to factors.
  data_test <-  reactive({
    infile <- input$datafile_test
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    data <- read.csv(infile$datapath)
    for(i in 1:dim(data)[2]){
      if(grepl('factor',colnames(data)[i])){data[,i] <- as.factor(data[,i])}
    }
    data
  })
  
  ## Update training data so all factor variables are dummied.
  data_dummied_factors <- reactive({
    out <- data.frame(matrix(0,dim(data())[1],dim(data())[2]))
    j=1
    for (i in 1: dim(data())[2]){
      if (grepl('factor',colnames(data())[i])) {
        nlevels <- length(levels(data()[,i]))
        levels <- levels(data()[,i])
        for (k in 1:(nlevels-1)){
          out[,j] <- as.numeric(data()[,i] == levels[k+1])
          colnames(out)[j] <- paste(colnames(data())[i],k,sep='')
          j=j+1
        }
      } else {
        out[,j] <- data()[,i]
        colnames(out)[j] <- colnames(data())[i]
        j=j+1
      }
    }
    out
  })
  
  ## Update test data so all factor variables are dummied.
  data_dummied_factors_test <- reactive({
    out <- data.frame(matrix(0,dim(data_test())[1],dim(data_test())[2]))
    j=1
    for (i in 1: dim(data_test())[2]){
      if (grepl('factor',colnames(data_test())[i])) {
        nlevels <- length(levels(data_test()[,i]))
        levels <- levels(data_test()[,i])
        for (k in 1:(nlevels-1)){
          out[,j] <- as.numeric(data_test()[,i] == levels[k+1])
          colnames(out)[j] <- paste(colnames(data_test())[i],k,sep='')
          j=j+1
        }
      } else {
        out[,j] <- data_test()[,i]
        colnames(out)[j] <- colnames(data_test())[i]
        j=j+1
      }
    }
    out
  })
  
  ## Select the dependent variable.
  output$dv = renderUI({
    if (!is.null(input$datafile)){selectInput('dv', h5('Dependent Variable'), choices = names(data()))}
    else(paste('Please upload your training data.'))
  })
  
  ## Define introduction text to appear at the top of every tab.
  output$intro =renderUI({
    str1 <- 'Create bayesian logistic regression models with and without prior information.'
    str2 <- '(Some calculations may take a few minutes to run.)'
    HTML(paste('<em>','<center>',str1, '<br>', str2))
  })
  
  ## Define all possible independent variables including first order interactions.
  poss <- reactive({
    all <- expand.grid(names(data()), names(data()))
    all <- all[all$Var1!=all$Var2,]
    all <- all[(all$Var1!=input$dv & all$Var2!=input$dv),]
    all[,'check'] <- apply(all,1,function(x){paste(sort(x),collapse='*')})
    all <- all[!duplicated(all[,'check']),]
    all <- c(names(data())[names(data())!=input$dv], all[,'check'])
    all
  })
  
  ## Allows selection of independent variables
  output$iv = renderUI({
    if(!is.null(input$datafile) && !is.null(input$remodel) && input$remodel>0){selectInput('iv', h5('Independent Variable(s)'), choices = poss(), multiple=T, selected = variables_prob_0.5())}
    else if(!is.null(input$datafile)){selectInput('iv', h5('Independent Variable(s)'), choices = poss(), multiple=T)}
  })

  ## State whether variable selection needs to be performed.
  output$var_selection = renderUI({
  if(!is.null(input$datafile) && (is.null(input$remodel) || input$remodel==0)){radioButtons('var_selection', label='Do you want to see information that may aid with variable selection?', choices=c('No','Yes'))}
  })

  ## Update the list of independent variables to correctly include all levels of factor variables and interaction terms.
  updated_iv <- reactive({
                  x <- vector()
                  j=1
                  for (i in 1:length(input$iv)){
                    if (!(input$iv[i] %in% names(data()))){
                      var1 <- strsplit(input$iv[i],'[*]')[[1]][1]
                      var2 <- strsplit(input$iv[i],'[*]')[[1]][2]
        
                      if (class(data()[,var1])!='factor' & class(data()[,var2])!='factor'){
                        x[j] <- input$iv[i]; j=j+1
                      } else if (class(data()[,var1])=='factor' || class(data()[,var2])=='factor') {
                        factor_var <- c(paste(var1),paste(var2))[c(class(data()[,var1]) == 'factor',class(data()[,var2]) == 'factor')]
                        cont_var <- c(paste(var1),paste(var2))[!c(class(data()[,var1]) == 'factor',class(data()[,var2]) == 'factor')]
                        nlevels <- length(levels(data()[,factor_var]))
                        x[j:(j+nlevels-2)] <- paste(factor_var,levels(data()[,factor_var])[-1],'*',cont_var,sep='')
                        j=j+nlevels-1
                      }
                    } else if (class(data()[,input$iv[i]])=='factor'){
                      nlevels <- length(levels(data()[,input$iv[i]]))
                      x[j:(j+nlevels-2)] <- paste(input$iv[i],levels(data()[,input$iv[i]])[-1],sep='')
                      j=j+nlevels-1
                    } else {
                      x[j] <- input$iv[i]
                      j=j+1
                    }
                  }
                  x
            })
  
  ## State whether informative priors will be provided.
  output$num_priors = renderUI({
    if(!is.null(input$datafile) & !is.null(input$iv)){radioButtons('num_priors', label='Do you want to specify normal prior distributions?', choices=c('No','Yes'))}
    else(paste('Please upload your training data and select modeling variables.'))
  })

  ## Create pretty presentation of training data.  
  output$data_table <- renderDataTable({
    data()
  })

  ## Create pretty presentation of test data.
  output$data_table_test <- renderDataTable({
    data_test()
  })

  ## Input mean and SD for normal priors.
  output$norm_options = renderUI({
  lapply(1:(length(updated_iv())+1), function(i) {
    use <- c('Intercept',updated_iv())
    list(numericInput(paste0('prior_norm_mu_',i), label=paste('Mean of Normal prior distribution for',use[i]), value=0),
    numericInput(paste0('prior_norm_sd_',i), label=paste('Standard deviation of Normal prior distribution for', use[i]), value=1, min=0))
  })
  })

  ## Error message if no test data is available.
  output$test_upload <- renderUI({
    if(is.null(input$datafile_test))
    {HTML(paste('Please upload your test data.'))}
  })

  ## Message to state no prior distributions are being used.
  output$text1 <- renderText({
    paste('You have chosen not to provide a prior distibution')
  })
  
  ## Extract mean for mutlitvariate normal prior. Embed in text.
  para1 <- reactive({
    lapply(1:(length(updated_iv())+1), function(i) {paste('Mean=',eval(parse(text=paste0('input$prior_norm_mu_',i))))})
  })
  
  ## Extract SD for multivariate normal prior. Embed in text.
  para2 <- reactive({
    lapply(1:(length(updated_iv())+1), function(i) {paste('SD=',eval(parse(text=paste0('input$prior_norm_sd_',i))))})
  })
  
  ## Simulate data to plot prior distributions.
  data1 <- reactive({
  
    if (input$num_priors =='No') {seq(0,100)}
    else {
    lapply(1:(length(updated_iv())+1), function(i){rnorm(1000, eval(parse(text=paste0('input$prior_norm_mu_',i))), eval(parse(text=paste0('input$prior_norm_sd_',i))))})
    }
  })
  
  ## Plot prior distributions
  output$prior <- renderPlot({
    if (input$num_priors =='No') {plot.new()}else{
    par(mfrow=c(2,(ceiling((length(updated_iv())+1)/2))))
    use <- c('Intercept',updated_iv())
    for(i in 1:(length(updated_iv())+1)){
    hist(data1()[[i]], main=paste(use[i],': ', 'Normal',' (',para1()[[i]],', ',para2()[[i]],')', sep=''), xlab='')
    }}
  })
  
  ## Extract mean for multivariate normal.
  b0 <- reactive({
    b0=vector()
    for (i in 1:(length(updated_iv())+1)){b0[i]=strsplit(unlist(para1()),'=')[[i]][2]}
    b0 <- as.numeric(b0)
  })
  
  ## Extract SD for multivariate normal.
  B0 <- reactive({
    B0=vector()
    for (i in 1:(length(updated_iv())+1)){B0[i]=strsplit(unlist(para2()),'=')[[i]][2]}
    B0 <- as.numeric(B0)
  })
  
  ## Dummy version of dependent variable.
  updated_dv <- reactive({
    paste(input$dv,1,sep='')
  })

  ## Build logitistic regression model.
  model1 <- reactive({
    if (is.null(input$num_priors) || input$num_priors=='No')
    {model_mcmc( data_dummied_factors(), updated_iv(), updated_dv(), b0(), B0(), 'No')}
    else {model_mcmc( data_dummied_factors(), updated_iv(), updated_dv(), b0(), B0(), 'Yes')}
  })
  
  ## Extract model .
  model <- reactive({
    model1()
  })
  
  ## Create model summary.
  output$model_summary <- renderPrint({
    if (!is.null(input$datafile) & !is.null(input$iv))
    summary(model())
    else(paste('Please upload your training data and select modeling variables.'))
  })
  
  ## Create density and trace plots of model.
  output$model_plot <- renderPlot({
    if(!is.null(input$datafile) & !is.null(input$iv))
    {plot(model())}
    else(paste('Please upload your training data and select modeling variables.'))
  })
  
  ## Perform ROC analysis.
  roc <- reactive({
    roc_mcmc_logit_app(model(), data_dummied_factors_test(), updated_dv(), updated_iv())
  })

  ## Create ROC plot.
  output$roc_plot <- renderPlot({
    if (!is.null(input$datafile) && !is.null(input$iv) && !is.null(input$datafile_test))
    {plot(roc()$perf, colorize=TRUE, main='ROC Curve')
    legend(0.7, 0.2, roc()$auc, border="white", cex=1.7, box.col = "white")}
  })
  
  ## Text to explain how the model is built.
  output$model_explain <- renderUI({
    if(!is.null(input$datafile) & !is.null(input$iv)){
    str1 <- paste('The Bayesian logistic regression model built here uses the R package MCMCpack (http://www.jstatsoft.org/v42/i09/).')
    str2 <- paste('We use 13,000 iterations of the Metropolis algorithm for MCMC sampling and discard 3,000 as burn-in.')
    str3 <- paste('If priors are not specified, improper uniform priors are used.')
    HTML(paste(str1, str2, str3, '</br>', sep='</br></br>'))}
  })

  ## Help text.
  output$dv_explain <- renderUI({
    if(!is.null(input$datafile)){
    HTML(paste('The dependent variable must be binary.'))}
  })

  ## Help text.
  output$interactions_explain <- renderUI({
    if(!is.null(input$datafile)){
    HTML(paste('If you choose to include an interaction term be sure to include the variables individually too.'))}
  })

  ## Button to download model plots.
  observe({
    if (!is.null(input$iv) && !is.null(input$datafile))
    {session$sendCustomMessage("download_ready_plots", list(fileSize=floor(runif(1) * 10000)))}
  })

  ## Code behind above button.
  output$downloadPlots <- downloadHandler(
    filename = 'bayes_logistic_regression_plots.pdf',
    content = function(file) {
      pdf(file)
      plot(model())
      dev.off()
    }
  )

  ## Button to download ROC plots.
  observe({
    if (!is.null(input$iv) && !is.null(input$datafile_test))
    {session$sendCustomMessage("download_ready_ROCplot", list(fileSize=floor(runif(1) * 10000)))}
  })

  ## Code behind above button.
  output$downloadROC <- downloadHandler(
    filename = 'bayes_logistic_regression_ROCplot.pdf',
    content = function(file) {
      pdf(file)
      plot(roc()$perf, colorize=TRUE, main='ROC Curve')
      legend(0.7, 0.2, roc()$auc, border="white", box.col = "white")
    dev.off()
    }
  )

  ## Button to download model summary.
  observe({
    if (!is.null(input$iv))
      {session$sendCustomMessage("download_ready_summary", list(fileSize=floor(runif(1) * 10000)))}
  })

  ## Code behind above button.
  output$downloadSummary <- downloadHandler(
    filename = 'bayes_logistic_regression_summary.txt',
    content = function(file) {
      sink(file)
      print(summary(model()))
      sink(NULL)
    }
  )

  ## Create summary of results in test data.
  output$test_summary <- renderPrint({
    if (!is.null(input$datafile) && !is.null(input$iv) && !is.null(input$datafile_test))
    {predict_mcmc_logit_app(model(), data_dummied_factors_test(), updated_dv())}
    else(paste('Please upload your training data, test data and select modeling variables.'))
  })

  ## Button to download summary results in test data.
  observe({
    if (!is.null(input$iv) && !is.null(input$datafile_test))
    {session$sendCustomMessage("download_ready_summary_test", list(fileSize=floor(runif(1) * 10000)))}
  })

  ## Code behind above button.
  output$downloadTestSummary <- downloadHandler(
    filename = 'bayes_logistic_regression_test_set_results.txt',
    content = function(file) {
      sink(file)
      print(predict_mcmc_logit_app(model(), data_dummied_factors_test(), updated_dv()))
      sink(NULL)
    }
  )

  ## Text to explain variable selection.
  output$var_selection_explain <- renderUI({
    if(!is.null(input$var_selection) && input$var_selection =='Yes'){
      str1 <- paste('Variable selection is performed through the BoomSpikeSlab package in R (https://cran.r-project.org/package=BoomSpikeSlab).')
      str2 <- paste('The algorithm places some amount of posterior probability at zero for a subset of regression coefficients.')
      str3 <- paste('When a prior distribution is specified the means of the normal distributions are included as the initial values for the MCMC algorithm.')
      str4 <- paste('Default parameter values are used with 13,000 iterations. 3,000 of these are discared as burn-in.')
      str5 <- paste('')
      HTML(paste(str1, str2, str3, str4, str5, '</br>', sep='</br></br>'))}
    else if (!is.null(input$var_selection) && input$var_selection =='No') {HTML(paste('You have chosen not to view variable selection information.'))}
    else {paste('Please upload your training data, select modeling variables and state whether you want to see variable selection information.')}
  })

  ## Build model including variable selection.
  model_with_selection <- reactive({

    if(!is.null(input$var_selection) && input$var_selection =='Yes'){
    
      if (is.null(input$num_priors) || input$num_priors=='No'){
      
        model_var_selection(data_dummied_factors(), updated_iv(), updated_dv(), 'No')
      
      } else {
    
        model_var_selection(data_dummied_factors(), updated_iv(), updated_dv(), 'Yes', b0())
  
      }
    }
  })

  ## Create summary of model with variable selection.
  output$model_with_selection_summary <- renderPrint({
    if (!is.null(input$var_selection) && input$var_selection=='Yes'){
        summary(model_with_selection(), burn=3000)
    }
  })

  ## Button to download summary of variable selection model.
  observe({
    if (!is.null(input$var_selection) && input$var_selection=='Yes')
    {session$sendCustomMessage("download_ready_summary_with_selection", list(fileSize=floor(runif(1) * 10000)))}
  })
  
  ## Code behind above button.
  output$downloadSummaryWithSelection <- downloadHandler(
    filename = 'bayes_logistic_regression_variable_selection_summary.txt',
    content = function(file) {
      sink(file)
      print(summary(model_with_selection(), burn=3000))
      sink(NULL)
    } 
  )

  ## Create plot of variable selection probabilities.
  output$model_with_selection_plot <- renderPlot({
    if (!is.null(input$var_selection) && input$var_selection=='Yes')
    {plot(model_with_selection())}
  })

  ## Button to download above plot.
  observe({
    if (!is.null(input$var_selection) && input$var_selection=='Yes')
    {session$sendCustomMessage("download_ready_selection_plot", list(fileSize=floor(runif(1) * 10000)))}
  })

  ## Code behind above button.
  output$downloadSelectionPlot <- downloadHandler(
    filename = 'bayes_logistic_regression_variable_selection_plot.pdf',
    content = function(file) {
      pdf(file)
      plot(model_with_selection())
      dev.off()
    } 
  )

  ## Slider to change the inclusion probability threshold for variable selection.
  output$cutoff_prob <- renderUI({
    if (!is.null(input$var_selection) && input$var_selection=='Yes')
    {sliderInput('cutoff_prob', label='Posterior probability cut-off for variable selection.', value=0.5, min = 0, max = 1)}
  })

  ## Vraibles included in model based on inclusion threshold defined above.
  variables_prob_0.5 <- reactive({
  
    if (!is.null(input$var_selection) && input$var_selection=='Yes')
    {x <- names(summary(model_with_selection(), burn = 3000)$coefficients[,5])[summary(model_with_selection(), burn = 3000)$coefficients[,5] > input$cutoff_prob]
    x <- x[!(x %in% '(Intercept)')]
    if (length(x) != 0) {
      count <- 0
      j <- rep(0, length(x))
      for (i in 1:length(x)){
        if (grepl('factor.:', x[i]) && count == 0){
          x[i] <- gsub('factor.:','factor:',x[i])
          x[i] <- gsub('factor\\d','factor',x[i])
          count <- 1
        } else if (grepl('.factor', x[i]) && count == 0){
          x[i] <- substr(x[i], 1, (regexpr('.factor', x[i])[1]+6))
          count <- 1
        } else if (grepl('.factor', x[i]) && count == 1){
          j[i] <- i
        }
        if (i!=length(x) && substr(x[i], 1, (regexpr('.factor', x[i])[1]+6)) != substr(x[i+1], 1, (regexpr('.factor', x[i+1])[1]+6))){count <- 0}
        if (grepl(':',x[i])) {x[i] <- gsub(':','*',x[i])}
      }
      if (sum(j)>0) {x <- x[-j]}
    }
    x
    }
  
  })

  ## Text stating which variables meet the inclusion probability threshold.
  output$variables_prob_0.5_text <- renderUI({
    if(!is.null(input$var_selection) && input$var_selection=='Yes'){
      if (length(variables_prob_0.5())!=0){
        str1 <- 'The following variables have a posterior inclusion probability of > '
        HTML(paste(str1, input$cutoff_prob, ':', paste(variables_prob_0.5(), collapse=', ')))}
      else {paste('No variables have a posterior inclusion probability of > ', input$cutoff_prob, '.')}}
  })

  ## Button to re-run the modelling only including variables meeting the inclusion threshold.
  output$remodel = renderUI({
    if(!is.null(input$var_selection) && input$var_selection=='Yes' && length(variables_prob_0.5())!=0){actionButton('remodel', label='Re-run analysis with only these variables?')}
  })
  
  ## If above button is clicked, return to training data tab.
  observe({
    if (!is.null(input$remodel) && input$remodel > 0) {
      updateTabsetPanel(session, "tabs", selected = "Training data")}
  })

  output$activeTab <- reactive({
    return(input$tab)
  })

  outputOptions(output, 'activeTab', suspendWhenHidden=FALSE)

})

