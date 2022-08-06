#############################################################################################
#                                                                                           #
#                                   General Setup                                           #
#                                                                                           #
#############################################################################################
# Working directory
dir <- "C:/Users/rpaul/Projects/suPAR/"

library(readxl)
library(ggplot2)
library(reshape2)
library(robCompositions)
library(corrplot)
library(psych)
#############################################################################################
#                                                                                           #
#                                   Data reconfiguration                                    #
#                                                                                           #
#############################################################################################
# Read the source file
suPAR.table<- as.data.frame(read_excel(paste0(dir,"Complement_suPAR_20201201.xlsx")))
colnames(suPAR.table) <- c("Sample ID", "suPAR", "Group", "C3a", "C5a", "C5b", "S100A8A9", "remarks")

# Save original
suPAR.table.original <- suPAR.table


suPAR.table <- suPAR.table[1:40,]
# Create clumps variable: 1: Yes, 0: No
suPAR.table$clumps <- ifelse (grepl( "clumps", suPAR.table$remarks, fixed = TRUE),1,0)

# Create hemolysis variable: 3: hemolysis+++, 2: hemolysis++, 1:hemolysis+, 0: no hemolysis
suPAR.table$hemolysis <- ifelse (grepl( "hemolysis +++", suPAR.table$remarks, fixed = TRUE),3,
                                 ifelse (grepl( "hemolysis ++", suPAR.table$remarks, fixed = TRUE),2,
                                    ifelse (grepl( "hemolysis +", suPAR.table$remarks, fixed = TRUE),1,0)))

# Read data for healthy individuals
suPAR.table.healthy <- read_excel("C:/Users/rpaul/Projects/suPAR/Complement_suPAR_20201201.xlsx",
                                        sheet = "Healthy Controls", n_max = 5)
colnames(suPAR.table.healthy) <- c("Sample ID", "C3a", "C5a", "C5b", "S100A8A9")
suPAR.table.healthy$Group <- "Healthy"
#############################################################################################
#                                                                                           #
#                                   1. Impute Obs > UDL                                     #
#                                                                                           #
#############################################################################################
imp.lm <- suPAR.table[,c(2,4:7)]


#### Several Methods will be implemented and compared
# A: Impute by setting to NA (lazy)
imp.lmA <- imp.lm
imp.lmA[imp.lmA == ">Max"] <-NA
imp.lmA[imp.lmA == "<2"] <-NA
imp.lmA[imp.lmA == ">15"] <-NA

# B: Impute by setting to UDL+sddev (quick&dirty)
imp.lm3 <- imp.lm
ssup <- sd(imp.lmA$suPAR, na.rm = T)
s1 <- sd(imp.lmA$C5a, na.rm = T)
s2 <- sd(imp.lmA$C5b, na.rm = T)
# Fill in obs below LDL for suPAR
imp.lm3[imp.lm3$suPAR == "<2",]$suPAR  <- runif(1,0,2)
imp.lm3[imp.lm3$suPAR == ">15",]$suPAR <- 15+abs(rnorm(1,0, sd = ssup))
imp.lm3[imp.lm3$C5a == ">Max",]$C5a <- 1000+abs(rnorm(1,0, sd = s1))
imp.lm3[imp.lm3$C5b == ">Max",]$C5b <- 10000+abs(rnorm(1,0, sd = s2))

# C: Impute using a Tobit regression(fancy)
# Tobit is a method to model censored regression data

# First, replace all ">Max"-Strings by infinity
imp.lm$C5a <- as.numeric(ifelse(grepl( ">Max", suPAR.table$C5a, fixed = TRUE), Inf,imp.lm$C5a))
imp.lm$C5b <- as.numeric(ifelse(grepl( ">Max", imp.lm$C5b, fixed = TRUE), Inf,imp.lm$C5b))
imp.lm$suPAR <- as.numeric(ifelse(grepl( ">15", imp.lm$suPAR, fixed = TRUE), Inf,imp.lm$suPAR))

UDL <- apply(imp.lm,2,max)
names(UDL) <- names(imp.lm)
UDL["suPAR"] <- 15
UDL["C5a"] <- 1000
UDL["C5b"]<- 10000
res.lm <- imputeUDLs(imp.lm, dl=UDL, method="lm", variation=TRUE)
imp.lm2 <- res.lm$x

# Rebuild data frames
suPAR.table.A <- cbind.data.frame(suPAR.table[,c(1,3,9:10)], imp.lmA)
suPAR.table.B <- cbind.data.frame(suPAR.table[,c(1,3,9:10)], imp.lm3)
suPAR.table.C <- cbind.data.frame(suPAR.table[,c(1,3,9:10)], imp.lm2)

### Create an overall data.frame
suPAR.table.complete <- rbind.data.frame(suPAR.table.A, suPAR.table.B, suPAR.table.C)
suPAR.table.complete$imputation <- rep( c("A","B","C"), each  =40)

suPAR.table.healthy <- rbind(suPAR.table.healthy, suPAR.table.healthy, suPAR.table.healthy)
suPAR.table.healthy$imputation <- rep( c("A","B","C"), each  =5)
suPAR.table.healthy$clumps <- NA
suPAR.table.healthy$hemolysis <- NA
suPAR.table.healthy$suPAR <- NA
suPAR.table.complete <- rbind(suPAR.table.complete, suPAR.table.healthy)

#rm(suPAR.table.A, suPAR.table.B, suPAR.table.C)
rm(imp.lm3, imp.lm2, imp.lm, imp.lmA)
rm(s1, s2, ssup, UDL)
#############################################################################################
#                                                                                           #
#                                   2. Summary Graphs                                       #
#                                                                                           #
#############################################################################################

### Transform data.frame from wide to long
temp1 <- suPAR.table.complete[, c(1:4,10)]
temp1$Value <- suPAR.table.complete[, 5]
temp1$Var <- "suPAR"
temp2 <- suPAR.table.complete[, c(1:4,10)]
temp2$Value <- suPAR.table.complete[, 6]
temp2$Var <- "C3a"
temp3 <- suPAR.table.complete[, c(1:4,10)]
temp3$Value <- suPAR.table.complete[, 7]
temp3$Var <- "C5a"
temp4 <- suPAR.table.complete[, c(1:4,10)]
temp4$Value <- suPAR.table.complete[, 8]
temp4$Var <- "C5b-9"
temp5 <- suPAR.table.complete[, c(1:4,10)]
temp5$Value <- suPAR.table.complete[, 9]
temp5$Var <- "S100A8A9"

suPAR.table.long <- rbind.data.frame(temp1, temp2, temp3, temp4, temp5)
suPAR.table.long$Value <- as.numeric(suPAR.table.long$Value)
rm(temp1, temp5, temp4, temp3, temp2)

hist.df <- suPAR.table.long[which(suPAR.table.long$imputation == "No Imputation"),]
hist.df2 <- hist.df
hist.df2$Group <- "Overall"

hist.df3 <- rbind(hist.df, hist.df2)

### Histograms
ggplot(data = hist.df3, aes(x = Value,fill = Group )) +
  geom_histogram(bins = 15, col = "black") +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 3))+
  facet_grid(Group ~ Var, scales = "free") +
  theme_bw()

### Summary Tables
summary.df <- rbind(suPAR.table.original[c(1:40),c(2:7)], suPAR.table.healthy[which(suPAR.table.healthy$imputation == "B"),c(2:6,10)])
summary.df[summary.df == ">Max"]<-NA
summary.df[summary.df == "<2"] <-NA
summary.df[summary.df == ">15"]<-NA
summary.df$suPAR <- as.numeric(summary.df$suPAR)
summary.df$C5a <- as.numeric(summary.df$C5a)
summary.df$C5b <- as.numeric(summary.df$C5b)

summary.complete <- summary(summary.df)

aaa <- summaryDF(summary.df)
write.csv(summary.complete, "C:/Users/rpaul/Projects/suPAR/summary_complete.csv")
summary.0 <- summary(summary.df[which(summary.df$Group == "<6 suPAR"),])

apply(summary.df[,c(1,3:6)],2 , sd, na.rm = T)

summary.1 <- summary(summary.df[which(summary.df$Group == ">6 suPAR"),])


apply(summary.df[which(summary.df$Group == ">6 suPAR"),c(1,3:6)], 2, sd, na.rm = T)
apply(summary.df[which(summary.df$Group == "<6 suPAR"),c(1,3:6)], 2, sd, na.rm = T)
apply(summary.df[which(summary.df$Group == "Healthy"),c(1,3:6)], 2, sd, na.rm = T)

summary.2 <- summary(summary.df[which(summary.df$Group == "Healthy"),])
write.csv(summary.0, "C:/Users/rpaul/Projects/suPAR/summary0.csv")
write.csv(summary.1, "C:/Users/rpaul/Projects/suPAR/summary1.csv")
write.csv(summary.2, "C:/Users/rpaul/Projects/suPAR/summary2.csv")

### Data is highly skewed -> log-transform (except suPAR)
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4120293/
### Important: analyses will be transformed on transformed data, therefore they have to be
# interpreted VERY carefully. The transformation is necessary to ensure that the parametric assumptions for the
# analysis methods hold!
suPAR.table.long$log.value <- ifelse(suPAR.table.long$Var == "suPAR", suPAR.table.long$Value,log(suPAR.table.long$Value))

### log-Histograms
ggplot(data = hist.df3, aes(x = log.value,fill = Group )) +
  geom_histogram(bins = 10, col = "black") +
  facet_grid(Group ~ Var, scales = "free") +
  labs(x = "log(value)") +
  theme_bw()

levels(suPAR.table.long$imputation) <- c(A="No Imputation", B="L/UDL+Random Term", C="Multiple Imputation")

### Boxplots + transparent Violin plot overlay
#ggplot(data = suPAR.table.long, aes(y = Value,x = Group, fill = Group  )) +
#  geom_boxplot(outlier.colour="black", outlier.shape=4,
#               outlier.size=2, notch=FALSE, width=0.1)+
#  geom_violin(alpha = 0.2)+
#  facet_grid(Var~imputation, scales = "free") +
#  theme_bw()

ggplot(data = suPAR.table.long[which(suPAR.table.long$Group != "Healthy"),], aes(y = log.value, x = Group, fill = Group  )) +
  geom_boxplot(outlier.colour="black", outlier.shape=4,
               outlier.size=2, notch=FALSE, width=0.1)+
  geom_violin(alpha = 0.2)+
  facet_grid(Var~imputation, scales = "free") +
  theme_bw()


### Check for correlation:
suPAR.table.A$suPAR <- as.numeric(suPAR.table.A$suPAR)
suPAR.table.A$C5a <- as.numeric(suPAR.table.A$C5a)
suPAR.table.A$C5b <- as.numeric(suPAR.table.A$C5b)
names(suPAR.table.A)[8] <- "C5b-9"
nums <- unlist(lapply(suPAR.table.A, is.numeric))
names(suPAR.table.A)[8] <- "C5b-9"
M  <- cor(suPAR.table.A[which(complete.cases(suPAR.table.A)),nums], method = "spearman")

# mat : is a matrix of data
# ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}
# matrix of the p-value of the correlation
p.mat <- cor.mtest(suPAR.table.A[which(complete.cases(suPAR.table.A)),nums], method = "spearman",exact = F)

### Correlation plot: correlation matrix as upper diagonal matrix w/o principal diagonal
# Colored cells have significant (< 0.05) correlation-test results
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(M, method="color", col=col(200),
         type="upper", order="hclust",
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat, sig.level = 0.05, insig = "blank",
         # hide correlation coefficient on the principal diagonal
         diag=FALSE
)

rm(col, nums, p.mat)

library(GGally)
my_fn <- function(data, mapping, method="lm", ...){
  p <- ggplot(data = data, mapping = mapping) +
    geom_point() +
    geom_smooth(method=method, ...)
  p
}

ggpairs(
  suPAR.table.A,
  aes(fill = Group, col = Group),
  columns = c(5:9),
  lower = list(continuous = 'points'),
  #axisLabels = "none",
  upper = list(continuous = 'blank')#,
  #scale_x_continuous(breaks=round(range(suPAR.table.A[,as.character(aes$x)])))
  #scale_y_continuous(trans = "log2")
)+
  theme_bw()+
  theme(legend.position = "bottom")+
  labs(col = "Group")

suPAR.table.complete$C5a <- as.numeric(suPAR.table.complete$C5a)
suPAR.table.complete$C5b <- as.numeric(suPAR.table.complete$C5b)
suPAR.log.A <- cbind(suPAR.table.complete[which(suPAR.table.complete$imputation == "A"),1:5],log(suPAR.table.complete[which(suPAR.table.complete$imputation == "A"),6:9]))
suPAR.log.A$suPAR <- as.numeric(suPAR.log.A$suPAR)
ggpairs(suPAR.log.A,
  aes(fill = Group, col = Group),
  columns = c(5:9),
  lower = list(continuous = 'points'),
  #axisLabels = "none",
  upper = list(continuous = 'blank')#,
  # scale_x_continuous(trans = "log2"),
  #scale_y_continuous(trans = "log2")
)+
  theme_bw()

#############################################################################################
#                                                                                           #
#                                   3. Analysis of Differences                              #
#                                                                                           #
#############################################################################################
### A: Wilcox pairwise
aab <- suPAR.table.complete[which(suPAR.table.complete$imputation == "A"),]
#pairwise.wilcox.test
attach(aab)
t1<- do.call("rbind.data.frame",pairwise.t.test(log(C3a), Group, p.adjust = "none"))
t2<- do.call("rbind.data.frame",pairwise.t.test(log(C5a), Group, p.adjust = "none"))
t3<- do.call("rbind.data.frame",pairwise.t.test(log(C5b), Group, p.adjust = "none"))
t4<- do.call("rbind.data.frame",pairwise.t.test(log(S100A8A9), Group, p.adjust = "none"))

w1<- do.call("rbind.data.frame",pairwise.wilcox.test(C3a, Group))
w2<- do.call("rbind.data.frame",pairwise.wilcox.test(C5a, Group))
w3<- do.call("rbind.data.frame",pairwise.wilcox.test(C5b, Group))
w4<- do.call("rbind.data.frame",pairwise.wilcox.test(S100A8A9, Group))
pairwise.w <- rbind(w1,w2,w3,w4)

pairwise.t <- rbind(t1,t2,t3,t4)
write.csv(pairwise.t, "C:/Users/rpaul/Projects/suPAR/paitwiset.csv")
write.csv(pairwise.w, "C:/Users/rpaul/Projects/suPAR/paitwisew.csv")

### Keep in Mind, that the comparisons are based on transformed data!

### Create Model
lm.C <- lm(log(S100A8A9) ~ Group + log(C3a) + log(C5b) + log(C5a) + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[which(suPAR.table.complete$imputation == "C"),])
lm.B <- lm(log(S100A8A9) ~ Group + log(C3a) + log(C5b) + log(C5a) + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[which(suPAR.table.complete$imputation == "B"),])
lm.B.cc <- lm(log(S100A8A9) ~ Group + log(C3a) + log(C5b) + log(C5a) + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[complete.cases(which(suPAR.table.complete$imputation == "B")),])
lm.A <- lm(log(S100A8A9) ~ 0+Group + (C3a) + (C5b) + (C5a) + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[which(suPAR.table.complete$imputation == "A"),])

df.A <- suPAR.table.complete[which(suPAR.table.complete$imputation == "A"),]
df.A[df.A$Group == ">6 suPAR","Group2"] <- 0
df.A[df.A$Group == "<6 suPAR","Group2"] <- 1
df.A[df.A$Group == "Healthy","Group2"]<- 2
df.A$Group3 <- as.factor(df.A$Group2) 
levels(df.A$Group3) <- c(">6 suPAR", "<6 suPAR", "Healthy")
df.A$Group3 <- relevel(df.A$Group3, ref = ">6 suPAR")
lm.A <- lm(log(S100A8A9) ~ 0+Group3 + (C3a) + (C5b) + (C5a) , data = df.A)
summary.df <- summary(lm.A)$coefficients

anova.df <- anova(lm.A) # Model with UDL +Random
write.csv(anova.df, "C:/Users/rpaul/Projects/suPAR/anova.csv")
write.csv(summary.df, "C:/Users/rpaul/Projects/suPAR/summary_anova.csv")

anova(lm.A) # Model CC
anova(lm.C) # Model Tobit
summary(lm.B.cc)

lm.A.cont <- lm(log(S100A8A9) ~ 0+log(as.numeric(suPAR)) + log(C3a) + log(C5b) + log(C5a), data = suPAR.table.complete[which(suPAR.table.complete$imputation == "A" & suPAR.table.complete$Group != "Healthy"),])
anova.df.cont <- anova(lm.A.cont)
summary.cont <- summary(lm.A.cont)$coefficients
write.csv(anova.df.cont, "C:/Users/rpaul/Projects/suPAR/anova_cont.csv")
write.csv(summary.cont, "C:/Users/rpaul/Projects/suPAR/summary_cont.csv")


lm.A <- lm(S100A8A9 ~ suPAR    , data = suPAR.table.A)
summary(lm.A)
AIC(lm.A)
BIC(lm.A)



### Plot regression
ggplot(data = suPAR.table.complete[which(suPAR.table.complete$imputation == "B"),], aes(x = suPAR,y = S100A8A9))+
  geom_point(aes( col = Group)) +
  geom_smooth(method = lm, formula = y ~ x)

### Zehui's approach: logistic regression
glm.df <- suPAR.table.A
glm.df$Group <-ifelse(glm.df$Group == ">6 suPAR",1,0)
glm.B <- glm(Group ~ 0 + C3a + C5b + C5a + as.factor(hemolysis) + as.factor(clumps) + S100A8A9, family = binomial(link = "logit"), data = glm.df)
summary(glm.B)


### Create Model with continuous suPAR
cont.lm.C <- lm(log(S100A8A9) ~ suPAR + C3a + (C5b) + (C5a) + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[which(suPAR.table.complete$imputation == "C"),])
cont.lm.B <- lm(log(S100A8A9) ~ suPAR + C3a + (C5b) + (C5a) + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[which(suPAR.table.complete$imputation == "B"),])
cont.lm.B.cc <- lm(log(S100A8A9) ~ suPAR + C3a + (C5b) + (C5a) + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[complete.cases(which(suPAR.table.complete$imputation == "B")),])
cont.lm.A <- lm(log(S100A8A9) ~ suPAR + C3a + (C5b) + C5a + as.factor(hemolysis) + as.factor(clumps), data = suPAR.table.complete[which(suPAR.table.complete$imputation == "A"),])

### Turns out: power increases slightly, when die independent variables are transformed as well
anova(cont.lm.C)
anova(cont.lm.B)
anova(cont.lm.B.cc)
anova(cont.lm.A)

suPAR.table.A$hemolysis <- as.factor(suPAR.table.A$hemolysis)
suPAR.table.A$clumps <- as.factor(suPAR.table.A$clumps)
names(suPAR.table.A)[8] <- "C5b"


df.aic <- suPAR.table.complete[which(suPAR.table.complete$imputation == "A"),]
### Iterative AIC analysis
#suPAR + C3a + (C5b) + (C5a)
AIC.variables <-  expand.grid(Var1 = c("Group", ""),
                             Var2 = c("C3a", ""),
                             Var3 = c("C5b", ""),
                            
                             Var4 = c("C5a", "")
                             )
AIC.variables$command <- paste(AIC.variables$Var1, AIC.variables$Var2, AIC.variables$Var3, AIC.variables$Var4  )
AIC.variables$command <- trimws(AIC.variables$command)
removeRS <- function(str) paste(rle(strsplit(str, "")[[1]])$values, collapse="")
AIC.variables$command <- gsub('([[:alpha:]])\\1+', '\\1',AIC.variables$command, fixed = T)
AIC.variables$command <- sapply(AIC.variables$command ,removeRS)
AIC.variables$command <- paste("lm(log(S100A8A9) ~ 0 +",gsub(" ", " + ",AIC.variables$command),", data =df.aic)")
# Drop empty row
AIC.variables <- AIC.variables[1:nrow(AIC.variables)-1,]

AIC.variables$AIC <- sapply(AIC.variables$command, function(cmd){
  lm <- eval(parse(text=cmd))
  return(AIC(lm))
})
AIC.variables$BIC <- sapply(AIC.variables$command, function(cmd){
  lm <- eval(parse(text=cmd))
  return(BIC(lm))
})

### Continuous Model
cont.AIC.variables <-  expand.grid(Var1 = c("as.numeric(suPAR)", ""),
                              Var2 = c("C3a", ""),
                              Var3 = c("C5b", ""),
                              
                              Var4 = c("C5a", "")
)
cont.AIC.variables$command <- paste(cont.AIC.variables$Var1, cont.AIC.variables$Var2, cont.AIC.variables$Var3, cont.AIC.variables$Var4 )
cont.AIC.variables$command <- trimws(cont.AIC.variables$command)
cont.AIC.variables$command <- gsub('([[:alpha:]])\\1+', '\\1',cont.AIC.variables$command, fixed = T)
cont.AIC.variables$command <- sapply(cont.AIC.variables$command ,removeRS)
cont.AIC.variables$command <- paste("lm(log(S100A8A9) ~",gsub(" ", " + ",cont.AIC.variables$command),", data = df.aic)")
# Drop empty row
cont.AIC.variables <- cont.AIC.variables[1:nrow(cont.AIC.variables)-1,]

cont.AIC.variables$AIC <- sapply(cont.AIC.variables$command, function(cmd){
  lm <- eval(parse(text=cmd))
  return(AIC(lm))
})
cont.AIC.variables$BIC <- sapply(cont.AIC.variables$command, function(cmd){
  lm <- eval(parse(text=cmd))
  return(BIC(lm))
})

# Best fitting seems to be achieved when factors are dropped, i.e. log(S100A8A9) ~ Group/suPAR + log(C3a) + log(C5b) + log(C5a))


### Use this for residual analysis
lm.fit <- eval(parse(text=AIC.variables[which(AIC.variables$AIC == min(AIC.variables$AIC)),]$command))
### Use this for residual analysis (cont)
cont.lm.fit <- eval(parse(text=cont.AIC.variables[which(cont.AIC.variables$AIC == min(cont.AIC.variables$AIC)),]$command))

res.df <- suPAR.table.A[which(complete.cases(suPAR.table.A)),]
#res.df$predicted <- predict(lm.fit)
#res.df$residuals <- residuals(lm.fit)
res.df$predicted <- predict(cont.lm.fit)
res.df$residuals <- residuals(cont.lm.fit)


temp1 <- res.df[,c(2,9:11)]
temp1$x <- res.df[,6]
temp1$iv <- "C3a"
temp2 <- res.df[,c(2,9:11)]
temp2$x <- res.df[,7]
temp2$iv <- "C5a"
temp3 <- res.df[,c(2,9:11)]
temp3$x <- res.df[,8]
temp3$iv <- "C5b-9"
temp4 <- res.df[,c(2,9:11)]
temp4$x <- res.df[,5]
temp4$iv <- "suPAR"

res.df.long <- rbind(temp1, temp2, temp3, temp4)
res.df.long$S100A8A9 <- log(res.df.long$S100A8A9)


ggplot(data = res.df.long, aes(x = x, y = S100A8A9, shape = Group)) +  # Note use of `x` here and next line
  geom_segment(aes(xend = x, yend = predicted), alpha = .2) +
  geom_point(aes(color = residuals, size = abs(residuals))) +
  #geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +
  guides(color = FALSE) +
  geom_point(aes(y = predicted), shape = 1) +
  labs(y = "log(S100A8A9)", x ="") +
  facet_grid(~ iv, scales = "free_x") +  # Split panels here by `iv`
  theme_bw() + guides(size=guide_legend(title="Residuals"))





ggplot(data = df.A, aes(y = C3a, x = Group, fill = Group))+
  geom_boxplot(outlier.colour="black", outlier.shape=4,
               outlier.size=2, width=0.55)  +
  scale_x_discrete(expand=c(0.8,0))+ theme_bw() + theme(legend.position = "none")
  

ggplot(data = suPAR.table.A, aes(y = C3a, col = Group))+
geom_point(aes(x = as.numeric(suPAR)))+
  labs(x = "suPAR")+
  geom_vline(xintercept = 6,lty="dashed")+
  theme_bw() + theme(legend.position = "bottom")

ggplot(data = df.A, aes(y = C5a, x = Group,fill = Group))+
  geom_boxplot(outlier.colour="black", outlier.shape=4,
               outlier.size=2, width=0.55)  +
  scale_x_discrete(expand=c(0.8,0))+ theme_bw() + theme(legend.position = "none")

ggplot(data = suPAR.table.A, aes(y = C5a, col = Group))+
  geom_point(aes(x = as.numeric(suPAR)))+
  labs(x = "suPAR")+
  geom_vline(xintercept = 6,lty="dashed")+
  theme_bw() + theme(legend.position = "bottom")

ggplot(data = df.A, aes(y = C5b, x = Group,fill = Group))+
  geom_boxplot(outlier.colour="black", outlier.shape=4,
               outlier.size=2, width=0.55)  +
  labs(y = "C5b-9")+
  scale_x_discrete(expand=c(0.8,0))+ theme_bw() + theme(legend.position = "none")

ggplot(data = suPAR.table.A, aes(y = C5b, col = Group))+
  geom_point(aes(x = as.numeric(suPAR)))+
  labs(x = "suPAR", y = "C5b-9")+
  geom_vline(xintercept = 6,lty="dashed")+
  theme_bw() + theme(legend.position = "bottom")


ggplot(data = df.A, aes(y = S100A8A9, x = Group,fill = Group))+
  geom_boxplot(outlier.colour="black", outlier.shape=4,
               outlier.size=2, width=0.55)  +
  scale_x_discrete(expand=c(0.8,0))+ theme_bw() + theme(legend.position = "none")

ggplot(data = suPAR.table.A, aes(y = S100A8A9, col = Group))+
  geom_point(aes(x = as.numeric(suPAR)))+
  labs(x = "suPAR")+
  geom_vline(xintercept = 6,lty="dashed")+
  theme_bw() + theme(legend.position = "bottom")
