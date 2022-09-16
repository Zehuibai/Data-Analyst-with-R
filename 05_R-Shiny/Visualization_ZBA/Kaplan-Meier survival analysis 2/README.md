---
title: "Survival Shiny App Documentation"
author: "Tom Belbin"
date: "May 22, 2015"
output: html_document
---
<br />

## Background
Head and neck cancer is an anatomically heterogeneous group of tumors arising most often from the oral cavity, oropharynx, and larynx. Conventional
treatments employ surgery, radiation therapy, and chemotherapy either alone or in combination. The 5-year survival rate for this disease has improved only marginally over the past decade. One of the reasons for the poor outcome in these patients is the highly invasive nature of these tumors; that is, they're propensity to invade local and regional lymph nodes.
<br /><br />
This Shiny App makes use of clinical data collected over the last 10 years from a cohort of 397 head and neck cancer patients undergoing treatment with curative intent at Montefiore Medical Center in Bronx, NY. It allows the user to subset the dataset by the specific anatomic site of the cancer, and then stratify patients by various clinical variables and compare survival outcomes. 
<br /><br />
For the purposes of illustrating how the code works, I will be using the example of the oral cavity cancer patients, plotting overall survival while stratifying patients based on their nodal status (node-positive vs node-negative).
<br /><br />

###1. Loading the data

The dataset for 397 patients is stored in a comma-separated-value (CSV) file called _HNpatientdata.csv_. To use the shiny app, Make sure that the _HNpatientdata.csv_ file is in the current working directory.
<br /><br />
The variables included in this dataset are:

* hn_id:            patient identifier
* age:              patient age
* AgeGroup:         patient age group (40-49, 50-59, 60-69, 70-79, 80-89)
* gender:           patient gender (Male, Female)
* race:             patient race (Black or African American, White)
* ethnicity:        patient ethnicity (non-Hispanic/Latino, Hispanic/Latino)
* tumor_site:       Larynx, Oral City, Oropharynx
* current_smoker:   patient most recent smoking status (Yes, No)
* current_drinker:  patient most recent drinking status (Yes, No)
* survival_status:  patient current death status (Live, Dead)
* survival_month:   time to death or last followup (months)
* DOD_status:       Died of their cancer (1=DEAD, 0=ALIVE)
* Overall_status:   Died of disease or other causes (1=DEAD, 0=ALIVE)
* tumor_stage:      Tumor pathological stage (I, II, III, IV)
* node_status:      Patient nodal status (Node-positive, Node-negative)
* treatment:        treatment modadlity (primary chemoradiation, primary surgery, both)

```{r load data}
patientdata<-read.csv(file="HNpatientdata.csv",header=TRUE)
str(patientdata)
dim(patientdata)
```

The data is in correct form and doesn't require any processing or tranformation.
<br /><br />

###2. Subsetting the data by anatomic site

Dataset is subsetted according to the site selected on the input widget. For example, if "Oral Cavity" is chosen, the code is as follows:

```{r subset data}
data<-subset(patientdata,tumor_site=="Oral Cavity")
dim(data)
```
The resulting dataset now has 126 oral cavity cancer patients but retains all 16 variables.
<br />

###3. Performing the survival calculation for each group

The example shown below is using the oral cavity subset of data calculated above (i.e. "data"), calculating overall survival curves stratifying patients based on nodal_status using the R survival package.


```{r survival calculations, warning=FALSE}
library(survival)
# Survival calculations using the survfit function in the R survival package
HN.surv <- survfit(Surv(survival_month, Overall_status) ~ node_status, data = data)
# Figure Legends for the Kaplan-Meier plot are defined
legend_IDs<-c("Node-negative","Node-positive")
# Difference between the two patient groups is tested using the survdiff function
HN.surv.sig <- survdiff(Surv(survival_month, Overall_status) ~ node_status, data = data)
```
<br />

###4. Output results for the survival analysis

The UI shows the output of calculations of summary statistics (the median age and number of patients used for the analysis), plots the Kaplan-Meier curves, and outputs the statistical analysis of the difference in survival between the two groups, along with a statistical p value for significance. The significance of the difference in survival by stratification group is calculated using using the G-_rho_ family of tests (Harrington and Fleming, 1982).

```{r output of calculations on subsetted data}
# Plot Kaplan-Meier curve for each patient group
plot(HN.surv, lty = 1,xlab="Months after Diagnosis",ylab="Proportion survived",col=c(1,2),mark.time=TRUE,main="Plot of patient survival by stratification group")
# Add figure legend
legend("bottomleft", legend_IDs, pch=1.2, lty=1, col=c(1,2),title="Stratification")
# Print out median age of patients used for the analysis
median(data$age)
# Print out number of patients used for the analysis
nrow(data)
# Print output of the statistical analysis
print(HN.surv.sig)
```
Based on these analysis from this specific example, oral cavity cancer patients classified as node-positive (tumor has invaded into local lymph nodes) have a significantly worse overall survival than oral cavity cancer patients classified as node-negative.
<br />

###5. Conclusions 

The survival Shiny app can instantly stratify and re-calculate survival statistics and plots without the need of any additional analysis or re-coding. Overall, the code is easily adapted to other datasets or variables for which you would like to stratify patient groups and look at their survival statistics.

Reference:
Harrington, D. P. and Fleming, T. R. (1982). A class of rank test procedures for censored survival data. _Biometrika_ 69, 553-566.
