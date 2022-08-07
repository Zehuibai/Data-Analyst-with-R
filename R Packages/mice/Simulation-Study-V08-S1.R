#---------------------------------------------------------------------------------------------#
# Project:              R code for simulation study (Master Thesis)
# Title:                Random Forests for Multiple Imputation of Missing Data in IDEFICS study
# Autor:                Zehui Bai
# Field:                Medical Biometry / Biostatistics
# Version:              Version 08
# Date:                 21/OCT/2020
# Details:              Simulation using linear regression S1
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
data$isced <- as.factor(data$isced)
data$sex <- as.factor(data$sex)
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
#                                   lm Analysis: Setting 1                                    #
#         Study on the impact of interaction and non-linearity on the performance of          #
#                                    MICE PMM and MICE RF                                     #
#---------------------------------------------------------------------------------------------#

doanalysis_lm_S1 <- function(x){
  
  ## generate datasets and create missing values
  data <- datasample(x,n=2000)
  missdata <- makeMarlm(data,missratio=0.2)
  
  ## create output listing
  out <- list()
  out$full <- lmfull(data)
  
  data$sex <- as.numeric(data$sex)
  data$isced <- as.numeric(data$isced)
  
  ## conditional independence test (power) alpha <- 0.05
  Fisher.p <- gaussCItest(5,3,1,list(C = cor(data), 
                                     n = nrow(data)))
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
  
  
  ## MICE RF 100
  setRFoptions(ntree_cat=100)
  options()$CALIBERrfimpute_ntree_cat
  micerf100 <- domice(missdata, c('rfcont100', '', 'rfcat', ''))
  out$rf100 <- lmimpute(micerf100)
  
  ## convert longdata to transform data type as numeric
  long_rf100 <- complete(micerf100, action='long', include=TRUE)
  long_rf100$sex <- as.numeric(long_rf100$sex)
  long_rf100$isced <- as.numeric(long_rf100$isced)
  # Convert back to Mids and calculate p-values
  short_rf100 <- as.mids(long_rf100)
  # Power: x=log.waist y=bmi z=age
  Fisher.p <- gaussCItestMI(5,3,1, short_rf100)
  out$rf100 <- cbind(out$rf100, Fisher.p=c(Fisher.p,rep("",9)))
  
  
  ## MICE PMM
  micepmm <- domice(missdata, c('pmm', '', 'pmm', ''))
  out$micepmm <- lmimpute(micepmm)
  
  ## convert longdata to transform data type as numeric
  long_pmm <- complete(micepmm, action='long', include=TRUE)
  long_pmm$sex <- as.numeric(long_pmm$sex)
  long_pmm$isced <- as.numeric(long_pmm$isced)
  # Convert back to Mids and calculate p-values
  short_pmm <- as.mids(long_pmm)
  # Power: x=log.waist y=bmi z=age
  Fisher.p <- gaussCItestMI(5,3,1, short_pmm)
  out$micepmm <- cbind(out$micepmm, Fisher.p=c(Fisher.p,rep("",9)))
  
  out
}



## carry out simulation studys
N <- 1000
results_lm_S1 <- mclapply(1:N, doanalysis_lm_S1)
save(results_lm_S1, 
     file = "C:/Users/Public/Documents/Bai (BIPS)/Masterarbeit/results_lm_S1.RData")  




### Model Check
### check the convergence
# 【B】Inspect the convergence of the algorithm 检查算法的收敛性

## The mice() function implements an iterative Markov Chain Monte Carlo type of algorithm. 
## the trace lines generated by the algorithm to study convergence:
## In general, we would like the streams to intermingle and be free of any trends at the later iterations. 通常，我们希望这些流混合在一起，并且在以后的迭代中没有任何趋势。

##  MICE RF 10
plot(mice.rf,
     main="convergence of the algorithm using MICE RF with 10 trees")

##  MICE RF 100
plot(micerf100,
     main="convergence of the algorithm using MICE RF with 100 trees")

##  MICE PMM
plot(micepmm,
     main="convergence of the algorithm using parametric MICE PMM")

##  MICE PMM with interactions
plot(mice.pmm,
     main="convergence of the algorithm using parametric MICE PMM 1")






xyplot(micerf100, log.waist ~ age + sex + bmi + isced)


#-----------------------------------#
#              stripplot            #
#-----------------------------------#

## Further diagnostic checking.stripplot()---MAR MCAR
## In order to form an idea about plausibility, one may check the imputations and compare them against the observed values.  合理性的想法，可以检查估算并将其与观察值进行比较
## If we are willing to assume that the data are missing completely at random (MCAR), then the imputations should have the same distribution as the observed data.
## In general, distributions may be different because the missing data are MAR (or even MNAR). 
## plot observed data in blue and the imputed data in red. 

## all numerical variables
stripplot(mice.rf, maxit=2, 
          main="Stripplot of continuous variables using MICE RF with 10 trees")
stripplot(micerf100, maxit=2, 
          main="Stripplot of continuous variables using MICE RF with 100 trees")
stripplot(micepmm, maxit=2, 
          main="Stripplot of continuous variables using parametric MICE PMM")




stripplot(micerf, isced,
          main="Stripplot of categorical variable using MICE RF with 10 trees")
stripplot(micerf100, isced,
          main="Stripplot of categorical variable using MICE RF with 100 trees")
stripplot(micepmm, isced,
          main="Stripplot of categorical variable using parametric MICE PMM")



#-----------------------------------#
#             Densityplot           #
#-----------------------------------#

## densityplot
densityplot(mice.rf, main="Densityplot of continuous variables using MICE RF with 10 trees")
densityplot(micerf100, main="Densityplot of continuous variables using MICE RF with 100 trees")
densityplot(micepmm, main="Densityplot of continuous variables using parametric MICE PMM")

## Full data
par(mfrow = c(1, 2))
plot(density(data$age), 
     main="Densityplot of Age using Full data",
     xlab = "Age")
plot(density(data$bmi),
     main="Densityplot of BMI using Full data",
     xlab = "BMI")
dev.off()


#-----------------------------------#
#             Densityplot           #
#-----------------------------------#

par(mfrow = c(3, 2))

data.complete <- data_complete
data.complete$isced <- as.numeric(data.complete$isced)
p1 <- ggplot(data.complete, aes(x=isced))+
  geom_bar(aes(y = ..prop..))+
  geom_text(aes( label = scales::percent(..prop..),
                 y= ..prop.. ), stat= "count", vjust = -.5) +
  scale_y_continuous(labels = scales::percent) +
  labs(title="ISCED categories using complete dataset")+
  theme_classic()
p1




p2 <- ggplot(data, aes(x=isced),main-"sss")+
  geom_bar(color="darkblue", fill="lightblue",aes(y = ..prop..))+
  geom_text(aes( label = scales::percent(..prop..),
                 y= ..prop.. ), stat= "count", vjust = -.5) +
  scale_y_continuous(labels = scales::percent) +
  labs(title="ISCED categories using Full data n=2000")+
  theme_classic()
  

rf10_comp <- complete(mice.rf,1)
rf10_comp$isced <- as.numeric(rf10_comp$isced )
p3 <- ggplot(rf10_comp,aes(x=isced))+
  geom_bar(color="darkblue", fill="lightblue", aes(y = ..prop..))+
  geom_text(aes( label = scales::percent(..prop..),
                 y= ..prop.. ), stat= "count", vjust = -.5) +
  scale_y_continuous(labels = scales::percent) +
  labs(title="ISCED categories using MICE RF with 10 trees")+
  theme_classic()

rf100_comp <- complete(micerf100,1)
rf100_comp$isced <- as.numeric(rf100_comp$isced )
p4 <- ggplot(rf100_comp,aes(x=isced))+
  geom_bar(color="darkblue", fill="lightblue",aes(y = ..prop..))+
  geom_text(aes( label = scales::percent(..prop..),
                 y= ..prop.. ), stat= "count", vjust = -.5) +
  scale_y_continuous(labels = scales::percent) +
  labs(title="ISCED categories using MICE RF with 100 trees")+
  theme_classic()

pmm_comp <- complete(micepmm,2)
pmm_comp$isced <- as.numeric(pmm_comp$isced )
p5 <- ggplot(pmm_comp,aes(x=isced))+
  geom_bar(color="darkblue", fill="lightblue", aes(y = ..prop..))+
  geom_text(aes( label = scales::percent(..prop..),
                 y= ..prop.. ), stat= "count", vjust = -.5) +
  scale_y_continuous(labels = scales::percent) +
  labs(title="ISCED categories using parametric MICE PMM")+
  theme_classic()


## gridExtra：Laying out multiple plots on a page
library(gridExtra)
grid.arrange(p1,p2,p3,p4,p5, nrow = 2)
grid.arrange(p2,p3,p4,p5, nrow = 2)

 


#-----------------------------------#
#             Residuals             #
#-----------------------------------#

## Analysis model
formular <- log.waist ~  age + bmi + sex + isced + sex:age + age:bmi





##  Full data
data$sex <- as.factor(data$sex)
data$isced <- as.factor(data$isced)
modf <- fortify(lm(formular, data = data))
rp1 <- ggplot(modf, aes(x = modf$bmi, y = .resid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Residuals plot for BMI using Full data",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
rp1


##  MICE RF 10
rf10_comp <- complete(mice.rf,1)
modf2 <- fortify(lm(formular, data = rf10_comp))
rp2 <- ggplot(modf2, aes(x = modf$bmi, y = .resid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Residuals plot for BMI using MICE RF with 10 trees",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
rp2



##  MICE RF 100
rf100_comp <- complete(micerf100,1)
modf3 <- fortify(lm(formular, data = rf100_comp))
rp3 <- ggplot(modf3, aes(x = modf$bmi, y = .resid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Residuals plot for BMI using MICE RF with 100 trees",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
rp3

##  MICE PMM
pmm_comp <- complete(micepmm,1)
modf4 <- fortify(lm(formular, data = pmm_comp))
rp4 <- ggplot(modf4, aes(x = modf$bmi, y = .resid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Residuals plot for BMI using parametricMICE PMM",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
rp4

grid.arrange(rp1, rp2, rp3, rp4, nrow = 2)


#-----------------------------------#
#   Standardised Residuals          #
#-----------------------------------#


##  Full data
data$sex <- as.factor(data$sex)
data$isced <- as.factor(data$isced)
modf <- fortify(lm(formular, data = data))
srp1 <- ggplot(modf, aes(x = modf$bmi, y = .stdresid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Standardised residuals plot for BMI using Full data",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
srp1


##  MICE RF 10
rf10_comp <- complete(mice.rf,1)
modf2 <- fortify(lm(formular, data = rf10_comp))
srp2 <- ggplot(modf2, aes(x = modf$bmi, y = .stdresid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Standardised residuals plot for BMI using MICE RF with 10 trees",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
srp2



##  MICE RF 100
rf100_comp <- complete(micerf100,1)
modf3 <- fortify(lm(formular, data = rf100_comp))
srp3 <- ggplot(modf3, aes(x = modf$bmi, y = .stdresid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Standardised residuals plot for BMI using MICE RF with 100 trees",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
srp3

##  MICE PMM
pmm_comp <- complete(micepmm,1)
modf4 <- fortify(lm(formular, data = pmm_comp))
srp4 <- ggplot(modf4, aes(x = modf$bmi, y = .stdresid)) + geom_point()+
  geom_hline(aes(yintercept=0), colour="#990000") +
  labs(title="Standardised residuals plot for BMI using parametricMICE PMM",
       x = "BMI",
       y = "Residuals")+
  theme_classic()
srp4

grid.arrange(srp1, srp2, srp3, srp4, nrow = 2)


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
  bias <- apply(estimates,1,mean) - coef
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








 

 
## results of linear regression performance
data_complete$sex <- as.factor(data_complete$sex)
best.fit <- lm(log.waist ~  age + bmi + sex + isced + sex:age + 
                 age:bmi, data = data_complete)
coef <- summary(best.fit)$coefficients[ ,1]
methods <- c('full', 'rf10', 'rf100', 'micepmm')
Model_names <- rep(c("Full data","RF MICE with 10 trees",
                     "RF MICE with 100 trees","Parametric MICE PMM"),
                   times=10)

results <- results_lm_S1
resultsTable_lm_S1 <- Table_lm(results_lm_S1,4)


S1_contimuous <- resultsTable_lm_S1[c(5:12),]
rownames(S1_contimuous) <- NULL
knitr::kable(S1_contimuous,
             format  = "pandoc", 
             row.names = NA,
             caption = "The impact of tree number for continuous variables in the new analysis model")

S1_categorical <- resultsTable_lm_S1[c(17:32),]
rownames(S1_categorical) <- NULL
knitr::kable(S1_categorical,
             format  = "pandoc", 
             row.names = NA,
             caption = "The impact of tree number for categorical variable in the new analysis model")

















#---------------------------------------------------------------------------------------------#
#                                   CIT Analysis: Setting 3                                   #
#         Study on the impact of interaction and non-linearity on the performance of          #
#                                    MICE PMM and MICE RF                                     #
#---------------------------------------------------------------------------------------------#

doanalysis_CIT_S1 <- function(x){
  
  data <- dataCITerror(x,n=2000)
  missdata <- makeMarlm(data,missratio=0.2)
  
  ## create output listing
  out <- list()
  out$full <- lmfull(data)
  
  data$sex <- as.numeric(data$sex)
  data$isced <- as.numeric(data$isced)
  ## conditional independence test (power) alpha <- 0.05
  Fisher.p <- gaussCItest(5,3,1,list(C = cor(data), 
                                     n = nrow(data)))
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
  
  ## MICE RF 100
  setRFoptions(ntree_cat=100)
  options()$CALIBERrfimpute_ntree_cat
  micerf100 <- mice(missdata, 
                    meth = c("rfcont100","rfcat","rfcont100",
                             "rfcat","rfcont100"), m = 10, 
                    visitSequence = 'monotone',
                    printFlag = FALSE, maxit = 9)
  out$rf100 <- lmimpute(micerf100)
  
  ## convert longdata to transform data type as numeric
  long_rf100 <- complete(micerf100, action='long', include=TRUE)
  long_rf100$sex <- as.numeric(long_rf100$sex)
  long_rf100$isced <- as.numeric(long_rf100$isced)
  # Convert back to Mids and calculate p-values
  short_rf100 <- as.mids(long_rf100)
  # Power: x=log.waist y=bmi z=age
  Fisher.p <- gaussCItestMI(5,3,1, short_rf100)
  out$rf100 <- cbind(out$rf100, Fisher.p=c(Fisher.p,rep("",9)))
  
  ## MICE PMM
  micepmm <- mice(missdata, 
                  meth = c("pmm","pmm","pmm","pmm","pmm"), m = 10, 
                  visitSequence = 'monotone',
                  printFlag = FALSE, maxit = 10)
  out$micepmm <- lmimpute(micepmm)
  
  ## convert longdata to transform data type as numeric
  long_pmm <- complete(micepmm, action='long', include=TRUE)
  long_pmm$sex <- as.numeric(long_pmm$sex)
  long_pmm$isced <- as.numeric(long_pmm$isced)
  # Convert back to Mids and calculate p-values
  short_pmm <- as.mids(long_pmm)
  # Power: x=log.waist y=bmi z=age
  Fisher.p <- gaussCItestMI(5,3,1, short_pmm)
  out$micepmm <- cbind(out$micepmm, Fisher.p=c(Fisher.p,rep("",10)))
  
  out
}



# Perform the simulation
N <- 190
S3 <- mclapply(1:N, doanalysis_CIT_S3)
results_CIT_S3 <- mclapply(1:N, doanalysis_CIT_S3)
 





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




methods <- c('rf10', 'rf100', 'micepmm')
Model_names <- c("RF MICE with 10 trees",
                 "RF MICE with 100 trees",
                 "Parametric MICE PMM")
results <- results_lm_S1
lm <- Table_CIT(results_lm_S1)
results <- results_CIT_S1
CIT <- Table_CIT(results_CIT_S1)
## CIT$Ratio <- 1-CIT$Ratio
resultsTable_CIT_S1 <- cbind(lm,CIT)[,-3]
colnames(resultsTable_CIT_S1) <- c('Models','Power','Type 1 error')

