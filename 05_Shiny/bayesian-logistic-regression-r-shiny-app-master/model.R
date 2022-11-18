## File providing functions that are called by the application.

## Function defining a beta distribution for use as a prior
## Not utilised in current version.
log_beta_prior <- function(x, scale1, scale2) {
  
  sum(dbeta(x, scale1, scale2, log = T))
  
}


## Function to implement variable selection in the Bayesian logistic regression.
## Uses spike slab priors to do so.
## If any other prior information is provided, the means are used as initial values. 
model_var_selection <- function(data, x, y, num_priors, b0=NULL) {
  
  formula <- paste(y,'~',paste(x,collapse='+')) 
  
  if (num_priors =='Yes') {
  
    logit.spike(as.formula(formula), data, niter=13000, initial.value = b0, ping=0)
  
  } else {
    
    logit.spike(as.formula(formula), data, niter=13000, ping=0)
    
  }
  
}


## Function to perform modeling using a Bayesian logistic regression.
## Prior information is included as a multivariate normal prior.

model_mcmc <- function(data, x, y, b0, B0, num_priors) {
  
  formula <- paste(y,'~',paste(x,collapse='+')) 
  
  if (num_priors =='Yes') {
    
  MCMClogit(as.formula(formula), data, b0=b0, B0=1/(B0^2), burnin=3000, mcmc=10000)
  
  }  else {
    
  MCMClogit(as.formula(formula), data, burnin=3000, mcmc=10000)
    
 }
  
}



## Function to take an existing Bayesian logistic regression model and create predictions in new data.
## Use if test data is not dummied.
predict_mcmc_logit <- function(mod, newdata, dv, snp=NULL){
  
  # Extract the estimates from the model.
  estimates <- summary(mod)$statistics[,1]
 
  # Extract the names of all variables in the model.
  names <- rownames(summary(mod)$statistics)[!(rownames(summary(mod)$statistics) %in% '(Intercept)')]
  
  # Format the names of the variables in the model.
  names_updated <- names
  count <- 0
  j <- rep(0, length(names_updated))
  for (i in 1:length(names_updated)){
    if (grepl('factor.:', names_updated[i]) && count == 0){
      names_updated[i] <- gsub('factor.:','factor:',names_updated[i])
      names_updated[i] <- gsub('factor\\d','factor',names_updated[i])
      count <- 1
    } else if (grepl('.factor', names_updated[i]) && count == 0){
      names_updated[i] <- substr(names_updated[i], 1, (regexpr('.factor', names_updated[i])[1]+6))
      count <- 1
    } else if (grepl('.factor', names_updated[i]) && count == 1){
      j[i] <- i
    }
    if (i!=length(names_updated) && substr(names_updated[i], 1, (regexpr('.factor', names_updated[i])[1]+6)) != substr(names_updated[i+1], 1, (regexpr('.factor', names_updated[i+1])[1]+6))){count <- 0}
    if (grepl(':',names_updated[i])) {names_updated[i] <- gsub(':','*',names_updated[i])}
  }
  if (sum(j)>0) {names_updated <- names_updated[-j]}

  ## Check names and estimates are in alphabetical order so they can be matched up.
  if(length(names_updated) > 1) {estimates <- estimates[sort(names(estimates))]}
  names_updated <- sort(names_updated)
  
  ## Create a model matrix from the new data.
  formula <- paste(dv,'~',paste(names_updated,collapse='+')) 
  newdata_reduced <- model.matrix(as.formula(formula), newdata)
  
  ## Create the probability estimates
  probs <- estimates %*% t(newdata_reduced)
  probs <- exp(probs)/(1+exp(probs))
 
  ## Assign each sample to a class using a probability cut off of 0.5
  class <- as.numeric(probs > 0.5)
  class <- factor(class, levels=c('0','1'))

  ## Give snp a value if it is null.
  if(is.null(snp)) {snp <- names_updated}
  
  ## Create confusion matrix
  if (!is.null(snp) && length(snp)>1){
    cm <- confusionMatrix(class, newdata[apply(is.na(newdata[,snp]), 1, sum)==0,dv], positive='1')
  } else if (!is.null(snp) && length(snp)==1){
    cm <- confusionMatrix(class, newdata[!is.na(newdata[,snp]),dv], positive='1')
  } else {
    cm <- confusionMatrix(class, newdata[,dv], positive='1')
  }
  
  ## Create output for app
  list('Probability of class 1'=probs, 'Classification'=class, 'Confusion Matrix'=cm)
  
}









## Function to take an existing Bayesian logistic regression model and create predictions in new data.
## Use if test data is dummied
predict_mcmc_logit_app <- function(mod, newdata, dv, snp=NULL){
  
  # Extract the estimates from the model.
  estimates <- summary(mod)$statistics[,1]
  
  # Extract the names of all variables in the model.
  names <- rownames(summary(mod)$statistics)[!(rownames(summary(mod)$statistics) %in% '(Intercept)')]
  
  ## Check names and estimates are in alphabetical order so they can be matched up.
  if(length(names) > 1) {estimates <- estimates[sort(names(estimates))]}
  names <- sort(names)
  
  ## Create a model matrix from the new data.
  formula <- paste(dv,'~',paste(names,collapse='+')) 
  newdata_reduced <- model.matrix(as.formula(formula), newdata)
  
  ## Create the probability estimates
  probs <- estimates %*% t(newdata_reduced)
  probs <- exp(probs)/(1+exp(probs))
  
  ## Assign each sample to a class using a probability cut off of 0.5
  class <- as.numeric(probs > 0.5)
  class <- factor(class, levels=c('0','1'))
  
  ## Create confusion matrix
  if (!is.null(names) && length(names)>1){
    cm <- confusionMatrix(class, newdata[apply(is.na(newdata_reduced), 1, sum)==0,dv], positive='1')
  } else if (!is.null(names) && length(names)==1){
    cm <- confusionMatrix(class, newdata[!is.na(newdata_reduced[,names]),dv], positive='1')
  } else {
    cm <- confusionMatrix(class, newdata[,dv], positive='1')
  }
  
  ## Create output for app
  list('Probability of class 1'=probs, 'Classification'=class, 'Confusion Matrix'=cm)
  
}



## Function to take an existing Bayesian logistic regression model and create predictions in new data.
### Use when test data is dummied and you are interested in varying the probability threshold for classification.
predict_mcmc_logit_app_varycutoff <- function(mod, newdata, dv, snp=NULL, cut_off){
  
  # Extract the estimates from the model.
  estimates <- summary(mod)$statistics[,1]
  
  # Extract the names of all variables in the model.
  names <- rownames(summary(mod)$statistics)[!(rownames(summary(mod)$statistics) %in% '(Intercept)')]
  
  ## Check names and estimates are in alphabetical order so they can be matched up.
  if(length(names) > 1) {estimates <- estimates[sort(names(estimates))]}
  names <- sort(names)
  
  ## Create a model matrix from the new data.
  formula <- paste(dv,'~',paste(names,collapse='+')) 
  newdata_reduced <- model.matrix(as.formula(formula), newdata)
  
  ## Create the probability estimates
  probs <- estimates %*% t(newdata_reduced)
  probs <- exp(probs)/(1+exp(probs))
  
  ## Assign each sample to a class using a probability cut off:cut_off
  class <- as.numeric(probs > cut_off)
  class <- factor(class, levels=c('0','1'))
  
  ## Create confusion matrix
  if (!is.null(names) && length(names)>1){
    cm <- confusionMatrix(class, newdata[apply(is.na(newdata_reduced), 1, sum)==0,dv], positive='1')
  } else if (!is.null(names) && length(names)==1){
    cm <- confusionMatrix(class, newdata[!is.na(newdata_reduced[,names]),dv], positive='1')
  } else {
    cm <- confusionMatrix(class, newdata[,dv], positive='1')
  }
  
  ## Create output for app
  list('Probability of class 1'=probs, 'Classification'=class, 'Confusion Matrix'=cm)
  
}









## Function to take an existing Bayesian logistic regression model and produce an ROC curve using new data.
## Use if test data is not dummied.
roc_mcmc_logit <- function(mod, newdata, dv, snp=NULL){
  
  # Extract the estimates from the model.
  estimates <- summary(mod)$statistics[,1]
  
  # Extract the names of all variables in the model.
  names <- rownames(summary(mod)$statistics)[!(rownames(summary(mod)$statistics) %in% '(Intercept)')]
  
  # Format the names of the variables in the model.
  names_updated <- names
  count <- 0
  j <- rep(0, length(names_updated))
  for (i in 1:length(names_updated)){
    if (grepl('factor.:', names_updated[i]) && count == 0){
      names_updated[i] <- gsub('factor.:','factor:',names_updated[i])
      names_updated[i] <- gsub('factor\\d','factor',names_updated[i])
      count <- 1
    } else if (grepl('.factor', names_updated[i]) && count == 0){
      names_updated[i] <- substr(names_updated[i], 1, (regexpr('.factor', names_updated[i])[1]+6))
      count <- 1
    } else if (grepl('.factor', names_updated[i]) && count == 1){
      j[i] <- i
    }
    if (i!=length(names_updated) && substr(names_updated[i], 1, (regexpr('.factor', names_updated[i])[1]+6)) != substr(names_updated[i+1], 1, (regexpr('.factor', names_updated[i+1])[1]+6))){count <- 0}
    if (grepl(':',names_updated[i])) {names_updated[i] <- gsub(':','*',names_updated[i])}
  }
  if (sum(j)>0) {names_updated <- names_updated[-j]}
  
  ## Check names and estimates are in alphabetical order so they can be matched up.
  if(length(names_updated) > 1) {estimates <- estimates[sort(names(estimates))]}
  names_updated <- sort(names_updated)
  
  ## Create a model matrix from the new data.
  formula <- paste(dv,'~',paste(names_updated,collapse='+')) 
  newdata_reduced <- model.matrix(as.formula(formula), newdata)
  
  ## Create the probability estimates
  probs <- estimates %*% t(newdata_reduced)
  probs <- exp(probs)/(1+exp(probs))
  
  if (!is.null(snp) && length(snp)>1){
    pred <- prediction(probs[1,], factor(newdata[apply(is.na(newdata[,snp]), 1, sum)==0,dv], levels=c(0,1), ordered=T))
  } else if (!is.null(snp) && length(snp)==1){
    pred <- prediction(probs[1,], factor(newdata[!is.na(newdata[,snp]),dv], levels=c(0,1), ordered=T))
  } else {
    pred <- prediction(probs[1,], factor(newdata[,dv], levels=c(0,1), ordered=T))
  }
  
  perf <- performance(pred,"tpr","fpr")
  auc <- performance(pred,"auc")
  auc <- unlist(slot(auc, "y.values"))
  auc <-round(auc, digits = 3)
  auc <- paste(c("AUC  = "),auc,sep="")

  list('perf'=perf, 'auc'=auc)
  
}


## Function to take an existing Bayesian logistic regression model and produce an ROC curve using new data.
# Use if test data is dummied
roc_mcmc_logit_app <- function(mod, newdata, dv, snp=NULL){
  
  # Extract the estimates from the model.
  estimates <- summary(mod)$statistics[,1]
  
  # Extract the names of all variables in the model.
  names <- rownames(summary(mod)$statistics)[!(rownames(summary(mod)$statistics) %in% '(Intercept)')]
  
  ## Check names and estimates are in alphabetical order so they can be matched up.
  if(length(names) > 1) {estimates <- estimates[sort(names(estimates))]}
  names <- sort(names)
  
  ## Create a model matrix from the new data.
  formula <- paste(dv,'~',paste(names,collapse='+')) 
  newdata_reduced <- model.matrix(as.formula(formula), newdata)
  
  ## Create the probability estimates
  probs <- estimates %*% t(newdata_reduced)
  probs <- exp(probs)/(1+exp(probs))

  if (!is.null(names) && length(names)>1){
    pred <- prediction(probs[1,], factor(newdata[apply(is.na(newdata_reduced), 1, sum)==0,dv], levels=c(0,1), ordered=T))
  } else if (!is.null(names) && length(names)==1){
    pred <- prediction(probs[1,], factor(newdata[!is.na(newdata_reduced[,names]),dv], levels=c(0,1), ordered=T))
  } else {
    pred <- prediction(probs[1,], factor(newdata[,dv], levels=c(0,1), ordered=T))
  }
  
  perf <- performance(pred,"tpr","fpr")
  auc <- performance(pred,"auc")
  auc <- unlist(slot(auc, "y.values"))
  auc <-round(auc, digits = 3)
  auc <- paste(c("AUC  = "),auc,sep="")
  
  list('perf'=perf, 'auc'=auc)
  
}



