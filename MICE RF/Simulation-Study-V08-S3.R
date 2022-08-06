#---------------------------------------------------------------------------------------------#
# Project:              R code for simulation study (Master Thesis)
# Title:                Random Forests for Multiple Imputation of Missing Data in IDEFICS study
# Autor:                Zehui Bai
# Field:                Medical Biometry / Biostatistics
# Version:              Version 08
# Date:                 21/OCT/2020
# Details:              Simulation using linear regression S3
#---------------------------------------------------------------------------------------------#



#---------------------------------------------------------------------------------------------#
#                                 Load required packages                                      #
#---------------------------------------------------------------------------------------------#


# load package
pkgs = c("mosaic","mice","CALIBERrfimpute","micd","parallel","ggm","pcalg")  
inst = lapply(pkgs, library, character.only = TRUE) 


#---------------------------------------------------------------------------------------------#
#                                    Prepare Datasets                                         #
#---------------------------------------------------------------------------------------------#


load("C:/Users/Public/Documents/Bai (BIPS)/Masterarbeit/data.RData")
data <- data[,c(2,3,4,7,9)]
names(data) <- c("age","sex","bmi","isced","waist")


## completet case, omit all rows that contain NA values
data$sex <- as.factor(data$sex)
data$isced <- as.factor(data$isced)
data_complete <- data[complete.cases(data),]
data_complete <- data_complete[data_complete$isced!="NaN",]

## refactor isced_max
data_complete$isced[data_complete$isced %in% c("0", "1")] <- "1"
data_complete$isced[data_complete$isced %in% c("5", "6")] <- "5"
data_complete$isced <- factor(data_complete$isced,levels = c("1","2","3","4","5"))

## transform waist to log.waist
data_complete$log.waist <- log(data_complete$waist)
data_complete <- data_complete[-5]
str(data_complete)



#---------------------------------------------------------------------------------------------#
#                               Functions: Data generating                                    #
#---------------------------------------------------------------------------------------------#

## sample n=2000 from complete datasets for linear regression
datasample <- function(x,n){
  x <- data_complete[sample(1:nrow(data_complete), 
                            n, replace=TRUE), ]
  return(x)
}



## sample n=2000 from complete datasets 
## for type 1 error of conditional independent tests
dataCITerror <- function(x,n){
  x <- data_complete[sample(1:nrow(data_complete), 
                            n, replace=TRUE), ]
  Model <- lm(bmi ~  age, data=x)
  ## delete all observations in variabe Y='bmi'
  x_miss <- x[,-3]
  ## extract coeficients
  coef <- coef(Model) 
  ## generate new bmi
  x_miss$bmi <- coef[1]+coef[2]*x_miss$age + rnorm(n, mean=0, sd=summary(Model)$sigma)
  x_miss <- x_miss[,c(1,2,5,3,4)]
  return(x_miss)
}



## generate missing data under MAR
## using ampute from "mice" package
makeMarlm <- function(data, missratio, missdata){
  ## convert to numeric datatype
  ## the calculation of weights requires numeric data 
  data$sex <- as.numeric(data$sex)
  data$isced <- as.numeric(data$isced)
  ampute_result1 <- ampute(data, prop = missratio, 
                           mech = "MAR")
  mypatterns <- ampute_result1$patterns
  ## make sure "waist" and 'sex' no missing
  mypatterns <- mypatterns[c(-2,-5),]
  mypatterns <- rbind(mypatterns,c(0,1,0,1,1),
                      c(0,1,1,0,1),c(1,1,0,0,1),c(0,1,0,0,1))
  ## using new predict matrix
  ampute_result2 <- ampute(data, prop = missratio, 
                           mech = "MAR", patterns = mypatterns)
  missdata <- data.frame(ampute_result2$amp)
  ## convert to factor
  missdata$sex <- as.factor(missdata$sex)
  missdata$isced <- as.factor(missdata$isced)
  ## check the missing pattern
  ## dev.off()
  ## md.pattern(missdata)
  return(missdata)
}




#---------------------------------------------------------------------------------------------#
#                                 Functions: perform MICE                                     #
#---------------------------------------------------------------------------------------------#

## impute data using MICE 
domice <- function(missdata, functions, reps = 10){
  ## conduct mice with specified function: parametric MICE using pmm
  ## random forest MICE using rfcont10 or rfcont100 for continous variables 
  ## using rfcat for catagorical variable
  mids <- mice(missdata, defaultMethod = functions,
               m = reps, visitSequence = 'monotone',
               printFlag = FALSE, maxit = 10)
  return(mids)
}

## RF MICE for continous variables
## n trees = 10
mice.impute.rfcont10 <- function(y, ry, x, ...){
  mice.impute.rfcont(y = y, ry = ry, x = x, ntree_cont = 10)
}
## n trees = 100
mice.impute.rfcont100 <- function(y, ry, x, ...){
  mice.impute.rfcont(y = y, ry = ry, x = x, ntree_cont = 100)
}




#---------------------------------------------------------------------------------------------#
#                              Functions: perform the analysis                                #
#---------------------------------------------------------------------------------------------#


## Full data analysis for simulation study
lmfull <- function(data){
  ## fit models
  fit <- summary(lm(formular, data = data))
  coefs <- fit$coefficients[ , 1]  
  se <- fit$coefficients[ , 2]
  ## return a vector of coefficients (est)
  ## upper and lower 95% limits 
  confint <- cbind(coefs - qnorm(0.975) * se,
                   coefs + qnorm(0.975) * se) 
  ## calculate coverage
  cover <- ifelse(consist_coef >= confint[,1] & 
                    consist_coef <= confint[,2],1,0)
  p.value <- fit$coefficients[,4]
  out <- cbind(coefs, confint, cover, p.value)
  ## rename
  colnames(out) <- c('est', 'lo 95', 'hi 95', 'cover', 'p value')
  rownames(out) <- c('(Intercept)', 'age', 'bmi', 'sex', 
                     'isced[2]','isced[3]','isced[4]','isced[5]',
                     'age:sex','age:bmi')
  out
}





## Analyses a list of imputed data sets
lmimpute <- function(imputed_datasets){
  ## The as.mira() function takes the results of 
  ## repeated complete-data analysis stored as a list,
  ## Turns it into a mira object that can be pooled.
  dolmmodel <- function(data){
    lm(formular, data=data)
  }
  reps=10
  list_fit <- lapply(1:reps, function(x) 
    complete(imputed_datasets, x))
  mirafits <- as.mira(lapply(list_fit, dolmmodel))
  ## Linear performance
  out <- summary(pool(mirafits))
  ## draw estimates and std.error for CI and cover calculation 
  coefs <- out$estimate
  se <- out$std.error
  ## return a vector of coefficients (est)
  ## and upper and lower 95% limits 
  confint <- cbind(coefs - qnorm(0.975) * se,
                   coefs + qnorm(0.975) * se)    
  p.value <- out$p.value
  out <- cbind(coefs, confint, 
               consist_coef >= confint[,1] & 
                 consist_coef <= confint[,2], p.value)
  ## rename
  colnames(out) <- c('est', 'lo 95', 'hi 95', 'cover', 'p value')
  rownames(out) <- c('(Intercept)', 'age', 'bmi', 'sex', 
                     'isced[2]','isced[3]','isced[4]','isced[5]',
                     'age:sex','age:bmi')
  out
}







#---------------------------------------------------------------------------------------------#
#                                      Linear coefficients                                    #
#---------------------------------------------------------------------------------------------#

## Analysis model
formular <- log.waist ~  age + bmi + sex + isced + sex:age + age:bmi
best.fit <- lm(log.waist ~  age + bmi + sex + isced + sex:age + age:bmi, data = data_complete)
consist_coef <- summary(best.fit)$coefficients[ ,1]




#---------------------------------------------------------------------------------------------#
#                                   lm Analysis: Setting 3                                    #
#         Study on the impact of interaction and non-linearity on the performance of          #
#                                    MICE PMM and MICE RF                                     #
#---------------------------------------------------------------------------------------------#

doanalysis_lm_S3 <- function(x){
  
  ## generate datasets and create missing values
  data <- datasample(x,n=2000)
  missdata <- makeMarlm(data,missratio=0.2)
  
  ## create output listing
  out <- list()
  out$full <- lmfull(data)
  data$sex <- as.numeric(data$sex)
  data$isced <- as.numeric(data$isced)
  
  ## conditional independence test (power) alpha <- 0.05
  Fisher.p <- gaussCItest(5,3,1,list(C = cor(data), n = nrow(data)))
  ## correlation between log.waist and bmi given age
  pcor <- pcor(c(5,3,1),var(data))
  out$full <- cbind(out$full, 
                    Fisher.p=c(Fisher.p,rep("",9)),
                    pcor=c(pcor,rep("",9)))
  
  ## imputation using mice rf
  ## MICE RF 10
  setRFoptions(ntree_cat=10)
  options()$CALIBERrfimpute_ntree_cat
  mice.rf <- domice(missdata, c('rfcont10', '', 'rfcat', ''))
  out$rf10 <- lmimpute(mice.rf)
  
  ## convert longdata to transform data type as numeric
  long_rf10 <- complete(mice.rf, action='long', include=TRUE)
  long_rf10$sex <- as.numeric(long_rf10$sex)
  long_rf10$isced <- as.numeric(long_rf10$isced)
  # Convert back to Mids and calculate p-values
  short_rf10 <- as.mids(long_rf10)
  # Power: x=log.waist y=bmi z=age
  Fisher.p <- gaussCItestMI(5,3,1, short_rf10)
  out$rf10 <- cbind(out$rf10, Fisher.p=c(Fisher.p,rep("",9)))
  
  ## generate interaction terms and non-linear terms for passive imputaton
  missdata$sex <- as.numeric(missdata$sex)
  missdata$isced <- as.numeric(missdata$isced)
  missdata <- cbind(missdata, 
                    age.sex = NA, age.bmi = NA, age.isced = NA,
                    age.waist = NA, sex.bmi = NA, sex.isced = NA,
                    sex.waist = NA, bmi.isced = NA, bmi.waist = NA,
                    isced.waist = NA, 
                    age.age = NA, bmi.bmi = NA, waist.waist = NA)
  
  ## change the method and prediction for interactionterm, 
  ## using interaction term to predict vaiable bmi isced
  S3 <- mice(missdata, max = 0, print = FALSE)
  pred <- S3$pred
  pred["age",   c("sex.bmi","sex.isced","sex.waist","bmi.isced",
                  "bmi.waist","isced.waist","bmi.bmi","waist.waist")] <- 1
  pred["bmi",   c("age.sex","age.isced","age.waist","sex.isced",
                  "sex.waist","isced.waist","age.age","waist.waist")] <- 1
  pred["isced", c("age.sex","age.bmi","age.waist","sex.bmi","sex.waist",
                  "bmi.waist","age.age","bmi.bmi","waist.waist")] <- 1
  
  ## MICE PMM
  meth_pmm <- c("pmm","","pmm","pmm","",
                "~I(age*sex)","~I(age*bmi)","~I(age*isced)",
                "~I(age*log.waist)","~I(sex*bmi)","~I(sex*isced)",
                "~I(sex*log.waist)","~I(bmi*isced)","~I(bmi*log.waist)",
                "~I(isced*log.waist)","~I(age*age)","~I(bmi*bmi)",
                "~I(log.waist*log.waist)")
  mice.pmm <- mice(missdata, meth = meth_pmm, pred = pred, m = 10, 
                   visitSequence = 'monotone',
                   printFlag = FALSE, maxit = 10)
  ## Check the imputed dataset
  ## head(complete(mice.pmm,10))
  ## Power: x=log.waist y=bmi z=age
  Fisher.p <- gaussCItestMI(5,3,1, mice.pmm)

  ## Convert sex and isced to factor
  long_pmm <- complete(mice.pmm, action='long', include=TRUE)
  long_pmm$sex <- as.factor(long_pmm$sex)
  long_pmm$isced <- as.factor(long_pmm$isced)
  short_pmm <- as.mids(long_pmm)
  ## Linear regression estimation
  out$micepmm <- lmimpute(short_pmm)
  out$micepmm <- cbind(out$micepmm, 
                       Fisher.p=c(Fisher.p,rep("",9)))
  out
}



## carry out simulation studys
N <- 400
results_lm_S3 <- mclapply(1:N, doanalysis_lm_S3)
save(results_lm_S3, 
     file = "C:/Users/Public/Documents/Bai (BIPS)/Masterarbeit/results_lm_S3_400.RData")
 
N <- 600
results_lm_S3 <- mclapply(1:N, doanalysis_lm_S3)
save(results_lm_S3, 
     file = "C:/Users/Public/Documents/Bai (BIPS)/Masterarbeit/results_lm_S3_600.RData")



#---------------------------------------------------------------------------------------------#
#                                        Format Results                                       #
#                                       Linear Regression                                     #
#---------------------------------------------------------------------------------------------#


## Results: Linear Regression Performance
getParameter_lm <- function(method){
  ## draw the coefficient estimates
  estimates <- sapply(results, function(x){
    as.numeric(x[[method]][ , 'est'])
  })
  ## calculate bias of estimates 
  bias <- apply(estimates,1,mean) - consist_coef
  ## calculate the standard error of bias 
  se_bias <- apply(estimates,1,sd) / sqrt(ncol(estimates))
  ## calculate z score
  z <- bias / se_bias
  ## confidence interval length
  ci_len <- apply(sapply(results, function(x){
    as.numeric(x[[method]][ , 'hi 95']) - 
      as.numeric(x[[method]][ , 'lo 95'])
  }),1,mean)
  ## coverage of the unbiased estimates
  ci_cov <- apply(sapply(results, function(x){
    as.numeric(x[[method]][ , 'cover'])
  }),1,mean)
  ## summary the output and rename
  out <- cbind(bias, se_bias, z, ci_len, ci_cov)
  colnames(out) <- c('bias', 'se_bias', 'z_bias', 
                     'ci_len', 'ci_cov')
  out
}



Table_lm <- function(x,n){
  results_lm <- lapply(methods, 
                       function(x){getParameter_lm(x)})
  ## convert list to data.frame
  results_lm <- do.call(rbind.data.frame, results_lm)
  
  ## reorder
  results_lm <- cbind(results_lm, 
                      order1=rep(1:10,time=n),
                      order2=rep(1:n,each=10))
  results_lm <- results_lm[order(results_lm$order1,
                                 results_lm$order2),]
  ## format the names
  results_lm <- cbind(Variables=c('Intercept',rep('',n-1),
                                  'Age',rep('',n-1),
                                  'BMI',rep('',n-1),
                                  'Sex',rep('',n-1),
                                  'ISCED[2]',rep('',n-1),
                                  'ISCED[3]',rep('',n-1),
                                  'ISCED[4]',rep('',n-1),
                                  'ISCED[5]',rep('',n-1),
                                  'Age:Sex',rep('',n-1),
                                  'Age:BMI',rep('',n-1)),
                      Nodell=Model_names,
                      results_lm[,c(1,2,3,4,5)])
  ## format the decimal
  results_lm$bias <- round(results_lm$bias, 4)
  results_lm$se_bias <- round(results_lm$se_bias, 4)
  results_lm$z_bias <- round(results_lm$z_bias, 4)
  results_lm$ci_len <- round(results_lm$ci_len, 4)
  library(formattable)
  results_lm$ci_cov <- percent(results_lm$ci_cov,digits = 1)
  colnames(results_lm) <- c('Variables','Models','Bias', 
                            'SD', 
                            'Z-score', 
                            'CI length', 
                            'CI coverage')
  rownames(results_lm) <- NULL
  return(results_lm)
}






 


methods <- c('full', 'rf10', 'micepmm')
Model_names <- rep(c("Full data","RF MICE with 10 trees","Parametric MICE PMM"),times=10)
results <- results_lm_S3
resultsTable_lm_S3 <- Table_lm(results_lm_S3,3)



S3_1 <- cbind(resultsTable_lm_S1[c(33:34,36,37,38,40),], "Y/N"=rep("N",6),  order1=c(1:6), order2=rep(1,6))
S3_1$Models <- rep(c("Full data","MICE RF","MICE PMM"),2)
S3_2 <- cbind(Variables="", Models="", resultsTable_lm_S3[c(25:30),-c(1,2)], "Y/N"=rep("Y",6), order1=c(1:6),order2=rep(2,6))
S3 <- rbind(S3_1,S3_2)
S3 <- S3[order(S3$order1,S3$order2),]
S3 <- S3[,c(1,2,8,3,4,5,6,7)]
rownames(S3) <- NULL


knitr::kable(S3, 
             format  = "pandoc", 
             row.names = NA,
             caption = "The interactions (not) in imputation models")





 













#---------------------------------------------------------------------------------------------#
#                                   CIT Analysis: Setting 3                                   #
#         Study on the impact of interaction and non-linearity on the performance of          #
#                                    MICE PMM and MICE RF                                     #
#---------------------------------------------------------------------------------------------#

doanalysis_CIT_S3 <- function(x){
  
  data <- dataCITerror(x,n=2000)
  missdata <- makeMarlm(data,missratio=0.2)
  
  ## create output listing
  out <- list()
  
  data$sex <- as.numeric(data$sex)
  data$isced <- as.numeric(data$isced)
  
  ## conditional independence test (power) alpha <- 0.05
  Fisher.p <- gaussCItest(5,3,1,list(C = cor(data), n = nrow(data)))
  ## correlation between log.waist and bmi given age
  pcor <- pcor(c(5,3,1),var(data))
  out$full <- cbind(NULL, 
                    Fisher.p=c(Fisher.p,rep("",9)),
                    pcor=c(pcor,rep("",9)))

  ## imputation using mice rf
  ## MICE RF 10
  setRFoptions(ntree_cat=10)
  options()$CALIBERrfimpute_ntree_cat
  mice.rf <- domice(missdata, c('rfcont10', '', 'rfcat', ''))
  
  ## convert longdata to transform data type as numeric
  long_rf10 <- complete(mice.rf, action='long', include=TRUE)
  long_rf10$sex <- as.numeric(long_rf10$sex)
  long_rf10$isced <- as.numeric(long_rf10$isced)
  # Convert back to Mids and calculate p-values
  short_rf10 <- as.mids(long_rf10)
  # Power: x=log.waist y=bmi z=age
  Fisher.p <- gaussCItestMI(5,3,1, short_rf10)
  out$rf10 <- cbind(NULL, Fisher.p=c(Fisher.p,rep("",9)))
  
  ## generate interaction terms and non-linear terms for passive imputaton
  missdata$sex <- as.numeric(missdata$sex)
  missdata$isced <- as.numeric(missdata$isced)
  missdata <- cbind(missdata, 
                    age.sex = NA, age.bmi = NA, age.isced = NA,
                    age.waist = NA, sex.bmi = NA, sex.isced = NA,
                    sex.waist = NA, bmi.isced = NA, bmi.waist = NA,
                    isced.waist = NA, 
                    age.age = NA, bmi.bmi = NA, waist.waist = NA)
  
  ## change the method and prediction for interactionterm, 
  ## using interaction term to predict vaiable bmi isced
  S3 <- mice(missdata, max = 0, print = FALSE)
  pred <- S3$pred
  pred["age",   c("sex.bmi","sex.isced","sex.waist","bmi.isced",
                  "bmi.waist","isced.waist","bmi.bmi","waist.waist")] <- 1
  pred["bmi",   c("age.sex","age.isced","age.waist","sex.isced",
                  "sex.waist","isced.waist","age.age","waist.waist")] <- 1
  pred["isced", c("age.sex","age.bmi","age.waist","sex.bmi","sex.waist",
                  "bmi.waist","age.age","bmi.bmi","waist.waist")] <- 1
  
  ## MICE PMM
  meth_pmm <- c("pmm","","pmm","pmm","",
                "~I(age*sex)","~I(age*bmi)","~I(age*isced)",
                "~I(age*log.waist)","~I(sex*bmi)","~I(sex*isced)",
                "~I(sex*log.waist)","~I(bmi*isced)","~I(bmi*log.waist)",
                "~I(isced*log.waist)","~I(age*age)","~I(bmi*bmi)",
                "~I(log.waist*log.waist)")
  mice.pmm <- mice(missdata, meth = meth_pmm, pred = pred, m = 10, 
                   visitSequence = 'monotone',
                   printFlag = FALSE, maxit = 10)
  Fisher.p <- gaussCItestMI(5,3,1, mice.pmm)
  out$micepmm <- cbind(NULL, 
                       Fisher.p=c(Fisher.p,rep("",9)))
  out
}



# Perform the simulation
N <- 450
results_CIT_S3 <- mclapply(1:N, doanalysis_CIT_S3)
save(results_CIT_S3, 
     file = "C:/Users/Public/Documents/Bai (BIPS)/Masterarbeit/results_CIT_S3_450.RData")

 
N <- 550
results_CIT_S3 <- mclapply(1:N, doanalysis_CIT_S3)
save(results_CIT_S3, 
     file = "C:/Users/Public/Documents/Bai (BIPS)/Masterarbeit/results_CIT_S3_550.RData")




#---------------------------------------------------------------------------------------------#
#                                        Format Results                                       #
#                                 Conditional Independence Test                               #
#---------------------------------------------------------------------------------------------#


getParameter_CIT <- function(method){
  ## draw the coefficient estimates
  Fisher.p <- sapply(results, function(x){
    as.numeric(x[[method]][ , 'Fisher.p'])
  })
  Fisher.p <- Fisher.p[1,]
  cover <- ifelse(Fisher.p <= 0.05,1,0)
  cover_ratio <- mean(cover)
  cover_ratio
}


Table_CIT <- function(x){
  results_CIT <- lapply(methods, 
                        function(x){getParameter_CIT(x)})
  ## convert list to data.frame
  results_CIT <- do.call(rbind.data.frame, results_CIT)
  ## format the names
  results_CIT <- cbind(Modell=Model_names,
                       results_CIT)
  colnames(results_CIT) <- c('Models','Ratio')
  rownames(results_CIT) <- NULL
  ## format the decimal
  library(formattable)
  results_CIT$Ratio <- percent(results_CIT$Ratio,digits = 2)
  return(results_CIT)
}




methods <- c('full','rf10', 'micepmm')
Model_names <- c("Full Date","RF MICE with 10 trees",
                 "Parametric MICE PMM")

results <- results_lm_S3
lm <- Table_CIT(results_lm_S3)

results <- results_CIT_S3
CIT <- Table_CIT(results_CIT_S3)

resultsTable_CIT_S3 <- cbind(lm,CIT)[,-3]
colnames(resultsTable_CIT_S3) <- c('Models','Power','Type 1 error')

