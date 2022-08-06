#-----------------------------------------------#
# title:   Biopsy
# Author:  Zehui Bai
# Date:    15.04.2021
# Version: V0.1 
#-----------------------------------------------#


## Load Packages
library("ggplot2")
library("ggcorrplot")
library("car")
library("reshape2")
library("papeR")
library("Hmisc")
library("GGally")
library("bestglm")
library("leaps") 
library("class")
library("kknn")
library("e1071")
library("caret")
library("glmnet")
library("psych")
library("dplyr")
library("earth")
library("MASS")
library("knitr")
library("kableExtra")
library("randomForest") 
library("InformationValue")

# Delete Later
DataScientist_test_data <- read.csv("C:/Users/zbai/Downloads/DataScientist_test_data.csv")
biopsy <- DataScientist_test_data[-c(1,33)]
biopsy$diagnosis <- factor(biopsy$diagnosis, 
                           levels = c("B", "M"), 
                           labels = c("Benign", "Malignant"))
## Feature scaling (z-score)
biopsy_ZS <- biopsy
biopsy_ZS[-1] <- as.data.frame(scale(biopsy[-1]))

set.seed(123)                       
ind <- sample(2, nrow(biopsy_ZS), replace = TRUE, prob = c(0.7, 0.3))
## the training data set with 70% data
biopsy.zs.train <- biopsy_ZS[ind == 1, ] 
## the test data set with 30% data
biopsy.zs.test <- biopsy_ZS[ind == 2, ] 


trainY <- biopsy_ZS$diagnosis[ind==1]
testY <-  biopsy_ZS$diagnosis[ind==2]

## Recode the diagnosis as numeric Benign 0 or Malignant 1
y_train <- ifelse(biopsy.zs.train$diagnosis == "Malignant",1,0)
y_test <- ifelse(biopsy.zs.test$diagnosis == "Malignant",1,0)

#-----------------------------------------------#
# 1) Provide a descriptive overview of the data.
#-----------------------------------------------#

## import dataset
# DataScientist_test_data <- read.csv("~/Library/Mobile Documents/com~apple~CloudDocs/02. Programm/01 R/00 Data/DataScientist_test_data.csv")
DataScientist_test_data <- read.csv("C:/Users/zbai/Downloads/DataScientist_test_data.csv")

## Explore data structure
names(DataScientist_test_data)
dim(DataScientist_test_data)
str(DataScientist_test_data)

## Drop the patient ID and blank column
biopsy <- DataScientist_test_data[-c(1,33)]
str(biopsy)
## "B" denotes the benign tumor and "M" denotes the malignant tumor

## Explore data: Check the missing ratio of biomaker
sapply(biopsy,function(x)sum(is.na(x)))


## Explore data: As factor and check the percent 
biopsy$diagnosis <- factor(biopsy$diagnosis, 
                           levels = c("B", "M"), 
                           labels = c("Benign", "Malignant"))
table(biopsy$diagnosis)
## Visualization
theme_set(theme_bw())
ggplot(data = biopsy) + 
  geom_bar(mapping = aes(x = diagnosis, y = ..prop..,  group=1),width=.5)+
  labs(title="Breast Cancer Classification Visualization", 
       subtitle="Relative Proportions")

                      



## Explore data: Summary tables for numerical variables
## HTML Output
papeR::summarize(biopsy, type = "numeric", group = "diagnosis")
## PDF Output
xtable(papeR::summarize(biopsy, type = "numeric", group = "diagnosis",
                        test = c( "t.test")))


## Visualization using Boxplot
biopsy.m <- melt(biopsy, id.var = "diagnosis")
ggplot(data = biopsy.m, aes(x = diagnosis, y = value)) + 
  geom_boxplot() + facet_wrap(~ variable, ncol = 5)

## Visualization using Histogram
par(mar=c(1,1,1,1))
hist.data.frame(biopsy[,c(2:16)], n.unique=1, mtitl = "Biomarkers Visualization using Histogram 1")
hist.data.frame(biopsy[,c(17:31)], n.unique=1, mtitl = "Biomarkers Visualization using Histogram 2")


## Feature scaling (z-score)
biopsy_ZS <- biopsy
biopsy_ZS[-1] <- as.data.frame(scale(biopsy[-1]))


## Visualization of the new results using Boxplot
biopsy_ZS.m <- melt(biopsy_ZS, id.var = "diagnosis")
ggplot(data = biopsy_ZS.m, aes(x = diagnosis, y = value)) + 
  geom_boxplot() + facet_wrap(~ variable, ncol = 5) + 
  labs(title="Breast Cancer Biomarkers Visualization", 
       subtitle="Using Boxplot after z-score transformation") +
  theme(legend.position="top")

## Visualization of the new results using Histogram
ggplot(data = biopsy_ZS.m, aes(x = value)) + 
  geom_histogram(aes(color = diagnosis, fill = diagnosis),
                 binwidth = 0.3,
                 alpha=0.5,
                 position = "identity") + 
  facet_wrap(~ variable, ncol = 5) +
  labs(title="Breast Cancer Biomarkers Visualization", 
       subtitle="Using Histogram after z-score transformation") +
  theme(legend.position="top")



## Other method for Feature scaling (normalizing)
## The results are not shown
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
biopsy_NM <- biopsy
biopsy_NM[-1]<- as.data.frame(lapply(biopsy[-1], normalize))








#-----------------------------------------------#
# 2) Analyze the correlation structure of 
#    the biomarkers.
#-----------------------------------------------#

## Compute correlation matrix
## round(cor(biopsy[-1]), 2)

## Correlation greater than 0.9
CorrMatrixtable <- function(cormat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut]
  )
}
## cormat : matrix of the correlation coefficients
Corr_Results <- CorrMatrixtable(round(cor(biopsy_ZS[-1]), 3))
Corr_Results[Corr_Results$cor>0.9,]

## Visualization: draw a correlogram
ggcorrplot(round(cor(biopsy_ZS[-1]), 2), hc.order = TRUE, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 1, 
           method="circle", 
           colors = c("yellow", "white", "blue"), 
           title="Correlogram of biomarkers", 
           ggtheme=theme_bw)

## Alternative shows the corrplots in rmd docu.
ggcorr(biopsy_ZS[-1], nbreaks=8, palette='PuOr', label=TRUE, label_size=4, size = 2) +
  ggtitle("Correlation Matrix of biomarkers") + 
  theme(plot.title = element_text(hjust = 0.5))
 

#-----------------------------------------------#
# 3) Identify potential biomarker candidates 
#    related to the cancer diagnosis 
#    (benign vs. malignant).
#-----------------------------------------------#

#-----------------------------------------------#
# Prepare train and test datasets 
#-----------------------------------------------#

set.seed(123)                       
ind <- sample(2, nrow(biopsy_ZS), replace = TRUE, prob = c(0.7, 0.3))
## the training data set with 70% data
biopsy.zs.train <- biopsy_ZS[ind == 1, ] 
## the test data set with 30% data
biopsy.zs.test <- biopsy_ZS[ind == 2, ] 


trainY <- biopsy_ZS$diagnosis[ind==1]
testY <-  biopsy_ZS$diagnosis[ind==2]


#-----------------------------------------------#
# Scenario 1: Logistic regression (Full Model)
#-----------------------------------------------#

LR.full.fit <- glm(diagnosis ~ ., family = binomial, data = biopsy.zs.train)

## view the coefficients of each predictor and its p-value
summary(LR.full.fit)

## 95% confidence interval
confint(LR.full.fit)
 
## Calculate VIF statistics
vif(LR.full.fit)




#-----------------------------------------------#
# Scenario 2: Logistic regression (Correlation)
#-----------------------------------------------#

## Fisrt check the correlation of biomarkers after removing
new_cor <- CorrMatrixtable(round(cor(biopsy_ZS[-c(1,2,4,5,9,12,15,17,23,24,25)]), 3))
new_cor[new_cor$cor>0.9,]

## Build model
LR.cor.fit <- glm(diagnosis ~ ., family = binomial, data = biopsy.zs.train[-c(2,4,5,9,12,15,17,23,24,25)])

## view the coefficients of each predictor and its p-value
summary(LR.cor.fit)

## 95% confidence interval
confint(LR.cor.fit)

## Calculate VIF statistics
vif(LR.cor.fit)

## Performance on the test dataset
LR.cor.probs <- predict(LR.cor.fit, newdata = biopsy.zs.test, type = "response")

## Calculate the confusion matrix 
InformationValue::confusionMatrix(testY, LR.cor.probs)


#-----------------------------------------------#
# Scenario 3: Logistic regression (Backward Subset)
#-----------------------------------------------#


## Recode the diagnosis as numeric Benign 0 or Malignant 1
y_train <- ifelse(biopsy.zs.train$diagnosis == "Malignant",1,0)
y_test <- ifelse(biopsy.zs.test$diagnosis == "Malignant",1,0)


## not done, only when features <= 15 can be used.
## p = 30. must be <= 15 for GLM.

## X <- biopsy.zs.train[, 2:31]
## Xy <- data.frame(cbind(X, y_train))
## bestglm(Xy = Xy, IC = "CV", 
##         CVArgs = list(Method = "HTF", K = 10, REP = 1), 
##         method = "forward", family=binomial)

 

## Selection from the full model of Scenario 1 
backward.full <- stepAIC(LR.full.fit, direction = "backward", trace = FALSE)
backward.full$formula

LR.Bestfull.fit <- glm(backward.full$formula, family = binomial, 
                       data = biopsy.zs.train)
summary(LR.Bestfull.fit)


## Selection from the model of Scenario 2 
backward.cor <- stepAIC(LR.cor.fit, direction = "backward", trace = FALSE)
backward.cor$formula

LR.Bestcor.fit <- glm(backward.cor$formula, family = binomial, 
                       data = biopsy.zs.train)
summary(LR.Bestcor.fit)

## Plot the main effect 
beta.table <- data.frame(summary(LR.Bestcor.fit)$coef)
beta.table$variable <- row.names(beta.table)
beta.table <- mutate(beta.table, estimate = Estimate, 
                     se = Std..Error, 
                     low = Estimate - 2*se, 
                     high = Estimate + 2*se,
                     p = Pr...z..)  

ggplot(beta.table, aes(y=estimate, x=variable, ymin=low, ymax=high, color = (p < 0.05))) + 
  geom_pointrange() +  
  geom_hline(yintercept = 0, col="darkgrey", lty = 3, lwd=2) + 
  coord_flip() + ggtitle("Best backward subset using AIC main effect plot")

## Performance on the test dataset
LR.Bestcor.probs <- predict(LR.Bestcor.fit, newdata = biopsy.zs.test, type = "response")

## Calculate the confusion matrix 
InformationValue::confusionMatrix(testY, LR.Bestcor.probs)





 


#-----------------------------------------------#
# Scenario 4: Lasso Regression
#-----------------------------------------------#


## Lasso Regression
## 3-fold cross-validation
set.seed(317)
lasso.cv = cv.glmnet(x=as.matrix(biopsy.zs.train[-1]), y=y_train, 
                     family = "binomial",  nfolds = 3)

## The two vertical dashed lines in the figure represent the log(lambda) of 
## the minimum MSE (the dashed line on the left) and the log(lambda) of one standard error of the minimum distance.
plot(lasso.cv,main="MSE vs. the log(lambda)")

## minimum
lasso.cv$lambda.min  

## show the fitted model
lasso.fit <- glmnet(x=as.matrix(biopsy.zs.train[-1]), y=y_train, 
                    family = "binomial", 
                    alpha = 1, 
                    lambda =lasso.cv$lambda.min) 
coef(lasso.fit)

## Predict on the test dataset
lasso.probs <- predict(lasso.cv, newx=as.matrix(biopsy.zs.test[-1]), 
                       type = "response", 
                       s = "lambda.min")

## Calculate the confusion matrix 
InformationValue::confusionMatrix(testY, lasso.probs)


#-----------------------------------------------#
# Scenario 5: Elastic net regularization
#-----------------------------------------------#

## Elastic net regularization
grid <- expand.grid(.alpha = seq(0,1, by=.2), 
                    .lambda = seq(0.00, 0.2, by = 0.02))

## Leave-One-Out Cross-Validation 
## FInd the best alpha and lambda with smallest MAE       
control <- trainControl(method = "LOOCV") 
set.seed(701)                            
enet.train = train(diagnosis ~ ., data = biopsy.zs.train, 
                   method = "glmnet", 
                   family = "binomial", 
                   trControl = control, 
                   tuneGrid = grid)
enet.train


## Modeling with resulted alpha and lambda
enet.fit <- glmnet(x=as.matrix(biopsy.zs.train[-1]), y=y_train, 
                   family = "binomial",  
                   alpha = 0.2, lambda = 0.02)
enet.coef <- coef(enet.fit, s = 0.02, exact = TRUE)
enet.coef


## Test in the test datasets
enet.probs <- predict(enet.fit, 
                      newx = as.matrix(biopsy.zs.test[-1]), 
                      type = "response",  s= 0.02)

## Calculate the confusion matrix 
InformationValue::confusionMatrix(testY, enet.probs)




#-----------------------------------------------#
# Scenario 6: MARS
#-----------------------------------------------#

## Use 5-fold cross-validation to select the model
set.seed(132)
MARS.fit <-  earth(diagnosis ~ ., data = biopsy.zs.train,
                   pmethod = "cv",
                   nfold = 5,
                   ncross = 3,
                   degree = 1,
                   minspan = -1,
                   glm=list(family=binomial))
summary(MARS.fit)


## The following variables are used to build the MARS model
name <- evimp(MARS.fit)
rownames(name)

## Prediction on the test dataset
MARS.probs <- predict(MARS.fit, newdata =biopsy.zs.test, type = "response")

## Calculate the confusion matrix 
InformationValue::confusionMatrix(testY, MARS.probs)









#-----------------------------------------------#
# LDA
#-----------------------------------------------#

## Linear discriminant analysis
lda.fit <- lda(diagnosis ~ ., data = biopsy.zs.train)
lda.fit

## There is some overlap between the groups, 
## which indicates that some observations are misclassified.
par(mar=c(1,1,1,1))
plot(lda.fit, type = "both")

 
## Performance on the test set
lda.probs <- predict(lda.fit, newdata = biopsy.zs.test)$posterior[, 2]

## Calculate the confusion matrix 
InformationValue::confusionMatrix(testY, lda.probs)



## Quadratic discriminant analysis
qda.fit <- qda(diagnosis ~ ., data = biopsy.zs.train)
test.qda.probs <- predict(qda.fit, newdata = biopsy.zs.test)$posterior[, 2]

InformationValue::confusionMatrix(testY, test.qda.probs)



#-----------------------------------------------#
# PCA and Logistic regression
#-----------------------------------------------#

## Extract the principal components 
## Rotation can reduce (or eliminate) the correlation between the principal components 
## and help explain the principal components.
pca <- principal(biopsy.zs.train[-1], nfactors = 8, rotate = "varimax")

## Find the point with small reduction rate. 
## The point means that when a new principal component is added to this point, 
## the explanation of variance does not increase too much.
plot(pca$values, type="b",main="Scree plot", ylab="Eigenvalues", xlab="Component")

## Calcualte scores  
pca.scores <- data.frame(pca$scores)
pca.scores$diagnosis <- biopsy.zs.train$diagnosis

## PCA Modeling using scores 
LR.PCA.fit <- glm(diagnosis ~ ., family = binomial, data = pca.scores)

## Model Results
summary(LR.PCA.fit)

## Performance on the test dataset
test.scores <- data.frame(predict(pca, biopsy.zs.test[-1]))
LR.PCA.probs <- predict(LR.PCA.fit, test.scores,type = "response")

## Calculate the confusion matrix 
InformationValue::confusionMatrix(testY, LR.PCA.probs)

 

 


#-----------------------------------------------#
# Support Vector Machine (SVM)
#-----------------------------------------------#

## Find the optimal cost function with the smallest error rate of misclassification
set.seed(123)
svm.fit <- tune.svm(diagnosis ~ ., data = biopsy.zs.train, 
                    kernel = "linear", 
                    cost = c(0.001, 0.01, 0.1, 1, 5, 10))
summary(svm.fit)

## Performance on the test data set 
best.svm.fit <- svm.fit$best.model

## Calculate the confusion matrix 
svm.probs <- predict(best.svm.fit, newdata = biopsy.zs.test)

## Confusion matrix
table(svm.probs, testY)
 





#-----------------------------------------------#
# K-Nearest Neighbors (KNN)
#-----------------------------------------------#


## Use cross-validation to select parameter k
knn.grid <- expand.grid(.k = seq(2, 20, by = 1))
control = trainControl(method = "cv")
 
set.seed(123)
knn.train <- train(diagnosis ~ ., data = biopsy.zs.train, 
                   method = "knn", 
                   trControl = control, 
                   tuneGrid = knn.grid)
## Optimal k value
knn.train
## The Y-axis represents the percentage of observations that are misclassified by the kernel function
## k=3 reaches its peak
plot(knn.train)

## Apply to the test data set
knn.probs <- knn(biopsy.zs.train[, -1], biopsy.zs.test[, -1], 
                 biopsy.zs.train[, 1], k = 3,prob=TRUE)

## Confusion matrix
table(knn.probs, testY) 

 
#-----------------------------------------------#
# Random Forest
#-----------------------------------------------#

## Build model
rf.fit <- randomForest(diagnosis ~ ., data = biopsy.zs.train)

## Confusion matrix in train dataset
rf.fit

## Variable Importance Plot
varImpPlot(rf.fit, main = "Variable importance using Random Forest")

## Show 9 variables important for classification
import <- rf.fit$importance
import[import>7,]

## Performance on the test dataset
rf.probs <- predict(rf.fit, newdata = biopsy.zs.test, type = "response")

## Confusion matrix in test dataset
table(rf.probs, testY)






#-----------------------------------------------#
# 4) Evaluate the performance of the model with 
#    the selected biomarkers.
#
# 5) Find a cutoff for the mean area separating 
#    the patients into benign and malignant breast 
#    cancer. In case you are not familiar with 
#    cutoff detection, please try to collect 
#    ideas how this could be done.
#-----------------------------------------------#

## Logistic regression (removing highly correlated items)
## Logistic regression (backward selection from the model removing highly correlated items)
## Lasso regression 
## Elastic net regularization
## Multiple adaptive regression spline
## Linear discriminant analysis
## Logistic regression based on principal component analysis
## Support Vector Machine
## K-Nearest Neighbors
## Random Forest

Evaluation1 <- function(description,probs){
  
  ## Calculate the percentage misclassification error 
  ## for the given actuals and probaility scores
  Misclassification <- misClassError(y_test, probs)
  Accuracy <- 1-Misclassification
  
  ## Calculate the area uder ROC curve statistic for a given logit model. 
  AUC <- round(AUROC(y_test, probs),4)
  
  ## ## Compute the optimal probability cutoff score
  OptimalCutoff <- round(optimalCutoff(y_test, probs),3)
  
  return(data.frame(Model=description,
                    Misclassification=Misclassification,
                    Accuracy=Accuracy,
                    AUC=AUC,
                    OptimalCutoff=OptimalCutoff))
}

 


Evaluation2 <- function(description,probs){
  
  ## confusion matrix 
  ConMatrx <- table(probs, testY)
  
  ## Calculate the Accuracy
  Accuracy <- round(sum(diag(ConMatrx))/sum(ConMatrx),4)
  Misclassification <- 1-Accuracy
  
  return(data.frame(Model=description,
                    Misclassification=Misclassification,
                    Accuracy=Accuracy,
                    AUC="-",
                    OptimalCutoff="-"))
}


Modelname1 <- list("LR.Cor","LR.Bestcor","Lasso","Elastic net","MARS","LDA","LR.PCA")
Modelname2 <- list("SVM","KNN","RF")
Testprobs1 <- list(LR.cor.probs, LR.Bestcor.probs, lasso.probs,
                   enet.probs, MARS.probs, lda.probs, LR.PCA.probs)
Testprobs2 <- list(svm.probs, knn.probs, rf.probs)

results <- cbind(as.data.frame(mapply(Evaluation1, Modelname1, Testprobs1)),
                 as.data.frame(mapply(Evaluation2, Modelname2, Testprobs2)))
results <- as.data.frame(t(results))
rownames(results) <- NULL


## ROC Curve of Lasso regression
plotROC(y_test, lasso.probs)

## ROC Curve of Elastic net regularization
plotROC(y_test, enet.probs)

#-----------------------------------------------#
# End
#-----------------------------------------------#