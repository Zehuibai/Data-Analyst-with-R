Repnorm <- repeatable(rnorm)  # A replicable wrapper for rnorm


normalDataFrame <- function(vars = 1, n = 1000, replicable=F){
  ## A function to create a data frame of vars-number variables X n-numbers rows of random normal data n ~ (0, 1)
  
  if(vars < 1 | n < 1){
    # If there are no variables and an n of 0
    return(NULL)
  }
  
  data <- data.frame(x1=rep(0, n))
  
  if(replicable == T){  
    # If the data are to be replicable
    for(i in 1:vars){
      data[paste0('x', toString(i))] <- Repnorm(n)
    }
  }
  if(replicable == F){
    # If the data are to be unique
    for(i in 1:vars){
      data[paste0('x', toString(i))] <- rnorm(n)
    }
  }
  return(data)
}



logitdat <- function(vars = 1, weights, n = 1000, bias=0, replicable=T) {
  ## A function to create a data frame of vars-number variables and n-numbers rows
  #  of random normal data n ~ (0, 1)
  
  # Create a data set of vars X n random normal deviates.  Make the data repeatable or not (T/F)
  logit_data <- normalDataFrame(vars, n, replicable)
  
  if(is.null(logit_data)){
    return(NULL)
  }
  
  if(length(weights) != vars){
    # Make sure there are the right number of b-weights
    weights <- rep(1, vars)
  }
  
  bias <- -log(1/bias - 1) # Convert
  z <- bias + rowSums(t(t(as.matrix(logit_data)) * weights)) # linear combination with a bias
  pr <- 1/(1 + exp(-z))  # pass through an inv-logit function
  logit_data['y'] <- rbinom(n, 1, pr)  # bernoulli response variable
  return(logit_data)
}


invlogit <- function(x){
  # A function to calculate the inverse of the logit
  exp(x)/(1+exp(x))
}