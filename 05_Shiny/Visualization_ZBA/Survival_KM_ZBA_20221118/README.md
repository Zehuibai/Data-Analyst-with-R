# Instructions

The Shiny App is designed for survival analysis, which includes **sample
size calculation**, **data input and presentation**, **visualization**
of continuous and categorical variables, Non-Parametric Method for
survival analysis using the **Kaplan-Meier method**, and multiple
regression using **Cox Proportional Hazard Model** based on
Semiparametric method.

## Sample Size Calculation

The sample size is estimated to ensure at least 90% power of the
Log-Rank test to demonstrate that in the interim analysis and in the
final analysis MSS is significantly higher in patients classified as
“MelaGenix® Low Score” than in patients classified as “MelaGenix® High
Score”) for each AJCC substage: IIIA, IIIB, IIIC in the phase III
oncology study.

The sample size estimation is based on the following quantities and
assumptions:

1.  A family-wise error rate of 2.5% (one-sided), which means the global
    level of significance at interim and final will be set to 2.5%
    (one-sided, 0.83% for each substage) and will be split between
    interim and final analysis according to the Lan and DeMets
    alpha-spending function (Lan, & DeMets, 1983). For the family-wise
    error-rate, one-sided significance levels at interim and final are
    calculated to αinterim = 0.0222 and αfinal = 0.0120, respectively
2.  The interim analysis is based on approximately 83% of initially
    targeted subset events, the time information is 0.83
3.  A statistical power of the interim test in each of the substages
    (IIIA, IIIB, or IIIC) of 90% (at local alpha = 0.0074)
4.  A statistical power of the final test in each of the substages
    (IIIA, IIIB, or IIIC) of more than 90% (at final alpha = 0.0035)
5.  An assumed relative allocation of patients to “MelaGenix® Low Score”
    and “MelaGenix® High Score” groups and assumed 5-year MSS rates for
    each group under the alternative hypothesis for each substage. The
    survival assumptions are based on CMMR data which represents a
    middle ground in the range of data reported by Garbe et al. (2020)
    as shown in following Table
6.  An expected observation time of 5 years (corresponding to an accrual
    time of 0 and follow-up time of 5 years)
7.  A 5-year incidence of death for other cause of 5% (equivalent to
    survival of 95 %)
8.  The required number of MSS events and sample sizes were calculated
    according to method [Logrank Tests Accounting for Competing
    Risks](https://ncss-wpengine.netdna-ssl.com/wp-content/themes/ncss/pdf/Procedures/PASS/Logrank_Tests_Accounting_for_Competing_Risks.pdf)
    by Pintilie (2002) and Pintilie (2006)

| AJCC Substage | Fraction of patients in MelaGenix Low Score Group | Fraction of patients in MelaGenix Low Score Group | Estimated 5-year MSS in MelaGenix High Score Group | Estimated 5-year MSS in MelaGenix Low Score Group |
|-----|-----------------|------------------|-----------------|-----------------|
| IIIA          | 40%                                               | 60%                                               | 65.0%                                              | 90%                                               |
| IIIB          | 60%                                               | 40%                                               | 64.2%                                              | 90%                                               |
| IIIC          | 90%                                               | 10%                                               | 52.7%                                              | 85%                                               |

## Data Input

This tool can upload the corresponding csv file, which contains the
event variables necessary for survival analysis (0 for censored, 1 for
interested events, 2 for competing risks), and survival time variables

1.  Upload a CSV file (the defaut dataset is **“Dummy Data.csv”**, which
    does not involve any patient data, but a dummy data set used for
    testing)
2.  Choose `time` and `event` variables for survival analysis

## Data Visualization

This is a simple data visualization dashboard. For continuous variables,
histograms and box plots will be provided to explore the distribution of
the data, and for categorical variables, bar charts will be displayed.
In addition, the visualization will be presented for each subgroup and
compared according to the risk group population, i.e. Mela Genix high
score group and Mela Genix low score group, as the primary objective of
this study is to confirm that melanoma-specific survival (MSS ) is
higher in patients classified as MelaGenix® Low Score than in patients
classified as MelaGenix® High Score for AJCC substages: IIIA, IIIB and
IIIC.

## Survival Analysis

Survival analysis is provided by two aspects, the KM method based on
non-parametric method and the cox proportional hazard model based on
semi-parametric method, following illustrates the details.

### Kaplan-Meier Method

1.  Table: Providing a summary table of estimates of survival
    probability and cumulative hazard using the **Kaplan-Meier**
    methods. Check the box `Show Confidence Interval` to obtain
    two-sided 95% confidence intervals (the following CI types are
    available: linear, log, log-log).
2.  Plot: Drawing survival and cumulative hazard curves for the data.
    Moreover, plots can be customized by adding a risk table or a number
    of censored subjects bar plot. In the area on the left, you can
    compare survival curves or cumulative hazard curves of different
    strata by stratification, selecting either a discrete variable or a
    continuous variable with specified cutpoints.
3.  Test: Providing results of a collection of weighted logrank tests
    for comparing survival distributions for two or more independent
    groups. Log Rank Test is used for this study. For more information
    of other method, see
    [`survMisc::comp`](https://www.rdocumentation.org/packages/survMisc/versions/0.5.5/topics/comp).

### Cox Proportional Hazard Model

Single or multiple cox proportional regression can be performed by
selecting one or more covariates in the options bar on the right, the
result provides a summary table of coefficient and hazard ratio
estimates, standard errors, etc. Also calculating the log-likelihood and
AIC of the model that can be used in model selection.
